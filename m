Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107F47D4F93
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 14:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjJXMPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 08:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjJXLlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 07:41:00 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28635128;
        Tue, 24 Oct 2023 04:40:58 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d9443c01a7336-1ca816f868fso27939765ad.1;
        Tue, 24 Oct 2023 04:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698147657; x=1698752457; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5viv4icoi216uHnGHO1LdrBrwyZJtbpFGI9zPwr27r8=;
        b=cEcs9CF2mSDyFfdHoVimws4ymF4InGv3XolYfQgmd61tLIiHV4eA+gntxY/1r/bM3j
         SNJCsHvkh4VUehT4kGpIMkDXv7U/fTnZ25UCHCS8V15d+LeTV9CpdBQVUcCpTlLguf79
         21Exrq1AhIwHfDdo1Z77CVhzZs/I0BnP915fpeOV3UnmzhipadxD9gBvqjVv2tRN0OZT
         x7z0MF2PveeaMWOjwD/5iletT1dlRm90CGGCwQwHJVXx5n2q6cVRtFYuz4lUARkPJavd
         bsQdgHGq8kBXQiS6zFs8w76kUOTgdXNrDucYEHV9yP6cb2Bv6x5z1AOak1aSvKg2DrXv
         BylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698147657; x=1698752457;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5viv4icoi216uHnGHO1LdrBrwyZJtbpFGI9zPwr27r8=;
        b=KzFrlsDHwpiFwBsE0FG0kGrxqLoqB79JChelTTkQPsmYOPs/BPT6Wsu4HzQFUc3lHz
         u73TMxkwqhfe1Ewc1l5+pRkqKT3u3yVApA88hm3JL0vdVjG5xLMzDtVEnMOGoDJd/Zhd
         e9mVCzpbI2feFr0xOsPjNW6EPkLTxFS4dPvSkqXwSvtaxP0Nxjr1KysdHJqrNS5QrKHJ
         ME7CSd353nua0W2vd0IV0ynHaORz3QYogZvL6LEWg53p5wqz/JFAgACqkccSgs9UOofE
         Js4tP0KnXJpYuAaHkvWTEZDx7kBKfM/TUrlFiUy0Ae2qvMAGp4tS1gNFCEvaATajf7N8
         Oldw==
X-Gm-Message-State: AOJu0Yx2dFvlJEPLndrFeCHD+pcKnYroTKgsrKnvvPDshAIeQWcnW04c
        uBZTHuOMHvKgDQLEahSEDF0=
X-Google-Smtp-Source: AGHT+IHyfLJ8xGwyttzAqlikW6bhql9g45kc1vXlEUwmN3Lg1dicfzOvSTjmUM3LoOtfYwW0VUBtDA==
X-Received: by 2002:a17:902:f94d:b0:1b5:561a:5ca9 with SMTP id kx13-20020a170902f94d00b001b5561a5ca9mr8645873plb.50.1698147657433;
        Tue, 24 Oct 2023 04:40:57 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id l11-20020a170903244b00b001c73f3a9b7fsm7212593pls.185.2023.10.24.04.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 04:40:57 -0700 (PDT)
Message-ID: <957b598d-c2bc-4568-2f36-a4ae762b49a8@gmail.com>
Date:   Tue, 24 Oct 2023 19:40:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: [PATCH v5 11/13] KVM: selftests: Test consistency of CPUID with
 num of fixed counters
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>
References: <20231024002633.2540714-1-seanjc@google.com>
 <20231024002633.2540714-12-seanjc@google.com>
From:   JinrongLiang <ljr.kernel@gmail.com>
In-Reply-To: <20231024002633.2540714-12-seanjc@google.com>
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

在 2023/10/24 08:26, Sean Christopherson 写道:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> Extend the PMU counters test to verify KVM emulation of fixed counters in
> addition to general purpose counters.  Fixed counters add an extra wrinkle
> in the form of an extra supported bitmask.  Thus quoth the SDM:
> 
>    fixed-function performance counter 'i' is supported if ECX[i] || (EDX[4:0] > i)
> 
> Test that KVM handles a counter being available through either method.
> 
> Co-developed-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   .../selftests/kvm/x86_64/pmu_counters_test.c  | 58 ++++++++++++++++++-
>   1 file changed, 55 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> index 274b7f4d4b53..f1d9cdd69a17 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> @@ -227,13 +227,19 @@ __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
>   	       expect_gp ? "#GP" : "no fault", msr, vector)			\
>   
>   static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
> -				 uint8_t nr_counters)
> +				 uint8_t nr_counters, uint32_t or_mask)
>   {
>   	uint8_t i;
>   
>   	for (i = 0; i < nr_possible_counters; i++) {
>   		const uint32_t msr = base_msr + i;
> -		const bool expect_success = i < nr_counters;
> +
> +		/*
> +		 * Fixed counters are supported if the counter is less than the
> +		 * number of enumerated contiguous counters *or* the counter is
> +		 * explicitly enumerated in the supported counters mask.
> +		 */
> +		const bool expect_success = i < nr_counters || (or_mask & BIT(i));
>   
>   		/*
>   		 * KVM drops writes to MSR_P6_PERFCTR[0|1] if the counters are
> @@ -273,7 +279,7 @@ static void guest_test_gp_counters(void)
>   	else
>   		base_msr = MSR_IA32_PERFCTR0;
>   
> -	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters);
> +	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters, 0);
>   }
>   
>   static void test_gp_counters(uint8_t nr_gp_counters, uint64_t perf_cap)
> @@ -292,10 +298,51 @@ static void test_gp_counters(uint8_t nr_gp_counters, uint64_t perf_cap)
>   	kvm_vm_free(vm);
>   }
>   
> +static void guest_test_fixed_counters(void)
> +{
> +	uint64_t supported_bitmask = 0;
> +	uint8_t nr_fixed_counters = 0;
> +
> +	/* KVM provides fixed counters iff the vPMU version is 2+. */

s/iff/if/

> +	if (this_cpu_property(X86_PROPERTY_PMU_VERSION) >= 2)
> +		nr_fixed_counters = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
> +
> +	/*
> +	 * The supported bitmask for fixed counters was introduced in PMU
> +	 * version 5.
> +	 */
> +	if (this_cpu_property(X86_PROPERTY_PMU_VERSION) >= 5)
> +		supported_bitmask = this_cpu_property(X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK);
> +
> +	guest_rd_wr_counters(MSR_CORE_PERF_FIXED_CTR0, MAX_NR_FIXED_COUNTERS,
> +			     nr_fixed_counters, supported_bitmask);
> +}
> +
> +static void test_fixed_counters(uint8_t nr_fixed_counters,
> +				uint32_t supported_bitmask, uint64_t perf_cap)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +
> +	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_fixed_counters);
> +
> +	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK,
> +				supported_bitmask);
> +	vcpu_set_cpuid_property(vcpu, X86_PROPERTY_PMU_NR_FIXED_COUNTERS,
> +				nr_fixed_counters);
> +	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, perf_cap);
> +
> +	run_vcpu(vcpu);
> +
> +	kvm_vm_free(vm);
> +}
> +
>   static void test_intel_counters(void)
>   {
> +	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
>   	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
>   	unsigned int i;
> +	uint32_t k;
>   	uint8_t j;
>   
>   	const uint64_t perf_caps[] = {
> @@ -306,6 +353,11 @@ static void test_intel_counters(void)
>   	for (i = 0; i < ARRAY_SIZE(perf_caps); i++) {
>   		for (j = 0; j <= nr_gp_counters; j++)
>   			test_gp_counters(j, perf_caps[i]);
> +
> +		for (j = 0; j <= nr_fixed_counters; j++) {
> +			for (k = 0; k <= (BIT(nr_fixed_counters) - 1); k++)
> +				test_fixed_counters(j, k, perf_caps[i]);
> +		}
>   	}
>   }
>   

