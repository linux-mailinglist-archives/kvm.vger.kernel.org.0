Return-Path: <kvm+bounces-5200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8559881DDAC
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 03:54:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7EC91C214C7
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 02:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04DCCD517;
	Mon, 25 Dec 2023 02:54:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.231.56.155])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F064CA70
	for <kvm@vger.kernel.org>; Mon, 25 Dec 2023 02:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from duchao$eswincomputing.com ( [123.139.59.82] ) by
 ajax-webmail-app2 (Coremail) ; Mon, 25 Dec 2023 10:52:50 +0800 (GMT+08:00)
Date: Mon, 25 Dec 2023 10:52:50 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Chao Du" <duchao@eswincomputing.com>
To: "Anup Patel" <apatel@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, anup@brainfault.org, 
	atishp@atishpatra.org, dbarboza@ventanamicro.com, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu
Subject: Re: Re: [RFC PATCH 0/3] RISC-V: KVM: Guest Debug Support
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.3 build 20220420(169d3f8c)
 Copyright (c) 2002-2023 www.mailtech.cn
 mispb-72143050-eaf5-4703-89e0-86624513b4ce-eswincomputing.com
In-Reply-To: <19434eff.1deb.18c90a3a375.Coremail.duchao@eswincomputing.com>
References: <20231221095002.7404-1-duchao@eswincomputing.com>
 <CAK9=C2Wfv7=fCitUdjBpC9=0icN82Bb+9p1-Gq5ha8o9v13nEg@mail.gmail.com>
 <19434eff.1deb.18c90a3a375.Coremail.duchao@eswincomputing.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <51c6e871.1f32.18c9ee3ae12.Coremail.duchao@eswincomputing.com>
X-Coremail-Locale: en_US
X-CM-TRANSID:TQJkCgBX5tSC7ohlUPwCAA--.2988W
X-CM-SenderInfo: xgxfxt3r6h245lqf0zpsxwx03jof0z/1tbiAgEQDGWITysSfgAAs6
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

T24gMjAyMy0xMi0yMiAxNjoyOCwgQ2hhbyBEdSA8ZHVjaGFvQGVzd2luY29tcHV0aW5nLmNvbT4g
d3JvdGU6Cj4gCj4gT24gMjAyMy0xMi0yMSAyMTowMSwgQW51cCBQYXRlbCA8YXBhdGVsQHZlbnRh
bmFtaWNyby5jb20+IHdyb3RlOgo+ID4gCj4gPiBPbiBUaHUsIERlYyAyMSwgMjAyMyBhdCAzOjIx
4oCvUE0gQ2hhbyBEdSA8ZHVjaGFvQGVzd2luY29tcHV0aW5nLmNvbT4gd3JvdGU6Cj4gPiA+Cj4g
PiA+IFRoaXMgc2VyaWVzIGltcGxlbWVudHMgS1ZNIEd1ZXN0IERlYnVnIG9uIFJJU0MtVi4gQ3Vy
cmVudGx5LCB3ZSBjYW4KPiA+ID4gZGVidWcgUklTQy1WIEtWTSBndWVzdCBmcm9tIHRoZSBob3N0
IHNpZGUsIHdpdGggc29mdHdhcmUgYnJlYWtwb2ludHMuCj4gPiA+Cj4gPiA+IEEgYnJpZWYgdGVz
dCB3YXMgZG9uZSBvbiBRRU1VIFJJU0MtViBoeXBlcnZpc29yIGVtdWxhdG9yLgo+ID4gPgo+ID4g
PiBBIFRPRE8gbGlzdCB3aGljaCB3aWxsIGJlIGFkZGVkIGxhdGVyOgo+ID4gPiAxLiBIVyBicmVh
a3BvaW50cyBzdXBwb3J0Cj4gPiA+IDIuIFRlc3QgY2FzZXMKPiA+IAo+ID4gSGltYW5zaHUgaGFz
IGFscmVhZHkgZG9uZSB0aGUgY29tcGxldGUgSFcgYnJlYWtwb2ludCBpbXBsZW1lbnRhdGlvbgo+
ID4gaW4gT3BlblNCSSwgTGludXggUklTQy1WLCBhbmQgS1ZNIFJJU0MtVi4gVGhpcyBpcyBiYXNl
ZCBvbiB0aGUgdXBjb21pbmcKPiA+IFNCSSBkZWJ1ZyB0cmlnZ2VyIGV4dGVuc2lvbiBkcmFmdCBw
cm9wb3NhbC4KPiA+IChSZWZlciwgaHR0cHM6Ly9saXN0cy5yaXNjdi5vcmcvZy90ZWNoLWRlYnVn
L21lc3NhZ2UvMTI2MSkKPiA+IAo+ID4gVGhlcmUgYXJlIGFsc28gUklTRSBwcm9qZWN0cyB0byB0
cmFjayB0aGVzZSBlZmZvcnRzOgo+ID4gaHR0cHM6Ly93aWtpLnJpc2Vwcm9qZWN0LmRldi9wYWdl
cy92aWV3cGFnZS5hY3Rpb24/cGFnZUlkPTM5NDU0MQo+ID4gaHR0cHM6Ly93aWtpLnJpc2Vwcm9q
ZWN0LmRldi9wYWdlcy92aWV3cGFnZS5hY3Rpb24/cGFnZUlkPTM5NDU0NQo+ID4gCj4gPiBDdXJy
ZW50bHksIHdlIGFyZSBpbiB0aGUgcHJvY2VzcyBvZiB1cHN0cmVhbWluZyB0aGUgT3BlblNCSSBz
dXBwb3J0Cj4gPiBmb3IgU0JJIGRlYnVnIHRyaWdnZXIgZXh0ZW5zaW9uLiBUaGUgTGludXggUklT
Qy1WIGFuZCBLVk0gUklTQy1WCj4gPiBwYXRjaGVzIHJlcXVpcmUgU0JJIGRlYnVnIHRyaWdnZXIg
ZXh0ZW5zaW9uIGFuZCBTZHRyaWcgZXh0ZW5zaW9uIHRvCj4gPiBiZSBmcm96ZW4gd2hpY2ggd2ls
bCBoYXBwZW4gbmV4dCB5ZWFyIDIwMjQuCj4gPiAKPiA+IFJlZ2FyZHMsCj4gPiBBbnVwCj4gPiAK
PiAKPiBIaSBBbnVwLAo+IAo+IFRoYW5rIHlvdSBmb3IgdGhlIGluZm9ybWF0aW9uIGFuZCB5b3Vy
IGdyZWF0IHdvcmsgb24gdGhlIFNCSQo+IERlYnVnIFRyaWdnZXIgRXh0ZW5zaW9uIHByb3Bvc2Fs
Lgo+IAo+IFNvIEkgdGhpbmsgdGhhdCAnSFcgYnJlYWtwb2ludHMgc3VwcG9ydCcgaW4gdGhlIGFi
b3ZlIFRPRE8gbGlzdAo+IHdpbGwgYmUgdGFrZW4gY2FyZSBvZiBieSBIaW1hbnNodSBmb2xsb3dp
bmcgdGhlIGV4dGVuc2lvbiBwcm9wb3NhbC4KPiAKPiBPbiB0aGUgb3RoZXIgaGFuZCwgaWYgSSB1
bmRlcnN0YW5kIGNvcnJlY3RseSwgdGhlIHNvZnR3YXJlCj4gYnJlYWtwb2ludCBwYXJ0IG9mIEtW
TSBHdWVzdCBEZWJ1ZyBoYXMgbm8gZGVwZW5kZW5jeSBvbiB0aGUgbmV3Cj4gZXh0ZW5zaW9uIHNp
bmNlIGl0IGRvZXMgbm90IHVzZSB0aGUgdHJpZ2dlciBtb2R1bGUuIEp1c3QgYW4KPiBlYnJlYWsg
c3Vic3RpdHV0aW9uIGlzIG1hZGUuCj4gCj4gU28gbWF5IEkga25vdyB5b3VyIHN1Z2dlc3Rpb24g
YWJvdXQgdGhpcyBSRkM/IEJvdGggaW4gS1ZNIGFuZCBRRU1VLgo+IAo+IFJlZ2FyZHMsCj4gQ2hh
bwo+IAoKSGkgQW51cCBhbmQgYWxsLAoKSSdtIHN0aWxsIHdhaXRpbmcgZm9yIHlvdXIgY29tbWVu
dCBhbmQgc3VnZ2VzdGlvbiBmb3IgdGhlIG5leHQgc3RlcC4KOikKClRoYW5rcwoKPiA+ID4KPiA+
ID4gVGhpcyBzZXJpZXMgaXMgYmFzZWQgb24gTGludXggNi43LXJjNiBhbmQgaXMgYWxzbyBhdmFp
bGFibGUgYXQ6Cj4gPiA+IGh0dHBzOi8vZ2l0aHViLmNvbS9EdS1DaGFvL2xpbnV4L3RyZWUvcmlz
Y3ZfZ2Rfc3cKPiA+ID4KPiA+ID4gVGhlIG1hdGNoZWQgUUVNVSBpcyBhdmFpbGFibGUgYXQ6Cj4g
PiA+IGh0dHBzOi8vZ2l0aHViLmNvbS9EdS1DaGFvL3FlbXUvdHJlZS9yaXNjdl9nZF9zdwo+ID4g
Pgo+ID4gPiBDaGFvIER1ICgzKToKPiA+ID4gICBSSVNDLVY6IEtWTTogRW5hYmxlIHRoZSBLVk1f
Q0FQX1NFVF9HVUVTVF9ERUJVRyBjYXBhYmlsaXR5Cj4gPiA+ICAgUklTQy1WOiBLVk06IEltcGxl
bWVudCBrdm1fYXJjaF92Y3B1X2lvY3RsX3NldF9ndWVzdF9kZWJ1ZygpCj4gPiA+ICAgUklTQy1W
OiBLVk06IEhhbmRsZSBicmVha3BvaW50IGV4aXRzIGZvciBWQ1BVCj4gPiA+Cj4gPiA+ICBhcmNo
L3Jpc2N2L2luY2x1ZGUvdWFwaS9hc20va3ZtLmggfCAgMSArCj4gPiA+ICBhcmNoL3Jpc2N2L2t2
bS92Y3B1LmMgICAgICAgICAgICAgfCAxNSArKysrKysrKysrKysrLS0KPiA+ID4gIGFyY2gvcmlz
Y3Yva3ZtL3ZjcHVfZXhpdC5jICAgICAgICB8ICA0ICsrKysKPiA+ID4gIGFyY2gvcmlzY3Yva3Zt
L3ZtLmMgICAgICAgICAgICAgICB8ICAxICsKPiA+ID4gIDQgZmlsZXMgY2hhbmdlZCwgMTkgaW5z
ZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPiA+ID4KPiA+ID4gLS0KPiA+ID4gMi4xNy4xCj4g
PiA+Cj4gPiA+Cj4gPiA+IC0tCj4gPiA+IGt2bS1yaXNjdiBtYWlsaW5nIGxpc3QKPiA+ID4ga3Zt
LXJpc2N2QGxpc3RzLmluZnJhZGVhZC5vcmcKPiA+ID4gaHR0cDovL2xpc3RzLmluZnJhZGVhZC5v
cmcvbWFpbG1hbi9saXN0aW5mby9rdm0tcmlzY3YK

