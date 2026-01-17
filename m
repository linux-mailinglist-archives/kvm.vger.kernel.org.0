Return-Path: <kvm+bounces-68419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A8BADD38ADB
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 01:44:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 64DF630A28ED
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 00:43:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 349301CBEB9;
	Sat, 17 Jan 2026 00:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="X8mxWMAB"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF1F2AE77;
	Sat, 17 Jan 2026 00:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768610635; cv=none; b=DQXfClBkR92afgKFzxsVh1eQTZIDkkMPmFDHKPteP7bBYKyuYXatguWt1HuDRGdQH78MCn/MNCS+k0V3/RaElPTPkZ7eaR2Pz7inI1QHw2qgxfrBTv5TLI8+PrtlymEj7kipPRiGcsshanLX1hkqw9Y6mr7QtpSgzUl+4Q5F38I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768610635; c=relaxed/simple;
	bh=GJGzOaw5XpicWH8ZxdOGPW7VUK9w4NSwHltaxAoD5gs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S2qL7hOpJ7qK91VVYbtZZVWWuUE7ZOVdXe6Awc5Rcxj/bzeBNacrkaPmWDxI8EhCCs5EmUlyM8a2IgG3msphH2ySmsVHMUmZPHi/G0eiJILEW7+2hXmk/YsqjTSjS24krcmU6id4vXnjKdUY2nP9QLZB5HprL06NblCss/tHI84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=X8mxWMAB; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [172.27.2.41] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60H0h7CI3247648
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 16 Jan 2026 16:43:10 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60H0h7CI3247648
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1768610592;
	bh=leLmyrJ1FfWSvMOk/rPhTdiGmvfjmFVcQEyk0fq21to=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X8mxWMABza4CzXSRrHyV8gVTuRUj93ewZVObWw1332qYM/DclYQbD7ekAae6Jgg7t
	 NpGQg16UPyqV0JWbZfzRpoMPcZrRWVD4HfUL2NNggy43L3JYM2DO31ZaJLL7luBCDQ
	 3gvT1MIEmfC2cBO2Vl5DVfv5xd7BFfiecdRLy8w99xLU9PbgSYSsC8rFac4HBw/DFR
	 rh/EH0IZgtijX2HYrw4IS4m6DhtBVG47F/5VZd5+8Rmp9db/jp04yrJExnR695DJTs
	 pXCcySASlBxTh2Q3vB195VSn3hzm3MUEsuERS+DpUK30Iy3isF+hHAtvPuccrkJRib
	 Wq6UbYvhpauEw==
Message-ID: <f0768546-a767-4d74-956e-b40128272a09@zytor.com>
Date: Fri, 16 Jan 2026 16:43:00 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 08/22] KVM: VMX: Set FRED MSR intercepts
To: Dave Hansen <dave.hansen@intel.com>, "Xin Li (Intel)" <xin@zytor.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, chao.gao@intel.com, hch@infradead.org,
        sohil.mehta@intel.com
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-9-xin@zytor.com>
 <d856b68d-3721-4d76-922b-4c98e2eb6c67@intel.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <d856b68d-3721-4d76-922b-4c98e2eb6c67@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026-01-16 11:49, Dave Hansen wrote:
> On 10/26/25 13:18, Xin Li (Intel) wrote:
>> Both MSR_IA32_FRED_RSP0 and MSR_IA32_FRED_SSP0 (aka MSR_IA32_PL0_SSP)
>> are dedicated for userspace event delivery, IOW they are NOT used in
>> any kernel event delivery and the execution of ERETS.  Thus KVM can
>> run safely with guest values in the two MSRs.  As a result, save and
>> restore of their guest values are deferred until vCPU context switch,
>> Host MSR_IA32_FRED_RSP0 is restored upon returning to userspace, and
>> Host MSR_IA32_PL0_SSP is managed with XRSTORS/XSAVES.
> 
> Is it worth making MSR_IA32_FRED_RSP0 special versus MSR_IA32_FRED_RSP[123]?
> 
> Is it needed because MSR_IA32_FRED_RSP0 is rewritten all the time as
> CPUs switch between threads? But MSR_IA32_FRED_RSP[123] are not
> frequently written?
> 
> I'd like to hear more about the motivation.

Because RSP[123] (and SSP[123]) are used by the kernel itself they are
context-switched by VTx automatically. This is necessary in order to preserve
the FRED architectural invariant that there should NEVER be a "gap" during
which it is unsafe to take an exception.

[RS]SP0 are not used while in kernel mode (since the only time we switch
*onto* the level 0 kernel stack is when entering from user space, logically
"CSL -1"), so during FRED architectural discussions it was agreed that it was
better to leave its management to kernel code, especially as KVM often does
not need to cross back into user space after each VMEXIT.

A nice side effect, but just that -- a side effect -- is that we don't need to
actually modify [RS]SP0 in the context-switch or task setup code.

The invariant that needs to be maintained is that IF the cached rsp0 value is
equal to the initial stack pointer for the running task, THEN the MSR MUST
match the cached value. A corollary of that is that if we modify either the
MSR or the cached value from an event that may have interrupted the kernel we
MUST make sure that this invariant cannot be inadvertently broken.

Setting the cached value to an invalid value (e.g. NULL/0) should work; there
shouldn't be an actual need to read the MSR unless I'm mistaken -- but I have
been working on other code today and so my cache for this specific code is not
100% up to date.

	-hpa


