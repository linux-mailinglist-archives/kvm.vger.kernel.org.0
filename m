Return-Path: <kvm+bounces-14218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12F198A09BB
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 09:26:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF6A7282A7E
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 07:26:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E09B13E882;
	Thu, 11 Apr 2024 07:26:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC7613DDAA;
	Thu, 11 Apr 2024 07:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.181.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712820382; cv=none; b=VSOkOtL+eqx0YErh9jJEtdP+gFE9vff4erj/crPu5jmKaYJa28XeJbShTSHFTwJpYAOAjOd4meEsHO4ERGPpAcB/Ef47sXZRkjdqQVcLMijcYHf0nkJUl3Q+/9ujv+qDLim+1+9UqN48Fga6IEOtx9dyt/Do9/VYSHvpV4zhXPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712820382; c=relaxed/simple;
	bh=PHXTsy2vNvIJCDbU4Ix9HLcR0CmUeuPk0oGEowtL/vU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=ttF+bC2/lYOJa7l4fsFFhcT0lVcWGHx8hUWm7+MYGfRyC3787xmSkbnSdBDC+AQz7CLgxsqrkmXpZo+NAlMhrfTcwB8IaxKLDXltxF+CEm7JHaoXOUrzHywDJvZAUIZ2c5N2C8F6hJIuxSOluSQDf5UwUhlExE66PlNU5yFPyv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=209.97.181.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from liangshenlin$eswincomputing.com ( [10.12.96.90] ) by
 ajax-webmail-app2 (Coremail) ; Thu, 11 Apr 2024 15:24:09 +0800 (GMT+08:00)
Date: Thu, 11 Apr 2024 15:24:09 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Shenlin Liang" <liangshenlin@eswincomputing.com>
To: "Eric Cheng" <eric.cheng.linux@gmail.com>
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com, 
	acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, 
	irogers@google.com, adrian.hunter@intel.com, 
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 1/2] RISCV: KVM: add tracepoints for entry and exit
 events
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT6.0.3 build 20220420(169d3f8c)
 Copyright (c) 2002-2024 www.mailtech.cn
 mispb-72143050-eaf5-4703-89e0-86624513b4ce-eswincomputing.com
In-Reply-To: <40a8d9d3-20a8-44e8-96d2-0dcd8627cfc8@gmail.com>
References: <20240328031220.1287-1-liangshenlin@eswincomputing.com>
 <20240328031220.1287-2-liangshenlin@eswincomputing.com>
 <40a8d9d3-20a8-44e8-96d2-0dcd8627cfc8@gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <607ba9f5.2876.18ecc0ae30d.Coremail.liangshenlin@eswincomputing.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:TQJkCgAHGrwZkBdmlBMGAA--.3617W
X-CM-SenderInfo: xold0whvkh0z1lq6v25zlqu0xpsx3x1qjou0bp/1tbiAQEEDGYWXM
	cg8QAAsy
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
	CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
	daVFxhVjvjDU=

T24gMjAyNC0wNC0xMCAxNToxMiwgRXJpYyBDaGVuZyA8ZXJpYy5jaGVuZy5saW51eEBnbWFpbC5j
b20+IHdyb3RlOgoKPiAKPiBPbiAzLzI4LzIwMjQgMTE6MTIgQU0sIFNoZW5saW4gTGlhbmcgd3Jv
dGU6Cj4gPiBMaWtlIG90aGVyIGFyY2hpdGVjdHVyZXMsIFJJU0NWIEtWTSBhbHNvIG5lZWRzIHRv
IGFkZCB0aGVzZSBldmVudAo+ID4gdHJhY2Vwb2ludHMgdG8gY291bnQgdGhlIG51bWJlciBvZiB0
aW1lcyBrdm0gZ3Vlc3QgZW50cnkvZXhpdC4KPiA+IAo+ID4gU2lnbmVkLW9mZi1ieTogU2hlbmxp
biBMaWFuZyA8bGlhbmdzaGVubGluQGVzd2luY29tcHV0aW5nLmNvbT4KPiA+IC0tLQo+ID4gICBh
cmNoL3Jpc2N2L2t2bS90cmFjZV9yaXNjdi5oIHwgNjAgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrCj4gCj4gQ29udmVudGlvbmFsbHksIGl0IHNob3VsZCBiZSBuYW1lZCB0byB0
cmFjZS5oLCBlc3BlY2lhbGx5IGlmIG9ubHkgb25lLiBSZWZlciB0byAKPiBvdGhlciBhcmNoJ3Mu
CgpUaGFuayB5b3UgZm9yIHRoZSByZXZpZXcuIEkgd2lsbCBzZW5kIHRoZSB2MiB2ZXJzaW9uLg==


