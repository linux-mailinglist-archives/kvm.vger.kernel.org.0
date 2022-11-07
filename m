Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F9B61FE20
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 20:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbiKGTCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 14:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbiKGTBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 14:01:53 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE8E25E9D
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 11:01:52 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id q9so11503735pfg.5
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 11:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q2n/Cgmsu8tKWQM5CKwHOZ+k/jvnspDL6f1qkBBQf1s=;
        b=YxAEdD0b+Q/TmeIUqoPf+dpK9tGqegysAV5+NNfc2Lzhpz/dBdZbv836WzVorwqhsw
         GjxsIrrqxnMLWqYizTaxjPOl2+9MScvinuCtP05crs7ltOJ4969hw9DLgc87S0mLABlV
         O3HWbJj9vPR4/JzMU68SyWIX/FopN9otiGAA35uEZWqu6RCpzpqzF1mEega+WDqcHEzz
         Ru+Uyw22x8kXd8a1DLrganMfuO7aJXDq4BlNhxxCsE/RHzBkxlamQ0zAZrk3tIqbu7de
         nPzFLZpRjrferCFsB7JvsR52Bf0sqBm40Zaf+ZsQTnnUtZ8W53g0FUaqoT0R85l1AKJs
         9x9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q2n/Cgmsu8tKWQM5CKwHOZ+k/jvnspDL6f1qkBBQf1s=;
        b=QdNp+T8pXTEIWa3i72JlIpti6RETNSj5XfvmK+Tb+1UFoB8wA6tc/FEzdKpUiXkoWP
         SEKsYNiIlsnQiP9HY7VtC2XTLMAY3V5xgFvvoyvnGYQy7xOp328moTJPLi3VjnqUqay2
         T6GBwx+vzd9Gr5ddCZ5PmSekTQpOCb0PomjGtg15KjysfkDJVFdYc1w97RvKOorCCeY7
         uyGb17TQbHPbX6X46WE7yTVmE0XzTISilaRCe9JzcfJlW6qiWzeewzrKatD9/AxkbPvS
         AP+0rQWsdNfOBhOP/2auLzw+jcRxoatl9mjXT8KNHgQSyM3cwpUcM8kH2Z2Fi+QMhNkW
         0w4A==
X-Gm-Message-State: ACrzQf08T4CfpMWWpKfdlfOVOkAuUzGEI3AivnqvpbN38YZjvPdKxnUM
        hJi73JlNL2FsyhXlWD7Rz8j/iw==
X-Google-Smtp-Source: AMsMyM4xNtJ2CH54SFvz8Guktw6dN7N0mSOjTjYsn4OpfDdfMeQFupcqleUmK0w7g75UCvX+taqvfg==
X-Received: by 2002:a05:6a00:1c92:b0:56d:643e:e116 with SMTP id y18-20020a056a001c9200b0056d643ee116mr43112334pfw.15.1667847712011;
        Mon, 07 Nov 2022 11:01:52 -0800 (PST)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id s10-20020aa78bca000000b0056bc5ad4862sm4800647pfd.28.2022.11.07.11.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 11:01:51 -0800 (PST)
Date:   Mon, 7 Nov 2022 11:01:47 -0800
From:   David Matlack <dmatlack@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] KVM: selftests: Test Hyper-V extended hypercall exit
 to userspace
Message-ID: <Y2lWG7wV+UvzX5jm@google.com>
References: <20221105045704.2315186-1-vipinsh@google.com>
 <20221105045704.2315186-7-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221105045704.2315186-7-vipinsh@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 04, 2022 at 09:57:04PM -0700, Vipin Sharma wrote:
> Hyper-V extended hypercalls by default exit to userspace. Verify
> userspace gets the call, update the result and then guest verifies
> result it received.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |  1 +
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../kvm/x86_64/hyperv_extended_hcalls.c       | 90 +++++++++++++++++++
>  3 files changed, 92 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_extended_hcalls.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 2f0d705db9db..ffe06dd1cc6e 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -24,6 +24,7 @@
>  /x86_64/kvm_pv_test
>  /x86_64/hyperv_clock
>  /x86_64/hyperv_cpuid
> +/x86_64/hyperv_extended_hcalls

nit: Any reason not to name this hyperv_extended_hypercalls? It's not
too long and as a non-Hyper-V developer it's easier to read.

>  /x86_64/hyperv_features
>  /x86_64/hyperv_svm_test
>  /x86_64/max_vcpuid_cap_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 0172eb6cb6ee..366345099363 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -85,6 +85,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/emulator_error_test
>  TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
> +TEST_GEN_PROGS_x86_64 += x86_64/hyperv_extended_hcalls
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
>  TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hcalls.c b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hcalls.c
> new file mode 100644
> index 000000000000..d378877235d4
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hcalls.c
> @@ -0,0 +1,90 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Test Hyper-V extended hypercalls

It would probably be worth adding a note in this comment that the
negative tests for extended hypercalls live in hyperv_features.c, that
way someone doesn't accidentally go down the rabbit hole of adding
negative tests here in the future.

> + *
> + * Copyright 2020 Google LLC

2022 :)

> + * Author: Vipin Sharma <vipinsh@google.com>
> + */
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "hyperv.h"
> +
> +/* Any value is fine */
> +#define EXT_CAPABILITIES 0xbull
> +
> +static void guest_code(vm_vaddr_t pgs_gpa, vm_vaddr_t output_pg_gva)
> +{
> +	uint64_t res, vector;
> +	uint64_t *output_gva;
> +
> +	wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
> +	wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
> +
> +	output_gva = (uint64_t *)output_pg_gva;
> +
> +	vector = hypercall(HV_EXT_CALL_QUERY_CAPABILITIES, pgs_gpa,
> +			   pgs_gpa + 4096, &res);
> +
> +	GUEST_ASSERT_1(!vector, vector);
> +	GUEST_ASSERT_2(res == HV_STATUS_SUCCESS, res, HV_STATUS_SUCCESS);

GUEST_ASSERT_EQ(res, HV_STATUS_SUCCESS);

> +
> +	/* TLFS states output will be a uint64_t value */
> +	GUEST_ASSERT_2(*output_gva == EXT_CAPABILITIES, *output_gva,
> +		       EXT_CAPABILITIES);

GUEST_ASSERT_EQ(*output_gva, EXT_CAPABILITIES);

> +
> +	GUEST_DONE();
> +}
> +
> +static void guest_extended_hcall_test(void)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_run *run;
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +	vm_vaddr_t hcall_page;
> +	uint64_t *outval;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +	run = vcpu->run;
> +	vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
> +	vcpu_set_hv_cpuid(vcpu);

Check if KVM offers HV_ENABLE_EXTENDED_HYPERCALLS in CPUID, and skip the
test if not.

> +
> +	/* Hypercall input/output */
> +	hcall_page = vm_vaddr_alloc_pages(vm, 2);
> +	memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());

s/getpagesize()/vm->page_size/

> +	vcpu_args_set(vcpu, 2, addr_gva2gpa(vm, hcall_page), hcall_page + 4096);

s/4096/vm->page_size/

And to avoid hard-coding 4096 in guest_code(), you could pass in the GPA
of the ouput page as another argument.

> +
> +	vcpu_run(vcpu);
> +
> +	TEST_ASSERT((run->exit_reason == KVM_EXIT_HYPERV),
> +		    "unexpected exit reason: %u (%s)", run->exit_reason,
> +		    exit_reason_str(run->exit_reason));
> +
> +	outval = addr_gpa2hva(vm, run->hyperv.u.hcall.params[1]);
> +	*outval = EXT_CAPABILITIES;
> +	run->hyperv.u.hcall.result = HV_STATUS_SUCCESS;
> +
> +	vcpu_run(vcpu);
> +
> +	TEST_ASSERT((run->exit_reason == KVM_EXIT_IO),
> +		    "unexpected exit reason: %u (%s)", run->exit_reason,
> +		    exit_reason_str(run->exit_reason));

Optional: Asserting a specific exit reason is a pretty common pattern in
the x86 selftests. It'd be nice to create a common macro for it. e.g.

	ASSERT_EXIT_REASON(vcpu, KVM_EXIT_IO);

> +
> +	switch (get_ucall(vcpu, &uc)) {
> +	case UCALL_ABORT:
> +		REPORT_GUEST_ASSERT_2(uc, "arg1 = %ld, arg2 = %ld");
> +		break;
> +	case UCALL_DONE:
> +		break;
> +	default:
> +		TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
> +	}
> +
> +	kvm_vm_free(vm);
> +}
> +
> +int main(void)
> +{
> +	guest_extended_hcall_test();

Why not just put all this in main()?

> +}

return 0?

> -- 
> 2.38.1.273.g43a17bfeac-goog
> 
