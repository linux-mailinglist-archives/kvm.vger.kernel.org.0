Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1666105D7
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 00:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbiJ0WhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 18:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235649AbiJ0WhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 18:37:22 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBD6B2DB5
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:37:21 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q1so3061188pgl.11
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 15:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ub/SIEZt986yb8arJ2cndGzVm5KRvAidZjWfFvReRi4=;
        b=qW7iZPT+Z4eBenEGCE1n1yppuncJnEUGbqoM5b7Mv5wfV9dZqhWk5SH7kyv3kRLunq
         KwG5ebE5Xx0WmDPEvqMFd2cDGXN4nubSXy870tvU/6zMuD82iTcW1e+fce8XaEB3XqEP
         9ORDg/daa9hERdOMgIfXYZf8IRS7OcXuHjC51tk5dBAZe25OOe4Ilw442gkODtYBZN+D
         j9Dhd/eouOjHhQWptHHVcfBgaQ9ZHQzeYRjTgKjl0DgLHgSFYWUt1wAtdE/j5viDURNP
         9LMmIGqLTjJLAsftx1GlMNfddLLMmyDtI1b/DZHgN+HTRfXNOQzfSvtKHMSJI0bio4yn
         Wz6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ub/SIEZt986yb8arJ2cndGzVm5KRvAidZjWfFvReRi4=;
        b=6nRIBvfZ7/9wOeZ5fMrac5NwSc5dj3nFEnzGLPrrE1glIUc54jMvndft9tlb0VUuJH
         59Au0PHoVXrteqvgorIbESzGTg2giGSRk5kORjqHDb3rAf6Xlo00BtzO8wFXTrE5DlkZ
         fL3RPt4ToOZ8SEjFmgp6xCyWn2rNwHO2CMA3pJQs3cHmRH18PStKg9pAbmvXpJTn83xZ
         qXMAAfwBGBS0SXsXISi4hjh+WW/pmI64mpDZSEcgWJrKQKDA9UKPinVEMnQW0v5/iHQF
         yLUeJo30qXZeNY7ivypygAqolPNgMvmqSk9+xRaKfZAKEmjkxBJwoi1ag2CrG0jh13fd
         58pA==
X-Gm-Message-State: ACrzQf0u+41w687Vi/ylgCbvIu9zz7oJh7YkLU3ZG1GTkKxnUXh/vy41
        /nNXopx2LzM2611gyDrW4S+6qQ==
X-Google-Smtp-Source: AMsMyM4wwjIk9ZHI8pZcsG+FNxhwRL3lw9zG/dOQPHWt/yYgnuXqjLQdE90uEuRPQRWQJ/2y0fXSyA==
X-Received: by 2002:aa7:800a:0:b0:565:af23:f5a4 with SMTP id j10-20020aa7800a000000b00565af23f5a4mr51517690pfi.42.1666910241002;
        Thu, 27 Oct 2022 15:37:21 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o18-20020a170902d4d200b00176c0e055f8sm1717367plg.64.2022.10.27.15.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 15:37:20 -0700 (PDT)
Date:   Thu, 27 Oct 2022 22:37:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>, g@google.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
Subject: Re: [PATCH v2 3/3] KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg
 leaf 0x80000022
Message-ID: <Y1sIHXX3HEJEXJm+@google.com>
References: <20220919093453.71737-1-likexu@tencent.com>
 <20220919093453.71737-4-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919093453.71737-4-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 19, 2022, Like Xu wrote:
> From: Sandipan Das <sandipan.das@amd.com>
> 
> From: Sandipan Das <sandipan.das@amd.com>

Duplicate "From:"s.

> CPUID leaf 0x80000022 i.e. ExtPerfMonAndDbg advertises some
> new performance monitoring features for AMD processors.

Wrap changelogs closer to ~75 chars.

> Bit 0 of EAX indicates support for Performance Monitoring
> Version 2 (PerfMonV2) features. If found to be set during
> PMU initialization, the EBX bits of the same CPUID function
> can be used to determine the number of available PMCs for
> different PMU types.
> 
> Expose the relevant bits via KVM_GET_SUPPORTED_CPUID so
> that guests can make use of the PerfMonV2 features.
> 
> Co-developed-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
> ---
>  arch/x86/include/asm/perf_event.h |  8 ++++++++
>  arch/x86/kvm/cpuid.c              | 32 ++++++++++++++++++++++++++++++-
>  2 files changed, 39 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index f6fc8dd51ef4..c848f504e467 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -214,6 +214,14 @@ union cpuid_0x80000022_ebx {
>  	unsigned int		full;
>  };
>  
> +union cpuid_0x80000022_eax {
> +	struct {
> +		/* Performance Monitoring Version 2 Supported */
> +		unsigned int	perfmon_v2:1;
> +	} split;
> +	unsigned int		full;
> +};

I'm not a fan of perf's unions, but I at least understand the value added for
CPUID entries that are a bunch of multi-bit values.  However, this leaf appears
to be a pure features leaf.  In which case a union just makes life painful.

Please add a CPUID_8000_0022_EAX kvm_only_cpuid_leafs entry (details in link[*]
below) so that KVM can write sane code like

	guest_cpuid_has(X86_FEATURE_AMD_PMU_V2)

and cpuid_entry_override() instead of manually filling in information.

where appropriate.

[*] https://lore.kernel.org/all/Y1AQX3RfM+awULlE@google.com

>  struct x86_pmu_capability {
>  	int		version;
>  	int		num_counters_gp;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 75dcf7a72605..34ba845c91b7 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1094,7 +1094,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		entry->edx = 0;
>  		break;
>  	case 0x80000000:
> -		entry->eax = min(entry->eax, 0x80000021);
> +		entry->eax = min(entry->eax, 0x80000022);
>  		/*
>  		 * Serializing LFENCE is reported in a multitude of ways, and
>  		 * NullSegClearsBase is not reported in CPUID on Zen2; help
> @@ -1203,6 +1203,36 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
>  			entry->eax |= BIT(6);
>  		break;
> +	/* AMD Extended Performance Monitoring and Debug */
> +	case 0x80000022: {
> +		union cpuid_0x80000022_eax eax;
> +		union cpuid_0x80000022_ebx ebx;
> +
> +		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> +		if (!enable_pmu)

Shouldn't

	case 0xa: { /* Architectural Performance Monitoring */

also check enable_pmu instead of X86_FEATURE_ARCH_PERFMON?

> +			break;
> +
> +		if (kvm_pmu_cap.version > 1) {
> +			/* AMD PerfMon is only supported up to V2 in the KVM. */
> +			eax.split.perfmon_v2 = 1;

With a proper CPUID_8000_0022_EAX, this becomes:

		entry->ecx = entry->edx = 0;
		if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_AMD_PMU_V2)) {
			entry->eax = entry->ebx;
			break;
		}

		cpuid_entry_override(entry, CPUID_8000_0022_EAX);

		...

		entry->ebx = ebx.full;
