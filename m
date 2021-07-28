Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22E83D85F9
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 04:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbhG1C5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 22:57:38 -0400
Received: from mx20.baidu.com ([111.202.115.85]:35506 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233223AbhG1C5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 22:57:37 -0400
Received: from Bc-Mail-Ex13.internal.baidu.com (unknown [172.31.51.53])
        by Forcepoint Email with ESMTPS id 624FBC15BD2622E63BB1;
        Wed, 28 Jul 2021 10:57:26 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 Bc-Mail-Ex13.internal.baidu.com (172.31.51.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Wed, 28 Jul 2021 10:57:26 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Wed, 28 Jul 2021 10:57:26 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Pankaj Gupta <pankaj.gupta.linux@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3YyXSBLVk06IHVzZSBjcHVfcmVsYXggd2hlbiBo?=
 =?utf-8?Q?alt_polling?=
Thread-Topic: [PATCH][v2] KVM: use cpu_relax when halt polling
Thread-Index: AQHXgxNrJHZDHQ3oBUOu+S+BDbpTIKtXpbcw
Date:   Wed, 28 Jul 2021 02:57:25 +0000
Message-ID: <fe516f0a191d4c6e9fbd10b380c87f19@baidu.com>
References: <20210727111247.55510-1-lirongqing@baidu.com>
 <CAM9Jb+hWS5=Oib-NuKWTL=sfg=BQ-usdRV-H-mj6hLFVF6NYnQ@mail.gmail.com>
In-Reply-To: <CAM9Jb+hWS5=Oib-NuKWTL=sfg=BQ-usdRV-H-mj6hLFVF6NYnQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.193.253]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFBhbmthaiBHdXB0YSA8
cGFua2FqLmd1cHRhLmxpbnV4QGdtYWlsLmNvbT4NCj4g5Y+R6YCB5pe26Ze0OiAyMDIx5bm0N+ac
iDI45pelIDI6MTYNCj4g5pS25Lu25Lq6OiBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5j
b20+DQo+IOaKhOmAgToga3ZtQHZnZXIua2VybmVsLm9yZzsgUGFvbG8gQm9uemluaSA8cGJvbnpp
bmlAcmVkaGF0LmNvbT47DQo+IHNlYW5qY0Bnb29nbGUuY29tDQo+IOS4u+mimDogUmU6IFtQQVRD
SF1bdjJdIEtWTTogdXNlIGNwdV9yZWxheCB3aGVuIGhhbHQgcG9sbGluZw0KPiANCj4gPiBTTVQg
c2libGluZ3Mgc2hhcmUgY2FjaGVzIGFuZCBvdGhlciBoYXJkd2FyZSwgYW5kIGJ1c3kgaGFsdCBw
b2xsaW5nDQo+ID4gd2lsbCBkZWdyYWRlIGl0cyBzaWJsaW5nIHBlcmZvcm1hbmNlIGlmIGl0cyBz
aWJsaW5nIGlzIHdvcmtpbmcNCj4gPg0KPiA+IFNlYW4gQ2hyaXN0b3BoZXJzb24gc3VnZ2VzdGVk
IGFzIGJlbG93Og0KPiA+DQo+ID4gIlJhdGhlciB0aGFuIGRpc2FsbG93aW5nIGhhbHQtcG9sbGlu
ZyBlbnRpcmVseSwgb24geDg2IGl0IHNob3VsZCBiZQ0KPiA+IHN1ZmZpY2llbnQgdG8gc2ltcGx5
IGhhdmUgdGhlIGhhcmR3YXJlIHRocmVhZCB5aWVsZCB0byBpdHMgc2libGluZyhzKQ0KPiA+IHZp
YSBQQVVTRS4gIEl0IHByb2JhYmx5IHdvbid0IGdldCBiYWNrIGFsbCBwZXJmb3JtYW5jZSwgYnV0
IEkgd291bGQNCj4gPiBleHBlY3QgaXQgdG8gYmUgY2xvc2UuDQo+ID4gVGhpcyBjb21waWxlcyBv
biBhbGwgS1ZNIGFyY2hpdGVjdHVyZXMsIGFuZCBBRkFJQ1QgdGhlIGludGVuZGVkIHVzYWdlDQo+
ID4gb2YgY3B1X3JlbGF4KCkgaXMgaWRlbnRpY2FsIGZvciBhbGwgYXJjaGl0ZWN0dXJlcy4iDQo+
IA0KPiBGb3Igc3VyZSBjaGFuZ2UgdG8gY3B1X3JlbGF4KCkgaXMgYmV0dGVyLg0KPiBXYXMganVz
dCBjdXJpb3VzIHRvIGtub3cgaWYgeW91IGdvdCBkZXNjZW50IHBlcmZvcm1hbmNlIGltcHJvdmVt
ZW50DQo+IGNvbXBhcmVkIHRvIHByZXZpb3VzbHkgcmVwb3J0ZWQgd2l0aCBVbml4YmVuY2guDQo+
IA0KPiBUaGFua3MsDQo+IFBhbmthag0KDQpUaGUgdGVzdCBhcyBiZWxvdzoNCg0KMS4gcnVuIHVu
aXhiZW5jaCBkaHJ5MnJlZzogIC4vUnVuIC1jIDEgZGhyeTJyZWcgLWkgMQ0Kd2l0aG91dCBTTVQg
ZGlzdHVyYmFuY2UsIHRoZSBzY29yZSBpcyAzMTcyDQp3aXRoIGEgIHt3aGlsZSgxKWkrK30gU01U
IGRpc3R1cmJhbmNlLCAgdGhlIHNjb3JlIGlzIDE1ODMNCndpdGggYSAge3doaWxlKDEpKHJlcCBu
b3AvcGF1c2UpfSBTTVQgZGlzdHVyYmFuY2UsICB0aGUgc2NvcmUgaXMgMTcyOS40DQoNCnNlZW1z
IGNwdV9yZWxheCBjYW4gbm90IGdldCBiYWNrIGFsbCBwZXJmb3JtYW5jZSAsIHdoYXQgd3Jvbmc/
DQoNCg0KMi4gYmFjayB0byBoYWx0cG9sbA0KcnVuIHVuaXhiZW5jaCBkaHJ5MnJlZyAuL1J1biAt
YyAxIGRocnkycmVnIC1pIDENCndpdGhvdXQgU01UIGRpc3R1cmJhbmNlLCB0aGUgc2NvcmUgaXMg
MzE3Mg0KDQp3aXRoIHJlZGlzLWJlbmNobWFyayBTTVQgZGlzdHVyYmFuY2UsIHJlZGlzLWJlbmNo
bWFyayB0YWtlcyA5MCVjcHU6DQp3aXRob3V0IHBhdGNoLCB0aGUgc2NvcmUgaXMgMTc3Ni45DQp3
aXRoIG15IGZpcnN0IHBhdGNoLCB0aGUgc2NvcmUgaXMgMTc4Mi4zDQp3aXRoIGNwdV9yZWxheCBw
YXRjaCwgdGhlIHNjb3JlIGlzIDE3NzgNCg0Kd2l0aCByZWRpcy1iZW5jaG1hcmsgU01UIGRpc3R1
cmJhbmNlLCByZWRpcy1iZW5jaG1hcmsgdGFrZXMgMzMlY3B1Og0Kd2l0aG91dCBwYXRjaCwgdGhl
IHNjb3JlIGlzIDE5MjkuOQ0Kd2l0aCBteSBmaXJzdCBwYXRjaCwgdGhlIHNjb3JlIGlzIDIyOTQu
Ng0Kd2l0aCBjcHVfcmVsYXggcGF0Y2gsIHRoZSBzY29yZSBpcyAyMDA1LjMNCg0KDQpjcHVfcmVs
YXggZ2l2ZSBsZXNzIHRoYW4gc3RvcCBoYWx0IHBvbGxpbmcsIGJ1dCBpdCBzaG91bGQgaGF2ZSBs
aXR0bGUgZWZmZWN0IGZvciByZWRpcy1iZW5jaG1hcmsgd2hpY2ggZ2V0IGJlbmVmaXQgZnJvbSBo
YWx0IHBvbGxpbmcgDQoNCg0KLUxpDQoNCj4gPg0KPiA+IFN1Z2dlc3RlZC1ieTogU2VhbiBDaHJp
c3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGkgUm9u
Z1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiA+IC0tLQ0KPiA+IGRpZmYgdjE6IHVzaW5n
IGNwdV9yZWxheCwgcmF0aGVyIHRoYXQgc3RvcCBoYWx0LXBvbGxpbmcNCj4gPg0KPiA+ICB2aXJ0
L2t2bS9rdm1fbWFpbi5jIHwgMSArDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2t2bV9tYWluLmMgYi92aXJ0L2t2bS9r
dm1fbWFpbi5jIGluZGV4DQo+ID4gN2Q5NTEyNi4uMTY3OTcyOCAxMDA2NDQNCj4gPiAtLS0gYS92
aXJ0L2t2bS9rdm1fbWFpbi5jDQo+ID4gKysrIGIvdmlydC9rdm0va3ZtX21haW4uYw0KPiA+IEBA
IC0zMTEwLDYgKzMxMTAsNyBAQCB2b2lkIGt2bV92Y3B1X2Jsb2NrKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSkNCj4gPg0KPiArK3ZjcHUtPnN0YXQuZ2VuZXJpYy5oYWx0X3BvbGxfaW52YWxpZDsNCj4g
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0KPiA+ICAgICAgICAg
ICAgICAgICAgICAgICAgIH0NCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBjcHVfcmVsYXgo
KTsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBwb2xsX2VuZCA9IGN1ciA9IGt0aW1lX2dl
dCgpOw0KPiA+ICAgICAgICAgICAgICAgICB9IHdoaWxlIChrdm1fdmNwdV9jYW5fcG9sbChjdXIs
IHN0b3ApKTsNCj4gPiAgICAgICAgIH0NCj4gPiAtLQ0KPiA+IDIuOS40DQo+ID4NCg==
