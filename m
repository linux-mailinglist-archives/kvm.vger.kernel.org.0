Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D00844619E
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 10:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbhKEJyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 05:54:19 -0400
Received: from mx24.baidu.com ([111.206.215.185]:42548 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232905AbhKEJyR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 05:54:17 -0400
Received: from BC-Mail-Ex15.internal.baidu.com (unknown [172.31.51.55])
        by Forcepoint Email with ESMTPS id DFEF8A036B2AD4DBEF30;
        Fri,  5 Nov 2021 17:51:35 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex15.internal.baidu.com (172.31.51.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Fri, 5 Nov 2021 17:51:35 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Fri, 5 Nov 2021 17:51:35 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBLVk06IHg4NjogZGlzYWJsZSBwdiBlb2kgaWYgZ3Vl?=
 =?gb2312?Q?st_gives_a_wrong_address?=
Thread-Topic: [PATCH] KVM: x86: disable pv eoi if guest gives a wrong address
Thread-Index: AQHX0eq3h9cMJGNG30iNx927S7UCXqv0H2CAgACSBNA=
Date:   Fri, 5 Nov 2021 09:51:35 +0000
Message-ID: <652f048a85d548d7b965680d9300e26b@baidu.com>
References: <1636078404-48617-1-git-send-email-lirongqing@baidu.com>
 <87v917km0y.fsf@vitty.brq.redhat.com>
In-Reply-To: <87v917km0y.fsf@vitty.brq.redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.207.33]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogVml0YWx5IEt1em5ldHNvdiA8dmt1
em5ldHNAcmVkaGF0LmNvbT4NCj4gt6LLzcqxvOQ6IDIwMjHE6jEx1MI1yNUgMTc6MDgNCj4gytW8
/sjLOiBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+ILOty806IGt2bUB2Z2Vy
Lmtlcm5lbC5vcmc7IHBib256aW5pQHJlZGhhdC5jb207IHNlYW5qY0Bnb29nbGUuY29tOw0KPiBM
aSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+INb3zOI6IFJlOiBbUEFUQ0hdIEtW
TTogeDg2OiBkaXNhYmxlIHB2IGVvaSBpZiBndWVzdCBnaXZlcyBhIHdyb25nIGFkZHJlc3MNCj4g
DQo+IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4gd3JpdGVzOg0KPiANCj4gPiBk
aXNhYmxlIHB2IGVvaSBpZiBndWVzdCBnaXZlcyBhIHdyb25nIGFkZHJlc3MsIHRoaXMgY2FuIHJl
ZHVjZXMgdGhlDQo+ID4gYXR0YWNrZWQgcG9zc2liaWxpdHkgZm9yIGEgbWFsaWNpb3VzIGd1ZXN0
LCBhbmQgY2FuIGF2b2lkIHVubmVjZXNzYXJ5DQo+ID4gd3JpdGUvcmVhZCBwdiBlb2kgbWVtb3J5
DQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBMaSBSb25nUWluZyA8bGlyb25ncWluZ0BiYWlkdS5j
b20+DQo+ID4gLS0tDQo+ID4gIGFyY2gveDg2L2t2bS9sYXBpYy5jIHwgICAgOSArKysrKysrKy0N
Cj4gPiAgMSBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pDQo+
ID4NCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2xhcGljLmMgYi9hcmNoL3g4Ni9rdm0v
bGFwaWMuYyBpbmRleA0KPiA+IGIxZGUyM2UuLjBmMzdhOGQgMTAwNjQ0DQo+ID4gLS0tIGEvYXJj
aC94ODYva3ZtL2xhcGljLmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rdm0vbGFwaWMuYw0KPiA+IEBA
IC0yODUzLDYgKzI4NTMsNyBAQCBpbnQga3ZtX2xhcGljX2VuYWJsZV9wdl9lb2koc3RydWN0IGt2
bV92Y3B1DQo+ICp2Y3B1LCB1NjQgZGF0YSwgdW5zaWduZWQgbG9uZyBsZW4pDQo+ID4gIAl1NjQg
YWRkciA9IGRhdGEgJiB+S1ZNX01TUl9FTkFCTEVEOw0KPiA+ICAJc3RydWN0IGdmbl90b19odmFf
Y2FjaGUgKmdoYyA9ICZ2Y3B1LT5hcmNoLnB2X2VvaS5kYXRhOw0KPiA+ICAJdW5zaWduZWQgbG9u
ZyBuZXdfbGVuOw0KPiA+ICsJaW50IHJldDsNCj4gPg0KPiA+ICAJaWYgKCFJU19BTElHTkVEKGFk
ZHIsIDQpKQ0KPiA+ICAJCXJldHVybiAxOw0KPiA+IEBAIC0yODY2LDcgKzI4NjcsMTMgQEAgaW50
IGt2bV9sYXBpY19lbmFibGVfcHZfZW9pKHN0cnVjdCBrdm1fdmNwdQ0KPiAqdmNwdSwgdTY0IGRh
dGEsIHVuc2lnbmVkIGxvbmcgbGVuKQ0KPiA+ICAJZWxzZQ0KPiA+ICAJCW5ld19sZW4gPSBsZW47
DQo+ID4NCj4gPiAtCXJldHVybiBrdm1fZ2ZuX3RvX2h2YV9jYWNoZV9pbml0KHZjcHUtPmt2bSwg
Z2hjLCBhZGRyLCBuZXdfbGVuKTsNCj4gPiArCXJldCA9IGt2bV9nZm5fdG9faHZhX2NhY2hlX2lu
aXQodmNwdS0+a3ZtLCBnaGMsIGFkZHIsIG5ld19sZW4pOw0KPiA+ICsNCj4gPiArCWlmIChyZXQg
JiYgKHZjcHUtPmFyY2gucHZfZW9pLm1zcl92YWwgJiBLVk1fTVNSX0VOQUJMRUQpKSB7DQo+ID4g
KwkJdmNwdS0+YXJjaC5wdl9lb2kubXNyX3ZhbCAmPSB+S1ZNX01TUl9FTkFCTEVEOw0KPiA+ICsJ
CXByX3dhcm5fb25jZSgiRGlzYWJsZWQgUFYgRU9JIGR1cmluZyB3cm9uZyBhZGRyZXNzXG4iKTsN
Cj4gDQo+IFBlcnNvbmFsbHksIEkgc2VlIGxpdHRsZSB2YWx1ZSBpbiB0aGlzIG1lc3NhZ2U6IGl0
J3Mgbm90IGVhc3kgdG8gc2F5IHdoaWNoIHBhcnRpY3VsYXINCj4gZ3Vlc3QgdHJpZ2dlcmVkIGl0
IHNvIGl0J3MgdW5jbGVhciB3aGF0IHN5c3RlbSBhZG1pbmlzdHJhdG9yIGlzIHN1cHBvc2VkIHRv
IGRvDQo+IHVwb24gc2VlaW5nIHRoaXMgbWVzc2FnZS4NCj4gDQo+IEFsc28sIHdoaWxlIG9uIGl0
LCBJIHRoaW5rIGt2bV9sYXBpY19lbmFibGVfcHZfZW9pKCkgaXMgbWlzbmFtZWQ6IGl0IGlzIGFs
c28gdXNlZA0KPiBmb3IgKmRpc2FibGluZyogUFYgRU9JLg0KPiANCj4gSW5zdGVhZCBvZiBkcm9w
cGluZyBLVk1fTVNSX0VOQUJMRUQgYml0LCBJJ2Qgc3VnZ2VzdCB3ZSBvbmx5IHNldA0KPiB2Y3B1
LT5hcmNoLnB2X2VvaS5tc3JfdmFsIGluIGNhc2Ugb2Ygc3VjY2Vzcy4gSW4gY2FzZQ0KPiBrdm1f
Z2ZuX3RvX2h2YV9jYWNoZV9pbml0KCkgZmFpbHMsIHdlIGluamVjdCAjR1Agc28gaXQncyByZWFz
b25hYmxlIHRvIGV4cGVjdA0KPiB0aGF0IE1TUidzIHZhbHVlIGRpZG4ndCBjaGFuZ2UuDQo+IA0K
DQoNCkhpIFZpdGFseToNCg0KQ291bGQgeW91IHN1Ym1pdCB5b3VyIHBhdGNoPyANCg0KVGhhbmtz
DQoNCi1MaQ0KDQo=
