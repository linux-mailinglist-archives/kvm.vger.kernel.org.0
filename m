Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BD27D4F30
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 13:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbjJXLth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 07:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjJXLtf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 07:49:35 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E5C10C0;
        Tue, 24 Oct 2023 04:49:33 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d9443c01a7336-1caad0bcc95so28113585ad.0;
        Tue, 24 Oct 2023 04:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698148172; x=1698752972; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z8zV5ejqtDym1yaTbxvSGO16pMXM/nARyLzYToDOMes=;
        b=Bkgz3fadMHmfJkpxK4qEJxpKplZxvX6Gn9JDGYv1KDKpru+zIlan7l7RUZHNAA/ogK
         69Ekhk6bmdwixupUEysn1XPwXs6Tb1OGHVblyPLAg35/a31rf4BaV9IfV3NkXrMovr6r
         BK5/F6m/6l9qkgz6fPg4Zd/7tF/LGAYFnL7mkBY+CmjPGf9Bviqbn6nBNq8RdVe2UzTO
         nmrHNgNEz/N8NRSgxVJUjxdGqTxaSt7DEg6kcqZW8nlIH5/hSlLbuWHAw6qGbE0ZNghC
         KgOkqJE08ZQX1p7C+KjLr0u5Eox3RGwp5kN5JR4Pfy17eR7KynOFTV0JgC1+2dFsxrEf
         YWfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698148172; x=1698752972;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Z8zV5ejqtDym1yaTbxvSGO16pMXM/nARyLzYToDOMes=;
        b=oEMT6qbHh6RA/CpOMcmv7fFLxI2TO12gPmMmFUUAqu2DkDMkPUAvx4QUJA+AR1D0fI
         /8QGv9YRjQf2m75kCTBzNo+4cq03uaK1oB5W4dJ5Rh8FzKkCT176AVpao3W843ATFKWn
         CsALG2bO9jSUvPvuKpQhWxvXX8xxzoiDC/E+qog04g1fIqgUmIaBTGiiAhQ/moc3/Sof
         QB//vi6t7/PJ9U3zp6YPGl4hnRvnUeGMJKAAfmWXuCDXnA4ccVTh//iFMSXVlst3sNz6
         rUIJxSoWUAlI82g6Yq5XPndlClvMZf9nZIalA2IhvsG2TrSx/aMqguHBOaPkFwfZayUc
         D6iQ==
X-Gm-Message-State: AOJu0Yz7EzWO7ZSJXfpjaGX5vv3s0UGk54sVg7rVh34F4AITOPc3Y/5P
        OUAQVKcX3QM9ZJbXRCfUsY0=
X-Google-Smtp-Source: AGHT+IF9SkfYm1waSx3W6WvcHav5gcUFBHbIxmbU8PDu9PZ5VgAUAbhVg1bek6dL9K3ZLLunhl6g8g==
X-Received: by 2002:a17:902:eccb:b0:1c9:ba18:785c with SMTP id a11-20020a170902eccb00b001c9ba18785cmr12037631plh.25.1698148172374;
        Tue, 24 Oct 2023 04:49:32 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u17-20020a170902e5d100b001b89a6164desm7284411plf.118.2023.10.24.04.49.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 04:49:31 -0700 (PDT)
Message-ID: <58bcee35-7573-7ea8-18f3-de741e3e7b9b@gmail.com>
Date:   Tue, 24 Oct 2023 19:49:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: [PATCH v5 13/13] KVM: selftests: Extend PMU counters test to
 permute on vPMU version
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>
References: <20231024002633.2540714-1-seanjc@google.com>
 <20231024002633.2540714-14-seanjc@google.com>
From:   JinrongLiang <ljr.kernel@gmail.com>
In-Reply-To: <20231024002633.2540714-14-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

在 2023/10/24 08:26, Sean Christopherson 写道:
> Extent the PMU counters test to verify that KVM emulates the vPMU (or
> not) according to the vPMU version exposed to the guest.  KVM's ABI (which
> does NOT reflect Intel's architectural behavior) is that GP counters are
> available if the PMU version is >0, and that fixed counters and
> PERF_GLOBAL_CTRL are available if the PMU version is >1.
> 
> Test up to vPMU version 5, i.e. the current architectural max.  KVM only
> officially supports up to version 2, but the behavior of the counters is
> backwards compatible, i.e. KVM shouldn't do something completely different
> for a higher, architecturally-defined vPMU version.
> 
> Verify KVM behavior against the effective vPMU version, e.g. advertising
> vPMU 5 when KVM only supports vPMU 2 shouldn't magically unlock vPMU 5
> features.
> 
> Suggested-by: Like Xu <likexu@tencent.com>
> Suggested-by: Jinrong Liang <cloudliang@tencent.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   .../selftests/kvm/x86_64/pmu_counters_test.c  | 60 +++++++++++++++----
>   1 file changed, 47 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> index 1c392ad156f4..85b01dd5b2cd 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> @@ -12,6 +12,8 @@
>   /* Guest payload for any performance counter counting */
>   #define NUM_BRANCHES		10
>   
> +static uint8_t kvm_pmu_version;
> +
>   static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
>   						  void *guest_code)
>   {
> @@ -21,6 +23,8 @@ static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
>   	vm_init_descriptor_tables(vm);
>   	vcpu_init_descriptor_tables(*vcpu);
>   
> +	sync_global_to_guest(vm, kvm_pmu_version);
> +
>   	return vm;
>   }
>   
> @@ -97,6 +101,19 @@ static bool pmu_is_null_feature(struct kvm_x86_pmu_feature event)
>   	return !(*(u64 *)&event);
>   }
>   
> +static uint8_t guest_get_pmu_version(void)
> +{
> +	/*
> +	 * Return the effective PMU version, i.e. the minimum between what KVM
> +	 * supports and what is enumerated to the guest.  The counters test
> +	 * deliberately advertises a PMU version to the guest beyond what is
> +	 * actually supported by KVM to verify KVM doesn't freak out and do
> +	 * something bizarre with an architecturally valid, but unsupported,
> +	 * version.
> +	 */
> +	return min_t(uint8_t, kvm_pmu_version, this_cpu_property(X86_PROPERTY_PMU_VERSION));
> +}
> +
>   static void guest_measure_loop(uint8_t idx)
>   {
>   	const struct {
> @@ -121,7 +138,7 @@ static void guest_measure_loop(uint8_t idx)
>   	};
>   
>   	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
> -	uint32_t pmu_version = this_cpu_property(X86_PROPERTY_PMU_VERSION);
> +	uint32_t pmu_version = guest_get_pmu_version();
>   	struct kvm_x86_pmu_feature gp_event, fixed_event;
>   	uint32_t counter_msr;
>   	unsigned int i;
> @@ -270,9 +287,12 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
>   
>   static void guest_test_gp_counters(void)
>   {
> -	uint8_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
> +	uint8_t nr_gp_counters = 0;
>   	uint32_t base_msr;
>   
> +	if (guest_get_pmu_version())
> +		nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
> +
>   	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES)
>   		base_msr = MSR_IA32_PMC0;
>   	else
> @@ -282,7 +302,8 @@ static void guest_test_gp_counters(void)
>   	GUEST_DONE();
>   }
>   
> -static void test_gp_counters(uint8_t nr_gp_counters, uint64_t perf_cap)
> +static void test_gp_counters(uint8_t pmu_version, uint8_t nr_gp_counters,

The parameter pmu_version is not used in this function.

> +			     uint64_t perf_cap)
>   {
>   	struct kvm_vcpu *vcpu;
>   	struct kvm_vm *vm;
> @@ -305,16 +326,17 @@ static void guest_test_fixed_counters(void)
>   	uint8_t i;
>   
>   	/* KVM provides fixed counters iff the vPMU version is 2+. */
> -	if (this_cpu_property(X86_PROPERTY_PMU_VERSION) >= 2)
> +	if (guest_get_pmu_version() >= 2)
>   		nr_fixed_counters = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
>   
>   	/*
>   	 * The supported bitmask for fixed counters was introduced in PMU
>   	 * version 5.
>   	 */
> -	if (this_cpu_property(X86_PROPERTY_PMU_VERSION) >= 5)
> +	if (guest_get_pmu_version() >= 5)
>   		supported_bitmask = this_cpu_property(X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK);
>   
> +
>   	guest_rd_wr_counters(MSR_CORE_PERF_FIXED_CTR0, MAX_NR_FIXED_COUNTERS,
>   			     nr_fixed_counters, supported_bitmask);
>   
> @@ -345,7 +367,7 @@ static void guest_test_fixed_counters(void)
>   	GUEST_DONE();
>   }
>   
> -static void test_fixed_counters(uint8_t nr_fixed_counters,
> +static void test_fixed_counters(uint8_t pmu_version, uint8_t nr_fixed_counters,

The parameter pmu_version is not used in this function.

>   				uint32_t supported_bitmask, uint64_t perf_cap)
>   {
>   	struct kvm_vcpu *vcpu;
> @@ -368,22 +390,32 @@ static void test_intel_counters(void)
>   {
>   	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
>   	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
> +	uint8_t max_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
>   	unsigned int i;
> +	uint8_t j, v;
>   	uint32_t k;
> -	uint8_t j;
>   
>   	const uint64_t perf_caps[] = {
>   		0,
>   		PMU_CAP_FW_WRITES,
>   	};
>   
> -	for (i = 0; i < ARRAY_SIZE(perf_caps); i++) {
> -		for (j = 0; j <= nr_gp_counters; j++)
> -			test_gp_counters(j, perf_caps[i]);
> +	/*
> +	 * Test up to PMU v5, which is the current maximum version defined by
> +	 * Intel, i.e. is the last version that is guaranteed to be backwards
> +	 * compatible with KVM's existing behavior.
> +	 */
> +	max_pmu_version = max_t(typeof(max_pmu_version), max_pmu_version, 5);
>   
> -		for (j = 0; j <= nr_fixed_counters; j++) {
> -			for (k = 0; k <= (BIT(nr_fixed_counters) - 1); k++)
> -				test_fixed_counters(j, k, perf_caps[i]);
> +	for (v = 0; v <= max_pmu_version; v++) {
> +		for (i = 0; i < ARRAY_SIZE(perf_caps) + 1; i++) {
> +			for (j = 0; j <= nr_gp_counters; j++)
> +				test_gp_counters(v, j, perf_caps[i]);
> +
> +			for (j = 0; j <= nr_fixed_counters; j++) {
> +				for (k = 0; k <= (BIT(nr_fixed_counters) - 1); k++)
> +					test_fixed_counters(v, j, k, perf_caps[i]);
> +			}
>   		}
>   	}
>   }
> @@ -397,6 +429,8 @@ int main(int argc, char *argv[])
>   	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION) > 0);
>   	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
>   
> +	kvm_pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
> +
>   	test_intel_arch_events();
>   	test_intel_counters();
>   

