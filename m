Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452196AE47B
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 16:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjCGPWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 10:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjCGPVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 10:21:48 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8688B521D3
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 07:19:33 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id n5so8251824pfv.11
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 07:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678202370;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vevVskjsp2vYQ7/20gv1ygjhkkXy4Qw3NPyqQjXGImI=;
        b=jmyxt3gTuysQAvuIvbUd80cLOWoWV85XWEBuSCaVUg6j9W2s/m5O/tLryMg88MI6Sk
         A8EdKQGGfL/WkJuD2g3EgFYpvZbcgFf0DpTU4lWr9nlel97QWhlbxuUqZFt5HD8hfFQQ
         Tyd/lykMiiOCfDl21B26CNIQDrZrIe70m5Jkf3T1CgXkckQZGK+028yf4mh/DvqaYh04
         fctj78uCYMK4WyJR/YeCSxebt/RsFk6LGnqbG827SaL8w/Ba+544ce77nt3WCXufApop
         hFPbzuBVR2oajn4FkRPlmMs8K3Gg8QkwSEPU8/GD4H5p8vuAZoHTQDwa6WP2nL2r+zzC
         jH/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678202370;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vevVskjsp2vYQ7/20gv1ygjhkkXy4Qw3NPyqQjXGImI=;
        b=3gkOy5Rm9T0yGP/g7NeBhWFGtdKNnRqDgoAOPBHovr00uFmflPq9YeM6to8R/2yepd
         sbHPIx/k7Au0vJYPn39/vm/I6g9o37AqzRaXJ6hJcrfmdzzDq9WRY8Y2Qebfs0z8Vh3r
         dYq4Ckd3U+F3P9ckS4D5/5Ci+W/pW4A7VXPcCvjmUYLiU+jy+yDBpB0s8iJy6SMHAWvv
         0vxLlWvfs5twDhG4wZQ1EPq3hgnMh8ubHSToZwn3tai8WgoGfT4TCrUnXL6fjh74TW9a
         2wisjb/JFFu9CZc2/NYfr+ZZ3U95743MIbHiQR7xjl5oEJIpM6sPsx2jGGczZNC5ukfE
         VYMA==
X-Gm-Message-State: AO0yUKWpndh3Nevh3/SMIlc6x1EEhCVLeLXpGevMGRcVHQ6dU585HO3F
        5EIf0r4YC8gCMxf9XruCDr4=
X-Google-Smtp-Source: AK7set+5cupDxQTU/1VpqTFmyszy6c61Y9MaCgZuQPQnD9avzX0wctOudVesg9inRv03E+XrS33UNQ==
X-Received: by 2002:aa7:98de:0:b0:5df:3aa1:10c5 with SMTP id e30-20020aa798de000000b005df3aa110c5mr12643246pfm.14.1678202370577;
        Tue, 07 Mar 2023 07:19:30 -0800 (PST)
Received: from [127.0.0.1] ([43.153.171.238])
        by smtp.gmail.com with ESMTPSA id z19-20020aa785d3000000b005a8a4665d3bsm8023474pfn.116.2023.03.07.07.19.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 07:19:30 -0800 (PST)
Message-ID: <1c7a20c4-742c-9c42-970e-19626323e367@gmail.com>
Date:   Tue, 7 Mar 2023 23:19:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH v3 1/5] KVM: x86/pmu: Prevent the PMU from counting
 disallowed events
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kvm@vger.kernel.org
References: <20230307141400.1486314-1-aaronlewis@google.com>
 <20230307141400.1486314-2-aaronlewis@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230307141400.1486314-2-aaronlewis@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/3/7 22:13, Aaron Lewis wrote:

> When counting "Instructions Retired" (0xc0) in a guest, KVM will
> occasionally increment the PMU counter regardless of if that event is
> being filtered. This is because some PMU events are incremented via
> kvm_pmu_trigger_event(), which doesn't know about the event filter. Add
> the event filter to kvm_pmu_trigger_event(), so events that are
> disallowed do not increment their counters.
It would be nice to have:

     Reported-by: Jinrong Liang <cloudliang@tencent.com>

, since he also found the same issue.

> Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>

Reviewed-by: Like Xu <likexu@tencent.com>

> ---
>   arch/x86/kvm/pmu.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 612e6c70ce2e..9914a9027c60 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -400,6 +400,12 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
>   	return is_fixed_event_allowed(filter, pmc->idx);
>   }
>   
> +static bool event_is_allowed(struct kvm_pmc *pmc)

Nit, an inline event_is_allowed() here might be better.

> +{
> +	return pmc_is_enabled(pmc) && pmc_speculative_in_use(pmc) &&
> +	       check_pmu_event_filter(pmc);
> +}
> +
>   static void reprogram_counter(struct kvm_pmc *pmc)
>   {
>   	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> @@ -409,10 +415,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
>   
>   	pmc_pause_counter(pmc);
>   
> -	if (!pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
> -		goto reprogram_complete;
> -
> -	if (!check_pmu_event_filter(pmc))
> +	if (!event_is_allowed(pmc))
>   		goto reprogram_complete;
>   
>   	if (pmc->counter < pmc->prev_counter)
> @@ -684,7 +687,7 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
>   	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
>   		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
>   
> -		if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
> +		if (!pmc || !event_is_allowed(pmc))
>   			continue;
>   
>   		/* Ignore checks for edge detect, pin control, invert and CMASK bits */
