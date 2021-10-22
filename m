Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23D64370B6
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 06:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbhJVESZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 00:18:25 -0400
Received: from mx24.baidu.com ([111.206.215.185]:39728 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229463AbhJVESY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 00:18:24 -0400
Received: from BJHW-Mail-Ex14.internal.baidu.com (unknown [10.127.64.37])
        by Forcepoint Email with ESMTPS id 18F8E6EA4C542A73A90;
        Fri, 22 Oct 2021 12:16:06 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Fri, 22 Oct 2021 12:16:05 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.014; Fri, 22 Oct 2021 12:16:05 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXVt2Ml0gS1ZNOiB4ODY6IGRpcmVjdGx5IGNhbGwgd2Jp?=
 =?gb2312?Q?nvd_for_local_cpu_when_emulate_wbinvd?=
Thread-Topic: [PATCH][v2] KVM: x86: directly call wbinvd for local cpu when
 emulate wbinvd
Thread-Index: AQHXwBaxxg5nBZNTvUWIcXVUwDFNd6vedoUg
Date:   Fri, 22 Oct 2021 04:16:05 +0000
Message-ID: <4857464fb9684af8a485ce9eb790fd75@baidu.com>
References: <1634118172-32699-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1634118172-32699-1-git-send-email-lirongqing@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.4]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex14_2021-10-22 12:16:05:941
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

UGluZyANCg0KLUxpDQoNCj4gLS0tLS3Tyrz+1K28/i0tLS0tDQo+ILeivP7IyzogTGksUm9uZ3Fp
bmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiC3osvNyrG85DogMjAyMcTqMTDUwjEzyNUgMTc6
NDMNCj4gytW8/sjLOiB4ODZAa2VybmVsLm9yZzsga3ZtQHZnZXIua2VybmVsLm9yZzsgTGksUm9u
Z3FpbmcNCj4gPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiDW98ziOiBbUEFUQ0hdW3YyXSBLVk06
IHg4NjogZGlyZWN0bHkgY2FsbCB3YmludmQgZm9yIGxvY2FsIGNwdSB3aGVuIGVtdWxhdGUNCj4g
d2JpbnZkDQo+IA0KPiBkaXJlY3RseSBjYWxsIHdiaW52ZCBmb3IgbG9jYWwgY3B1LCBpbnN0ZWFk
IG9mIGNhbGxpbmcgYXRvbWljIGNwdW1hc2tfc2V0X2NwdSB0bw0KPiBzZXQgbG9jYWwgY3B1LCBh
bmQgdGhlbiBjaGVjayBpZiBsb2NhbCBjcHUgbmVlZHMgdG8gcnVuIGluIG9uX2VhY2hfY3B1X21h
c2sNCj4gDQo+IG9uX2VhY2hfY3B1X21hc2sgaXMgbGVzcyBlZmZpY2llbnQgdGhhbiBzbXBfY2Fs
bF9mdW5jdGlvbl9tYW55LCBzaW5jZSBpdCB3aWxsDQo+IGNsb3NlIHByZWVtcHQgYWdhaW4gYW5k
IHJ1bm5pbmcgY2FsbCBmdW5jdGlvbiBieSBjaGVja2luZyBmbGFnIHdpdGgNCj4gU0NGX1JVTl9M
T0NBTC4gYW5kIGhlcmUgd2JpbnZkIGNhbiBiZSBjYWxsZWQgZGlyZWN0bHkNCj4gDQo+IEluIGZh
Y3QsIFRoaXMgY2hhbmdlIHJldmVydHMgY29tbWl0IDJlZWM3MzQzNzQ4NyAoIktWTTogeDg2OiBB
dm9pZCBpc3N1aW5nDQo+IHdiaW52ZCB0d2ljZSIpLCBzaW5jZSBzbXBfY2FsbF9mdW5jdGlvbl9t
YW55IGlzIHNraXBpbmcgdGhlIGxvY2FsIGNwdSAoYXMNCj4gZGVzY3JpcHRpb24gb2YgYzIxNjJl
MTNkNmUyZiksIHdiaW52ZCBpcyBub3QgaXNzdWVkIHR3aWNlDQo+IA0KPiBhbmQgcmV2ZXJ0cyBj
b21taXQgYzIxNjJlMTNkNmUyZiAoIktWTTogWDg2OiBGaXggbWlzc2luZyBsb2NhbCBwQ1BVIHdo
ZW4NCj4gZXhlY3V0aW5nIHdiaW52ZCBvbiBhbGwgZGlydHkgcENQVXMiKSB0b28sIHdoaWNoIGZp
eGVkIHRoZSBwcmV2aW91cyBwYXRjaCwgd2hlbg0KPiByZXZlcnQgcHJldmlvdXMgcGF0Y2gsIGl0
IGlzIG5vdCBuZWVkZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBMaSBSb25nUWluZyA8bGlyb25n
cWluZ0BiYWlkdS5jb20+DQo+IC0tLQ0KPiBkaWZmIHYyOiByZXdyaXRlIGNvbW1pdCBsb2cNCj4g
DQo+ICBhcmNoL3g4Ni9rdm0veDg2LmMgfCAgIDEzICsrKysrKy0tLS0tLS0NCj4gIDEgZmlsZXMg
Y2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYyBpbmRleCBhYWJkM2Ey
Li4yOGM0YzcyDQo+IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gKysrIGIv
YXJjaC94ODYva3ZtL3g4Ni5jDQo+IEBAIC02OTkxLDE1ICs2OTkxLDE0IEBAIHN0YXRpYyBpbnQg
a3ZtX2VtdWxhdGVfd2JpbnZkX25vc2tpcChzdHJ1Y3QNCj4ga3ZtX3ZjcHUgKnZjcHUpDQo+ICAJ
CXJldHVybiBYODZFTVVMX0NPTlRJTlVFOw0KPiANCj4gIAlpZiAoc3RhdGljX2NhbGwoa3ZtX3g4
Nl9oYXNfd2JpbnZkX2V4aXQpKCkpIHsNCj4gLQkJaW50IGNwdSA9IGdldF9jcHUoKTsNCj4gLQ0K
PiAtCQljcHVtYXNrX3NldF9jcHUoY3B1LCB2Y3B1LT5hcmNoLndiaW52ZF9kaXJ0eV9tYXNrKTsN
Cj4gLQkJb25fZWFjaF9jcHVfbWFzayh2Y3B1LT5hcmNoLndiaW52ZF9kaXJ0eV9tYXNrLA0KPiAr
CQlwcmVlbXB0X2Rpc2FibGUoKTsNCj4gKwkJc21wX2NhbGxfZnVuY3Rpb25fbWFueSh2Y3B1LT5h
cmNoLndiaW52ZF9kaXJ0eV9tYXNrLA0KPiAgCQkJCXdiaW52ZF9pcGksIE5VTEwsIDEpOw0KPiAt
CQlwdXRfY3B1KCk7DQo+ICsJCXByZWVtcHRfZW5hYmxlKCk7DQo+ICAJCWNwdW1hc2tfY2xlYXIo
dmNwdS0+YXJjaC53YmludmRfZGlydHlfbWFzayk7DQo+IC0JfSBlbHNlDQo+IC0JCXdiaW52ZCgp
Ow0KPiArCX0NCj4gKw0KPiArCXdiaW52ZCgpOw0KPiAgCXJldHVybiBYODZFTVVMX0NPTlRJTlVF
Ow0KPiAgfQ0KPiANCj4gLS0NCj4gMS43LjENCg0K
