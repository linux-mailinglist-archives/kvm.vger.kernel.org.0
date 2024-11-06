Return-Path: <kvm+bounces-30993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A8CF19BF27E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 17:04:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1ADD1B20B93
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 16:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E513D206045;
	Wed,  6 Nov 2024 16:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NKC//QNW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D366F204028;
	Wed,  6 Nov 2024 16:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730909001; cv=none; b=IxfyfprJ1sHeCHEz3J2bVHNQZ2nnFRZG07pcynG103IpwbBO6aO4pBhno6wCTVw0aWj9IvfGil9dvGjZqaNcMPN+Hvue57TIp0jyEEmwFM+DA423yp2fYn5jfc/Lm2932Cm5tMrv3JKHfQxIGHYmirfF9pcKdt6meicN9Z4UetM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730909001; c=relaxed/simple;
	bh=eeEXuIJ2vlczIF22PZRVZhnTIMIbHqdB4rwbCI1c/Sg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ioHxjZvG2b/rKl6i/a9S1Pg1BDRxa0z/4iLF/c/FJbM0VqV0EHMGsIS4X9gifo/pSYDnIP7wsKPjBNBS7wDV6lgPJzDoUdiMPaDa/1gTKI1ISVPvBY142jZaCISZLGzbvfs2TEc3tP0Tk1bhI7CVZBvXTaA+mIY6rE8lrgENED4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NKC//QNW; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730908999; x=1762444999;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eeEXuIJ2vlczIF22PZRVZhnTIMIbHqdB4rwbCI1c/Sg=;
  b=NKC//QNWBYXoeHvZEqxuSnuxCT8KPuPef2vRSskVLfPrVkXKORdjfijW
   PT7V0JcFNbWVVXXhZwlVA794AgC694G7LGkNkSz2IbCO1hDExl+sq3xG7
   /fRkRkG5ju89ymQYYguwuEomHa1v/GjWw8MjjK28lvNUNJOBNDv7AcMWZ
   yxw0QRmo+0ToBCzstBTRpq6oTMdqgIVJr7/PZ8W2ga3++bO5+X8dG+MrF
   K1YcUPu0accPxz4YTPXOifFZJSr29oIB8TOZSmE/1ttypxAeeUppdpFAP
   F5DBWDDDNkKxnuwtnTrUfyig6yjxQPRNXpi7UcMAHMhIUtz0PiPYhRudm
   w==;
X-CSE-ConnectionGUID: Nh3lJl2hQrih+hUTaZUwAg==
X-CSE-MsgGUID: kfGnJJAiTmm8xeWlk7XzkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48176917"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48176917"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 08:03:17 -0800
X-CSE-ConnectionGUID: a5M3gJ+/QYaSWgS/qH6ALg==
X-CSE-MsgGUID: phJVPBFJQuabQWlVho3xvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="84715253"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 08:03:17 -0800
Received: from [10.212.82.230] (kliang2-mobl1.ccr.corp.intel.com [10.212.82.230])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 2C51820B5703;
	Wed,  6 Nov 2024 08:03:12 -0800 (PST)
Message-ID: <65675ed8-e569-47f8-b1eb-40c853751bfb@linux.intel.com>
Date: Wed, 6 Nov 2024 11:03:10 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] x86: perf: Refactor misc flag assignments
To: Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Will Deacon <will@kernel.org>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Naveen N Rao <naveen@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org
References: <20241105195603.2317483-1-coltonlewis@google.com>
 <20241105195603.2317483-5-coltonlewis@google.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20241105195603.2317483-5-coltonlewis@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-11-05 2:56 p.m., Colton Lewis wrote:
> Break the assignment logic for misc flags into their own respective
> functions to reduce the complexity of the nested logic.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/x86/events/core.c            | 31 +++++++++++++++++++++++--------
>  arch/x86/include/asm/perf_event.h |  2 ++
>  2 files changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index d19e939f3998..24910c625e3d 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -3011,16 +3011,34 @@ unsigned long perf_arch_instruction_pointer(struct pt_regs *regs)
>  	return regs->ip + code_segment_base(regs);
>  }
>  
> +static unsigned long common_misc_flags(struct pt_regs *regs)
> +{
> +	if (regs->flags & PERF_EFLAGS_EXACT)
> +		return PERF_RECORD_MISC_EXACT_IP;
> +
> +	return 0;
> +}
> +
> +unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs)
> +{
> +	unsigned long guest_state = perf_guest_state();
> +	unsigned long flags = common_misc_flags(regs);
> +
> +	if (guest_state & PERF_GUEST_USER)
> +		flags |= PERF_RECORD_MISC_GUEST_USER;
> +	else if (guest_state & PERF_GUEST_ACTIVE)
> +		flags |= PERF_RECORD_MISC_GUEST_KERNEL;
> +

The logic of setting the GUEST_KERNEL flag is implicitly changed here.

For the current code, the GUEST_KERNEL flag is set for !PERF_GUEST_USER,
which include both guest_in_kernel and guest_in_NMI.

With the above change, the GUEST_KERNEL flag should be only set for the
guest_in_kernel case.
IIUC, this is the series's target, right?

If so, could you please move the explanation into this patch?
For x86, the behavior has already been changed since this patch.

Thanks,
Kan

> +	return flags;
> +}
> +
>  unsigned long perf_arch_misc_flags(struct pt_regs *regs)
>  {
>  	unsigned int guest_state = perf_guest_state();
> -	int misc = 0;
> +	unsigned long misc = common_misc_flags(regs);
>  
>  	if (guest_state) {
> -		if (guest_state & PERF_GUEST_USER)
> -			misc |= PERF_RECORD_MISC_GUEST_USER;
> -		else
> -			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
> +		misc |= perf_arch_guest_misc_flags(regs);
>  	} else {
>  		if (user_mode(regs))
>  			misc |= PERF_RECORD_MISC_USER;
> @@ -3028,9 +3046,6 @@ unsigned long perf_arch_misc_flags(struct pt_regs *regs)
>  			misc |= PERF_RECORD_MISC_KERNEL;
>  	}
>  
> -	if (regs->flags & PERF_EFLAGS_EXACT)
> -		misc |= PERF_RECORD_MISC_EXACT_IP;
> -
>  	return misc;
>  }
>  
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index feb87bf3d2e9..d95f902acc52 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -538,7 +538,9 @@ struct x86_perf_regs {
>  
>  extern unsigned long perf_arch_instruction_pointer(struct pt_regs *regs);
>  extern unsigned long perf_arch_misc_flags(struct pt_regs *regs);
> +extern unsigned long perf_arch_guest_misc_flags(struct pt_regs *regs);
>  #define perf_arch_misc_flags(regs)	perf_arch_misc_flags(regs)
> +#define perf_arch_guest_misc_flags(regs)	perf_arch_guest_misc_flags(regs)
>  
>  #include <asm/stacktrace.h>
>  


