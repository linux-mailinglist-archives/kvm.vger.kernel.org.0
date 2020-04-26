Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70A31B8BDD
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 06:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgDZEJm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Apr 2020 00:09:42 -0400
Received: from mx22.baidu.com ([220.181.50.185]:55824 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725979AbgDZEJm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Apr 2020 00:09:42 -0400
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id D6C331B46E93A0046C65;
        Sun, 26 Apr 2020 11:22:35 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Sun, 26 Apr 2020 11:22:35 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Sun, 26 Apr 2020 11:22:35 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBbUkZDXSBrdm06IHg4NjogZW11bGF0ZSBBUEVSRi9N?=
 =?gb2312?Q?PERF_registers?=
Thread-Topic: [PATCH] [RFC] kvm: x86: emulate APERF/MPERF registers
Thread-Index: AQHWGh9bZdasuQhOo023NQfHi2P1S6iH0+aAgALlLmA=
Date:   Sun, 26 Apr 2020 03:22:35 +0000
Message-ID: <49b5870b24184a18aaac08382a023b29@baidu.com>
References: <1587704935-30960-1-git-send-email-lirongqing@baidu.com>
 <20200424100143.GZ20730@hirez.programming.kicks-ass.net>
 <20200424144625.GB30013@linux.intel.com>
In-Reply-To: <20200424144625.GB30013@linux.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.27]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex14_2020-04-26 11:22:35:825
x-baidu-bdmsfe-viruscheck: BC-Mail-Ex14_GRAY_Inside_WithoutAtta_2020-04-26
 11:22:35:700
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiAtLS0tLdPKvP7Urbz+LS0tLS0NCj4gt6K8/sjLOiBTZWFuIENocmlzdG9waGVyc29uIFttYWls
dG86c2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbV0NCj4gt6LLzcqxvOQ6IDIwMjDE6jTU
wjI0yNUgMjI6NDYNCj4gytW8/sjLOiBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5v
cmc+DQo+ILOty806IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT47IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IHg4NkBrZXJuZWwu
b3JnOyBocGFAenl0b3IuY29tOyBicEBhbGllbjguZGU7DQo+IG1pbmdvQHJlZGhhdC5jb207IHRn
bHhAbGludXRyb25peC5kZTsgam9yb0A4Ynl0ZXMub3JnOw0KPiBqbWF0dHNvbkBnb29nbGUuY29t
OyB3YW5wZW5nbGlAdGVuY2VudC5jb207IHZrdXpuZXRzQHJlZGhhdC5jb207DQo+IHBib256aW5p
QHJlZGhhdC5jb20NCj4g1vfM4jogUmU6IFtQQVRDSF0gW1JGQ10ga3ZtOiB4ODY6IGVtdWxhdGUg
QVBFUkYvTVBFUkYgcmVnaXN0ZXJzDQo+IA0KPiBPbiBGcmksIEFwciAyNCwgMjAyMCBhdCAxMjow
MTo0M1BNICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToNCj4gPiBPbiBGcmksIEFwciAyNCwg
MjAyMCBhdCAwMTowODo1NVBNICswODAwLCBMaSBSb25nUWluZyB3cm90ZToNCj4gPiA+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rdm0vY3B1aWQuYyBiL2FyY2gveDg2L2t2bS9jcHVpZC5jIGluZGV4
DQo+ID4gPiA5MDFjZDFmZGVjZDkuLjAwZTQ5OTNjYjMzOCAxMDA2NDQNCj4gPiA+IC0tLSBhL2Fy
Y2gveDg2L2t2bS9jcHVpZC5jDQo+ID4gPiArKysgYi9hcmNoL3g4Ni9rdm0vY3B1aWQuYw0KPiA+
ID4gQEAgLTU1OCw3ICs1NTgsMTAgQEAgc3RhdGljIGlubGluZSBpbnQgX19kb19jcHVpZF9mdW5j
KHN0cnVjdA0KPiBrdm1fY3B1aWRfYXJyYXkgKmFycmF5LCB1MzIgZnVuY3Rpb24pDQo+ID4gPiAg
CWNhc2UgNjogLyogVGhlcm1hbCBtYW5hZ2VtZW50ICovDQo+ID4gPiAgCQllbnRyeS0+ZWF4ID0g
MHg0OyAvKiBhbGxvdyBBUkFUICovDQo+ID4gPiAgCQllbnRyeS0+ZWJ4ID0gMDsNCj4gPiA+IC0J
CWVudHJ5LT5lY3ggPSAwOw0KPiA+ID4gKwkJaWYgKGJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9B
UEVSRk1QRVJGKSkNCj4gPiA+ICsJCQllbnRyeS0+ZWN4ID0gMHgxOw0KPiA+ID4gKwkJZWxzZQ0K
PiA+ID4gKwkJCWVudHJ5LT5lY3ggPSAweDA7DQo+ID4gPiAgCQllbnRyeS0+ZWR4ID0gMDsNCj4g
PiA+ICAJCWJyZWFrOw0KPiA+ID4gIAkvKiBmdW5jdGlvbiA3IGhhcyBhZGRpdGlvbmFsIGluZGV4
LiAqLw0KPiA+DQo+ID4gQUZBSUNUIHRoaXMgaXMgZ2VuZXJpYyB4ODYgY29kZSwgdGhhdCBpcywg
dGhpcyB3aWxsIHRlbGwgYW4gQU1EIFNWTQ0KPiA+IGd1ZXN0IGl0IGhhcyBBUEVSRk1QRVJGIG9u
Lg0KPiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gv
eDg2L2t2bS92bXgvdm14LmMgaW5kZXgNCj4gPiA+IDkxNzQ5ZjEyNTRlOC4uZjIwMjE2ZmMwYjU3
IDEwMDY0NA0KPiA+ID4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiA+ID4gKysrIGIv
YXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiA+ID4gQEAgLTEwNjQsNiArMTA2NCwxMSBAQCBzdGF0
aWMgaW5saW5lIHZvaWQgcHRfc2F2ZV9tc3Ioc3RydWN0IHB0X2N0eA0KPiA+ID4gKmN0eCwgdTMy
IGFkZHJfcmFuZ2UpDQo+ID4gPg0KPiA+ID4gIHN0YXRpYyB2b2lkIHB0X2d1ZXN0X2VudGVyKHN0
cnVjdCB2Y3B1X3ZteCAqdm14KSAgew0KPiA+ID4gKwlzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUgPSAm
dm14LT52Y3B1Ow0KPiA+ID4gKw0KPiA+ID4gKwlyZG1zcmwoTVNSX0lBMzJfTVBFUkYsIHZjcHUt
PmFyY2guaG9zdF9tcGVyZik7DQo+ID4gPiArCXJkbXNybChNU1JfSUEzMl9BUEVSRiwgdmNwdS0+
YXJjaC5ob3N0X2FwZXJmKTsNCj4gDQo+IFdoeSBhcmUgdGhlc2UgYnVyaWVkIGluIFByb2Nlc3Nv
ciBUcmFjZSBjb2RlPyAgSXMgQVBFUkZNRVJGIGluIGFueSB3YXkNCj4gZGVwZW5kZW50IG9uIFBU
Pw0KPiANCg0KTm87DQpJIHdpbGwgbW92ZSBpdCBvdXQgUFQgY29kZXMNCg0KPiA+ID4gKw0KPiA+
ID4gIAlpZiAodm14X3B0X21vZGVfaXNfc3lzdGVtKCkpDQo+ID4gPiAgCQlyZXR1cm47DQo+ID4g
Pg0KPiA+ID4gQEAgLTEwODEsNiArMTA4NiwxNSBAQCBzdGF0aWMgdm9pZCBwdF9ndWVzdF9lbnRl
cihzdHJ1Y3QgdmNwdV92bXgNCj4gPiA+ICp2bXgpDQo+ID4gPg0KPiA+ID4gIHN0YXRpYyB2b2lk
IHB0X2d1ZXN0X2V4aXQoc3RydWN0IHZjcHVfdm14ICp2bXgpICB7DQo+ID4gPiArCXN0cnVjdCBr
dm1fdmNwdSAqdmNwdSA9ICZ2bXgtPnZjcHU7DQo+ID4gPiArCXU2NCBwZXJmOw0KPiA+ID4gKw0K
PiA+ID4gKwlyZG1zcmwoTVNSX0lBMzJfTVBFUkYsIHBlcmYpOw0KPiA+ID4gKwl2Y3B1LT5hcmNo
LnZfbXBlcmYgKz0gcGVyZiAtIHZjcHUtPmFyY2guaG9zdF9tcGVyZjsNCj4gPiA+ICsNCj4gPiA+
ICsJcmRtc3JsKE1TUl9JQTMyX0FQRVJGLCBwZXJmKTsNCj4gPiA+ICsJdmNwdS0+YXJjaC52X2Fw
ZXJmICs9IHBlcmYgLSB2Y3B1LT5hcmNoLmhvc3RfYXBlcmY7DQo+IA0KPiBUaGlzIHJlcXVpcmVz
IGZvdXIgUkRNU1JzIHBlciBWTVggdHJhbnNpdGlvbi4gIERvaW5nIHRoYXQgdW5jb25kaXRpb25h
bGx5IHdpbGwNCj4gZHJhc3RpY2FsbHkgaW1wYWN0IHBlcmZvcm1hbmNlLiAgTm90IHRvIG1lbnRp
b24gdGhhdCByZWFkaW5nIHRoZSBNU1JzDQo+IHdpdGhvdXQgY2hlY2tpbmcgZm9yIGhvc3Qgc3Vw
cG9ydCB3aWxsIGdlbmVyYXRlICNHUHMgYW5kIFdBUk5zIG9uIGhhcmR3YXJlDQo+IHdpdGhvdXQg
QVBFUkZNUEVSRi4NCj4gDQo+IEFzc3VtaW5nIHdlJ3JlIGdvaW5nIGZvcndhcmQgd2l0aCB0aGlz
LCBhdCBhbiBhYnNvbHV0ZSBtaW5pbXVtIHRoZSBSRE1TUnMNCj4gbmVlZCB0byBiZSB3cmFwcGVk
IHdpdGggY2hlY2tzIG9uIGhvc3QgX2FuZF8gZ3Vlc3Qgc3VwcG9ydCBmb3IgdGhlIGVtdWxhdGVk
DQo+IGJlaGF2aW9yLiAgR2l2ZW4gdGhlIHNpZ25pZmljYW50IG92ZXJoZWFkLCB0aGlzIG1pZ2h0
IGV2ZW4gYmUgc29tZXRoaW5nIHRoYXQNCj4gc2hvdWxkIHJlcXVpcmUgYW4gZXh0cmEgb3B0LWlu
IGZyb20gdXNlcnNwYWNlIHRvIGVuYWJsZS4NCj4gDQoNCndpbGwgZG8gYXMgeW91ciBzdWdnZXN0
aW9uIA0KDQo+ID4gPiArDQo+ID4gPiAgCWlmICh2bXhfcHRfbW9kZV9pc19zeXN0ZW0oKSkNCj4g
PiA+ICAJCXJldHVybjsNCj4gPiA+DQo+ID4gPiBAQCAtMTkxNCw2ICsxOTI4LDEyIEBAIHN0YXRp
YyBpbnQgdm14X2dldF9tc3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiBzdHJ1Y3QgbXNyX2Rh
dGEgKm1zcl9pbmZvKQ0KPiA+ID4gIAkJICAgICFndWVzdF9jcHVpZF9oYXModmNwdSwgWDg2X0ZF
QVRVUkVfUkRUU0NQKSkNCj4gPiA+ICAJCQlyZXR1cm4gMTsNCj4gPiA+ICAJCWdvdG8gZmluZF9z
aGFyZWRfbXNyOw0KPiA+ID4gKwljYXNlIE1TUl9JQTMyX01QRVJGOg0KPiA+ID4gKwkJbXNyX2lu
Zm8tPmRhdGEgPSB2Y3B1LT5hcmNoLnZfbXBlcmY7DQo+ID4gPiArCQlicmVhazsNCj4gPiA+ICsJ
Y2FzZSBNU1JfSUEzMl9BUEVSRjoNCj4gPiA+ICsJCW1zcl9pbmZvLT5kYXRhID0gdmNwdS0+YXJj
aC52X2FwZXJmOw0KPiA+ID4gKwkJYnJlYWs7DQo+ID4gPiAgCWRlZmF1bHQ6DQo+ID4gPiAgCWZp
bmRfc2hhcmVkX21zcjoNCj4gPiA+ICAJCW1zciA9IGZpbmRfbXNyX2VudHJ5KHZteCwgbXNyX2lu
Zm8tPmluZGV4KTsNCj4gPg0KPiA+IEJ1dCB0aGVuIGhlcmUgeW91IG9ubHkgZW11bGF0ZSBpdCBm
b3IgVk1YLCB3aGljaCB0aGVuIHJlc3VsdHMgaW4gU1ZNDQo+ID4gZ3Vlc3RzIGdvaW5nIHdvYmJs
eS4NCj4gDQo+IFlhLg0KDQpJIHdpbGwgbWFrZSB0aGlzIGNvZGUgc3VpdGFibGUgZm9yIEFNRCBh
bmQgSW50ZWwgY3B1DQoNCj4gDQo+ID4gQWxzbywgb24gSW50ZWwsIHRoZSBtb21lbnQgeW91IGFk
dmVydGlzZSBBUEVSRk1QRVJGLCB3ZSdsbCB0cnkgYW5kDQo+ID4gcmVhZCBNU1JfUExBVEZPUk1f
SU5GTyAvIE1TUl9UVVJCT19SQVRJT19MSU1JVCosIEkgZG9uJ3Qgc3VwcG9zZQ0KPiA+IHlvdSdy
ZSBwYXNzaW5nIHRob3NlIHRocm91Z2ggYXMgd2VsbD8NCj4gDQo+IEFGQUlDVCwgdGhlIHByb3Bv
c2VkIHBhdGNoIGlzbid0IGZ1bGx5IGFkdmVydGlzaW5nIEFQRVJGTVBFUkYsIGl0J3MgYWR2ZXJ0
aXNpbmcNCj4gVHVyYm8gQm9vc3QgLyBEeW5hbWljIEFjY2VsZXJhdGlvbiB0byB0aGUgZ3Vlc3Qg
d2hlbiBBUEVSRk1QRVJGIGNhbiBiZQ0KPiB1c2VkIGJ5IHRoZSBob3N0IHRvIGVtdWxhdGUgSURB
LiAgVGhlIHRyYW5zbGl0ZXJhdGlvbiBvZiB0aGUgYWJvdmUgY29kZSB0byBiZQ0KPiBWTVgtb25s
eSBpczoNCg0KRG8geW91IG1lYW5zIHdoZW4gd2UgZm9yd2FyZCBBUEVSRk1QRVJGIHRvIGd1ZXN0
ICwgZ3Vlc3QgaGFzIHNpbWlsYXIgSURBIGNhcGFiaWxpdHksDQogYW5kIG5vdCBuZWVkIHRvIGNv
bnNpZGVyIE1TUl9QTEFURk9STV9JTkZPIC8gTVNSX1RVUkJPX1JBVElPX0xJTUlUKiA/DQoNCi1M
aQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMgYi9hcmNoL3g4Ni9r
dm0vdm14L3ZteC5jIGluZGV4DQo+IDc2NjMwM2IzMTk0OS4uN2U0NTliNjZiMDZlIDEwMDY0NA0K
PiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgv
dm14LmMNCj4gQEAgLTcxOTEsNiArNzE5MSw5IEBAIHN0YXRpYyBfX2luaXQgdm9pZCB2bXhfc2V0
X2NwdV9jYXBzKHZvaWQpDQo+ICAgICAgICAgaWYgKG5lc3RlZCkNCj4gICAgICAgICAgICAgICAg
IGt2bV9jcHVfY2FwX3NldChYODZfRkVBVFVSRV9WTVgpOw0KPiANCj4gKyAgICAgICBpZiAoYm9v
dF9jcHVfaGFzKFg4Nl9GRUFUVVJFX0FQRVJGTVBFUkYpKQ0KPiArICAgICAgICAgICAgICAga3Zt
X2NwdV9jYXBfc2V0KFg4Nl9GRUFUVVJFX0lEQSk7DQo+ICsNCj4gICAgICAgICAvKiBDUFVJRCAw
eDcgKi8NCj4gICAgICAgICBpZiAoa3ZtX21weF9zdXBwb3J0ZWQoKSkNCj4gICAgICAgICAgICAg
ICAgIGt2bV9jcHVfY2FwX2NoZWNrX2FuZF9zZXQoWDg2X0ZFQVRVUkVfTVBYKTsNCj4gDQo+IEkg
aGF2ZSBubyBjbHVlIGFzIHRvIHdoZXRoZXIgdGhhdCdzIHNhbmUvY29ycmVjdC4NCg==
