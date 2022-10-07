Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC9F5F7E67
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 22:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiJGUCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 16:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiJGUCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 16:02:42 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45971108DEB
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 13:02:41 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t12-20020a17090a3b4c00b0020b04251529so5579837pjf.5
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 13:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Stpxx95ZDS9bG7gmnuOOMaTOxoqM57dWWZd+DU6ZCY=;
        b=EuVXkfT890+uXLhGn1y6QZEwG27EWOv4n808K0IFF1hwKchiIKSQdpzc+vGCxXct3T
         6Qnm3cms+sekDh6uwCBfaCmSIH6KdAwIuB2k8Ue4aEXM5AeTDnmjh0PodxtrvbUat4fQ
         a5hp5P4/UkiclTjfT0EeFWrV1kf+VWZ7s5q1vciJVEpoIlToRu1rRHDcSdTOM42jpP1r
         qFDXIjfj4qTs0KjOU/pj4a/hYmAhE7Xu7n2tOvudDuU6Y23wx4eYT+0wdG011b6aXoRa
         CBJtDDRCV/NQ7y+BGQKGqEcbFmAlJJzeMylBeNrY+UxquCz5vfB7X2s334mkB44MKj/F
         Nw3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Stpxx95ZDS9bG7gmnuOOMaTOxoqM57dWWZd+DU6ZCY=;
        b=sTZEoeEZ7wGwGKsJuTp8F3wFQxxpinw9m/APe5TdeTfk7OwIxFZD1tW1oXm7eq0m/s
         bi1Pki3F8zKwgMtexaE9E8DoCz8f185PnDylz80WFqOZELd7lOlDMRsTDFu8OOn0L3gB
         s2JxdK/R9IhZUuJHqrFMIiwRmWLfOYYdH4uR2pvmJAb4SYy85Prv/qjvbR/gafjqD9Cw
         sBC4SpCmy6p2pW7+XYhMuoyNMUaz6kyLUV62lvq6k2c4R5f055ZvtjrQT5rKtHq/DjOH
         TkO4SFn60Y4B1ar3eD6bL45hIQvwklo1t+2NGC2s1taN0JDuBhP9Vun62JOf8QLQP5rc
         Ot7Q==
X-Gm-Message-State: ACrzQf3HoM+2NY3CCAW4LEoPcExkj5TiZWk+gT81ebg5VXkQzHz8piII
        KiiX9kCYm+lydX34kVnacz1jrQ==
X-Google-Smtp-Source: AMsMyM6Rh8YqTGb3IqdGB22AIAmJShevOI/0MPvRB6FqAdLfLtB7gC1oCxKtpabLfH6405OBOBApGw==
X-Received: by 2002:a17:90b:350b:b0:205:dfc1:63a7 with SMTP id ls11-20020a17090b350b00b00205dfc163a7mr7074824pjb.41.1665172960680;
        Fri, 07 Oct 2022 13:02:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o2-20020a170902d4c200b0016dbdf7b97bsm1855468plg.266.2022.10.07.13.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 13:02:39 -0700 (PDT)
Date:   Fri, 7 Oct 2022 20:02:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] KVM: x86/pmu: Limit the maximum number of
 supported Intel GP counters
Message-ID: <Y0CF3F/pJOBnY1Xz@google.com>
References: <20220919091008.60695-1-likexu@tencent.com>
 <20220919091008.60695-2-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919091008.60695-2-likexu@tencent.com>
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
> From: Like Xu <likexu@tencent.com>
> 
> The Intel Architectural IA32_PMCx MSRs addresses range allows for
> a maximum of 8 GP counters. A local macro (named KVM_INTEL_PMC_MAX_GENERIC)
> is introduced to take back control of this virtual capability to avoid
> errors introduced by the out-of-bound counter emulations.

Phrase changelogs as commands.

> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  6 +++++-
>  arch/x86/kvm/pmu.c              |  2 +-
>  arch/x86/kvm/vmx/pmu_intel.c    |  4 ++--
>  arch/x86/kvm/x86.c              | 12 +++++++-----
>  4 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2c96c43c313a..17abcf5c496a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -501,6 +501,10 @@ struct kvm_pmc {
>  	bool intr;
>  };
>  
> +/* More counters may conflict with other existing Architectural MSRs */
> +#define KVM_INTEL_PMC_MAX_GENERIC	8

This is weird and backwards.  Common x86 code shouldn't "prefer" Intel over AMD,
or vice versa.  Similar to KVM_MAX_NR_USER_RETURN_MSRS, the way to do this is to
define KVM's common software limit, and then verify that the vendor limits are
below that common limit.  E.g.

#define KVM_MAX_NR_PMU_GP_COUNTERS	8

and then add compile-time assertions that Intel stays below the max (and obviously
AMD as well).

> +#define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
> +#define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)

These are Intel specific, correct?  I.e. "arch" means "Intel architectural MSRs"?

The perf-defined names are out of KVM's control, but adding what appears to be
generic #defines in common KVM that are actually Intel specific is confusing.
Given that there's only a single user, I think the easiest thing is to just open
code the users, e.g.

		case MSR_ARCH_PERFMON_PERFCTR0 ...
		     MSR_ARCH_PERFMON_PERFCTR0 + KVM_MAX_NR_PMU_GP_COUNTERS - 1:
			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
			    min(KVM_MAX_NR_PMU_GP_COUNTERS, kvm_pmu_cap.num_counters_gp))
				continue;
			break;
		case MSR_ARCH_PERFMON_EVENTSEL0 ...
		     MSR_ARCH_PERFMON_EVENTSEL0 + KVM_MAX_NR_PMU_GP_COUNTERS - 1:
			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
			    min(KVM_INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
				continue;
			break;

