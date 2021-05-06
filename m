Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772A3375080
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 09:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbhEFIAg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 04:00:36 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3795 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbhEFIAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 04:00:35 -0400
Received: from dggeml707-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FbQqG0wZqz19LyD;
        Thu,  6 May 2021 15:55:22 +0800 (CST)
Received: from dggpemm000002.china.huawei.com (7.185.36.174) by
 dggeml707-chm.china.huawei.com (10.3.17.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 6 May 2021 15:59:24 +0800
Received: from dggpemm000001.china.huawei.com (7.185.36.245) by
 dggpemm000002.china.huawei.com (7.185.36.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 6 May 2021 15:59:24 +0800
Received: from dggpemm000001.china.huawei.com ([7.185.36.245]) by
 dggpemm000001.china.huawei.com ([7.185.36.245]) with mapi id 15.01.2176.012;
 Thu, 6 May 2021 15:59:24 +0800
From:   Jiangyifei <jiangyifei@huawei.com>
To:     Anup Patel <anup@brainfault.org>
CC:     Bin Meng <bin.meng@windriver.com>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        "KVM General" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Anup Patel <anup.patel@wdc.com>,
        "QEMU Developers" <qemu-devel@nongnu.org>,
        yinyipeng <yinyipeng1@huawei.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "Fanliang (EulerOS)" <fanliang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>
Subject: RE: [PATCH RFC v5 07/12] hw/riscv: PLIC update external interrupt by
 KVM when kvm enabled
Thread-Topic: [PATCH RFC v5 07/12] hw/riscv: PLIC update external interrupt by
 KVM when kvm enabled
Thread-Index: AQHXL2iS97/Gt+zlwEynCeteOmCihKrMFKeAgAok0BA=
Date:   Thu, 6 May 2021 07:59:24 +0000
Message-ID: <057e885d5168477a904943e8ebb5fbbb@huawei.com>
References: <20210412065246.1853-1-jiangyifei@huawei.com>
 <20210412065246.1853-8-jiangyifei@huawei.com>
 <CAAhSdy34aVwGEW-_Z=FkOkrAGrTsaS-11Ck6gJg77wwUSXe=zw@mail.gmail.com>
In-Reply-To: <CAAhSdy34aVwGEW-_Z=FkOkrAGrTsaS-11Ck6gJg77wwUSXe=zw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.186.236]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFFlbXUtcmlzY3YNCj4gW21h
aWx0bzpxZW11LXJpc2N2LWJvdW5jZXMramlhbmd5aWZlaT1odWF3ZWkuY29tQG5vbmdudS5vcmdd
IE9uIEJlaGFsZiBPZg0KPiBBbnVwIFBhdGVsDQo+IFNlbnQ6IEZyaWRheSwgQXByaWwgMzAsIDIw
MjEgMTI6NTQgUE0NCj4gVG86IEppYW5neWlmZWkgPGppYW5neWlmZWlAaHVhd2VpLmNvbT4NCj4g
Q2M6IEJpbiBNZW5nIDxiaW4ubWVuZ0B3aW5kcml2ZXIuY29tPjsgb3BlbiBsaXN0OlJJU0MtVg0K
PiA8cWVtdS1yaXNjdkBub25nbnUub3JnPjsgU2FnYXIgS2FyYW5kaWthciA8c2FnYXJrQGVlY3Mu
YmVya2VsZXkuZWR1PjsNCj4gS1ZNIEdlbmVyYWwgPGt2bUB2Z2VyLmtlcm5lbC5vcmc+OyBsaWJ2
aXItbGlzdEByZWRoYXQuY29tOyBCYXN0aWFuDQo+IEtvcHBlbG1hbm4gPGtiYXN0aWFuQG1haWwu
dW5pLXBhZGVyYm9ybi5kZT47IEFudXAgUGF0ZWwNCj4gPGFudXAucGF0ZWxAd2RjLmNvbT47IFFF
TVUgRGV2ZWxvcGVycyA8cWVtdS1kZXZlbEBub25nbnUub3JnPjsNCj4geWlueWlwZW5nIDx5aW55
aXBlbmcxQGh1YXdlaS5jb20+OyBQYWxtZXIgRGFiYmVsdCA8cGFsbWVyQGRhYmJlbHQuY29tPjsN
Cj4ga3ZtLXJpc2N2QGxpc3RzLmluZnJhZGVhZC5vcmc7IEFsaXN0YWlyIEZyYW5jaXMgPEFsaXN0
YWlyLkZyYW5jaXNAd2RjLmNvbT47DQo+IEZhbmxpYW5nIChFdWxlck9TKSA8ZmFubGlhbmdAaHVh
d2VpLmNvbT47IFd1YmluIChIKQ0KPiA8d3Uud3ViaW5AaHVhd2VpLmNvbT47IFpoYW5naGFpbGlh
bmcgPHpoYW5nLnpoYW5naGFpbGlhbmdAaHVhd2VpLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRD
SCBSRkMgdjUgMDcvMTJdIGh3L3Jpc2N2OiBQTElDIHVwZGF0ZSBleHRlcm5hbCBpbnRlcnJ1cHQg
YnkNCj4gS1ZNIHdoZW4ga3ZtIGVuYWJsZWQNCj4gDQo+IE9uIE1vbiwgQXByIDEyLCAyMDIxIGF0
IDEyOjI0IFBNIFlpZmVpIEppYW5nIDxqaWFuZ3lpZmVpQGh1YXdlaS5jb20+IHdyb3RlOg0KPiA+
DQo+ID4gT25seSBzdXBwb3J0IHN1cGVydmlzb3IgZXh0ZXJuYWwgaW50ZXJydXB0IGN1cnJlbnRs
eS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFlpZmVpIEppYW5nIDxqaWFuZ3lpZmVpQGh1YXdl
aS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogWWlwZW5nIFlpbiA8eWlueWlwZW5nMUBodWF3ZWku
Y29tPg0KPiA+IC0tLQ0KPiA+ICBody9pbnRjL3NpZml2ZV9wbGljLmMgICAgfCAyOSArKysrKysr
KysrKysrKysrKysrKy0tLS0tLS0tLQ0KPiA+ICB0YXJnZXQvcmlzY3Yva3ZtLXN0dWIuYyAgfCAg
NSArKysrKw0KPiA+ICB0YXJnZXQvcmlzY3Yva3ZtLmMgICAgICAgfCAyMCArKysrKysrKysrKysr
KysrKysrKw0KPiA+ICB0YXJnZXQvcmlzY3Yva3ZtX3Jpc2N2LmggfCAgMSArDQo+ID4gIDQgZmls
ZXMgY2hhbmdlZCwgNDYgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRp
ZmYgLS1naXQgYS9ody9pbnRjL3NpZml2ZV9wbGljLmMgYi9ody9pbnRjL3NpZml2ZV9wbGljLmMg
aW5kZXgNCj4gPiA5N2ExYTI3YTlhLi4yNzQ2ZWI3YTA1IDEwMDY0NA0KPiA+IC0tLSBhL2h3L2lu
dGMvc2lmaXZlX3BsaWMuYw0KPiA+ICsrKyBiL2h3L2ludGMvc2lmaXZlX3BsaWMuYw0KPiA+IEBA
IC0zMSw2ICszMSw4IEBADQo+ID4gICNpbmNsdWRlICJ0YXJnZXQvcmlzY3YvY3B1LmgiDQo+ID4g
ICNpbmNsdWRlICJzeXNlbXUvc3lzZW11LmgiDQo+ID4gICNpbmNsdWRlICJtaWdyYXRpb24vdm1z
dGF0ZS5oIg0KPiA+ICsjaW5jbHVkZSAic3lzZW11L2t2bS5oIg0KPiA+ICsjaW5jbHVkZSAia3Zt
X3Jpc2N2LmgiDQo+ID4NCj4gPiAgI2RlZmluZSBSSVNDVl9ERUJVR19QTElDIDANCj4gPg0KPiA+
IEBAIC0xNDcsMTUgKzE0OSwyNCBAQCBzdGF0aWMgdm9pZCBzaWZpdmVfcGxpY191cGRhdGUoU2lG
aXZlUExJQ1N0YXRlICpwbGljKQ0KPiA+ICAgICAgICAgICAgICBjb250aW51ZTsNCj4gPiAgICAg
ICAgICB9DQo+ID4gICAgICAgICAgaW50IGxldmVsID0gc2lmaXZlX3BsaWNfaXJxc19wZW5kaW5n
KHBsaWMsIGFkZHJpZCk7DQo+ID4gLSAgICAgICAgc3dpdGNoIChtb2RlKSB7DQo+ID4gLSAgICAg
ICAgY2FzZSBQTElDTW9kZV9NOg0KPiA+IC0gICAgICAgICAgICByaXNjdl9jcHVfdXBkYXRlX21p
cChSSVNDVl9DUFUoY3B1KSwgTUlQX01FSVAsDQo+IEJPT0xfVE9fTUFTSyhsZXZlbCkpOw0KPiA+
IC0gICAgICAgICAgICBicmVhazsNCj4gPiAtICAgICAgICBjYXNlIFBMSUNNb2RlX1M6DQo+ID4g
LSAgICAgICAgICAgIHJpc2N2X2NwdV91cGRhdGVfbWlwKFJJU0NWX0NQVShjcHUpLCBNSVBfU0VJ
UCwNCj4gQk9PTF9UT19NQVNLKGxldmVsKSk7DQo+ID4gLSAgICAgICAgICAgIGJyZWFrOw0KPiA+
IC0gICAgICAgIGRlZmF1bHQ6DQo+ID4gLSAgICAgICAgICAgIGJyZWFrOw0KPiA+ICsgICAgICAg
IGlmIChrdm1fZW5hYmxlZCgpKSB7DQo+ID4gKyAgICAgICAgICAgIGlmIChtb2RlID09IFBMSUNN
b2RlX00pIHsNCj4gPiArICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KPiA+ICsgICAgICAgICAg
ICB9DQo+ID4gKyAgICAgICAgICAgIGt2bV9yaXNjdl9zZXRfaXJxKFJJU0NWX0NQVShjcHUpLCBJ
UlFfU19FWFQsIGxldmVsKTsNCj4gPiArICAgICAgICB9IGVsc2Ugew0KPiA+ICsgICAgICAgICAg
ICBzd2l0Y2ggKG1vZGUpIHsNCj4gPiArICAgICAgICAgICAgY2FzZSBQTElDTW9kZV9NOg0KPiA+
ICsgICAgICAgICAgICAgICAgcmlzY3ZfY3B1X3VwZGF0ZV9taXAoUklTQ1ZfQ1BVKGNwdSksDQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBNSVBfTUVJUCwNCj4gQk9P
TF9UT19NQVNLKGxldmVsKSk7DQo+ID4gKyAgICAgICAgICAgICAgICBicmVhazsNCj4gPiArICAg
ICAgICAgICAgY2FzZSBQTElDTW9kZV9TOg0KPiA+ICsgICAgICAgICAgICAgICAgcmlzY3ZfY3B1
X3VwZGF0ZV9taXAoUklTQ1ZfQ1BVKGNwdSksDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBNSVBfU0VJUCwNCj4gQk9PTF9UT19NQVNLKGxldmVsKSk7DQo+ID4gKyAg
ICAgICAgICAgICAgICBicmVhazsNCj4gPiArICAgICAgICAgICAgZGVmYXVsdDoNCj4gPiArICAg
ICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICsgICAgICAgICAgICB9DQo+IA0KPiBJIGFtIG5vdCBj
b21mb3J0YWJsZSB3aXRoIHRoaXMgcGF0Y2guDQo+IA0KPiBUaGlzIHdheSB3ZSB3aWxsIGVuZHVw
IGNhbGxpbmcga3ZtX3Jpc2N2X3NldF9pcnEoKSBmcm9tIHZhcmlvdXMgcGxhY2VzIGluDQo+IGh3
L2ludGMgYW5kIGh3L3Jpc2N2Lg0KPiANCj4gSSBzdWdnZXN0IHRvIGV4dGVuZCByaXNjdl9jcHVf
dXBkYXRlX21pcCgpIHN1Y2ggdGhhdCB3aGVuIGt2bSBpcyBlbmFibGVkDQo+IHJpc2N2X2NwdV91
cGRhdGVfbWlwKCkgd2lsbDoNCj4gMSkgQ29uc2lkZXIgb25seSBNSVBfU0VJUCBiaXQgaW4gIm1h
c2siIHBhcmFtZXRlciBhbmQgYWxsIG90aGVyDQo+ICAgICBiaXRzIGluICJtYXNrIiBwYXJhbWV0
ZXIgd2lsbCBiZSBpZ25vcmVkIHByb2JhYmx5IHdpdGggd2FybmluZw0KPiAyKSBXaGVuIHRoZSBN
SVBfU0VJUCBiaXQgaXMgc2V0IGluICJtYXNrIiBjYWxsIGt2bV9yaXNjdl9zZXRfaXJxKCkgdG8g
Y2hhbmdlDQo+IHRoZSBJUlEgc3RhdGUgaW4gdGhlIEtWTSBtb2R1bGUuDQo+IA0KPiBSZWdhcmRz
LA0KPiBBbnVwDQo+IA0KDQpZZXMsIGJ1dCByaXNjdl9jcHVfdXBkYXRlX21pcCgpIGluIHRhcmdl
dC9yaXNjdi9jcHVfaGVscGVyLmMgaXMgdXNlZCB0byBUQ0cuIFNvIGl0IGlzIG5vdA0KYXBwcm9w
cmlhdGUgdG8gYWRhcHQgZm9yIEtWTS4NCg0KV2Ugd2lsbCBtb3ZlIHJpc2N2X2NwdV91cGRhdGVf
bWlwKCkgdG8gdGFyZ2V0L3Jpc2N2L2NwdS5jIGFuZCBtb2RpZnkgaXQgYWNjb3JkaW5nIHlvdXIN
CmFkdmljZS4NCg0KUmVnYXJkcywNCllpZmVpDQoNCj4gPiAgICAgICAgICB9DQo+ID4gICAgICB9
DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L3Jpc2N2L2t2bS1zdHViLmMgYi90YXJnZXQv
cmlzY3Yva3ZtLXN0dWIuYyBpbmRleA0KPiA+IDM5Yjk2ZmUzZjQuLjRlOGZjMzFhMjEgMTAwNjQ0
DQo+ID4gLS0tIGEvdGFyZ2V0L3Jpc2N2L2t2bS1zdHViLmMNCj4gPiArKysgYi90YXJnZXQvcmlz
Y3Yva3ZtLXN0dWIuYw0KPiA+IEBAIC0yMywzICsyMyw4IEBAIHZvaWQga3ZtX3Jpc2N2X3Jlc2V0
X3ZjcHUoUklTQ1ZDUFUgKmNwdSkgIHsNCj4gPiAgICAgIGFib3J0KCk7DQo+ID4gIH0NCj4gPiAr
DQo+ID4gK3ZvaWQga3ZtX3Jpc2N2X3NldF9pcnEoUklTQ1ZDUFUgKmNwdSwgaW50IGlycSwgaW50
IGxldmVsKSB7DQo+ID4gKyAgICBhYm9ydCgpOw0KPiA+ICt9DQo+ID4gZGlmZiAtLWdpdCBhL3Rh
cmdldC9yaXNjdi9rdm0uYyBiL3RhcmdldC9yaXNjdi9rdm0uYyBpbmRleA0KPiA+IDc5YzkzMWFj
YjQuLmRhNjM1MzU4MTIgMTAwNjQ0DQo+ID4gLS0tIGEvdGFyZ2V0L3Jpc2N2L2t2bS5jDQo+ID4g
KysrIGIvdGFyZ2V0L3Jpc2N2L2t2bS5jDQo+ID4gQEAgLTQ1Myw2ICs0NTMsMjYgQEAgdm9pZCBr
dm1fcmlzY3ZfcmVzZXRfdmNwdShSSVNDVkNQVSAqY3B1KQ0KPiA+ICAgICAgZW52LT5ncHJbMTFd
ID0gY3B1LT5lbnYuZmR0X2FkZHI7ICAgICAgICAgIC8qIGExICovDQo+ID4gIH0NCj4gPg0KPiA+
ICt2b2lkIGt2bV9yaXNjdl9zZXRfaXJxKFJJU0NWQ1BVICpjcHUsIGludCBpcnEsIGludCBsZXZl
bCkgew0KPiA+ICsgICAgaW50IHJldDsNCj4gPiArICAgIHVuc2lnbmVkIHZpcnEgPSBsZXZlbCA/
IEtWTV9JTlRFUlJVUFRfU0VUIDoNCj4gS1ZNX0lOVEVSUlVQVF9VTlNFVDsNCj4gPiArDQo+ID4g
KyAgICBpZiAoaXJxICE9IElSUV9TX0VYVCkgew0KPiA+ICsgICAgICAgIHJldHVybjsNCj4gPiAr
ICAgIH0NCj4gPiArDQo+ID4gKyAgICBpZiAoIWt2bV9lbmFibGVkKCkpIHsNCj4gPiArICAgICAg
ICByZXR1cm47DQo+ID4gKyAgICB9DQo+ID4gKw0KPiA+ICsgICAgcmV0ID0ga3ZtX3ZjcHVfaW9j
dGwoQ1BVKGNwdSksIEtWTV9JTlRFUlJVUFQsICZ2aXJxKTsNCj4gPiArICAgIGlmIChyZXQgPCAw
KSB7DQo+ID4gKyAgICAgICAgcGVycm9yKCJTZXQgaXJxIGZhaWxlZCIpOw0KPiA+ICsgICAgICAg
IGFib3J0KCk7DQo+ID4gKyAgICB9DQo+ID4gK30NCj4gPiArDQo+ID4gIGJvb2wga3ZtX2FyY2hf
Y3B1X2NoZWNrX2FyZV9yZXNldHRhYmxlKHZvaWQpDQo+ID4gIHsNCj4gPiAgICAgIHJldHVybiB0
cnVlOw0KPiA+IGRpZmYgLS1naXQgYS90YXJnZXQvcmlzY3Yva3ZtX3Jpc2N2LmggYi90YXJnZXQv
cmlzY3Yva3ZtX3Jpc2N2LmggaW5kZXgNCj4gPiBmMzhjODJiZjU5Li5lZDI4MWJkY2UwIDEwMDY0
NA0KPiA+IC0tLSBhL3RhcmdldC9yaXNjdi9rdm1fcmlzY3YuaA0KPiA+ICsrKyBiL3RhcmdldC9y
aXNjdi9rdm1fcmlzY3YuaA0KPiA+IEBAIC0yMCw1ICsyMCw2IEBADQo+ID4gICNkZWZpbmUgUUVN
VV9LVk1fUklTQ1ZfSA0KPiA+DQo+ID4gIHZvaWQga3ZtX3Jpc2N2X3Jlc2V0X3ZjcHUoUklTQ1ZD
UFUgKmNwdSk7DQo+ID4gK3ZvaWQga3ZtX3Jpc2N2X3NldF9pcnEoUklTQ1ZDUFUgKmNwdSwgaW50
IGlycSwgaW50IGxldmVsKTsNCj4gPg0KPiA+ICAjZW5kaWYNCj4gPiAtLQ0KPiA+IDIuMTkuMQ0K
PiA+DQo+ID4NCj4gPiAtLQ0KPiA+IGt2bS1yaXNjdiBtYWlsaW5nIGxpc3QNCj4gPiBrdm0tcmlz
Y3ZAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiA+IGh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21h
aWxtYW4vbGlzdGluZm8va3ZtLXJpc2N2DQoNCg==
