Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196EF620671
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 03:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbiKHCFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 21:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbiKHCFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 21:05:08 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610CD13CEE
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 18:05:07 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id j15so18789841wrq.3
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 18:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FUEPXHKzAMUHVmD4WvM6dOc560yHHvBZi3eb3Aooaf0=;
        b=PLHcG5fH4ho2jlxitjL9A00nNuuJPjoWfZkPJdkmCf+9vSj/QHFnAUsMyoPdrwQw5e
         Xoj0anXoEX67uDx3VlAWe/MDV6sJe8cKPlYWvBtuKPkq5JEgCuz1srm8ccE72kkByG17
         /Ho4AV2CsTZRLI2ZP3Nvc7WA0kW8CF/kl6Wx7ShSyuR+WaNL2fwPfgottAyap+0UGKEW
         OgfER170rd+rEQhzvfqbGrmZRdVyc8CBTURk7ReD2XGXydDGkqHs8rSgI+hCw+eH07Mk
         WMCwoVl9Of8HpI/MjsKkFT19o2rs/9o2jgDkMTjNa+FudEJXc5mzW+ZiMArem/NRr8Sd
         jVxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FUEPXHKzAMUHVmD4WvM6dOc560yHHvBZi3eb3Aooaf0=;
        b=CnHbies331cz7td8IMvsOGor1yNHJaxB46ri74UoAvv2HyPuMlh3AkI5sPDRYdS7j1
         a4SaYZAmXYZZT82qN5/b0TCQDTJ1V3yLED6hounessS1U16GhygDNfTdmUGI1Cc6mSNa
         9++kXtZqOIz21GZnow3vHlxzTTeN56sJc82tfKNm6XtTOiKrH4B0Bg1LVK/LqpdP0aCN
         ZXBegk6L4xS/4WdlsYr0VxJ4df37LlxHiqpWnGRf6DRt1T3pcuT4/A+BoBu6PtT91jQG
         w3ZhSuLkUpHvB95g+6m29ellpm89t2dTRwYoPtffcNWScSrzQhcfC4cvylZRnLpf+uAx
         9BDA==
X-Gm-Message-State: ACrzQf2HUIcSFraUk0yTqoa6ZrTu4AA8AZE14cFW8J3RzF9zW7cIF1Xm
        FOUHJEk2N3Zs9uczReBRgnhgXo9Cd1tmeiFsb7vpGw==
X-Google-Smtp-Source: AMsMyM47ozfThHqf8FTKFr4zFo99pM6oLeEwjH+kPw6CR9OGe1ZvFhFIHsFE6TGcCUB1HO8S0khEO8qXfw2Qsz//jQs=
X-Received: by 2002:adf:f081:0:b0:236:5e7c:4ec2 with SMTP id
 n1-20020adff081000000b002365e7c4ec2mr32735182wro.641.1667873105816; Mon, 07
 Nov 2022 18:05:05 -0800 (PST)
MIME-Version: 1.0
References: <20221105045704.2315186-1-vipinsh@google.com> <20221105045704.2315186-7-vipinsh@google.com>
 <Y2lWG7wV+UvzX5jm@google.com>
In-Reply-To: <Y2lWG7wV+UvzX5jm@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Mon, 7 Nov 2022 18:04:29 -0800
Message-ID: <CAHVum0eM7NtBDRFhXa9pk9DAEere1q4XVTUti2TFZuKPiGK6LQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] KVM: selftests: Test Hyper-V extended hypercall exit
 to userspace
To:     David Matlack <dmatlack@google.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Mon, Nov 7, 2022 at 11:01 AM David Matlack <dmatlack@google.com> wrote:
>
> On Fri, Nov 04, 2022 at 09:57:04PM -0700, Vipin Sharma wrote:
> > Hyper-V extended hypercalls by default exit to userspace. Verify
> > userspace gets the call, update the result and then guest verifies
> > result it received.
> >
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > ---
> >  tools/testing/selftests/kvm/.gitignore        |  1 +
> >  tools/testing/selftests/kvm/Makefile          |  1 +
> >  .../kvm/x86_64/hyperv_extended_hcalls.c       | 90 +++++++++++++++++++
> >  3 files changed, 92 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/x86_64/hyperv_extended_hcalls.c
> >
> > diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> > index 2f0d705db9db..ffe06dd1cc6e 100644
> > --- a/tools/testing/selftests/kvm/.gitignore
> > +++ b/tools/testing/selftests/kvm/.gitignore
> > @@ -24,6 +24,7 @@
> >  /x86_64/kvm_pv_test
> >  /x86_64/hyperv_clock
> >  /x86_64/hyperv_cpuid
> > +/x86_64/hyperv_extended_hcalls
>
> nit: Any reason not to name this hyperv_extended_hypercalls? It's not
> too long and as a non-Hyper-V developer it's easier to read.
>

I was keeping it consistent with other names like
KVM_EXIT_HYPERV_HCALL, and struct hcall{} in struct kvm_hyperv_exit{}.

I am fine with renaming it to hyperv_extended_hypercalls.

> >  /x86_64/hyperv_features
> >  /x86_64/hyperv_svm_test
> >  /x86_64/max_vcpuid_cap_test
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 0172eb6cb6ee..366345099363 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -85,6 +85,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/emulator_error_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_clock
> >  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
> > +TEST_GEN_PROGS_x86_64 += x86_64/hyperv_extended_hcalls
> >  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_features
> >  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
> > diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_extended_hcalls.c b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hcalls.c
> > new file mode 100644
> > index 000000000000..d378877235d4
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/x86_64/hyperv_extended_hcalls.c
> > @@ -0,0 +1,90 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Test Hyper-V extended hypercalls
>
> It would probably be worth adding a note in this comment that the
> negative tests for extended hypercalls live in hyperv_features.c, that
> way someone doesn't accidentally go down the rabbit hole of adding
> negative tests here in the future.
>

Sure.

> > + *
> > + * Copyright 2020 Google LLC
>
> 2022 :)
>
> > + * Author: Vipin Sharma <vipinsh@google.com>
> > + */
> > +
> > +#include "kvm_util.h"
> > +#include "processor.h"
> > +#include "hyperv.h"
> > +
> > +/* Any value is fine */
> > +#define EXT_CAPABILITIES 0xbull
> > +
> > +static void guest_code(vm_vaddr_t pgs_gpa, vm_vaddr_t output_pg_gva)
> > +{
> > +     uint64_t res, vector;
> > +     uint64_t *output_gva;
> > +
> > +     wrmsr(HV_X64_MSR_GUEST_OS_ID, hv_linux_guest_id());
> > +     wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
> > +
> > +     output_gva = (uint64_t *)output_pg_gva;
> > +
> > +     vector = hypercall(HV_EXT_CALL_QUERY_CAPABILITIES, pgs_gpa,
> > +                        pgs_gpa + 4096, &res);
> > +
> > +     GUEST_ASSERT_1(!vector, vector);
> > +     GUEST_ASSERT_2(res == HV_STATUS_SUCCESS, res, HV_STATUS_SUCCESS);
>
> GUEST_ASSERT_EQ(res, HV_STATUS_SUCCESS);
>

Copied things from hyperv_features test. This looks better, I will change it.

> > +
> > +     /* TLFS states output will be a uint64_t value */
> > +     GUEST_ASSERT_2(*output_gva == EXT_CAPABILITIES, *output_gva,
> > +                    EXT_CAPABILITIES);
>
> GUEST_ASSERT_EQ(*output_gva, EXT_CAPABILITIES);
>
> > +
> > +     GUEST_DONE();
> > +}
> > +
> > +static void guest_extended_hcall_test(void)
> > +{
> > +     struct kvm_vcpu *vcpu;
> > +     struct kvm_run *run;
> > +     struct kvm_vm *vm;
> > +     struct ucall uc;
> > +     vm_vaddr_t hcall_page;
> > +     uint64_t *outval;
> > +
> > +     vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> > +     run = vcpu->run;
> > +     vcpu_enable_cap(vcpu, KVM_CAP_HYPERV_ENFORCE_CPUID, 1);
> > +     vcpu_set_hv_cpuid(vcpu);
>
> Check if KVM offers HV_ENABLE_EXTENDED_HYPERCALLS in CPUID, and skip the
> test if not.
>

Sure.

> > +
> > +     /* Hypercall input/output */
> > +     hcall_page = vm_vaddr_alloc_pages(vm, 2);
> > +     memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
>
> s/getpagesize()/vm->page_size/
>
> > +     vcpu_args_set(vcpu, 2, addr_gva2gpa(vm, hcall_page), hcall_page + 4096);
>
> s/4096/vm->page_size/
>
> And to avoid hard-coding 4096 in guest_code(), you could pass in the GPA
> of the ouput page as another argument.
>

Sounds good.

> > +
> > +     vcpu_run(vcpu);
> > +
> > +     TEST_ASSERT((run->exit_reason == KVM_EXIT_HYPERV),
> > +                 "unexpected exit reason: %u (%s)", run->exit_reason,
> > +                 exit_reason_str(run->exit_reason));
> > +
> > +     outval = addr_gpa2hva(vm, run->hyperv.u.hcall.params[1]);
> > +     *outval = EXT_CAPABILITIES;
> > +     run->hyperv.u.hcall.result = HV_STATUS_SUCCESS;
> > +
> > +     vcpu_run(vcpu);
> > +
> > +     TEST_ASSERT((run->exit_reason == KVM_EXIT_IO),
> > +                 "unexpected exit reason: %u (%s)", run->exit_reason,
> > +                 exit_reason_str(run->exit_reason));
>
> Optional: Asserting a specific exit reason is a pretty common pattern in
> the x86 selftests. It'd be nice to create a common macro for it. e.g.
>
>         ASSERT_EXIT_REASON(vcpu, KVM_EXIT_IO);
>

This is much better. I can add a patch which creates this API.

Should it be run or vcpu? Seems like everything needed is in struct kvm_run{}.

> > +
> > +     switch (get_ucall(vcpu, &uc)) {
> > +     case UCALL_ABORT:
> > +             REPORT_GUEST_ASSERT_2(uc, "arg1 = %ld, arg2 = %ld");
> > +             break;
> > +     case UCALL_DONE:
> > +             break;
> > +     default:
> > +             TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
> > +     }
> > +
> > +     kvm_vm_free(vm);
> > +}
> > +
> > +int main(void)
> > +{
> > +     guest_extended_hcall_test();
>
> Why not just put all this in main()?
>

I will.

> > +}
>
> return 0?
>
> > --
> > 2.38.1.273.g43a17bfeac-goog
> >
