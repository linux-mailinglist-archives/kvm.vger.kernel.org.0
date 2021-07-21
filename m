Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867663D1221
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 17:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239414AbhGUOhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 10:37:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239743AbhGUOhC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Jul 2021 10:37:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626880658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cjz/qY9rq3iPuIQlWrJrcTCNPSV381YIh1gROWvzlnA=;
        b=iZnNrWxAP+92P1XW8AwJY5WvkBaBbjEYo+Dukj/cwfTbZVBxvem6iitReyX4Ei90ssqGWl
        Y6L0441PSfVnA5UYFMErrx0hr65PBj3kcBiIaP1hV8Nud7LPFfT0yqq1yRaWs5RmDQaRkN
        0bNNCxAp56P5F4tRzAvrT7+zLGVssjo=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-2oDt8zurOMK9dNGkTC34YQ-1; Wed, 21 Jul 2021 11:17:37 -0400
X-MC-Unique: 2oDt8zurOMK9dNGkTC34YQ-1
Received: by mail-il1-f199.google.com with SMTP id a13-20020a92c54d0000b0290216ae9088ffso1769160ilj.9
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 08:17:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cjz/qY9rq3iPuIQlWrJrcTCNPSV381YIh1gROWvzlnA=;
        b=tRbtWu0yQP9YoDSSJjkpGEHy6Hx/eLX2/TQ9+XQFQmO2xai0QOrinG/vfc6MOifJp5
         xE0cD8H4qqU9rPz4Jk95n8V1ta5Gp3RKYet72tY3paeTDiWdvNh8AkhbwIRKkZj1/Ss+
         PVkgeSgFjoWVCq9cW/JmOe6Nky66NFap/6vSsMayUKwV+8urEgUq5mxfxxOszP1SitzE
         82R0bgtgRrzRWpTyUh1/6/P4qdtwYHRWGr/qyz+317qlwUi6+4jddUiPBknaB1C7KNpF
         ikUKjSQIhqTeMHkBN1Cgy/e4aDJDnLEwKWgxIY/vdeEd0ijcI4pzM6G3llkBZdBeqVLq
         CFrw==
X-Gm-Message-State: AOAM5327jAObXvQ9DakX+6ZFSDmdOF1PFjiOZKZ2TRGUNzt1PoOSIvr8
        rrbKULVX25oafhK6jYhuST96VcJMCR8pJg2GV89uY8HkwsNEx9tE0ZPCnxlB03vvhzYlc1hG2vT
        RoXPwWlEwWX9M
X-Received: by 2002:a5e:d508:: with SMTP id e8mr14388599iom.101.1626880656747;
        Wed, 21 Jul 2021 08:17:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJ0u39et2NnLlV6EWy3+1YIXupxf89Pzxvb2E5MW4TyugGAON0zndCG+fRuGJzVGbOohzoIQ==
X-Received: by 2002:a5e:d508:: with SMTP id e8mr14388578iom.101.1626880656539;
        Wed, 21 Jul 2021 08:17:36 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id x16sm12926397ila.84.2021.07.21.08.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 08:17:35 -0700 (PDT)
Date:   Wed, 21 Jul 2021 17:17:33 +0200
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
Subject: Re: [PATCH v2 07/12] selftests: KVM: Introduce system counter offset
 test
Message-ID: <20210721151733.6yj3lm3h2amwmgmf@gator>
References: <20210716212629.2232756-1-oupton@google.com>
 <20210716212629.2232756-8-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716212629.2232756-8-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 16, 2021 at 09:26:24PM +0000, Oliver Upton wrote:
> Introduce a KVM selftest to verify that userspace manipulation of the
> TSC (via the new vCPU attribute) results in the correct behavior within
> the guest.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |   1 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../kvm/system_counter_offset_test.c          | 133 ++++++++++++++++++
>  3 files changed, 135 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/system_counter_offset_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index d0877d01e771..2752813d5090 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -50,3 +50,4 @@
>  /set_memory_region_test
>  /steal_time
>  /kvm_binary_stats_test
> +/system_counter_offset_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index f7e24f334c6e..7bf2e5fb1d5a 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -83,6 +83,7 @@ TEST_GEN_PROGS_x86_64 += memslot_perf_test
>  TEST_GEN_PROGS_x86_64 += set_memory_region_test
>  TEST_GEN_PROGS_x86_64 += steal_time
>  TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
> +TEST_GEN_PROGS_x86_64 += system_counter_offset_test
>  
>  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
>  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
> new file mode 100644
> index 000000000000..7e9015770759
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
> @@ -0,0 +1,133 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2021, Google LLC.
> + *
> + * Tests for adjusting the system counter from userspace
> + */
> +#include <asm/kvm_para.h>
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
> +#ifdef __x86_64__
> +
> +struct test_case {
> +	uint64_t tsc_offset;
> +};
> +
> +static struct test_case test_cases[] = {
> +	{ 0 },
> +	{ 180 * NSEC_PER_SEC },
> +	{ -180 * NSEC_PER_SEC },
> +};
> +
> +static void check_preconditions(struct kvm_vm *vm)
> +{
> +	if (!_vcpu_has_device_attr(vm, VCPU_ID, KVM_VCPU_TSC_CTRL, KVM_VCPU_TSC_OFFSET))
> +		return;
> +
> +	print_skip("KVM_VCPU_TSC_OFFSET not supported; skipping test");
> +	exit(KSFT_SKIP);
> +}
> +
> +static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
> +{
> +	vcpu_access_device_attr(vm, VCPU_ID, KVM_VCPU_TSC_CTRL,
> +				KVM_VCPU_TSC_OFFSET, &test->tsc_offset, true);
> +}
> +
> +static uint64_t guest_read_system_counter(struct test_case *test)
> +{
> +	return rdtsc();
> +}
> +
> +static uint64_t host_read_guest_system_counter(struct test_case *test)
> +{
> +	return rdtsc() + test->tsc_offset;
> +}
> +
> +#else /* __x86_64__ */
> +
> +#error test not implemented for this architecture!
> +
> +#endif
> +
> +#define GUEST_SYNC_CLOCK(__stage, __val)			\
> +		GUEST_SYNC_ARGS(__stage, __val, 0, 0, 0)
> +
> +static void guest_main(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
> +		struct test_case *test = &test_cases[i];
> +
> +		GUEST_SYNC_CLOCK(i, guest_read_system_counter(test));
> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +static void handle_sync(struct ucall *uc, uint64_t start, uint64_t end)
> +{
> +	uint64_t obs = uc->args[2];
> +
> +	TEST_ASSERT(start <= obs && obs <= end,
> +		    "unexpected system counter value: %"PRIu64" expected range: [%"PRIu64", %"PRIu64"]",
> +		    obs, start, end);
> +
> +	pr_info("system counter value: %"PRIu64" expected range [%"PRIu64", %"PRIu64"]\n",
> +		obs, start, end);
> +}
> +
> +static void handle_abort(struct ucall *uc)
> +{
> +	TEST_FAIL("%s at %s:%ld", (const char *)uc->args[0],
> +		  __FILE__, uc->args[1]);
> +}
> +
> +static void enter_guest(struct kvm_vm *vm)
> +{
> +	uint64_t start, end;
> +	struct ucall uc;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
> +		struct test_case *test = &test_cases[i];
> +
> +		setup_system_counter(vm, test);
> +		start = host_read_guest_system_counter(test);
> +		vcpu_run(vm, VCPU_ID);
> +		end = host_read_guest_system_counter(test);
> +
> +		switch (get_ucall(vm, VCPU_ID, &uc)) {
> +		case UCALL_SYNC:
> +			handle_sync(&uc, start, end);
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
> +int main(void)
> +{
> +	struct kvm_vm *vm;
> +
> +	vm = vm_create_default(VCPU_ID, 0, guest_main);
> +	check_preconditions(vm);
> +	ucall_init(vm, NULL);
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

Reviewed-by: Andrew Jones <drjones@redhat.com>

