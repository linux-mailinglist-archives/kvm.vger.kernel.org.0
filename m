Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A884F8551
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 18:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345862AbiDGQzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 12:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbiDGQzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 12:55:08 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECA463BF7
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 09:53:07 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id x131so10578077ybe.11
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 09:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L3Dd+P2g38/w2YOBvMoRWTN4BwvuSs+hqZexviAv7/Q=;
        b=MVGOAPXcz1EpFRY0XjrNe3feNoA85tcka9Rgll5WS0+gK7wgvGS5SeBNLBdhHiasxS
         TBISqO2gQ0OG/GN8MUrhN9MlvuKtBqiP/zcpE/qpDVuVlkkzpoPk+1Bl2HL/tTH1/l7h
         vGBbvDnx2XR5d/tkGX7DAOeBhO3nLVOl/Vkuy+NXz7fxAUyIurf4diiWaDZmjF9Hv6hE
         vAnQbMc8/M/gZF+CF4ACw/AgqBZHswtgZ2QSBpyHANqeU2gCfOPzq7yemVn+3blYKRak
         wApaFbqX+lMiAnAV4BUsyXcXedrv4d2hvU10lB5W6mv0FAobkVAtoCulomx39mj0IlEH
         3PyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L3Dd+P2g38/w2YOBvMoRWTN4BwvuSs+hqZexviAv7/Q=;
        b=eOzivATX0JgIAqrxBswUbjzavCdvprKMGM+jx7BK6/tK7GS53Y/kKkvmePZjJz0JeN
         PwhR667zjcHcNEUVJ6lcAAiYRZI4IRn32ZCnmrNI5mz9lqEKDOzXM7FucYVtGiOlPwyp
         eg1VJimQKA8WdcGlAxkjnCqyN+IbsJZjnckQ9lXcdKwHh6YbUSrMg83la6nmR+J/pOaW
         0AuopnUFUDBg5cqaGvcd3umIvAdMHA35Abxv8VrYwgwGjsm7br5wLxf9NJWZl4tGfPHZ
         oSCzZimiWe2xACCYkwLUz2ZgjKwFsDkliHpCMjZWU9xzMGKBtGaYIDidXmXhSnXIByRP
         Q9vg==
X-Gm-Message-State: AOAM5302MDr77BrQ9c7MQbrEDI9K0clWMzFtFtslFy/IDRTtSrtuyWmj
        M7Qrq2E4/Iae/GuRT9l2kBanFbeKiiGjxNcTHkfnHA==
X-Google-Smtp-Source: ABdhPJx2WUXX4U6252qtESTlyIuoxr2WM725CDomF1ww+2Dp0QGdo8bpNHKsasiV2thlqGZWiehFuPYzfUs++TMdzoM=
X-Received: by 2002:a25:e689:0:b0:63e:4f58:d27 with SMTP id
 d131-20020a25e689000000b0063e4f580d27mr3816581ybh.341.1649350368103; Thu, 07
 Apr 2022 09:52:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220330174621.1567317-1-bgardon@google.com> <20220330174621.1567317-7-bgardon@google.com>
 <YkzE9Kf0q6oWUoi5@google.com>
In-Reply-To: <YkzE9Kf0q6oWUoi5@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 7 Apr 2022 09:52:37 -0700
Message-ID: <CANgfPd-8vCbvGis3S2yCumF=SsMDdGQ_ur4rajFSe2bFQ9DfYg@mail.gmail.com>
Subject: Re: [PATCH v3 06/11] KVM: selftests: Add NX huge pages test
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
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 5, 2022 at 3:38 PM David Matlack <dmatlack@google.com> wrote:
>
> On Wed, Mar 30, 2022 at 10:46:16AM -0700, Ben Gardon wrote:
> > There's currently no test coverage of NX hugepages in KVM selftests, so
> > add a basic test to ensure that the feature works as intended.
> >
> > Reviewed-by: David Dunn <daviddunn@google.com>
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   7 +-
> >  .../kvm/lib/x86_64/nx_huge_pages_guest.S      |  45 ++++++
> >  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 133 ++++++++++++++++++
> >  .../kvm/x86_64/nx_huge_pages_test.sh          |  25 ++++
> >  4 files changed, 209 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/kvm/lib/x86_64/nx_huge_pages_guest.S
> >  create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> >  create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index c9cdbd248727..c671224cf755 100644
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
> > @@ -57,6 +57,8 @@ TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/mmu_role_test
> > +TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
> > +TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
>
> Suggest brearking TEST_PROGS and TEST_GEN_PROGS_EXTENDED out into their
> own separate blocks with newlines in between. They capture different
> types of files so I think it makes sense to separate them in the
> Makefile. I expect both lists will grow over time so the awkwardness of
> having them off on their lonesome is temporary :).
>
> It'd also be nice to have some comments above each explaining when they
> should be used. A short blurb is fine since the selftest documentation
> is the authority.

Will do.

>
> >  TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
> > @@ -141,7 +143,9 @@ TEST_GEN_PROGS_riscv += kvm_page_table_test
> >  TEST_GEN_PROGS_riscv += set_memory_region_test
> >  TEST_GEN_PROGS_riscv += kvm_binary_stats_test
> >
> > +TEST_PROGS += $(TEST_PROGS_$(UNAME_M))
> >  TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
> > +TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(UNAME_M))
> >  LIBKVM += $(LIBKVM_$(UNAME_M))
> >
> >  INSTALL_HDR_PATH = $(top_srcdir)/usr
> > @@ -192,6 +196,7 @@ $(OUTPUT)/libkvm.a: $(LIBKVM_OBJS)
> >  x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
> >  all: $(STATIC_LIBS)
> >  $(TEST_GEN_PROGS): $(STATIC_LIBS)
> > +$(TEST_GEN_PROGS_EXTENDED): $(STATIC_LIBS)
> >
> >  cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
> >  cscope:
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
>
> What do you think about my idea in [1] of using ret instructions and
> function pointers to trigger execution on an arbitrary page? That would
> avoid the need for this assembly file and we could probably share the
> code between our tests.
>
> Feel free to take the idea and incorporate it directly if you agree, and
> I'll rebase on top, since you're series is further along than mine.
>
> [1] https://lore.kernel.org/kvm/20220401233737.3021889-2-dmatlack@google.com/
>

Sigh, it means I have to rewrite a lot of the test, but it is the
better way to write this test.

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
>
> So we give it an extra 50ms? That should probably be enough but I'm
> paranoid so I'd probably bump it up to 500 ms.

Will do.

>
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
> > 2.35.1.1021.g381101b075-goog
> >
