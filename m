Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508CA6DAA91
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 11:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239429AbjDGJEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 05:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbjDGJEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 05:04:38 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F66B65A4;
        Fri,  7 Apr 2023 02:04:37 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-244922a6b71so124579a91.3;
        Fri, 07 Apr 2023 02:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680858276; x=1683450276;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zb8y9dudq0AzNbaQ2lh02gLnr7/d8UxGMGjzbJEkvuo=;
        b=lTejcQZdW/H/Lkv0u39rnc8X/MYFHuE9oiwqmf+46TuP4aPifZpz/ETMw7kqBkzX7+
         ecJmdYCsvuYkwcfYO9pdxFmk24aW/t32mtVYXnsIrvCKUkrsROjZ6KkC8vEs99cUlVPS
         hmBQrUkdWKXWqqpLxNoy9BpSkc9MasFElu7eNdzgI75vPReJOtDVlf8LwMKsA/GO3T++
         do+cK9i4e+38HQuxb3iR4qxGNmptPWDWnGcomNCxsdjVHeuzjg+WdIzVHO9WwzfnTtkm
         IA/X5YFL0d7YJ5bsAA3R+cjZo4dOWW94+bSAHS1zoibyeVfTu9JvLaCsVi9/s7DGBoxm
         YZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680858276; x=1683450276;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zb8y9dudq0AzNbaQ2lh02gLnr7/d8UxGMGjzbJEkvuo=;
        b=7nMN0zvG4PV067fyww5vzU+XmTSAT3z4sTVhK87dPX/MqCWPEZGFKe/7ZakFxhn0vm
         RITN9UcUg0yH76agK+rC2cvCK24H+b0UL/5sQAFsnwy6K3a/0NehJ5Hec4NpJ4RV9dif
         Vd4ZyF9M3BbkviaZbJ2j2H+BG4A4J+/2J1FndwYF5L/vQrXqgUOfeK8BP2jDzeErrIri
         kbLYZt0eAY1VE1a7vfS5mRj2zuyxpQbTpM8sk4Rx6rRqfrwswlVkSsVstgaXkhw6pWgv
         /GXGyCQfiihlZn2z4oi2b9zIE0BSCMYVvUjrjh5fbjXFdkDtJK//HKaQrd1b0DdbiQsf
         fbUQ==
X-Gm-Message-State: AAQBX9cZFLIF4GPFPsXb7+KmJzFnVBDi+GZ+Lk+W9in0Sphso8ke+DF1
        tRqgsIEq46lr4wsNnkMchoc=
X-Google-Smtp-Source: AKy350Y1WUX7V+whh9L25qRg6k2smxxT3Z+GWtjK8iipL4+UJ9ogI5MUK1YEMq4VNikKkXsYAk+oGg==
X-Received: by 2002:a62:790c:0:b0:5f1:f57a:b0c3 with SMTP id u12-20020a62790c000000b005f1f57ab0c3mr2124159pfc.5.1680858276637;
        Fri, 07 Apr 2023 02:04:36 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v19-20020a62a513000000b005a8dd86018dsm2603373pfm.64.2023.04.07.02.04.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 02:04:36 -0700 (PDT)
Message-ID: <7c57fa4e-de52-867f-6ad9-1afa705245cc@gmail.com>
Date:   Fri, 7 Apr 2023 17:04:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH v2] KVM: x86/pmu/misc: Fix a typo on
 kvm_pmu_request_counter_reprogam()
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230310113349.31799-1-likexu@tencent.com>
In-Reply-To: <20230310113349.31799-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean, would you pick this up ?

On 10/3/2023 7:33 pm, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Fix a "reprogam" typo in the kvm_pmu_request_counter_reprogam(), which
> should be fixed earlier to follow the meaning of {pmc_}reprogram_counter().
> 
> Fixes: 68fb4757e867 ("KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
> v1: https://lore.kernel.org/all/20230308104707.27284-1-likexu@tencent.com
>   arch/x86/kvm/pmu.c           | 2 +-
>   arch/x86/kvm/pmu.h           | 2 +-
>   arch/x86/kvm/svm/pmu.c       | 2 +-
>   arch/x86/kvm/vmx/pmu_intel.c | 6 +++---
>   4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 7b6c3ba2c8e1..bdeec0ab5e2b 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -646,7 +646,7 @@ static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
>   {
>   	pmc->prev_counter = pmc->counter;
>   	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
> -	kvm_pmu_request_counter_reprogam(pmc);
> +	kvm_pmu_request_counter_reprogram(pmc);
>   }
>   
>   static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 79988dafb15b..cff0651b030b 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -183,7 +183,7 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>   					     KVM_PMC_MAX_FIXED);
>   }
>   
> -static inline void kvm_pmu_request_counter_reprogam(struct kvm_pmc *pmc)
> +static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
>   {
>   	set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
>   	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index cc77a0681800..5fa939e411d8 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -161,7 +161,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		data &= ~pmu->reserved_bits;
>   		if (data != pmc->eventsel) {
>   			pmc->eventsel = data;
> -			kvm_pmu_request_counter_reprogam(pmc);
> +			kvm_pmu_request_counter_reprogram(pmc);
>   		}
>   		return 0;
>   	}
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index e8a3be0b9df9..797fff9dbe80 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -57,7 +57,7 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
>   		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
>   
>   		__set_bit(INTEL_PMC_IDX_FIXED + i, pmu->pmc_in_use);
> -		kvm_pmu_request_counter_reprogam(pmc);
> +		kvm_pmu_request_counter_reprogram(pmc);
>   	}
>   }
>   
> @@ -81,7 +81,7 @@ static void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
>   	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX) {
>   		pmc = intel_pmc_idx_to_pmc(pmu, bit);
>   		if (pmc)
> -			kvm_pmu_request_counter_reprogam(pmc);
> +			kvm_pmu_request_counter_reprogram(pmc);
>   	}
>   }
>   
> @@ -482,7 +482,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   				reserved_bits ^= HSW_IN_TX_CHECKPOINTED;
>   			if (!(data & reserved_bits)) {
>   				pmc->eventsel = data;
> -				kvm_pmu_request_counter_reprogam(pmc);
> +				kvm_pmu_request_counter_reprogram(pmc);
>   				return 0;
>   			}
>   		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false))
> 
> base-commit: 13738a3647368f7f600b30d241779bcd2a3ebbfd
