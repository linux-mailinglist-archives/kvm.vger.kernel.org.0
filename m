Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08BC63F59F
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 17:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiLAQs0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 11:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiLAQsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 11:48:03 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33AB1C92B
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 08:47:51 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y17so2183760plp.3
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 08:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oiPlfSphC7yJwjzyONiuPHRaJCv76fAx56UNQh41g3U=;
        b=aaSEEL1+r4eJA9s7O/txHL7Xi6SeBXxCYU48kQub2FzkoNiCQgY/eKMqO5OpiGzNkd
         1fgcRFsW0Q8Eus37xwWj3KdJkf/nkdAn7deQM9A3unixyBBmCtnk4ItrX5zmkqeauV7Z
         EHSxi6t3xV9JTzBKEe6qyUH3nU5jd8scAngXmGxbO4kHLXLzwd7eMIA1U+m6io8/hlIA
         inkGF5zxjhY3WjorcUncv5WMH8ppC3yRqxudwsfmA3Vd8bdpGI39pdI3xbMqZhlJ9Dae
         qoVrUQ5fNhLvFb2qSkC+7WLtct4Cl639VfIpdiNSV+VUkVIZJmLINY9wkDpQ16j8PGnQ
         DUMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oiPlfSphC7yJwjzyONiuPHRaJCv76fAx56UNQh41g3U=;
        b=FGHRprjnVBz3BQ3ByhQ9PvNfrSVZsOSZEatxdRSvSbC9YeAezWzOoDWvRgilDXPpKh
         rgpFaVA/9scmvjzaoS6MEn6gFwyOndYCWyvGHbT0rqrT2ZBXUET+JpOTFfnAwjpArShK
         opuv+oD23W8H7M32UPxMABktsRVgzTEifLyxZRHiX3voMK1JULD4hO+Vu8JFtHXB9G9a
         FVjXgN08qlJG4xOeUcpUxIOOwVHiexRMUZ36ZP0hfAiaW7QbN7rfmFaMLdDIV829lXun
         8ZCAxplyCo8BiaOvESpauXkm0H+lHHUqCRpLuEqbYB900jrsIC2hgIJDLTEmxY6qcDIQ
         Y6Zg==
X-Gm-Message-State: ANoB5pkVP5KwySgOQjtg+v8pT2ujHWsL26dE7Bh9v+UGREP5P6FvzRON
        +Rtbb7Uj4SYdHA+fvbCJTW4kZw==
X-Google-Smtp-Source: AA0mqf53wGa2uc6DutJAhGFjA4M2t8L/aNqHRIlBg+n5iB0HMiUkSRxe6etbVweNGGfkPbg13GSeTw==
X-Received: by 2002:a17:90a:4e41:b0:218:a971:d847 with SMTP id t1-20020a17090a4e4100b00218a971d847mr56219004pjl.91.1669913271049;
        Thu, 01 Dec 2022 08:47:51 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id g6-20020a63fa46000000b0046f469a2661sm2751612pgk.27.2022.12.01.08.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:47:50 -0800 (PST)
Date:   Thu, 1 Dec 2022 08:47:47 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v4 04/16] KVM: arm64: PMU: Distinguish between 64bit
 counter and 64bit overflow
Message-ID: <Y4jasyxvFRNvvmox@google.com>
References: <20221113163832.3154370-1-maz@kernel.org>
 <20221113163832.3154370-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221113163832.3154370-5-maz@kernel.org>
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

On Sun, Nov 13, 2022 at 04:38:20PM +0000, Marc Zyngier wrote:
> The PMU architecture makes a subtle difference between a 64bit
> counter and a counter that has a 64bit overflow. This is for example
> the case of the cycle counter, which can generate an overflow on
> a 32bit boundary if PMCR_EL0.LC==0 despite the accumulation being
> done on 64 bits.
> 
> Use this distinction in the few cases where it matters in the code,
> as we will reuse this with PMUv3p5 long counters.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 43 ++++++++++++++++++++++++++++-----------
>  1 file changed, 31 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 69b67ab3c4bf..d050143326b5 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -50,6 +50,11 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
>   * @select_idx: The counter index
>   */
>  static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
> +{
> +	return (select_idx == ARMV8_PMU_CYCLE_IDX);
> +}
> +
> +static bool kvm_pmu_idx_has_64bit_overflow(struct kvm_vcpu *vcpu, u64 select_idx)
>  {
>  	return (select_idx == ARMV8_PMU_CYCLE_IDX &&
>  		__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
> @@ -57,7 +62,8 @@ static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
>  
>  static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
>  {
> -	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX);
> +	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX &&
> +		!kvm_pmu_idx_has_64bit_overflow(vcpu, idx));
>  }
>  
>  static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
> @@ -97,7 +103,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>  		counter += perf_event_read_value(pmc->perf_event, &enabled,
>  						 &running);
>  
> -	if (select_idx != ARMV8_PMU_CYCLE_IDX)
> +	if (!kvm_pmu_idx_is_64bit(vcpu, select_idx))
>  		counter = lower_32_bits(counter);
>  
>  	return counter;
> @@ -423,6 +429,23 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> +/* Compute the sample period for a given counter value */
> +static u64 compute_period(struct kvm_vcpu *vcpu, u64 select_idx, u64 counter)
> +{
> +	u64 val;
> +
> +	if (kvm_pmu_idx_is_64bit(vcpu, select_idx)) {
> +		if (!kvm_pmu_idx_has_64bit_overflow(vcpu, select_idx))
> +			val = -(counter & GENMASK(31, 0));

If I understand things correctly, this might be missing another mask:

+		if (!kvm_pmu_idx_has_64bit_overflow(vcpu, select_idx)) {
+			val = -(counter & GENMASK(31, 0));
+			val &= GENMASK(31, 0);
+		} else {

For example, if the counter is 64-bits wide, it overflows at 32-bits,
and it is _one_ sample away from overflowing at 32-bits:

	0x01010101_ffffffff

Then "val = (-counter) & GENMASK(63, 0)" would return 0xffffffff_00000001.
But the right period is 0x00000000_00000001 (it's one sample away from
overflowing).

> +		else
> +			val = (-counter) & GENMASK(63, 0);
> +	} else {
> +		val = (-counter) & GENMASK(31, 0);
> +	}
> +
> +	return val;
> +}
> +
>  /**
>   * When the perf event overflows, set the overflow status and inform the vcpu.
>   */
> @@ -442,10 +465,7 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
>  	 * Reset the sample period to the architectural limit,
>  	 * i.e. the point where the counter overflows.
>  	 */
> -	period = -(local64_read(&perf_event->count));
> -
> -	if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
> -		period &= GENMASK(31, 0);
> +	period = compute_period(vcpu, idx, local64_read(&perf_event->count));
>  
>  	local64_set(&perf_event->hw.period_left, 0);
>  	perf_event->attr.sample_period = period;
> @@ -571,14 +591,13 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  
>  	/*
>  	 * If counting with a 64bit counter, advertise it to the perf
> -	 * code, carefully dealing with the initial sample period.
> +	 * code, carefully dealing with the initial sample period
> +	 * which also depends on the overflow.
>  	 */
> -	if (kvm_pmu_idx_is_64bit(vcpu, select_idx)) {
> +	if (kvm_pmu_idx_is_64bit(vcpu, select_idx))
>  		attr.config1 |= PERF_ATTR_CFG1_COUNTER_64BIT;
> -		attr.sample_period = (-counter) & GENMASK(63, 0);
> -	} else {
> -		attr.sample_period = (-counter) & GENMASK(31, 0);
> -	}
> +
> +	attr.sample_period = compute_period(vcpu, select_idx, counter);
>  
>  	event = perf_event_create_kernel_counter(&attr, -1, current,
>  						 kvm_pmu_perf_overflow, pmc);
> -- 
> 2.34.1
> 
> 
