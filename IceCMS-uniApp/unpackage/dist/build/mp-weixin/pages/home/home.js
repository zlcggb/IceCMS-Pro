(global["webpackJsonp"] = global["webpackJsonp"] || []).push([
  ["pages/home/home"], {
    "09ec": function (e, t, n) {
      "use strict";
      (function (e) {
        var o = n("47a9");
        Object.defineProperty(t, "__esModule", {
          value: !0
        }), t.default = void 0;
        var i = o(n("c8ae")),
          u = 1,
          c = {
            data: function () {
              return {
                displays: [{
                  cover: "/static/home/query.jpeg",
                  title: "圈子社区",
                  desc: "公共区域，文明发言",
                  label: "最新",
                  page: "/pages/circle/circle"
                }, {
                  cover: "/static/home/news.jpeg",
                  title: "每日快讯",
                  desc: "让你瞬间了解世界大事",
                  label: "最新",
                  page: "base_cell"
                }, {
                  cover: "/static/home/web.jpeg",
                  title: "互联网资源",
                  desc: "你想要的应有尽有",
                  label: "最新",
                  page: "base_icon"
                }, {
                  cover: "/static/home/vip.jpeg",
                  title: "开通会员",
                  desc: "尊享会员服务",
                  label: "最新",
                  page: "base_icon"
                }],
                showlist: "",
                swiper: [],
                tag: [],
                hotlist: [],
                newList: [],
                recommend: [],
                indexList: [],
                urls: ["https://cdn.uviewui.com/uview/album/1.jpg", "https://cdn.uviewui.com/uview/album/2.jpg", "https://cdn.uviewui.com/uview/album/3.jpg", "https://cdn.uviewui.com/uview/album/4.jpg", "https://cdn.uviewui.com/uview/album/5.jpg", "https://cdn.uviewui.com/uview/album/6.jpg", "https://cdn.uviewui.com/uview/album/7.jpg", "https://cdn.uviewui.com/uview/album/8.jpg", "https://cdn.uviewui.com/uview/album/9.jpg", "https://cdn.uviewui.com/uview/album/10.jpg"],
                keyword: ""
              }
            },
            onLoad: function () {
              this.getswiper(), this.gettag(), this.getnewlist(), this.gethotlist();
              var t = e.getLaunchOptionsSync();
              null != t.query && Object.keys(t.query).length > 0 && (console.log("启动小程序 query"), this.weChatLogin(t.query.scene, {
                profile: "user_profile",
                name: "user_name",
                gender: "user_gender"
              }))
            },
            onPullDownRefresh: function () {
              this.getswiper(), this.gettag(), this.getnewlist(), this.gethotlist(), this.page = 1, setTimeout((function () {
                e.showToast({
                  title: "刷新成功"
                }), e.stopPullDownRefresh()
              }), 1e3)
            },
            onReachBottom: function () {
              var t = this;
              e.request({
                url: i.default.GetPosts(u, 4),
                success: function (n) {
                  console.log(n), "0" != n.data.data.length ? (u += 1, t.newList = t.newList.concat(n.data.data), e.hideLoading(), setTimeout((function () {
                    e.stopPullDownRefresh()
                  }), 100)) : e.showToast({
                    icon: "none",
                    title: "暂无更多"
                  })
                }
              })
            },
            methods: {
              weChatLogin: function (t, n) {
                e.login({
                  provider: "weixin",
                  success: function (n) {
                    if (console.log("dtrd"), n.code) {
                      var o = "http://4dd2dfc.r3.cpolar.top/User/CreateWeChatLogin?scene=".concat(t, "&code=").concat(n.code);
                      console.log(o), e.request({
                        url: o,
                        method: "POST",
                        header: {
                          "Content-Type": "application/json"
                        },
                        success: function (e) {
                          console.log(e)
                        },
                        fail: function (e) {
                          console.log("请求失败！", e)
                        }
                      })
                    } else console.log("登录失败！" + n.errMsg)
                  },
                  fail: function (e) {
                    console.log("uni.login调用失败", e)
                  }
                })
              },
              goTo: function (t) {
                e.navigateTo({
                  url: t
                })
              },
              MergeArray: function (e, t) {
                for (var n = new Array, o = 0; o < e.length; o++) n.push(e[o]);
                for (o = 0; o < t.length; o++) {
                  for (var i = !0, u = 0; u < e.length; u++)
                    if (t[o] == e[u]) {
                      i = !1;
                      break
                    } i && n.push(t[o])
                }
                return n
              },
              goSwiper: function (t) {
                var n = t,
                  o = this.swiper[n].post[0].cid,
                  i = this.swiper[n].post[0].title;
                e.navigateTo({
                  url: "/subPage/commen/appdetails?cid=" + o + "&name=" + i
                }), console.log(o)
              },
              goDetails: function (t, n) {
                e.navigateTo({
                  url: "/subPage/commen/appdetails?id=" + t + "&name=" + n
                })
              },
              goPost: function () {
                var t = this.swiper[0].posts;
                if ("0" === t) {
                  var n = this.swiper[0].qqfurm;
                  plus.runtime.openURL("mqqopensdkapi://bizAgent/qm/qr?url=http%3A%2F%2Fqm.qq.com%2Fcgi-bin%2Fqm%2Fqr%3Ffrom%3Dapp%26p%3Dandroid%26jump_from%3Dwebapi%26k%3D" + n)
                } else e.navigateTo({
                  url: "/subPage/commen/post"
                })
              },
              goSearch: function (t) {
                e.navigateTo({
                  url: "/subPage/commen/appsearchlist?keyword=" + t
                })
              },
              tolink: function () {
                e.navigateTo({
                  url: "/subPage/commen/apptaglist"
                })
              },
              getnewlist: function () {
                var t = this;
                e.request({
                  url: i.default.GetPosts(1, 4),
                  success: function (e) {
                    console.log(e);
                    var n = e.data;
                    "undefined" != typeof n || "none" != e.data ? (t.showlist = !0, t.newList = e.data.data) : t.showlist = !1
                  }
                })
              },
              gethotlist: function () {
                var t = this;
                e.request({
                  url: i.default.GetHot(),
                  success: function (e) {
                    t.hotlist = e.data.data
                  }
                })
              },
              getswiper: function () {
                var t = this;
                e.request({
                  url: i.default.GetSwiperPost(),
                  success: function (e) {
                    for (var n = 0; n < e.data.length; n++) t.swiper.unshift(e.data[n].img)
                  }
                })
              },
              gettag: function () {
                var t = this;
                e.request({
                  url: i.default.GetTag(),
                  success: function (e) {
                    t.tag = e.data.data
                  }
                })
              },
              left: function () {
                console.log("left")
              },
              right: function () {
                console.log("right")
              },
              showMore: function () {
                e.$u.toast("查看更多")
              },
              click: function () {
                console.log("Cell is clicked.")
              },
              rightClick: function () {
                console.log("rightClick")
              },
              radioClick: function (t, n) {
                e.navigateTo({
                  url: "/subPage/commen/commenlist?mid=" + n + "&name=" + t
                })
              }
            }
          };
        t.default = c
      }).call(this, n("df3c")["default"])
    },
    1368: function (e, t, n) {
      "use strict";
      var o = n("a706"),
        i = n.n(o);
      i.a
    },
    "7ff1": function (e, t, n) {
      "use strict";
      (function (e, t) {
        var o = n("47a9");
        n("7882");
        o(n("3240"));
        var i = o(n("873f"));
        e.__webpack_require_UNI_MP_PLUGIN__ = n, t(i.default)
      }).call(this, n("3223")["default"], n("df3c")["createPage"])
    },
    "873f": function (e, t, n) {
      "use strict";
      n.r(t);
      var o = n("fa40"),
        i = n("c44f");
      for (var u in i)["default"].indexOf(u) < 0 && function (e) {
        n.d(t, e, (function () {
          return i[e]
        }))
      }(u);
      n("1368");
      var c = n("828b"),
        s = Object(c["a"])(i["default"], o["b"], o["c"], !1, null, null, null, !1, o["a"], void 0);
      t["default"] = s.exports
    },
    a706: function (e, t, n) {},
    c44f: function (e, t, n) {
      "use strict";
      n.r(t);
      var o = n("09ec"),
        i = n.n(o);
      for (var u in o)["default"].indexOf(u) < 0 && function (e) {
        n.d(t, e, (function () {
          return o[e]
        }))
      }(u);
      t["default"] = i.a
    },
    fa40: function (e, t, n) {
      "use strict";
      n.d(t, "b", (function () {
        return i
      })), n.d(t, "c", (function () {
        return u
      })), n.d(t, "a", (function () {
        return o
      }));
      var o = {
          uSearch: function () {
            return n.e("uni_modules/uview-ui/components/u-search/u-search").then(n.bind(null, "882a"))
          },
          uSwiper: function () {
            return n.e("uni_modules/uview-ui/components/u-swiper/u-swiper").then(n.bind(null, "470f"))
          },
          oGrid: function () {
            return n.e("uni_modules/o-grid/components/o-grid/o-grid").then(n.bind(null, "ef9c"))
          },
          oGridItem: function () {
            return n.e("uni_modules/o-grid/components/o-grid-item/o-grid-item").then(n.bind(null, "94b5"))
          },
          uCellGroup: function () {
            return n.e("uni_modules/uview-ui/components/u-cell-group/u-cell-group").then(n.bind(null, "d5e0"))
          },
          uCellItem: function () {
            return n.e("uni_modules/uview-ui/components/u-cell-item/u-cell-item").then(n.bind(null, "e5a0"))
          },
          zjcScrollNav: function () {
            return n.e("components/zjc-scroll-nav/zjc-scroll-nav").then(n.bind(null, "0158"))
          }
        },
        i = function () {
          var e = this.$createElement;
          this._self._c
        },
        u = []
    }
  },
  [
    ["7ff1", "common/runtime", "common/vendor"]
  ]
]);