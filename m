Return-Path: <kvm+bounces-15470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72D078AC6FE
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 10:29:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 295221F215D9
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 08:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B0ED502AE;
	Mon, 22 Apr 2024 08:29:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A7D50246;
	Mon, 22 Apr 2024 08:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.150.39.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713774552; cv=none; b=OBvMe1u9mpJuhx40j+oK/8czlCsD0xFQG7AZZIG574nYEy6ky09VtNY4Bw3iO3wSGllkg7fEEKeErhf9diqziutk91KCawkA1AN/OyQGL0AZE0lttydRY26VEWQnZDchvjHdcVVcNdVZ+Q+9pEVV0SKcDXW3F/ba2S5CuclFTnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713774552; c=relaxed/simple;
	bh=zTjKFa9ufsEGRtTe1qCOiuLYhpnykAwM1b+hG7FfP9w=;
	h=Date:From:To:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=YNmtec46RlM7+lYdZcsZKjj8XxSZUYAvIfhsBFlax+c1/9ETdTB7T5aaPf6f404O6RUVTkHdWIaG5a9AlJLF4UF6p4cK3P7P+jooSGnMzolJz7a4geg087aLFZ7Tm60BuShyZoOH9s1+6pA8mfbBLC1L0wdAJz3Mtz9zaxQY1U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=129.150.39.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from liangshenlin$eswincomputing.com ( [10.12.96.90] ) by
 ajax-webmail-app2 (Coremail) ; Mon, 22 Apr 2024 16:27:10 +0800 (GMT+08:00)
Date: Mon, 22 Apr 2024 16:27:10 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Shenlin Liang" <liangshenlin@eswincomputing.com>
To: atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com, 
	acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, 
	irogers@google.com, adrian.hunter@intel.com, 
	linux-perf-users@vger.kernel.org, atishp@rivosinc.com
Subject: Re: [PATCH v2 0/2] perf kvm: Add kvm stat support on riscv
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.3 build 20220420(169d3f8c)
 Copyright (c) 2002-2024 www.mailtech.cn
 mispb-72143050-eaf5-4703-89e0-86624513b4ce-eswincomputing.com
In-Reply-To: <aceaaeba-61cb-44fa-8639-e30a86ef8cd8@rivosinc.com>
References: <20240415031131.23443-1-liangshenlin@eswincomputing.com>
 <aceaaeba-61cb-44fa-8639-e30a86ef8cd8@rivosinc.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <35896859.387e.18f04ea87b1.Coremail.liangshenlin@eswincomputing.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:TQJkCgAnOrxeHyZmbhAIAA--.5206W
X-CM-SenderInfo: xold0whvkh0z1lq6v25zlqu0xpsx3x1qjou0bp/1tbiAQEPDGYk3U
	gl0wACsg
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

SGkgQXRpc2gsCgpJIGFzc3VtZSB0aGF0IHlvdSBhcmUgY3Jvc3MgYnVpbGRpbmcgaXQgb24gWDg2
LiBZb3UgbmVlZCB0byBidWlsZCBhIHBrZy1jb25maWctcmlzY3Y2NCBmaXJzdC4gT3IgZ2V0IGEg
ZGViIGZpbGUgZnJvbSBbMV0gaWYgeW91IGFyZSBidWlkaW5nIG9uIFVidW50dS4KSW5zdGVhZCBv
ZiBjcm9zcyBidWlsZGluZywgaXQgaXMgcmVjb21tZW5kZWQgdG8gYnVpbGQgaXQgbmF0aXZlbHku
CgpCVFcsIHBsZWFzZSB0ZXN0IHdpdGggVjMgd2hpY2ggSSBzZW50IHRvZGF5LgoKWzFdIGh0dHBz
Oi8vYW5zd2Vycy5sYXVuY2hwYWQubmV0L35jaS10cmFpbi1wcGEtc2VydmljZS8rYXJjaGl2ZS91
YnVudHUvMzcxOS1kZWxldGVkcHBhLytidWlsZC8xNjgyMzg2Mi8rZmlsZXMvcGtnLWNvbmZpZy1y
aXNjdjY0LWxpbnV4LWdudV83LjQuMC0xdWJ1bnR1MS4zX2FtZDY0LmRlYgoKVGhhbmtzLgoKU2hl
bmxpbgoKPiAKPiBPbiA0LzE0LzI0IDIwOjExLCBTaGVubGluIExpYW5nIHdyb3RlOgo+ID4gQ2hh
bmdlcyBmcm9tIHYxLT52MjoKPiA+IC0gUmViYXNlZCBvbiBMaW51eCA2LjktcmMzLgo+ID4gCj4g
PiAncGVyZiBrdm0gc3RhdCByZXBvcnQvcmVjb3JkJyBnZW5lcmF0ZXMgYSBzdGF0aXN0aWNhbCBh
bmFseXNpcyBvZiBLVk0KPiA+IGV2ZW50cyBhbmQgY2FuIGJlIHVzZWQgdG8gYW5hbHl6ZSBndWVz
dCBleGl0IHJlYXNvbnMuIFRoaXMgcGF0Y2ggdHJpZXMKPiA+IHRvIGFkZCBzdGF0IHN1cHBvcnQg
b24gcmlzY3YuCj4gPiAKPiA+IE1hcCB0aGUgcmV0dXJuIHZhbHVlIG9mIHRyYWNlX2t2bV9leGl0
KCkgdG8gdGhlIHNwZWNpZmljIGNhdXNlIG9mIHRoZQo+ID4gZXhjZXB0aW9uLCBhbmQgZXhwb3J0
IGl0IHRvIHVzZXJzcGFjZS4KPiA+IAo+ID4gSXQgcmVjb3JkcyBvbiB0d28gYXZhaWxhYmxlIEtW
TSB0cmFjZXBvaW50cyBmb3IgcmlzY3Y6ICJrdm06a3ZtX2VudHJ5Igo+ID4gYW5kICJrdm06a3Zt
X2V4aXQiLCBhbmQgcmVwb3J0cyBzdGF0aXN0aWNhbCBkYXRhIHdoaWNoIGluY2x1ZGVzIGV2ZW50
cwo+ID4gaGFuZGxlcyB0aW1lLCBzYW1wbGVzLCBhbmQgc28gb24uCj4gPiAKPiA+IFNpbXBsZSB0
ZXN0cyBnbyBiZWxvdzoKPiA+IAo+ID4gIyAuL3BlcmYga3ZtIHJlY29yZCAtZSAia3ZtOmt2bV9l
bnRyeSIgLWUgImt2bTprdm1fZXhpdCIKPiA+IExvd2VyaW5nIGRlZmF1bHQgZnJlcXVlbmN5IHJh
dGUgZnJvbSA0MDAwIHRvIDI1MDAuCj4gPiBQbGVhc2UgY29uc2lkZXIgdHdlYWtpbmcgL3Byb2Mv
c3lzL2tlcm5lbC9wZXJmX2V2ZW50X21heF9zYW1wbGVfcmF0ZS4KPiA+IFsgcGVyZiByZWNvcmQ6
IFdva2VuIHVwIDE4IHRpbWVzIHRvIHdyaXRlIGRhdGEgXQo+ID4gWyBwZXJmIHJlY29yZDogQ2Fw
dHVyZWQgYW5kIHdyb3RlIDUuNDMzIE1CIHBlcmYuZGF0YS5ndWVzdCAoNjI1MTkgc2FtcGxlcykK
PiA+IAo+IAo+IEkgd2FudCB0byB0ZXN0IHRoZXNlIHBhdGNoZXMgYnV0IGNvdWxkbid0IGJ1aWxk
IGEgcGVyZiBmb3IgUklTQy1WIHdpdGggCj4gbGlidHJhY2VldmVudCBlbmFibGVkLiBJdCBmYWls
cyB3aXRoIHBrZy1jb25maWcgZGVwZW5kZW5jaWVzIHdoZW4gSSAKPiB0cmllZCB0byBidWlsZCBp
dCAoYm90aCB2aWEgYnVpbGRyb290IGFuZCBkaXJlY3RseSBmcm9tIGtlcm5lbCBzb3VyY2UpLgo+
IAo+ID4gIyAuL3BlcmYga3ZtIHJlcG9ydAo+ID4gMzFLIGt2bTprdm1fZW50cnkKPiA+IDMxSyBr
dm06a3ZtX2V4aXQKPiA+IAo+ID4gIyAuL3BlcmYga3ZtIHN0YXQgcmVjb3JkIC1hCj4gPiBbIHBl
cmYgcmVjb3JkOiBXb2tlbiB1cCAzIHRpbWVzIHRvIHdyaXRlIGRhdGEgXQo+ID4gWyBwZXJmIHJl
Y29yZDogQ2FwdHVyZWQgYW5kIHdyb3RlIDguNTAyIE1CIHBlcmYuZGF0YS5ndWVzdCAoOTkzMzgg
c2FtcGxlcykgXQo+ID4gCj4gPiAjIC4vcGVyZiBrdm0gc3RhdCByZXBvcnQgLS1ldmVudD12bWV4
aXQKPiA+IEV2ZW50IG5hbWUgICAgICAgICAgICAgICAgU2FtcGxlcyAgIFNhbXBsZSUgICAgVGlt
ZSAobnMpICAgICBUaW1lJSAgIE1heCBUaW1lIChucykgICBNaW4gVGltZSAobnMpICBNZWFuIFRp
bWUgKG5zKQo+ID4gU1RPUkVfR1VFU1RfUEFHRV9GQVVMVCAgICAgMjY5NjggICAgIDU0LjAwJSAg
ICAyMDAzMDMxODAwICAgIDQwLjAwJSAgICAgMzM2MTQwMCAgICAgICAgIDI3NjAwICAgICAgICAg
IDc0Mjc0Cj4gPiBMT0FEX0dVRVNUX1BBR0VfRkFVTFQgICAgICAxNzY0NSAgICAgMzUuMDAlICAg
IDExNTMzMzgxMDAgICAgMjMuMDAlICAgICAyNTEzNDAwICAgICAgICAgMzA4MDAgICAgICAgICAg
NjUzNjMKPiA+IFZJUlRVQUxfSU5TVF9GQVVMVCAgICAgICAgIDEyNDcgICAgICAyLjAwJSAgICAg
MzQwODIwODAwICAgICA2LjAwJSAgICAgIDExOTA4MDAgICAgICAgICA0MzMwMCAgICAgICAgICAy
NzMzMTIKPiA+IElOU1RfR1VFU1RfUEFHRV9GQVVMVCAgICAgIDExMjggICAgICAyLjAwJSAgICAg
MzQwNjQ1ODAwICAgICA2LjAwJSAgICAgIDIxMjMyMDAgICAgICAgICAzMDIwMCAgICAgICAgICAz
MDE5OTAKPiA+IFNVUEVSVklTT1JfU1lTQ0FMTCAgICAgICAgIDEwMTkgICAgICAyLjAwJSAgICAg
MjQ1OTg5OTAwICAgICA0LjAwJSAgICAgIDE4NTE1MDAgICAgICAgICAyOTMwMCAgICAgICAgICAy
NDE0MDMKPiA+IExPQURfQUNDRVNTICAgICAgICAgICAgICAgIDk4NiAgICAgICAxLjAwJSAgICAg
NjcxNTU2MjAwICAgICAxMy4wMCUgICAgIDQxODAyMDAgICAgICAgICAxMDA3MDAgICAgICAgICA2
ODEwOTEKPiA+IElOU1RfQUNDRVNTICAgICAgICAgICAgICAgIDY1NSAgICAgICAxLjAwJSAgICAg
MTcwMDU0ODAwICAgICAzLjAwJSAgICAgIDE4MDgzMDAgICAgICAgICA1NDYwMCAgICAgICAgICAy
NTk2MjUKPiA+IEhZUEVSVklTT1JfU1lTQ0FMTCAgICAgICAgIDIxICAgICAgICAwLjAwJSAgICAg
NDI3NjQwMCAgICAgICAwLjAwJSAgICAgIDcxNjUwMCAgICAgICAgICAxMTYwMDAgICAgICAgICAy
MDM2MzgKPiA+IAo+ID4gU2hlbmxpbiBMaWFuZyAoMik6Cj4gPiAgICBSSVNDVjogS1ZNOiBhZGQg
dHJhY2Vwb2ludHMgZm9yIGVudHJ5IGFuZCBleGl0IGV2ZW50cwo+ID4gICAgcGVyZiBrdm0vcmlz
Y3Y6IFBvcnQgcGVyZiBrdm0gc3RhdCB0byBSSVNDLVYKPiA+IAo+ID4gICBhcmNoL3Jpc2N2L2t2
bS90cmFjZS5oICAgICAgICAgICAgICAgICAgICAgICAgfCA2NyArKysrKysrKysrKysrKysrCj4g
PiAgIGFyY2gvcmlzY3Yva3ZtL3ZjcHUuYyAgICAgICAgICAgICAgICAgICAgICAgICB8ICA3ICsr
Cj4gPiAgIHRvb2xzL3BlcmYvYXJjaC9yaXNjdi9NYWtlZmlsZSAgICAgICAgICAgICAgICB8ICAx
ICsKPiA+ICAgdG9vbHMvcGVyZi9hcmNoL3Jpc2N2L3V0aWwvQnVpbGQgICAgICAgICAgICAgIHwg
IDEgKwo+ID4gICB0b29scy9wZXJmL2FyY2gvcmlzY3YvdXRpbC9rdm0tc3RhdC5jICAgICAgICAg
fCA3OCArKysrKysrKysrKysrKysrKysrCj4gPiAgIC4uLi9hcmNoL3Jpc2N2L3V0aWwvcmlzY3Zf
ZXhjZXB0aW9uX3R5cGVzLmggICB8IDQxICsrKysrKysrKysKPiA+ICAgNiBmaWxlcyBjaGFuZ2Vk
LCAxOTUgaW5zZXJ0aW9ucygrKQo+ID4gICBjcmVhdGUgbW9kZSAxMDA2NDQgYXJjaC9yaXNjdi9r
dm0vdHJhY2UuaAo+ID4gICBjcmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMvcGVyZi9hcmNoL3Jpc2N2
L3V0aWwva3ZtLXN0YXQuYwo+ID4gICBjcmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMvcGVyZi9hcmNo
L3Jpc2N2L3V0aWwvcmlzY3ZfZXhjZXB0aW9uX3R5cGVzLmgKPiA+IAo=

