Return-Path: <kvm+bounces-48516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBF1FACEDBF
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 12:34:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4ACFB3AC5D7
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 10:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F494218E96;
	Thu,  5 Jun 2025 10:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LOo8s37P"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F3E21858E
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 10:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749119674; cv=none; b=KVVN0YyxcdOHc3xdpNmXM90K725z5etKOh3qjkUetpDO2V3HBJ8BuJ9Zxw1S2Hop8C3G6lhVldBqiho9bpnS55cjwtiz7UR9s+DTfsaBj9l6tbmKqmKUY339h/QVhxNRh9KisWAyT0SCZrnK4YARpPuhbeuH+Ed36lGDCWxvOIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749119674; c=relaxed/simple;
	bh=x94JNse3vGAwAiiyc2ocIi5QOnWATaFnVJ9A8mJm2vg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mNdThxwnZcczdaqAziJk0QahAr0tFzFVlnuWEqlQm8xXNDjZ+Qj4pQzZT+yyYzjgI5KrqioyddsyIrLAUh6X5kKASoM6p5knYQDPVnwSQozBeS1d6bdVWVbHBXcibL+yKertcTNtGaKgWi6VtCqmoJKEbxZa9SdviMarHagKn2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LOo8s37P; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 5 Jun 2025 12:34:28 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749119670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5LvxkDopGogQM6V5tHY5SCNcHoKvu6McPGJuxgeMFrU=;
	b=LOo8s37PkCutFOdQT6wYtTTpquluxzfvRpYTVBANNif/CakKn4hFgJoqhx0zHAsnl2VFq3
	t/Ex4jGfGxRQ0Dj74YCTy9L2KDsgnZeXAjvHGpaN+ZJAOSIdKzFyIpPoJhwyzII5/4kqQA
	Tz1MNbVNLT4FNG/wiAVIOhvwUXNT/74=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Ved Shanbhogue <ved@rivosinc.com>
Subject: Re: [kvm-unit-tests v2 2/2] riscv: Add ISA double trap extension
 testing
Message-ID: <20250605-804fba12f792b0f8cde255d3@orel>
References: <20250603154652.1712459-1-cleger@rivosinc.com>
 <20250603154652.1712459-3-cleger@rivosinc.com>
 <20250603-1e175dd9e60c1bf2a52dbfc9@orel>
 <f8acf479-4a80-4128-bdd3-4ae69e0c215c@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f8acf479-4a80-4128-bdd3-4ae69e0c215c@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 05, 2025 at 11:52:14AM +0200, Clément Léger wrote:
...
> >> +	if (sbi_probe(SBI_EXT_SSE)) {
> >> +		if (sse_double_trap()) {
> >> +			report_skip("Could not correctly unregister SSE event, skipping last test");
> >> +			return;
> >> +		}
> >> +	} else {
> >> +		report_skip("SSE double trap event will not be tested, extension is not available");
> > 
> > Missing return
> 
> That's actually telling us it skipped the SSE + double trap test, not
> the rest of this function. So that should be kept without any return or
> we will skip the last test.
>

Ah, yes.

Thanks,
drew

