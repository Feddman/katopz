﻿/*
   CASA Lib for ActionScript 3.0
   Copyright (c) 2010, Aaron Clinger & Contributors of CASA Lib
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:

   - Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.

   - Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

   - Neither the name of the CASA Lib nor the names of its contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.
 */
package com.sleepydesign.collection.iterators
{
	import com.sleepydesign.collection.List;

	[Event(name="change", type="flash.events.Event")]

	/**
	 * @author Jon Adams
	 * @version 09/22/10
	 */
	public class ListIterator extends Iterator
	{

		/**
		 * Creates a new ListIterator;
		 *
		 * @param list The List to be iterated over.
		 * @param index The position of iteration.
		 * @param isLooping: Indicates if the Iterator returns to the begining from the end and vice versa.
		 */
		public function ListIterator(list:List, index:int = -1, loop:Boolean = false)
		{
			super(list, index, loop);
		}

		/**
		 * Retrieves the target and casts it as a List.
		 */
		public function get list():List
		{
			return target as List;
		}

		/**
		 * Retrieves the number of elements in the List.
		 */
		override public function getLength():uint
		{
			return list.size;
		}

		/**
		 * Retrieves the current element.
		 */
		override public function get current():*
		{
			return list.getItemAt(currentIndex);
		}
	}
}
