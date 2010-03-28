package away3dlite.builders{	import away3dlite.animators.BonesAnimator;	import away3dlite.animators.MovieMesh;	import away3dlite.animators.bones.Bone;	import away3dlite.animators.frames.Frame;	import away3dlite.arcane;	import away3dlite.containers.ObjectContainer3D;	import away3dlite.core.base.Mesh;	import away3dlite.core.base.Object3D;	import away3dlite.core.utils.Debug;	import away3dlite.loaders.MD2;	import away3dlite.loaders.data.AnimationData;	import away3dlite.materials.BitmapMaterial;	import flash.geom.Vector3D;	import flash.utils.ByteArray;	import flash.utils.Endian;	use namespace arcane;	public class MD2Builder extends MD2	{		public function MD2Builder()		{			super();		}		private function leadingZero(source:*, length:Number = 2):String		{			if (isNaN(Number(source)))				return source;			source = String(source)			while (source.length < length)				source = "0" + source;			return source;		}		public function convert(object3D:Object3D, animationDatas:Vector.<AnimationData> = null, animationName:String = "default"):Vector.<MovieMesh>		{			var _meshes:Vector.<MovieMesh> = new Vector.<MovieMesh>();			var _outMesh:MovieMesh;			_materialLibrary = object3D.materialLibrary;			if (object3D.animationLibrary)			{				// DAE				var _bonesAnimator:BonesAnimator;				try				{					_bonesAnimator = object3D.animationLibrary.getAnimation(animationName).animation as BonesAnimator;				}				catch (e:*)				{					Debug.warning("No Animation.");				}				for each (var _inMesh:Mesh in ObjectContainer3D(object3D).children)				{					if (_inMesh is Bone)						continue;					// init					_outMesh = new MovieMesh();					_outMesh.name = _inMesh.name;					_outMesh._vertices.fixed = false;					_outMesh._uvtData.fixed = false;					_outMesh._indices.fixed = false;					_outMesh._faceLengths.fixed = false;					// convert animation					convertFrame(_outMesh, _inMesh, _bonesAnimator, animationDatas);					// material					if (_inMesh.material)						_outMesh.material = _inMesh.material;					// build					_outMesh.buildFaces();					// group it					_meshes.push(_outMesh);				}			}			else			{				// MD2				_outMesh = object3D as MovieMesh;			}			_mesh = _outMesh;			return _meshes;		}		/** @private */		private function convertFrame(_outMesh:MovieMesh, _inMesh:Mesh, _bonesAnimator:BonesAnimator = null, animationDatas:Vector.<AnimationData> = null):void		{			// init			_outMesh._vertices = _inMesh._vertices.concat();			_outMesh._uvtData = _inMesh._uvtData.concat();			_outMesh._indices = _inMesh._indices.concat();			_outMesh._faceLengths = _inMesh._faceLengths.concat();			// TODO : mesh in animated mesh need only 1 frame			// single frame			if (!_bonesAnimator && !animationDatas)			{				num_frames = 1;				_outMesh.addFrame(new Frame("frame000", _inMesh._vertices.concat()));				return;			}			var _length:Number = _bonesAnimator.length;			var _step:Number = _outMesh.fps / 1000;			var i:Number;			var _labelIndex:int = 0;			var _frameIndex:int = 0;			var _animationData:AnimationData;			num_frames = _length / _step;			if (!animationDatas)			{				_animationData = new AnimationData();				_animationData.name = "frame";				_animationData.start = 0;				_animationData.end = num_frames;				animationDatas = Vector.<AnimationData>([_animationData]);			}			for (i = 0; i < _length; i += _step)			{				_bonesAnimator.update(i);				_animationData = animationDatas[_labelIndex] as AnimationData;				var _name:String = _animationData.name + leadingZero(_frameIndex++, 3);				var _frame:Frame = new Frame(_name, _inMesh._vertices.concat());				_outMesh.addFrame(_frame);				if (i > _animationData.end * _step)				{					if (++_labelIndex > animationDatas.length - 1)						_labelIndex = animationDatas.length - 1;					_frameIndex = 0;				}			}		}		public function getMD2(mesh:MovieMesh = null):ByteArray		{			if (!mesh)				mesh = _mesh;			md2 = new ByteArray();			var a:int, b:int, c:int, ta:int, tb:int, tc:int, i1:int, i2:int, i3:int;			var i:int, uvs:Array = [];			md2.position = 0;			// Make sure to have this in Little Endian or you will hate you life.			md2.endian = Endian.LITTLE_ENDIAN;			// make sure we have default material			material = material || new BitmapMaterial;			// Write the header to make it valid MD2 file			writeMD2Header(mesh, md2);			// UV coordinates			/* offset texture coordinate data */			md2.position = offset_st;			var _uvtData:Vector.<Number> = mesh._uvtData;			for (i = 0; i < _uvtData.length; i += 3)			{				md2.writeShort(skinwidth * _uvtData[i + 0]);				md2.writeShort(skinheight * _uvtData[i + 1]);			}			// faces			ta = 0;			tb = 1;			tc = 2;			md2.position = offset_tris;			for (i = 0; i < num_tris; i++)			{				i1 = i * 3 + 0;				i2 = i * 3 + 1;				i3 = i * 3 + 2;				//collect indices				a = mesh._indices[i1];				b = mesh._indices[i2];				c = mesh._indices[i3];				md2.writeShort(c);				md2.writeShort(b);				md2.writeShort(a);				//collect uvData 				uvs[ta * 2 + 0] = _uvtData[i1 * 3 + 0];				uvs[ta * 2 + 1] = _uvtData[i1 * 3 + 1];				uvs[tb * 2 + 0] = _uvtData[i2 * 3 + 0];				uvs[tb * 2 + 1] = _uvtData[i2 * 3 + 1];				uvs[tc * 2 + 0] = _uvtData[i3 * 3 + 0];				uvs[tc * 2 + 1] = _uvtData[i3 * 3 + 1];				md2.writeShort(tc);				md2.writeShort(tb);				md2.writeShort(ta);				ta += 3;				tb += 3;				tc += 3;			}			md2.position = offset_frames;			writeFrames(mesh, md2);			return md2;		}		private function writeFrames(mesh:MovieMesh, data:ByteArray):void		{			if (!mesh)				mesh = _mesh;			var sx:Number, sy:Number, sz:Number;			var tx:Number, ty:Number, tz:Number;			var fvertices:Vector.<Number>, tvertices:Vector.<Number>;			var frame:Frame;			var i:int, j:int, k:int, char:int, _frameNum:int;			for (i = 0; i < num_frames; i++)			{				frame = mesh.frames[i];				tvertices = new Vector.<Number>(num_vertices * 3, true);				fvertices = frame.vertices;				for (j = 0; j < num_tris * 3; j++)				{					//collect min/max for scale					minX = (fvertices[j * 3 + 0] < minX) ? fvertices[j * 3 + 0] : minX;					minY = (fvertices[j * 3 + 1] < minY) ? fvertices[j * 3 + 1] : minY;					minZ = (fvertices[j * 3 + 2] < minZ) ? fvertices[j * 3 + 2] : minZ;					maxX = (fvertices[j * 3 + 0] > maxX) ? fvertices[j * 3 + 0] : maxX;					maxY = (fvertices[j * 3 + 1] > maxY) ? fvertices[j * 3 + 1] : maxY;					maxZ = (fvertices[j * 3 + 2] > maxZ) ? fvertices[j * 3 + 2] : maxZ;				}				var _vmin:Vector3D = new Vector3D(minX, minY, minZ);				var _vmax:Vector3D = new Vector3D(maxX, maxY, maxZ);				var _scale:Vector3D = _vmax.clone();				_scale.decrementBy(_vmin);				_scale.scaleBy(1 / 255);				// scale				data.writeFloat(sx = _scale.x);				data.writeFloat(sy = _scale.y);				data.writeFloat(sz = _scale.z);				// translate				data.writeFloat(tx = _vmin.x);				data.writeFloat(ty = _vmin.y);				data.writeFloat(tz = _vmin.z);				// frame name				var _position:Number = data.position;				data.writeUTFBytes(frame.name);				data.position = _position + 16;				// read vertices				for (j = 0; j < num_tris * 3; j++)				{					tvertices[mesh._indices[j] * 3 + 0] = fvertices[j * 3 + 0];					tvertices[mesh._indices[j] * 3 + 1] = fvertices[j * 3 + 1];					tvertices[mesh._indices[j] * 3 + 2] = fvertices[j * 3 + 2];				}				// Note, the extra data.position++ in the for loop is there 				// to skip over a byte that holds the "vertex normal index"				var _a:Number, _b:Number, _c:Number;				k = 0;				for (j = 0; j < num_vertices; j++)				{					_a = tvertices[int(k++)];					_a = _a - tx;					_a = _a / sx;					_b = tvertices[int(k++)];					_b = _b - ty;					_b = _b / sy;					_c = tvertices[int(k++)];					_c = _c - tz;					_c = _c / sz;					data.writeByte(_a);					data.writeByte(_b);					data.writeByte(_c);					data.position++;				}			}		}		private function writeMD2Header(mesh:MovieMesh, data:ByteArray):void		{			if (!mesh)				mesh = _mesh;			//CONST//ident 			data.writeInt(844121161);			//CONST//version			data.writeInt(8);			//skinwidth 			data.writeInt(skinwidth = BitmapMaterial(material).width);			//skinheight 			data.writeInt(skinheight = BitmapMaterial(material).height);			//framesize 			//vertnum = model.framelist[1].vlist.count			//framesize = 40+(4*vertnum)			num_vertices = mesh._vertices.length / 3;			data.writeInt(framesize = 40 + 4 * num_vertices);			//TODO:get from mat lib			//num_skins 			data.writeInt(num_skins = 1);			//num_vertices 			data.writeInt(num_vertices);			//num_st /* number of texture coordinates */			data.writeInt(num_st = mesh.faces.length * 3);			//num_tris 			data.writeInt(num_tris = mesh.faces.length);			//CONST//num_glcmds 			data.writeInt(num_glcmds = 0);			//num_frames 			data.writeInt(num_frames);			//CONST//offset_skins = headersize			data.writeInt(offset_skins = 0x44);			//offset_st /* offset texture coordinate data */			//offset_st = offsetskins + (skinnum*64)			data.writeInt(offset_st = offset_skins + num_skins * 64);			//offsettris = offset_st + (texnum*texsize)			data.writeInt(offset_tris = offset_st + num_st * 4);			// offsetframes = offsettris + (trinum*trisize)			data.writeInt(offset_frames = offset_tris + num_tris * 12);			// offsetgl = offsetframes + (framenum*framesize)			// framesize = 40+(4*vertnum)			data.writeInt(offset_glcmds = offset_frames + num_frames * framesize);			// offsetend = offsetgl + (glnum*4)			data.writeInt(offset_end = offset_glcmds + num_glcmds * 4);			// texture //TODO:multi-texture?			data.position = 0x44;			data.writeUTFBytes(mesh.name);		}	}}