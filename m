Return-Path: <kvm+bounces-13817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D4E089AE13
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 04:33:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 142AC1F21EE4
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 02:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 056F03D62;
	Sun,  7 Apr 2024 02:33:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmja2lje4os4yms4ymjma.icoremail.net (zg8tmja2lje4os4yms4ymjma.icoremail.net [206.189.21.223])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 324AE368;
	Sun,  7 Apr 2024 02:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.21.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712457225; cv=none; b=eSVQWw+cs5IDo7yYHQW9GsFfQJ7LzXF17CvQgV/LfrZS3bP/H8QhUdPpnchl8RiHJEuJUQkAjiwaQcZtrayc6kBevfQvAL+ZBJOuEfrOsHoZ2VHPjzixFbPL5fNOLoVTCJswyTZauTSCnalfrLFdP6c/K5hC7zivFxtIwh2GrIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712457225; c=relaxed/simple;
	bh=vvc00YemBHkBGmzAmPgwXj7gzhMI2fSH6tZO1sA3vQ4=;
	h=Date:From:To:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=Z/LmBltDCQTOElBsuCk8P0Gv3Ds4XLZKkuL7aO29iBxWji4Uo1Is/yUX5sMMRQEq8+hM8VsXv+5jV6TmSscplWFrxnvp+tN3PhiR75SpzY397wDUY3IUqqAmFd2NxZ2s9T5nF0otQ7zuf9zCN58atZn1ADBfr00ajaL+fv+kKSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=206.189.21.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from liangshenlin$eswincomputing.com ( [10.12.96.90] ) by
 ajax-webmail-app2 (Coremail) ; Sun, 7 Apr 2024 10:31:34 +0800 (GMT+08:00)
Date: Sun, 7 Apr 2024 10:31:34 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Shenlin Liang" <liangshenlin@eswincomputing.com>
To: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com, 
	acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, 
	irogers@google.com, adrian.hunter@intel.com, 
	linux-perf-users@vger.kernel.org, 
	"Shenlin Liang" <liangshenlin@eswincomputing.com>
Subject: Re: [PATCH 0/2] perf kvm: Add kvm stat support on riscv
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.3 build 20220420(169d3f8c)
 Copyright (c) 2002-2024 www.mailtech.cn
 mispb-72143050-eaf5-4703-89e0-86624513b4ce-eswincomputing.com
In-Reply-To: <20240328031220.1287-1-liangshenlin@eswincomputing.com>
References: <20240328031220.1287-1-liangshenlin@eswincomputing.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <71d045ed.2258.18eb6659685.Coremail.liangshenlin@eswincomputing.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:TQJkCgBHWbuGBRJmHT0FAA--.2754W
X-CM-SenderInfo: xold0whvkh0z1lq6v25zlqu0xpsx3x1qjou0bp/1tbiAgEADGYRGI
	0ZWwAAsv
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

R2VudGxlIHBpbmcuLi4KCj4gCj4gJ3BlcmYga3ZtIHN0YXQgcmVwb3J0L3JlY29yZCcgZ2VuZXJh
dGVzIGEgc3RhdGlzdGljYWwgYW5hbHlzaXMgb2YgS1ZNCj4gZXZlbnRzIGFuZCBjYW4gYmUgdXNl
ZCB0byBhbmFseXplIGd1ZXN0IGV4aXQgcmVhc29ucy4gVGhpcyBwYXRjaCB0cmllcwo+IHRvIGFk
ZCBzdGF0IHN1cHBvcnQgb24gcmlzY3YuCj4gCj4gTWFwIHRoZSByZXR1cm4gdmFsdWUgb2YgdHJh
Y2Vfa3ZtX2V4aXQoKSB0byB0aGUgc3BlY2lmaWMgY2F1c2Ugb2YgdGhlIAo+IGV4Y2VwdGlvbiwg
YW5kIGV4cG9ydCBpdCB0byB1c2Vyc3BhY2UuCj4gCj4gSXQgcmVjb3JkcyBvbiB0d28gYXZhaWxh
YmxlIEtWTSB0cmFjZXBvaW50cyBmb3IgcmlzY3Y6ICJrdm06a3ZtX2VudHJ5Igo+IGFuZCAia3Zt
Omt2bV9leGl0IiwgYW5kIHJlcG9ydHMgc3RhdGlzdGljYWwgZGF0YSB3aGljaCBpbmNsdWRlcyBl
dmVudHMKPiBoYW5kbGVzIHRpbWUsIHNhbXBsZXMsIGFuZCBzbyBvbi4KPiAKPiBTaW1wbGUgdGVz
dHMgZ28gYmVsb3c6Cj4gCj4gIyAuL3BlcmYga3ZtIHJlY29yZCAtZSAia3ZtOmt2bV9lbnRyeSIg
LWUgImt2bTprdm1fZXhpdCIKPiBMb3dlcmluZyBkZWZhdWx0IGZyZXF1ZW5jeSByYXRlIGZyb20g
NDAwMCB0byAyNTAwLgo+IFBsZWFzZSBjb25zaWRlciB0d2Vha2luZyAvcHJvYy9zeXMva2VybmVs
L3BlcmZfZXZlbnRfbWF4X3NhbXBsZV9yYXRlLgo+IFsgcGVyZiByZWNvcmQ6IFdva2VuIHVwIDE4
IHRpbWVzIHRvIHdyaXRlIGRhdGEgXQo+IFsgcGVyZiByZWNvcmQ6IENhcHR1cmVkIGFuZCB3cm90
ZSA1LjQzMyBNQiBwZXJmLmRhdGEuZ3Vlc3QgKDYyNTE5IHNhbXBsZXMpIAo+IAo+ICMgLi9wZXJm
IGt2bSByZXBvcnQKPiAzMUsga3ZtOmt2bV9lbnRyeQo+IDMxSyBrdm06a3ZtX2V4aXQKPiAKPiAj
IC4vcGVyZiBrdm0gc3RhdCByZWNvcmQgLWEKPiBbIHBlcmYgcmVjb3JkOiBXb2tlbiB1cCAzIHRp
bWVzIHRvIHdyaXRlIGRhdGEgXQo+IFsgcGVyZiByZWNvcmQ6IENhcHR1cmVkIGFuZCB3cm90ZSA4
LjUwMiBNQiBwZXJmLmRhdGEuZ3Vlc3QgKDk5MzM4IHNhbXBsZXMpIF0KPiAKPiAjIC4vcGVyZiBr
dm0gc3RhdCByZXBvcnQgLS1ldmVudD12bWV4aXQKPiBFdmVudCBuYW1lICAgICAgICAgICAgICAg
IFNhbXBsZXMgICBTYW1wbGUlICAgIFRpbWUgKG5zKSAgICAgVGltZSUgICBNYXggVGltZSAobnMp
ICAgTWluIFRpbWUgKG5zKSAgTWVhbiBUaW1lIChucykKPiBTVE9SRV9HVUVTVF9QQUdFX0ZBVUxU
ICAgICAyNjk2OCAgICAgNTQuMDAlICAgIDIwMDMwMzE4MDAgICAgNDAuMDAlICAgICAzMzYxNDAw
ICAgICAgICAgMjc2MDAgICAgICAgICAgNzQyNzQKPiBMT0FEX0dVRVNUX1BBR0VfRkFVTFQgICAg
ICAxNzY0NSAgICAgMzUuMDAlICAgIDExNTMzMzgxMDAgICAgMjMuMDAlICAgICAyNTEzNDAwICAg
ICAgICAgMzA4MDAgICAgICAgICAgNjUzNjMKPiBWSVJUVUFMX0lOU1RfRkFVTFQgICAgICAgICAx
MjQ3ICAgICAgMi4wMCUgICAgIDM0MDgyMDgwMCAgICAgNi4wMCUgICAgICAxMTkwODAwICAgICAg
ICAgNDMzMDAgICAgICAgICAgMjczMzEyCj4gSU5TVF9HVUVTVF9QQUdFX0ZBVUxUICAgICAgMTEy
OCAgICAgIDIuMDAlICAgICAzNDA2NDU4MDAgICAgIDYuMDAlICAgICAgMjEyMzIwMCAgICAgICAg
IDMwMjAwICAgICAgICAgIDMwMTk5MAo+IFNVUEVSVklTT1JfU1lTQ0FMTCAgICAgICAgIDEwMTkg
ICAgICAyLjAwJSAgICAgMjQ1OTg5OTAwICAgICA0LjAwJSAgICAgIDE4NTE1MDAgICAgICAgICAy
OTMwMCAgICAgICAgICAyNDE0MDMKPiBMT0FEX0FDQ0VTUyAgICAgICAgICAgICAgICA5ODYgICAg
ICAgMS4wMCUgICAgIDY3MTU1NjIwMCAgICAgMTMuMDAlICAgICA0MTgwMjAwICAgICAgICAgMTAw
NzAwICAgICAgICAgNjgxMDkxCj4gSU5TVF9BQ0NFU1MgICAgICAgICAgICAgICAgNjU1ICAgICAg
IDEuMDAlICAgICAxNzAwNTQ4MDAgICAgIDMuMDAlICAgICAgMTgwODMwMCAgICAgICAgIDU0NjAw
ICAgICAgICAgIDI1OTYyNQo+IEhZUEVSVklTT1JfU1lTQ0FMTCAgICAgICAgIDIxICAgICAgICAw
LjAwJSAgICAgNDI3NjQwMCAgICAgICAwLjAwJSAgICAgIDcxNjUwMCAgICAgICAgICAxMTYwMDAg
ICAgICAgICAyMDM2MzggCj4gCj4gU2hlbmxpbiBMaWFuZyAoMik6Cj4gICBSSVNDVjogS1ZNOiBh
ZGQgdHJhY2Vwb2ludHMgZm9yIGVudHJ5IGFuZCBleGl0IGV2ZW50cwo+ICAgcGVyZiBrdm0vcmlz
Y3Y6IFBvcnQgcGVyZiBrdm0gc3RhdCB0byBSSVNDLVYKPiAKPiAgYXJjaC9yaXNjdi9rdm0vdHJh
Y2VfcmlzY3YuaCAgICAgICAgICAgICAgICAgIHwgNjAgKysrKysrKysrKysrKysKPiAgYXJjaC9y
aXNjdi9rdm0vdmNwdS5jICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDcgKysKPiAgdG9vbHMv
cGVyZi9hcmNoL3Jpc2N2L01ha2VmaWxlICAgICAgICAgICAgICAgIHwgIDEgKwo+ICB0b29scy9w
ZXJmL2FyY2gvcmlzY3YvdXRpbC9CdWlsZCAgICAgICAgICAgICAgfCAgMSArCj4gIHRvb2xzL3Bl
cmYvYXJjaC9yaXNjdi91dGlsL2t2bS1zdGF0LmMgICAgICAgICB8IDc4ICsrKysrKysrKysrKysr
KysrKysKPiAgLi4uL2FyY2gvcmlzY3YvdXRpbC9yaXNjdl9leGNlcHRpb25fdHlwZXMuaCAgIHwg
NDEgKysrKysrKysrKwo+ICA2IGZpbGVzIGNoYW5nZWQsIDE4OCBpbnNlcnRpb25zKCspCj4gIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL3Jpc2N2L2t2bS90cmFjZV9yaXNjdi5oCj4gIGNyZWF0ZSBt
b2RlIDEwMDY0NCB0b29scy9wZXJmL2FyY2gvcmlzY3YvdXRpbC9rdm0tc3RhdC5jCj4gIGNyZWF0
ZSBtb2RlIDEwMDY0NCB0b29scy9wZXJmL2FyY2gvcmlzY3YvdXRpbC9yaXNjdl9leGNlcHRpb25f
dHlwZXMuaAo+IAo+IC0tIAo+IDIuMzcuMgo=

