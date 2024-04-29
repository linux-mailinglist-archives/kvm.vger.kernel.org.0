Return-Path: <kvm+bounces-16139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C5F58B511E
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 08:15:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFD681F23D2A
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 06:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C284210A31;
	Mon, 29 Apr 2024 06:15:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmja2lje4os43os4xodqa.icoremail.net (zg8tmja2lje4os43os4xodqa.icoremail.net [206.189.79.184])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A174DD534;
	Mon, 29 Apr 2024 06:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.79.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714371347; cv=none; b=cfIm5r3PGHAjTYAC1a/Ikt9+2PM6CclWr/cziy83FeUaSg5gHE7gaOBIgV4lf4A2tQBoAjvzjgRfMiFfe81KyZ7tvQyE9uJC8GYZLxlaTqatt0uCTVgQ1T3d+qtNsdP6SBmhZ2fltCAyRRdwsb+WYHmy706Y7ST21ghYP/Y87z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714371347; c=relaxed/simple;
	bh=ezHdYf0ToGwvT1Tn/f6ETFKnkP43vGQzEEh2GxSKbbM=;
	h=Date:From:To:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=c4xR0tKnoY8SlsxDn/H8BqBANSrTcQjrXP6XkgTkDHw6NwBfFDrUJDbkkvekcgDQi0JVV/JNHrmPe7SPkovusUBVoaRDiFG9FMk4x1EscTi2SimO4lRSqS9kuJLU4BWLyt1ExcCGX+rlC4qcioWQkBZqtrAKM8KfWF9S3LoCA98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=206.189.79.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from liangshenlin$eswincomputing.com ( [10.12.96.90] ) by
 ajax-webmail-app2 (Coremail) ; Mon, 29 Apr 2024 14:13:22 +0800 (GMT+08:00)
Date: Mon, 29 Apr 2024 14:13:22 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Shenlin Liang" <liangshenlin@eswincomputing.com>
To: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com, 
	acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, 
	irogers@google.com, adrian.hunter@intel.com, 
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v3 0/2] perf kvm: Add kvm stat support on riscv
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.3 build 20220420(169d3f8c)
 Copyright (c) 2002-2024 www.mailtech.cn
 mispb-72143050-eaf5-4703-89e0-86624513b4ce-eswincomputing.com
In-Reply-To: <20240422080833.8745-1-liangshenlin@eswincomputing.com>
References: <20240422080833.8745-1-liangshenlin@eswincomputing.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <5e830d33.45c7.18f287c8f73.Coremail.liangshenlin@eswincomputing.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:TQJkCgAnOryCOi9mlSgJAA--.6236W
X-CM-SenderInfo: xold0whvkh0z1lq6v25zlqu0xpsx3x1qjou0bp/1tbiAgEBDGYsyB
	ATxgABsI
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

CkdlbnRsZSBwaW5nLi4uCgo+IAo+ICdwZXJmIGt2bSBzdGF0IHJlcG9ydC9yZWNvcmQnIGdlbmVy
YXRlcyBhIHN0YXRpc3RpY2FsIGFuYWx5c2lzIG9mIEtWTQo+IGV2ZW50cyBhbmQgY2FuIGJlIHVz
ZWQgdG8gYW5hbHl6ZSBndWVzdCBleGl0IHJlYXNvbnMuIFRoaXMgcGF0Y2ggdHJpZXMKPiB0byBh
ZGQgc3RhdCBzdXBwb3J0IG9uIHJpc2N2Lgo+IAo+IE1hcCB0aGUgcmV0dXJuIHZhbHVlIG9mIHRy
YWNlX2t2bV9leGl0KCkgdG8gdGhlIHNwZWNpZmljIGNhdXNlIG9mIHRoZSAKPiBleGNlcHRpb24s
IGFuZCBleHBvcnQgaXQgdG8gdXNlcnNwYWNlLgo+IAo+IEl0IHJlY29yZHMgb24gdHdvIGF2YWls
YWJsZSBLVk0gdHJhY2Vwb2ludHMgZm9yIHJpc2N2OiAia3ZtOmt2bV9lbnRyeSIKPiBhbmQgImt2
bTprdm1fZXhpdCIsIGFuZCByZXBvcnRzIHN0YXRpc3RpY2FsIGRhdGEgd2hpY2ggaW5jbHVkZXMg
ZXZlbnRzCj4gaGFuZGxlcyB0aW1lLCBzYW1wbGVzLCBhbmQgc28gb24uCj4gCj4gQ3Jvc3MgY29t
cGlsaW5nIHBlcmYgaW4gWDg2IGVudmlyb25tZW50IG1heSBlbmNvdW50ZXIgaXNzdWVzIHdpdGgg
bWlzc2luZwo+IGxpYnJhcmllcyBhbmQgdG9vbHMuIFN1Z2dlc3QgY29tcGlsaW5nIG5hdGl2bHkg
aW4gUklTQy1WIGVudmlyb25tZW50Cj4gCj4gU2ltcGxlIHRlc3RzIGdvIGJlbG93Ogo+IAo+ICMg
Li9wZXJmIGt2bSByZWNvcmQgLWUgImt2bTprdm1fZW50cnkiIC1lICJrdm06a3ZtX2V4aXQiCj4g
TG93ZXJpbmcgZGVmYXVsdCBmcmVxdWVuY3kgcmF0ZSBmcm9tIDQwMDAgdG8gMjUwMC4KPiBQbGVh
c2UgY29uc2lkZXIgdHdlYWtpbmcgL3Byb2Mvc3lzL2tlcm5lbC9wZXJmX2V2ZW50X21heF9zYW1w
bGVfcmF0ZS4KPiBbIHBlcmYgcmVjb3JkOiBXb2tlbiB1cCAxOCB0aW1lcyB0byB3cml0ZSBkYXRh
IF0KPiBbIHBlcmYgcmVjb3JkOiBDYXB0dXJlZCBhbmQgd3JvdGUgNS40MzMgTUIgcGVyZi5kYXRh
Lmd1ZXN0ICg2MjUxOSBzYW1wbGVzKSAKPiAKPiAjIC4vcGVyZiBrdm0gcmVwb3J0Cj4gMzFLIGt2
bTprdm1fZW50cnkKPiAzMUsga3ZtOmt2bV9leGl0Cj4gCj4gIyAuL3BlcmYga3ZtIHN0YXQgcmVj
b3JkIC1hCj4gWyBwZXJmIHJlY29yZDogV29rZW4gdXAgMyB0aW1lcyB0byB3cml0ZSBkYXRhIF0K
PiBbIHBlcmYgcmVjb3JkOiBDYXB0dXJlZCBhbmQgd3JvdGUgOC41MDIgTUIgcGVyZi5kYXRhLmd1
ZXN0ICg5OTMzOCBzYW1wbGVzKSBdCj4gCj4gIyAuL3BlcmYga3ZtIHN0YXQgcmVwb3J0IC0tZXZl
bnQ9dm1leGl0Cj4gRXZlbnQgbmFtZSAgICAgICAgICAgICAgICBTYW1wbGVzICAgU2FtcGxlJSAg
ICBUaW1lIChucykgICAgIFRpbWUlICAgTWF4IFRpbWUgKG5zKSAgIE1pbiBUaW1lIChucykgIE1l
YW4gVGltZSAobnMpCj4gU1RPUkVfR1VFU1RfUEFHRV9GQVVMVCAgICAgMjY5NjggICAgIDU0LjAw
JSAgICAyMDAzMDMxODAwICAgIDQwLjAwJSAgICAgMzM2MTQwMCAgICAgICAgIDI3NjAwICAgICAg
ICAgIDc0Mjc0Cj4gTE9BRF9HVUVTVF9QQUdFX0ZBVUxUICAgICAgMTc2NDUgICAgIDM1LjAwJSAg
ICAxMTUzMzM4MTAwICAgIDIzLjAwJSAgICAgMjUxMzQwMCAgICAgICAgIDMwODAwICAgICAgICAg
IDY1MzYzCj4gVklSVFVBTF9JTlNUX0ZBVUxUICAgICAgICAgMTI0NyAgICAgIDIuMDAlICAgICAz
NDA4MjA4MDAgICAgIDYuMDAlICAgICAgMTE5MDgwMCAgICAgICAgIDQzMzAwICAgICAgICAgIDI3
MzMxMgo+IElOU1RfR1VFU1RfUEFHRV9GQVVMVCAgICAgIDExMjggICAgICAyLjAwJSAgICAgMzQw
NjQ1ODAwICAgICA2LjAwJSAgICAgIDIxMjMyMDAgICAgICAgICAzMDIwMCAgICAgICAgICAzMDE5
OTAKPiBTVVBFUlZJU09SX1NZU0NBTEwgICAgICAgICAxMDE5ICAgICAgMi4wMCUgICAgIDI0NTk4
OTkwMCAgICAgNC4wMCUgICAgICAxODUxNTAwICAgICAgICAgMjkzMDAgICAgICAgICAgMjQxNDAz
Cj4gTE9BRF9BQ0NFU1MgICAgICAgICAgICAgICAgOTg2ICAgICAgIDEuMDAlICAgICA2NzE1NTYy
MDAgICAgIDEzLjAwJSAgICAgNDE4MDIwMCAgICAgICAgIDEwMDcwMCAgICAgICAgIDY4MTA5MQo+
IElOU1RfQUNDRVNTICAgICAgICAgICAgICAgIDY1NSAgICAgICAxLjAwJSAgICAgMTcwMDU0ODAw
ICAgICAzLjAwJSAgICAgIDE4MDgzMDAgICAgICAgICA1NDYwMCAgICAgICAgICAyNTk2MjUKPiBI
WVBFUlZJU09SX1NZU0NBTEwgICAgICAgICAyMSAgICAgICAgMC4wMCUgICAgIDQyNzY0MDAgICAg
ICAgMC4wMCUgICAgICA3MTY1MDAgICAgICAgICAgMTE2MDAwICAgICAgICAgMjAzNjM4IAo+IAo+
IENoYW5nZXMgZnJvbSB2MS0+djI6Cj4gLSBSZWJhc2VkIG9uIExpbnV4IDYuOS1yYzMuCj4gCj4g
Q2hhbmdlcyBmcm9tIHYyLT52MzoKPiAtIEFkZCB0aGUgbWlzc2luZyBhc3NpZ25tZW50IGZvciAn
dmNwdV9pZF9zdHInIGluIHBhdGNoIDIuCj4gLSBSZW1vdmUgcGFyZW50aGVzZXMgdGhhdCBjYXVz
ZSBjb21waWxhdGlvbiBlcnJvcnMKPiAKPiBTaGVubGluIExpYW5nICgyKToKPiAgIFJJU0NWOiBL
Vk06IGFkZCB0cmFjZXBvaW50cyBmb3IgZW50cnkgYW5kIGV4aXQgZXZlbnRzCj4gICBwZXJmIGt2
bS9yaXNjdjogUG9ydCBwZXJmIGt2bSBzdGF0IHRvIFJJU0MtVgo+IAo+ICBhcmNoL3Jpc2N2L2t2
bS90cmFjZS5oICAgICAgICAgICAgICAgICAgICAgICAgfCA2NyArKysrKysrKysrKysrKysrCj4g
IGFyY2gvcmlzY3Yva3ZtL3ZjcHUuYyAgICAgICAgICAgICAgICAgICAgICAgICB8ICA3ICsrCj4g
IHRvb2xzL3BlcmYvYXJjaC9yaXNjdi9NYWtlZmlsZSAgICAgICAgICAgICAgICB8ICAxICsKPiAg
dG9vbHMvcGVyZi9hcmNoL3Jpc2N2L3V0aWwvQnVpbGQgICAgICAgICAgICAgIHwgIDEgKwo+ICB0
b29scy9wZXJmL2FyY2gvcmlzY3YvdXRpbC9rdm0tc3RhdC5jICAgICAgICAgfCA3OSArKysrKysr
KysrKysrKysrKysrCj4gIC4uLi9hcmNoL3Jpc2N2L3V0aWwvcmlzY3ZfZXhjZXB0aW9uX3R5cGVz
LmggICB8IDM1ICsrKysrKysrCj4gIDYgZmlsZXMgY2hhbmdlZCwgMTkwIGluc2VydGlvbnMoKykK
PiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGFyY2gvcmlzY3Yva3ZtL3RyYWNlLmgKPiAgY3JlYXRlIG1v
ZGUgMTAwNjQ0IHRvb2xzL3BlcmYvYXJjaC9yaXNjdi91dGlsL2t2bS1zdGF0LmMKPiAgY3JlYXRl
IG1vZGUgMTAwNjQ0IHRvb2xzL3BlcmYvYXJjaC9yaXNjdi91dGlsL3Jpc2N2X2V4Y2VwdGlvbl90
eXBlcy5oCj4gCj4gLS0gCj4gMi4zNy4yCg==

