Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE275A504B
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 17:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiH2PjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 11:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiH2PjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 11:39:01 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10678A6CC
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 08:38:59 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id bx38so8409479ljb.10
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 08:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=qtzMJN2IhwIOKg+LEINBh2ep7v5OmXo7vf2/7aGCYLw=;
        b=Uou770Z69zcy9Fx491hC0/9hhWGQ5eEEbqSRe/YlCorX0tbOdNIUazpXYiYK8Of6Ol
         dC/EY0JbyhxTSGbA+pnZtzbggRVE/nHVKt/oQ4UN8/1oUYcxndBsxiCvusjqNp/lz/B8
         dNQ8kPplmMJZpkBjGEZ4iIrwy3pcW03sTp/65tKECv+EPgAygoLPl2KEfv8B/T277sEz
         6XvtDO3E8e4ALPfDD5XXu/98juMN2M/v/gtB3vkPZOBopuyYwuO9QT/vRsFPzyUPx2H+
         1j5jH254P5XYLaKqlLZMATHmRI8SCJXTwrMrR18BYhElKqiRRQyKBAFfVuwpnqr0d4/t
         DIUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=qtzMJN2IhwIOKg+LEINBh2ep7v5OmXo7vf2/7aGCYLw=;
        b=HZmohkfpo0FWq4y+BwFzwx9MSa4zn76moGuuLD+E9rIYjGqVmxYApQtiqmwHSVlQLe
         hNWWAxpODDpM7vyc/cqrh0TqOc+TW6Y2fTMGnkYxCY0HvWax9YJnHshyMkqg/ctnZ2No
         BR0ZOYoYONfkDf7rJ9c6xekjfVHv6SNiBfHjlvQaK9V8deMsnAbEKlb2nnuIWV7VIlrZ
         6sqhKRJ0EcibnLpKV1HD/Z0d0qjNvSiHLLyyPMYrsYPUdzrGKMwtEWxH+ybFxjCyNUKq
         dkSeTbj5K+9ezH9/zW7WWyujmTFFGhOZRMROIhNuKj3aICiXuuYEPPmjqK5K09umNViA
         EC0A==
X-Gm-Message-State: ACgBeo1a9JZ3fkP5zdhwk3nUo76CBG0zfA4LZTBcDGC0VTIMFHlePuVP
        OyHVXWmJkKxTR90wCTw25jZ5aYRwoQYMbQX+CPZI+g==
X-Google-Smtp-Source: AA6agR62YqFrZZsQGwicm8/fjP4Jpt/uuJYGWEFHNIbGeY3FG1XsTaQ6pSWykQej8AxLmdziTLzvGGo8QOdl7C5gCOA=
X-Received: by 2002:a2e:a552:0:b0:25e:6fa1:a6c4 with SMTP id
 e18-20020a2ea552000000b0025e6fa1a6c4mr5489880ljn.90.1661787537928; Mon, 29
 Aug 2022 08:38:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220810152033.946942-1-pgonda@google.com> <20220810152033.946942-12-pgonda@google.com>
 <Yv2GN1WPvi7K8LdI@google.com>
In-Reply-To: <Yv2GN1WPvi7K8LdI@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 29 Aug 2022 09:38:46 -0600
Message-ID: <CAMkAt6qo624CvoA==+umFJJtAiG4XOL277xOwwznZ9EmPzTxjw@mail.gmail.com>
Subject: Re: [V3 11/11] KVM: selftests: Add simple sev vm testing
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Orr <marcorr@google.com>,
        Michael Roth <michael.roth@amd.com>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 6:22 PM Sean Christopherson <seanjc@google.com> wrote:
>
> /sev_vm_launch_measurOn Wed, Aug 10, 2022, Peter Gonda wrote:
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/sev.h b/tools/testing/selftests/kvm/include/x86_64/sev.h
> > index 2f7f7c741b12..b6552ea1c716 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/sev.h
> > +++ b/tools/testing/selftests/kvm/include/x86_64/sev.h
> > @@ -22,6 +22,9 @@
> >  #define SEV_POLICY_NO_DBG    (1UL << 0)
> >  #define SEV_POLICY_ES                (1UL << 2)
> >
> > +#define CPUID_MEM_ENC_LEAF 0x8000001f
> > +#define CPUID_EBX_CBIT_MASK 0x3f
>
> Ha!  I was going to say "put these in processor.h", but I have an even better idea.
> I'll try to a series posted tomorrow (compile tested only at this point), but what
> I'm hoping to do is to allow automagic retrieval of multi-bit CPUID properties, a la
> the existing this_cpu_has() stuff.
>
> E.g.
>
>         #define X86_PROPERTY_CBIT_LOCATION              KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 0, 5)
>
> and then
>
>         sev->enc_bit = this_cpu_property(X86_PROPERTY_CBIT_LOCATION);
>
> LOL, now I see that the defines in sev.c were introduced back in patch 08.  That's
> probably fine for your submission so as not to take a dependency on the "property"
> idea.  This patch doesn't need to move the CPUID_* defines because it can use
> this_cpu_has(X86_FEATURE_SEV) and avoid referencing CPUID_MEM_ENC_LEAF.

OK I've put these into sev.c instead of the header. I can clean up
after you property patch series goes in.

>
> >  enum {
> >       SEV_GSTATE_UNINIT = 0,
> >       SEV_GSTATE_LUPDATE,
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing/selftests/kvm/lib/x86_64/sev.c
> > index 3abcf50c0b5d..8f9f55c685a7 100644
> > --- a/tools/testing/selftests/kvm/lib/x86_64/sev.c
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/sev.c
> > @@ -13,8 +13,6 @@
> >  #include "sev.h"
> >
> >  #define PAGE_SHIFT           12
>
> Already defined in processor.h

Removed

>
> > -#define CPUID_MEM_ENC_LEAF 0x8000001f
> > -#define CPUID_EBX_CBIT_MASK 0x3f
> >
> >  struct sev_vm {
> >       struct kvm_vm *vm;
> > diff --git a/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c b/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c
> > new file mode 100644
> > index 000000000000..b319d18bdb60
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c
> > @@ -0,0 +1,131 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Basic SEV boot tests.
> > + *
> > + * Copyright (C) 2021 Advanced Micro Devices
> > + */
> > +#define _GNU_SOURCE /* for program_invocation_short_name */
> > +#include <fcntl.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <sys/ioctl.h>
> > +
> > +#include "test_util.h"
> > +
> > +#include "kvm_util.h"
> > +#include "processor.h"
> > +#include "svm_util.h"
> > +#include "linux/psp-sev.h"
> > +#include "sev.h"
> > +
> > +#define VCPU_ID                      2
>
> Nooooooo.  Unless there is a really, REALLY good reason this needs to be '2', just
> pass '0' as a literal to vm_vcpu_add() and delete VCPU_ID.

Not needed, removed.

>
> > +#define PAGE_STRIDE          32
> > +
> > +#define SHARED_PAGES         8192
> > +#define SHARED_VADDR_MIN     0x1000000
> > +
> > +#define PRIVATE_PAGES                2048
> > +#define PRIVATE_VADDR_MIN    (SHARED_VADDR_MIN + SHARED_PAGES * PAGE_SIZE)
> > +
> > +#define TOTAL_PAGES          (512 + SHARED_PAGES + PRIVATE_PAGES)
> > +
> > +#define NR_SYNCS 1
> > +
> > +static void guest_run_loop(struct kvm_vcpu *vcpu)
> > +{
> > +     struct ucall uc;
> > +     int i;
> > +
> > +     for (i = 0; i <= NR_SYNCS; ++i) {
> > +             vcpu_run(vcpu);
> > +             switch (get_ucall(vcpu, &uc)) {
> > +             case UCALL_SYNC:
> > +                     continue;
> > +             case UCALL_DONE:
> > +                     return;
> > +             case UCALL_ABORT:
> > +                     TEST_ASSERT(false, "%s at %s:%ld\n\tvalues: %#lx, %#lx",
> > +                                 (const char *)uc.args[0], __FILE__,
> > +                                 uc.args[1], uc.args[2], uc.args[3]);
> > +             default:
> > +                     TEST_ASSERT(
> > +                             false, "Unexpected exit: %s",
> > +                             exit_reason_str(vcpu->run->exit_reason));
> > +             }
> > +     }
> > +}
> > +
> > +static void __attribute__((__flatten__)) guest_sev_code(void)
>
> Is __flatten__ strictly necessary?  I don't see this being copied over anything
> that would require it to be a contiguous chunk.

Nope, removed.

>
> > +{
> > +     uint32_t eax, ebx, ecx, edx;
> > +     uint64_t sev_status;
> > +
> > +     GUEST_SYNC(1);
> > +
> > +     cpuid(CPUID_MEM_ENC_LEAF, &eax, &ebx, &ecx, &edx);
> > +     GUEST_ASSERT(eax & (1 << 1));
>
>         GUEST_ASSERT(this_cpu_has(X86_FEATURE_SEV));

Done.

> > +
> > +     sev_status = rdmsr(MSR_AMD64_SEV);
> > +     GUEST_ASSERT((sev_status & 0x1) == 1);
> > +
> > +     GUEST_DONE();
> > +}
> > +
> > +static struct sev_vm *setup_test_common(void *guest_code, uint64_t policy,
> > +                                     struct kvm_vcpu **vcpu)
> > +{
> > +     uint8_t measurement[512];
> > +     struct sev_vm *sev;
> > +     struct kvm_vm *vm;
> > +     int i;
> > +
> > +     sev = sev_vm_create(policy, TOTAL_PAGES);
>
>         TEST_ASSERT(sev, ...) so that this doesn't silently "pass"?

Done.

>
> > +     if (!sev)
> > +             return NULL;
> > +     vm = sev_get_vm(sev);
> > +
> > +     /* Set up VCPU and initial guest kernel. */
> > +     *vcpu = vm_vcpu_add(vm, VCPU_ID, guest_code);
> > +     kvm_vm_elf_load(vm, program_invocation_name);
> > +
> > +     /* Allocations/setup done. Encrypt initial guest payload. */
> > +     sev_vm_launch(sev);
> > +
> > +     /* Dump the initial measurement. A test to actually verify it would be nice. */
> > +     sev_vm_launch_measure(sev, measurement);
> > +     pr_info("guest measurement: ");
> > +     for (i = 0; i < 32; ++i)
> > +             pr_info("%02x", measurement[i]);
> > +     pr_info("\n");
> > +
> > +     sev_vm_launch_finish(sev);
> > +
> > +     return sev;
> > +}
> > +
> > +static void test_sev(void *guest_code, uint64_t policy)
> > +{
> > +     struct sev_vm *sev;
> > +     struct kvm_vcpu *vcpu;
> > +
> > +     sev = setup_test_common(guest_code, policy, &vcpu);
> > +     if (!sev)
> > +             return;
>
> And with an assert above, this return goes away.  Or better yet, fold setup_test_common()
> into test_sev(), there's only the one user of the so called "common" function.

Done.

>
> > +
> > +     /* Guest is ready to run. Do the tests. */
> > +     guest_run_loop(vcpu);
> > +
> > +     pr_info("guest ran successfully\n");
> > +
> > +     sev_vm_free(sev);
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +     /* SEV tests */
> > +     test_sev(guest_sev_code, SEV_POLICY_NO_DBG);
> > +     test_sev(guest_sev_code, 0);
> > +
> > +     return 0;
> > +}
> > --
> > 2.37.1.559.g78731f0fdb-goog
> >
