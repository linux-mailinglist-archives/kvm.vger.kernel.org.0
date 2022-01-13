Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEFB48D134
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 05:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbiAMEHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 23:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbiAMEHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 23:07:08 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0C2C06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 20:07:08 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id a1-20020a17090a688100b001b3fd52338eso8006435pjd.1
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 20:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to
         :references:cc:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=EWcXLNh8AYt+/tVU3hJ8862UgzEDENLO7tNuZoOCGYc=;
        b=LGlnyy+jFi2gL6fW2R9t7h+c3XclZfVP9/PofjGr11MROKk5gUL6/kBXttlktowZCE
         l1KCPxUvRCTFMEknrSDhPTYGVwqmfIur5e7pj0AU0UbW6b464PyppiEftHnDEAQl8PD6
         IaJdXfvv588HyGvdPcg7wYZQdcccA9pgs6TRB5TogN+nhz/kmw7Qpb8To6oUHs4Sp4Tf
         AZ7qEdJ7LZSJMc8JzMZ5IUt4xfpNcd1WInEeBEgft+trvhoq24DlEwxb37pSCxO5HgOP
         3JKm2pGtakKjZtCUeOpvKYPR2rF02KmEJkWKEpce0LVEp7G/DysgyyjWRE7qavO2p6Bg
         oYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:references:cc:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=EWcXLNh8AYt+/tVU3hJ8862UgzEDENLO7tNuZoOCGYc=;
        b=KCgf8Fo20LbXRZRIgXrgFf8JX6WOTTTahBY8OsUeEc0Y+W++LNKsHVhg3vxkRbm8NS
         5dkejbEgRmgtqv0huDII2snOODB9gtZH9OFtioYBQO/quVogOdRoz3FRSzOxsthucM78
         6NoI99+/Lps4T44mX6cHPCDCVc/3c1QWokhUfGaZsrAbAjIfzO97B1R/NJ+sv2RjmTtj
         oeZ1nfVE73BA8OG3zxbzEWrMbyCBH6DZVzL0m+5zFcZz37qFhuFiAUmf/UCV5UPame9l
         tPak0liFVGEi/tkE5Ct9nzPAGHWqCarcjnBo4d5eLt1d4M9WFK722Xb707zOSMn8Ehvr
         Q0sw==
X-Gm-Message-State: AOAM530E5uggv5rINqNzjBMl6g/9NgpW+nB8D0aLWP0loP/RhWQdQuw2
        S0GCxLH9G7vLWCBZhV+V2+9r+l3eQhrnLloIHT6hGw==
X-Google-Smtp-Source: ABdhPJxhu6JiQBgUdA+xROYE1aNj88Zy5GUZMFaNsOiN7F80qgYN42Cmk+ZmsuCUoRmmKpGI4Oo+5w==
X-Received: by 2002:a62:7997:0:b0:4bf:508a:2f78 with SMTP id u145-20020a627997000000b004bf508a2f78mr2577671pfc.16.1642046828242;
        Wed, 12 Jan 2022 20:07:08 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m5sm114302pfh.123.2022.01.12.20.07.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 20:07:07 -0800 (PST)
Message-ID: <a1053e1c-a16a-b1ec-a836-56974b4d4a65@gmail.com>
Date:   Thu, 13 Jan 2022 12:06:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        =?UTF-8?B?Y2xvdWRsaWFuZyjmooHph5HojaMp?= <cloudliang@tencent.com>
References: <20220113011453.3892612-1-jmattson@google.com>
 <20220113011453.3892612-7-jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org)" 
        <pbonzini@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH 6/6] selftests: kvm/x86: Add test for
 KVM_SET_PMU_EVENT_FILTER
In-Reply-To: <20220113011453.3892612-7-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cc Liang,

On 13/1/2022 9:14 am, Jim Mattson wrote:
> Verify that the PMU event filter works as expected.
> 
> Note that the virtual PMU doesn't work as expected on AMD Zen CPUs (an
> intercepted rdmsr is counted as a retired branch instruction), but the
> PMU event filter does work.

Thanks for this patch. It saves us from upstreaming our equivalent patch.
We do have a plan to cover vPMU features (and more) in selftests/kvm/x86.

Liang would help me on these selftests patches and,
please share more issues or insights (if any) you have found.

> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../kvm/x86_64/pmu_event_filter_test.c        | 310 ++++++++++++++++++
>   3 files changed, 312 insertions(+)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 8c129961accf..7834e03ab159 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -22,6 +22,7 @@
>   /x86_64/mmio_warning_test
>   /x86_64/mmu_role_test
>   /x86_64/platform_info_test
> +/x86_64/pmu_event_filter_test
>   /x86_64/set_boot_cpu_id
>   /x86_64/set_sregs_test
>   /x86_64/sev_migrate_tests
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index c407ebbec2c1..899413a6588f 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -56,6 +56,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
>   TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
>   TEST_GEN_PROGS_x86_64 += x86_64/mmu_role_test
>   TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
> +TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
>   TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
>   TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
>   TEST_GEN_PROGS_x86_64 += x86_64/smm_test
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> new file mode 100644
> index 000000000000..d879a4b92fae
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -0,0 +1,310 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Test for x86 KVM_SET_PMU_EVENT_FILTER.
> + *
> + * Copyright (C) 2022, Google LLC.
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.
> + *
> + * Verifies the expected behavior of allow lists and deny lists for
> + * virtual PMU events.
> + */
> +
> +#define _GNU_SOURCE /* for program_invocation_short_name */
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +
> +/*
> + * In lieue of copying perf_event.h into tools...
> + */
> +#define ARCH_PERFMON_EVENTSEL_ENABLE	BIT(22)
> +#define ARCH_PERFMON_EVENTSEL_OS	BIT(17)
> +
> +#define VCPU_ID 0
> +#define NUM_BRANCHES 42
> +
> +/*
> + * This is how the event selector and unit mask are stored in an AMD
> + * core performance event-select register. Intel's format is similar,
> + * but the event selector is only 8 bits.
> + */
> +#define EVENT(select, umask) ((select & 0xf00UL) << 24 | (select & 0xff) | \
> +			      (umask & 0xff) << 8)
> +
> +/*
> + * "Branch instructions retired", from the Intel SDM, volume 3,
> + * "Pre-defined Architectural Performance Events."
> + */
> +
> +#define INTEL_BR_RETIRED EVENT(0xc4, 0)
> +
> +/*
> + * "Retired branch instructions", from Processor Programming Reference
> + * (PPR) for AMD Family 17h Model 01h, Revision B1 Processors,
> + * Preliminary Processor Programming Reference (PPR) for AMD Family
> + * 17h Model 31h, Revision B0 Processors, and Preliminary Processor
> + * Programming Reference (PPR) for AMD Family 19h Model 01h, Revision
> + * B1 Processors Volume 1 of 2
> + */
> +
> +#define AMD_ZEN_BR_RETIRED EVENT(0xc2, 0)
> +
> +/*
> + * This event list comprises Intel's eight architectural events plus
> + * AMD's "branch instructions retired" for Zen[123].
> + */
> +static const uint64_t event_list[] = {
> +	EVENT(0x3c, 0),
> +	EVENT(0xc0, 0),
> +	EVENT(0x3c, 1),
> +	EVENT(0x2e, 0x4f),
> +	EVENT(0x2e, 0x41),
> +	EVENT(0xc4, 0),
> +	EVENT(0xc5, 0),
> +	EVENT(0xa4, 1),
> +	AMD_ZEN_BR_RETIRED,
> +};
> +
> +static void intel_guest_code(void)
> +{
> +	uint64_t br0, br1;
> +
> +	for (;;) {
> +		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> +		wrmsr(MSR_P6_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
> +		      ARCH_PERFMON_EVENTSEL_OS | INTEL_BR_RETIRED);
> +		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 1);
> +		br0 = rdmsr(MSR_IA32_PMC0);
> +		__asm__ __volatile__("loop ."
> +				     : "=c"((int){0})
> +				     : "0"(NUM_BRANCHES));
> +		br1 = rdmsr(MSR_IA32_PMC0);
> +		GUEST_SYNC(br1 - br0);
> +	}
> +}
> +
> +/*
> + * To avoid needing a check for CPUID.80000001:ECX.PerfCtrExtCore[bit
> + * 23], this code uses the always-available, legacy K7 PMU MSRs, which
> + * alias to the first four of the six extended core PMU MSRs.
> + */
> +static void amd_guest_code(void)
> +{
> +	uint64_t br0, br1;
> +
> +	for (;;) {
> +		wrmsr(MSR_K7_EVNTSEL0, 0);
> +		wrmsr(MSR_K7_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
> +		      ARCH_PERFMON_EVENTSEL_OS | AMD_ZEN_BR_RETIRED);
> +		br0 = rdmsr(MSR_K7_PERFCTR0);
> +		__asm__ __volatile__("loop ."
> +				     : "=c"((int){0})
> +				     : "0"(NUM_BRANCHES));
> +		br1 = rdmsr(MSR_K7_PERFCTR0);
> +		GUEST_SYNC(br1 - br0);
> +	}
> +}
> +
> +static uint64_t test_branches_retired(struct kvm_vm *vm)
> +{
> +	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> +	struct ucall uc;
> +
> +	vcpu_run(vm, VCPU_ID);
> +	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +		    "Exit_reason other than KVM_EXIT_IO: %u (%s)\n",
> +		    run->exit_reason,
> +		    exit_reason_str(run->exit_reason));
> +	get_ucall(vm, VCPU_ID, &uc);
> +	TEST_ASSERT(uc.cmd == UCALL_SYNC,
> +		    "Received ucall other than UCALL_SYNC: %lu", uc.cmd);
> +	return uc.args[1];
> +}
> +
> +static struct kvm_pmu_event_filter *make_pmu_event_filter(uint32_t nevents)
> +{
> +	struct kvm_pmu_event_filter *f;
> +	int size = sizeof(*f) + nevents * sizeof(f->events[0]);
> +
> +	f = malloc(size);
> +	TEST_ASSERT(f, "Out of memory");
> +	memset(f, 0, size);
> +	f->nevents = nevents;
> +	return f;
> +}
> +
> +static struct kvm_pmu_event_filter *event_filter(uint32_t action)
> +{
> +	struct kvm_pmu_event_filter *f;
> +	int i;
> +
> +	f = make_pmu_event_filter(ARRAY_SIZE(event_list));
> +	f->action = action;
> +	for (i = 0; i < ARRAY_SIZE(event_list); i++)
> +		f->events[i] = event_list[i];
> +
> +	return f;
> +}
> +
> +static struct kvm_pmu_event_filter *remove_event(struct kvm_pmu_event_filter *f,
> +						 uint64_t event)
> +{
> +	bool found = false;
> +	int i;
> +
> +	for (i = 0; i < f->nevents; i++) {
> +		if (found)
> +			f->events[i - 1] = f->events[i];
> +		else
> +			found = f->events[i] == event;
> +	}
> +	if (found)
> +		f->nevents--;
> +	return f;
> +}
> +
> +static void test_no_filter(struct kvm_vm *vm)
> +{
> +	uint64_t count = test_branches_retired(vm);
> +
> +	if (count != NUM_BRANCHES)
> +		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
> +			__func__, count, NUM_BRANCHES);
> +	TEST_ASSERT(count, "Allowed PMU event is not counting");
> +}
> +
> +static uint64_t test_with_filter(struct kvm_vm *vm,
> +				 struct kvm_pmu_event_filter *f)
> +{
> +	vm_ioctl(vm, KVM_SET_PMU_EVENT_FILTER, (void *)f);
> +	return test_branches_retired(vm);
> +}
> +
> +static void test_member_deny_list(struct kvm_vm *vm)
> +{
> +	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_DENY);
> +	uint64_t count = test_with_filter(vm, f);
> +
> +	free(f);
> +	if (count)
> +		pr_info("%s: Branch instructions retired = %lu (expected 0)\n",
> +			__func__, count);
> +	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
> +}
> +
> +static void test_member_allow_list(struct kvm_vm *vm)
> +{
> +	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_ALLOW);
> +	uint64_t count = test_with_filter(vm, f);
> +
> +	free(f);
> +	if (count != NUM_BRANCHES)
> +		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
> +			__func__, count, NUM_BRANCHES);
> +	TEST_ASSERT(count, "Allowed PMU event is not counting");
> +}
> +
> +static void test_not_member_deny_list(struct kvm_vm *vm)
> +{
> +	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_DENY);
> +	uint64_t count;
> +
> +	remove_event(f, INTEL_BR_RETIRED);
> +	remove_event(f, AMD_ZEN_BR_RETIRED);
> +	count = test_with_filter(vm, f);
> +	free(f);
> +	if (count != NUM_BRANCHES)
> +		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
> +			__func__, count, NUM_BRANCHES);
> +	TEST_ASSERT(count, "Allowed PMU event is not counting");
> +}
> +
> +static void test_not_member_allow_list(struct kvm_vm *vm)
> +{
> +	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_ALLOW);
> +	uint64_t count;
> +
> +	remove_event(f, INTEL_BR_RETIRED);
> +	remove_event(f, AMD_ZEN_BR_RETIRED);
> +	count = test_with_filter(vm, f);
> +	free(f);
> +	if (count)
> +		pr_info("%s: Branch instructions retired = %lu (expected 0)\n",
> +			__func__, count);
> +	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
> +}
> +
> +/*
> + * Note that CPUID leaf 0xa is Intel-specific. This leaf should be
> + * clear on AMD hardware.
> + */
> +static bool vcpu_supports_intel_br_retired(void)
> +{
> +	struct kvm_cpuid_entry2 *entry;
> +	struct kvm_cpuid2 *cpuid;
> +
> +	cpuid = kvm_get_supported_cpuid();
> +	entry = kvm_get_supported_cpuid_index(0xa, 0);
> +	return entry &&
> +		(entry->eax & 0xff) &&
> +		(entry->eax >> 24) > 5 &&
> +		!(entry->ebx & BIT(5));
> +}
> +
> +/*
> + * Determining AMD support for a PMU event requires consulting the AMD
> + * PPR for the CPU or reference material derived therefrom.
> + */
> +static bool vcpu_supports_amd_zen_br_retired(void)
> +{
> +	struct kvm_cpuid_entry2 *entry;
> +	struct kvm_cpuid2 *cpuid;
> +
> +	cpuid = kvm_get_supported_cpuid();
> +	entry = kvm_get_supported_cpuid_index(1, 0);
> +	return entry &&
> +		((x86_family(entry->eax) == 0x17 &&
> +		  (x86_model(entry->eax) == 1 ||
> +		   x86_model(entry->eax) == 0x31)) ||
> +		 (x86_family(entry->eax) == 0x19 &&
> +		  x86_model(entry->eax) == 1));
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	void (*guest_code)(void) = NULL;
> +	struct kvm_vm *vm;
> +	int r;
> +
> +	/* Tell stdout not to buffer its content */
> +	setbuf(stdout, NULL);
> +
> +	r = kvm_check_cap(KVM_CAP_PMU_EVENT_FILTER);
> +	if (!r) {
> +		print_skip("KVM_CAP_PMU_EVENT_FILTER not supported");
> +		exit(KSFT_SKIP);
> +	}
> +
> +	if (vcpu_supports_intel_br_retired())
> +		guest_code = intel_guest_code;
> +	else if (vcpu_supports_amd_zen_br_retired())
> +		guest_code = amd_guest_code;
> +
> +	if (!guest_code) {
> +		print_skip("Branch instructions retired not supported");
> +		exit(KSFT_SKIP);
> +	}
> +
> +	vm = vm_create_default(VCPU_ID, 0, guest_code);
> +
> +	test_no_filter(vm);
> +	test_member_deny_list(vm);
> +	test_member_allow_list(vm);
> +	test_not_member_deny_list(vm);
> +	test_not_member_allow_list(vm);
> +
> +	kvm_vm_free(vm);
> +
> +	return 0;
> +}
