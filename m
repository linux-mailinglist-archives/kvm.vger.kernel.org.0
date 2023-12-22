Return-Path: <kvm+bounces-5128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFAAD81C6A5
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 09:30:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7286D1F2644F
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 08:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DACECCA65;
	Fri, 22 Dec 2023 08:30:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C36FD2E0
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 08:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from duchao$eswincomputing.com ( [123.139.59.82] ) by
 ajax-webmail-app2 (Coremail) ; Fri, 22 Dec 2023 16:28:12 +0800 (GMT+08:00)
Date: Fri, 22 Dec 2023 16:28:12 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Chao Du" <duchao@eswincomputing.com>
To: "Anup Patel" <apatel@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, anup@brainfault.org, 
	atishp@atishpatra.org, dbarboza@ventanamicro.com, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu
Subject: Re: [RFC PATCH 0/3] RISC-V: KVM: Guest Debug Support
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.3 build 20220420(169d3f8c)
 Copyright (c) 2002-2023 www.mailtech.cn
 mispb-72143050-eaf5-4703-89e0-86624513b4ce-eswincomputing.com
In-Reply-To: <CAK9=C2Wfv7=fCitUdjBpC9=0icN82Bb+9p1-Gq5ha8o9v13nEg@mail.gmail.com>
References: <20231221095002.7404-1-duchao@eswincomputing.com>
 <CAK9=C2Wfv7=fCitUdjBpC9=0icN82Bb+9p1-Gq5ha8o9v13nEg@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <19434eff.1deb.18c90a3a375.Coremail.duchao@eswincomputing.com>
X-Coremail-Locale: en_US
X-CM-TRANSID:TQJkCgBX5tScSIVlKrMCAA--.2850W
X-CM-SenderInfo: xgxfxt3r6h245lqf0zpsxwx03jof0z/1tbiAQENDGWEWng11AACsh
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

T24gMjAyMy0xMi0yMSAyMTowMSwgQW51cCBQYXRlbCA8YXBhdGVsQHZlbnRhbmFtaWNyby5jb20+
IHdyb3RlOgo+IAo+IE9uIFRodSwgRGVjIDIxLCAyMDIzIGF0IDM6MjHigK9QTSBDaGFvIER1IDxk
dWNoYW9AZXN3aW5jb21wdXRpbmcuY29tPiB3cm90ZToKPiA+Cj4gPiBUaGlzIHNlcmllcyBpbXBs
ZW1lbnRzIEtWTSBHdWVzdCBEZWJ1ZyBvbiBSSVNDLVYuIEN1cnJlbnRseSwgd2UgY2FuCj4gPiBk
ZWJ1ZyBSSVNDLVYgS1ZNIGd1ZXN0IGZyb20gdGhlIGhvc3Qgc2lkZSwgd2l0aCBzb2Z0d2FyZSBi
cmVha3BvaW50cy4KPiA+Cj4gPiBBIGJyaWVmIHRlc3Qgd2FzIGRvbmUgb24gUUVNVSBSSVNDLVYg
aHlwZXJ2aXNvciBlbXVsYXRvci4KPiA+Cj4gPiBBIFRPRE8gbGlzdCB3aGljaCB3aWxsIGJlIGFk
ZGVkIGxhdGVyOgo+ID4gMS4gSFcgYnJlYWtwb2ludHMgc3VwcG9ydAo+ID4gMi4gVGVzdCBjYXNl
cwo+IAo+IEhpbWFuc2h1IGhhcyBhbHJlYWR5IGRvbmUgdGhlIGNvbXBsZXRlIEhXIGJyZWFrcG9p
bnQgaW1wbGVtZW50YXRpb24KPiBpbiBPcGVuU0JJLCBMaW51eCBSSVNDLVYsIGFuZCBLVk0gUklT
Qy1WLiBUaGlzIGlzIGJhc2VkIG9uIHRoZSB1cGNvbWluZwo+IFNCSSBkZWJ1ZyB0cmlnZ2VyIGV4
dGVuc2lvbiBkcmFmdCBwcm9wb3NhbC4KPiAoUmVmZXIsIGh0dHBzOi8vbGlzdHMucmlzY3Yub3Jn
L2cvdGVjaC1kZWJ1Zy9tZXNzYWdlLzEyNjEpCj4gCj4gVGhlcmUgYXJlIGFsc28gUklTRSBwcm9q
ZWN0cyB0byB0cmFjayB0aGVzZSBlZmZvcnRzOgo+IGh0dHBzOi8vd2lraS5yaXNlcHJvamVjdC5k
ZXYvcGFnZXMvdmlld3BhZ2UuYWN0aW9uP3BhZ2VJZD0zOTQ1NDEKPiBodHRwczovL3dpa2kucmlz
ZXByb2plY3QuZGV2L3BhZ2VzL3ZpZXdwYWdlLmFjdGlvbj9wYWdlSWQ9Mzk0NTQ1Cj4gCj4gQ3Vy
cmVudGx5LCB3ZSBhcmUgaW4gdGhlIHByb2Nlc3Mgb2YgdXBzdHJlYW1pbmcgdGhlIE9wZW5TQkkg
c3VwcG9ydAo+IGZvciBTQkkgZGVidWcgdHJpZ2dlciBleHRlbnNpb24uIFRoZSBMaW51eCBSSVND
LVYgYW5kIEtWTSBSSVNDLVYKPiBwYXRjaGVzIHJlcXVpcmUgU0JJIGRlYnVnIHRyaWdnZXIgZXh0
ZW5zaW9uIGFuZCBTZHRyaWcgZXh0ZW5zaW9uIHRvCj4gYmUgZnJvemVuIHdoaWNoIHdpbGwgaGFw
cGVuIG5leHQgeWVhciAyMDI0Lgo+IAo+IFJlZ2FyZHMsCj4gQW51cAo+IAoKSGkgQW51cCwKClRo
YW5rIHlvdSBmb3IgdGhlIGluZm9ybWF0aW9uIGFuZCB5b3VyIGdyZWF0IHdvcmsgb24gdGhlIFNC
SQpEZWJ1ZyBUcmlnZ2VyIEV4dGVuc2lvbiBwcm9wb3NhbC4KClNvIEkgdGhpbmsgdGhhdCAnSFcg
YnJlYWtwb2ludHMgc3VwcG9ydCcgaW4gdGhlIGFib3ZlIFRPRE8gbGlzdAp3aWxsIGJlIHRha2Vu
IGNhcmUgb2YgYnkgSGltYW5zaHUgZm9sbG93aW5nIHRoZSBleHRlbnNpb24gcHJvcG9zYWwuCgpP
biB0aGUgb3RoZXIgaGFuZCwgaWYgSSB1bmRlcnN0YW5kIGNvcnJlY3RseSwgdGhlIHNvZnR3YXJl
CmJyZWFrcG9pbnQgcGFydCBvZiBLVk0gR3Vlc3QgRGVidWcgaGFzIG5vIGRlcGVuZGVuY3kgb24g
dGhlIG5ldwpleHRlbnNpb24gc2luY2UgaXQgZG9lcyBub3QgdXNlIHRoZSB0cmlnZ2VyIG1vZHVs
ZS4gSnVzdCBhbgplYnJlYWsgc3Vic3RpdHV0aW9uIGlzIG1hZGUuCgpTbyBtYXkgSSBrbm93IHlv
dXIgc3VnZ2VzdGlvbiBhYm91dCB0aGlzIFJGQz8gQm90aCBpbiBLVk0gYW5kIFFFTVUuCgpSZWdh
cmRzLApDaGFvCgo+ID4KPiA+IFRoaXMgc2VyaWVzIGlzIGJhc2VkIG9uIExpbnV4IDYuNy1yYzYg
YW5kIGlzIGFsc28gYXZhaWxhYmxlIGF0Ogo+ID4gaHR0cHM6Ly9naXRodWIuY29tL0R1LUNoYW8v
bGludXgvdHJlZS9yaXNjdl9nZF9zdwo+ID4KPiA+IFRoZSBtYXRjaGVkIFFFTVUgaXMgYXZhaWxh
YmxlIGF0Ogo+ID4gaHR0cHM6Ly9naXRodWIuY29tL0R1LUNoYW8vcWVtdS90cmVlL3Jpc2N2X2dk
X3N3Cj4gPgo+ID4gQ2hhbyBEdSAoMyk6Cj4gPiAgIFJJU0MtVjogS1ZNOiBFbmFibGUgdGhlIEtW
TV9DQVBfU0VUX0dVRVNUX0RFQlVHIGNhcGFiaWxpdHkKPiA+ICAgUklTQy1WOiBLVk06IEltcGxl
bWVudCBrdm1fYXJjaF92Y3B1X2lvY3RsX3NldF9ndWVzdF9kZWJ1ZygpCj4gPiAgIFJJU0MtVjog
S1ZNOiBIYW5kbGUgYnJlYWtwb2ludCBleGl0cyBmb3IgVkNQVQo+ID4KPiA+ICBhcmNoL3Jpc2N2
L2luY2x1ZGUvdWFwaS9hc20va3ZtLmggfCAgMSArCj4gPiAgYXJjaC9yaXNjdi9rdm0vdmNwdS5j
ICAgICAgICAgICAgIHwgMTUgKysrKysrKysrKysrKy0tCj4gPiAgYXJjaC9yaXNjdi9rdm0vdmNw
dV9leGl0LmMgICAgICAgIHwgIDQgKysrKwo+ID4gIGFyY2gvcmlzY3Yva3ZtL3ZtLmMgICAgICAg
ICAgICAgICB8ICAxICsKPiA+ICA0IGZpbGVzIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pCj4gPgo+ID4gLS0KPiA+IDIuMTcuMQo+ID4KPiA+Cj4gPiAtLQo+ID4ga3Zt
LXJpc2N2IG1haWxpbmcgbGlzdAo+ID4ga3ZtLXJpc2N2QGxpc3RzLmluZnJhZGVhZC5vcmcKPiA+
IGh0dHA6Ly9saXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8va3ZtLXJpc2N2Cg==


