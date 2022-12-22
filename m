Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDD7653C1C
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 07:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbiLVGTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 01:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235068AbiLVGTU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 01:19:20 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B0E639A
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 22:19:19 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so905460pjm.2
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 22:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uSQJp3c40T4fZk8/DCzTgVC9RtoHPQk5yC/bARRlKoA=;
        b=WfM89LTEK3i+PhXwL56ijGBXSSryZivNFfoc/MehuAtY4NC0w+CPDFvm5ZJNdTEDS6
         6nfvQeqwnKZ8NJflo3QgTLJh9+ZDJQ4anHM2kC1dZ8AjJ89SaOEKv2xZiOXjj7P9sgfa
         zB+0uvKveEZulAU6x3G3E1CgRxfux2WmACIRLv+77AbhnmctLELTNVgsMy00kYMYGhRw
         niUu+5kdMLfxVSo0jiVGmUXIvIYomUSFOaVOSZUKafkrR/1xkYS0+hDr9ntr7GrHpCYL
         rjAWRt6CjLss/2PE+R5g7bI5fhPiGs7X8SlesiT5bncvzX3zMwyua4RLgiHaNoitY/qd
         e31Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uSQJp3c40T4fZk8/DCzTgVC9RtoHPQk5yC/bARRlKoA=;
        b=VrIcMhJdv/Zp9FLW1SRt53NakvJSt4Tua5ZrDPkdii4n9Z2OLOf/UT8HSOMaqWYwdQ
         2Q43MIZGgq4ErRhkelt/FPTce+nnV6mj7RAH6+M/Fk0VgkHpI3Zrf5P+SfFDsPLY11qO
         9hJ7AYcEi/axq/G/yfssZJDihGTwzEhbanAtGuawjQnx9a1+G86i54BBUGaWlNU6u4Js
         Kdv/jM09IIzxF1iF5PpyFSEMeI82wZKn8B+Hzi/EsEu3/3IZHIm5rqo03m4sFMld7QPq
         z35LnB/t4hqJDFDtQ/c+xgDrn0MtXfoOsJN69f52zwgDI+nJq+EDuy2O7LLEuDPCssez
         Kk/w==
X-Gm-Message-State: AFqh2kqgHTZpfNRvuL5FzzrM50ZmxUUzOAUNjuy0BegyrgKK+SR2+mlc
        ao4UTuUzXyYoWSvCmYTME9s=
X-Google-Smtp-Source: AMrXdXuFanj7Rtkp0ahgxL6swgH6UgHZJ8lLqp0jzTv1kgbRxlGmhVzFKmk275nAXJm1CUQCydWdrg==
X-Received: by 2002:a17:90a:cb16:b0:225:b36b:caef with SMTP id z22-20020a17090acb1600b00225b36bcaefmr1361194pjt.23.1671689958786;
        Wed, 21 Dec 2022 22:19:18 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id o8-20020a17090ad24800b00218daa55e5fsm710603pjw.12.2022.12.21.22.19.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 22:19:18 -0800 (PST)
Message-ID: <37064a64-47cb-aaad-4b8e-6ce2bdf68e56@gmail.com>
Date:   Thu, 22 Dec 2022 14:19:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH v8 1/7] kvm: x86/pmu: Correct the mask used in a pmu event
 filter lookup
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kvm list <kvm@vger.kernel.org>
References: <20221220161236.555143-1-aaronlewis@google.com>
 <20221220161236.555143-2-aaronlewis@google.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221220161236.555143-2-aaronlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/12/2022 12:12 am, Aaron Lewis wrote:
> When checking if a pmu event the guest is attempting to program should
> be filtered, only consider the event select + unit mask in that
> decision. Use an architecture specific mask to mask out all other bits,
> including bits 35:32 on Intel.  Those bits are not part of the event
> select and should not be considered in that decision.
> 
> Fixes: 66bb8a065f5a ("KVM: x86: PMU Event Filter")
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>   arch/x86/kvm/pmu.c           | 3 ++-
>   arch/x86/kvm/pmu.h           | 2 ++
>   arch/x86/kvm/svm/pmu.c       | 1 +
>   arch/x86/kvm/vmx/pmu_intel.c | 1 +
>   4 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 684393c22105..760a09ff65cd 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -277,7 +277,8 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>   		goto out;
>   
>   	if (pmc_is_gp(pmc)) {
> -		key = pmc->eventsel & AMD64_RAW_EVENT_MASK_NB;
> +		key = pmc->eventsel & (kvm_pmu_ops.EVENTSEL_EVENT |
> +				       ARCH_PERFMON_EVENTSEL_UMASK);
>   		if (bsearch(&key, filter->events, filter->nevents,
>   			    sizeof(__u64), cmp_u64))
>   			allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 85ff3c0588ba..5b070c563a97 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -40,6 +40,8 @@ struct kvm_pmu_ops {
>   	void (*reset)(struct kvm_vcpu *vcpu);
>   	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
>   	void (*cleanup)(struct kvm_vcpu *vcpu);
> +
> +	const u64 EVENTSEL_EVENT;

Isn't it weird when the new thing added here is
not of the same type as the existing members ?

Doesn't "pmu->raw_event_mask" help here ?

>   };
>   
>   void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 0e313fbae055..d3ae261d56a6 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -229,4 +229,5 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
>   	.refresh = amd_pmu_refresh,
>   	.init = amd_pmu_init,
>   	.reset = amd_pmu_reset,
> +	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
>   };
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index e5cec07ca8d9..edf23115f2ef 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -810,4 +810,5 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
>   	.reset = intel_pmu_reset,
>   	.deliver_pmi = intel_pmu_deliver_pmi,
>   	.cleanup = intel_pmu_cleanup,
> +	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
>   };
