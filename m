Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542F12DA876
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 08:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgLOHWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 02:22:30 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2478 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgLOHWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 02:22:15 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Cw8n04Nvhz55B1;
        Tue, 15 Dec 2020 15:20:52 +0800 (CST)
Received: from dggemm753-chm.china.huawei.com (10.1.198.59) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 15 Dec 2020 15:21:29 +0800
Received: from dggpemm000001.china.huawei.com (7.185.36.245) by
 dggemm753-chm.china.huawei.com (10.1.198.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Tue, 15 Dec 2020 15:21:29 +0800
Received: from dggpemm000001.china.huawei.com ([7.185.36.245]) by
 dggpemm000001.china.huawei.com ([7.185.36.245]) with mapi id 15.01.1913.007;
 Tue, 15 Dec 2020 15:21:29 +0800
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
Subject: RE: [PATCH RFC v4 09/15] target/riscv: Add host cpu type
Thread-Topic: [PATCH RFC v4 09/15] target/riscv: Add host cpu type
Thread-Index: AQHWyXJ9oK/dWmr7MUmMCa2h97amm6ntSBCAgAqKhbA=
Date:   Tue, 15 Dec 2020 07:21:29 +0000
Message-ID: <8098caa00cdd4bda81a6ff2af62b5acd@huawei.com>
References: <20201203124703.168-1-jiangyifei@huawei.com>
 <20201203124703.168-10-jiangyifei@huawei.com>
 <CAKmqyKMDWzBf29MgG7BsGTmweH7ZCRVqwCCqC620QoO776=cww@mail.gmail.com>
In-Reply-To: <CAKmqyKMDWzBf29MgG7BsGTmweH7ZCRVqwCCqC620QoO776=cww@mail.gmail.com>
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
ciA5LCAyMDIwIDY6MjIgQU0NCj4gVG86IEppYW5neWlmZWkgPGppYW5neWlmZWlAaHVhd2VpLmNv
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
Z2hhaWxpYW5nQGh1YXdlaS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggUkZDIHY0IDA5LzE1
XSB0YXJnZXQvcmlzY3Y6IEFkZCBob3N0IGNwdSB0eXBlDQo+IA0KPiBPbiBUaHUsIERlYyAzLCAy
MDIwIGF0IDQ6NTUgQU0gWWlmZWkgSmlhbmcgPGppYW5neWlmZWlAaHVhd2VpLmNvbT4gd3JvdGU6
DQo+ID4NCj4gPiBDdXJyZW50bHksIGhvc3QgY3B1IGlzIGluaGVyaXRlZCBzaW1wbHkuDQo+ID4N
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBZaWZlaSBKaWFuZyA8amlhbmd5aWZlaUBodWF3ZWkuY29tPg0K
PiA+IFNpZ25lZC1vZmYtYnk6IFlpcGVuZyBZaW4gPHlpbnlpcGVuZzFAaHVhd2VpLmNvbT4NCj4g
PiAtLS0NCj4gPiAgdGFyZ2V0L3Jpc2N2L2NwdS5jIHwgNiArKysrKysNCj4gPiAgdGFyZ2V0L3Jp
c2N2L2NwdS5oIHwgMSArDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspDQo+
ID4NCj4gPiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L3Jpc2N2L2NwdS5jIGIvdGFyZ2V0L3Jpc2N2L2Nw
dS5jIGluZGV4DQo+ID4gZmFlZTk4YTU4Yy4uNDM5ZGM4OWVlNyAxMDA2NDQNCj4gPiAtLS0gYS90
YXJnZXQvcmlzY3YvY3B1LmMNCj4gPiArKysgYi90YXJnZXQvcmlzY3YvY3B1LmMNCj4gPiBAQCAt
MTg2LDYgKzE4NiwxMCBAQCBzdGF0aWMgdm9pZCBydjMyX2ltYWZjdV9ub21tdV9jcHVfaW5pdChP
YmplY3QNCj4gPiAqb2JqKQ0KPiA+DQo+ID4gICNlbmRpZg0KPiA+DQo+ID4gK3N0YXRpYyB2b2lk
IHJpc2N2X2hvc3RfY3B1X2luaXQoT2JqZWN0ICpvYmopIHsgfQ0KPiA+ICsNCj4gPiAgc3RhdGlj
IE9iamVjdENsYXNzICpyaXNjdl9jcHVfY2xhc3NfYnlfbmFtZShjb25zdCBjaGFyICpjcHVfbW9k
ZWwpICB7DQo+ID4gICAgICBPYmplY3RDbGFzcyAqb2M7DQo+ID4gQEAgLTY0MSwxMCArNjQ1LDEy
IEBAIHN0YXRpYyBjb25zdCBUeXBlSW5mbyByaXNjdl9jcHVfdHlwZV9pbmZvc1tdID0gew0KPiA+
ICAgICAgREVGSU5FX0NQVShUWVBFX1JJU0NWX0NQVV9TSUZJVkVfRTMxLA0KPiBydnh4X3NpZml2
ZV9lX2NwdV9pbml0KSwNCj4gPiAgICAgIERFRklORV9DUFUoVFlQRV9SSVNDVl9DUFVfU0lGSVZF
X0UzNCwNCj4gcnYzMl9pbWFmY3Vfbm9tbXVfY3B1X2luaXQpLA0KPiA+ICAgICAgREVGSU5FX0NQ
VShUWVBFX1JJU0NWX0NQVV9TSUZJVkVfVTM0LA0KPiBydnh4X3NpZml2ZV91X2NwdV9pbml0KSwN
Cj4gPiArICAgIERFRklORV9DUFUoVFlQRV9SSVNDVl9DUFVfSE9TVCwNCj4gcmlzY3ZfaG9zdF9j
cHVfaW5pdCksDQo+ID4gICNlbGlmIGRlZmluZWQoVEFSR0VUX1JJU0NWNjQpDQo+ID4gICAgICBE
RUZJTkVfQ1BVKFRZUEVfUklTQ1ZfQ1BVX0JBU0U2NCwNCj4gcmlzY3ZfYmFzZV9jcHVfaW5pdCks
DQo+ID4gICAgICBERUZJTkVfQ1BVKFRZUEVfUklTQ1ZfQ1BVX1NJRklWRV9FNTEsDQo+IHJ2eHhf
c2lmaXZlX2VfY3B1X2luaXQpLA0KPiA+ICAgICAgREVGSU5FX0NQVShUWVBFX1JJU0NWX0NQVV9T
SUZJVkVfVTU0LA0KPiBydnh4X3NpZml2ZV91X2NwdV9pbml0KSwNCj4gPiArICAgIERFRklORV9D
UFUoVFlQRV9SSVNDVl9DUFVfSE9TVCwNCj4gcmlzY3ZfaG9zdF9jcHVfaW5pdCksDQo+IA0KPiBT
aG91bGRuJ3QgdGhpcyBvbmx5IGJlIGluY2x1ZGVkIGlmIEtWTSBpcyBjb25maWd1cmVkPyBBbHNv
IGl0IHNob3VsZCBiZSBzaGFyZWQNCj4gYmV0d2VlbiBSVjMyIGFuZCBSVjY0Lg0KPiANCj4gQWxp
c3RhaXINCj4gDQoNClllcywgSXQgc2hvdWxkIGJlIGluY2x1ZGVkIGJ5IENPTkZJR19LVk0gYW5k
IGJlIHNoYXJlZCBiZXR3ZWVuIFJWMzIgYW5kIFJWNjQuDQoNCllpZmVpDQoNCj4gPiAgI2VuZGlm
DQo+ID4gIH07DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvdGFyZ2V0L3Jpc2N2L2NwdS5oIGIvdGFy
Z2V0L3Jpc2N2L2NwdS5oIGluZGV4DQo+ID4gYWQxYzkwZjc5OC4uNDI4ODg5ODAxOSAxMDA2NDQN
Cj4gPiAtLS0gYS90YXJnZXQvcmlzY3YvY3B1LmgNCj4gPiArKysgYi90YXJnZXQvcmlzY3YvY3B1
LmgNCj4gPiBAQCAtNDMsNiArNDMsNyBAQA0KPiA+ICAjZGVmaW5lIFRZUEVfUklTQ1ZfQ1BVX1NJ
RklWRV9FNTENCj4gUklTQ1ZfQ1BVX1RZUEVfTkFNRSgic2lmaXZlLWU1MSIpDQo+ID4gICNkZWZp
bmUgVFlQRV9SSVNDVl9DUFVfU0lGSVZFX1UzNA0KPiBSSVNDVl9DUFVfVFlQRV9OQU1FKCJzaWZp
dmUtdTM0IikNCj4gPiAgI2RlZmluZSBUWVBFX1JJU0NWX0NQVV9TSUZJVkVfVTU0DQo+IFJJU0NW
X0NQVV9UWVBFX05BTUUoInNpZml2ZS11NTQiKQ0KPiA+ICsjZGVmaW5lIFRZUEVfUklTQ1ZfQ1BV
X0hPU1QNCj4gUklTQ1ZfQ1BVX1RZUEVfTkFNRSgiaG9zdCIpDQo+ID4NCj4gPiAgI2RlZmluZSBS
VjMyICgodGFyZ2V0X3Vsb25nKTEgPDwgKFRBUkdFVF9MT05HX0JJVFMgLSAyKSkgICNkZWZpbmUN
Cj4gPiBSVjY0ICgodGFyZ2V0X3Vsb25nKTIgPDwgKFRBUkdFVF9MT05HX0JJVFMgLSAyKSkNCj4g
PiAtLQ0KPiA+IDIuMTkuMQ0KPiA+DQo+ID4NCg==
