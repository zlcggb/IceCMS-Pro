<template>
  <header class="app-header">
    <!-- 登录 -->
    <el-dialog class="dialogdeep" width="30%" top="30px" center title="" @close="closeDialog"
      :visible.sync="dialogFormVisible">
      <div v-if="IsRegister && forgotPassword == false" class="box">
        <a> <img class="close-icon"
            src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAHhlWElmTU0AKgAAAAgABAEaAAUAAAABAAAAPgEbAAUAAAABAAAARgEoAAMAAAABAAIAAIdpAAQAAAABAAAATgAAAAAAAACQAAAAAQAAAJAAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAAACCgAwAEAAAAAQAAACAAAAAAfgvaUgAAAAlwSFlzAAAWJQAAFiUBSVIk8AAAAalJREFUWAntlr9OwzAQxm2XAV4DIfEQTFHE2p2B5+hSiQ5d+jh0BKlZUJ6i8BxUUBt/up5kOU7iM38W4sWxc3ffz2dfYqWm9t8zoOME7HYv1859Lo3Re6Xspqqq99hGMm6a5lwps7DWXSl1XNV1/Rr6n4UDerYPWus755TS2tz4APNSiLZtLw6Hj0cf69bHVM7NIHEfappwgGfn3BvPwdHTb2kVPJvXw4fF2YOyyiPqOwDG2LWHfWazEohT2rfkS5Eopt1wXO47ZwAvBgKMbofUNwlQCiEVh04vgBSiRHwUIBeiVDwLYAwC71EpiQM3el7gObgFMODWv0qULsqV2um0Z4nDIxsAxikIzHOTisNPBACHPogSccTrfIgw+ZdNlIG+1TNwSRayM9Aj/kSihFDy2c7KQEqcV0vSv1iGQ+L8m86x4W2K+8EMSAJLbEOIXoCSgCU+SYCSQLwqqW8HQBqAhcNeEiNRhmbxnW87QOhw2nlcotaaZQiK5w4A3V7JjEuNT3vsPDROQfiL6WXsk7gVH1e4vf7EtRwQfjt8JuharvVsHQNM4ykDX94FYhBKOJraAAAAAElFTkSuQmCC"
            @click="closeDialog"></a>

        <div class="login-logo">
        <div v-if="setting.sitLogo">
          <img height="40" width="40" :src="setting.sitLogo" />
        </div>
        <div v-else>
          <img height="40" width="40" src="../../static/image/logo.svg" />
        </div>
        </div>
        <div class="login-title">
          <!-- <span><b>登录可享更多权益</b></span> -->
        </div>
        <div class="login-box-tabs">
          <div class="login-box-tabs-items">
            <span id="last-login" class="last-login-way"
              style="display: block; left: 0px; max-width: 120px; width: 120px;">
              扫码登录更方便
            </span>
            <span :class="{ 'tabs-item': true, 'tabs-active': activeTab === 'wechat' }"
              @click="setActiveTab('wechat')">微信登录</span>
            <span :class="{ 'tabs-item': true, 'tabs-active': activeTab === 'phone' }"
              @click="setActiveTab('phone')">手机号登录</span>
            <span :class="{ 'tabs-item': true, 'tabs-active': activeTab === 'password' }"
              @click="setActiveTab('password')">密码登录</span>
          </div>
          <div class="login-box-tabs-main">
            <div v-if="activeTab === 'wechat'" style="display: flex;
              flex-wrap: nowrap;
              align-content: center;
              justify-content: center;
              flex-direction: column;
              align-items: center;">
              <!-- 微信登录内容 -->
              <!-- <qriously :value="qrCodeValue" :size="200"></qriously> -->
              <div v-if="qrCodeValue">
                <img :src="qrCodeValue" alt="QR Code" style="width: 200px; height: 200px;">
              </div>
              <div v-else class="loading-container">
                <div class="spinner"></div>
              </div>
              <div data-v-71b618bc="" class="wechat-title">打开微信扫一扫，快速登录/注册</div>
            </div>
            <div v-if="activeTab === 'phone'">
              <!-- 手机号登录内容 -->
              <el-form ref="phoneLoginForm" :model="phoneLoginForm" :rules="phoneLoginRules" class="login-form"
                auto-complete="on" label-position="left">
                <el-form-item prop="phone">
                  <el-input ref="phone" v-model="phoneLoginForm.phone" placeholder="手机号" name="phone" type="text"
                    tabindex="1" auto-complete="on" />
                </el-form-item>
                <el-form-item prop="code">
                  <el-input class="check-code-box" v-model="phoneLoginForm.code" placeholder="请输入验证码" name="code"
                    type="text" tabindex="2" auto-complete="on">
                    <el-button :disabled="codeButtonDisabled" size="small" slot="append" @click="sendCode">获取验证码
                      <span v-if="codeCd">({{ long }})</span>
                    </el-button>
                  </el-input>
                </el-form-item>
                <el-button :loading="loading" type="primary" style="width: 100%; margin-bottom: 30px"
                  @click.native.prevent="handlePhoneLogin">登录</el-button>
                <div class="ss-login_statement">
                  <span>登录注册即代表同意</span>
                  <a href="/Protocol">
                    <a target="_blank">用户协议</a></a><span>及</span>
                  <a href="/Privacy">
                    <a target="_blank">隐私条款</a></a>
                </div>
                <div class="line"></div>
              </el-form>
            </div>
            <div v-if="activeTab === 'password'">
              <!-- 密码登录内容 -->
              <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form" auto-complete="on"
                label-position="left">
                <el-form-item prop="username">
                  <el-input ref="username" v-model="loginForm.username" placeholder="用户名或邮箱" name="username" type="text"
                    tabindex="1" auto-complete="on" />
                </el-form-item>

                <el-form-item prop="password">
                  <el-input :key="passwordType" ref="password" v-model="loginForm.password" :type="passwordType"
                    placeholder="密码" name="password" tabindex="2" auto-complete="on"
                    @keyup.enter.native="handleLogin" />

                  <!-- <span class="show-pwd" @click="showPwd">
          <svg-icon
            :icon-class="passwordType === 'password' ? 'eye' : 'eye-open'"
          />
         </span> -->
                </el-form-item>

                <el-button :loading="loading" type="primary" style="width: 100%; margin-bottom: 30px"
                  @click.native.prevent="handleLogin">登录</el-button>
                <!-- 找回密码链接和提示文字 -->
                <div class="forgot-password" style="text-align: left; margin-bottom: 30px;">
                  <span style="color: #666; font-size: 12px; margin-right: 5px;">
                    忘记密码？
                  </span>
                  <a @click="handleforgotPassword" target="_blank" style="color: #409EFF;">找回密码</a>
                </div>
                <div class="ss-login_statement">
                  <span>登录注册即代表同意</span>
                  <a href="/Protocol">
                    <a target="_blank">用户协议</a></a><span>及</span>
                  <a href="/Privacy">
                    <a target="_blank">隐私条款</a></a>
                </div>
                <div class="line"></div>

              </el-form>
            </div>
          </div>
        </div>
        <!-- <label class="login-form-item" style="display: none"
          ><input
            type="text"
            name="nickname"
            tabindex="1"
            spellcheck="false"
            autocomplete="off"
            class=""
          />
          <span><b>可爱的昵称</b></span></label
        > -->
        <div class="footer">
          <p class="text-align-center">
            其他登录方式
            <a style="text-decoration: none">或</a>
            <a @click="handleRegister">
              <a class="text-align-center">立即注册</a></a>
          </p>
          <div class="other-login">
            <button class="btn-login circle weixin">
              <img class="qqloginsvg" src="../../static/image/qq.png" />
            </button>
            <button class="btn-login circle weibo">
              <img class="qqloginsvg" src="../../static/image/weibo.png" />
            </button>
            <button class="btn-login circle weibo">
              <img class="qqloginsvg" src="../../static/image/github.png" />
            </button>
          </div>
        </div>

        <div class="tips">
          <span style="margin-right: 20px"></span>
          <span> </span>
        </div>
      </div>
      <div v-if="!IsRegister && forgotPassword == false" class="box">
        <a> <img class="close-icon"
            src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAHhlWElmTU0AKgAAAAgABAEaAAUAAAABAAAAPgEbAAUAAAABAAAARgEoAAMAAAABAAIAAIdpAAQAAAABAAAATgAAAAAAAACQAAAAAQAAAJAAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAAACCgAwAEAAAAAQAAACAAAAAAfgvaUgAAAAlwSFlzAAAWJQAAFiUBSVIk8AAAAalJREFUWAntlr9OwzAQxm2XAV4DIfEQTFHE2p2B5+hSiQ5d+jh0BKlZUJ6i8BxUUBt/up5kOU7iM38W4sWxc3ffz2dfYqWm9t8zoOME7HYv1859Lo3Re6Xspqqq99hGMm6a5lwps7DWXSl1XNV1/Rr6n4UDerYPWus755TS2tz4APNSiLZtLw6Hj0cf69bHVM7NIHEfappwgGfn3BvPwdHTb2kVPJvXw4fF2YOyyiPqOwDG2LWHfWazEohT2rfkS5Eopt1wXO47ZwAvBgKMbofUNwlQCiEVh04vgBSiRHwUIBeiVDwLYAwC71EpiQM3el7gObgFMODWv0qULsqV2um0Z4nDIxsAxikIzHOTisNPBACHPogSccTrfIgw+ZdNlIG+1TNwSRayM9Aj/kSihFDy2c7KQEqcV0vSv1iGQ+L8m86x4W2K+8EMSAJLbEOIXoCSgCU+SYCSQLwqqW8HQBqAhcNeEiNRhmbxnW87QOhw2nlcotaaZQiK5w4A3V7JjEuNT3vsPDROQfiL6WXsk7gVH1e4vf7EtRwQfjt8JuharvVsHQNM4ykDX94FYhBKOJraAAAAAElFTkSuQmCC"
            @click="closeDialog"></a>

        <div class="login-logo">
          <div v-if="setting.sitLogo">
          <img height="40" width="40" :src="setting.sitLogo" />
        </div>
        <div v-else>
          <img height="40" width="40" src="../../static/image/logo.svg" />
        </div>          
        </div>
        <div class="register-text">
          <span><b>注册</b></span>
        </div>
        <el-form ref="emailRegisterForm" :model="emailRegisterForm" :rules="emailRegisterRules" class="login-form"
          auto-complete="on" label-position="left">
          <el-form-item prop="email">
            <el-input ref="email" v-model="emailRegisterForm.email" placeholder="邮箱" name="phone" type="text"
              tabindex="1" auto-complete="on" />
          </el-form-item>
          <el-form-item prop="password">
            <el-input ref="password" v-model="emailRegisterForm.password" placeholder="密码" name="phone" type="password"
              tabindex="1" auto-complete="on" />
          </el-form-item>
          <el-form-item prop="code">
            <el-input class="check-code-box" v-model="emailRegisterForm.code" placeholder="请输入验证码" name="code"
              type="text" tabindex="2" auto-complete="on">
              <el-button :disabled="codeButtonDisabled" size="small" slot="append" @click="RegistersendCode">获取验证码
                <span v-if="RegistercodeCd">({{ long }})</span>
              </el-button>
            </el-input>
          </el-form-item>


          <el-button :loading="loading" type="primary" style="width: 100%; margin-bottom: 30px"
            @click.native.prevent="handleEmailLogin">注册</el-button>
          <div class="ss-login_statement">
            <span>登录注册即代表同意</span>
            <a href="/Protocol">
              <a target="_blank">用户协议</a></a><span>及</span>
            <a href="/Privacy">
              <a target="_blank">隐私条款</a></a>
          </div>
          <div class="line"></div>
        </el-form>
        <div class="footer">
          <p class="text-align-center">
            已有账号？
            <a style="text-decoration: none"></a>
            <a @click="tohandleLogin">
              <a class="text-align-center">立即登录</a></a>
          </p>
          <div class="other-login">
            <button class="btn-login circle weixin">
              <img class="qqloginsvg" src="../../static/image/qq.png" />
            </button>
            <button class="btn-login circle weibo">
              <img class="qqloginsvg" src="../../static/image/weibo.png" />
            </button>
            <button class="btn-login circle weibo">
              <img class="qqloginsvg" src="../../static/image/github.png" />
            </button>
          </div>
        </div>

        <div class="tips">
          <span style="margin-right: 20px"></span>
          <span> </span>
        </div>
      </div>
      <div v-show="forgotPassword" class="box">
        <a> <img class="close-icon"
            src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAHhlWElmTU0AKgAAAAgABAEaAAUAAAABAAAAPgEbAAUAAAABAAAARgEoAAMAAAABAAIAAIdpAAQAAAABAAAATgAAAAAAAACQAAAAAQAAAJAAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAAACCgAwAEAAAAAQAAACAAAAAAfgvaUgAAAAlwSFlzAAAWJQAAFiUBSVIk8AAAAalJREFUWAntlr9OwzAQxm2XAV4DIfEQTFHE2p2B5+hSiQ5d+jh0BKlZUJ6i8BxUUBt/up5kOU7iM38W4sWxc3ffz2dfYqWm9t8zoOME7HYv1859Lo3Re6Xspqqq99hGMm6a5lwps7DWXSl1XNV1/Rr6n4UDerYPWus755TS2tz4APNSiLZtLw6Hj0cf69bHVM7NIHEfappwgGfn3BvPwdHTb2kVPJvXw4fF2YOyyiPqOwDG2LWHfWazEohT2rfkS5Eopt1wXO47ZwAvBgKMbofUNwlQCiEVh04vgBSiRHwUIBeiVDwLYAwC71EpiQM3el7gObgFMODWv0qULsqV2um0Z4nDIxsAxikIzHOTisNPBACHPogSccTrfIgw+ZdNlIG+1TNwSRayM9Aj/kSihFDy2c7KQEqcV0vSv1iGQ+L8m86x4W2K+8EMSAJLbEOIXoCSgCU+SYCSQLwqqW8HQBqAhcNeEiNRhmbxnW87QOhw2nlcotaaZQiK5w4A3V7JjEuNT3vsPDROQfiL6WXsk7gVH1e4vf7EtRwQfjt8JuharvVsHQNM4ykDX94FYhBKOJraAAAAAElFTkSuQmCC"
            @click="closeDialog"></a>

        <div class="login-logo">
          <img height="40" width="40" src="../../static/image/logo.svg" />
        </div>
        <div class="register-text">
          <span><b>找回密码</b></span>
        </div>
        <el-form ref="emailRegisterForm" :model="emailRegisterForm" :rules="emailRegisterRules" class="login-form"
          auto-complete="on" label-position="left">
          <el-form-item prop="email">
            <el-input ref="email" v-model="emailRegisterForm.email" placeholder="邮箱" name="phone" type="text"
              tabindex="1" auto-complete="on" />
          </el-form-item>
          <el-form-item prop="code">
            <el-input class="check-code-box" v-model="emailRegisterForm.code" placeholder="请输入验证码" name="code"
              type="text" tabindex="2" auto-complete="on">
              <el-button :disabled="codeButtonDisabled" size="small" slot="append" @click="RegistersendCode">获取验证码
                <span v-if="RegistercodeCd">({{ long }})</span>
              </el-button>
            </el-input>
          </el-form-item>
          <el-form-item prop="password">
            <el-input ref="password" v-model="emailRegisterForm.password" placeholder="密码" name="phone" type="password"
              tabindex="1" auto-complete="on" />
          </el-form-item>
          <el-form-item prop="password">
            <el-input ref="password" v-model="emailRegisterForm.password" placeholder="确认密码" name="phone"
              type="password" tabindex="1" auto-complete="on" />
          </el-form-item>



          <el-button :loading="loading" type="primary" style="width: 100%; margin-bottom: 30px"
            @click.native.prevent="handleEmailLogin">提交</el-button>
          <div class="ss-login_statement">
            <span>登录注册即代表同意</span>
            <a href="/Protocol">
              <a target="_blank">用户协议</a></a><span>及</span>
            <a href="/Privacy">
              <a target="_blank">隐私条款</a></a>
          </div>
          <div class="line"></div>
        </el-form>
        <div class="footer">
          <p class="text-align-center">
            已有账号？
            <a style="text-decoration: none"></a>
            <a @click="tohandleLogin">
              <a class="text-align-center">立即登录</a></a>
          </p>
          <div class="other-login">
            <button class="btn-login circle weixin">
              <img class="qqloginsvg" src="../../static/image/qq.png" />
            </button>
            <button class="btn-login circle weibo">
              <img class="qqloginsvg" src="../../static/image/weibo.png" />
            </button>
            <button class="btn-login circle weibo">
              <img class="qqloginsvg" src="../../static/image/github.png" />
            </button>
          </div>
        </div>

        <div class="tips">
          <span style="margin-right: 20px"></span>
          <span> </span>
        </div>
      </div>
      <el-form :model="form"> </el-form>
    </el-dialog>
    <div class="app-header-navbar white shadow-4 border-bottom pc-model">
      <div class="app-header-main">

        <a href="/" class="app-header-logo active" aria-current="page">
          <div v-if="setting.sitLogo">
            <img :src="setting.sitLogo" />
          </div>
          <div v-else> 
            <img src="../../static/image/logo.svg" />
          </div>
          <span class="ml-4">{{ setting.sitTitle }}</span>
        </a>
        <div class="app-header-nav nav">
          <nuxt-link target="_self" class="nav-link" :class="message1" aria-current="page" to="/">首页</nuxt-link>
          <nuxt-link target="_self" class="nav-link" :class="message2" to="/Alllist">资源</nuxt-link>
          <nuxt-link target="_self" class="nav-link" :class="message3" to="/allpost">文章</nuxt-link>
          <nuxt-link target="_self" class="nav-link" :class="message4" to="/class">分类</nuxt-link>
          <nuxt-link target="_self" class="nav-link" :class="message5" to="/planet">星球</nuxt-link>
        </div>
        <div class="app-header-search grid-list lazy-transition">
          <div id="autosuggest">
            <div role="combobox" aria-expanded="false" aria-haspopup="listbox"
              aria-owns="autosuggest-autosuggest__results">
              <el-input @keyup.native="keyup()" @focus="focus()" @blur="blur()" v-model="seachcontent" type="text"
                autocomplete="off" aria-autocomplete="list" aria-activedescendant=""
                aria-controls="autosuggest-autosuggest__results" id="autosuggest__input" placeholder="输入关键词搜索软件或文章…"
                value="" class="" />
            </div>
            <div class="popUp" v-show="searchshow" @mouseenter="enter" @mouseleave="leave">
              <div aria-labelledby="autosuggest" class="autosuggest__results">
                <div class="overflow-hidden">
                  <div class="d-flex align-items-center px-5">
                    <a @click="codeshows()" :class="{ 'active search-active': codeshow }"
                      class="flex flex-grow-1 text-center py-3 fs-16"><span class="fw-400">资源</span>
                      <span class="fs-12">({{ ResourceNumber }})</span></a>
                    <a @click="articleshows()" :class="{ 'active search-active': articleshow }"
                      class="flex flex-grow-1 text-center py-3 fs-16"><span class="">文章</span>
                      <span class="fs-12">({{ articleCount }})</span></a>
                  </div>
                </div>
                <ul role="listbox">
                  <div v-for="(item, id) in this.tempdata" :key="id">
                    <div v-if="item.status.includes('published')">
                      <a :to="howto + item.id">
                        <li role="option" data-suggestion-index="0" data-section-name="default"
                          id="autosuggest__results-item--0" class="autosuggest__results-item">
                          <a class="macwk-app white border-top"><span class="snow-dot"></span>
                            <span class="snow-dot"></span>
                            <span class="snow-dot"></span>
                            <span class="snow-dot"></span>
                            <span class="snow-dot"></span>
                            <span class="snow-dot"></span>
                            <span class="snow-dot"></span>
                            <div class="macwk-app__hover--content"></div>
                            <div class="macwk-app__header--icon">
                              <div class="macwk-app__header--icon--content"></div>
                              <img :src="item.thumb" lazy="loaded" />
                            </div>
                            <div class="macwk-app__body py-1">
                              <h5 class="macwk-app__body--title fs-14" style="
                                  display: -webkit-box;
                                  -webkit-box-orient: vertical;
                                  overflow: hidden;
                                  word-break: break-all;
                                  text-overflow: ellipsis;
                                  -webkit-line-clamp: 1;
                                ">
                                <span>{{ item.title }}</span>
                                <!-- <span

                            class="
                              macwk-app__body--title--version
                              text-muted
                              fs-14
                            "
                            ><span      class="mx-1">-</span
                            >1.0.1</span
                          > -->
                              </h5>
                              <p class="macwk-app__body--info" style="
                                  display: -webkit-box;
                                  -webkit-box-orient: vertical;
                                  overflow: hidden;
                                  word-break: break-all;
                                  text-overflow: ellipsis;
                                  -webkit-line-clamp: 1;
                                ">
                                <span>{{ item.intro }}</span>
                              </p>
                            </div>
                            <!---->
                            <div class="macwk-box__more fs-24">
                              <i class="light-icon-more icon-next-arrow"></i>
                            </div>
                          </a>
                        </li>
                      </a>
                    </div>
                  </div>
                </ul>
                <div>
                  <button class="
                      btn btn-block
                      border-top
                      no-radius
                      py-3
                      hover-primary
                      cursor-pointer
                      fs-14
                    ">
                    查看更多
                    <span class="fw-400"></span>
                    <!---->
                  </button>
                </div>
              </div>
            </div>

            <!---->
            <button class="btn search-to" @click="queryarticle()">
              <i class="icon-search"></i>
            </button>
            <div id="autosuggest-autosuggest__results" class="autosuggest__results-container">
              <!---->
            </div>
          </div>
        </div>
        <el-popover placement="top-start" width="" trigger="hover">
          <div class="">
            <div class="flex-col self-start group">
              <div class="self-start" style="display: flex; align-items: center; justify-content: center;">
                <div class="topic-avatars" style="margin-right: 8px;">
                  <el-avatar :src="user.profile"></el-avatar>
                </div>
                <span class="font-username text">{{ user.name }}</span>
              </div>
              <div class="flex-row self-stretch group_2">
                <div class="flex-row">
                  <span class="font_2">硬币：</span>
                  <span class="font_3">882</span>
                </div>
              </div>
            </div>
            <div class="flex-row justify-between items-start self-start group_1">
              <img class="image image_3"
                src="https://ide.code.fun/api/image?token=6716186338a7c10015881310&name=55167cb7355819bd03753c9bd6f25a6b.png" />
              <img class="image image_2"
                src="https://ide.code.fun/api/image?token=6716186338a7c10015881310&name=17866fe53ba884d3f24c5aef69da7a79.png" />
            </div>
            <div class="flex-col self-stretch group_3">
              <div class="flex-col items-start self-stretch group_4">
                <span class="text_4">当前成长10515，距离升级Lv.5 还需要285</span>
                <div class="flex-row justify-between equal-division mt-15">
                  <div class="flex-col items-center equal-division-item">
                    <span class="font">119</span>
                    <span class="font_3">关注</span>
                  </div>
                  <div class="flex-col items-center equal-division-item">
                    <span class="font">119</span>
                    <span class="font_3">粉丝</span>
                  </div>
                  <div class="flex-col items-center equal-division-item">
                    <span class="font">119</span>
                    <span class="font_3">动态</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="flex-col-bar self-start group_5">
            <div class="flex-row-bar items-center group_6 view-bar">
              <img class="image_4"
                src="https://ide.code.fun/api/image?token=6716186338a7c10015881310&name=775ab799af101d7db890b565a9a5a372.png" />
              <span class="ml-20 font_3">个人中心</span>
            </div>
            <div class="flex-row-bar group_6 view-bar">
              <img class="image_5"
                src="https://ide.code.fun/api/image?token=6716186338a7c10015881310&name=ed2744fa182c3ca2bd86f65c2ea25769.png" />
              <span class="ml-20 font_3">资源管理</span>
            </div>
            <div class="flex-row-bar view-bar">
              <img class="image_6"
                src="https://ide.code.fun/api/image?token=6716186338a7c10015881310&name=d2ff13cdd5319e666a93eba391bdaa70.png" />
              <span class="ml-18 font_3">个人收藏</span>
            </div>
            <div @click="loginout()" class="flex-row-bar items-center group_6 view-bar-2">
              <img class="image_7"
                src="https://ide.code.fun/api/image?token=6716186338a7c10015881310&name=98ae7ba00542b035ccb62ad4754089a4.png" />
              <span class="ml-18 font_3">退出登录</span>
            </div>
          </div>
          <div class="top-user-info-box-names">
            <!-- <div class="topic-header-lefts">
              <div class="topic-avatars">
                <el-avatar :src="user.profile"></el-avatar>
              </div>
              <div class="topic-names">
                <div>
                  <div class="topic-name-datas">
                    <a target="_blank"><b>{{ user.name }}</b></a>
              
                  </div>
                  <div class="topic-user-lvs">
                    <p>
                      <span class="user-vips"><i style="border-color: #ff8223"></i><b v-show="vipTrue"
                          style="color: #ff8223">会员</b></span>
                    </p>
                    <p>
                      <span class="user-lvs"><b>荣誉用户</b><i>lv1</i></span>
                    </p>
                 
                  </div>
                </div>
              </div>
            </div> -->

            <!-- <div data-title="退出登录" @click="loginout()" class="login-outs user-tips">
              <a href="javascript:void(0)"><i class="el-icon-caret-left"></i></a>
            </div> -->
          </div>
          <!-- <div class="top-user-info-box-count">
                <p><span>文章</span> <b>0</b></p>
                <p><span>评论</span> <b>0</b></p>
                <p><span>关注</span> <b>0</b></p>
                <p><span>粉丝</span> <b>0</b></p>
                <a
                  href="https://www.zmki.cn/users/dCACBojqs"
                  target="_blank"
                  class="link-block"
                ></a>
              </div>
              <div class="user-w-gold">
                <div data-title="余额" class="user-money user-tips">
                  <a href="https://www.zmki.cn/gold" target="_blank"
                    ><i>￥</i>0.00</a
                  >
                </div>
                <div data-title="积分" class="user-credit user-tips">
                  <a href="https://www.zmki.cn/gold" target="_blank"
                    ><i class="b2font b2-coin-line"></i>20</a
                  >
                </div>
              </div>
              <div class="user-w-rw b2-radius">
                <div class="user-w-rw-bg" style="width: 0%"></div>
                <a
                  href="https://www.zmki.cn/task"
                  target="_blank"
                  class="link-block"
                  ><span>您已完成今天任务的<b>0%</b></span></a
                >
              </div> -->

          <!-- <ul>
              <li>
                <a href="https://www.zmki.cn/directmessage"
                  ><i class="b2font b2-mail-send-line"></i>
                  <p>
                    私信列表<span class="top-user-link-des">所有往来私信</span>
                  </p></a
                >
              </li>
              <li>
                <a href="https://www.zmki.cn/gold"
                  ><i class="b2font b2-bit-coin-line"></i>
                  <p>
                    财富管理<span class="top-user-link-des"
                      >余额、积分管理</span
                    >
                  </p></a
                >
              </li>
              <li>
                <a href="https://www.zmki.cn/distribution"
                  ><i class="b2font b2-share-line"></i>
                  <p>
                    推广中心<span class="top-user-link-des">推广有奖励</span>
                  </p>
                  <i class="menu-new">NEW</i></a
                >
              </li>
              <li>
                <a href="https://www.zmki.cn/task"
                  ><i class="b2font b2-task-line"></i>
                  <p>任务中心<span class="top-user-link-des">每日任务</span></p>
                  <i class="menu-new">NEW</i></a
                >
              </li>
              <li>
                <a href="https://www.zmki.cn/vips"
                  ><i class="b2font b2-vip-crown-2-line"></i>
                  <p>
                    成为会员<span class="top-user-link-des">购买付费会员</span>
                  </p></a
                >
              </li>
              <li>
                <a href="https://www.zmki.cn/verify"
                  ><i class="b2font b2-shield-user-line"></i>
                  <p>认证服务<span class="top-user-link-des">申请认证</span></p>
                  <i class="menu-new">NEW</i></a
                >
              </li>
              <li>
                <a href="https://www.zmki.cn/dark-room"
                  ><i class="b2font b2-skull-2-line"></i>
                  <p>
                    小黑屋<span class="top-user-link-des">关进小黑屋的人</span>
                  </p>
                  <i class="menu-new">NEW</i></a
                >
              </li>
              <li>
                <a href="https://www.zmki.cn/users/dCACBojqs/orders"
                  ><i class="b2font b2-file-list-2-line"></i>
                  <p>
                    我的订单<span class="top-user-link-des">查看我的订单</span>
                  </p></a
                >
              </li>
              <li>
                <a href="https://www.zmki.cn/users/dCACBojqs/settings"
                  ><i class="b2font b2-user-settings-line"></i>
                  <p>
                    我的设置<span class="top-user-link-des">编辑个人资料</span>
                  </p></a
                >
              </li>
              <li></li>
            </ul>
           -->
          <div slot="reference">
            <nuxt-link to="/userinfo">
              <div v-show="!userJudje" class="avatartext">
                <el-avatar :src="user.profile"></el-avatar>
                <span class="spans">{{ user.name }}</span>
              </div>
            </nuxt-link>
          </div>
        </el-popover>
        <a v-if="userJudje" class="actions" style="cursor: pointer">
          <div @click="showlogin()" class="app-header-user">
            <div class="login-button">
              <span class="logintext">登录/注册</span>
            </div>
          </div>
        </a>

        <div style="margin-left: 30px;">
          <div style="margin-left: 30px;">
            <div class="view-bar-black toggle-button" @click="toggleMode"
              style="position: relative; display: flex; align-items: center; justify-content: center;">
              <!-- 圆形边框的外层 div -->
              <!-- 白天模式图标 -->
              <div :class="['icon-wrapper', isDark ? 'hidden' : 'visible']"
                style="position: absolute; width: 35px; height: 35px; border: 1px solid rgba(227, 228, 229, 0.5); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                <div
                  style="position: absolute; width: 100%; height: 42%; display: flex; align-items: center; justify-content: center; top: 10px; transform: translateY(0); transition: transform 0.2s ease-in-out;">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none">
                    <path fill="currentColor"
                      d="M8 5.818c1.2 0 2.182.982 2.182 2.182S9.2 10.182 8 10.182 5.818 9.2 5.818 8 6.8 5.818 8 5.818Zm0-1.454A3.638 3.638 0 0 0 4.364 8 3.638 3.638 0 0 0 8 11.636 3.638 3.638 0 0 0 11.636 8 3.638 3.638 0 0 0 8 4.364ZM.727 8.727h1.455A.73.73 0 0 0 2.909 8a.73.73 0 0 0-.727-.727H.727A.73.73 0 0 0 0 8c0 .4.327.727.727.727Zm13.091 0h1.455A.73.73 0 0 0 16 8a.73.73 0 0 0-.727-.727h-1.455a.73.73 0 0 0-.727.727c0 .4.327.727.727.727Zm-6.545-8v1.455c0 .4.327.727.727.727a.73.73 0 0 0 .727-.727V.727A.73.73 0 0 0 8 0a.73.73 0 0 0-.727.727Zm0 13.091v1.455c0 .4.327.727.727.727a.73.73 0 0 0 .727-.727v-1.455A.73.73 0 0 0 8 13.091a.73.73 0 0 0-.727.727ZM3.629 2.604a.724.724 0 1 0-1.025 1.025l.77.771A.724.724 0 1 0 4.4 3.375l-.77-.771Zm8.997 8.996a.724.724 0 1 0-1.026 1.026l.77.77a.724.724 0 1 0 1.025-1.025l-.77-.771Zm.77-7.97a.724.724 0 1 0-1.025-1.025l-.771.77A.724.724 0 1 0 12.626 4.4l.77-.77ZM4.4 12.624A.724.724 0 1 0 3.375 11.6l-.771.772a.724.724 0 1 0 1.025 1.025l.771-.77Z">
                    </path>
                  </svg>
                </div>
              </div>
              <!-- 黑夜模式图标 -->
              <div :class="['icon-wrapper', isDark ? 'visible' : 'hidden']"
                style="position: absolute; width: 35px; height: 35px; border: 1px solid rgba(227, 228, 229, 0.5); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                <div
                  style="position: absolute; width: 100%; height: 42%; display: flex; align-items: center; justify-content: center; top: 10px; transform: translateY(0); transition: transform 0.2s ease-in-out;">
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16" fill="none">
                    <path fill="currentColor" fill-rule="evenodd"
                      d="M6.563 1.66a6.5 6.5 0 1 0 7.778 7.777A5.5 5.5 0 0 1 6.563 1.66ZM0 8A8 8 0 0 1 9.526.146a.75.75 0 0 1 .033 1.465A4.002 4.002 0 0 0 10.5 9.5a4.002 4.002 0 0 0 3.889-3.06.75.75 0 0 1 1.466.034A8 8 0 1 1 0 8Z"
                      clip-rule="evenodd"></path>
                  </svg>
                </div>
              </div>

            </div>
          </div>
        </div>

      </div>
    </div>

  </header>
</template>

<script>
import { FindarticlesByNum } from '@/api/webarticle'
import { FindresourceByNum } from '@/api/webresource'
import { login, WeChatLogin, WeChatLoginCheck, Messagelogin, MessageloginCheck } from '@/api/login'
import { getAllResource, getAllResourceNumber } from '@/api/webresource'
import { getAllArticle, getAllArticleNumber } from '@/api/webarticle'
import { testemail } from '@/api/webuser'
import { register } from '@/api/register'

import { CheckVip } from '@/api/user'

import { mapState, mapMutations } from 'vuex'

export default ({
  name: 'Top',
  props: ['message1', 'message2', 'message3', 'message4', 'message5'],
  computed: {
    ...mapState(['playlist', 'glabledata', 'count'])
  },
  created() {
    // 检查是否在客户端环境
    if (process.client) {
      const savedMode = localStorage.getItem('darkMode');
      if (savedMode === 'true') {
        this.isDark = true;
      } else {
        this.isDark = false;
      }
    }
  },
  watch: {
    isDark(newVal) {
      // 根据 isDark 的值设置 CSS 变量
      document.documentElement.style.setProperty('--dialog-bg-color', newVal ? '#202020' : '#ffffff');
    },
  },
  methods: {
    toggleMode() {
      this.isDark = !this.isDark; // 切换模式
      if (this.isDark) {
        this.setDarkMode();
        localStorage.setItem('darkMode', 'true');
      } else {
        this.setLightMode();
        localStorage.setItem('darkMode', 'false');
      }
    },
    setDarkMode() {
      const appDiv = document.querySelector('.app');
      if (appDiv) {
        appDiv.classList.remove('light');
        appDiv.classList.add('black');
      }
    },
    setLightMode() {
      const appDiv = document.querySelector('.app');
      if (appDiv) {
        appDiv.classList.remove('black');
        appDiv.classList.add('light');
      }
    },
    async fullnum() {
      let res1 = await getAllResourceNumber()
      if (res1) {
        this.ResourceNumber = res1.data
      }
      let res2 = await getAllArticleNumber()
      if (res2) {
        this.articleCount = res2.data
      }
    },
    async loginout() {
      //退出登录
      //清除本地数据
      this.$cookies.remove('access-user')
      //关闭用户头像
      this.userJudje = false

      //显示退出成功
      this.$notify({
        title: '成功',
        message: '您已退出登录',
        type: 'success',
        offset: 50
      });
      // 刷新页面
      //延时刷新页面
      //延时刷新页面  
      setTimeout(() => {
        this.$router.go(0);
      }, 900);
      this.$router.go(0);
    },
    async getSetting() {
      const setting = this.$cookies.get("setting")
      this.setting = setting
    },
    async getUserInfo() {
      const user = this.$cookies.get('access-user')
      if (user != null) {
        this.user = user
        this.userJudje = (user == null)
        //获取会员有效性
        let res = await CheckVip(this.user.userid);
        if (res) {
          if (resp.data) {
            this.vipTrue = true
          }
        }
      }
    },
    RegistersendCode() {
      //发送验证码
      console.log(this.emailRegisterForm.email)
      // 如果手机号为空
      if (this.emailRegisterForm.email.trim() === '') {
        this.$notify({
          title: '失败',
          message: '请输入邮箱',
          type: 'warning',
          offset: 50
        });
        return
      }
      // 检测邮箱类型
      if (!(/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/).test(this.emailRegisterForm.email)) {
        this.$notify({
          title: '失败',
          message: '请输入正确的邮箱',
          type: 'warning',
          offset: 50
        });
        return
      }
      // 检测不是计时器状态
      if (this.RegistercodeCd) {
        this.$notify({
          title: '失败',
          message: '请等待60秒后再次发送',
          type: 'warning',
          offset: 50
        });
        return
      } else {
        testemail(this.emailRegisterForm.email).then(resp => {
          console.log(resp.data);
          if (resp.data.code === 200) {
            this.$notify({
              title: '成功',
              message: '验证码已发送',
              type: 'success',
              offset: 50
            });
          }
        }).catch(error => {
          console.error('Error during WeChatLoginCheck:', error);
        });
      }
      // 获取验证码
      // captcha(this.form.phoneNum)
      // 开启计时
      this.RegistercodeCd = true
      const timer = setInterval(() => {
        this.long--
        if (this.long <= 0) {
          this.long = 60
          this.RegistercodeCd = false
          clearInterval(timer)
        }
      }, 1000)

    },
    handleforgotPassword() {
      this.forgotPassword = true;
      // this.IsRegister = false;
    },
    handleEmailLogin() {
      var that = this
      this.$refs.emailRegisterForm.validate(valid => {
        if (valid) {
          this.loading = true
          console.log(that.emailRegisterForm)
          that.emailRegisterForm.status = that.emailRegisterForm.code
          register(that.emailRegisterForm).then(resp => {
            console.log(resp)
            if (resp.data.code == 402 || resp.data.code == 400) {
              this.$notify({
                title: '失败',
                message: resp.data.msg,
                type: 'warning',
                offset: 50
              });
            } else if (resp.data.code == 200) {
              console.log(resp.data)
              that.$cookies.set('access-user', resp.data.data)

              // 关闭登录框
              that.dialogFormVisible = false
              // 关闭登录按钮
              that.userJudje = false
              //立即获取用户数据
              that.getUserInfo()
              this.$notify({
                title: '成功',
                message: '您已成功登录',
                type: 'success',
                offset: 50
              });
            }
          }).catch((e) => { })
          this.loading = false
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    sendCode() {
      //发送验证码
      console.log(this.phoneLoginForm.phone)
      // 如果手机号为空
      if (this.phoneLoginForm.phone.trim() === '') {
        this.$notify({
          title: '失败',
          message: '请输入手机号码',
          type: 'warning',
          offset: 50
        });
        return
      }
      // 检测手机号码类型
      if (!(/^1[3456789]\d{9}$/.test(this.phoneLoginForm.phone))) {
        this.$notify({
          title: '失败',
          message: '请输入正确的手机号码',
          type: 'warning',
          offset: 50
        });
        return
      }
      // 检测不是计时器状态
      if (this.codeCd) {
        this.$notify({
          title: '失败',
          message: '请等待60秒后再次发送',
          type: 'warning',
          offset: 50
        });
        return
      } else {
        Messagelogin(this.phoneLoginForm.phone).then(resp => {
          console.log(resp.data);
          if (resp.data.code === 200) {
            this.$notify({
              title: '成功',
              message: '验证码已发送',
              type: 'success',
              offset: 50
            });
          }
        }).catch(error => {
          console.error('Error during WeChatLoginCheck:', error);
        });
      }
      // 获取验证码
      // captcha(this.form.phoneNum)
      // 开启计时
      this.codeCd = true
      const timer = setInterval(() => {
        this.long--
        if (this.long <= 0) {
          this.long = 60
          this.codeCd = false
          clearInterval(timer)
        }
      }, 1000)

    },
    closeDialog() {
      console.log('关闭对话框');
      this.dialogFormVisible = false;  // 点击图片关闭对话框
      this.beforeDestroy();
    },
    tohandleLogin() {
      console.log('打开登录框');
      this.IsRegister = true;
      this.forgotPassword = false;
    },
    handleLogin() {
      var that = this
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          login(that.loginForm).then(resp => {
            console.log(resp)
            if (resp.data.code == 402 || resp.data.code == 400) {
              this.$notify({
                title: '失败',
                message: '登录失败',
                type: 'warning',
                offset: 50
              });
            } else if (resp.data.code == 200) {
              console.log(resp.data)
              that.$cookies.set('access-user', resp.data.data)

              // 关闭登录框
              that.dialogFormVisible = false
              // 关闭登录按钮
              that.userJudje = false
              //立即获取用户数据
              that.getUserInfo()
              this.$notify({
                title: '成功',
                message: '您已成功登录',
                type: 'success',
                offset: 50
              });
            }
          }).catch((e) => { })
          this.loading = false
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    showlogin() {
      this.setActiveTab("wechat")
      this.dialogFormVisible = true;

      // 检查accountId是否为空
      if (this.accountId.trim() === '') {
        console.warn('accountId为空，无法开始轮询');
        return;
      }
      // this.startPolling();
    },
    beforeDestroy() {
      if (this.intervalId) {
        clearInterval(this.intervalId);
      }
    },
    showPwd() {
      if (this.passwordType === 'password') {
        this.passwordType = ''
      } else {
        this.passwordType = 'password'
      }
      this.$nextTick(() => {
        this.$refs.password.focus()
      })
    },
    keyup() {
      this.searchshow = true
      this.search(this.seachcontent)
    },
    Findresource(seachcontents, num) {
      FindresourceByNum(seachcontents, num).then(resp => {
        this.tempdata = resp.data
      })
    },
    Findarticles(seachcontents, num) {
      FindarticlesByNum(seachcontents, num).then(resp => {
        this.tempdata = resp.data
      })
    },
    //临时查询
    search(seachcontents) {
      //限制查询五个数据
      if (!this.judgeNull(this.seachcontent)) {
        if (this.fundByresource) { this.Findresource(seachcontents, 5) }
        else { this.Findarticles(seachcontents, 5) }

      }
    },
    //判空
    judgeNull(str) {
      if (str == "") return true;
      var regu = "^[ ]+$";
      var re = new RegExp(regu);
      return re.test(str);
    },
    handlePhoneLogin() {
      var that = this
      this.$refs.phoneLoginForm.validate(valid => {
        if (valid) {
          this.loading = true
          console.log(that.phoneLoginForm)
          MessageloginCheck(that.phoneLoginForm.phone, that.phoneLoginForm.code).then(resp => {
            console.log(resp)
            if (resp.data.code == 402 || resp.data.code == 400) {
              this.$notify({
                title: '失败',
                message: '登录失败',
                type: 'warning',
                offset: 50
              });
            } else if (resp.data.code == 200) {
              console.log(resp.data)
              that.$cookies.set('access-user', resp.data.data)

              // 关闭登录框
              that.dialogFormVisible = false
              // 关闭登录按钮
              that.userJudje = false
              //立即获取用户数据
              that.getUserInfo()
              this.$notify({
                title: '成功',
                message: '您已成功登录',
                type: 'success',
                offset: 50
              });
            }
          }).catch((e) => { })
          this.loading = false
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    queryarticle() {
      //提交
      if (this.judgeNull(this.seachcontent)) {
        this.$notify({
          title: '提示',
          message: '输入的数据不能为空',
          type: 'warning'
        });
      } else {
        //   直接调用$router.push 实现携带参数的跳转
        this.$router.push({
          path: `/findpost/${this.seachcontent}`,
        })
      }
    },
    articleshows() {
      // setTimeout(() => { this.focus() }, 219)
      // this.searchshow = true
      this.codeshow = false
      this.articleshow = true
      this.tempdata = ""
      this.fundByresource = false
      this.Findarticles(this.seachcontent, 5)
      this.howto = '/post/'

    },
    codeshows() {
      // setTimeout(() => { this.focus() }, 219)
      // this.searchshow = true
      this.codeshow = true
      this.articleshow = false
      this.tempdata = ""
      this.fundByresource = true
      this.Findresource(this.seachcontent, 5)
      this.howto = '/list/'
    },
    focus() {
      this.searchshow = true
    },
    blur() {
      // setTimeout(() => { this.searchshow = false }, 300)
      //设置300ms后让下拉框消失
    },
    handleRegister() {
      console.log('注册');
      this.IsRegister = false;
      this.beforeDestroy(); // 停止轮询
    },

    startPolling() {
      const checkStatus = () => {
        WeChatLoginCheck(this.accountId).then(resp => {
          console.log(resp.data);
          if (resp.data.code === 200) {
            console.log('登录成功');
            this.beforeDestroy(); // 停止轮询
            this.dialogFormVisible = false;
            // 关闭登录按钮
            this.userJudje = false
            console.log(resp.data.data);
            this.$cookies.set('access-user', resp.data.data); // 设置用户访问
            this.getUserInfo(); // 获取用户信息
            this.$notify({
              title: '成功',
              message: '您已成功登录',
              type: 'success',
              offset: 50
            });
            // 刷新页面
            //延时刷新页面  
            setTimeout(() => {
              this.$router.go(0);
            }, 500);
            this.$router.go(0);
          }
        }).catch(error => {
          console.error('Error during WeChatLoginCheck:', error);
        });
      };

      console.log('开始轮询');
      // 设置轮询，每隔2秒检查一次
      this.intervalId = setInterval(checkStatus, 700);
    },
    enter() {
      this.searchshow = true
    },
    leave() {
      setTimeout(() => { this.searchshow = false }, 300)
    },
    setActiveTab(tab) {
      if (tab === 'wechat') {
        this.qrCodeValue = '';
        // 微信登录
        const that = this; // 将组件实例的 this 赋值给 that
        WeChatLogin().then(resp => {
          if (resp.data.code === 200) {
            // 假设后端返回的是 Base64 编码的 QR 码数据
            this.qrCodeValue = 'data:image/png;base64,' + resp.data.data.data.bytes;
            this.accountId = resp.data.data.data.accountId;
            console.log(resp.data.data)
            // 设置轮询，每隔2秒检查一次
            this.beforeDestroy(); // 停止轮询
            console.log("开始轮询")
            // 设置轮询，每隔2秒检查一次状态
            that.startPolling();
          }
          // 清除之前所有多生成的二维码
          // this.$refs.qrCode.innerHTML = '';
          // 清除之前多的轮询事件
        })
      }
      if (tab === 'phone') {
        // 手机号登录
        this.beforeDestroy(); // 停止轮询

      }
      if (tab === 'password') {
        // 密码登录
        this.beforeDestroy(); // 停止轮询


      }
      this.activeTab = tab;
    }
  },

  data() {
    return {
      forgotPassword: false,
      IsRegister: true,
      intervalId: null,
      activeTab: 'wechat', // 默认选中的标签
      accountId: '', // 账号ID
      qrCodeValue: '', // 二维码内容
      phoneLoginForm: {
        phone: '',
        code: ''
      },
      emailRegisterForm: {
        email: '',
        password: '',
        code: '',
        Status: ''
      },
      RegistercodeCd: false,
      codeCd: false,
      // CD长度
      long: 60,
      emailRegisterRules: {
        email: [
          { required: true, message: '请输入邮箱', trigger: 'blur' },
          { type: 'email', message: '请输入正确的邮箱', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, max: 20, message: '密码长度在6-20个字符', trigger: 'blur' }
        ],
        code: [
          { required: true, message: '请输入验证码', trigger: 'blur' },
          { len: 6, message: '验证码为6位数字', trigger: 'blur' }
        ]
      },
      phoneLoginRules: {
        phone: [
          { required: true, message: '请输入手机号', trigger: 'blur' },
          { pattern: /^1[34578]\d{9}$/, message: '请输入有效的手机号', trigger: 'blur' }
        ],
        code: [
          { required: true, message: '请输入验证码', trigger: 'blur' },
          { len: 6, message: '验证码为6位数字', trigger: 'blur' }
        ]
      },
      loading: false,
      codeButtonDisabled: false,
      setting: "",
      vipTrue: false,
      articleCount: "",
      ResourceNumber: "",
      howto: '/list/',
      fundByresource: true,
      user: "",
      userJudje: true,
      loginForm: {
        username: '',
        password: ''
      },
      loginRules: {
        username: [{ required: true, message: '请您输入用户名或邮箱', trigger: 'blur' }],
        password: [{ required: true, message: '请您输入密码', trigger: 'blur' }]
      },
      loading: false,
      passwordType: 'password',
      redirect: undefined,
      dialogFormVisible: false,
      form: {
        name: '',
        region: '',
        date1: '',
        date2: '',
        delivery: false,
        type: [],
        resource: '',
        desc: ''
      },
      formLabelWidth: '60px',
      tempdata: "",
      seen: false,
      codeshow: true,
      articleshow: false,
      searchshow: false,
      navlinks: "nav-link active",
      seachcontent: '',
      isDark: false // 默认白天模式
    }
  },
  mounted() {
    // 初始化时设置 CSS 变量
    document.documentElement.style.setProperty('--dialog-bg-color', this.isDark ? '#202020' : '#ffffff');

    // 判断是否在服务端
    if (process.client) {
      // this.lazyLoad();
      this.getUserInfo()
      this.getSetting()
      //检测token是否有效
      this.fullnum()
    }
    // 顶部广告
    // (window.slotbydup = window.slotbydup || []).push({
    //   id: "u6324930",
    //   container: "_utrtw8kq5so",
    //   async: true,
    // });
  },
})
</script>

<style scoped>
@import "../../static/mycss/margin_top.css";

.navbar .navbar-button,
.off-canvas .canvas-close {
  background: linear-gradient(125deg, #18cef2 0%, #448aff 100%);
  transition: transform 0.1s;
  box-shadow: 4px 3px 10px #2f6bd024;
  color: #fff;
}

.actions .login-btn {
  position: relative;
}

.navbar .login-btn {
  border-radius: 25px;
  width: 90px;
}

.login-button {
  height: 30px;
  width: 100px;
  color: #fff;
  background: linear-gradient(125deg, #18cef2 0%, #448aff 100%);
  line-height: 50px;
  transition: transform 0.1s;
  text-align: center;
  font-weight: 600;
  font-size: 16px;
  box-shadow: 4px 3px 10px #2f6bd024;
  align-items: center;
  display: flex;
  justify-content: center;
  border-radius: 50px 50px 50px 50px;
}

.logintext {
  font-size: 15px;
  text-align: center;
  line-height: 90px;
  /* transform:translateY(-50%);
  transform:translateX(30px);  */
}

.login-title {
  image-rendering: -webkit-optimize-contrast;
  --bs-blue: #0d6efd;
  --bs-indigo: #6610f2;
  --bs-purple: #6f42c1;
  --bs-pink: #d63384;
  --bs-red: #dc3545;
  --bs-orange: #fd7e14;
  --bs-yellow: #ffc107;
  --bs-green: #198754;
  --bs-teal: #20c997;
  --bs-cyan: #0dcaf0;
  --bs-white: #fff;
  --bs-gray: #6c757d;
  --bs-gray-dark: #343a40;
  --bs-primary: #0d6efd;
  --bs-secondary: #6c757d;
  --bs-success: #198754;
  --bs-info: #0dcaf0;
  --bs-warning: #ffc107;
  --bs-danger: #dc3545;
  --bs-light: #f8f9fa;
  --bs-dark: #212529;
  --bs-font-sans-serif: system-ui, -apple-system, "Segoe UI", Roboto,
    "Helvetica Neue", Arial, "Noto Sans", "Liberation Sans", sans-serif,
    "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
  --bs-font-monospace: SFMono-Regular, Menlo, Monaco, Consolas,
    "Liberation Mono", "Courier New", monospace;
  --bs-gradient: linear-gradient(180deg,
      rgba(255, 255, 255, 0.15),
      rgba(255, 255, 255, 0));
  --web-color: #0a36fa;
  --web-light-color: rgba(10, 54, 250, 0.2);
  --border-radius: 4px;
  --wp--preset--font-size--normal: 16px;
  --wp--preset--font-size--huge: 42px;
  -webkit-text-size-adjust: 100%;
  -webkit-tap-highlight-color: transparent;
  line-height: 1.4;
  text-rendering: optimizeLegibility;
  font-feature-settings: "liga" on;
  -webkit-font-smoothing: subpixel-antialiased;
  --wp--preset--color--black: #000000;
  --wp--preset--color--cyan-bluish-gray: #abb8c3;
  --wp--preset--color--white: #ffffff;
  --wp--preset--color--pale-pink: #f78da7;
  --wp--preset--color--vivid-red: #cf2e2e;
  --wp--preset--color--luminous-vivid-orange: #ff6900;
  --wp--preset--color--luminous-vivid-amber: #fcb900;
  --wp--preset--color--light-green-cyan: #7bdcb5;
  --wp--preset--color--vivid-green-cyan: #00d084;
  --wp--preset--color--pale-cyan-blue: #8ed1fc;
  --wp--preset--color--vivid-cyan-blue: #0693e3;
  --wp--preset--color--vivid-purple: #9b51e0;
  --wp--preset--gradient--vivid-cyan-blue-to-vivid-purple: linear-gradient(135deg,
      rgba(6, 147, 227, 1) 0%,
      rgb(155, 81, 224) 100%);
  --wp--preset--gradient--light-green-cyan-to-vivid-green-cyan: linear-gradient(135deg,
      rgb(122, 220, 180) 0%,
      rgb(0, 208, 130) 100%);
  --wp--preset--gradient--luminous-vivid-amber-to-luminous-vivid-orange: linear-gradient(135deg,
      rgba(252, 185, 0, 1) 0%,
      rgba(255, 105, 0, 1) 100%);
  --wp--preset--gradient--luminous-vivid-orange-to-vivid-red: linear-gradient(135deg,
      rgba(255, 105, 0, 1) 0%,
      rgb(207, 46, 46) 100%);
  --wp--preset--gradient--very-light-gray-to-cyan-bluish-gray: linear-gradient(135deg,
      rgb(238, 238, 238) 0%,
      rgb(169, 184, 195) 100%);
  --wp--preset--gradient--cool-to-warm-spectrum: linear-gradient(135deg,
      rgb(74, 234, 220) 0%,
      rgb(151, 120, 209) 20%,
      rgb(207, 42, 186) 40%,
      rgb(238, 44, 130) 60%,
      rgb(251, 105, 98) 80%,
      rgb(254, 248, 76) 100%);
  --wp--preset--gradient--blush-light-purple: linear-gradient(135deg,
      rgb(255, 206, 236) 0%,
      rgb(152, 150, 240) 100%);
  --wp--preset--gradient--blush-bordeaux: linear-gradient(135deg,
      rgb(254, 205, 165) 0%,
      rgb(254, 45, 45) 50%,
      rgb(107, 0, 62) 100%);
  --wp--preset--gradient--luminous-dusk: linear-gradient(135deg,
      rgb(255, 203, 112) 0%,
      rgb(199, 81, 192) 50%,
      rgb(65, 88, 208) 100%);
  --wp--preset--gradient--pale-ocean: linear-gradient(135deg,
      rgb(255, 245, 203) 0%,
      rgb(182, 227, 212) 50%,
      rgb(51, 167, 181) 100%);
  --wp--preset--gradient--electric-grass: linear-gradient(135deg,
      rgb(202, 248, 128) 0%,
      rgb(113, 206, 126) 100%);
  --wp--preset--gradient--midnight: linear-gradient(135deg,
      rgb(2, 3, 129) 0%,
      rgb(40, 116, 252) 100%);
  --wp--preset--duotone--dark-grayscale: url("#wp-duotone-dark-grayscale");
  --wp--preset--duotone--grayscale: url("#wp-duotone-grayscale");
  --wp--preset--duotone--purple-yellow: url("#wp-duotone-purple-yellow");
  --wp--preset--duotone--blue-red: url("#wp-duotone-blue-red");
  --wp--preset--duotone--midnight: url("#wp-duotone-midnight");
  --wp--preset--duotone--magenta-yellow: url("#wp-duotone-magenta-yellow");
  --wp--preset--duotone--purple-green: url("#wp-duotone-purple-green");
  --wp--preset--duotone--blue-orange: url("#wp-duotone-blue-orange");
  --wp--preset--font-size--small: 13px;
  --wp--preset--font-size--medium: 20px;
  --wp--preset--font-size--large: 36px;
  --wp--preset--font-size--x-large: 42px;
  visibility: visible;
  pointer-events: auto;
  -webkit-user-select: text !important;
  border: 0;
  font-family: inherit;
  font-style: inherit;
  font-weight: inherit;
  margin: 0;
  outline: 0;
  padding: 0;
  vertical-align: baseline;
  word-wrap: break-word;
  box-sizing: border-box;
  color: #b2bac2;
  font-size: 13px;
  margin-bottom: 20px;
  text-align: center;
}

.login-logo {
  image-rendering: -webkit-optimize-contrast;
  --bs-blue: #0d6efd;
  --bs-indigo: #6610f2;
  --bs-purple: #6f42c1;
  --bs-pink: #d63384;
  --bs-red: #dc3545;
  --bs-orange: #fd7e14;
  --bs-yellow: #ffc107;
  --bs-green: #198754;
  --bs-teal: #20c997;
  --bs-cyan: #0dcaf0;
  --bs-white: #fff;
  --bs-gray: #6c757d;
  --bs-gray-dark: #343a40;
  --bs-primary: #0d6efd;
  --bs-secondary: #6c757d;
  --bs-success: #198754;
  --bs-info: #0dcaf0;
  --bs-warning: #ffc107;
  --bs-danger: #dc3545;
  --bs-light: #f8f9fa;
  --bs-dark: #212529;
  --bs-font-sans-serif: system-ui, -apple-system, "Segoe UI", Roboto,
    "Helvetica Neue", Arial, "Noto Sans", "Liberation Sans", sans-serif,
    "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
  --bs-font-monospace: SFMono-Regular, Menlo, Monaco, Consolas,
    "Liberation Mono", "Courier New", monospace;
  --bs-gradient: linear-gradient(180deg,
      rgba(255, 255, 255, 0.15),
      rgba(255, 255, 255, 0));
  --web-color: #0a36fa;
  --web-light-color: rgba(10, 54, 250, 0.2);
  --border-radius: 4px;
  --wp--preset--font-size--normal: 16px;
  --wp--preset--font-size--huge: 42px;
  -webkit-text-size-adjust: 100%;
  -webkit-tap-highlight-color: transparent;
  color: #121212;
  line-height: 1.4;
  text-rendering: optimizeLegibility;
  font-feature-settings: "liga" on;
  -webkit-font-smoothing: subpixel-antialiased;
  --wp--preset--color--black: #000000;
  --wp--preset--color--cyan-bluish-gray: #abb8c3;
  --wp--preset--color--white: #ffffff;
  --wp--preset--color--pale-pink: #f78da7;
  --wp--preset--color--vivid-red: #cf2e2e;
  --wp--preset--color--luminous-vivid-orange: #ff6900;
  --wp--preset--color--luminous-vivid-amber: #fcb900;
  --wp--preset--color--light-green-cyan: #7bdcb5;
  --wp--preset--color--vivid-green-cyan: #00d084;
  --wp--preset--color--pale-cyan-blue: #8ed1fc;
  --wp--preset--color--vivid-cyan-blue: #0693e3;
  --wp--preset--color--vivid-purple: #9b51e0;
  --wp--preset--gradient--vivid-cyan-blue-to-vivid-purple: linear-gradient(135deg,
      rgba(6, 147, 227, 1) 0%,
      rgb(155, 81, 224) 100%);
  --wp--preset--gradient--light-green-cyan-to-vivid-green-cyan: linear-gradient(135deg,
      rgb(122, 220, 180) 0%,
      rgb(0, 208, 130) 100%);
  --wp--preset--gradient--luminous-vivid-amber-to-luminous-vivid-orange: linear-gradient(135deg,
      rgba(252, 185, 0, 1) 0%,
      rgba(255, 105, 0, 1) 100%);
  --wp--preset--gradient--luminous-vivid-orange-to-vivid-red: linear-gradient(135deg,
      rgba(255, 105, 0, 1) 0%,
      rgb(207, 46, 46) 100%);
  --wp--preset--gradient--very-light-gray-to-cyan-bluish-gray: linear-gradient(135deg,
      rgb(238, 238, 238) 0%,
      rgb(169, 184, 195) 100%);
  --wp--preset--gradient--cool-to-warm-spectrum: linear-gradient(135deg,
      rgb(74, 234, 220) 0%,
      rgb(151, 120, 209) 20%,
      rgb(207, 42, 186) 40%,
      rgb(238, 44, 130) 60%,
      rgb(251, 105, 98) 80%,
      rgb(254, 248, 76) 100%);
  --wp--preset--gradient--blush-light-purple: linear-gradient(135deg,
      rgb(255, 206, 236) 0%,
      rgb(152, 150, 240) 100%);
  --wp--preset--gradient--blush-bordeaux: linear-gradient(135deg,
      rgb(254, 205, 165) 0%,
      rgb(254, 45, 45) 50%,
      rgb(107, 0, 62) 100%);
  --wp--preset--gradient--luminous-dusk: linear-gradient(135deg,
      rgb(255, 203, 112) 0%,
      rgb(199, 81, 192) 50%,
      rgb(65, 88, 208) 100%);
  --wp--preset--gradient--pale-ocean: linear-gradient(135deg,
      rgb(255, 245, 203) 0%,
      rgb(182, 227, 212) 50%,
      rgb(51, 167, 181) 100%);
  --wp--preset--gradient--electric-grass: linear-gradient(135deg,
      rgb(202, 248, 128) 0%,
      rgb(113, 206, 126) 100%);
  --wp--preset--gradient--midnight: linear-gradient(135deg,
      rgb(2, 3, 129) 0%,
      rgb(40, 116, 252) 100%);
  --wp--preset--duotone--dark-grayscale: url("#wp-duotone-dark-grayscale");
  --wp--preset--duotone--grayscale: url("#wp-duotone-grayscale");
  --wp--preset--duotone--purple-yellow: url("#wp-duotone-purple-yellow");
  --wp--preset--duotone--blue-red: url("#wp-duotone-blue-red");
  --wp--preset--duotone--midnight: url("#wp-duotone-midnight");
  --wp--preset--duotone--magenta-yellow: url("#wp-duotone-magenta-yellow");
  --wp--preset--duotone--purple-green: url("#wp-duotone-purple-green");
  --wp--preset--duotone--blue-orange: url("#wp-duotone-blue-orange");
  --wp--preset--font-size--small: 13px;
  --wp--preset--font-size--medium: 20px;
  --wp--preset--font-size--large: 36px;
  --wp--preset--font-size--x-large: 42px;
  visibility: visible;
  pointer-events: auto;
  -webkit-user-select: text !important;
  border: 0;
  font-family: inherit;
  font-style: inherit;
  font-weight: inherit;
  margin: 0;
  outline: 0;
  padding: 0;
  vertical-align: baseline;
  word-wrap: break-word;
  box-sizing: border-box;
  align-items: center;
  display: flex;
  justify-content: center;
  font-size: 27px;
}

.box {
  /* image-rendering: -webkit-optimize-contrast;
  --bs-blue: #0d6efd;
  --bs-indigo: #6610f2;
  --bs-purple: #6f42c1;
  --bs-pink: #d63384;
  --bs-red: #dc3545;
  --bs-orange: #fd7e14;
  --bs-yellow: #ffc107;
  --bs-green: #198754;
  --bs-teal: #20c997;
  --bs-cyan: #0dcaf0;
  --bs-white: #fff;
  --bs-gray: #6c757d;
  --bs-gray-dark: #343a40;
  --bs-primary: #0d6efd;
  --bs-secondary: #6c757d;
  --bs-success: #198754;
  --bs-info: #0dcaf0;
  --bs-warning: #ffc107;
  --bs-danger: #dc3545;
  --bs-light: #f8f9fa;
  --bs-dark: #212529;
  --bs-font-sans-serif: system-ui, -apple-system, "Segoe UI", Roboto,
    "Helvetica Neue", Arial, "Noto Sans", "Liberation Sans", sans-serif,
    "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
  --bs-font-monospace: SFMono-Regular, Menlo, Monaco, Consolas,
    "Liberation Mono", "Courier New", monospace;
  --bs-gradient: linear-gradient(
    180deg,
    rgba(255, 255, 255, 0.15),
    rgba(255, 255, 255, 0)
  );
  --web-color: #0a36fa;
  --web-light-color: rgba(10, 54, 250, 0.2);
  --border-radius: 4px;
  --wp--preset--font-size--normal: 16px;
  --wp--preset--font-size--huge: 42px;
  -webkit-text-size-adjust: 100%;
  -webkit-tap-highlight-color: transparent;
  color: #121212;
  line-height: 1.4;
  text-rendering: optimizeLegibility;
  font-feature-settings: "liga" on;
  -webkit-font-smoothing: subpixel-antialiased;
  --wp--preset--color--black: #000000;
  --wp--preset--color--cyan-bluish-gray: #abb8c3;
  --wp--preset--color--white: #ffffff;
  --wp--preset--color--pale-pink: #f78da7;
  --wp--preset--color--vivid-red: #cf2e2e;
  --wp--preset--color--luminous-vivid-orange: #ff6900;
  --wp--preset--color--luminous-vivid-amber: #fcb900;
  --wp--preset--color--light-green-cyan: #7bdcb5;
  --wp--preset--color--vivid-green-cyan: #00d084;
  --wp--preset--color--pale-cyan-blue: #8ed1fc;
  --wp--preset--color--vivid-cyan-blue: #0693e3;
  --wp--preset--color--vivid-purple: #9b51e0;
  --wp--preset--gradient--vivid-cyan-blue-to-vivid-purple: linear-gradient(
    135deg,
    rgba(6, 147, 227, 1) 0%,
    rgb(155, 81, 224) 100%
  );
  --wp--preset--gradient--light-green-cyan-to-vivid-green-cyan: linear-gradient(
    135deg,
    rgb(122, 220, 180) 0%,
    rgb(0, 208, 130) 100%
  );
  --wp--preset--gradient--luminous-vivid-amber-to-luminous-vivid-orange: linear-gradient(
    135deg,
    rgba(252, 185, 0, 1) 0%,
    rgba(255, 105, 0, 1) 100%
  );
  --wp--preset--gradient--luminous-vivid-orange-to-vivid-red: linear-gradient(
    135deg,
    rgba(255, 105, 0, 1) 0%,
    rgb(207, 46, 46) 100%
  );
  --wp--preset--gradient--very-light-gray-to-cyan-bluish-gray: linear-gradient(
    135deg,
    rgb(238, 238, 238) 0%,
    rgb(169, 184, 195) 100%
  );
  --wp--preset--gradient--cool-to-warm-spectrum: linear-gradient(
    135deg,
    rgb(74, 234, 220) 0%,
    rgb(151, 120, 209) 20%,
    rgb(207, 42, 186) 40%,
    rgb(238, 44, 130) 60%,
    rgb(251, 105, 98) 80%,
    rgb(254, 248, 76) 100%
  );
  --wp--preset--gradient--blush-light-purple: linear-gradient(
    135deg,
    rgb(255, 206, 236) 0%,
    rgb(152, 150, 240) 100%
  );
  --wp--preset--gradient--blush-bordeaux: linear-gradient(
    135deg,
    rgb(254, 205, 165) 0%,
    rgb(254, 45, 45) 50%,
    rgb(107, 0, 62) 100%
  );
  --wp--preset--gradient--luminous-dusk: linear-gradient(
    135deg,
    rgb(255, 203, 112) 0%,
    rgb(199, 81, 192) 50%,
    rgb(65, 88, 208) 100%
  );
  --wp--preset--gradient--pale-ocean: linear-gradient(
    135deg,
    rgb(255, 245, 203) 0%,
    rgb(182, 227, 212) 50%,
    rgb(51, 167, 181) 100%
  );
  --wp--preset--gradient--electric-grass: linear-gradient(
    135deg,
    rgb(202, 248, 128) 0%,
    rgb(113, 206, 126) 100%
  );
  --wp--preset--gradient--midnight: linear-gradient(
    135deg,
    rgb(2, 3, 129) 0%,
    rgb(40, 116, 252) 100%
  );
  --wp--preset--duotone--dark-grayscale: url("#wp-duotone-dark-grayscale");
  --wp--preset--duotone--grayscale: url("#wp-duotone-grayscale");
  --wp--preset--duotone--purple-yellow: url("#wp-duotone-purple-yellow");
  --wp--preset--duotone--blue-red: url("#wp-duotone-blue-red");
  --wp--preset--duotone--midnight: url("#wp-duotone-midnight");
  --wp--preset--duotone--magenta-yellow: url("#wp-duotone-magenta-yellow");
  --wp--preset--duotone--purple-green: url("#wp-duotone-purple-green");
  --wp--preset--duotone--blue-orange: url("#wp-duotone-blue-orange");
  --wp--preset--font-size--small: 13px;
  --wp--preset--font-size--medium: 20px;
  --wp--preset--font-size--large: 36px;
  --wp--preset--font-size--x-large: 42px;
  visibility: visible;
  pointer-events: auto;
  -webkit-user-select: text !important;
  border: 0;
  font-family: inherit;
  font-size: 100%;
  font-style: inherit;
  font-weight: inherit;
  margin: 0;
  outline: 0;
  vertical-align: baseline;
  word-wrap: break-word;
  box-sizing: border-box;
  box-shadow: 0px 0px 2px rgb(98 124 153 / 10%);
  position: relative;
  padding: 30px 24px 24px;
  background-repeat: no-repeat;
  background: none; */
}

.footer {
  display: flex;
  justify-content: center;
  font-family: -apple-system, BlinkMacSystemFont, PingFang SC, Hiragino Sans GB,
    Microsoft YaHei, "\5FAE\8F6F\96C5\9ED1", helvetica neue, helvetica, ubuntu,
    roboto, noto, segoe ui, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  --sspaiRed: #d71a1b;
  --yellow: #ffbe16;
  --B0: #fff;
  --B10: #fbfbfb;
  --B20: #f7f7f8;
  --B30: #efefef;
  --B40: #e5e5e5;
  --B60: #8e8787;
  --B80: #655e5e;
  --B100: #292525;
  --text: #4c4e4d;
  --green: #3fd67e;
  --red: #fd281a;
  --pink: #ff2c78;
  --white: #f4f4f4;
  --sspai-red: #d71a1b;
  --blue: #44b9fb;
  -webkit-text-size-adjust: 100%;
  font-size: 14px;
  word-break: break-all;
  outline: none !important;
  -webkit-user-select: text !important;
  -webkit-tap-highlight-color: transparent;
  color: #8e8787;
  align-content: center;
  align-items: stretch;
  flex-direction: column;
  flex-wrap: wrap;
}

.line {
  font-family: -apple-system, BlinkMacSystemFont, PingFang SC, Hiragino Sans GB,
    Microsoft YaHei, "\5FAE\8F6F\96C5\9ED1", helvetica neue, helvetica, ubuntu,
    roboto, noto, segoe ui, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  --sspaiRed: #d71a1b;
  --yellow: #ffbe16;
  --B0: #fff;
  --B10: #fbfbfb;
  --B20: #f7f7f8;
  --B30: #efefef;
  --B40: #e5e5e5;
  --B60: #8e8787;
  --B80: #655e5e;
  --B100: #292525;
  --text: #4c4e4d;
  --green: #3fd67e;
  --red: #fd281a;
  --pink: #ff2c78;
  --white: #f4f4f4;
  --sspai-red: #d71a1b;
  --blue: #44b9fb;
  -webkit-text-size-adjust: 100%;
  font-size: 14px;
  word-break: break-all;
  color: #292525;
  outline: none !important;
  -webkit-user-select: text !important;
  -webkit-tap-highlight-color: transparent;
  width: calc(100% - 40px);
  margin: 0 auto;
  height: 1px;
  background: #e5e5e5;
  margin-top: 20px;
  margin-bottom: 20px;
}

.ss-login_statement {
  font-family: -apple-system, BlinkMacSystemFont, PingFang SC, Hiragino Sans GB,
    Microsoft YaHei, "\5FAE\8F6F\96C5\9ED1", helvetica neue, helvetica, ubuntu,
    roboto, noto, segoe ui, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  --sspaiRed: #d71a1b;
  --yellow: #ffbe16;
  --B0: #fff;
  --B10: #fbfbfb;
  --B20: #f7f7f8;
  --B30: #efefef;
  --B40: #e5e5e5;
  --B60: #8e8787;
  --B80: #655e5e;
  --B100: #292525;
  --text: #4c4e4d;
  --green: #3fd67e;
  --red: #fd281a;
  --pink: #ff2c78;
  --white: #f4f4f4;
  --sspai-red: #d71a1b;
  --blue: #44b9fb;
  -webkit-text-size-adjust: 100%;
  word-break: break-all;
  outline: none !important;
  -webkit-user-select: text !important;
  -webkit-tap-highlight-color: transparent;
  margin: 12px auto;
  font-size: 12px;
  padding: 0 20px;
  color: var(--B80);
}

/* .ss-login_statement a {
  padding: 0 0.5em;
  font-weight: 600;
  color: var(--red);
} */
</style>
<style lang="scss" scoped>
.dialogdeep {
  :deep(.el-dialog--center) {
    border-radius: 18px;
  }
}

.avatartext {
  display: flex;
}

.spans {
  display: flex;
  align-content: center;
  flex-wrap: wrap;
  margin-left: 5px;
  font-weight: bold;
}

.qqloginsvg {
  display: flex;
  width: 31px;
}
</style>
<style>
.el-dialog--center {
  border-radius: 10px;
  background-color: var(--dialog-bg-color);
  /* 使用 CSS 变量 */
}

.other-login {
  display: flex;
  flex-wrap: nowrap;
  align-content: center;
  justify-content: center;
  align-items: center;
}

/* .login-form {
  width: 350px;
  margin: 0 auto;
  padding: 20px;
  background: #fff;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  border-radius: 8px;
} */
.login-box .login-box-top .login-box-tabs {
  width: 100%;
  display: block;
}

.login-box-tabs-items {
  font-weight: 600;
  color: #999aaa;
  height: 32px;
  box-sizing: content-box;
  margin-bottom: 16px;
  display: -ms-flexbox;
  display: flex;
  -ms-flex-pack: justify;
  justify-content: space-between;
  position: relative;
}

.tabs-item {
  width: 120px;
  display: inline-block;
  font-size: 16px;
  height: 22px;
  line-height: 16px;
  position: relative;
  cursor: pointer;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
  text-align: center;
}

.tabs-active {
  width: 120px;
  display: inline-block;
  font-size: 16px;
  height: 22px;
  line-height: 16px;
  position: relative;
  cursor: pointer;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
  text-align: center;
}

span.last-login-way {
  display: none;
  cursor: default;
  min-width: 74px;
  width: 74px;
  max-width: 74px;
  position: absolute;
  top: -28px;
  left: 142px;
  background: #fef7f0;
  border-radius: 4px 4px;
  border: 1px solid #ffd5a6;
  font-size: 14px;
  font-weight: 400;
  color: #df760c;
  line-height: 20px;
  text-align: center;
  padding: 0 8px;
}

span.last-login-way:after {
  display: block;
  content: "";
  width: 10px;
  height: 6px;
  background: url('~@/static/image/arrow_D.png') no-repeat 50%;
  background-size: 100% 100%;
  position: absolute;
  bottom: -5px;
  left: 50%;
  transform: translateX(-50%);
}

.tabs-active {
  color: #222226;
  position: relative;
}

.tabs-active::after {
  content: "";
  display: block;
  width: 24px;
  height: 2px;
  background: #222226;
  position: absolute;
  bottom: -8px;
  left: 50%;
  transform: translateX(-50%);
}

.wechat-title {
  font-size: 12px;
  font-weight: 400;
  color: #555666;
  line-height: 20px;
  margin-top: 17px
}

.box {
  position: relative;
  /* box 相对定位 */
  padding: 20px;
  /* 设置合适的内边距 */
}

.close-icon {
  position: absolute;
  /* 绝对定位 */
  top: 2%;
  /* 距离顶部的位置，可以根据需要调整 */
  right: -58px;
  /* 距离右侧的位置 */
  width: 16px;
  /* 图标宽度 */
  height: 16px;
  /* 图标高度 */
  cursor: pointer;
  /* 鼠标指针样式 */
  z-index: 999;
  /* 确保在 el-dialog 内部最上层显示 */
}

.loading-container {
  width: 200px;
  height: 200px;
  background-color: #F3F5F7;
  display: flex;
  align-items: center;
  justify-content: center;
}

.spinner {
  border: 4px solid rgba(255, 255, 255, 0.3);
  border-top: 4px solid #ffffff;
  border-radius: 50%;
  width: 50px;
  height: 50px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }

  100% {
    transform: rotate(360deg);
  }
}

.register-text {
  font-size: 30px;
  /* 调整字体大小 */
  text-align: center;
  /* 居中对齐 */
  display: flex;
  justify-content: center;
  align-items: center;
  height: 70px;
  /* 调整高度以确保垂直居中 */
}

.flex-row {
  display: flex;
  justify-content: space-around;
  /* 或 space-between */
  width: 100%;
}

.equal-division-item {
  flex: 1;
  text-align: center;
}

.mt-15 {
  margin-top: 15px;
}

.flex-col {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.flex-col-bar {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  /* 靠左对齐 */
}

.flex-row-bar {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
  /* 设置下方间距，保持各项之间的间隔 */
}

.font_3 {
  font-size: 16px;
  /* 调整字体大小 */
  color: #333;
  /* 优化字体颜色 */
}

.ml-18 {
  margin-left: 18px;
}

.ml-20 {
  margin-left: 20px;
}

.image_4,
.image_5,
.image_6,
.image_7 {
  width: 24px;
  /* 优化图片大小 */
  height: 24px;
}

.group_5 {
  padding: 20px;
  /* 添加一些内边距 */
}

.view-bar {
  cursor: pointer;
  /* 增加鼠标指针样式 */
}

.font_3:hover {
  color: #007bff;

  /* 鼠标悬停时改变字体颜色 */
}

.view-bar:hover {
  color: #007bff;
  background-color: #f0f0f0;
  /* 鼠标悬停时改变背景颜色 */
  border-radius: 8px;
  /* 圆角效果 */
  padding: 8px;
  /* 增加内边距，使悬停效果更明显 */
  /* 鼠标悬停时改变字体颜色 */
}

.view-bar-2:hover .font_3,
.view-bar-2:hover .font_3 {
  color: #ff5722;
}

.view-bar-2 {
  cursor: pointer;

  /* 增加鼠标指针样式 */
}

.view-bar-black {
  cursor: pointer;

  /* 增加鼠标指针样式 */
}

.font-username {
  font-size: 18px;
  /* 调整为更大的字体大小 */
  font-weight: 500;
  /* 可选：增加字体的粗细 */
  color: #333;
  /* 可选：设置字体颜色 */
}

.toggle-button {
  position: relative;
  width: 40px;
  height: 40px;
  cursor: pointer;
  overflow: hidden;
  transition: background-color 0.3s ease-in-out, border-color 0.3s ease-in-out;
}

.icon-wrapper {
  position: absolute;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.3s ease-in-out;
}

.hidden {
  transform: translateY(40px);
}

.visible {
  transform: translateY(0);
}

.forgot-password {
  text-align: left;
  font-size: 12px;
  color: #666;
  margin-left: 20px;

}

.forgot-password a {
  color: #409EFF;
  margin-left: 5px;
}
</style>
