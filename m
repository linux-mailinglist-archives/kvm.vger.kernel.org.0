Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253025FE948
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 09:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJNHPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 03:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiJNHPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 03:15:06 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0C927B36;
        Fri, 14 Oct 2022 00:14:55 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y191so4148265pfb.2;
        Fri, 14 Oct 2022 00:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O1uTvZzh8RS2GyiFatdDCOZIfUcH2ah3khqENyTDbD8=;
        b=CT5TyGBbuObOvfYQz4+vbt7NRdOIo78d5sbDgKK70zuwHBLcj4eLjDqLfMhqe4uZGx
         aTxQVDUHbPk2ZuNmVtV5Symquz0zFsXSXoh2AAEwZRACnUzDg8UhztN6hzO16/yLAnsp
         mVfSRAioiOTx7gZPhkV8DtbDuakA7ngaUNzCrZ6oan5JUd2Mx4R2Uncaptk3wssq+mtS
         IZHoyRtXNhQqDCUJHe/dDRCmX9EDsC/1E+j+8a7/5TvbDBVGOVN1kOw9yqOaNbx9ZjLq
         Lhq8K9wr102zyOYPzDFx8ySFHr8UaAXdsk7HeAkaDyZUTya2qW2QnP9PB+M1WuhJXXcu
         Mz7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O1uTvZzh8RS2GyiFatdDCOZIfUcH2ah3khqENyTDbD8=;
        b=uxlynC+DOcUeb2+5Ek1q0YqZIZgMoghUapTsQewi7ccfx/Lu8ejjfyC3EOIsXAtg7p
         wNn/j3HRRm+6gLq2ZM9H3ujXqGP9xmIl864DzJm4yP5FOp/M+sEJWkxqlgwh53EnLfoH
         jaY5dnjFgdkPb2uGhEJP0S17YYiQ9o46LMOUZAZq1jikZZEYPPl1XdJID9Iv9AerPqir
         W6D0W0OHQlhsenQcGLaxHBz2Hxb/ehweGOiucpI33m/lHf8JE0Fe9mCXavwLdfphGrCW
         KseokzfRh+5jkB3Y3PEwgb68Y+8ca0B3tekQE57Y/vwZN+tzTKvI39GhuOjkgC7/uL0+
         ggkA==
X-Gm-Message-State: ACrzQf1lKGFGiKlPUtmQEIBWln1+GYT1aMuAizwKfozpusI2fc5lIXqI
        ZvZ8FDSoYrFHhXWwSwgv06oNXhmfE13FEkQx
X-Google-Smtp-Source: AMsMyM5rpnAaPmHIoqUzmfO/5//fBOf4dPQQucAL4kzQZ1t2tSfZ85asIXufiJ0i9P5BG9Q6yov2Yg==
X-Received: by 2002:a05:6a00:807:b0:563:136f:a4fe with SMTP id m7-20020a056a00080700b00563136fa4femr3709865pfk.36.1665731694593;
        Fri, 14 Oct 2022 00:14:54 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f14-20020a170902ab8e00b001783f964fe3sm981519plr.113.2022.10.14.00.14.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Oct 2022 00:14:53 -0700 (PDT)
Message-ID: <2a83292b-a4d0-8d5e-b52a-31b7fcad2de6@gmail.com>
Date:   Fri, 14 Oct 2022 15:14:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH 2/4] KVM: x86/pmu: Clear "reprogram" bit if counter is
 disabled or disallowed
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220923001355.3741194-1-seanjc@google.com>
 <20220923001355.3741194-3-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20220923001355.3741194-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For subject title, the "reprogram" bit is _only_ used to keep track of 
pmc->perf_event,
not whether the counter is disabled.

On 23/9/2022 8:13 am, Sean Christopherson wrote:
> When reprogramming a counter, clear the counter's "reprogram pending" bit
> if the counter is disabled (by the guest) or is disallowed (by the
> userspace filter).  In both cases, there's no need to re-attempt
> programming on the next coincident KVM_REQ_PMU as enabling the counter by
> either method will trigger reprogramming.

Perhaps we could move the check_pmu_event_filter() towards the top of the call 
stack.

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/pmu.c | 38 ++++++++++++++++++++++++--------------
>   1 file changed, 24 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 4504987cbbe2..4cd99320019b 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -150,9 +150,9 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
>   	__kvm_perf_overflow(pmc, true);
>   }
>   
> -static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
> -				  u64 config, bool exclude_user,
> -				  bool exclude_kernel, bool intr)
> +static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
> +				 bool exclude_user, bool exclude_kernel,
> +				 bool intr)
>   {
>   	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>   	struct perf_event *event;
> @@ -204,14 +204,14 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>   	if (IS_ERR(event)) {
>   		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
>   			    PTR_ERR(event), pmc->idx);
> -		return;
> +		return PTR_ERR(event);
>   	}
>   
>   	pmc->perf_event = event;
>   	pmc_to_pmu(pmc)->event_count++;
> -	clear_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
>   	pmc->is_paused = false;
>   	pmc->intr = intr || pebs;
> +	return 0;
>   }
>   
>   static void pmc_pause_counter(struct kvm_pmc *pmc)
> @@ -245,7 +245,6 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
>   	perf_event_enable(pmc->perf_event);
>   	pmc->is_paused = false;
>   
> -	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);

This change is very suspicious.

>   	return true;
>   }
>   
> @@ -303,10 +302,10 @@ void reprogram_counter(struct kvm_pmc *pmc)
>   	pmc_pause_counter(pmc);
>   
>   	if (!pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
> -		return;
> +		goto reprogram_complete;
>   
>   	if (!check_pmu_event_filter(pmc))
> -		return;
> +		goto reprogram_complete;
>   
>   	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
>   		printk_once("kvm pmu: pin control bit is ignored\n");
> @@ -324,16 +323,27 @@ void reprogram_counter(struct kvm_pmc *pmc)
>   	}
>   
>   	if (pmc->current_config == new_config && pmc_resume_counter(pmc))
> -		return;
> +		goto reprogram_complete;
>   
>   	pmc_release_perf_event(pmc);
>   
>   	pmc->current_config = new_config;
> -	pmc_reprogram_counter(pmc, PERF_TYPE_RAW,
> -			      (eventsel & pmu->raw_event_mask),
> -			      !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
> -			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
> -			      eventsel & ARCH_PERFMON_EVENTSEL_INT);
> +
> +	/*
> +	 * If reprogramming fails, e.g. due to contention, leave the counter's
> +	 * regprogram bit set, i.e. opportunistically try again on the next PMU

This is what we need, in the upstream case we need to keep trying regprogram
to try to occupy the hardware.

> +	 * refresh.  Don't make a new request as doing so can stall the guest
> +	 * if reprogramming repeatedly fails.

This does not happen, the guest still enters w/p perf_event backend support
and the vPMU is broken until the next vm-exit.

There is no need to endlessly call kvm_pmu_handle_event() when reprogram fails.

> +	 */
> +	if (pmc_reprogram_counter(pmc, PERF_TYPE_RAW,
> +				  (eventsel & pmu->raw_event_mask),
> +				  !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
> +				  !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
> +				  eventsel & ARCH_PERFMON_EVENTSEL_INT))
> +		return;
> +
> +reprogram_complete:
> +	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
>   }
>   EXPORT_SYMBOL_GPL(reprogram_counter);
>   
