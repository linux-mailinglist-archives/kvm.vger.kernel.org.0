Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D7D3D11C1
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 16:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239391AbhGUOS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 10:18:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239329AbhGUOSY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Jul 2021 10:18:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626879541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KjXeCIfxGo6ypRWFVmbC/zpyi2fFuYdjiGPI5pJ0Hh8=;
        b=YMji/HWvzA0k4qzMwicHcTrlC9F9JZ45tV2fTgFS3lzwpmdhM7xhRrtg2MAXYi0FhLyWKC
        gBslX6RA0PRpFh+h0yTSi5cOok156eek1NfXMIn9ndCEBSoxx0p9Eki9y84CQTx8in7Zsc
        vFcBwLPMIa/7hJJy5BP46zgH/sXxn58=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-aJ95ANyJMQO0D-mOIMHITg-1; Wed, 21 Jul 2021 10:58:57 -0400
X-MC-Unique: aJ95ANyJMQO0D-mOIMHITg-1
Received: by mail-il1-f200.google.com with SMTP id x4-20020a056e021bc4b0290205d0d8dac7so1700099ilv.23
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 07:58:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KjXeCIfxGo6ypRWFVmbC/zpyi2fFuYdjiGPI5pJ0Hh8=;
        b=VNUNLlp/IgVwWLRkxCPrLrB2wIV/MsEk4bR8+ARYNzWJt/oXlUL/Sz6H++h7II/W9S
         Jlb84VBkAZWRq9DjCSvCvySqQbFUILlZYhrCbHzLqrrBMJG4G+xxQwexIHD2CwKg0ugQ
         k7wqJikkp8cGxkzXCaXXeEHj/lsRuj3Lr5pP8RsOV6vKes1vxY45gZfbqUrjxOCVal7R
         aj9/oGJP4f0zptQA5abiBCQ2k6tnwXH5uW1jx9WtV1GFMQQEkneeAWynr6JEnhzdojpg
         a85CuPEppgSNWMCQUnyEpJQOS4MUZwTEaAAMUBEPRIrk/GBzuIS5Fpti80RhUwnxVfL6
         ReEg==
X-Gm-Message-State: AOAM5308N6Kbghnn038gN0Ta3npmKRFeD4pLft2158fKg06ua9lpvBtB
        SxVu9cVOpFI73sZMGwEZ8GegcdZ+w2y5wPJ9zvKjPgjDec76ntNFh84fyzhzLdLXfyGQXh1q734
        9xQVK8TTV3nLl
X-Received: by 2002:a05:6638:192:: with SMTP id a18mr31241643jaq.47.1626879537303;
        Wed, 21 Jul 2021 07:58:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCvmcoF2dGZuvNzDsaOj5G/RdWgErC/EtuPOllb5o5+KUsUbgnv5nMan6lry5XkbsaZLo4qA==
X-Received: by 2002:a05:6638:192:: with SMTP id a18mr31241622jaq.47.1626879537086;
        Wed, 21 Jul 2021 07:58:57 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id k4sm14443329ior.55.2021.07.21.07.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 07:58:56 -0700 (PDT)
Date:   Wed, 21 Jul 2021 16:58:54 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        Raghavendra Rao Anata <rananta@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 05/12] selftests: KVM: Add test for KVM_{GET,SET}_CLOCK
Message-ID: <20210721145854.4rp4fl5buxc32kpf@gator>
References: <20210716212629.2232756-1-oupton@google.com>
 <20210716212629.2232756-6-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716212629.2232756-6-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 16, 2021 at 09:26:22PM +0000, Oliver Upton wrote:
> Add a selftest for the new KVM clock UAPI that was introduced. Ensure
> that the KVM clock is consistent between userspace and the guest, and
> that the difference in realtime will only ever cause the KVM clock to
> advance forward.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../testing/selftests/kvm/include/kvm_util.h  |   2 +
>  .../selftests/kvm/x86_64/kvm_clock_test.c     | 210 ++++++++++++++++++
>  4 files changed, 214 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 06a351b4f93b..d0877d01e771 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -11,6 +11,7 @@
>  /x86_64/emulator_error_test
>  /x86_64/get_cpuid_test
>  /x86_64/get_msr_index_features
> +/x86_64/kvm_clock_test
>  /x86_64/kvm_pv_test
>  /x86_64/hyperv_clock
>  /x86_64/hyperv_cpuid
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index b853be2ae3c6..f7e24f334c6e 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -46,6 +46,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/get_cpuid_test
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
> +TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
>  TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
>  TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
>  TEST_GEN_PROGS_x86_64 += x86_64/mmu_role_test
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 010b59b13917..a8ac5d52e17b 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -19,6 +19,8 @@
>  #define KVM_DEV_PATH "/dev/kvm"
>  #define KVM_MAX_VCPUS 512
>  
> +#define NSEC_PER_SEC 1000000000L
> +
>  /*
>   * Callers of kvm_util only have an incomplete/opaque description of the
>   * structure kvm_util is using to maintain the state of a VM.
> diff --git a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
> new file mode 100644
> index 000000000000..34c48f2dde54
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
> @@ -0,0 +1,210 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2021, Google LLC.
> + *
> + * Tests for adjusting the KVM clock from userspace
> + */
> +#include <asm/kvm_para.h>
> +#include <asm/pvclock.h>
> +#include <asm/pvclock-abi.h>
> +#include <stdint.h>
> +#include <string.h>
> +#include <sys/stat.h>
> +#include <time.h>
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +
> +#define VCPU_ID 0
> +
> +struct test_case {
> +	uint64_t kvmclock_base;
> +	int64_t realtime_offset;
> +};
> +
> +static struct test_case test_cases[] = {
> +	{ .kvmclock_base = 0 },
> +	{ .kvmclock_base = 180 * NSEC_PER_SEC },
> +	{ .kvmclock_base = 0, .realtime_offset = -180 * NSEC_PER_SEC },
> +	{ .kvmclock_base = 0, .realtime_offset = 180 * NSEC_PER_SEC },
> +};
> +
> +#define GUEST_SYNC_CLOCK(__stage, __val)			\
> +		GUEST_SYNC_ARGS(__stage, __val, 0, 0, 0)
> +
> +static void guest_main(vm_paddr_t pvti_pa, struct pvclock_vcpu_time_info *pvti)
> +{
> +	int i;
> +
> +	wrmsr(MSR_KVM_SYSTEM_TIME_NEW, pvti_pa | KVM_MSR_ENABLED);
> +	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
> +		GUEST_SYNC_CLOCK(i, __pvclock_read_cycles(pvti, rdtsc()));
> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +#define EXPECTED_FLAGS (KVM_CLOCK_REAL_TIME | KVM_CLOCK_HOST_TSC)
> +
> +static inline void assert_flags(struct kvm_clock_data *data)
> +{
> +	TEST_ASSERT((data->flags & EXPECTED_FLAGS) == EXPECTED_FLAGS,
> +		    "unexpected clock data flags: %x (want set: %x)",
> +		    data->flags, EXPECTED_FLAGS);
> +}
> +
> +static void handle_sync(struct ucall *uc, struct kvm_clock_data *start,
> +			struct kvm_clock_data *end)
> +{
> +	uint64_t obs, exp_lo, exp_hi;
> +
> +	obs = uc->args[2];
> +	exp_lo = start->clock;
> +	exp_hi = end->clock;
> +
> +	assert_flags(start);
> +	assert_flags(end);
> +
> +	TEST_ASSERT(exp_lo <= obs && obs <= exp_hi,
> +		    "unexpected kvm-clock value: %"PRIu64" expected range: [%"PRIu64", %"PRIu64"]",
> +		    obs, exp_lo, exp_hi);
> +
> +	pr_info("kvm-clock value: %"PRIu64" expected range [%"PRIu64", %"PRIu64"]\n",
> +		obs, exp_lo, exp_hi);
> +}
> +
> +static void handle_abort(struct ucall *uc)
> +{
> +	TEST_FAIL("%s at %s:%ld", (const char *)uc->args[0],
> +		  __FILE__, uc->args[1]);
> +}
> +
> +static void setup_clock(struct kvm_vm *vm, struct test_case *test_case)
> +{
> +	struct kvm_clock_data data;
> +
> +	memset(&data, 0, sizeof(data));
> +
> +	data.clock = test_case->kvmclock_base;
> +	if (test_case->realtime_offset) {
> +		struct timespec ts;
> +		int r;
> +
> +		data.flags |= KVM_CLOCK_REAL_TIME;
> +		do {
> +			r = clock_gettime(CLOCK_REALTIME, &ts);
> +			if (!r)
> +				break;
> +		} while (errno == EINTR);
> +
> +		TEST_ASSERT(!r, "clock_gettime() failed: %d\n", r);
> +
> +		data.realtime = ts.tv_sec * NSEC_PER_SEC;
> +		data.realtime += ts.tv_nsec;
> +		data.realtime += test_case->realtime_offset;
> +	}
> +
> +	vm_ioctl(vm, KVM_SET_CLOCK, &data);
> +}
> +
> +static void enter_guest(struct kvm_vm *vm)
> +{
> +	struct kvm_clock_data start, end;
> +	struct kvm_run *run;
> +	struct ucall uc;
> +	int i, r;
> +
> +	run = vcpu_state(vm, VCPU_ID);
> +
> +	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
> +		setup_clock(vm, &test_cases[i]);
> +
> +		vm_ioctl(vm, KVM_GET_CLOCK, &start);
> +
> +		r = _vcpu_run(vm, VCPU_ID);
> +		vm_ioctl(vm, KVM_GET_CLOCK, &end);
> +
> +		TEST_ASSERT(!r, "vcpu_run failed: %d\n", r);
> +		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +			    "unexpected exit reason: %u (%s)",
> +			    run->exit_reason, exit_reason_str(run->exit_reason));
> +
> +		switch (get_ucall(vm, VCPU_ID, &uc)) {
> +		case UCALL_SYNC:
> +			handle_sync(&uc, &start, &end);
> +			break;
> +		case UCALL_ABORT:
> +			handle_abort(&uc);
> +			return;
> +		case UCALL_DONE:
> +			return;
> +		}
> +	}
> +}
> +
> +#define CLOCKSOURCE_PATH "/sys/devices/system/clocksource/clocksource0/current_clocksource"
> +
> +static void check_clocksource(void)
> +{
> +	char *clk_name;
> +	struct stat st;
> +	FILE *fp;
> +
> +	fp = fopen(CLOCKSOURCE_PATH, "r");
> +	if (!fp) {
> +		pr_info("failed to open clocksource file: %d; assuming TSC.\n",
> +			errno);
> +		return;
> +	}
> +
> +	if (fstat(fileno(fp), &st)) {
> +		pr_info("failed to stat clocksource file: %d; assuming TSC.\n",
> +			errno);
> +		goto out;
> +	}
> +
> +	clk_name = malloc(st.st_size);
> +	TEST_ASSERT(clk_name, "failed to allocate buffer to read file\n");
> +
> +	if (!fgets(clk_name, st.st_size, fp)) {
> +		pr_info("failed to read clocksource file: %d; assuming TSC.\n",
> +			ferror(fp));
> +		goto out;
> +	}
> +
> +	TEST_ASSERT(!strncmp(clk_name, "tsc\n", st.st_size),
> +		    "clocksource not supported: %s", clk_name);
> +out:
> +	fclose(fp);
> +}
> +
> +int main(void)
> +{
> +	struct kvm_cpuid2 *best;
> +	vm_vaddr_t pvti_gva;
> +	vm_paddr_t pvti_gpa;
> +	struct kvm_vm *vm;
> +	int flags;
> +
> +	flags = kvm_check_cap(KVM_CAP_ADJUST_CLOCK);
> +	if (!(flags & KVM_CLOCK_REAL_TIME)) {
> +		print_skip("KVM_CLOCK_REAL_TIME not supported; flags: %x",
> +			   flags);
> +		exit(KSFT_SKIP);
> +	}
> +
> +	check_clocksource();
> +
> +	vm = vm_create_default(VCPU_ID, 0, guest_main);
> +
> +	best = kvm_get_supported_cpuid();
> +	vcpu_set_cpuid(vm, VCPU_ID, best);

Default vm types (which use default vcpu types) will already set cpuids
like this for x86. See the bottom of
lib/x86_64/processor.c:vm_vcpu_add_default

Thanks,
drew

> +
> +	pvti_gva = vm_vaddr_alloc(vm, getpagesize(), 0x10000);
> +	pvti_gpa = addr_gva2gpa(vm, pvti_gva);
> +	vcpu_args_set(vm, VCPU_ID, 2, pvti_gpa, pvti_gva);
> +
> +	enter_guest(vm);
> +	kvm_vm_free(vm);
> +}
> -- 
> 2.32.0.402.g57bb445576-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

