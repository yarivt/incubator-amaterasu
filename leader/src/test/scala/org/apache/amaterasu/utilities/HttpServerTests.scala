/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.amaterasu.utilities


import java.io.File

import org.scalatest.{FlatSpec, Matchers}


class HttpServerTests extends FlatSpec with Matchers {

  // this is an ugly hack, getClass.getResource("/").getPath should have worked but
  // stopped working when we moved to gradle :(
  val resources: String = new File(getClass.getResource("/simple-maki.yml").getPath).getParent

  //  "Jetty Web server" should "start HTTP server, serve content and stop successfully" in {
  //
  //    var data = ""
  //    try {
  //      HttpServer.start("8000", resources)
  //      val html = Source.fromURL("http://localhost:8000/jetty-test-data.txt")
  //      data = html.mkString
  //    }
  //    finally {
  //      HttpServer.stop()
  //    }
  //    data should equal("This is a test file to download from Jetty webserver")
  //  }

//  "Jetty File server with '/' as root" should "start HTTP server, serve content and stop successfully" in {
//
//    var urlCount: Int = 0
//    println("resource location" + resources)
//    try {
//      HttpServer.start("8000", resources)
//      val urls = HttpServer.getFilesInDirectory("127.0.0.1", "8000", "dist")
//      urls.foreach(println)
//      urlCount = urls.length
//    } catch {
//      case e: Exception => println(s"++++>> ${e.getMessage}")
//    }
//    finally {
//      HttpServer.stop()
//    }
//    urlCount should equal(2)
//  }
//
//  "Jetty File server with 'dist' as root" should "start HTTP server, serve content and stop successfully" in {
//    var data = ""
//    var urlCount: Int = 0
//    println("resource location" + resources)
//    try {
//      HttpServer.start("8000", resources + "/dist")
//      val urls = HttpServer.getFilesInDirectory("localhost", "8000", "")
//      urls.foreach(println)
//      urlCount = urls.length
//    }
//    finally {
//      HttpServer.stop()
//    }
//    urlCount should equal(2)
//  }
}
