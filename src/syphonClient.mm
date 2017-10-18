/*
 syphonClient.mm
 Cinder Syphon Implementation
 
 Created by astellato on 2/6/11
 
 Copyright 2011 astellato, bangnoise (Tom Butterworth) & vade (Anton Marini).
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "cinder/gl/gl.h"
#import "SyphonNameboundClient.h"
#import "syphonClient.h"

syphonClient::syphonClient()
{
  mClient = [[SyphonNameboundClient alloc] init];
}

syphonClient::~syphonClient()
{
  [[(SyphonNameboundClient *)mClient client] stop];
  if ( mTex ) {
    unbind();
  }
  [(SyphonNameboundClient *)mClient release];
  mClient = nil;
}

void syphonClient::set(syphonServerDescription _server){
  set(_server.serverName, _server.appName);
}

void syphonClient::set(std::string _serverName, std::string _appName){
  setServerName(_serverName);
  setApplicationName(_appName);
}

void syphonClient::setApplicationName(std::string _appName)
{
  NSString *name = [NSString stringWithUTF8String:_appName.c_str()];
  [(SyphonNameboundClient *)mClient setAppName:name];
}

void syphonClient::setServerName(std::string _serverName)
{
  NSString *name = [NSString stringWithUTF8String:_serverName.c_str()];
  
  if ([name length] == 0)
    name = nil;
  
  [(SyphonNameboundClient*)mClient setName:name];
}

ci::gl::TextureRef& syphonClient::getTexture() {
  if ( mTex ) {
    unbind();
  }
  bind();
  return mTex;
}

std::string syphonClient::getApplicationName(){
  return std::string( [(SyphonNameboundClient *)mClient appName].UTF8String );
}

std::string syphonClient::getServerName(){
  return std::string( [(SyphonNameboundClient *)mClient name].UTF8String );
}

void syphonClient::bind()
{
  [(SyphonNameboundClient*)mClient lockClient];
  
  auto client = [(SyphonNameboundClient*)mClient client];
  
  auto latestImage = [[client newFrameImageForContext:CGLGetCurrentContext()] autorelease];
  auto texSize = [(SyphonImage *)latestImage textureSize];
  auto m_id = [(SyphonImage *)latestImage textureName];
  
  mTex = ci::gl::Texture::create(GL_TEXTURE_RECTANGLE_ARB, m_id,
                                 texSize.width, texSize.height, true);
  mTex->bind();
}

void syphonClient::unbind()
{
  mTex->unbind();
  [(SyphonNameboundClient*)mClient unlockClient];
}
