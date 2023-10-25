Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013FD7D6073
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 05:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbjJYDRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 23:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbjJYDRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 23:17:32 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9078182;
        Tue, 24 Oct 2023 20:17:28 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d2e1a72fcca58-6b9af7d41d2so4477307b3a.0;
        Tue, 24 Oct 2023 20:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698203848; x=1698808648; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSBC2EEzIFGKkcvVEZdun9j4nAtpxrzV4OlXixgyLsk=;
        b=Q010FynxLVxIlNPE/0gmFnT7sNDDWPb5IElqDHbSInlUK1hfNqMTy5dMdJaum9yVF1
         05ZEDnuKyb+f/i8bLpc/3D1GdE2fSCGGTs72XSvIKnGYO1UI5TF1u/zEzvwnov1h6pxt
         f8Og91Wj2F/GbajAjHRXOcIJet+RwpLPt80ydyAC781nfq58fhtAcZ0LhBG/Lf6N3HdJ
         pqL/eVhQac3Kyb+uQanTEF1zIA/LJrmK8dzskrYEJlACiDxutO8QCTe0SS89stpWpiR3
         +IL8+LARYNBGqovVt66tuo1EOjyNgdJJLl6YFGlp0bwd4jDJvcpGDTdNroVc7hg6eu3D
         3oIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698203848; x=1698808648;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lSBC2EEzIFGKkcvVEZdun9j4nAtpxrzV4OlXixgyLsk=;
        b=gROrsmy7K7kuZS8BDJTjKcO/ltcOm4uiol6Ja6tjj/QmAjQOqz/YDysYza38bDZmky
         C4Lol65qaIyuBSI4RWMqySA6dRnLmVTAaMILL6nMu4ih94pYq2Q4tkWGLSPtY4ygtWJD
         YLGmKhbulLbloGPcuqWfQxKCHAfe72w9V1kO3CH0kXPX3PMbcBemMiX0a2usA58CP72J
         655lCs/K5P2fMqBx2DJRAvfV6nl999vugb4Ec7l8C6mluCtG+08vWPx+R76N3srYxMvR
         lCwNUzdT6zSkzdeC2IXMY87H6sWCRgFaJGRyBjMLBAbhtVdF075Vs92gu5829XDIipsd
         hAQw==
X-Gm-Message-State: AOJu0Yx8hnGt7NSmRdpyXBRqAltCoaIPBcF4fL3Uf81INrMRM/FiN/xR
        KuHAWnCr9IgrRHwMFt4ceAA=
X-Google-Smtp-Source: AGHT+IG+PXQD+0Twc4cI6VT/NKbF/ORrJ8UovTK4yPuAQgl8aQYuGXR8hZ8Egak4wTQo4i6VCvlQJw==
X-Received: by 2002:a62:f24c:0:b0:690:d620:7801 with SMTP id y12-20020a62f24c000000b00690d6207801mr9777229pfl.11.1698203847897;
        Tue, 24 Oct 2023 20:17:27 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z4-20020aa79904000000b006b6f3bc8123sm8284926pff.50.2023.10.24.20.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 20:17:27 -0700 (PDT)
Message-ID: <f10b1eb8-db53-42e4-85ba-f38560724ae1@gmail.com>
Date:   Wed, 25 Oct 2023 11:17:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: [PATCH v5 08/13] KVM: selftests: Test Intel PMU architectural
 events on gp counters
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>
References: <20231024002633.2540714-1-seanjc@google.com>
 <20231024002633.2540714-9-seanjc@google.com> <ZTgf1Cutah5VQp_q@google.com>
From:   JinrongLiang <ljr.kernel@gmail.com>
In-Reply-To: <ZTgf1Cutah5VQp_q@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

在 2023/10/25 03:49, Sean Christopherson 写道:
> On Mon, Oct 23, 2023, Sean Christopherson wrote:
>> +static void guest_measure_pmu_v1(struct kvm_x86_pmu_feature event,
>> +				 uint32_t counter_msr, uint32_t nr_gp_counters)
>> +{
>> +	uint8_t idx = event.f.bit;
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < nr_gp_counters; i++) {
>> +		wrmsr(counter_msr + i, 0);
>> +		wrmsr(MSR_P6_EVNTSEL0 + i, ARCH_PERFMON_EVENTSEL_OS |
>> +		      ARCH_PERFMON_EVENTSEL_ENABLE | intel_pmu_arch_events[idx]);
>> +		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
>> +
>> +		if (pmu_is_intel_event_stable(idx))
>> +			GUEST_ASSERT_EQ(this_pmu_has(event), !!_rdpmc(i));
>> +
>> +		wrmsr(MSR_P6_EVNTSEL0 + i, ARCH_PERFMON_EVENTSEL_OS |
>> +		      !ARCH_PERFMON_EVENTSEL_ENABLE |
>> +		      intel_pmu_arch_events[idx]);
>> +		wrmsr(counter_msr + i, 0);
>> +		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
>> +
>> +		if (pmu_is_intel_event_stable(idx))
>> +			GUEST_ASSERT(!_rdpmc(i));
>> +	}
>> +
>> +	GUEST_DONE();
>> +}
>> +
>> +static void guest_measure_loop(uint8_t idx)
>> +{
>> +	const struct {
>> +		struct kvm_x86_pmu_feature gp_event;
>> +	} intel_event_to_feature[] = {
>> +		[INTEL_ARCH_CPU_CYCLES]		   = { X86_PMU_FEATURE_CPU_CYCLES },
>> +		[INTEL_ARCH_INSTRUCTIONS_RETIRED]  = { X86_PMU_FEATURE_INSNS_RETIRED },
>> +		[INTEL_ARCH_REFERENCE_CYCLES]	   = { X86_PMU_FEATURE_REFERENCE_CYCLES },
>> +		[INTEL_ARCH_LLC_REFERENCES]	   = { X86_PMU_FEATURE_LLC_REFERENCES },
>> +		[INTEL_ARCH_LLC_MISSES]		   = { X86_PMU_FEATURE_LLC_MISSES },
>> +		[INTEL_ARCH_BRANCHES_RETIRED]	   = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED },
>> +		[INTEL_ARCH_BRANCHES_MISPREDICTED] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED },
>> +	};
>> +
>> +	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
>> +	uint32_t pmu_version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
>> +	struct kvm_x86_pmu_feature gp_event;
>> +	uint32_t counter_msr;
>> +	unsigned int i;
>> +
>> +	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
>> +		counter_msr = MSR_IA32_PMC0;
>> +	else
>> +		counter_msr = MSR_IA32_PERFCTR0;
>> +
>> +	gp_event = intel_event_to_feature[idx].gp_event;
>> +	TEST_ASSERT_EQ(idx, gp_event.f.bit);
>> +
>> +	if (pmu_version < 2) {
>> +		guest_measure_pmu_v1(gp_event, counter_msr, nr_gp_counters);
> 
> Looking at this again, testing guest PMU version 1 is practically impossible
> because this testcase doesn't force the guest PMU version.  I.e. unless I'm
> missing something, this requires old hardware or running in a VM with its PMU
> forced to '1'.
> 
> And if all subtests use similar inputs, the common configuration can be shoved
> into pmu_vm_create_with_one_vcpu().
> 
> It's easy enough to fold test_intel_arch_events() into test_intel_counters(),
> which will also provide coverage for running with full-width writes enabled.  The
> only downside is that the total runtime will be longer.
> 
>> +static void test_arch_events_cpuid(uint8_t i, uint8_t j, uint8_t idx)
>> +{
>> +	uint8_t arch_events_unavailable_mask = BIT_ULL(j);
>> +	uint8_t arch_events_bitmap_size = BIT_ULL(i);
>> +	struct kvm_vcpu *vcpu;
>> +	struct kvm_vm *vm;
>> +
>> +	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_measure_loop);
>> +
>> +	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH,
>> +				arch_events_bitmap_size);
>> +	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_EVENTS_MASK,
>> +				arch_events_unavailable_mask);
>> +
>> +	vcpu_args_set(vcpu, 1, idx);
>> +
>> +	run_vcpu(vcpu);
>> +
>> +	kvm_vm_free(vm);
>> +}
>> +
>> +static void test_intel_arch_events(void)
>> +{
>> +	uint8_t idx, i, j;
>> +
>> +	for (idx = 0; idx < NR_INTEL_ARCH_EVENTS; idx++) {
> 
> There's no need to iterate over each event in the host, we can simply add a wrapper
> for guest_measure_loop() in the guest.  That'll be slightly faster since it won't
> require creating and destroying a VM for every event.
> 
>> +		/*
>> +		 * A brute force iteration of all combinations of values is
>> +		 * likely to exhaust the limit of the single-threaded thread
>> +		 * fd nums, so it's test by iterating through all valid
>> +		 * single-bit values.
>> +		 */
>> +		for (i = 0; i < NR_INTEL_ARCH_EVENTS; i++) {
> 
> This is flawed/odd.  'i' becomes arch_events_bitmap_size, i.e. it's a length,
> but the length is computed byt BIT(i).  That's nonsensical and will eventually
> result in undefined behavior.  Oof, that'll actually happen sooner than later
> because arch_events_bitmap_size is only a single byte, i.e. when the number of
> events hits 9, this will try to shove 256 into an 8-bit variable.
> 
> The more correct approach would be to pass in 0..NR_INTEL_ARCH_EVENTS inclusive
> as the size.  But I think we should actually test 0..length+1, where "length" is
> the max of the native length and NR_INTEL_ARCH_EVENTS, i.e. we should verify KVM
> KVM handles a size larger than the native length.
> 
>> +			for (j = 0; j < NR_INTEL_ARCH_EVENTS; j++)
>> +				test_arch_events_cpuid(i, j, idx);
> 
> And here, I think it makes sense to brute force all possible values for at least
> one configuration.  There aren't actually _that_ many values, e.g. currently it's
> 64 (I think).  E.g. test the native PMU version with the "full" length, and then
> test single bits with varying lengths.
> 
> I'll send a v6 later this week.

Got it, thanks.

Please feel free to let me know if there's anything you'd like me to do.
