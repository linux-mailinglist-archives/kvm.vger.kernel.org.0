Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA63D740AB0
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbjF1IJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbjF1IFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:05:47 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5F9A3;
        Wed, 28 Jun 2023 01:03:59 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-39ca48cd4c6so4002170b6e.0;
        Wed, 28 Jun 2023 01:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687939438; x=1690531438;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bxCU+wW77iFplvleR1CjjbOa9wKPfnwB+vKBRzAbrcc=;
        b=SxMj97TvfP6YxCfU4GWyH7F19MxuBG0jP9ix/xcaLMoZPRvsQ4IKQfSYTi969i8Ctc
         8xrcY9X3N/VcfGQHTC6cA1WxOU9kakBeNpPMkbXJLwqPE0blSIk1yvWUvQPSryXnern9
         Mb1ki6izUjUBV5FxIkF8GL5AnWdDgPjCR9ebfphtq1+OeBx5zsqckNm3yI9n9gDE6J7o
         EyEuwpHhLqgW3FN2ntz0p+sYnbdQVFM1b02kKQkBLShr9ILfs0PmhNyjrCSIhe2YtRuh
         FVxsyiZf0dbVRW8x/h4WXtmhtIGxE8PqG8L2gpcL0Cx3NbMjWX/pXauSllgyfZzBfzDg
         AD5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687939438; x=1690531438;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bxCU+wW77iFplvleR1CjjbOa9wKPfnwB+vKBRzAbrcc=;
        b=MiSxIo5V8uO7hrTPsQY4+rfj2aah23cI//Z3uYLklKI0t4K15pT2oucFAt/pFeb5uB
         NGI2EykZgHjthu8FzkFU9R8TM7iax9NGYUNMFmN9VSCoqVoIFJbL67m/T6NvU8c0q/z9
         +UMGvaNknKjh03zsGGKKcShCtVJ3p8SOf6GYBUCCFJ74dIz3xfdxqYYlAkKDX8+2TnvH
         sEYu1ZyNR7PNRfQoADu3iXdjWkFmiJoSelmzkNPrZk6LxdBMPWmNwb0sUGRXtjhIAAu7
         fwGyMq1KUpw5e3+wDKfTDxlzHbwsjYuBnuh20sx7CBwE1w4cWQ44y3EDzAQH+dGBuxkr
         gTyQ==
X-Gm-Message-State: AC+VfDwIqHgO0Tcio0qii2tdfyuVyMBc276unwQqts/wnmBPZP6PO93S
        h2rxDAOvDRYS8DimYm8gvS8GfVQww7lUqzKF5cQ=
X-Google-Smtp-Source: ACHHUZ4lsDTguCXruYbr7bp0NA/beuD9ynw6ujb4MumtIC91eoD5OTRFDon7v6LMYNvhBomVwAGkRQ==
X-Received: by 2002:a54:4612:0:b0:396:e3a:9f2f with SMTP id p18-20020a544612000000b003960e3a9f2fmr29657170oip.5.1687933638398;
        Tue, 27 Jun 2023 23:27:18 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ge21-20020a17090b0e1500b00260a5ecd273sm7081815pjb.1.2023.06.27.23.27.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jun 2023 23:27:18 -0700 (PDT)
Message-ID: <c8ae0068-2484-85a3-819e-d71cee23c640@gmail.com>
Date:   Wed, 28 Jun 2023 14:27:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH 4/4] KVM: selftests: Add test case for guest and host LBR
 preemption
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>
Cc:     pbonzini@redhat.com, peterz@infradead.org,
        kan.liang@linux.intel.com, zhenyuw@linux.intel.com,
        zhiyuan.lv@intel.com, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>
References: <20230616113353.45202-1-xiong.y.zhang@intel.com>
 <20230616113353.45202-5-xiong.y.zhang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230616113353.45202-5-xiong.y.zhang@intel.com>
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

This direction could be a vPMU "coexistence" feature, please feel free to test it.
But the first step might be to test the behavior of vPMC when its event is 
preempted.
Then expand to Guest LBR and Guest PEBS etc.

On 16/6/2023 7:33 pm, Xiong Zhang wrote:
> When guest access LBR msr at the first time, kvm will create a vLBR event,
> vLBR event joins perf scheduler and occupy physical LBR for guest usage.
> Once vLBR event is active and own LBR, guest could access LBR msr.
> 
> But vLBR event is per process pinned event, perf has higher priority event:
> per cpu pinned LBR event, perf has lower priority events also: per cpu LBR
> event and per process LBR event.
> So if host doesn't have higher priority per cpu pinned LBR event, vLBR
> event could occupy physical LBR always. But once per cpu pinned LBR event
> is active, vLBR event couldn't be active anymore, then guest couldn't
> access LBR msr.
> 
> This commit adds test case to cover guest and host lbr contend.
> 
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> ---
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../selftests/kvm/include/ucall_common.h      |  17 ++
>   .../kvm/x86_64/pmu_event_filter_test.c        |  16 --
>   .../kvm/x86_64/vmx_pmu_lbr_contend.c          | 171 ++++++++++++++++++
>   4 files changed, 189 insertions(+), 16 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_pmu_lbr_contend.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 4761b768b773..422bbc16ba2a 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -100,6 +100,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_exception_with_invalid_guest_state
>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_msrs_test
>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_invalid_nested_guest_state
> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_lbr_contend

x86_64/vmx_pmu_coexistence ?

>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
>   TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index 1a6aaef5ccae..c1bb0cacf390 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -35,6 +35,23 @@ void ucall(uint64_t cmd, int nargs, ...);
>   uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
>   void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
>   
> +/*
> + * Run the VM to the next GUEST_SYNC(value), and return the value passed
> + * to the sync. Any other exit from the guest is fatal.
> + */
> +static inline uint64_t run_vcpu_to_sync(struct kvm_vcpu *vcpu)
> +{
> +	struct ucall uc;
> +
> +	vcpu_run(vcpu);
> +	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> +	get_ucall(vcpu, &uc);
> +	TEST_ASSERT(uc.cmd == UCALL_SYNC,
> +		    "Received ucall other than UCALL_SYNC: %lu", uc.cmd);
> +
> +	return uc.args[1];
> +}
> +
>   /*
>    * Perform userspace call without any associated data.  This bare call avoids
>    * allocating a ucall struct, which can be useful if the atomic operations in
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index 40507ed9fe8a..8c68029cfb4b 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -177,22 +177,6 @@ static void amd_guest_code(void)
>   	}
>   }
>   
> -/*
> - * Run the VM to the next GUEST_SYNC(value), and return the value passed
> - * to the sync. Any other exit from the guest is fatal.
> - */
> -static uint64_t run_vcpu_to_sync(struct kvm_vcpu *vcpu)
> -{
> -	struct ucall uc;
> -
> -	vcpu_run(vcpu);
> -	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> -	get_ucall(vcpu, &uc);
> -	TEST_ASSERT(uc.cmd == UCALL_SYNC,
> -		    "Received ucall other than UCALL_SYNC: %lu", uc.cmd);
> -	return uc.args[1];
> -}

Can this part be a separate patch ?

> -
>   static void run_vcpu_and_sync_pmc_results(struct kvm_vcpu *vcpu)
>   {
>   	uint64_t r;
> diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_lbr_contend.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_lbr_contend.c
> new file mode 100644
> index 000000000000..a6a793f08515
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_lbr_contend.c
> @@ -0,0 +1,171 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Test for host and guest LBR preemption
> + *
> + * Copyright (C) 2021 Intel Corporation
> + *
> + */
> +
> +#define _GNU_SOURCEGG
> +
> +#include <linux/perf_event.h>
> +#include <sys/syscall.h>
> +#include <sys/sysinfo.h>
> +#include <unistd.h>
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +
> +static void create_perf_events(int *fds, int cpu_num, bool pinned)
> +{
> +	struct perf_event_attr attr = {
> +		.type = PERF_TYPE_HARDWARE,
> +		.size = sizeof(attr),
> +		.config = PERF_COUNT_HW_CPU_CYCLES,
> +		.sample_type = PERF_SAMPLE_BRANCH_STACK,
> +		.sample_period = 1000,
> +		.pinned = pinned,
> +		.branch_sample_type = PERF_SAMPLE_BRANCH_CALL_STACK |
> +				      PERF_SAMPLE_BRANCH_USER |
> +				      PERF_SAMPLE_BRANCH_KERNEL,
> +	};
> +	int i;
> +
> +	for (i = 0; i < cpu_num; i++) {
> +		fds[i] = syscall(__NR_perf_event_open, &attr, -1, i, -1, PERF_FLAG_FD_CLOEXEC);

Which field can point to the generation of a "per cpu pinned" event ?
More comments are required.

> +		TEST_ASSERT(fds[i] != -1, "Failed to create lbr event on cpu%d", i);
> +	}
> +}
> +
> +static void release_perf_events(int *fds, int cpu_num)
> +{
> +	int i;
> +
> +	for (i = 0; i < cpu_num; i++)
> +		close(fds[i]);
> +}
> +
> +#define PERF_CAP_LBR_FMT_MASK  0x1F
> +
> +#define LBR_NOT_SUPPORTED  0xFFFE
> +#define LBR_MSR_WRITE_ERROR 0xFFFD
> +
> +#define LBR_MODE_CHECK_PASS 0x0
> +#define LBR_MSR_WRITE_SUCC  0x1
> +
> +static bool check_lbr_msr(void)
> +{
> +	uint64_t v, old_val;
> +
> +	old_val = rdmsr(MSR_LBR_TOS);

Why focus only on MSR_LBR_TOS ?

> +
> +	v  = old_val ^ 0x3UL;
> +
> +	wrmsr(MSR_LBR_TOS, v);
> +	if (rdmsr(MSR_LBR_TOS) != v)
> +		return false;
> +
> +	wrmsr(MSR_LBR_TOS, old_val);
> +	if (rdmsr(MSR_LBR_TOS) != old_val)
> +		return false;
> +
> +	return true;
> +}
> +
> +static void guest_code(void)
> +{
> +	uint64_t v;
> +
> +	v = rdmsr(MSR_IA32_PERF_CAPABILITIES);
> +	if ((v & PERF_CAP_LBR_FMT_MASK) == 0)
> +		GUEST_SYNC(LBR_NOT_SUPPORTED);
> +
> +	GUEST_SYNC(LBR_MODE_CHECK_PASS);
> +
> +	while (1) {
> +		if (!check_lbr_msr()) {
> +			GUEST_SYNC(LBR_MSR_WRITE_ERROR);
> +			continue;
> +		}
> +
> +		/* Enable LBR to avoid KVM recyling LBR. */
> +		 v = rdmsr(MSR_IA32_DEBUGCTLMSR);
> +		 v |= DEBUGCTLMSR_LBR;
> +		 wrmsr(MSR_IA32_DEBUGCTLMSR, v);
> +
> +		GUEST_SYNC(LBR_MSR_WRITE_SUCC);
> +	}
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int *fds, ncpus;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	uint64_t r;
> +
> +	TEST_REQUIRE(get_kvm_param_bool("enable_pmu"));
> +	TEST_REQUIRE(host_cpu_is_intel);
> +	TEST_REQUIRE(kvm_cpu_property(X86_PROPERTY_PMU_VERSION));
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +	r = run_vcpu_to_sync(vcpu);
> +	TEST_ASSERT(r == LBR_MODE_CHECK_PASS,
> +		    "LBR format in guest PERF_CAP msr isn't correct");
> +
> +	ncpus = get_nprocs();

Could we limit the test to a specific cpu, since it will affect the load on 
other cpus?

> +	fds = malloc(sizeof(int) * ncpus);
> +	TEST_ASSERT(fds != NULL, "Failed to create fds for all cpus");
> +
> +	/* Create per cpu pinned LBR event, then it will own LBR. */
> +	create_perf_events(fds, ncpus, true);
> +
> +	/* Since LBR is owned by per cpu pinned LBR event, guest couldn't get it,
> +	 * so guest couldn't access LBR_TOS msr.
> +	 */
> +	r = run_vcpu_to_sync(vcpu);
> +	TEST_ASSERT(r == LBR_MSR_WRITE_ERROR,
> +		    "1. Unexpected successfully read/write guest LBR_TO msr");
> +
> +	release_perf_events(fds, ncpus);

Obviously there are duplicate calls on release_perf_events() that can be omitted.

> +
> +	/* Since per cpu pinned event is closed and LBR is free, guest could get it,
> +	 * so guest could access LBR_TOS msr.
> +	 */
> +	r = run_vcpu_to_sync(vcpu);
> +	TEST_ASSERT(r == LBR_MSR_WRITE_SUCC,
> +		    "2. Failed to read/write guest LBR_TO msr");
> +
> +	/* Create per cpu LBR event, its priority is lower than vLBR event, and it
> +	 *  couldn't get LBR back from vLBR
> +	 */
> +	create_perf_events(fds, ncpus, false);
> +
> +	/* LBR is still owned by guest, So guest could access LBR_TOS successfully. */
> +	r = run_vcpu_to_sync(vcpu);
> +	TEST_ASSERT(r == LBR_MSR_WRITE_SUCC,
> +		    "3. Failed read/write guest LBR_TO msr");
> +
> +	release_perf_events(fds, ncpus);
> +
> +	/* Create per cpu pinned LBR event, its priority is higher than vLBR event,
> +	 * so it will get LBR back from vLBR.
> +	 */
> +	create_perf_events(fds, ncpus, true);
> +
> +	/* LBR is preepmted by per cpu pinned LBR event, guest couldn't access
> +	 * LBR_TOS msr.
> +	 */
> +	r = run_vcpu_to_sync(vcpu);
> +	TEST_ASSERT(r == LBR_MSR_WRITE_ERROR,
> +		    "4. Unexpected successfully read/write guest LBR_TO msr");
> +
> +	release_perf_events(fds, ncpus);

  Why not add more tests to cover all possibilities ?

	per cpu pinned event
	per process pinned event
	per cpu event
	per process event

> +
> +	kvm_vm_free(vm);
> +
> +	free(fds);
> +
> +	return 0;
> +}
