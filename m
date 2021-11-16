Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4646453259
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 13:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbhKPMrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 07:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbhKPMrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 07:47:00 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02714C061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 04:44:03 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id s138so9457335pgs.4
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 04:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=VyBotEnELwPTVUGa3LbnDkVaNpz8Ks+cOch1tAz1ksI=;
        b=axre/ao5Ium5t0uR7LuE0joAJEQFf+yUuprMMBM+cKpb2xg18Ohg6HFSaUdYjYkz94
         k/NR6PpcmXjVR3acBe+/lgVejnMm8jUpg0h35kWJjUFB1FK3hl4b7ZU5lBMgb77MqLoy
         a/DQYaVVN8WwbWQBoI8N8SVjnxAAMHVGCVIzHQM1BRObRIY9EymQOGRfEmuYSlj8QCWM
         OztvEjfDUUXcKeMgbvux6bDE2DfkyWkvNB/bKrCIENfNOe/VXR03FXhbcFgiT4C0JkC7
         rehHYjnWGbKaC8MQs9fw9zMARXKRNhd2aHmhdQtQPqtqFvUE/HF7ekVZTl9VgqKjoh6k
         6JBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=VyBotEnELwPTVUGa3LbnDkVaNpz8Ks+cOch1tAz1ksI=;
        b=J5Ggehpta4VjsvMdLcd/KgTUghddXceD69jaXx1kqBhqzGZjGClqs6RGYGFfZQz3J5
         pSearEKrqgCMEv4OTe6v6H6eOzJnkLiVCzsxGu4gFTJiE1xx6qL4FCbA+wn3fw9P14XQ
         Q9Tf4c5c4FXdu074en9bOClH9rJG7JvdI5eT5c9n3EypEQh9mlsj482T3I+xNqBax6vl
         jKv4W42v8ICgKnAdhpbU96hEotnayHfu1ToUCrCrbcIO//5Pqc4ACcEDo+m+U29/N/f7
         mPZA34SCkH0P8sgLzhhC3vYyme9J5pHx5HHFfJ6birYkO23uXg1qGI+0/IvuATBU/YM7
         tImg==
X-Gm-Message-State: AOAM531baDS/E0pju86VYZQa7FzbMPM/TKgdHH6tYi3H6hPgArucEhoE
        6iZmsK0+gwSzdiNtPgocEuw=
X-Google-Smtp-Source: ABdhPJzxxYfGB7hBue01JxPaEKsCS9r1MADkZxEb2gO9JI6GCPbc1Ox0VyyI1eESr13pSVyAq0UcfQ==
X-Received: by 2002:a62:2503:0:b0:4a2:b772:25ac with SMTP id l3-20020a622503000000b004a2b77225acmr16530641pfl.53.1637066642511;
        Tue, 16 Nov 2021 04:44:02 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f130sm19133398pfa.81.2021.11.16.04.43.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 04:44:02 -0800 (PST)
Message-ID: <fcb9aea5-2cf5-897f-5a3d-054ead555da4@gmail.com>
Date:   Tue, 16 Nov 2021 20:43:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Eric Hankland <ehankland@google.com>, kvm@vger.kernel.org,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org)" 
        <pbonzini@redhat.com>
References: <20211112235235.1125060-1-jmattson@google.com>
 <20211112235235.1125060-2-jmattson@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH 1/2] KVM: x86: Update vPMCs when retiring instructions
In-Reply-To: <20211112235235.1125060-2-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jim,

On 13/11/2021 7:52 am, Jim Mattson wrote:
> When KVM retires a guest instruction through emulation, increment any
> vPMCs that are configured to monitor "instructions retired," and
> update the sample period of those counters so that they will overflow
> at the right time.
> 
> Signed-off-by: Eric Hankland <ehankland@google.com>
> [jmattson:
>    - Split the code to increment "branch instructions retired" into a
>      separate commit.
>    - Added 'static' to kvm_pmu_incr_counter() definition.
>    - Modified kvm_pmu_incr_counter() to check pmc->perf_event->state ==
>      PERF_EVENT_STATE_ACTIVE.
> ]
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
> ---
>   arch/x86/kvm/pmu.c | 31 +++++++++++++++++++++++++++++++
>   arch/x86/kvm/pmu.h |  1 +
>   arch/x86/kvm/x86.c |  3 +++
>   3 files changed, 35 insertions(+)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 09873f6488f7..153c488032a5 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -490,6 +490,37 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
>   	kvm_pmu_reset(vcpu);
>   }
>   
> +static void kvm_pmu_incr_counter(struct kvm_pmc *pmc, u64 evt)
> +{
> +	u64 counter_value, sample_period;
> +
> +	if (pmc->perf_event &&

We need to incr pmc->counter whether it has a perf_event or not.

> +	    pmc->perf_event->attr.type == PERF_TYPE_HARDWARE &&

We need to cover PERF_TYPE_RAW as well, for example,
it has the basic bits for "{ 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },"
plus HSW_IN_TX or ARCH_PERFMON_EVENTSEL_EDGE stuff.

We just need to focus on checking the select and umask bits:

static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
	unsigned int perf_hw_id)
{
	u64 old_eventsel = pmc->eventsel;
	unsigned int config;

	pmc->eventsel &=
		(ARCH_PERFMON_EVENTSEL_EVENT | ARCH_PERFMON_EVENTSEL_UMASK);
	config = kvm_x86_ops.pmu_ops->find_perf_hw_id(pmc);
	pmc->eventsel = old_eventsel;
	return config == perf_hw_id;
}

> +	    pmc->perf_event->state == PERF_EVENT_STATE_ACTIVE &&

Again, we should not care the pmc->perf_event.

> +	    pmc->perf_event->attr.config == evt) {

So how about the emulated instructions for
ARCH_PERFMON_EVENTSEL_USR and ARCH_PERFMON_EVENTSEL_USR ?

> +		pmc->counter++;
> +		counter_value = pmc_read_counter(pmc);
> +		sample_period = get_sample_period(pmc, counter_value);
> +		if (!counter_value)
> +			perf_event_overflow(pmc->perf_event, NULL, NULL);

We need to call kvm_perf_overflow() or kvm_perf_overflow_intr().
And the patch set doesn't export the perf_event_overflow() SYMBOL.

> +		if (local64_read(&pmc->perf_event->hw.period_left) >
> +		    sample_period)
> +			perf_event_period(pmc->perf_event, sample_period);
> +	}
> +}

Not cc PeterZ or perf reviewers for this part of code is not a good thing.

How about this:

static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
{
	struct kvm_pmu *pmu = pmc_to_pmu(pmc);

	pmc->counter++;
	reprogram_counter(pmu, pmc->idx);
	if (!pmc_read_counter(pmc))
		// https://lore.kernel.org/kvm/20211116122030.4698-1-likexu@tencent.com/T/#t
		kvm_pmu_counter_overflow(pmc, need_overflow_intr(pmc));
}

> +
> +void kvm_pmu_record_event(struct kvm_vcpu *vcpu, u64 evt)

s/kvm_pmu_record_event/kvm_pmu_trigger_event/

> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	int i;
> +
> +	for (i = 0; i < pmu->nr_arch_gp_counters; i++)
> +		kvm_pmu_incr_counter(&pmu->gp_counters[i], evt);

Why do we need to accumulate a counter that is not enabled at all ?

> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
> +		kvm_pmu_incr_counter(&pmu->fixed_counters[i], evt);

How about this:

	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, i);

		if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
			continue;

		// https://lore.kernel.org/kvm/20211116122030.4698-1-likexu@tencent.com/T/#t
		if (eventsel_match_perf_hw_id(pmc, perf_hw_id))
			kvm_pmu_incr_counter(pmc);
	}

> +}
> +EXPORT_SYMBOL_GPL(kvm_pmu_record_event);
> +
>   int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>   {
>   	struct kvm_pmu_event_filter tmp, *filter;
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 59d6b76203d5..d1dd2294f8fb 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -159,6 +159,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu);
>   void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
>   void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
>   int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
> +void kvm_pmu_record_event(struct kvm_vcpu *vcpu, u64 evt);
>   
>   bool is_vmware_backdoor_pmc(u32 pmc_idx);
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d7def720227d..bd49e2a204d5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7854,6 +7854,8 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
>   	if (unlikely(!r))
>   		return 0;
>   
> +	kvm_pmu_record_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
> +
>   	/*
>   	 * rflags is the old, "raw" value of the flags.  The new value has
>   	 * not been saved yet.
> @@ -8101,6 +8103,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
>   		if (!ctxt->have_exception ||
>   		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
> +			kvm_pmu_record_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
>   			kvm_rip_write(vcpu, ctxt->eip);
>   			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
>   				r = kvm_vcpu_do_singlestep(vcpu);
> 
