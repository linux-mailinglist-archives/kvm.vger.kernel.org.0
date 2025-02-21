Return-Path: <kvm+bounces-38827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EEA7A3EAC5
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 03:29:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04747175524
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 02:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E33C1D515A;
	Fri, 21 Feb 2025 02:29:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmja2lje4os43os4xodqa.icoremail.net (zg8tmja2lje4os43os4xodqa.icoremail.net [206.189.79.184])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE8A1B85FD
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 02:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.79.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740104956; cv=none; b=oJup6fnUHaoq0BbxtJQWumA/ia5JPOfnYrB/LlCVx69PvxYBcnFFP8M+fN08xv9Tr/aGronWkVtPvsE+00J/py9i82hTvH5sSAbDRNzzyuV3Wzxf89J/CubykSgozKWqHQvVE2B0O7ZaSG2kEiFLAkZdY8RSYgW1jYB6kqTbXqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740104956; c=relaxed/simple;
	bh=FK4brgrCp+l8uFqnG8IFktTxmnRRVclE44F4kyEtYlo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=p7x3eyMKZbv/smmaHsxzDUd8YLKRS9Khl7ydRVimG4zYi+ZGNAFYcCjKGSWlSy5idkYsMVgKGXgMFgJzeWhjI/DhA3rjIM5tDgBMmFJxlpZgHI/B0TUjw2ZUpIoLx39MUGTqKSAZtvh68QzNfBenF+MjI5kXryVkuyydOuDgRuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=206.189.79.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from duchao$eswincomputing.com ( [10.64.112.210] ) by
 ajax-webmail-app1 (Coremail) ; Fri, 21 Feb 2025 10:28:27 +0800 (GMT+08:00)
Date: Fri, 21 Feb 2025 10:28:27 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Chao Du" <duchao@eswincomputing.com>
To: "Andrew Jones" <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, anup@brainfault.org,
	atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Subject: Re: [PATCH] RISC-V: KVM: Fix comments in
 kvm_riscv_vcpu_isa_disable_allowed
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2024.2-cmXT6 build
 20241010(a2f59183) Copyright (c) 2002-2025 www.mailtech.cn
 mispb-72143050-eaf5-4703-89e0-86624513b4ce-eswincomputing.com
In-Reply-To: <20250220-69956156f8489f179d3ed97d@orel>
References: <20250220074905.29014-1-duchao@eswincomputing.com>
 <20250220-69956156f8489f179d3ed97d@orel>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <10c88f03.11fe.1952655ba39.Coremail.duchao@eswincomputing.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:TAJkCgA3WxHL5Ldn4gQnAA--.1946W
X-CM-SenderInfo: xgxfxt3r6h245lqf0zpsxwx03jof0z/1tbiAQEADGe3WNkL2wAAsN
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

T24gMjAyNS0wMi0yMCAyMzo1NCwgQW5kcmV3IEpvbmVzIDxham9uZXNAdmVudGFuYW1pY3JvLmNv
bT4gd3JvdGU6Cj4gT24gVGh1LCBGZWIgMjAsIDIwMjUgYXQgMDc6NDk6MDVBTSArMDAwMCwgQ2hh
byBEdSB3cm90ZToKPiA+IFRoZSBjb21tZW50cyBmb3IgRVhUX1NWQURFIGFyZSBvcHBvc2l0ZSB3
aXRoIHRoZSBjb2Rlcy4gRml4IGl0IHRvIGF2b2lkCj4gPiBjb25mdXNpb24uCj4gPiAKPiA+IFNp
Z25lZC1vZmYtYnk6IENoYW8gRHUgPGR1Y2hhb0Blc3dpbmNvbXB1dGluZy5jb20+Cj4gPiAtLS0K
PiA+ICBhcmNoL3Jpc2N2L2t2bS92Y3B1X29uZXJlZy5jIHwgMiArLQo+ID4gIDEgZmlsZSBjaGFu
Z2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQo+ID4gCj4gPiBkaWZmIC0tZ2l0IGEv
YXJjaC9yaXNjdi9rdm0vdmNwdV9vbmVyZWcuYyBiL2FyY2gvcmlzY3Yva3ZtL3ZjcHVfb25lcmVn
LmMKPiA+IGluZGV4IGY2ZDI3YjU5YzY0MS4uNmRmNDE3OTRlMzQ2IDEwMDY0NAo+ID4gLS0tIGEv
YXJjaC9yaXNjdi9rdm0vdmNwdV9vbmVyZWcuYwo+ID4gKysrIGIvYXJjaC9yaXNjdi9rdm0vdmNw
dV9vbmVyZWcuYwo+ID4gQEAgLTIwMyw3ICsyMDMsNyBAQCBzdGF0aWMgYm9vbCBrdm1fcmlzY3Zf
dmNwdV9pc2FfZGlzYWJsZV9hbGxvd2VkKHVuc2lnbmVkIGxvbmcgZXh0KQo+ID4gIAljYXNlIEtW
TV9SSVNDVl9JU0FfRVhUX1NWQURFOgo+ID4gIAkJLyoKPiA+ICAJCSAqIFRoZSBoZW52Y2ZnLkFE
VUUgaXMgcmVhZC1vbmx5IHplcm8gaWYgbWVudmNmZy5BRFVFIGlzIHplcm8uCj4gPiAtCQkgKiBT
dmFkZSBpcyBub3QgYWxsb3dlZCB0byBkaXNhYmxlIHdoZW4gdGhlIHBsYXRmb3JtIHVzZSBTdmFk
ZS4KPiA+ICsJCSAqIFN2YWRlIGlzIGFsbG93ZWQgdG8gZGlzYWJsZSB3aGVuIHRoZSBwbGF0Zm9y
bSB1c2UgU3ZhZGUuCj4gPiAgCQkgKi8KPiAKPiBJdCB3YXMgY29ycmVjdCAoYnV0IGNvbmZ1c2lu
ZykgYmVmb3JlIHRoaXMgY2hhbmdlLiBXaGVuCj4gYXJjaF9oYXNfaHdfcHRlX3lvdW5nKCkgcmV0
dXJucyB0cnVlLCB0aGF0IG1lYW5zIHdlIGNhbiB1c2UKPiBTVkFEVSAod2hpY2ggaXMgIVNWQURF
KS4gSWYgd2UgZG9uJ3QgaGF2ZSBTVkFEVSwgdGhlbiB3ZSBtdXN0Cj4gYmUgdXNpbmcgU1ZBREUs
IGFuZCB0aGVyZWZvcmUgY2FuJ3QgZGlzYWJsZSBpdC4KPiAKClRoYW5rcyBmb3IgdGhlIGNsYXJp
ZmljYXRpb24uIApJIGhhZCBzb21lIG1pc3VuZGVyc3RhbmRpbmdzIGFib3V0IHRoZSByZWxhdGlv
biBiZXR3ZWVuIFNWQURVCmFuZCBTVkFERS4KCj4gSG93IGFib3V0Cj4gCj4gLyoKPiAgKiBUaGUg
aGVudmNmZy5BRFVFIGlzIHJlYWQtb25seSB6ZXJvIGlmIG1lbnZjZmcuQURVRSBpcyB6ZXJvLgo+
ICAqIFN2YWRlIGNhbid0IGJlIGRpc2FibGVkIHVubGVzcyB3ZSBzdXBwb3J0IFN2YWR1Lgo+ICAq
LwoKWWVhaCwgdGhhdCdzIGJldHRlci4KClRoYW5rcywKQ2hhbwoKPiAKPiBUaGFua3MsCj4gZHJl
dwo+IAo+ID4gIAkJcmV0dXJuIGFyY2hfaGFzX2h3X3B0ZV95b3VuZygpOwo+ID4gIAlkZWZhdWx0
Ogo+ID4gLS0gCj4gPiAyLjM0LjEKPiA+IAo+ID4gCj4gPiAtLSAKPiA+IGt2bS1yaXNjdiBtYWls
aW5nIGxpc3QKPiA+IGt2bS1yaXNjdkBsaXN0cy5pbmZyYWRlYWQub3JnCj4gPiBodHRwOi8vbGlz
dHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2t2bS1yaXNjdgo=

