Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC732DA890
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 08:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgLOHdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 02:33:54 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2527 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbgLOHdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 02:33:53 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Cw92Z368szQs69;
        Tue, 15 Dec 2020 15:32:38 +0800 (CST)
Received: from dggemm752-chm.china.huawei.com (10.1.198.58) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 15 Dec 2020 15:33:11 +0800
Received: from dggpemm000001.china.huawei.com (7.185.36.245) by
 dggemm752-chm.china.huawei.com (10.1.198.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Tue, 15 Dec 2020 15:33:11 +0800
Received: from dggpemm000001.china.huawei.com ([7.185.36.245]) by
 dggpemm000001.china.huawei.com ([7.185.36.245]) with mapi id 15.01.1913.007;
 Tue, 15 Dec 2020 15:33:11 +0800
From:   Jiangyifei <jiangyifei@huawei.com>
To:     Alistair Francis <alistair23@gmail.com>
CC:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        "Zhangxiaofeng (F)" <victor.zhangxiaofeng@huawei.com>,
        Sagar Karandikar <sagark@eecs.berkeley.edu>,
        "open list:Overall" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Anup Patel <anup.patel@wdc.com>,
        yinyipeng <yinyipeng1@huawei.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "Palmer Dabbelt" <palmer@dabbelt.com>,
        "dengkai (A)" <dengkai1@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>
Subject: RE: [PATCH RFC v4 07/15] hw/riscv: PLIC update external interrupt by
 KVM when kvm enabled
Thread-Topic: [PATCH RFC v4 07/15] hw/riscv: PLIC update external interrupt by
 KVM when kvm enabled
Thread-Index: AQHWyXJ3Z8M1hD5DZEKuvvnK52oxEKntSkOAgAqLccA=
Date:   Tue, 15 Dec 2020 07:33:11 +0000
Message-ID: <9845536243684e55b20fb9336229babe@huawei.com>
References: <20201203124703.168-1-jiangyifei@huawei.com>
 <20201203124703.168-8-jiangyifei@huawei.com>
 <CAKmqyKMXmCPyMmo_OHdeVZCjN1k_Lv9n_FVFe9pvbnoHhVSL1g@mail.gmail.com>
In-Reply-To: <CAKmqyKMXmCPyMmo_OHdeVZCjN1k_Lv9n_FVFe9pvbnoHhVSL1g@mail.gmail.com>
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

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFsaXN0YWlyIEZyYW5jaXMg
W21haWx0bzphbGlzdGFpcjIzQGdtYWlsLmNvbV0NCj4gU2VudDogV2VkbmVzZGF5LCBEZWNlbWJl
ciA5LCAyMDIwIDY6MzAgQU0NCj4gVG86IEppYW5neWlmZWkgPGppYW5neWlmZWlAaHVhd2VpLmNv
bT4NCj4gQ2M6IHFlbXUtZGV2ZWxAbm9uZ251Lm9yZyBEZXZlbG9wZXJzIDxxZW11LWRldmVsQG5v
bmdudS5vcmc+OyBvcGVuDQo+IGxpc3Q6UklTQy1WIDxxZW11LXJpc2N2QG5vbmdudS5vcmc+OyBa
aGFuZ3hpYW9mZW5nIChGKQ0KPiA8dmljdG9yLnpoYW5neGlhb2ZlbmdAaHVhd2VpLmNvbT47IFNh
Z2FyIEthcmFuZGlrYXINCj4gPHNhZ2Fya0BlZWNzLmJlcmtlbGV5LmVkdT47IG9wZW4gbGlzdDpP
dmVyYWxsIDxrdm1Admdlci5rZXJuZWwub3JnPjsNCj4gbGlidmlyLWxpc3RAcmVkaGF0LmNvbTsg
QmFzdGlhbiBLb3BwZWxtYW5uDQo+IDxrYmFzdGlhbkBtYWlsLnVuaS1wYWRlcmJvcm4uZGU+OyBB
bnVwIFBhdGVsIDxhbnVwLnBhdGVsQHdkYy5jb20+Ow0KPiB5aW55aXBlbmcgPHlpbnlpcGVuZzFA
aHVhd2VpLmNvbT47IEFsaXN0YWlyIEZyYW5jaXMNCj4gPEFsaXN0YWlyLkZyYW5jaXNAd2RjLmNv
bT47IGt2bS1yaXNjdkBsaXN0cy5pbmZyYWRlYWQub3JnOyBQYWxtZXIgRGFiYmVsdA0KPiA8cGFs
bWVyQGRhYmJlbHQuY29tPjsgZGVuZ2thaSAoQSkgPGRlbmdrYWkxQGh1YXdlaS5jb20+OyBXdWJp
biAoSCkNCj4gPHd1Lnd1YmluQGh1YXdlaS5jb20+OyBaaGFuZ2hhaWxpYW5nIDx6aGFuZy56aGFu
Z2hhaWxpYW5nQGh1YXdlaS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggUkZDIHY0IDA3LzE1
XSBody9yaXNjdjogUExJQyB1cGRhdGUgZXh0ZXJuYWwgaW50ZXJydXB0IGJ5DQo+IEtWTSB3aGVu
IGt2bSBlbmFibGVkDQo+IA0KPiBPbiBUaHUsIERlYyAzLCAyMDIwIGF0IDQ6NDcgQU0gWWlmZWkg
SmlhbmcgPGppYW5neWlmZWlAaHVhd2VpLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBPbmx5IHN1cHBv
cnQgc3VwZXJ2aXNvciBleHRlcm5hbCBpbnRlcnJ1cHQgY3VycmVudGx5Lg0KPiA+DQo+ID4gU2ln
bmVkLW9mZi1ieTogWWlmZWkgSmlhbmcgPGppYW5neWlmZWlAaHVhd2VpLmNvbT4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBZaXBlbmcgWWluIDx5aW55aXBlbmcxQGh1YXdlaS5jb20+DQo+ID4gLS0tDQo+
ID4gIGh3L2ludGMvc2lmaXZlX3BsaWMuYyAgICB8IDMxICsrKysrKysrKysrKysrKysrKysrKyst
LS0tLS0tLS0NCj4gPiAgdGFyZ2V0L3Jpc2N2L2t2bS5jICAgICAgIHwgMTkgKysrKysrKysrKysr
KysrKysrKw0KPiA+ICB0YXJnZXQvcmlzY3Yva3ZtX3Jpc2N2LmggfCAgMSArDQo+ID4gIDMgZmls
ZXMgY2hhbmdlZCwgNDIgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRp
ZmYgLS1naXQgYS9ody9pbnRjL3NpZml2ZV9wbGljLmMgYi9ody9pbnRjL3NpZml2ZV9wbGljLmMg
aW5kZXgNCj4gPiA5N2ExYTI3YTlhLi5hNDE5Y2EzYTNjIDEwMDY0NA0KPiA+IC0tLSBhL2h3L2lu
dGMvc2lmaXZlX3BsaWMuYw0KPiA+ICsrKyBiL2h3L2ludGMvc2lmaXZlX3BsaWMuYw0KPiA+IEBA
IC0zMSw2ICszMSw4IEBADQo+ID4gICNpbmNsdWRlICJ0YXJnZXQvcmlzY3YvY3B1LmgiDQo+ID4g
ICNpbmNsdWRlICJzeXNlbXUvc3lzZW11LmgiDQo+ID4gICNpbmNsdWRlICJtaWdyYXRpb24vdm1z
dGF0ZS5oIg0KPiA+ICsjaW5jbHVkZSAic3lzZW11L2t2bS5oIg0KPiA+ICsjaW5jbHVkZSAia3Zt
X3Jpc2N2LmgiDQo+ID4NCj4gPiAgI2RlZmluZSBSSVNDVl9ERUJVR19QTElDIDANCj4gPg0KPiA+
IEBAIC0xNDcsMTUgKzE0OSwyNiBAQCBzdGF0aWMgdm9pZCBzaWZpdmVfcGxpY191cGRhdGUoU2lG
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
ICB9DQo+ID4gKyNpZmRlZiBDT05GSUdfS1ZNDQo+ID4gKyAgICAgICAgICAgIGt2bV9yaXNjdl9z
ZXRfaXJxKFJJU0NWX0NQVShjcHUpLCBJUlFfU19FWFQsIGxldmVsKTsNCj4gPiArI2VuZGlmDQo+
IA0KPiBXaGF0IGlmIGt2bV9lbmFsYmVkKCkgaXMgdHJ1ZSwgYnV0IENPTkZJR19LVk0gaXNuJ3Qg
ZGVmaW5lZD8NCj4gDQo+IEFsaXN0YWlyDQo+IA0KDQpJbXBvc3NpYmxlLiBJdCB3aWxsIGNhdXNl
IGNvbXBpbGF0aW9uIGZhaWx1cmUgd2l0aG91dCBDT05GSUdfS1ZNLiBXZSBhbHNvDQppbnRyb2R1
Y2Uga3ZtLXN0dWIuYyB0byBzb2x2ZSB0aGUgY29tcGlsYXRpb24gZmFpbHVyZSBsaWtlIG90aGVy
IGFyY2hpdGVjdHVyZXMuDQoNCldlIHdpbGwgaW50cm9kdWNlIGt2bS1zdHViLmMgaW4gbmV4dCBz
ZXJpZXMuDQoNCllpZmVpDQoNCj4gPiArICAgICAgICB9IGVsc2Ugew0KPiA+ICsgICAgICAgICAg
ICBzd2l0Y2ggKG1vZGUpIHsNCj4gPiArICAgICAgICAgICAgY2FzZSBQTElDTW9kZV9NOg0KPiA+
ICsgICAgICAgICAgICAgICAgcmlzY3ZfY3B1X3VwZGF0ZV9taXAoUklTQ1ZfQ1BVKGNwdSksDQo+
ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBNSVBfTUVJUCwNCj4gQk9P
TF9UT19NQVNLKGxldmVsKSk7DQo+ID4gKyAgICAgICAgICAgICAgICBicmVhazsNCj4gPiArICAg
ICAgICAgICAgY2FzZSBQTElDTW9kZV9TOg0KPiA+ICsgICAgICAgICAgICAgICAgcmlzY3ZfY3B1
X3VwZGF0ZV9taXAoUklTQ1ZfQ1BVKGNwdSksDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBNSVBfU0VJUCwNCj4gQk9PTF9UT19NQVNLKGxldmVsKSk7DQo+ID4gKyAg
ICAgICAgICAgICAgICBicmVhazsNCj4gPiArICAgICAgICAgICAgZGVmYXVsdDoNCj4gPiArICAg
ICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICsgICAgICAgICAgICB9DQo+ID4gICAgICAgICAgfQ0K
PiA+ICAgICAgfQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL3RhcmdldC9yaXNjdi9rdm0uYyBiL3Rh
cmdldC9yaXNjdi9rdm0uYyBpbmRleA0KPiA+IDYyNTBjYTBjN2QuLmIwMWZmMDc1NGMgMTAwNjQ0
DQo+ID4gLS0tIGEvdGFyZ2V0L3Jpc2N2L2t2bS5jDQo+ID4gKysrIGIvdGFyZ2V0L3Jpc2N2L2t2
bS5jDQo+ID4gQEAgLTQ1NCwzICs0NTQsMjIgQEAgdm9pZCBrdm1fcmlzY3ZfcmVzZXRfdmNwdShS
SVNDVkNQVSAqY3B1KQ0KPiA+ICAgICAgZW52LT5zYXRwID0gMDsNCj4gPiAgfQ0KPiA+DQo+ID4g
K3ZvaWQga3ZtX3Jpc2N2X3NldF9pcnEoUklTQ1ZDUFUgKmNwdSwgaW50IGlycSwgaW50IGxldmVs
KSB7DQo+ID4gKyAgICBpbnQgcmV0Ow0KPiA+ICsgICAgdW5zaWduZWQgdmlycSA9IGxldmVsID8g
S1ZNX0lOVEVSUlVQVF9TRVQgOg0KPiBLVk1fSU5URVJSVVBUX1VOU0VUOw0KPiA+ICsNCj4gPiAr
ICAgIGlmIChpcnEgIT0gSVJRX1NfRVhUKSB7DQo+ID4gKyAgICAgICAgcmV0dXJuOw0KPiA+ICsg
ICAgfQ0KPiA+ICsNCj4gPiArICAgIGlmICgha3ZtX2VuYWJsZWQoKSkgew0KPiA+ICsgICAgICAg
IHJldHVybjsNCj4gPiArICAgIH0NCj4gPiArDQo+ID4gKyAgICByZXQgPSBrdm1fdmNwdV9pb2N0
bChDUFUoY3B1KSwgS1ZNX0lOVEVSUlVQVCwgJnZpcnEpOw0KPiA+ICsgICAgaWYgKHJldCA8IDAp
IHsNCj4gPiArICAgICAgICBwZXJyb3IoIlNldCBpcnEgZmFpbGVkIik7DQo+ID4gKyAgICAgICAg
YWJvcnQoKTsNCj4gPiArICAgIH0NCj4gPiArfQ0KPiA+IGRpZmYgLS1naXQgYS90YXJnZXQvcmlz
Y3Yva3ZtX3Jpc2N2LmggYi90YXJnZXQvcmlzY3Yva3ZtX3Jpc2N2LmggaW5kZXgNCj4gPiBmMzhj
ODJiZjU5Li5lZDI4MWJkY2UwIDEwMDY0NA0KPiA+IC0tLSBhL3RhcmdldC9yaXNjdi9rdm1fcmlz
Y3YuaA0KPiA+ICsrKyBiL3RhcmdldC9yaXNjdi9rdm1fcmlzY3YuaA0KPiA+IEBAIC0yMCw1ICsy
MCw2IEBADQo+ID4gICNkZWZpbmUgUUVNVV9LVk1fUklTQ1ZfSA0KPiA+DQo+ID4gIHZvaWQga3Zt
X3Jpc2N2X3Jlc2V0X3ZjcHUoUklTQ1ZDUFUgKmNwdSk7DQo+ID4gK3ZvaWQga3ZtX3Jpc2N2X3Nl
dF9pcnEoUklTQ1ZDUFUgKmNwdSwgaW50IGlycSwgaW50IGxldmVsKTsNCj4gPg0KPiA+ICAjZW5k
aWYNCj4gPiAtLQ0KPiA+IDIuMTkuMQ0KPiA+DQo+ID4NCg==
