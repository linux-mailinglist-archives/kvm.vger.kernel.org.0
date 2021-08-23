Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E1B3F52E5
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 23:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhHWVg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 17:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbhHWVgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Aug 2021 17:36:55 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3C4C061757
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 14:36:12 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id s16so18475998ilo.9
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 14:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rUyor/8q1SI5iCRnQ5Kwgmmr9Mseym+7axVhkjht0GE=;
        b=HF6Q8dZ8mP9h8rsXIYySetmtOoT7Vti6I7Ll+WHD710DDgG+MO4/JgQ7av7o010xPl
         eqXhv1hgxujJL6oyW5WF/CAJSZkd6kPvpbGIbk72bSDIybLKaDrTHHvB97i2Duq9ddC+
         vxJtxRNJ4Y631BwDnBExMJc/1lKMAb55G79SOPPhSsbbvDbRLSxjJxXq/AokrSCdioVe
         wUfnbxNCDGEFTF2t6DT4r9/jiX6ag9P52aO19FZkDH0/hpbJ2Su3iiXoGZGZ19RyUFYz
         KdKosC4n+qkWv8aYSr3bdJX4U/lVc6J+KOa8n1pw6ZnS7onw1pmOAwfFJsDW1xKHfz4z
         O74Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rUyor/8q1SI5iCRnQ5Kwgmmr9Mseym+7axVhkjht0GE=;
        b=ropehSPX6sUtbvxVIFvNKV1IIfCpW+cdUb5OfqvCqhqVfpkPmn3/Y1U73ppFozGQfL
         6XIo1JsuNST9WjsuJq9YCB4LSsP4CUFXo2R5co507LNUURtAr4IPQboP1hI3OkSYvcGK
         ds0d+5wmn5Fci1fWNxPbtp0MO3PTJzEd2cLVXbQeF9mp+ujKW3WSDfdtiypSixwUaCT9
         JR1ioJdtLhQvdsNlVfDnqQSM4UopT+ME/qFSQNb3MOltZbqLorjmBYpro1OeS49BmBVE
         1i3Noy86QdLkgELVG9gUx9XH1Jl8vse8CaouHmBJKiKurBdowPMFePs2xN62rFsZsO09
         VDZg==
X-Gm-Message-State: AOAM5338sHpMKSdJeaB9WrjESaUEu2WqOQNSZ+0S0ZF8dopcGkTzCEaV
        e/aDfo+gOsBQgETUYU+pujkTy7CjbDySDzCUTGUD/w==
X-Google-Smtp-Source: ABdhPJz64VTbI8K3vCETm17kYUoctYMa5AA//lXav0B8n3XNKE+glANT+1Vcia5FNIt/kvg6pcFF0ujXLIl/TX60xWQ=
X-Received: by 2002:a05:6e02:524:: with SMTP id h4mr24493282ils.203.1629754572221;
 Mon, 23 Aug 2021 14:36:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210823051622.312890-1-mizhang@google.com>
In-Reply-To: <20210823051622.312890-1-mizhang@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 23 Aug 2021 14:36:01 -0700
Message-ID: <CANgfPd9RR+a675MgLuyy6g-Ab-4jSHVV+mwxJnwOHCiC6KgAhA@mail.gmail.com>
Subject: Re: [PATCH] selftests: KVM: use dirty logging to check if page stats
 work correctly
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>, Ben Gardon <bgorden@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 22, 2021 at 10:16 PM Mingwei Zhang <mizhang@google.com> wrote:
>
> When dirty logging is enabled, KVM splits the all hugepage mapping in
> NPT/EPT into the smallest 4K size. This property could be used to check if
> the page stats metrics work properly in KVM mmu. At the same time, this
> logic might be used the other way around: using page stats to verify if
> dirty logging really splits all huge pages.

This isn't quite right for upstream.
Internally at Google we eagerly split all large page mappings when
enabling dirty logging, but upstream the large page mappings are just
write protected and then lazily split in response to vCPU writes.
This makes it difficult to make assertions about the number of large /
4k page mappings right after enabling dirty logging, but we can make
those assertions after the vCPUs have written to each page of memory,
as you did below.

>
> So add page stats checking in dirty logging performance selftest. In
> particular, add checks in three locations:
>  - just after vm is created;
>  - after populating memory into vm but before enabling dirty logging;
>  - after turning off dirty logging.

I think you mean after turning ON dirty logging here, but I think it
should be "after turning on dirty logging and waiting for vCPUs to
write to all their memory"
I don't think we can make 100% certain assertions about the mapping
counts after disabling dirty logging. It'd probably be safe to assert
that the counts are non-zero though. Or wait for a pass after
disabling dirty logging and check that the counts return to more or
less what they were before dirty logging was enabled.

>
> Tested using commands:
>  - ./dirty_log_perf_test -s anonymous_hugetlb_1gb
>  - ./dirty_log_perf_test -s anonymous_thp
>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Matlack <dmatlack@google.com>
> Cc: Jing Zhang <jingzhangos@google.com>
> Cc: Peter Xu <peterx@redhat.com>
>
> Suggested-by: Ben Gardon <bgorden@google.com>

Woops :)

> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  .../selftests/kvm/dirty_log_perf_test.c       | 30 +++++++++++++++++++
>  .../testing/selftests/kvm/include/test_util.h |  1 +
>  .../selftests/kvm/lib/perf_test_util.c        |  3 ++
>  tools/testing/selftests/kvm/lib/test_util.c   | 29 ++++++++++++++++++
>  4 files changed, 63 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 3c30d0045d8d..e190f6860166 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -19,6 +19,10 @@
>  #include "perf_test_util.h"
>  #include "guest_modes.h"
>
> +#ifdef __x86_64__
> +#include "processor.h"
> +#endif
> +
>  /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
>  #define TEST_HOST_LOOP_N               2UL
>
> @@ -166,6 +170,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
>                                  p->slots, p->backing_src);
>

It might be worth adding a comment explaining these assertions. E.g.
"No vCPUs have been started yet, so KVM should not have created any
mappings."

> +#ifdef __x86_64__
> +       TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_4K) == 0,
> +                   "4K page is non zero");
> +       TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_2M) == 0,
> +                   "2M page is non zero");
> +       TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_1G) == 0,
> +                   "1G page is non zero");
> +#endif
>         perf_test_args.wr_fract = p->wr_fract;
>
>         guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
> @@ -211,6 +223,16 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         pr_info("Populate memory time: %ld.%.9lds\n",
>                 ts_diff.tv_sec, ts_diff.tv_nsec);
>
> +#ifdef __x86_64__
> +       TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_4K) != 0,
> +                   "4K page is zero");
> +       if (p->backing_src == VM_MEM_SRC_ANONYMOUS_THP)
> +               TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_2M) != 0,
> +                           "2M page is zero");
> +       if (p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB)
> +               TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_1G) != 0,
> +                           "1G page is zero");
> +#endif

This check is correct, but it misses some cases. It'd be worth going
back to ensure that all relevant backing src types are handled here.
For example, this misses VM_MEM_SRC_ANONYMOUS_HUGETLB_2MB.

We could also be more precise by asserting that the counts are at
least some value or total to some value. THP introduces some flakiness
but one way or another the mapping counts at this point should total
up to account for the expected size of guest memory.

>         /* Enable dirty logging */
>         clock_gettime(CLOCK_MONOTONIC, &start);
>         enable_dirty_logging(vm, p->slots);
> @@ -256,6 +278,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                                 iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
>                 }
>         }
> +#ifdef __x86_64__
> +       TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_4K) != 0,
> +                   "4K page is zero after dirty logging");
> +       TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_2M) == 0,
> +                   "2M page is non-zero after dirty logging");
> +       TEST_ASSERT(get_page_stats(X86_PAGE_SIZE_1G) == 0,
> +                   "1G page is non-zero after dirty logging");
> +#endif
>
>         /* Disable dirty logging */
>         clock_gettime(CLOCK_MONOTONIC, &start);
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index d79be15dd3d2..dca5fcf7aa87 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -102,6 +102,7 @@ const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(uint32_t i);
>  size_t get_backing_src_pagesz(uint32_t i);
>  void backing_src_help(void);
>  enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name);
> +size_t get_page_stats(uint32_t page_level);
>
>  /*
>   * Whether or not the given source type is shared memory (as opposed to
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 0ef80dbdc116..c2c532990fb0 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -96,6 +96,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>  #ifdef __s390x__
>         /* Align to 1M (segment size) */
>         guest_test_phys_mem &= ~((1 << 20) - 1);
> +#elif __x86_64__
> +       /* Align to 1G (segment size) to allow hugepage mapping. */
> +       guest_test_phys_mem &= ~((1 << 30) - 1);
>  #endif

This should be a separate commit. It could probably also be
arch-agnostic and just replace the s390 alignment above too.

>         pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
>
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index af1031fed97f..07eb6b5c125e 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -15,6 +15,13 @@
>  #include "linux/kernel.h"
>
>  #include "test_util.h"
> +#include "processor.h"
> +
> +static const char * const pagestat_filepaths[] = {
> +       "/sys/kernel/debug/kvm/pages_4k",
> +       "/sys/kernel/debug/kvm/pages_2m",
> +       "/sys/kernel/debug/kvm/pages_1g",
> +};
>
>  /*
>   * Parses "[0-9]+[kmgt]?".
> @@ -141,6 +148,28 @@ size_t get_trans_hugepagesz(void)
>         return size;
>  }
>
> +#ifdef __x86_64__
> +size_t get_stats_from_file(const char *path)
> +{
> +       size_t value;
> +       FILE *f;
> +
> +       f = fopen(path, "r");
> +       TEST_ASSERT(f != NULL, "Error in opening file: %s\n", path);
> +
> +       fscanf(f, "%ld", &value);
> +       fclose(f);
> +
> +       return value;
> +}
> +
> +size_t get_page_stats(uint32_t page_level)
> +{
> +       TEST_ASSERT(page_level <= X86_PAGE_SIZE_1G, "page type error.");
> +       return get_stats_from_file(pagestat_filepaths[page_level]);
> +}
> +#endif
> +
>  size_t get_def_hugetlb_pagesz(void)
>  {
>         char buf[64];
> --
> 2.33.0.rc2.250.ged5fa647cd-goog
>
