Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D4916F6AC
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 05:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgBZE7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 23:59:50 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3026 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726277AbgBZE7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 23:59:50 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 7C3F0B47B2D3DC586118;
        Wed, 26 Feb 2020 12:59:48 +0800 (CST)
Received: from DGGEMM424-HUB.china.huawei.com (10.1.198.41) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 26 Feb 2020 12:59:48 +0800
Received: from DGGEMM508-MBX.china.huawei.com ([169.254.2.45]) by
 dggemm424-hub.china.huawei.com ([10.1.198.41]) with mapi id 14.03.0439.000;
 Wed, 26 Feb 2020 12:59:41 +0800
From:   "Zhoujian (jay)" <jianjay.zhou@huawei.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Subject: RE: [PATCH v3] KVM: x86: enable dirty log gradually in small chunks
Thread-Topic: [PATCH v3] KVM: x86: enable dirty log gradually in small chunks
Thread-Index: AQHV6sIxsDFZr7X1XEqnl6bLywYnuagqDaUAgAEbwDCAAGZ4AIAAMheAgAEmrkA=
Date:   Wed, 26 Feb 2020 04:59:40 +0000
Message-ID: <B2D15215269B544CADD246097EACE7474BB21BF6@dggemm508-mbx.china.huawei.com>
References: <20200224032558.2728-1-jianjay.zhou@huawei.com>
 <20200224170538.GH37727@xz-x1>
 <B2D15215269B544CADD246097EACE7474BB1B778@dggemm508-mbx.china.huawei.com>
 <20200225160758.GB127720@xz-x1> <20200225190715.GA140200@xz-x1>
In-Reply-To: <20200225190715.GA140200@xz-x1>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.228.206]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGV0ZXIgWHUgW21haWx0
bzpwZXRlcnhAcmVkaGF0LmNvbV0NCg0KWy4uLl0NCg0KPiA+ID4gPiA+IEBAIC0zMzIwLDYgKzMz
MjYsMTAgQEAgc3RhdGljIGxvbmcNCj4gPiA+ID4ga3ZtX3ZtX2lvY3RsX2NoZWNrX2V4dGVuc2lv
bl9nZW5lcmljKHN0cnVjdCBrdm0gKmt2bSwgbG9uZyBhcmcpDQo+ID4gPiA+ID4gIAljYXNlIEtW
TV9DQVBfQ09BTEVTQ0VEX1BJTzoNCj4gPiA+ID4gPiAgCQlyZXR1cm4gMTsNCj4gPiA+ID4gPiAg
I2VuZGlmDQo+ID4gPiA+ID4gKyNpZmRlZiBDT05GSUdfS1ZNX0dFTkVSSUNfRElSVFlMT0dfUkVB
RF9QUk9URUNUDQo+ID4gPiA+ID4gKwljYXNlIEtWTV9DQVBfTUFOVUFMX0RJUlRZX0xPR19QUk9U
RUNUMjoNCj4gPiA+ID4gPiArCQlyZXR1cm4gS1ZNX0RJUlRZX0xPR19NQU5VQUxfQ0FQUzsNCj4g
PiA+ID4NCj4gPiA+ID4gV2UgcHJvYmFibHkgY2FuIG9ubHkgcmV0dXJuIHRoZSBuZXcgZmVhdHVy
ZSBiaXQgd2hlbiB3aXRoIENPTkZJR19YODY/DQoNClNpbmNlIHRoZSBtZWFuaW5nIG9mIEtWTV9E
SVJUWV9MT0dfTUFOVUFMX0NBUFMgd2lsbCBjaGFuZ2UgYWNjb3JkaW5nbHkgaW4NCmRpZmZlcmVu
dCBhcmNocywgd2UgY2FuIHVzZSBpdCBpbiBrdm1fdm1faW9jdGxfZW5hYmxlX2NhcF9nZW5lcmlj
LCBob3cgYWJvdXQ6DQoNCkBAIC0zMzQ3LDExICszMzUxLDE3IEBAIHN0YXRpYyBpbnQga3ZtX3Zt
X2lvY3RsX2VuYWJsZV9jYXBfZ2VuZXJpYyhzdHJ1Y3Qga3ZtICprdm0sDQogew0KICAgICAgICBz
d2l0Y2ggKGNhcC0+Y2FwKSB7DQogI2lmZGVmIENPTkZJR19LVk1fR0VORVJJQ19ESVJUWUxPR19S
RUFEX1BST1RFQ1QNCi0gICAgICAgY2FzZSBLVk1fQ0FQX01BTlVBTF9ESVJUWV9MT0dfUFJPVEVD
VDI6DQotICAgICAgICAgICAgICAgaWYgKGNhcC0+ZmxhZ3MgfHwgKGNhcC0+YXJnc1swXSAmIH4x
KSkNCisgICAgICAgY2FzZSBLVk1fQ0FQX01BTlVBTF9ESVJUWV9MT0dfUFJPVEVDVDI6IHsNCisg
ICAgICAgICAgICAgICB1NjQgYWxsb3dlZF9vcHRpb25zID0gS1ZNX0RJUlRZX0xPR19NQU5VQUxf
UFJPVEVDVF9FTkFCTEU7DQorDQorICAgICAgICAgICAgICAgaWYgKGNhcC0+YXJnc1swXSAmIEtW
TV9ESVJUWV9MT0dfTUFOVUFMX1BST1RFQ1RfRU5BQkxFKQ0KKyAgICAgICAgICAgICAgICAgICAg
ICAgYWxsb3dlZF9vcHRpb25zID0gS1ZNX0RJUlRZX0xPR19NQU5VQUxfQ0FQUzsNCisNCisgICAg
ICAgICAgICAgICBpZiAoY2FwLT5mbGFncyB8fCAoY2FwLT5hcmdzWzBdICYgfmFsbG93ZWRfb3B0
aW9ucykpDQogICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCiAgICAgICAg
ICAgICAgICBrdm0tPm1hbnVhbF9kaXJ0eV9sb2dfcHJvdGVjdCA9IGNhcC0+YXJnc1swXTsNCiAg
ICAgICAgICAgICAgICByZXR1cm4gMDsNCisgICAgICAgfQ0KDQpbLi4uXQ0KDQo+PiBIb3cgYWJv
dXQ6DQo+ID4NCj4gPiA9PT09PT09PT09DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
aW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiA+IGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hv
c3QuaCBpbmRleCA0MGEwYzBmZDk1Y2EuLmZjZmZhZjhhNjk2NA0KPiA+IDEwMDY0NA0KPiA+IC0t
LSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCj4gPiArKysgYi9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+ID4gQEAgLTE2OTcsNCArMTY5Nyw3IEBAIHN0YXRpYyBp
bmxpbmUgaW50IGt2bV9jcHVfZ2V0X2FwaWNpZChpbnQgbXBzX2NwdSkNCj4gPiAgI2RlZmluZSBH
RVRfU01TVEFURSh0eXBlLCBidWYsIG9mZnNldCkgICAgICAgICBcDQo+ID4gICAgICAgICAoKih0
eXBlICopKChidWYpICsgKG9mZnNldCkgLSAweDdlMDApKQ0KPiA+DQo+ID4gKyNkZWZpbmUgS1ZN
X0RJUlRZX0xPR19NQU5VQUxfQ0FQUw0KPiAoS1ZNX0RJUlRZX0xPR19NQU5VQUxfUFJPVEVDVCB8
IFwNCj4gPiArDQo+IEtWTV9ESVJUWV9MT0dfSU5JVElBTExZX1NFVCkNCj4gPiArDQo+ID4gICNl
bmRpZiAvKiBfQVNNX1g4Nl9LVk1fSE9TVF9IICovDQo+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUv
bGludXgva3ZtX2hvc3QuaCBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaCBpbmRleA0KPiA+IGU4
OWViNjczNTZjYi4uMzlkNDk4MDJlZTg3IDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvbGludXgv
a3ZtX2hvc3QuaA0KPiA+ICsrKyBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaA0KPiA+IEBAIC0x
NDEwLDQgKzE0MTAsOCBAQCBpbnQga3ZtX3ZtX2NyZWF0ZV93b3JrZXJfdGhyZWFkKHN0cnVjdCBr
dm0gKmt2bSwNCj4ga3ZtX3ZtX3RocmVhZF9mbl90IHRocmVhZF9mbiwNCj4gPiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHVpbnRwdHJfdCBkYXRhLCBjb25zdCBjaGFyICpuYW1lLA0K
PiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHRhc2tfc3RydWN0ICoq
dGhyZWFkX3B0cik7DQo+ID4NCj4gPiArI2lmbmRlZiBLVk1fRElSVFlfTE9HX01BTlVBTF9DQVBT
DQo+ID4gKyNkZWZpbmUgS1ZNX0RJUlRZX0xPR19NQU5VQUxfQ0FQUw0KPiBLVk1fRElSVFlfTE9H
X01BTlVBTF9QUk9URUNUDQo+ID4gKyNlbmRpZg0KPiA+ICsNCj4gDQo+IEhtbS4uLiBNYXliZSB0
aGlzIHdvbid0IHdvcmssIGJlY2F1c2UgSSBzYXcgdGhhdCBhc20va3ZtX2hvc3QuaCBhbmQNCj4g
bGludXgva3ZtX2hvc3QuaCBoYXMgbm8gZGVwZW5kZW5jeSBiZXR3ZWVuIGVhY2ggb3RoZXIgKHdo
aWNoIEkgdGhvdWdodCB0aGV5DQo+IGhhZCkuICBSaWdodCBub3cgaW4gbW9zdCBjYXNlcyBsaW51
eC8gaGVhZGVyIGNhbiBiZSBpbmNsdWRlZCBlYXJsaWVyIHRoYW4gdGhlDQo+IGFzbS8gaGVhZGVy
IGluIEMgZmlsZXMuICBTbyBpbnRlYWQsIG1heWJlIHdlIGNhbiBtb3ZlIHRoZXNlIGxpbmVzIGlu
dG8NCj4ga3ZtX21haW4uYyBkaXJlY3RseS4NCg0KSSBkaWQgc29tZSB0ZXN0cyBvbiB4ODYsIGFu
ZCBpdCB3b3Jrcy4gTG9va3MgZ29vZCB0byBtZS4NCg0KPiANCj4gKEknbSB0aGlua2luZyBpZGVh
bGx5IGxpbnV4L2t2bV9ob3N0Lmggc2hvdWxkIGluY2x1ZGUgYXNtL2t2bV9ob3N0LmggIHdpdGhp
bg0KPiBpdHNlbGYsIHRoZW4gQyBmaWxlcyBzaG91bGQgbm90IGluY2x1ZGUgYXNtL2t2bV9ob3N0
LmggIGRpcmVjdGx5LiBIb3dldmVyIEkgZGFyZQ0KPiBub3QgdHJ5IHRoYXQgcmlnaHQgbm93IHdp
dGhvdXQgYmVpbmcgYWJsZSB0byAgdGVzdCBjb21waWxlIG9uIGFsbCBhcmNocy4uLikNCj4gDQpC
dXQsIEkgc2VlIGluY2x1ZGUvbGludXgva3ZtX2hvc3QuaCBoYXMgYWxyZWFkeSBpbmNsdWRlZCBh
c20va3ZtX2hvc3QuaCBpbiB0aGUNCnVwc3RyZWFtLiBEbyBJIHVuZGVyc3RhbmQgeW91ciBtZWFu
aW5nIGNvcnJlY3RseT8NCg0KUmVnYXJkcywNCkpheSBaaG91DQo=
