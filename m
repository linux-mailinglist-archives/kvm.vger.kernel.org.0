Return-Path: <kvm+bounces-49933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3C5CADFCA5
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 07:03:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A9D63B2152
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 05:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 290FC241665;
	Thu, 19 Jun 2025 05:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="nJlMFyh+"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325D821A452;
	Thu, 19 Jun 2025 05:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750309374; cv=none; b=kOlNdhEzV7orx1V/TVOgdpdeAHG3/UsCReBJMvlYTusANW+oPz2/mvkvOhtVsnVGd4bRf+WoVBzabtXCwan3wVe1mQ8qMIAa4dh1QU2ptxWbwCSKOyzrmcJLhPBWu6KuAiiwrVGbMdUmdf2r/wXBqYUpeuh13+I3IU5KtQ6H9Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750309374; c=relaxed/simple;
	bh=cC1gNkglobCCgQWoLRRzm+tji0YRzCCMskKW7Rup5es=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GWvMkHKNOe1w9mTA/SOxeEWIySM2JmMWyTl7CkNOj87yBRIk4jNMh9+Xw9g3yaBOrpw6DY1C439j3QbgsONWQxGzx5H4FmgVfzeABUjwqfbgBGHV1WFcHsj4JChudcZhTePhMywneyByZhLa0dhzmBIUyeMZkbTC6tuL5RgjzQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=nJlMFyh+; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55J529FG1854570
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 18 Jun 2025 22:02:10 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55J529FG1854570
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1750309332;
	bh=nz8+KCii5aZfAsUnyh008znZgZhwquPROyRzQoxFqeU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nJlMFyh+ggWVGqIlASPvwYh5Mktn0GpAWRc4Ez52VsMr9JJFOsr68py3bAlMqCyVa
	 iPTFNYYN9v3AZnZMbNUzpMZrF5c5KPFwyH2FOvTO/JiF4XLBMbXxRdolhMLtWb3GQ4
	 g6U5VKe+4x9fa3SvV3nyYsYgYselIur7BeF1j8HsmaYBDzk0IiHaYi591QoRNziaPP
	 phFigHu1V45uCzhqSqmglaZrWJNDAdwpN7T+4/+WAoRKpwykXs/PrZ5TlpJ0/bEWs8
	 MaGPZRCuIqr7QzmC0G9Buu4oLjgHl6Xs4ww37cGZ9QI6ps7VibWf6LNW/2QiAqLtra
	 /X+rG0AtsNaNw==
Message-ID: <7525af7f-a817-47d5-91f7-d7702380c85f@zytor.com>
Date: Wed, 18 Jun 2025 22:02:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/10] x86/fred: Pass event data to the NMI entry point
 from KVM
To: Sohil Mehta <sohil.mehta@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Jacob Pan <jacob.pan@linux.microsoft.com>,
        Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>,
        Sandipan Das <sandipan.das@amd.com>, linux-perf-users@vger.kernel.org,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-3-sohil.mehta@intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250612214849.3950094-3-sohil.mehta@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/2025 2:48 PM, Sohil Mehta wrote:
> Extend the FRED NMI entry point from KVM to take an extra argument to
> allow KVM to invoke the FRED event dispatch framework with event data.
> 
> This API is used to pass the NMI-source bitmap for NMI-induced VM exits.
> Read the VMCS exit qualification field to get the NMI-source information
> and store it as event data precisely in the format expected by the FRED
> event framework.
> 
> Read the VMCS exit qualification unconditionally since almost all
> upcoming CPUs are expected to enable FRED and NMI-source together. In
> the rare case that NMI-source isn't enabled, the extra VMREAD would be
> harmless since the exit qualification is expected to be zero.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Originally-by: Zeng Guang <guang.zeng@intel.com>
> Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>

A couple of nits below, otherwise:

Reviewed-by: Xin Li (Intel) <xin@zytor.com>

> ---
> v7: Pass the event data from KVM only for NMI. (Sean)
> 
> v6: No change
> 
> v5: Read the VMCS exit qualification unconditionally. (Sean)
>      Combine related patches into one.
> ---
>   arch/x86/entry/entry_64_fred.S |  2 +-
>   arch/x86/include/asm/fred.h    | 11 ++++++-----
>   arch/x86/kvm/vmx/vmx.c         |  2 +-
>   3 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
> index 29c5c32c16c3..1c9c6e036233 100644
> --- a/arch/x86/entry/entry_64_fred.S
> +++ b/arch/x86/entry/entry_64_fred.S
> @@ -93,7 +93,7 @@ SYM_FUNC_START(asm_fred_entry_from_kvm)
>   	 * +--------+-----------------+
>   	 */
>   	push $0				/* Reserved, must be 0 */
> -	push $0				/* Event data, 0 for IRQ/NMI */
> +	push %rsi			/* Event data for NMI */

Maybe a bit more accurate?

/* Event data, NMI-source bitmap only so far */

>   	push %rdi			/* fred_ss handed in by the caller */
>   	push %rbp
>   	pushf
> diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
> index 552332ca060c..bccf4a3c06b8 100644
> --- a/arch/x86/include/asm/fred.h
> +++ b/arch/x86/include/asm/fred.h
> @@ -66,14 +66,14 @@ static __always_inline unsigned long fred_event_data(struct pt_regs *regs)
>   
>   void asm_fred_entrypoint_user(void);
>   void asm_fred_entrypoint_kernel(void);
> -void asm_fred_entry_from_kvm(struct fred_ss);
> +void asm_fred_entry_from_kvm(struct fred_ss ss, unsigned long edata);
>   
>   __visible void fred_entry_from_user(struct pt_regs *regs);
>   __visible void fred_entry_from_kernel(struct pt_regs *regs);
>   __visible void __fred_entry_from_kvm(struct pt_regs *regs);
>   
>   /* Must be called from noinstr code, thus __always_inline */
> -static __always_inline void fred_nmi_from_kvm(void)
> +static __always_inline void fred_nmi_from_kvm(unsigned long edata)
>   {
>   	struct fred_ss ss = {
>   		.ss	= __KERNEL_DS,
> @@ -83,7 +83,7 @@ static __always_inline void fred_nmi_from_kvm(void)
>   		.lm	= 1,
>   	};
>   
> -	asm_fred_entry_from_kvm(ss);
> +	asm_fred_entry_from_kvm(ss, edata);
>   }
>   
>   static inline void fred_irq_from_kvm(unsigned int vector)
> @@ -95,7 +95,8 @@ static inline void fred_irq_from_kvm(unsigned int vector)
>   		.lm	= 1,
>   	};
>   
> -	asm_fred_entry_from_kvm(ss);
> +	/* Event data is always zero for IRQ */

/* Event data not used for IRQ thus 0 */

