Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE80546FE5E
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 11:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239796AbhLJKGp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 05:06:45 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16362 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236447AbhLJKGo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 05:06:44 -0500
Received: from canpemm500003.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J9RKJ4qfYz91NF;
        Fri, 10 Dec 2021 18:02:28 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 canpemm500003.china.huawei.com (7.192.105.39) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 18:03:08 +0800
Received: from kwepemm600017.china.huawei.com ([7.193.23.234]) by
 kwepemm600017.china.huawei.com ([7.193.23.234]) with mapi id 15.01.2308.020;
 Fri, 10 Dec 2021 18:03:08 +0800
From:   Jiangyifei <jiangyifei@huawei.com>
To:     Anup Patel <anup@brainfault.org>
CC:     QEMU Developers <qemu-devel@nongnu.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        KVM General <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        "Fanliang (EulerOS)" <fanliang@huawei.com>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>,
        "wanbo (G)" <wanbo13@huawei.com>,
        "limingwang (A)" <limingwang@huawei.com>
Subject: RE: [PATCH v1 10/12] target/riscv: Add kvm_riscv_get/put_regs_timer
Thread-Topic: [PATCH v1 10/12] target/riscv: Add kvm_riscv_get/put_regs_timer
Thread-Index: AQHX3eLRFRepOD3ac02ZrMId1/0A+qwgESyAgAuNNaA=
Date:   Fri, 10 Dec 2021 10:03:08 +0000
Message-ID: <f68f51d29e5748fa9fe31370640e047c@huawei.com>
References: <20211120074644.729-1-jiangyifei@huawei.com>
 <20211120074644.729-11-jiangyifei@huawei.com>
 <CAAhSdy075GcmcMTsVsvgXN+W9Cf7EKCrycnOG9BZAkfKfp3J-w@mail.gmail.com>
In-Reply-To: <CAAhSdy075GcmcMTsVsvgXN+W9Cf7EKCrycnOG9BZAkfKfp3J-w@mail.gmail.com>
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

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFudXAgUGF0ZWwgW21haWx0
bzphbnVwQGJyYWluZmF1bHQub3JnXQ0KPiBTZW50OiBGcmlkYXksIERlY2VtYmVyIDMsIDIwMjEg
NTozOCBQTQ0KPiBUbzogSmlhbmd5aWZlaSA8amlhbmd5aWZlaUBodWF3ZWkuY29tPg0KPiBDYzog
UUVNVSBEZXZlbG9wZXJzIDxxZW11LWRldmVsQG5vbmdudS5vcmc+OyBvcGVuIGxpc3Q6UklTQy1W
DQo+IDxxZW11LXJpc2N2QG5vbmdudS5vcmc+OyBrdm0tcmlzY3ZAbGlzdHMuaW5mcmFkZWFkLm9y
ZzsgS1ZNIEdlbmVyYWwNCj4gPGt2bUB2Z2VyLmtlcm5lbC5vcmc+OyBsaWJ2aXItbGlzdEByZWRo
YXQuY29tOyBBbnVwIFBhdGVsDQo+IDxhbnVwLnBhdGVsQHdkYy5jb20+OyBQYWxtZXIgRGFiYmVs
dCA8cGFsbWVyQGRhYmJlbHQuY29tPjsgQWxpc3RhaXINCj4gRnJhbmNpcyA8QWxpc3RhaXIuRnJh
bmNpc0B3ZGMuY29tPjsgQmluIE1lbmcgPGJpbi5tZW5nQHdpbmRyaXZlci5jb20+Ow0KPiBGYW5s
aWFuZyAoRXVsZXJPUykgPGZhbmxpYW5nQGh1YXdlaS5jb20+OyBXdWJpbiAoSCkNCj4gPHd1Lnd1
YmluQGh1YXdlaS5jb20+OyBXYW5naGFpYmluIChEKSA8d2FuZ2hhaWJpbi53YW5nQGh1YXdlaS5j
b20+Ow0KPiB3YW5ibyAoRykgPHdhbmJvMTNAaHVhd2VpLmNvbT47IGxpbWluZ3dhbmcgKEEpDQo+
IDxsaW1pbmd3YW5nQGh1YXdlaS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEgMTAvMTJd
IHRhcmdldC9yaXNjdjogQWRkIGt2bV9yaXNjdl9nZXQvcHV0X3JlZ3NfdGltZXINCj4gDQo+IE9u
IFNhdCwgTm92IDIwLCAyMDIxIGF0IDE6MTcgUE0gWWlmZWkgSmlhbmcgPGppYW5neWlmZWlAaHVh
d2VpLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBBZGQga3ZtX3Jpc2N2X2dldC9wdXRfcmVnc190aW1l
ciB0byBzeW5jaHJvbml6ZSB2aXJ0dWFsIHRpbWUgY29udGV4dA0KPiA+IGZyb20gS1ZNLg0KPiA+
DQo+ID4gVG8gc2V0IHJlZ2lzdGVyIG9mIFJJU0NWX1RJTUVSX1JFRyhzdGF0ZSkgd2lsbCBvY2N1
ciBhIGVycm9yIGZyb20gS1ZNDQo+ID4gb24ga3ZtX3RpbWVyX3N0YXRlID09IDAuIEl0J3MgYmV0
dGVyIHRvIGFkYXB0IGluIEtWTSwgYnV0IGl0IGRvZXNuJ3QNCj4gPiBtYXR0ZXIgdGhhdCBhZGFw
aW5nIGluIFFFTVUuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZaWZlaSBKaWFuZyA8amlhbmd5
aWZlaUBodWF3ZWkuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IE1pbmd3YW5nIExpIDxsaW1pbmd3
YW5nQGh1YXdlaS5jb20+DQo+ID4gLS0tDQo+ID4gIHRhcmdldC9yaXNjdi9jcHUuaCB8ICA2ICsr
KysNCj4gPiAgdGFyZ2V0L3Jpc2N2L2t2bS5jIHwgNzINCj4gPiArKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgNzggaW5z
ZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL3RhcmdldC9yaXNjdi9jcHUuaCBiL3Rh
cmdldC9yaXNjdi9jcHUuaCBpbmRleA0KPiA+IGU3ZGJhMzVhY2IuLmRlYTQ5ZTUzZjAgMTAwNjQ0
DQo+ID4gLS0tIGEvdGFyZ2V0L3Jpc2N2L2NwdS5oDQo+ID4gKysrIGIvdGFyZ2V0L3Jpc2N2L2Nw
dS5oDQo+ID4gQEAgLTI1OSw2ICsyNTksMTIgQEAgc3RydWN0IENQVVJJU0NWU3RhdGUgew0KPiA+
DQo+ID4gICAgICBod2FkZHIga2VybmVsX2FkZHI7DQo+ID4gICAgICBod2FkZHIgZmR0X2FkZHI7
DQo+ID4gKw0KPiA+ICsgICAgLyoga3ZtIHRpbWVyICovDQo+ID4gKyAgICBib29sIGt2bV90aW1l
cl9kaXJ0eTsNCj4gPiArICAgIHVpbnQ2NF90IGt2bV90aW1lcl90aW1lOw0KPiA+ICsgICAgdWlu
dDY0X3Qga3ZtX3RpbWVyX2NvbXBhcmU7DQo+ID4gKyAgICB1aW50NjRfdCBrdm1fdGltZXJfc3Rh
dGU7DQo+IA0KPiBXZSBzaG91bGQgYWxzbyBpbmNsdWRlIGt2bV90aW1lcl9mcmVxdWVuY3kgaGVy
ZS4NCj4gDQo+IEN1cnJlbnRseSwgaXQgaXMgcmVhZC1vbmx5IGJ1dCBpbi1mdXR1cmUgS1ZNIFJJ
U0MtViB3aWxsIGFsbG93IHNldHRpbmcNCj4gdGltZXJfZnJlcXVlbmN5IHVzaW5nIFNCSSBwYXJh
LXZpcnQgdGltZSBzY2FsaW5nIGV4dGVuc2lvbi4NCj4gDQo+IFJlZ2FyZHMsDQo+IEFudXANCj4g
DQoNCk9rLCBhZGRlZC4NCg0KPiA+ICB9Ow0KPiA+DQo+ID4gIE9CSkVDVF9ERUNMQVJFX1RZUEUo
UklTQ1ZDUFUsIFJJU0NWQ1BVQ2xhc3MsIGRpZmYgLS1naXQNCj4gPiBhL3RhcmdldC9yaXNjdi9r
dm0uYyBiL3RhcmdldC9yaXNjdi9rdm0uYyBpbmRleCA2ZDQxOWJhMDJlLi5lNTcyNTc3MGYyDQo+
ID4gMTAwNjQ0DQo+ID4gLS0tIGEvdGFyZ2V0L3Jpc2N2L2t2bS5jDQo+ID4gKysrIGIvdGFyZ2V0
L3Jpc2N2L2t2bS5jDQo+ID4gQEAgLTY0LDYgKzY0LDkgQEAgc3RhdGljIHVpbnQ2NF90IGt2bV9y
aXNjdl9yZWdfaWQoQ1BVUklTQ1ZTdGF0ZSAqZW52LA0KPiA+IHVpbnQ2NF90IHR5cGUsIHVpbnQ2
NF90IGlkeCAgI2RlZmluZSBSSVNDVl9DU1JfUkVHKGVudiwgbmFtZSkNCj4ga3ZtX3Jpc2N2X3Jl
Z19pZChlbnYsIEtWTV9SRUdfUklTQ1ZfQ1NSLCBcDQo+ID4gICAgICAgICAgICAgICAgICAgS1ZN
X1JFR19SSVNDVl9DU1JfUkVHKG5hbWUpKQ0KPiA+DQo+ID4gKyNkZWZpbmUgUklTQ1ZfVElNRVJf
UkVHKGVudiwgbmFtZSkgIGt2bV9yaXNjdl9yZWdfaWQoZW52LA0KPiBLVk1fUkVHX1JJU0NWX1RJ
TUVSLCBcDQo+ID4gKyAgICAgICAgICAgICAgICAgS1ZNX1JFR19SSVNDVl9USU1FUl9SRUcobmFt
ZSkpDQo+ID4gKw0KPiA+ICAjZGVmaW5lIFJJU0NWX0ZQX0ZfUkVHKGVudiwgaWR4KSAga3ZtX3Jp
c2N2X3JlZ19pZChlbnYsDQo+ID4gS1ZNX1JFR19SSVNDVl9GUF9GLCBpZHgpDQo+ID4NCj4gPiAg
I2RlZmluZSBSSVNDVl9GUF9EX1JFRyhlbnYsIGlkeCkgIGt2bV9yaXNjdl9yZWdfaWQoZW52LA0K
PiA+IEtWTV9SRUdfUklTQ1ZfRlBfRCwgaWR4KSBAQCAtMzEwLDYgKzMxMyw3NSBAQCBzdGF0aWMg
aW50DQo+IGt2bV9yaXNjdl9wdXRfcmVnc19mcChDUFVTdGF0ZSAqY3MpDQo+ID4gICAgICByZXR1
cm4gcmV0Ow0KPiA+ICB9DQo+ID4NCj4gPiArc3RhdGljIHZvaWQga3ZtX3Jpc2N2X2dldF9yZWdz
X3RpbWVyKENQVVN0YXRlICpjcykgew0KPiA+ICsgICAgaW50IHJldDsNCj4gPiArICAgIHVpbnQ2
NF90IHJlZzsNCj4gPiArICAgIENQVVJJU0NWU3RhdGUgKmVudiA9ICZSSVNDVl9DUFUoY3MpLT5l
bnY7DQo+ID4gKw0KPiA+ICsgICAgaWYgKGVudi0+a3ZtX3RpbWVyX2RpcnR5KSB7DQo+ID4gKyAg
ICAgICAgcmV0dXJuOw0KPiA+ICsgICAgfQ0KPiA+ICsNCj4gPiArICAgIHJldCA9IGt2bV9nZXRf
b25lX3JlZyhjcywgUklTQ1ZfVElNRVJfUkVHKGVudiwgdGltZSksICZyZWcpOw0KPiA+ICsgICAg
aWYgKHJldCkgew0KPiA+ICsgICAgICAgIGFib3J0KCk7DQo+ID4gKyAgICB9DQo+ID4gKyAgICBl
bnYtPmt2bV90aW1lcl90aW1lID0gcmVnOw0KPiA+ICsNCj4gPiArICAgIHJldCA9IGt2bV9nZXRf
b25lX3JlZyhjcywgUklTQ1ZfVElNRVJfUkVHKGVudiwgY29tcGFyZSksICZyZWcpOw0KPiA+ICsg
ICAgaWYgKHJldCkgew0KPiA+ICsgICAgICAgIGFib3J0KCk7DQo+ID4gKyAgICB9DQo+ID4gKyAg
ICBlbnYtPmt2bV90aW1lcl9jb21wYXJlID0gcmVnOw0KPiA+ICsNCj4gPiArICAgIHJldCA9IGt2
bV9nZXRfb25lX3JlZyhjcywgUklTQ1ZfVElNRVJfUkVHKGVudiwgc3RhdGUpLCAmcmVnKTsNCj4g
PiArICAgIGlmIChyZXQpIHsNCj4gPiArICAgICAgICBhYm9ydCgpOw0KPiA+ICsgICAgfQ0KPiA+
ICsgICAgZW52LT5rdm1fdGltZXJfc3RhdGUgPSByZWc7DQo+ID4gKw0KPiA+ICsgICAgZW52LT5r
dm1fdGltZXJfZGlydHkgPSB0cnVlOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgdm9pZCBr
dm1fcmlzY3ZfcHV0X3JlZ3NfdGltZXIoQ1BVU3RhdGUgKmNzKSB7DQo+ID4gKyAgICBpbnQgcmV0
Ow0KPiA+ICsgICAgdWludDY0X3QgcmVnOw0KPiA+ICsgICAgQ1BVUklTQ1ZTdGF0ZSAqZW52ID0g
JlJJU0NWX0NQVShjcyktPmVudjsNCj4gPiArDQo+ID4gKyAgICBpZiAoIWVudi0+a3ZtX3RpbWVy
X2RpcnR5KSB7DQo+ID4gKyAgICAgICAgcmV0dXJuOw0KPiA+ICsgICAgfQ0KPiA+ICsNCj4gPiAr
ICAgIHJlZyA9IGVudi0+a3ZtX3RpbWVyX3RpbWU7DQo+ID4gKyAgICByZXQgPSBrdm1fc2V0X29u
ZV9yZWcoY3MsIFJJU0NWX1RJTUVSX1JFRyhlbnYsIHRpbWUpLCAmcmVnKTsNCj4gPiArICAgIGlm
IChyZXQpIHsNCj4gPiArICAgICAgICBhYm9ydCgpOw0KPiA+ICsgICAgfQ0KPiA+ICsNCj4gPiAr
ICAgIHJlZyA9IGVudi0+a3ZtX3RpbWVyX2NvbXBhcmU7DQo+ID4gKyAgICByZXQgPSBrdm1fc2V0
X29uZV9yZWcoY3MsIFJJU0NWX1RJTUVSX1JFRyhlbnYsIGNvbXBhcmUpLCAmcmVnKTsNCj4gPiAr
ICAgIGlmIChyZXQpIHsNCj4gPiArICAgICAgICBhYm9ydCgpOw0KPiA+ICsgICAgfQ0KPiA+ICsN
Cj4gPiArICAgIC8qDQo+ID4gKyAgICAgKiBUbyBzZXQgcmVnaXN0ZXIgb2YgUklTQ1ZfVElNRVJf
UkVHKHN0YXRlKSB3aWxsIG9jY3VyIGEgZXJyb3IgZnJvbQ0KPiBLVk0NCj4gPiArICAgICAqIG9u
IGVudi0+a3ZtX3RpbWVyX3N0YXRlID09IDAsIEl0J3MgYmV0dGVyIHRvIGFkYXB0IGluIEtWTSwg
YnV0IGl0DQo+ID4gKyAgICAgKiBkb2Vzbid0IG1hdHRlciB0aGF0IGFkYXBpbmcgaW4gUUVNVSBu
b3cuDQo+ID4gKyAgICAgKiBUT0RPIElmIEtWTSBjaGFuZ2VzLCBhZGFwdCBoZXJlLg0KPiA+ICsg
ICAgICovDQo+ID4gKyAgICBpZiAoZW52LT5rdm1fdGltZXJfc3RhdGUpIHsNCj4gPiArICAgICAg
ICByZWcgPSBlbnYtPmt2bV90aW1lcl9zdGF0ZTsNCj4gPiArICAgICAgICByZXQgPSBrdm1fc2V0
X29uZV9yZWcoY3MsIFJJU0NWX1RJTUVSX1JFRyhlbnYsIHN0YXRlKSwgJnJlZyk7DQo+ID4gKyAg
ICAgICAgaWYgKHJldCkgew0KPiA+ICsgICAgICAgICAgICBhYm9ydCgpOw0KPiA+ICsgICAgICAg
IH0NCj4gPiArICAgIH0NCj4gPiArDQo+ID4gKyAgICBlbnYtPmt2bV90aW1lcl9kaXJ0eSA9IGZh
bHNlOw0KPiA+ICt9DQo+ID4NCj4gPiAgY29uc3QgS1ZNQ2FwYWJpbGl0eUluZm8ga3ZtX2FyY2hf
cmVxdWlyZWRfY2FwYWJpbGl0aWVzW10gPSB7DQo+ID4gICAgICBLVk1fQ0FQX0xBU1RfSU5GTw0K
PiA+IC0tDQo+ID4gMi4xOS4xDQo+ID4NCj4gPg0KPiA+IC0tDQo+ID4ga3ZtLXJpc2N2IG1haWxp
bmcgbGlzdA0KPiA+IGt2bS1yaXNjdkBsaXN0cy5pbmZyYWRlYWQub3JnDQo+ID4gaHR0cDovL2xp
c3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9rdm0tcmlzY3YNCg==
