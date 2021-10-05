Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29D4422019
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 10:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbhJEIGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 04:06:36 -0400
Received: from mx22.baidu.com ([220.181.50.185]:33670 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232942AbhJEIGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 04:06:35 -0400
Received: from Bc-Mail-Ex13.internal.baidu.com (unknown [172.31.51.53])
        by Forcepoint Email with ESMTPS id CBD904FE7D1812FC8829;
        Tue,  5 Oct 2021 16:04:38 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 Bc-Mail-Ex13.internal.baidu.com (172.31.51.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Tue, 5 Oct 2021 16:04:38 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Tue, 5 Oct 2021 16:04:38 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Andy Lutomirski <luto@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIEtWTTogeDg2OiBkaXJlY3RseSBjYWxsIHdiaW52?=
 =?utf-8?Q?d_for_local_cpu_when_emulate_wbinvd?=
Thread-Topic: [PATCH] KVM: x86: directly call wbinvd for local cpu when
 emulate wbinvd
Thread-Index: AQHXuXMaPPVMI+ZMo0W+myyiElZgI6vECFTA
Date:   Tue, 5 Oct 2021 08:04:38 +0000
Message-ID: <7daf6f1bb52a461f9f53beea2b23943d@baidu.com>
References: <1632821269-52969-1-git-send-email-lirongqing@baidu.com>
 <fe38bc2e-64a5-e770-a86a-b2b70eef4fb4@kernel.org>
In-Reply-To: <fe38bc2e-64a5-e770-a86a-b2b70eef4fb4@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.21.146.48]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IEFuZHkgTHV0b21pcnNr
aSA8bHV0b0BrZXJuZWwub3JnPg0KPiDlj5HpgIHml7bpl7Q6IDIwMjHlubQxMOaciDXml6UgNjo1
Nw0KPiDmlLbku7bkuro6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT47IGt2bUB2
Z2VyLmtlcm5lbC5vcmc7DQo+IHdhbnBlbmdsaUB0ZW5jZW50LmNvbTsgamFuLmtpc3prYUBzaWVt
ZW5zLmNvbTsgeDg2QGtlcm5lbC5vcmcNCj4g5Li76aKYOiBSZTogW1BBVENIXSBLVk06IHg4Njog
ZGlyZWN0bHkgY2FsbCB3YmludmQgZm9yIGxvY2FsIGNwdSB3aGVuIGVtdWxhdGUNCj4gd2JpbnZk
DQo+IA0KPiBPbiA5LzI4LzIxIDAyOjI3LCBMaSBSb25nUWluZyB3cm90ZToNCj4gPiBkaXJlY3Rs
eSBjYWxsIHdiaW52ZCBmb3IgbG9jYWwgcENQVSwgd2hpY2ggY2FuIGF2b2lkIGlwaSBmb3IgaXRz
ZWxmDQo+ID4gYW5kIGNhbGxpbmcgb2YgZ2V0X2NwdS9vbl9lYWNoX2NwdV9tYXNrL2V0Yy4NCj4g
Pg0KPiANCj4gV2h5IGlzIHRoaXMgYW4gaW1wcm92ZW1lbnQ/ICBUcmFkaW5nIGdldF9jcHUoKSB2
cyBwcmVlbXB0X2Rpc2FibGUoKSBzZWVtcw0KPiBsaWtlIGEgbmVnbGlnaWJsZSBkaWZmZXJlbmNl
LCBhbmQgaXQgbWFrZXMgdGhlIGNvZGUgbW9yZSBjb21wbGljYXRlZC4NCj4gDQoNCkZpcnN0OiB0
byBsb2NhbCBwQ3B1LCB0aGlzIHJlZHVjZXMgYSBpcGkgdG8gaXRzZWxmLCBpcGkgd2lsbCB0cmln
Z2VyIGNvbnRleHQgc3dpdGNoIGJldHdlZW4gaXJxIGFuZCB0aHJlYWQsIGl0IGlzIGV4cGVuc2l2
ZS4NCg0KU2Vjb25kLCBwcmVlbXB0X2Rpc2FibGUvcHJlZW1wdF9lbmFibGUgdnMgZ2V0X2NwdS8g
Y3B1bWFza19zZXRfY3B1L3B1dF9jcHUsIHRoZSBwcmVlbXB0X2Rpc2FibGUvIHByZWVtcHRfZW5h
YmxlIGlzIG1vcmUgc2xpZ2h0LiANCg0KQW5kIHRoaXMgY2FuIGF2b2lkIHRoZSBhdG9taWMgY3B1
bWFza19zZXRfY3B1DQoNCi1MaSAgDQoNCg0KPiA+IEluIGZhY3QsIFRoaXMgY2hhbmdlIHJldmVy
dHMgY29tbWl0IDJlZWM3MzQzNzQ4NyAoIktWTTogeDg2OiBBdm9pZA0KPiA+IGlzc3Vpbmcgd2Jp
bnZkIHR3aWNlIiksIHNpbmNlIHNtcF9jYWxsX2Z1bmN0aW9uX21hbnkgaXMgc2tpcGluZyB0aGUN
Cj4gPiBsb2NhbCBjcHUgKGFzIGRlc2NyaXB0aW9uIG9mIGMyMTYyZTEzZDZlMmYpLCB3YmludmQg
aXMgbm90IGlzc3VlZA0KPiA+IHR3aWNlDQo+ID4NCj4gPiBhbmQgcmV2ZXJ0cyBjb21taXQgYzIx
NjJlMTNkNmUyZiAoIktWTTogWDg2OiBGaXggbWlzc2luZyBsb2NhbCBwQ1BVDQo+ID4gd2hlbiBl
eGVjdXRpbmcgd2JpbnZkIG9uIGFsbCBkaXJ0eSBwQ1BVcyIpIHRvbywgd2hpY2ggZml4ZWQgdGhl
DQo+ID4gcHJldmlvdXMgcGF0Y2gsIHdoZW4gcmV2ZXJ0IHByZXZpb3VzIHBhdGNoLCBpdCBpcyBu
b3QgbmVlZGVkLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGkgUm9uZ1FpbmcgPGxpcm9uZ3Fp
bmdAYmFpZHUuY29tPg0KPiA+IC0tLQ0KPiA+ICAgYXJjaC94ODYva3ZtL3g4Ni5jIHwgICAxMyAr
KysrKystLS0tLS0tDQo+ID4gICAxIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNyBk
ZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9h
cmNoL3g4Ni9rdm0veDg2LmMgaW5kZXgNCj4gPiAyOGVmMTQxLi5lZTY1OTQxIDEwMDY0NA0KPiA+
IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuYw0KPiA+ICsrKyBiL2FyY2gveDg2L2t2bS94ODYuYw0K
PiA+IEBAIC02OTg0LDE1ICs2OTg0LDE0IEBAIHN0YXRpYyBpbnQga3ZtX2VtdWxhdGVfd2JpbnZk
X25vc2tpcChzdHJ1Y3QNCj4ga3ZtX3ZjcHUgKnZjcHUpDQo+ID4gICAJCXJldHVybiBYODZFTVVM
X0NPTlRJTlVFOw0KPiA+DQo+ID4gICAJaWYgKHN0YXRpY19jYWxsKGt2bV94ODZfaGFzX3diaW52
ZF9leGl0KSgpKSB7DQo+ID4gLQkJaW50IGNwdSA9IGdldF9jcHUoKTsNCj4gPiAtDQo+ID4gLQkJ
Y3B1bWFza19zZXRfY3B1KGNwdSwgdmNwdS0+YXJjaC53YmludmRfZGlydHlfbWFzayk7DQo+ID4g
LQkJb25fZWFjaF9jcHVfbWFzayh2Y3B1LT5hcmNoLndiaW52ZF9kaXJ0eV9tYXNrLA0KPiA+ICsJ
CXByZWVtcHRfZGlzYWJsZSgpOw0KPiA+ICsJCXNtcF9jYWxsX2Z1bmN0aW9uX21hbnkodmNwdS0+
YXJjaC53YmludmRfZGlydHlfbWFzaywNCj4gPiAgIAkJCQl3YmludmRfaXBpLCBOVUxMLCAxKTsN
Cj4gPiAtCQlwdXRfY3B1KCk7DQo+ID4gKwkJcHJlZW1wdF9lbmFibGUoKTsNCj4gPiAgIAkJY3B1
bWFza19jbGVhcih2Y3B1LT5hcmNoLndiaW52ZF9kaXJ0eV9tYXNrKTsNCj4gPiAtCX0gZWxzZQ0K
PiA+IC0JCXdiaW52ZCgpOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCXdiaW52ZCgpOw0KPiA+ICAg
CXJldHVybiBYODZFTVVMX0NPTlRJTlVFOw0KPiA+ICAgfQ0KPiA+DQo+ID4NCg0K
