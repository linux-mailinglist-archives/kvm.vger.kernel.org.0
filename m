Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04B070DCC2
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 14:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbjEWMlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 08:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjEWMlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 08:41:04 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B6ADD;
        Tue, 23 May 2023 05:41:03 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-2536e522e47so4786393a91.1;
        Tue, 23 May 2023 05:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684845662; x=1687437662;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gr1WY2Fuh1EgRnKdC7Fm8StOxQjikRGaMYsWVllTkXc=;
        b=nut+ochA96Xk4vOpZg9Qiy8uNmx/M278Eyt7WdRvY9XXGCForZjUHFvpgqMLvAy2Qu
         9eJl/SQjOj9O2Oc4csjY/9NN6+lwhIi22RHpbxliSO1OH543hkhDbMHqTz3I7efRL/70
         zYAWCEeIZ0glSGWYj5B8tzJuFxAPglqkLLULzNrW4HD0xQyz+Q7v9/iTNo0nkaHMy4lL
         p9aaIwL/WbqzUE5zjd4+6fEBYiAlL1TTYDRlmpd7haFTT/OqtAI9e+fV4v7jf5ebyitX
         fFXDrtU2DWxBtD4SeNEAfsXrp1HWQTtyQcjNz0mgB2bZ/MlrXH5IQhzI1bRHnhqxDm3k
         MVmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684845662; x=1687437662;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gr1WY2Fuh1EgRnKdC7Fm8StOxQjikRGaMYsWVllTkXc=;
        b=FX6C05132CQiDAhS+yfWyRynzgjyPJrgOpDNMnliX/kvCIu2cwXLlR6R0TLXch0wy7
         81VbnG+/xrJ8qVDWMHwr74NGbHYJGhT0QRct7pd8vGkaJabIvkn8VA0IUU9tEkhu/pTD
         hAvmLCRuAazaJi35tght7uFwU+8GGSCdruD/kcye3Ay7FuY2+ooRmDWWV0v3brPXDdB/
         kJFMf8PSNwsDTca1p9Qq7JDftTaQA6KhJQKRYQLDALZ38XXP86W3YIn2WbH7No2TRxu1
         KQ3tm3tIv7svtGxVD9Rdge9JL42ywFl4K7fhcYXyeSufXF6zi0x7VexUXGYYY6GnPAx5
         gqdA==
X-Gm-Message-State: AC+VfDwPld/f6BPTuNihn/kCSbnhFXMVctDFy/pZFLkCmaF4w9VUwSOi
        CpbrzifsjDtTxtBG9pchels=
X-Google-Smtp-Source: ACHHUZ74sbVH3K4eprhTZdPfGpcafMs8ZjoeuI5AiPjLNf6PINd9tDgr1XH+yEUMseq6208aHR6sFg==
X-Received: by 2002:a17:90b:1941:b0:253:5728:f631 with SMTP id nk1-20020a17090b194100b002535728f631mr13558492pjb.15.1684845662254;
        Tue, 23 May 2023 05:41:02 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id bk3-20020a17090b080300b0024e0141353dsm7421480pjb.28.2023.05.23.05.40.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 05:41:01 -0700 (PDT)
Message-ID: <de6acc7e-8e7f-2c54-11cc-822df4084719@gmail.com>
Date:   Tue, 23 May 2023 20:40:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH] KVM: x86: vPMU: truncate counter value to allowed width
Content-Language: en-US
To:     Roman Kagan <rkagan@amazon.de>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Eric Hankland <ehankland@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
References: <20230504120042.785651-1-rkagan@amazon.de>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230504120042.785651-1-rkagan@amazon.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/2023 8:00 pm, Roman Kagan wrote:
> Performance counters are defined to have width less than 64 bits.  The
> vPMU code maintains the counters in u64 variables but assumes the value
> to fit within the defined width.  However, for Intel non-full-width
> counters (MSR_IA32_PERFCTRx) the value receieved from the guest is
> truncated to 32 bits and then sign-extended to full 64 bits.  If a
> negative value is set, it's sign-extended to 64 bits, but then in
> kvm_pmu_incr_counter() it's incremented, truncated, and compared to the
> previous value for overflow detection.

Thanks for reporting this issue. An easier-to-understand fix could be:

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e17be25de6ca..51e75f121234 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -718,7 +718,7 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)

  static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
  {
-	pmc->prev_counter = pmc->counter;
+	pmc->prev_counter = pmc->counter & pmc_bitmask(pmc);
  	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
  	kvm_pmu_request_counter_reprogram(pmc);
  }

Considering that the pmu code uses pmc_bitmask(pmc) everywhere to wrap
around, I would prefer to use this fix above first and then do a more thorough
cleanup based on your below diff. What do you think ?

> That previous value is not truncated, so it always evaluates bigger than
> the truncated new one, and a PMI is injected.  If the PMI handler writes
> a negative counter value itself, the vCPU never quits the PMI loop.
> 
> Turns out that Linux PMI handler actually does write the counter with
> the value just read with RDPMC, so when no full-width support is exposed
> via MSR_IA32_PERF_CAPABILITIES, and the guest initializes the counter to
> a negative value, it locks up.

Not really sure what the behavioral difference is between "it locks up" and
"the vCPU never quits the PMI loop".

> 
> We observed this in the field, for example, when the guest configures
> atop to use perfevents and runs two instances of it simultaneously.

A more essential case I found is this:

  kvm_msr: msr_write CTR1 = 0xffffffffffffffea
  rdpmc on host: CTR1, value 0xffffffffffe3
  kvm_exit: vcpu 0 reason EXCEPTION_NMI
  kvm_msr: msr_read CTR1 = 0x83 // nmi_handler

There are two typical issues here:
- the emulated counter value changed from 0xffffffffffffffffea to 0xffffffffffffe3,
  triggering __kvm_perf_overflow(pmc, false);
- PMI-handler should not reset the counter to a value that is easily overflowed,
  in order to avoid overflow here before iret;

Please confirm whether your usage scenarios consist of these two types, or more.

> 
> To address the problem, maintain the invariant that the counter value
> always fits in the defined bit width, by truncating the received value
> in the respective set_msr methods.  For better readability, factor this
> out into a helper function, pmc_set_counter, shared by vmx and svm
> parts.
> 
> Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
> Signed-off-by: Roman Kagan <rkagan@amazon.de>

Tested-by: Like Xu <likexu@tencent.com>
I prefer to use pmc_bitmask(pmc) to wrap around pmc->prev_counter as the first step.

> ---
>   arch/x86/kvm/pmu.h           | 6 ++++++
>   arch/x86/kvm/svm/pmu.c       | 2 +-
>   arch/x86/kvm/vmx/pmu_intel.c | 4 ++--
>   3 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 5c7bbf03b599..6a91e1afef5a 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -60,6 +60,12 @@ static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
>   	return counter & pmc_bitmask(pmc);
>   }
>   
> +static inline void pmc_set_counter(struct kvm_pmc *pmc, u64 val)
> +{
> +	pmc->counter += val - pmc_read_counter(pmc);
> +	pmc->counter &= pmc_bitmask(pmc);
> +}
> +
>   static inline void pmc_release_perf_event(struct kvm_pmc *pmc)
>   {
>   	if (pmc->perf_event) {
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 5fa939e411d8..f93543d84cfe 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -151,7 +151,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	/* MSR_PERFCTRn */
>   	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
>   	if (pmc) {
> -		pmc->counter += data - pmc_read_counter(pmc);
> +		pmc_set_counter(pmc, data);
>   		pmc_update_sample_period(pmc);
>   		return 0;
>   	}
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 741efe2c497b..51354e3935d4 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -467,11 +467,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			if (!msr_info->host_initiated &&
>   			    !(msr & MSR_PMC_FULL_WIDTH_BIT))
>   				data = (s64)(s32)data;
> -			pmc->counter += data - pmc_read_counter(pmc);
> +			pmc_set_counter(pmc, data);
>   			pmc_update_sample_period(pmc);
>   			break;
>   		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
> -			pmc->counter += data - pmc_read_counter(pmc);
> +			pmc_set_counter(pmc, data);
>   			pmc_update_sample_period(pmc);
>   			break;
>   		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
