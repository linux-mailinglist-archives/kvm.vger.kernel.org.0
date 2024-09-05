Return-Path: <kvm+bounces-25933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 726F296D609
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 12:29:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D0B41F212FA
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 10:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE23519D06D;
	Thu,  5 Sep 2024 10:25:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39AAD1990A1;
	Thu,  5 Sep 2024 10:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725531925; cv=none; b=oDe33Xm22FZdlWocwT35sAdUNuyCEDjz6HezkceRN1Ih/U9VlbBM7wyeGmoBjtmaW9oFt+ur8RK6Bv96nHT4I4bbV9u/bMblHKMDUr98GYC3ffj+9Glf5AV7UXXrP9hyxEX1qS341NheiFIHEAPq5DkL78S9UQ3IcY4IA5JiMTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725531925; c=relaxed/simple;
	bh=fm7S5KGbuLe9W5HkTosNITMnTz+xAKNDodVv8VFktOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJ4TaQd+IfBj5raX5XUnqzUkgj/PKJzU7NsYsJ7puB9iwagWtBbk+3HA//ETxjYZFmH42XfjNOOBSlm9k7WFsOnixMZKWrhSYKPuwaRYku5vf0dqO1y/zn11Wxgv2qe1m88pwGufvhkJFOTe6/fcplfIWitvU5hBYgZDWBF81ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06AA5FEC;
	Thu,  5 Sep 2024 03:25:49 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BBA503F73F;
	Thu,  5 Sep 2024 03:25:16 -0700 (PDT)
Date: Thu, 5 Sep 2024 11:25:10 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>,
	Sean Christopherson <seanjc@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Will Deacon <will@kernel.org>, Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 1/5] arm: perf: Drop unused functions
Message-ID: <ZtmHBuggqUr3ncw6@J2N7QTR9R3>
References: <20240904204133.1442132-1-coltonlewis@google.com>
 <20240904204133.1442132-2-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904204133.1442132-2-coltonlewis@google.com>

On Wed, Sep 04, 2024 at 08:41:29PM +0000, Colton Lewis wrote:
> perf_instruction_pointer() and perf_misc_flags() aren't used anywhere
> in this particular perf implementation. Drop them.

I think it'd be better to say that arch/arm's implementation of these is
equivalent to the generic versions in include/linux/perf_event.h, and so
arch/arm doesn't need to provide its own versions. It doesn't matter if
arch/arm uses them itself since they're being provided for the core perf
code.

With words to that effect:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  arch/arm/include/asm/perf_event.h |  7 -------
>  arch/arm/kernel/perf_callchain.c  | 17 -----------------
>  2 files changed, 24 deletions(-)
> 
> diff --git a/arch/arm/include/asm/perf_event.h b/arch/arm/include/asm/perf_event.h
> index bdbc1e590891..c08f16f2e243 100644
> --- a/arch/arm/include/asm/perf_event.h
> +++ b/arch/arm/include/asm/perf_event.h
> @@ -8,13 +8,6 @@
>  #ifndef __ARM_PERF_EVENT_H__
>  #define __ARM_PERF_EVENT_H__
>  
> -#ifdef CONFIG_PERF_EVENTS
> -struct pt_regs;
> -extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
> -extern unsigned long perf_misc_flags(struct pt_regs *regs);
> -#define perf_misc_flags(regs)	perf_misc_flags(regs)
> -#endif
> -
>  #define perf_arch_fetch_caller_regs(regs, __ip) { \
>  	(regs)->ARM_pc = (__ip); \
>  	frame_pointer((regs)) = (unsigned long) __builtin_frame_address(0); \
> diff --git a/arch/arm/kernel/perf_callchain.c b/arch/arm/kernel/perf_callchain.c
> index 1d230ac9d0eb..a2601b1ef318 100644
> --- a/arch/arm/kernel/perf_callchain.c
> +++ b/arch/arm/kernel/perf_callchain.c
> @@ -96,20 +96,3 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
>  	arm_get_current_stackframe(regs, &fr);
>  	walk_stackframe(&fr, callchain_trace, entry);
>  }
> -
> -unsigned long perf_instruction_pointer(struct pt_regs *regs)
> -{
> -	return instruction_pointer(regs);
> -}
> -
> -unsigned long perf_misc_flags(struct pt_regs *regs)
> -{
> -	int misc = 0;
> -
> -	if (user_mode(regs))
> -		misc |= PERF_RECORD_MISC_USER;
> -	else
> -		misc |= PERF_RECORD_MISC_KERNEL;
> -
> -	return misc;
> -}
> -- 
> 2.46.0.469.g59c65b2a67-goog
> 

