Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1D26C84EC
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 19:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjCXSX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 14:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjCXSXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 14:23:55 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830FB5BBA
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 11:23:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-541942bfdccso26554077b3.14
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 11:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679682232;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5sa+gU+3qUwEmWNy48CwgWqEoKIn1PttS/Tvw1JyYDM=;
        b=qfSebCD6x9D8Cz9IxVHXMQjrApsaw9TZAyXdBj1VnVApuK25cn3bqLLYVzXkDTvUMC
         09u4viW04/cBmfX6ONsmnu1P/EhFNt5zJKGBP7j4FquobyvLfrZANc6vwCwyXAPiloJe
         twZr5vl7Sf5RkQWVz4i2DFq+GjoLgRx1azHlq6qK9Ow6yVY3hRtPCVShW667in3u+Xws
         JqpbS3vgRf0utIqu38WqCnA5Aeweev50ZQ+4tEMU7u29Md1X0QFkRbCzC+rGYw0n8iQJ
         eMzfXAt7PkOoTF/9fDn2ZY7ILo2jsXCBkE6KkS2AH4PXwmDcgrbr+9QKmZiZoCWh33He
         eMgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679682232;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5sa+gU+3qUwEmWNy48CwgWqEoKIn1PttS/Tvw1JyYDM=;
        b=niot2QpXC+riEWxCb0ozeak4VT35xDKEpPA2Lp1OYgF71YAKEieQB4xYQ3rf7G0ybA
         JaXpxsiL1OPhRyQbAa5hV9feVX2QLSwdxcY7KRpBuyS2qU8nnTdoHowYAEfueaMGhDjE
         gnHacX+kd1NU88YVMo4VL2YfAY+tUGFdjg/GOQg53sx5n0ZFmeJ01Fv/L8qHgeSo21K5
         Yxt4tZ1yPcOQrmoilkgjp03vuTI1gqUrbGGuZlwteiJ6tipo1YQAaq58ggsdCL31S4Jh
         LKWl3jiheigILtAYWWBpKnER5rc6Mw7HGfkpEOtW9DeA+R6521LF/tdEKH9QiNQkwrXB
         ZCGg==
X-Gm-Message-State: AAQBX9cZvYh1WyERsTIjrhNA5VB/VqJmHJeTjoBhHV0eQgfMaeaZvqH+
        jA7HmH6ZaU0+Vx4uy3q3cESqTSyD2yY=
X-Google-Smtp-Source: AKy350YptXv5e/SK7JPw38hYnWTWXHKFixyIpllVG7RkNf6SzE/NT34GjwF4+H3pfm8Ve23n9h4vHuNtB58=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1003:b0:b1d:5061:98e3 with SMTP id
 w3-20020a056902100300b00b1d506198e3mr2048173ybt.6.1679682232832; Fri, 24 Mar
 2023 11:23:52 -0700 (PDT)
Date:   Fri, 24 Mar 2023 11:23:51 -0700
In-Reply-To: <20230110175057.715453-8-pgonda@google.com>
Mime-Version: 1.0
References: <20230110175057.715453-1-pgonda@google.com> <20230110175057.715453-8-pgonda@google.com>
Message-ID: <ZB3qtwN2BtSDgU0Y@google.com>
Subject: Re: [PATCH V6 7/7] KVM: selftests: Add simple sev vm testing
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023, Peter Gonda wrote:
> A very simple of booting SEV guests that checks related CPUID bits. This
> is a stripped down version of "[PATCH v2 08/13] KVM: selftests: add SEV
> boot tests" from Michael but much simpler.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Ackerley Tng <ackerleytng@google.com>
> cc: Andrew Jones <andrew.jones@linux.dev>
> Suggested-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        | 84 +++++++++++++++++++
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../selftests/kvm/x86_64/sev_all_boot_test.c  | 84 +++++++++++++++++++
>  3 files changed, 169 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 6d9381d60172..6d826957c6ae 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -1,7 +1,91 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +<<<<<<< HEAD
>  *
>  !/**/
>  !*.c
>  !*.h
>  !*.S
>  !*.sh
> +=======

For the love of all that is holy, please take the time to actually look at what
you're posting.

> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index b7cfb15712d1..66d7ab3da990 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -111,6 +111,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_caps_test
>  TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
>  TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
> +TEST_GEN_PROGS_x86_64 += x86_64/sev_all_boot_test
>  TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
>  TEST_GEN_PROGS_x86_64 += x86_64/amx_test
>  TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
> diff --git a/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c b/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c
> new file mode 100644
> index 000000000000..e9e4d7305bc1
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c

"all_boot" is kinda odd.  Maybe just sev_basic_test?

> @@ -0,0 +1,84 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Basic SEV boot tests.
> + *
> + */

Meh, I'd leave off the comment, the testname should be pretty self-explanatory.

> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "svm_util.h"
> +#include "linux/psp-sev.h"
> +#include "sev.h"
> +
> +#define NR_SYNCS 1
> +
> +#define MSR_AMD64_SEV_BIT  1

msr-index.h exists in tools, use the defines from there.

> +
> +static void guest_run_loop(struct kvm_vcpu *vcpu)

Another pointless helper with one caller.  _If_ more subtests come along _and_
need this separate loop, then by all means.  But right now, it's just noise.

> +{
> +	struct ucall uc;
> +	int i;
> +
> +	for (i = 0; i <= NR_SYNCS; ++i) {

There's zero reason to cap the number of loops, and it can lead to false passes,
e.g. if the guest gets stuck on GUEST_SYNC() then this will pass.  Just do

	for (;;) {

> +		vcpu_run(vcpu);
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_SYNC:
> +			continue;
> +		case UCALL_DONE:
> +			return;
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +		default:
> +			TEST_FAIL("Unexpected exit: %s",
> +				  exit_reason_str(vcpu->run->exit_reason));
> +		}
> +	}
> +}
> +
> +static void is_sev_enabled(void)
> +{
> +	uint64_t sev_status;
> +
> +	GUEST_ASSERT(this_cpu_has(X86_FEATURE_SEV));
> +
> +	sev_status = rdmsr(MSR_AMD64_SEV);
> +	GUEST_ASSERT(sev_status & 0x1);
> +}
> +
> +static void guest_sev_code(void)
> +{
> +	GUEST_SYNC(1);
> +
> +	is_sev_enabled();

Again, completely unnecessary helper.  And is_blah_enabled() _strongly_ suggests
a pure function that returns true/false.

All in all, this can be slimmed down to:

// SPDX-License-Identifier: GPL-2.0-only
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>

#include "test_util.h"
#include "kvm_util.h"
#include "processor.h"
#include "svm_util.h"
#include "linux/psp-sev.h"
#include "sev.h"

static void guest_sev_code(void)
{
	GUEST_ASSERT(this_cpu_has(X86_FEATURE_SEV));
	GUEST_ASSERT(rdmsr(MSR_AMD64_SEV) & MSR_AMD64_SEV_ENABLED);

	GUEST_DONE();
}

static void test_sev(void *guest_code, uint64_t policy)
{
	struct kvm_vcpu *vcpu;
	struct kvm_vm *vm;
	struct ucall uc;
	int i;

	vm = vm_sev_create_with_one_vcpu(policy, guest_code, &vcpu);

	for (;;) {
		vcpu_run(vcpu);

		switch (get_ucall(vcpu, &uc)) {
		case UCALL_SYNC:
			continue;
		case UCALL_DONE:
			return;
		case UCALL_ABORT:
			REPORT_GUEST_ASSERT(uc);
		default:
			TEST_FAIL("Unexpected exit: %s",
				  exit_reason_str(vcpu->run->exit_reason));
		}
	}

	kvm_vm_free(vm);
}

int main(int argc, char *argv[])
{
	TEST_REQUIRE(is_kvm_sev_supported());

	test_sev(guest_sev_code, SEV_POLICY_NO_DBG);
	test_sev(guest_sev_code, 0);

	return 0;
}
