Return-Path: <kvm+bounces-5629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9122C823F63
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 11:24:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E322287092
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 10:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DB9E20B26;
	Thu,  4 Jan 2024 10:24:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tndyumtaxlji0oc4xnzya.icoremail.net (zg8tndyumtaxlji0oc4xnzya.icoremail.net [46.101.248.176])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6516E20B16
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 10:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from duchao$eswincomputing.com ( [123.139.59.82] ) by
 ajax-webmail-app2 (Coremail) ; Thu, 4 Jan 2024 18:22:26 +0800 (GMT+08:00)
Date: Thu, 4 Jan 2024 18:22:26 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Chao Du" <duchao@eswincomputing.com>
To: "Anup Patel" <apatel@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, anup@brainfault.org, 
	atishp@atishpatra.org, dbarboza@ventanamicro.com, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu
Subject: Re: [RFC PATCH 0/3] RISC-V: KVM: Guest Debug Support
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.3 build 20220420(169d3f8c)
 Copyright (c) 2002-2024 www.mailtech.cn
 mispb-72143050-eaf5-4703-89e0-86624513b4ce-eswincomputing.com
In-Reply-To: <51c6e871.1f32.18c9ee3ae12.Coremail.duchao@eswincomputing.com>
References: <20231221095002.7404-1-duchao@eswincomputing.com>
 <CAK9=C2Wfv7=fCitUdjBpC9=0icN82Bb+9p1-Gq5ha8o9v13nEg@mail.gmail.com>
 <19434eff.1deb.18c90a3a375.Coremail.duchao@eswincomputing.com>
 <51c6e871.1f32.18c9ee3ae12.Coremail.duchao@eswincomputing.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <2be7402e.34b.18cd3fee5ab.Coremail.duchao@eswincomputing.com>
X-Coremail-Locale: en_US
X-CM-TRANSID:TQJkCgDHVdTihpZlT14EAA--.3989W
X-CM-SenderInfo: xgxfxt3r6h245lqf0zpsxwx03jof0z/1tbiAgEGDGWVfiwd9gAAsA
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

SGkgYWxsLAoKR2VudGxlIHBpbmcuCgpJbiBteSBwb2ludCBvZiB2aWV3LCB0aGVzZSBwYXRjaGVz
IGZvY3VzIG9uIHRoZSBzb2Z0d2FyZSBicmVha3BvaW50Cm9mIEtWTSBHdWVzdCBEZWJ1Zywgd2hp
Y2ggYXJlIGluZGVwZW5kZW50IG9mIHRoZSBTQkkgZXh0ZW5zaW9ucyBBbnVwCm1lbnRpb25lZC4K
ClBsZWFzZSBjb3JyZWN0IG1lIGlmIEknbSB3cm9uZy4KClRoYW5rcywKQ2hhbwoKT24gMjAyMy0x
Mi0yNSAxMDo1MiwgQ2hhbyBEdSA8ZHVjaGFvQGVzd2luY29tcHV0aW5nLmNvbT4gd3JvdGU6Cj4g
Cj4gT24gMjAyMy0xMi0yMiAxNjoyOCwgQ2hhbyBEdSA8ZHVjaGFvQGVzd2luY29tcHV0aW5nLmNv
bT4gd3JvdGU6Cj4gPiAKPiA+IE9uIDIwMjMtMTItMjEgMjE6MDEsIEFudXAgUGF0ZWwgPGFwYXRl
bEB2ZW50YW5hbWljcm8uY29tPiB3cm90ZToKPiA+ID4gCj4gPiA+IE9uIFRodSwgRGVjIDIxLCAy
MDIzIGF0IDM6MjHigK9QTSBDaGFvIER1IDxkdWNoYW9AZXN3aW5jb21wdXRpbmcuY29tPiB3cm90
ZToKPiA+ID4gPgo+ID4gPiA+IFRoaXMgc2VyaWVzIGltcGxlbWVudHMgS1ZNIEd1ZXN0IERlYnVn
IG9uIFJJU0MtVi4gQ3VycmVudGx5LCB3ZSBjYW4KPiA+ID4gPiBkZWJ1ZyBSSVNDLVYgS1ZNIGd1
ZXN0IGZyb20gdGhlIGhvc3Qgc2lkZSwgd2l0aCBzb2Z0d2FyZSBicmVha3BvaW50cy4KPiA+ID4g
Pgo+ID4gPiA+IEEgYnJpZWYgdGVzdCB3YXMgZG9uZSBvbiBRRU1VIFJJU0MtViBoeXBlcnZpc29y
IGVtdWxhdG9yLgo+ID4gPiA+Cj4gPiA+ID4gQSBUT0RPIGxpc3Qgd2hpY2ggd2lsbCBiZSBhZGRl
ZCBsYXRlcjoKPiA+ID4gPiAxLiBIVyBicmVha3BvaW50cyBzdXBwb3J0Cj4gPiA+ID4gMi4gVGVz
dCBjYXNlcwo+ID4gPiAKPiA+ID4gSGltYW5zaHUgaGFzIGFscmVhZHkgZG9uZSB0aGUgY29tcGxl
dGUgSFcgYnJlYWtwb2ludCBpbXBsZW1lbnRhdGlvbgo+ID4gPiBpbiBPcGVuU0JJLCBMaW51eCBS
SVNDLVYsIGFuZCBLVk0gUklTQy1WLiBUaGlzIGlzIGJhc2VkIG9uIHRoZSB1cGNvbWluZwo+ID4g
PiBTQkkgZGVidWcgdHJpZ2dlciBleHRlbnNpb24gZHJhZnQgcHJvcG9zYWwuCj4gPiA+IChSZWZl
ciwgaHR0cHM6Ly9saXN0cy5yaXNjdi5vcmcvZy90ZWNoLWRlYnVnL21lc3NhZ2UvMTI2MSkKPiA+
ID4gCj4gPiA+IFRoZXJlIGFyZSBhbHNvIFJJU0UgcHJvamVjdHMgdG8gdHJhY2sgdGhlc2UgZWZm
b3J0czoKPiA+ID4gaHR0cHM6Ly93aWtpLnJpc2Vwcm9qZWN0LmRldi9wYWdlcy92aWV3cGFnZS5h
Y3Rpb24/cGFnZUlkPTM5NDU0MQo+ID4gPiBodHRwczovL3dpa2kucmlzZXByb2plY3QuZGV2L3Bh
Z2VzL3ZpZXdwYWdlLmFjdGlvbj9wYWdlSWQ9Mzk0NTQ1Cj4gPiA+IAo+ID4gPiBDdXJyZW50bHks
IHdlIGFyZSBpbiB0aGUgcHJvY2VzcyBvZiB1cHN0cmVhbWluZyB0aGUgT3BlblNCSSBzdXBwb3J0
Cj4gPiA+IGZvciBTQkkgZGVidWcgdHJpZ2dlciBleHRlbnNpb24uIFRoZSBMaW51eCBSSVNDLVYg
YW5kIEtWTSBSSVNDLVYKPiA+ID4gcGF0Y2hlcyByZXF1aXJlIFNCSSBkZWJ1ZyB0cmlnZ2VyIGV4
dGVuc2lvbiBhbmQgU2R0cmlnIGV4dGVuc2lvbiB0bwo+ID4gPiBiZSBmcm96ZW4gd2hpY2ggd2ls
bCBoYXBwZW4gbmV4dCB5ZWFyIDIwMjQuCj4gPiA+IAo+ID4gPiBSZWdhcmRzLAo+ID4gPiBBbnVw
Cj4gPiA+IAo+ID4gCj4gPiBIaSBBbnVwLAo+ID4gCj4gPiBUaGFuayB5b3UgZm9yIHRoZSBpbmZv
cm1hdGlvbiBhbmQgeW91ciBncmVhdCB3b3JrIG9uIHRoZSBTQkkKPiA+IERlYnVnIFRyaWdnZXIg
RXh0ZW5zaW9uIHByb3Bvc2FsLgo+ID4gCj4gPiBTbyBJIHRoaW5rIHRoYXQgJ0hXIGJyZWFrcG9p
bnRzIHN1cHBvcnQnIGluIHRoZSBhYm92ZSBUT0RPIGxpc3QKPiA+IHdpbGwgYmUgdGFrZW4gY2Fy
ZSBvZiBieSBIaW1hbnNodSBmb2xsb3dpbmcgdGhlIGV4dGVuc2lvbiBwcm9wb3NhbC4KPiA+IAo+
ID4gT24gdGhlIG90aGVyIGhhbmQsIGlmIEkgdW5kZXJzdGFuZCBjb3JyZWN0bHksIHRoZSBzb2Z0
d2FyZQo+ID4gYnJlYWtwb2ludCBwYXJ0IG9mIEtWTSBHdWVzdCBEZWJ1ZyBoYXMgbm8gZGVwZW5k
ZW5jeSBvbiB0aGUgbmV3Cj4gPiBleHRlbnNpb24gc2luY2UgaXQgZG9lcyBub3QgdXNlIHRoZSB0
cmlnZ2VyIG1vZHVsZS4gSnVzdCBhbgo+ID4gZWJyZWFrIHN1YnN0aXR1dGlvbiBpcyBtYWRlLgo+
ID4gCj4gPiBTbyBtYXkgSSBrbm93IHlvdXIgc3VnZ2VzdGlvbiBhYm91dCB0aGlzIFJGQz8gQm90
aCBpbiBLVk0gYW5kIFFFTVUuCj4gPiAKPiA+IFJlZ2FyZHMsCj4gPiBDaGFvCj4gPiAKPiAKPiBI
aSBBbnVwIGFuZCBhbGwsCj4gCj4gSSdtIHN0aWxsIHdhaXRpbmcgZm9yIHlvdXIgY29tbWVudCBh
bmQgc3VnZ2VzdGlvbiBmb3IgdGhlIG5leHQgc3RlcC4KPiA6KQo+IAo+IFRoYW5rcwo+IAo+ID4g
PiA+Cj4gPiA+ID4gVGhpcyBzZXJpZXMgaXMgYmFzZWQgb24gTGludXggNi43LXJjNiBhbmQgaXMg
YWxzbyBhdmFpbGFibGUgYXQ6Cj4gPiA+ID4gaHR0cHM6Ly9naXRodWIuY29tL0R1LUNoYW8vbGlu
dXgvdHJlZS9yaXNjdl9nZF9zdwo+ID4gPiA+Cj4gPiA+ID4gVGhlIG1hdGNoZWQgUUVNVSBpcyBh
dmFpbGFibGUgYXQ6Cj4gPiA+ID4gaHR0cHM6Ly9naXRodWIuY29tL0R1LUNoYW8vcWVtdS90cmVl
L3Jpc2N2X2dkX3N3Cj4gPiA+ID4KPiA+ID4gPiBDaGFvIER1ICgzKToKPiA+ID4gPiAgIFJJU0Mt
VjogS1ZNOiBFbmFibGUgdGhlIEtWTV9DQVBfU0VUX0dVRVNUX0RFQlVHIGNhcGFiaWxpdHkKPiA+
ID4gPiAgIFJJU0MtVjogS1ZNOiBJbXBsZW1lbnQga3ZtX2FyY2hfdmNwdV9pb2N0bF9zZXRfZ3Vl
c3RfZGVidWcoKQo+ID4gPiA+ICAgUklTQy1WOiBLVk06IEhhbmRsZSBicmVha3BvaW50IGV4aXRz
IGZvciBWQ1BVCj4gPiA+ID4KPiA+ID4gPiAgYXJjaC9yaXNjdi9pbmNsdWRlL3VhcGkvYXNtL2t2
bS5oIHwgIDEgKwo+ID4gPiA+ICBhcmNoL3Jpc2N2L2t2bS92Y3B1LmMgICAgICAgICAgICAgfCAx
NSArKysrKysrKysrKysrLS0KPiA+ID4gPiAgYXJjaC9yaXNjdi9rdm0vdmNwdV9leGl0LmMgICAg
ICAgIHwgIDQgKysrKwo+ID4gPiA+ICBhcmNoL3Jpc2N2L2t2bS92bS5jICAgICAgICAgICAgICAg
fCAgMSArCj4gPiA+ID4gIDQgZmlsZXMgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkKPiA+ID4gPgo+ID4gPiA+IC0tCj4gPiA+ID4gMi4xNy4xCj4gPiA+ID4KPiA+ID4g
Pgo+ID4gPiA+IC0tCj4gPiA+ID4ga3ZtLXJpc2N2IG1haWxpbmcgbGlzdAo+ID4gPiA+IGt2bS1y
aXNjdkBsaXN0cy5pbmZyYWRlYWQub3JnCj4gPiA+ID4gaHR0cDovL2xpc3RzLmluZnJhZGVhZC5v
cmcvbWFpbG1hbi9saXN0aW5mby9rdm0tcmlzY3YK

