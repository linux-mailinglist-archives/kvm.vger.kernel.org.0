Return-Path: <kvm+bounces-70347-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WM44CjLBhGnG4wMAu9opvQ
	(envelope-from <kvm+bounces-70347-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 17:11:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 933C2F5061
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 17:11:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 49934302DE09
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 16:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01224436365;
	Thu,  5 Feb 2026 16:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Nv2s5bbx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0921A42980C;
	Thu,  5 Feb 2026 16:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770307816; cv=none; b=qijqHMjCDLKkLHrOPvlobCfxSwMhlTLnIbovySCJKPnxXUqaCZoaq5JRCYNN/YogSzlO9sCaP8iOvJqNEDe5kF5y2Pqy9D7UFF9tY3SU0JSy17gO5/u1nuOGw+XpYcJ2LKPGfE7wCKhkjEPR2SdgXhnP7bzb26KVhPhgMQ+/nAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770307816; c=relaxed/simple;
	bh=1Y9kTUxObA5PRGOhksza1ItRBMQVFFAeDQzn+OFKihU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bXDo5/gc92eAqN5DGA+RsV6g6q5367KDCMoTW4n+WJ5YFg7WzeF06UfXUwAdeBmpqc66AD1mY558MF+goVbwoZOy2cMchwyx30AtzV51wlw3ypBFW2i2AiToaCTZihP1daVap7UdCRdnI2OvfLgDvAmFfdcUDR4CwETT5/YpTzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Nv2s5bbx; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770307816; x=1801843816;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1Y9kTUxObA5PRGOhksza1ItRBMQVFFAeDQzn+OFKihU=;
  b=Nv2s5bbxDlveC0hulJDEWjWDxx5wgemlaXjUmIy7bbEHX9JWymaayKcl
   R3ohva144/7svOeIGYpB32A/SUI/gENUGRfWpFcQSLEBrN9WRY3UW1cAE
   o0ZIITDlwIBZagHGNlkxDWgxxpZpCOCzcujXizsP0ewofOmb/JgoQYBfr
   YIilKjGLKzsLcVY0WzKLtEgRtC1zbM/ke4u4dt7L7jSszvB7SmDgoQsmH
   J2aaQYIAidb6cxl3PcQ6krkcvdzuw0mwZympMQ4znV4OXp76JE+N6vkGJ
   ocGiZNcMlVZdLyvo88GkpjnGQsG22Lk5It6lnuncUEwE9mrLHrw9k1g16
   w==;
X-CSE-ConnectionGUID: viRKRnImSliMZ/21pju8+w==
X-CSE-MsgGUID: iLnZQi/PQpubM9KJRix73A==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="71549231"
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="71549231"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 08:10:16 -0800
X-CSE-ConnectionGUID: Vyls9xQeSZuLf00A9ztyOQ==
X-CSE-MsgGUID: f49i3fagTOaNrMxJeaoKzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="210483918"
Received: from tfalcon-desk.amr.corp.intel.com (HELO [10.125.111.86]) ([10.125.111.86])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 08:10:15 -0800
Message-ID: <9c8c2d69-5434-4416-ba37-897ce00e2b11@intel.com>
Date: Thu, 5 Feb 2026 08:10:14 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, bp@alien8.de, thomas.lendacky@amd.com
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 hpa@zytor.com, xin@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 x86@kernel.org, jon.grimm@amd.com, stable@vger.kernel.org
References: <20260205051030.1225975-1-nikunj@amd.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260205051030.1225975-1-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[15];
	TAGGED_FROM(0.00)[bounces-70347-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.hansen@intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim]
X-Rspamd-Queue-Id: 933C2F5061
X-Rspamd-Action: no action

On 2/4/26 21:10, Nikunj A Dadhania wrote:
...
> --- a/arch/x86/entry/entry_fred.c
> +++ b/arch/x86/entry/entry_fred.c
> @@ -208,6 +208,11 @@ static noinstr void fred_hwexc(struct pt_regs *regs, unsigned long error_code)
>  #ifdef CONFIG_X86_CET
>  	case X86_TRAP_CP: return exc_control_protection(regs, error_code);
>  #endif
> +	case X86_TRAP_VC:
> +		if (user_mode(regs))
> +			return user_exc_vmm_communication(regs, error_code);
> +		else
> +			return kernel_exc_vmm_communication(regs, error_code);
>  	default: return fred_bad_type(regs, error_code);
>  	}

Please look at the code in the ~20 lines above this hunk. It has a nice,
consistent form of:

	case X86_TRAP_FOO: return exc_foo_action(...);

Could we keep that going, please?

Second, these functions are defined in arch/x86/coco/sev/vc-handle.c.
That looks suspiciously like CONFIG_AMD_MEM_ENCRYPT code and not
something that will compile everywhere. Also note the other features in
the switch() block. See all the #ifdefs on those?

Have you compiled this?

> diff --git a/arch/x86/kernel/fred.c b/arch/x86/kernel/fred.c
> index e736b19e18de..8cf4da546a8e 100644
> --- a/arch/x86/kernel/fred.c
> +++ b/arch/x86/kernel/fred.c
> @@ -27,9 +27,6 @@ EXPORT_PER_CPU_SYMBOL(fred_rsp0);
>  
>  void cpu_init_fred_exceptions(void)
>  {
> -	/* When FRED is enabled by default, remove this log message */
> -	pr_info("Initialize FRED on CPU%d\n", smp_processor_id());
> -
>  	/*
>  	 * If a kernel event is delivered before a CPU goes to user level for
>  	 * the first time, its SS is NULL thus NULL is pushed into the SS field
> @@ -70,6 +67,17 @@ void cpu_init_fred_exceptions(void)
>  	/* Use int $0x80 for 32-bit system calls in FRED mode */
>  	setup_clear_cpu_cap(X86_FEATURE_SYSFAST32);
>  	setup_clear_cpu_cap(X86_FEATURE_SYSCALL32);
> +
> +	/*
> +	 * For secondary processors, FRED bit in CR4 gets enabled in cr4_init()
> +	 * and FRED MSRs are not configured till the end of this function. For
> +	 * SEV-ES and SNP guests, any console write before the FRED MSRs are
> +	 * setup will cause a #VC and cannot be handled. Move the pr_info to
> +	 * the end of this function.
> +	 *
> +	 * When FRED is enabled by default, remove this log message
> +	 */
> +	pr_info("Initialized FRED on CPU%d\n", smp_processor_id());
>  }

This seems really gross. Now there's a window where printk() doesn't
work. To fix it, we start moving printk()'s?

Please, no.

Shouldn't we flip the FRED CR4 bit _last_, once all the MSRs are set up?
Why is it backwards in the first place? Why can't it be fixed?

