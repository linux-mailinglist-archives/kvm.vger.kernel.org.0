Return-Path: <kvm+bounces-13586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0520C898CFA
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 19:07:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAB58284D90
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 17:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0591112D1EA;
	Thu,  4 Apr 2024 17:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="F2H76ow5"
X-Original-To: kvm@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE09A12B82;
	Thu,  4 Apr 2024 17:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712250451; cv=none; b=V1+t/HslF9Sciq0tZhHKq/TQ0ML2OnmcRIOQuC3W7tqgPbLRiodLHWP5W+BdqKU5A52R9Sfpozt37PEQnXQHvtJFwEWU3zxgQCn98W0ZSkqaSbylQ+PggJ16sN1f/wgTi9ewmu6SDQP9kQyiz2A0/fNgs1jih0ykjO5p0aSF6Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712250451; c=relaxed/simple;
	bh=80vC5r0T6UXs+U9Ol1rgtY347RqFa7tSqjNTx7djY0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jYYANVJQZOqxgDcVcc7hgNcIVifpK81bpTB7rIUTReZ+9aPRSxQU3ZK+C841EDDHpZ6B7DB7otbV5ghT3Gus/o1DKtARBQK4VewgcsgqSOTUEAIoSjVuZSS8KkO7G2RHJ6/jXpZ1EhKDagSRSF2ciZfxXwD688Cl5kQbdMsBh+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=F2H76ow5; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.66.208.34] (unknown [108.143.43.187])
	by linux.microsoft.com (Postfix) with ESMTPSA id DB70B20E94A4;
	Thu,  4 Apr 2024 10:07:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DB70B20E94A4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1712250449;
	bh=72abs/jZSWLvmWAMUPLH/C4UA5U70IV/0GN6RCUuyvc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F2H76ow5rcwnwLy2p9aJA7bpF0N9MZ1LBBjScin0cGtJ+3U+IvW4qtjHa9lPOsWhE
	 WWGfoIGOOpTwTy8O6fJRl5HurbvSEUthk6qWqo6jbxldtkuuROfpwp7iTZjGIS/LPf
	 /a6pgm6LVRPaKXZlfodKCCVWIx09r4ycXgPx/bto=
Message-ID: <aecd56a4-0a88-4162-95ef-47561631f16e@linux.microsoft.com>
Date: Thu, 4 Apr 2024 19:07:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] x86/CPU/AMD: Track SNP host status with
 cc_platform_*()
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 KVM <kvm@vger.kernel.org>, Ashish Kalra <ashish.kalra@amd.com>,
 Joerg Roedel <joro@8bytes.org>, Michael Roth <michael.roth@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>
References: <20240327154317.29909-1-bp@alien8.de>
 <20240327154317.29909-6-bp@alien8.de>
 <f6bb6f62-c114-4a82-bbaf-9994da8999cd@linux.microsoft.com>
 <20240328134109.GAZgVzdfQob43XAIr9@fat_crate.local>
 <ac4f34a0-036a-48b9-ab56-8257700842fc@linux.microsoft.com>
 <20240328153914.GBZgWPIvLT6EXAPJci@fat_crate.local>
Content-Language: en-CA
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
In-Reply-To: <20240328153914.GBZgWPIvLT6EXAPJci@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/03/2024 16:39, Borislav Petkov wrote:
> On Thu, Mar 28, 2024 at 03:24:29PM +0100, Jeremi Piotrowski wrote:
>> It's not but if you set it before the check it will be set for all AMD
>> systems, even if they are neither CC hosts nor CC guests.
> 
> That a problem?
> 

No problem now but I did find it odd that cc_vendor will now always be set for AMD but
not for Intel. For Intel the various checks would automatically return true. Something
to look out for in the future when adding CC_ATTR's - no one can assume that the checks
will only run when actively dealing with confidential computing.

> It is under a CONFIG_ARCH_HAS_CC_PLATFORM...
>>> To leave open the possibility of an SNP hypervisor running nested.
> 
> But !CC_ATTR_GUEST_SEV_SNP doesn't mean that. It means it is not
> a SEV-SNP guest.
> 
>> I thought you wanted to filter out SEV-SNP guests, which also have
>> X86_FEATURE_SEV_SNP CPUID bit set.
> 
> I want to run snp_probe_rmptable_info() only on baremetal where it makes
> sense.
>>> My understanding is that these are the cases:
>>
>> CPUID(SEV_SNP) | MSR(SEV_SNP)     | what am I
>> ---------------------------------------------
>> set            | set              | SNP-guest
>> set            | unset            | SNP-host
>> unset          | ??               | not SNP
> 
> So as you can see, we can't use X86_FEATURE_SEV_SNP for anything due to
> the late disable need. So we should be moving away from it.
> 

I see your point about the disable needing to happen late - but then how about we remove
the setup_clear_cpu_cap(X86_FEATURE_SEV_SNP) too? No code depends on it any more and it would
help my cause as well.

> So we need a test for "am I a nested SNP hypervisor?"
> 
> So, can your thing clear X86_FEATURE_HYPERVISOR and thus "emulate"
> baremetal?
> 

Can't do that... it is a VM and hypervisor detection and various paravirt interfaces depend on
X86_FEATURE_HYPERVISOR.



