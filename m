Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83951657029
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 23:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiL0WH3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 17:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiL0WH2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 17:07:28 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35131DEA0
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 14:07:26 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id k44-20020a9d19af000000b00683e176ab01so4007873otk.13
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 14:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6eKENyLUnBlxFelrrjXtLl/W/PIA/vKjhIr0gt4MRBo=;
        b=cDG1hXhB8fLm9+KyWVbcKeNInKZyesRjgT9vWR1ztAxarQDG9GuabojwuqowSIxzn9
         xXcJCXS5nBgtj0Cdr2aKB3YD7eMuCX64eRi8VwVpuW9v3DO6GoWJQFL2jOrvwWUFBe87
         9zfFco5S1RnPAyA0E1xJJ68lTkD0rSI8PIr27MA0XlsfLUUaLn0YZHMa8LA9qdIOjNZY
         22a/6vNBxxYCKwiJhpEzcKemrKvhkUTylEN23LUGUNr3CpDrii8Lv4KeSUuy8kKN+bex
         VR3iMT2C2Q7QwedhA6isV4btMxnLZEl0Oz0lkOXOBJ6HuJYQnRW+9ZcFlBX53Z9IDc9c
         WPNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6eKENyLUnBlxFelrrjXtLl/W/PIA/vKjhIr0gt4MRBo=;
        b=YNBszvOP3fiZaLvEpM/sdxCzl9wV5B/oTfuEac/n+5PyFTzESMlDz/m03CWduhxJkL
         IyWISwmpSeBw0GRdg6gje9g/4bLr+KN+ZDlq1/nCZZfxJFY9gy7pbkfzOGUaxMQAA9iB
         49VMAM4UknPoPtnfM0HXkAGK00HQbh5wJHTexKpo92+1t95pm0DqsoLL/SZlDgnACpoB
         tPVn9xNYZaG3Ysdc4q/hpF3ZORFwtSZOrV1nmCEuErG8Zg3RxFQ/GjeS8iH0NcLb7hBC
         pnRLg/67tQdHhWo+qe00H2s7fDQYBfiSQoe5Q5qXx0GEUGNn3ShhXKw+BGjCnklipGCB
         gRMg==
X-Gm-Message-State: AFqh2koFhcKRBn8YgK13Ju1ST5HxBZ4yz1G0vhm6fYdNggK064zpTUZ1
        OO7EOsSBOpSNfQd5HydzRqRjTKWkLLpZcbCwcmuRccaka+a59g==
X-Google-Smtp-Source: AMrXdXso3FCLqvnxce7UQ8Jh0ianfCvUcu0ZPZN9XoPTDFg6jKfOfgWaHF48BWBvr/OsK5l7XjkSxbYZu7B3S0fRI0w=
X-Received: by 2002:a9d:6d84:0:b0:66c:a613:9843 with SMTP id
 x4-20020a9d6d84000000b0066ca6139843mr1671234otp.8.1672178845297; Tue, 27 Dec
 2022 14:07:25 -0800 (PST)
MIME-Version: 1.0
References: <20221227183713.29140-1-aaronlewis@google.com> <20221227183713.29140-4-aaronlewis@google.com>
In-Reply-To: <20221227183713.29140-4-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 27 Dec 2022 14:07:14 -0800
Message-ID: <CALMp9eQD8EpS50A0iAxsoaW-_yFmWERWw6rbAh9VSEJjDrMkNQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: selftests: Add XCR0 Test
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        like.xu.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 27, 2022 at 10:38 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Test that the user xfeature bits, EDX:EAX of CPUID.(EAX=0DH,ECX=0),
> don't set up userspace for failure.
>
> Though it isn't architectural, test that the user xfeature bits aren't
> set in a half baked state that will cause a #GP if used when setting
> XCR0.
>
> Check that the rules for XCR0 described in the SDM vol 1, section
> 13.3 ENABLING THE XSAVE FEATURE SET AND XSAVE-ENABLED FEATURES, are
> followed for the xfeature bits too.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/x86_64/xcr0_cpuid_test.c    | 134 ++++++++++++++++++
>  2 files changed, 135 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 1750f91dd9362..e2e56c82b8a90 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -104,6 +104,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
>  TEST_GEN_PROGS_x86_64 += x86_64/xapic_ipi_test
>  TEST_GEN_PROGS_x86_64 += x86_64/xapic_state_test
> +TEST_GEN_PROGS_x86_64 += x86_64/xcr0_cpuid_test
>  TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
>  TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
>  TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
> diff --git a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
> new file mode 100644
> index 0000000000000..644791ff5c48b
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
> @@ -0,0 +1,134 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * XCR0 cpuid test
> + *
> + * Copyright (C) 2022, Google LLC.
> + */
> +
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +
> +#include "test_util.h"
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +
> +#define XFEATURE_MASK_SSE              (1ul << 1)
> +#define XFEATURE_MASK_YMM              (1ul << 2)
> +#define XFEATURE_MASK_BNDREGS          (1ul << 3)
> +#define XFEATURE_MASK_BNDCSR           (1ul << 4)
> +#define XFEATURE_MASK_OPMASK           (1ul << 5)
> +#define XFEATURE_MASK_ZMM_Hi256                (1ul << 6)
> +#define XFEATURE_MASK_Hi16_ZMM         (1ul << 7)
> +#define XFEATURE_MASK_XTILECFG         (1ul << 17)
> +#define XFEATURE_MASK_XTILEDATA                (1ul << 18)
> +#define XFEATURE_MASK_XTILE            (XFEATURE_MASK_XTILECFG | \
> +                                        XFEATURE_MASK_XTILEDATA)

With XSETBV hoisted into processor.h, shouldn't these macros be more
widely available as well?

> +static uint64_t get_supported_user_xfeatures(void)
> +{
> +       uint32_t a, b, c, d;
> +
> +       cpuid(0xd, &a, &b, &c, &d);
> +
> +       return a | ((uint64_t)d << 32);
> +}
> +
> +static void guest_code(void)
> +{
> +       uint64_t xcr0_rest;
> +       uint64_t supported_xcr0;
> +       uint64_t xfeature_mask;
> +       uint64_t supported_state;
> +
> +       set_cr4(get_cr4() | X86_CR4_OSXSAVE);
> +
> +       xcr0_rest = xgetbv(0);
> +       supported_xcr0 = get_supported_user_xfeatures();
> +
> +       GUEST_ASSERT(xcr0_rest == 1ul);
> +
> +       /* Check AVX */
> +       xfeature_mask = XFEATURE_MASK_SSE | XFEATURE_MASK_YMM;
> +       supported_state = supported_xcr0 & xfeature_mask;
> +       GUEST_ASSERT(supported_state != XFEATURE_MASK_YMM);
> +
> +       /* Check MPX */
> +       xfeature_mask = XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR;
> +       supported_state = supported_xcr0 & xfeature_mask;
> +       GUEST_ASSERT((supported_state == xfeature_mask) ||
> +                    (supported_state == 0ul));
> +
> +       /* Check AVX-512 */
> +       xfeature_mask = XFEATURE_MASK_OPMASK |
> +                       XFEATURE_MASK_ZMM_Hi256 |
> +                       XFEATURE_MASK_Hi16_ZMM;
> +       supported_state = supported_xcr0 & xfeature_mask;
> +       GUEST_ASSERT((supported_state == xfeature_mask) ||
> +                    (supported_state == 0ul));
> +
> +       /* Check AMX */
> +       xfeature_mask = XFEATURE_MASK_XTILE;
> +       supported_state = supported_xcr0 & xfeature_mask;
> +       GUEST_ASSERT((supported_state == xfeature_mask) ||
> +                    (supported_state == 0ul));

In this series, you've added code to __do_cpuid_func() to ensure that
XFEATURE_MASK_XTILECFG and XFEATURE_MASK_XTILEDATA can't be set unless
the other is set. Do we need to do something similar for AVX-512 and
MPX?

> +       GUEST_SYNC(0);
> +
> +       xsetbv(0, supported_xcr0);
> +
> +       GUEST_DONE();
> +}
> +
> +static void guest_gp_handler(struct ex_regs *regs)
> +{
> +       GUEST_ASSERT(!"Failed to set the supported xfeature bits in XCR0.");
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +       struct kvm_vcpu *vcpu;
> +       struct kvm_run *run;
> +       struct kvm_vm *vm;
> +       struct ucall uc;
> +
> +       TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XSAVE));
> +
> +       /* Tell stdout not to buffer its content */
> +       setbuf(stdout, NULL);
> +
> +       vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +       run = vcpu->run;
> +
> +       vm_init_descriptor_tables(vm);
> +       vcpu_init_descriptor_tables(vcpu);
> +
> +       while (1) {
> +               vcpu_run(vcpu);
> +
> +               TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +                           "Unexpected exit reason: %u (%s),\n",
> +                           run->exit_reason,
> +                           exit_reason_str(run->exit_reason));
> +
> +               switch (get_ucall(vcpu, &uc)) {
> +               case UCALL_SYNC:
> +                       vm_install_exception_handler(vm, GP_VECTOR,
> +                                                    guest_gp_handler);
> +                       break;
> +               case UCALL_ABORT:
> +                       REPORT_GUEST_ASSERT(uc);
> +                       break;
> +               case UCALL_DONE:
> +                       goto done;
> +               default:
> +                       TEST_FAIL("Unknown ucall %lu", uc.cmd);
> +               }
> +       }
> +
> +done:
> +       kvm_vm_free(vm);
> +       return 0;
> +}
> --
> 2.39.0.314.g84b9a713c41-goog
>
