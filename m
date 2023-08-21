Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA5978250F
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 10:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbjHUIFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 04:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbjHUIFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 04:05:44 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0CAB5;
        Mon, 21 Aug 2023 01:05:42 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-56963f2e48eso644558a12.1;
        Mon, 21 Aug 2023 01:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692605142; x=1693209942;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R8+twpAdIifafYak1GhoiEe0j1R1LSeO5MSc+/qvLN8=;
        b=Ka8DRSvECpCdFUeZk0vxW8VciogcM/xYwqyXaQ2oK8MVmI2TeOfMbr+87kZz8OGZQC
         n9K1/Zq746TVTx2NDvvR+9fHRuHjydnQA5MYNGhImGgrLNFBVSnvAUIrN2bQaZ/tjBWx
         G+eXxQmhp5Ai7P0xeiSHxYYp3mBgT86LbZFXzx29gSW6JX4s6IvzLLwE4rLP+tZRsXag
         jH5VXhjpDhNNnTH6lRFWcE2jWGQHKyPDy7s0uyZkUhgoFiBCyofaSgocjvr4dv2E2DyD
         cTQnsBjb0EzV34gN6X1mKY8j71kFleSL0DggS3zwIOwmZZpOYz4AhfpD3OqPDN1qyyLW
         mwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692605142; x=1693209942;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R8+twpAdIifafYak1GhoiEe0j1R1LSeO5MSc+/qvLN8=;
        b=KZ6AXD2KYYoCvsFbmx1pjjDp/qQoHEMqe5wicPWVYO3+h32io2RWcxIf+0D/B2AaLH
         K+DEVUldBAQ/K/vLM/dfMglW20L1YnIqm0pvNmCv7NlCYNLjlxVk7xVZ04r9sAn8Ikyc
         ejpH/l7eVnCCHJnik/O+tYBjCDfu4YA5O3qvkJCrXuap6m2P0Rq3Lk0i+06MJkuLFbFl
         PnVo8t+uwHhL/xECsy5iJXdgNJPzbmjQ9p7hfbuInGkMzKkSBTMesK9GbpnFdtX99ase
         z6OMpqLNHzYi6aA/QSchuL4OfPpJHPawcz8fsZPC91Rn6OsHk6agssJNkYWGpWtitzET
         83pw==
X-Gm-Message-State: AOJu0Yx4g4lLbFrrolAknxGqrcE+afhVWlh4DahdtH3ZoxRVcdqLFEtF
        jEV7ap92lts1j7K/Ma85Ic8=
X-Google-Smtp-Source: AGHT+IEgR81aC7uWhmHDKjI6b8NW+OuEbTwRpJ1/iQciPPXKp7Bwr0gSiiUODOJhnGPjng9CIE0lgg==
X-Received: by 2002:a17:90a:cb8f:b0:268:ce03:e17e with SMTP id a15-20020a17090acb8f00b00268ce03e17emr3142818pju.47.1692605142076;
        Mon, 21 Aug 2023 01:05:42 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id l16-20020a17090aec1000b0026d462d34ffsm5274721pjy.47.2023.08.21.01.05.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Aug 2023 01:05:41 -0700 (PDT)
Message-ID: <305fa208-e1d6-7e22-3156-11fd551a8dd1@gmail.com>
Date:   Mon, 21 Aug 2023 16:05:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v2] KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with
 macros
Content-Language: en-US
To:     Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>
References: <20230815032849.2929788-1-dapeng1.mi@linux.intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230815032849.2929788-1-dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/8/2023 11:28 am, Dapeng Mi wrote:
> Magic numbers are used to manipulate the bit fields of
> FIXED_CTR_CTRL MSR. This is not read-friendly and use macros to replace
> these magic numbers to increase the readability.

More, reuse INTEL_FIXED_0_* macros for pmu->fixed_ctr_ctrl_mask, pls.

> 
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>   arch/x86/kvm/pmu.c | 10 +++++-----
>   arch/x86/kvm/pmu.h |  6 ++++--
>   2 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index edb89b51b383..fb4ef2da3e32 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -420,11 +420,11 @@ static void reprogram_counter(struct kvm_pmc *pmc)
>   	if (pmc_is_fixed(pmc)) {
>   		fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
>   						  pmc->idx - INTEL_PMC_IDX_FIXED);
> -		if (fixed_ctr_ctrl & 0x1)
> +		if (fixed_ctr_ctrl & INTEL_FIXED_0_KERNEL)
>   			eventsel |= ARCH_PERFMON_EVENTSEL_OS;
> -		if (fixed_ctr_ctrl & 0x2)
> +		if (fixed_ctr_ctrl & INTEL_FIXED_0_USER)
>   			eventsel |= ARCH_PERFMON_EVENTSEL_USR;
> -		if (fixed_ctr_ctrl & 0x8)
> +		if (fixed_ctr_ctrl & INTEL_FIXED_0_ENABLE_PMI)
>   			eventsel |= ARCH_PERFMON_EVENTSEL_INT;
>   		new_config = (u64)fixed_ctr_ctrl;
>   	}
> @@ -749,8 +749,8 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
>   	} else {
>   		config = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl,
>   					  pmc->idx - INTEL_PMC_IDX_FIXED);
> -		select_os = config & 0x1;
> -		select_user = config & 0x2;
> +		select_os = config & INTEL_FIXED_0_KERNEL;
> +		select_user = config & INTEL_FIXED_0_USER;
>   	}
>   
>   	return (static_call(kvm_x86_get_cpl)(pmc->vcpu) == 0) ? select_os : select_user;
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 7d9ba301c090..ffda2ecc3a22 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -12,7 +12,8 @@
>   					  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
>   
>   /* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
> -#define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) & 0xf)
> +#define fixed_ctrl_field(ctrl_reg, idx) \
> +	(((ctrl_reg) >> ((idx) * INTEL_FIXED_BITS_STRIDE)) & INTEL_FIXED_BITS_MASK)
>   
>   #define VMWARE_BACKDOOR_PMC_HOST_TSC		0x10000
>   #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
> @@ -165,7 +166,8 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
>   
>   	if (pmc_is_fixed(pmc))
>   		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
> -					pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
> +					pmc->idx - INTEL_PMC_IDX_FIXED) &
> +					(INTEL_FIXED_0_KERNEL | INTEL_FIXED_0_USER);
>   
>   	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
>   }
> 
> base-commit: 240f736891887939571854bd6d734b6c9291f22e
