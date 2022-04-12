Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71FEF4FEAC3
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 01:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiDLX0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 19:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiDLXZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 19:25:50 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313B6D0AB4
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 15:11:40 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id g34so554930ybj.1
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 15:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dX18XFalO+5VRFUdL43U3k+dLLK5yTyJYa4I3YIVqFk=;
        b=SZzVp3DiGHF/EmA93oedd5W0ZwZxJvYUA4uhia5KPqw5TlJOuV/zlLTuonzvhic+8h
         gHPhA5+Tm9AB9KK3iNwb9YmaWLxVlTGyGmcqbuNROIv0UcKJCYbsODAg6cYmAGctN1sb
         +tMTF3LkjiD31iA6yXQiJONetagtF8LEUaAJbBE5BBlnE55Um+sZOYxOjtuhiwenmawh
         EQ6C3n8F2UMZJUbVRnbEFT93/8bTEOmoLqUaE7VAntwwQ2q/Y77ieI3YcfEgx+kKBBbM
         C8ZbICQ1TbZlX8lAegdszx26QJs2hNsbkVknTliia2UzvjdDdfi7BH+WA+m6TxYcSauO
         moLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dX18XFalO+5VRFUdL43U3k+dLLK5yTyJYa4I3YIVqFk=;
        b=gQrlYZ/t34koM4UXOsPPuLH+Lq92rfQf5Ow7EPVF3xSQq+7oEIb/2x+/htxo2pqZOi
         OxxuLZ5bGuqYBaA2iEyaFFpPv8eH3PMM0pbIYDx/5foycSs3ksgWgBDdh2koAwCjI9M3
         VMneQc7PPVdMtDakc3O4t/syGx9R1x2j60mfKCB15/MuJRMYRjJ2ozsLddo2Qt1FKfwf
         Arteq3vsqQ501zr1Ra0Adco8uh3Du9S+ZFkCh37lbDFR+jW6aNtVWDjx2wExGFZgchh6
         SGmagmAyrYcYKtoChJ/alEh58lRhR1Cn6tIfMhphpCX9G5UsIwpUoXLpHJ1+CMmtvsVr
         crAQ==
X-Gm-Message-State: AOAM532ZyGg5FhszDmr0iB+vi3YY7BtNL0ioC6h1rnBBIloEokMoA1tq
        pC9Eyd2fBIC+H5zuFMjCm48pyJnJ7G1YDzuFgIXE+A==
X-Google-Smtp-Source: ABdhPJx51dk0/yi7K6qi1ODlhJqq6Bxgi1t20BM2QV7c9CcQnX06JjUNSYiIQ8QmJtoiZ2zR93TTbTwdYuuEZn8Lvyo=
X-Received: by 2002:a25:4094:0:b0:641:2b90:3b1a with SMTP id
 n142-20020a254094000000b006412b903b1amr11908457yba.8.1649801499111; Tue, 12
 Apr 2022 15:11:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220411211015.3091615-1-bgardon@google.com> <20220411211015.3091615-6-bgardon@google.com>
 <CALzav=dbvmuWk9SiscbnWd3hVOpHu7LhcJYC2eiaXEpfsxDrvw@mail.gmail.com>
In-Reply-To: <CALzav=dbvmuWk9SiscbnWd3hVOpHu7LhcJYC2eiaXEpfsxDrvw@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 12 Apr 2022 15:11:28 -0700
Message-ID: <CANgfPd9BTomA6w9seMwAerjMjtceT95pajokpnHbp+wBjuMAxg@mail.gmail.com>
Subject: Re: [PATCH v4 05/10] KVM: selftests: Add NX huge pages test
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>
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

On Mon, Apr 11, 2022 at 3:28 PM David Matlack <dmatlack@google.com> wrote:
>
> On Mon, Apr 11, 2022 at 2:10 PM Ben Gardon <bgardon@google.com> wrote:
> >
> > There's currently no test coverage of NX hugepages in KVM selftests, so
> > add a basic test to ensure that the feature works as intended.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |  10 ++
> >  .../selftests/kvm/include/kvm_util_base.h     |   1 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c    |  48 ++++++
> >  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 163 ++++++++++++++++++
> >  .../kvm/x86_64/nx_huge_pages_test.sh          |  25 +++
> >  5 files changed, 247 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> >  create mode 100755 tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index af582d168621..9bb9bce4df37 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -43,6 +43,10 @@ LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handler
> >  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
> >  LIBKVM_riscv = lib/riscv/processor.c lib/riscv/ucall.c
> >
> > +# Non-compiled test targets
> > +TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
> > +
> > +# Compiled test targets
> >  TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
> > @@ -104,6 +108,9 @@ TEST_GEN_PROGS_x86_64 += steal_time
> >  TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
> >  TEST_GEN_PROGS_x86_64 += system_counter_offset_test
> >
> > +# Compiled outputs used by test targets
> > +TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
> > +
> >  TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
> >  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
> >  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> > @@ -142,7 +149,9 @@ TEST_GEN_PROGS_riscv += kvm_page_table_test
> >  TEST_GEN_PROGS_riscv += set_memory_region_test
> >  TEST_GEN_PROGS_riscv += kvm_binary_stats_test
> >
> > +TEST_PROGS += $(TEST_PROGS_$(UNAME_M))
> >  TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
> > +TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(UNAME_M))
> >  LIBKVM += $(LIBKVM_$(UNAME_M))
> >
> >  INSTALL_HDR_PATH = $(top_srcdir)/usr
> > @@ -193,6 +202,7 @@ $(OUTPUT)/libkvm.a: $(LIBKVM_OBJS)
> >  x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
> >  all: $(STATIC_LIBS)
> >  $(TEST_GEN_PROGS): $(STATIC_LIBS)
> > +$(TEST_GEN_PROGS_EXTENDED): $(STATIC_LIBS)
> >
> >  cscope: include_paths = $(LINUX_TOOL_INCLUDE) $(LINUX_HDR_PATH) include lib ..
> >  cscope:
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index b2684cfc2cb1..f9c2ac0a5b97 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -408,6 +408,7 @@ void read_vm_stats_desc(int stats_fd, struct kvm_stats_header *header,
> >  int read_stat_data(int stats_fd, struct kvm_stats_header *header,
> >                    struct kvm_stats_desc *desc, uint64_t *data,
> >                    ssize_t max_elements);
> > +uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name);
> >
> >  uint32_t guest_get_vcpuid(void);
> >
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 64e2085f1129..833c7e63d62d 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -2614,3 +2614,51 @@ int read_stat_data(int stats_fd, struct kvm_stats_header *header,
> >
> >         return ret;
> >  }
> > +
> > +static int vm_get_stat_data(struct kvm_vm *vm, const char *stat_name,
> > +                           uint64_t *data, ssize_t max_elements)
> > +{
> > +       struct kvm_stats_desc *stats_desc;
> > +       struct kvm_stats_header header;
> > +       struct kvm_stats_desc *desc;
> > +       size_t size_desc;
> > +       int stats_fd;
> > +       int ret = -EINVAL;
> > +       int i;
> > +
> > +       stats_fd = vm_get_stats_fd(vm);
> > +
> > +       read_vm_stats_header(stats_fd, &header);
> > +
> > +       stats_desc = alloc_vm_stats_desc(stats_fd, &header);
> > +       read_vm_stats_desc(stats_fd, &header, stats_desc);
>
> This is a fair bit of redundant work to do when reading every stat.
> Reading stats in selftests is probably not going to be
> performance-senstive, but it should be pretty easy to move everything
> above to VM initialization and storing the outputs in struct kvm_vm
> for access during this function.
>

That's true, but for now I'm just going to leave this as-is. If we
have a case where it is performance sensitive, we can look at
optimizing the stats collection for that case.

> > +
> > +       size_desc = sizeof(struct kvm_stats_desc) + header.name_size;
> > +
> > +       /* Read kvm stats data one by one */
> > +       for (i = 0; i < header.num_desc; ++i) {
> > +               desc = (void *)stats_desc + (i * size_desc);
> > +
> > +               if (strcmp(desc->name, stat_name))
> > +                       continue;
> > +
> > +               ret = read_stat_data(stats_fd, &header, desc, data,
> > +                                    max_elements);
> > +       }
> > +
> > +       free(stats_desc);
> > +       close(stats_fd);
> > +       return ret;
> > +}
> > +
> > +uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name)
>
> nit: I'd prefer the simpler "vm_get_stat()". The function signature
> already makes it clear we're reading one stat value. And when we add
> more support for more complicated stats (e.g.
> vm_get_histogram_stat()), I think "vm_get_stat()" will still work for
> reading single value stats.

Will do.

>
> > +{
> > +       uint64_t data;
> > +       int ret;
> > +
> > +       ret = vm_get_stat_data(vm, stat_name, &data, 1);
> > +       TEST_ASSERT(ret == 1,
> > +                   "Stat %s expected to have 1 element, but %d returned",
> > +                   stat_name, ret);
> > +       return data;
> > +}
> > diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > new file mode 100644
> > index 000000000000..3f21726b22c7
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> > @@ -0,0 +1,163 @@
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
> > +#define HPAGE_SLOT             10
> > +#define HPAGE_GVA              (23*1024*1024)
> > +#define HPAGE_GPA              (10*1024*1024)
> > +#define HPAGE_SLOT_NPAGES      (512 * 3)
> > +#define PAGE_SIZE              4096
> > +
> > +/*
> > + * When writing to guest memory, write the opcode for the `ret` instruction so
> > + * that subsequent iteractions can exercise instruction fetch by calling the
> > + * memory.
>
> I think this comment needs to be reworded to better fit this test.
>

Woops, will do.

>
> > + */
> > +#define RETURN_OPCODE 0xC3
> > +
> > +void guest_code(void)
> > +{
> > +       uint64_t hpage_1 = HPAGE_GVA;
> > +       uint64_t hpage_2 = hpage_1 + (PAGE_SIZE * 512);
> > +       uint64_t hpage_3 = hpage_2 + (PAGE_SIZE * 512);
> > +
> > +       READ_ONCE(*(uint64_t *)hpage_1);
> > +       GUEST_SYNC(1);
> > +
> > +       READ_ONCE(*(uint64_t *)hpage_2);
> > +       GUEST_SYNC(2);
> > +
> > +       ((void (*)(void)) hpage_1)();
> > +       GUEST_SYNC(3);
> > +
> > +       ((void (*)(void)) hpage_3)();
> > +       GUEST_SYNC(4);
> > +
> > +       READ_ONCE(*(uint64_t *)hpage_1);
> > +       GUEST_SYNC(5);
> > +
> > +       READ_ONCE(*(uint64_t *)hpage_3);
> > +       GUEST_SYNC(6);
> > +}
> > +
> > +static void check_2m_page_count(struct kvm_vm *vm, int expected_pages_2m)
> > +{
> > +       int actual_pages_2m;
> > +
> > +       actual_pages_2m = vm_get_single_stat(vm, "pages_2m");
> > +
> > +       TEST_ASSERT(actual_pages_2m == expected_pages_2m,
> > +                   "Unexpected 2m page count. Expected %d, got %d",
> > +                   expected_pages_2m, actual_pages_2m);
> > +}
> > +
> > +static void check_split_count(struct kvm_vm *vm, int expected_splits)
> > +{
> > +       int actual_splits;
> > +
> > +       actual_splits = vm_get_single_stat(vm, "nx_lpage_splits");
> > +
> > +       TEST_ASSERT(actual_splits == expected_splits,
> > +                   "Unexpected nx lpage split count. Expected %d, got %d",
> > +                   expected_splits, actual_splits);
> > +}
> > +
> > +int main(int argc, char **argv)
> > +{
> > +       struct kvm_vm *vm;
> > +       struct timespec ts;
> > +       void *hva;
> > +
> > +       vm = vm_create_default(0, 0, guest_code);
> > +
> > +       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
> > +                                   HPAGE_GPA, HPAGE_SLOT,
> > +                                   HPAGE_SLOT_NPAGES, 0);
> > +
> > +       virt_map(vm, HPAGE_GVA, HPAGE_GPA, HPAGE_SLOT_NPAGES);
> > +
> > +       hva = addr_gpa2hva(vm, HPAGE_GPA);
> > +       memset(hva, RETURN_OPCODE, HPAGE_SLOT_NPAGES * PAGE_SIZE);
> > +
> > +       check_2m_page_count(vm, 0);
> > +       check_split_count(vm, 0);
> > +
> > +       /*
> > +        * The guest code will first read from the first hugepage, resulting
> > +        * in a huge page mapping being created.
> > +        */
> > +       vcpu_run(vm, 0);
> > +       check_2m_page_count(vm, 1);
> > +       check_split_count(vm, 0);
> > +
> > +       /*
> > +        * Then the guest code will read from the second hugepage, resulting
> > +        * in another huge page mapping being created.
> > +        */
> > +       vcpu_run(vm, 0);
> > +       check_2m_page_count(vm, 2);
> > +       check_split_count(vm, 0);
> > +
> > +       /*
> > +        * Next, the guest will execute from the first huge page, causing it
> > +        * to be remapped at 4k.
> > +        */
> > +       vcpu_run(vm, 0);
> > +       check_2m_page_count(vm, 1);
> > +       check_split_count(vm, 1);
> > +
> > +       /*
> > +        * Executing from the third huge page (previously unaccessed) will
> > +        * cause part to be mapped at 4k.
> > +        */
> > +       vcpu_run(vm, 0);
> > +       check_2m_page_count(vm, 1);
> > +       check_split_count(vm, 2);
> > +
> > +       /* Reading from the first huge page again should have no effect. */
> > +       vcpu_run(vm, 0);
> > +       check_2m_page_count(vm, 1);
> > +       check_split_count(vm, 2);
> > +
> > +       /*
> > +        * Give recovery thread time to run. The wrapper script sets
> > +        * recovery_period_ms to 100, so wait 5x that.
> > +        */
> > +       ts.tv_sec = 0;
> > +       ts.tv_nsec = 500000000;
> > +       nanosleep(&ts, NULL);
> > +
> > +       /*
> > +        * Now that the reclaimer has run, all the split pages should be gone.
> > +        */
> > +       check_2m_page_count(vm, 1);
> > +       check_split_count(vm, 0);
> > +
> > +       /*
> > +        * The 4k mapping on hpage 3 should have been removed, so check that
> > +        * reading from it causes a huge page mapping to be installed.
> > +        */
> > +       vcpu_run(vm, 0);
> > +       check_2m_page_count(vm, 2);
> > +       check_split_count(vm, 0);
> > +
> > +       kvm_vm_free(vm);
> > +
> > +       return 0;
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
> > 2.35.1.1178.g4f1659d476-goog
> >
