Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6C74EA2F9
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 00:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiC1WT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 18:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiC1WTv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 18:19:51 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2856165D32
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 15:17:40 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2db2add4516so165284247b3.1
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 15:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HlzHnAB+DkmHC29zDgjcUDTmmN26ykYVSroGA/4Zdtw=;
        b=byEqOtoQCkaUX7NCZl/dyQLS8bl7uXnfWbp3NnlOTpwEbQSF2NneIOCbmVjrOYZ8lH
         yUeHyqvS4GE5CgutHCCmNZEKkjGu+uNiNibetefHkv+kN6GCT8/QXwawstXjdsPzLMNZ
         oaaCz3s6ZR1zFJfBtlhv4UsgA2FCpslTEd6dI42/v48Ymsj2lfcdZcwI7WXSriOiuC2S
         J+qbvKl2fLVNGj5nqODiZ7gxfiGf2QwRm7I5JEaHuIOQ1gxRJ2iratpEYAFGSeLeqk66
         rhoXJgPGFjzOevlyTJKjt9/B5oI9LnfAVHGaMD5dOpCUrbQZTuCyMiy7EO98zbfc35mA
         0/JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HlzHnAB+DkmHC29zDgjcUDTmmN26ykYVSroGA/4Zdtw=;
        b=A6bkm8ZiknoBN+KIRvBUNttuWyWpSpH6tjzIwmaEw1IRFoD+JTNi9h99QyX8QGwWGq
         31RN2asL/IUmwPcqGIk+JPKubwi5D2o3pJK8Ss/JmAcOTWexT4dyeO9LP0Cvlh8Y/mUE
         YCxQoPhfEAFDOqLGI3znX8N9pjkaAaESvVEP2TWjFYXOJkcU2nGlIIIeCitaV5E3m8Ce
         TIG3VyImzstUkmmP3VyIyaIARq76X/PwdIzewvUBrs2o2VC6UETLHI0UQuNLR0m6YhqL
         MHd4oCYTvmmC1Gs29IoemvZ7G+LQe0wyogbQ9kIK3LJxRY5XDW0MATe161Zwx9F8RgmX
         4jpQ==
X-Gm-Message-State: AOAM5305E1HPsVNwnVBG7pFnN7q9R9x6P6JCXM+Vqt4AQxCBJj2Lpcl/
        3FGK0S91nt646DY6x/CccxDwaYZMsBzLyfcpSyP89A==
X-Google-Smtp-Source: ABdhPJzaA21lYo0IR0rgyTPFFwxXQ5ehzsABJkFVJt46iQRr9T7gnDQyB44x84FPmWaSA/qiKkY5GmYHJxKSZa0WL74=
X-Received: by 2002:a81:15ce:0:b0:2e5:e189:7366 with SMTP id
 197-20020a8115ce000000b002e5e1897366mr28498284ywv.188.1648505858953; Mon, 28
 Mar 2022 15:17:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220321234844.1543161-1-bgardon@google.com> <20220321234844.1543161-7-bgardon@google.com>
 <YkIFCHFBOy+VIllw@google.com>
In-Reply-To: <YkIFCHFBOy+VIllw@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 28 Mar 2022 15:17:27 -0700
Message-ID: <CANgfPd9NG5cKWrq=tFmnsE1MnPaek+w6wLtdpKqVSg3W1QNMnQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/11] KVM: selftests: Add NX huge pages test
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 28, 2022 at 11:57 AM David Matlack <dmatlack@google.com> wrote:
>
> On Mon, Mar 21, 2022 at 04:48:39PM -0700, Ben Gardon wrote:
> > There's currently no test coverage of NX hugepages in KVM selftests, so
> > add a basic test to ensure that the feature works as intended.
> >
> > Reviewed-by: David Dunn <daviddunn@google.com>
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   3 +-
> >  .../kvm/lib/x86_64/nx_huge_pages_guest.S      |  45 ++++++
> >  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 133 ++++++++++++++++++
> >  .../kvm/x86_64/nx_huge_pages_test.sh          |  25 ++++
> >  4 files changed, 205 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/kvm/lib/x86_64/nx_huge_pages_guest.S
> >  create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> >  create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 04099f453b59..6ee30c0df323 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -38,7 +38,7 @@ ifeq ($(ARCH),riscv)
> >  endif
> >
> >  LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
> > -LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
> > +LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S lib/x86_64/nx_huge_pages_guest.S
> >  LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c
> >  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
> >  LIBKVM_riscv = lib/riscv/processor.c lib/riscv/ucall.c
> > @@ -56,6 +56,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/mmu_role_test
> > +TEST_GEN_PROGS_x86_64 += x86_64/nx_huge_pages_test
>
> This will make the selftest infrastructure treat nx_huge_pages_test as
> the selftest that gets run by default (e.g. if someone runs `make
> kselftest`). But you actually want nx_huge_pages_test.sh to be the
> selftest that gets run (nx_huge_pages_test is really just a helper
> binary). Is that correct?
>
> Take a look at [1] for how to set this up. Specifically I think you want
> to move nx_huge_pages_test to TEST_GEN_PROGS_EXTENDED and add
> nx_huge_pages_test.sh to TEST_PROGS.
>
> I'd love to have the infrastructure in place for doing this because I've
> been wanting to add some shell script wrappers for dirty_log_perf_test
> to set up HugeTLBFS and invoke it with various different arguments.
>
> [1] https://www.kernel.org/doc/html/latest/dev-tools/kselftest.html#contributing-new-tests-details

Oh awesome, thank you for the tip! I'll try that.

>
> >  TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
> > diff --git a/tools/testing/selftests/kvm/lib/x86_64/nx_huge_pages_guest.S b/tools/testing/selftests/kvm/lib/x86_64/nx_huge_pages_guest.S
> > new file mode 100644
> > index 000000000000..09c66b9562a3
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/lib/x86_64/nx_huge_pages_guest.S
> > @@ -0,0 +1,45 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * tools/testing/selftests/kvm/nx_huge_page_guest.S
> > + *
> > + * Copyright (C) 2022, Google LLC.
> > + */
> > +
> > +.include "kvm_util.h"
> > +
> > +#define HPAGE_SIZE   (2*1024*1024)
> > +#define PORT_SUCCESS 0x70
> > +
> > +.global guest_code0
> > +.global guest_code1
> > +
> > +.align HPAGE_SIZE
> > +exit_vm:
> > +     mov    $0x1,%edi
> > +     mov    $0x2,%esi
> > +     mov    a_string,%edx
> > +     mov    $0x1,%ecx
> > +     xor    %eax,%eax
> > +     jmp    ucall
> > +
> > +
> > +guest_code0:
> > +     mov data1, %eax
> > +     mov data2, %eax
> > +     jmp exit_vm
> > +
> > +.align HPAGE_SIZE
> > +guest_code1:
> > +     mov data1, %eax
> > +     mov data2, %eax
> > +     jmp exit_vm
> > +data1:
> > +.quad        0
> > +
> > +.align HPAGE_SIZE
> > +data2:
> > +.quad        0
> > +a_string:
> > +.string "why does the ucall function take a string argument?"
> > +
> > +
> > diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > new file mode 100644
> > index 000000000000..2bcbe4efdc6a
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > @@ -0,0 +1,133 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * tools/testing/selftests/kvm/nx_huge_page_test.c
> > + *
> > + * Usage: to be run via nx_huge_page_test.sh, which does the necessary
> > + * environment setup and teardown
> > + *
> > + * Copyright (C) 2022, Google LLC.
> > + */
> > +
> > +#define _GNU_SOURCE
> > +
> > +#include <fcntl.h>
> > +#include <stdint.h>
> > +#include <time.h>
> > +
> > +#include <test_util.h>
> > +#include "kvm_util.h"
> > +
> > +#define HPAGE_SLOT           10
> > +#define HPAGE_PADDR_START       (10*1024*1024)
> > +#define HPAGE_SLOT_NPAGES    (100*1024*1024/4096)
> > +
> > +/* Defined in nx_huge_page_guest.S */
> > +void guest_code0(void);
> > +void guest_code1(void);
> > +
> > +static void run_guest_code(struct kvm_vm *vm, void (*guest_code)(void))
> > +{
> > +     struct kvm_regs regs;
> > +
> > +     vcpu_regs_get(vm, 0, &regs);
> > +     regs.rip = (uint64_t)guest_code;
> > +     vcpu_regs_set(vm, 0, &regs);
> > +     vcpu_run(vm, 0);
> > +}
> > +
> > +static void check_2m_page_count(struct kvm_vm *vm, int expected_pages_2m)
> > +{
> > +     int actual_pages_2m;
> > +
> > +     actual_pages_2m = vm_get_single_stat(vm, "pages_2m");
> > +
> > +     TEST_ASSERT(actual_pages_2m == expected_pages_2m,
> > +                 "Unexpected 2m page count. Expected %d, got %d",
> > +                 expected_pages_2m, actual_pages_2m);
> > +}
> > +
> > +static void check_split_count(struct kvm_vm *vm, int expected_splits)
> > +{
> > +     int actual_splits;
> > +
> > +     actual_splits = vm_get_single_stat(vm, "nx_lpage_splits");
> > +
> > +     TEST_ASSERT(actual_splits == expected_splits,
> > +                 "Unexpected nx lpage split count. Expected %d, got %d",
> > +                 expected_splits, actual_splits);
> > +}
> > +
> > +int main(int argc, char **argv)
> > +{
> > +     struct kvm_vm *vm;
> > +     struct timespec ts;
> > +
> > +     vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
> > +
> > +     vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
> > +                                 HPAGE_PADDR_START, HPAGE_SLOT,
> > +                                 HPAGE_SLOT_NPAGES, 0);
> > +
> > +     kvm_vm_elf_load_memslot(vm, program_invocation_name, HPAGE_SLOT);
> > +
> > +     vm_vcpu_add_default(vm, 0, guest_code0);
> > +
> > +     check_2m_page_count(vm, 0);
> > +     check_split_count(vm, 0);
> > +
> > +     /*
> > +      * Running guest_code0 will access data1 and data2.
> > +      * This should result in part of the huge page containing guest_code0,
> > +      * and part of the hugepage containing the ucall function being mapped
> > +      * at 4K. The huge pages containing data1 and data2 will be mapped
> > +      * at 2M.
> > +      */
> > +     run_guest_code(vm, guest_code0);
> > +     check_2m_page_count(vm, 2);
> > +     check_split_count(vm, 2);
> > +
> > +     /*
> > +      * guest_code1 is in the same huge page as data1, so it will cause
> > +      * that huge page to be remapped at 4k.
> > +      */
> > +     run_guest_code(vm, guest_code1);
> > +     check_2m_page_count(vm, 1);
> > +     check_split_count(vm, 3);
> > +
> > +     /* Run guest_code0 again to check that is has no effect. */
> > +     run_guest_code(vm, guest_code0);
> > +     check_2m_page_count(vm, 1);
> > +     check_split_count(vm, 3);
> > +
> > +     /*
> > +      * Give recovery thread time to run. The wrapper script sets
> > +      * recovery_period_ms to 100, so wait 1.5x that.
> > +      */
> > +     ts.tv_sec = 0;
> > +     ts.tv_nsec = 150000000;
> > +     nanosleep(&ts, NULL);
> > +
> > +     /*
> > +      * Now that the reclaimer has run, all the split pages should be gone.
> > +      */
> > +     check_2m_page_count(vm, 1);
> > +     check_split_count(vm, 0);
> > +
> > +     /*
> > +      * The split 2M pages should have been reclaimed, so run guest_code0
> > +      * again to check that pages are mapped at 2M again.
> > +      */
> > +     run_guest_code(vm, guest_code0);
> > +     check_2m_page_count(vm, 2);
> > +     check_split_count(vm, 2);
> > +
> > +     /* Pages are once again split from running guest_code1. */
> > +     run_guest_code(vm, guest_code1);
> > +     check_2m_page_count(vm, 1);
> > +     check_split_count(vm, 3);
> > +
> > +     kvm_vm_free(vm);
> > +
> > +     return 0;
> > +}
> > +
> > diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> > new file mode 100755
> > index 000000000000..19fc95723fcb
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> > @@ -0,0 +1,25 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-only */
> > +
> > +# tools/testing/selftests/kvm/nx_huge_page_test.sh
> > +# Copyright (C) 2022, Google LLC.
> > +
> > +NX_HUGE_PAGES=$(cat /sys/module/kvm/parameters/nx_huge_pages)
> > +NX_HUGE_PAGES_RECOVERY_RATIO=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio)
> > +NX_HUGE_PAGES_RECOVERY_PERIOD=$(cat /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms)
> > +HUGE_PAGES=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
> > +
> > +echo 1 > /sys/module/kvm/parameters/nx_huge_pages
> > +echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> > +echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
> > +echo 200 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> > +
> > +./nx_huge_pages_test
> > +RET=$?
> > +
> > +echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
> > +echo $NX_HUGE_PAGES_RECOVERY_RATIO > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> > +echo $NX_HUGE_PAGES_RECOVERY_PERIOD > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
> > +echo $HUGE_PAGES > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
> > +
> > +exit $RET
> > --
> > 2.35.1.894.gb6a874cedc-goog
> >
