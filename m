Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E1A3D16B9
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 20:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbhGUSSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 14:18:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59805 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231215AbhGUSSb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Jul 2021 14:18:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626893947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iBmGCL7jPFnHI9C3ijkGqsP0JNbW0XOP1l5/J0Ba0Dc=;
        b=Y+hupfBmsP7QXHDkcYVmu9k9hp49iOFZ2bZqoTh+lOUHd0UIkgUIPj17kw+SMU0GNrCo4p
        6fu7kz5LR7vXNG7zSLt/5c+O6Ixo5UDSj6gnALDTuaSgHaFgQSYxJOg0ty5FQfs0uxnT9o
        mtIK8Maab4DEHabH7jj/JCFqxDVhSeA=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-r0zqu-TBNPCI10CQm7SkOw-1; Wed, 21 Jul 2021 14:59:06 -0400
X-MC-Unique: r0zqu-TBNPCI10CQm7SkOw-1
Received: by mail-io1-f69.google.com with SMTP id h7-20020a6bb7070000b0290525efa1b760so2210341iof.16
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 11:59:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iBmGCL7jPFnHI9C3ijkGqsP0JNbW0XOP1l5/J0Ba0Dc=;
        b=m3Q+mJcMyFRbOyNGx3mDvsdWtTmuYaXUI7JlM3WWV0cWJ9vanUNn6tpRaco3jSgdmX
         rvVQKFxKsXVDgsBSOeswsMqa+pIfhJgvqOY1vBE3T7IXgIFmxD6X0jFfZeAde3CTXo9a
         gl8czlDECcXLknA8NNQiB4YBNm68rjL0ubMjOVjk6TgBiatqKM0AAlpHf46HCI2YI9LM
         4umDfzV2vfUbeQ3vB/AeMrmYH0aw1VKm+4mJEvNpDWoU+e2gppGkvZyClR3b7NqK3XXo
         eRoUxzYR/sEhsOnKc8ES9dF3J0L7bvwMM2GG5CMenAHEn75cVfm/RK76EpXsZHQJUmAi
         VQ3w==
X-Gm-Message-State: AOAM533ySOgxgBDla4CgkM7EFhWHPqmbwT5NOobTbNGME6SusUtvhtjK
        5mkEiBdTwYHF2EkelBA4Svaam3uEnp4QuaRL6z1o78U9d3EMF5gFcYOwZAM1pDe9kOsuNMiMYVr
        CfiF5Bf+rCNu0
X-Received: by 2002:a92:b111:: with SMTP id t17mr26160431ilh.208.1626893945688;
        Wed, 21 Jul 2021 11:59:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQ4mMJK3pXkXKSexNYDbrE2sP+tp5hb8uptHNQl5fEFcJFBTu/FZLububJb1KHAUh4923ujA==
X-Received: by 2002:a92:b111:: with SMTP id t17mr26160408ilh.208.1626893945154;
        Wed, 21 Jul 2021 11:59:05 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id j13sm8789953ila.38.2021.07.21.11.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 11:59:04 -0700 (PDT)
Date:   Wed, 21 Jul 2021 20:59:02 +0200
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
Subject: Re: [PATCH v3 12/12] selftests: KVM: Add counter emulation benchmark
Message-ID: <20210721185902.dbuv3vv4aorpgn54@gator>
References: <20210719184949.1385910-1-oupton@google.com>
 <20210719184949.1385910-13-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719184949.1385910-13-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 06:49:49PM +0000, Oliver Upton wrote:
> Add a test case for counter emulation on arm64. A side effect of how KVM
> handles physical counter offsetting on non-ECV systems is that the
> virtual counter will always hit hardware and the physical could be
> emulated. Force emulation by writing a nonzero offset to the physical
> counter and compare the elapsed cycles to a direct read of the hardware
> register.
> 
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../kvm/aarch64/counter_emulation_benchmark.c | 215 ++++++++++++++++++
>  3 files changed, 217 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 2752813d5090..1d811c6a769b 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -1,5 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  /aarch64/debug-exceptions
> +/aarch64/counter_emulation_benchmark

alphabetic order please

>  /aarch64/get-reg-list
>  /aarch64/vgic_init
>  /s390x/memop
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index d89908108c97..e560a3e74bc2 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -86,6 +86,7 @@ TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
>  TEST_GEN_PROGS_x86_64 += system_counter_offset_test
>  
>  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
> +TEST_GEN_PROGS_aarch64 += aarch64/counter_emulation_benchmark

alphabetic order please

>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
>  TEST_GEN_PROGS_aarch64 += demand_paging_test
> diff --git a/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c b/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
> new file mode 100644
> index 000000000000..73aeb6cdebfe
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/aarch64/counter_emulation_benchmark.c
> @@ -0,0 +1,215 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * counter_emulation_benchmark.c -- test to measure the effects of counter
> + * emulation on guest reads of the physical counter.
> + *
> + * Copyright (c) 2021, Google LLC.
> + */
> +
> +#define _GNU_SOURCE
> +#include <asm/kvm.h>
> +#include <linux/kvm.h>
> +#include <stdio.h>
> +#include <stdint.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "test_util.h"
> +
> +#define VCPU_ID 0
> +
> +static struct counter_values {
> +	uint64_t cntvct_start;
> +	uint64_t cntpct;
> +	uint64_t cntvct_end;
> +} counter_values;
> +
> +static uint64_t nr_iterations = 1000;
> +
> +static void do_test(void)
> +{
> +	/*
> +	 * Open-coded approach instead of using helper methods to keep a tight
> +	 * interval around the physical counter read.
> +	 */
> +	asm volatile("isb\n\t"
> +		     "mrs %[cntvct_start], cntvct_el0\n\t"
> +		     "isb\n\t"
> +		     "mrs %[cntpct], cntpct_el0\n\t"
> +		     "isb\n\t"
> +		     "mrs %[cntvct_end], cntvct_el0\n\t"
> +		     "isb\n\t"
> +		     : [cntvct_start] "=r"(counter_values.cntvct_start),
> +		     [cntpct] "=r"(counter_values.cntpct),
> +		     [cntvct_end] "=r"(counter_values.cntvct_end));
> +}
> +
> +static void guest_main(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_iterations; i++) {
> +		do_test();
> +		GUEST_SYNC(i);
> +	}
> +
> +	for (i = 0; i < nr_iterations; i++) {
> +		do_test();
> +		GUEST_SYNC(i);
> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +static bool enter_guest(struct kvm_vm *vm)
> +{
> +	struct ucall uc;
> +
> +	vcpu_ioctl(vm, VCPU_ID, KVM_RUN, NULL);
> +
> +	switch (get_ucall(vm, VCPU_ID, &uc)) {
> +	case UCALL_DONE:
> +		return true;
> +	case UCALL_SYNC:
> +		break;
> +	case UCALL_ABORT:
> +		TEST_ASSERT(false, "%s at %s:%ld", (const char *)uc.args[0],
> +			    __FILE__, uc.args[1]);
> +		break;
> +	default:
> +		TEST_ASSERT(false, "unexpected exit: %s",
> +			    exit_reason_str(vcpu_state(vm, VCPU_ID)->exit_reason));
> +		break;
> +	}
> +
> +	/* more work to do in the guest */
> +	return false;
> +}
> +
> +static double counter_frequency(void)
> +{
> +	uint32_t freq;
> +
> +	asm volatile("mrs %0, cntfrq_el0"
> +		     : "=r" (freq));
> +
> +	return freq / 1000000.0;
> +}
> +
> +static void log_csv(FILE *csv, bool trapped)
> +{
> +	double freq = counter_frequency();
> +
> +	fprintf(csv, "%s,%.02f,%lu,%lu,%lu\n",
> +		trapped ? "true" : "false", freq,
> +		counter_values.cntvct_start,
> +		counter_values.cntpct,
> +		counter_values.cntvct_end);
> +}
> +
> +static double run_loop(struct kvm_vm *vm, FILE *csv, bool trapped)
> +{
> +	double avg = 0;
> +	int i;
> +
> +	for (i = 0; i < nr_iterations; i++) {
> +		uint64_t delta;
> +
> +		TEST_ASSERT(!enter_guest(vm), "guest exited unexpectedly");

UCALL_DONE would assert, but we never do a UCALL_DONE because we're
entering the guest nr_iterations times but [would] exit it
2 * nr_iterations times before GUEST_DONE() gets called. IOW, the
logic of the run loop looks like it could use some cleanup.

> +		sync_global_from_guest(vm, counter_values);
> +
> +		if (csv)
> +			log_csv(csv, trapped);
> +
> +		delta = counter_values.cntvct_end - counter_values.cntvct_start;
> +		avg = ((avg * i) + delta) / (i + 1);
> +	}
> +
> +	return avg;
> +}
> +
> +static void setup_counter(struct kvm_vm *vm, uint64_t offset)
> +{
> +	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> +				KVM_ARM_VCPU_TIMER_OFFSET_PTIMER, &offset,
> +				true);
> +}
> +
> +static void run_tests(struct kvm_vm *vm, FILE *csv)
> +{
> +	double avg_trapped, avg_native, freq;
> +
> +	freq = counter_frequency();
> +
> +	if (csv)
> +		fputs("trapped,freq_mhz,cntvct_start,cntpct,cntvct_end\n", csv);
> +
> +	/* no physical offsetting; kvm allows reads of cntpct_el0 */
> +	setup_counter(vm, 0);
> +	avg_native = run_loop(vm, csv, false);
> +
> +	/* force emulation of the physical counter */
> +	setup_counter(vm, 1);
> +	avg_trapped = run_loop(vm, csv, true);
> +
> +	TEST_ASSERT(enter_guest(vm), "guest didn't run to completion");
> +	pr_info("%lu iterations: average cycles (@%.02fMHz) native: %.02f, trapped: %.02f\n",
> +		nr_iterations, freq, avg_native, avg_trapped);
> +}
> +
> +static void usage(const char *program_name)
> +{
> +	fprintf(stderr,
> +		"Usage: %s [-h] [-o csv_file] [-n iterations]\n"
> +		"  -h prints this message\n"
> +		"  -n number of test iterations (default: %lu)\n"
> +		"  -o csv file to write data\n",
> +		program_name, nr_iterations);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	struct kvm_vm *vm;
> +	FILE *csv = NULL;
> +	int opt;
> +
> +	while ((opt = getopt(argc, argv, "hn:o:")) != -1) {
> +		switch (opt) {
> +		case 'o':
> +			csv = fopen(optarg, "w");
> +			if (!csv) {
> +				fprintf(stderr, "failed to open file '%s': %d\n",
> +					optarg, errno);
> +				exit(1);
> +			}
> +			break;
> +		case 'n':
> +			nr_iterations = strtoul(optarg, NULL, 0);
> +			break;
> +		default:
> +			fprintf(stderr, "unrecognized option: '-%c'\n", opt);
> +			/* fallthrough */
> +		case 'h':
> +			usage(argv[0]);
> +			exit(1);
> +		}
> +	}
> +
> +	vm = vm_create_default(VCPU_ID, 0, guest_main);
> +	sync_global_to_guest(vm, nr_iterations);
> +	ucall_init(vm, NULL);
> +
> +	if (_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
> +				  KVM_ARM_VCPU_TIMER_OFFSET_PTIMER)) {
> +		print_skip("KVM_ARM_VCPU_TIMER_OFFSET_PTIMER not supported.");
> +		exit(KSFT_SKIP);
> +	}
> +
> +	run_tests(vm, csv);
> +	kvm_vm_free(vm);
> +
> +	if (csv)
> +		fclose(csv);
> +}
> -- 
> 2.32.0.402.g57bb445576-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>

Thanks,
drew 

