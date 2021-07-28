Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E733D8826
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 08:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbhG1Gq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 02:46:56 -0400
Received: from mx21.baidu.com ([220.181.3.85]:41930 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232798AbhG1Gq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 02:46:56 -0400
Received: from BC-Mail-Ex14.internal.baidu.com (unknown [172.31.51.54])
        by Forcepoint Email with ESMTPS id BADC532CDD7BE581D7CF;
        Wed, 28 Jul 2021 14:46:45 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex14.internal.baidu.com (172.31.51.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Wed, 28 Jul 2021 14:46:45 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Wed, 28 Jul 2021 14:46:45 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Pankaj Gupta <pankaj.gupta.linux@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3YyXSBLVk06IHVzZSBjcHVfcmVsYXggd2hlbiBo?=
 =?utf-8?Q?alt_polling?=
Thread-Topic: [PATCH][v2] KVM: use cpu_relax when halt polling
Thread-Index: AQHXgxNrJHZDHQ3oBUOu+S+BDbpTIKtXpbcw//+9FYCAAIwC8A==
Date:   Wed, 28 Jul 2021 06:46:45 +0000
Message-ID: <46659966ffbb49c29240a6e8944179b7@baidu.com>
References: <20210727111247.55510-1-lirongqing@baidu.com>
 <CAM9Jb+hWS5=Oib-NuKWTL=sfg=BQ-usdRV-H-mj6hLFVF6NYnQ@mail.gmail.com>
 <fe516f0a191d4c6e9fbd10b380c87f19@baidu.com>
 <CAM9Jb+iuhexGnwhp_zNCWBLO5dGainBUitObyTDRubjV_nq-HA@mail.gmail.com>
In-Reply-To: <CAM9Jb+iuhexGnwhp_zNCWBLO5dGainBUitObyTDRubjV_nq-HA@mail.gmail.com>
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
iDI45pelIDE0OjEyDQo+IOaUtuS7tuS6ujogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUu
Y29tPg0KPiDmioTpgIE6IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IFBhb2xvIEJvbnppbmkgPHBib256
aW5pQHJlZGhhdC5jb20+Ow0KPiBzZWFuamNAZ29vZ2xlLmNvbQ0KPiDkuLvpopg6IFJlOiBbUEFU
Q0hdW3YyXSBLVk06IHVzZSBjcHVfcmVsYXggd2hlbiBoYWx0IHBvbGxpbmcNCj4gDQo+ICcNCj4g
PiA+ID4gIlJhdGhlciB0aGFuIGRpc2FsbG93aW5nIGhhbHQtcG9sbGluZyBlbnRpcmVseSwgb24g
eDg2IGl0IHNob3VsZA0KPiA+ID4gPiBiZSBzdWZmaWNpZW50IHRvIHNpbXBseSBoYXZlIHRoZSBo
YXJkd2FyZSB0aHJlYWQgeWllbGQgdG8gaXRzDQo+ID4gPiA+IHNpYmxpbmcocykgdmlhIFBBVVNF
LiAgSXQgcHJvYmFibHkgd29uJ3QgZ2V0IGJhY2sgYWxsIHBlcmZvcm1hbmNlLA0KPiA+ID4gPiBi
dXQgSSB3b3VsZCBleHBlY3QgaXQgdG8gYmUgY2xvc2UuDQo+ID4gPiA+IFRoaXMgY29tcGlsZXMg
b24gYWxsIEtWTSBhcmNoaXRlY3R1cmVzLCBhbmQgQUZBSUNUIHRoZSBpbnRlbmRlZA0KPiA+ID4g
PiB1c2FnZSBvZiBjcHVfcmVsYXgoKSBpcyBpZGVudGljYWwgZm9yIGFsbCBhcmNoaXRlY3R1cmVz
LiINCj4gPiA+DQo+ID4gPiBGb3Igc3VyZSBjaGFuZ2UgdG8gY3B1X3JlbGF4KCkgaXMgYmV0dGVy
Lg0KPiA+ID4gV2FzIGp1c3QgY3VyaW91cyB0byBrbm93IGlmIHlvdSBnb3QgZGVzY2VudCBwZXJm
b3JtYW5jZSBpbXByb3ZlbWVudA0KPiA+ID4gY29tcGFyZWQgdG8gcHJldmlvdXNseSByZXBvcnRl
ZCB3aXRoIFVuaXhiZW5jaC4NCj4gPiA+DQo+ID4gPiBUaGFua3MsDQo+ID4gPiBQYW5rYWoNCj4g
Pg0KPiA+IFRoZSB0ZXN0IGFzIGJlbG93Og0KPiA+DQo+ID4gMS4gcnVuIHVuaXhiZW5jaCBkaHJ5
MnJlZzogIC4vUnVuIC1jIDEgZGhyeTJyZWcgLWkgMSB3aXRob3V0IFNNVA0KPiA+IGRpc3R1cmJh
bmNlLCB0aGUgc2NvcmUgaXMgMzE3MiB3aXRoIGEgIHt3aGlsZSgxKWkrK30gU01UIGRpc3R1cmJh
bmNlLA0KPiA+IHRoZSBzY29yZSBpcyAxNTgzIHdpdGggYSAge3doaWxlKDEpKHJlcCBub3AvcGF1
c2UpfSBTTVQgZGlzdHVyYmFuY2UsDQo+ID4gdGhlIHNjb3JlIGlzIDE3MjkuNA0KPiA+DQo+ID4g
c2VlbXMgY3B1X3JlbGF4IGNhbiBub3QgZ2V0IGJhY2sgYWxsIHBlcmZvcm1hbmNlICwgd2hhdCB3
cm9uZz8NCj4gDQo+IE1heWJlIGJlY2F1c2Ugb2YgcGF1c2UgaW50ZXJjZXB0IGZpbHRlcmluZywg
Y29tcGFyYXRpdmVseSBNYXlsZXNzIFZNIEV4aXRzPw0KPiANCg0KSW4gdm07DQoNCkkgcmV0ZXN0
IGl0IGluIGJhcmUgbWV0YWwsIHBhdXNlIGluc3RydWN0aW9uIHdvcmtzIGFzIGV4cGVjdCwgdGhl
IHNjb3JlIHdpdGggInBhdXNlIGxvb3AiIGRpc3R1cmJhbmNlIGlzIDI4ODY7IGFib3V0IDkwJSBv
ZiBubyBkaXN0dXJiYW5jZQ0KDQotTGkNCg0KPiA+DQo+ID4NCj4gPiAyLiBiYWNrIHRvIGhhbHRw
b2xsDQo+ID4gcnVuIHVuaXhiZW5jaCBkaHJ5MnJlZyAuL1J1biAtYyAxIGRocnkycmVnIC1pIDEg
d2l0aG91dCBTTVQNCj4gPiBkaXN0dXJiYW5jZSwgdGhlIHNjb3JlIGlzIDMxNzINCj4gPg0KPiA+
IHdpdGggcmVkaXMtYmVuY2htYXJrIFNNVCBkaXN0dXJiYW5jZSwgcmVkaXMtYmVuY2htYXJrIHRh
a2VzIDkwJWNwdToNCj4gPiB3aXRob3V0IHBhdGNoLCB0aGUgc2NvcmUgaXMgMTc3Ni45DQo+ID4g
d2l0aCBteSBmaXJzdCBwYXRjaCwgdGhlIHNjb3JlIGlzIDE3ODIuMyB3aXRoIGNwdV9yZWxheCBw
YXRjaCwgdGhlDQo+ID4gc2NvcmUgaXMgMTc3OA0KPiA+DQo+ID4gd2l0aCByZWRpcy1iZW5jaG1h
cmsgU01UIGRpc3R1cmJhbmNlLCByZWRpcy1iZW5jaG1hcmsgdGFrZXMgMzMlY3B1Og0KPiA+IHdp
dGhvdXQgcGF0Y2gsIHRoZSBzY29yZSBpcyAxOTI5LjkNCj4gPiB3aXRoIG15IGZpcnN0IHBhdGNo
LCB0aGUgc2NvcmUgaXMgMjI5NC42IHdpdGggY3B1X3JlbGF4IHBhdGNoLCB0aGUNCj4gPiBzY29y
ZSBpcyAyMDA1LjMNCj4gPg0KPiA+DQo+ID4gY3B1X3JlbGF4IGdpdmUgbGVzcyB0aGFuIHN0b3Ag
aGFsdCBwb2xsaW5nLCBidXQgaXQgc2hvdWxkIGhhdmUgbGl0dGxlDQo+ID4gZWZmZWN0IGZvciBy
ZWRpcy1iZW5jaG1hcmsgd2hpY2ggZ2V0IGJlbmVmaXQgZnJvbSBoYWx0IHBvbGxpbmcNCj4gDQo+
IFdlIGFyZSBzZWVpbmcgaW1wcm92ZW1lbnQgd2l0aCBjcHVfcmVsYXgoKSB0aG91Z2ggbm90IHRv
IHRoZSBsZXZlbCBvZiBzdG9wcGluZw0KPiB0aGUgaGFsdCBwb2xsaW5nIHdoZW4gc2libGluZyBD
UFUgcnVubmluZyByZWRpcyB3b3JrbG9hZC4gRm9yIDkwJSBjYXNlIEkgdGhpbmsgaXRzDQo+IGV4
cGVjdGVkIHRvIGhhdmUgc2ltaWxhciBwZXJmb3JtYW5jZS4NCj4gDQo+IEZvciAzMyUgc3RvcHBp
bmcgaGFsdCBwb2xsIGdpdmVzIGJldHRlciByZXN1bHQgYmVjYXVzZSBvZiB0aGUgd29ya2xvYWQu
IE92ZXJhbGwgSQ0KPiB0aGluayB0aGlzIHBhdGNoIGhlbHBzIGFuZCBub3QgaW1wYWN0IHBlcmZv
cm1hbmNlIGluIG5vcm1hbCBjYXNlcy4NCj4gDQo+IFJldmlld2VkLWJ5OiBQYW5rYWogR3VwdGEg
PHBhbmthai5ndXB0YUBpb25vcy5jb20+DQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IFBhbmthag0K
PiANCj4gDQo+ID4NCj4gPg0KPiA+IC1MaQ0KPiA+DQo+ID4gPiA+DQo+ID4gPiA+IFN1Z2dlc3Rl
ZC1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+ID4gPiA+IFNp
Z25lZC1vZmYtYnk6IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gPiA+ID4g
LS0tDQo+ID4gPiA+IGRpZmYgdjE6IHVzaW5nIGNwdV9yZWxheCwgcmF0aGVyIHRoYXQgc3RvcCBo
YWx0LXBvbGxpbmcNCj4gPiA+ID4NCj4gPiA+ID4gIHZpcnQva3ZtL2t2bV9tYWluLmMgfCAxICsN
Cj4gPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPiA+ID4gPg0KPiA+ID4g
PiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0va3ZtX21haW4uYyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMg
aW5kZXgNCj4gPiA+ID4gN2Q5NTEyNi4uMTY3OTcyOCAxMDA2NDQNCj4gPiA+ID4gLS0tIGEvdmly
dC9rdm0va3ZtX21haW4uYw0KPiA+ID4gPiArKysgYi92aXJ0L2t2bS9rdm1fbWFpbi5jDQo+ID4g
PiA+IEBAIC0zMTEwLDYgKzMxMTAsNyBAQCB2b2lkIGt2bV92Y3B1X2Jsb2NrKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSkNCj4gPiA+ID4NCj4gPiA+ICsrdmNwdS0+c3RhdC5nZW5lcmljLmhhbHRfcG9s
bF9pbnZhbGlkOw0KPiA+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8g
b3V0Ow0KPiA+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICB9DQo+ID4gPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgIGNwdV9yZWxheCgpOw0KPiA+ID4gPiAgICAgICAgICAgICAgICAgICAg
ICAgICBwb2xsX2VuZCA9IGN1ciA9IGt0aW1lX2dldCgpOw0KPiA+ID4gPiAgICAgICAgICAgICAg
ICAgfSB3aGlsZSAoa3ZtX3ZjcHVfY2FuX3BvbGwoY3VyLCBzdG9wKSk7DQo+ID4gPiA+ICAgICAg
ICAgfQ0KPiA+ID4gPiAtLQ0KPiA+ID4gPiAyLjkuNA0KPiA+ID4gPg0K
