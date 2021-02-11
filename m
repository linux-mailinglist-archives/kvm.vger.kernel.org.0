Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9684F31830E
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 02:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhBKB11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 20:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhBKB1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 20:27:24 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A3EC0613D6
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 17:26:44 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id q9so3738474ilo.1
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 17:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6tiT0juHAG7LVhaT0F44eBAB2bgXNLxaZJxsTDj1mbs=;
        b=DzFjxy3gEGVjFmul7he+A/bOAPNHqHCEpK7zDeTHeubgSfCEbNv1/rsyTH9m3Xl86H
         NMEtdIluV0GqiwdmX98XLyOc5yqMTZLlI9uQ+wJYr9oBv5JzOm6Q3bD60Ri2IcOIBEYc
         0zmBLZZYY7C94JynijcgF+N1wtDFnHkggQL+vw+CdUQEla/Ipl676x55wAchbgJBHEfN
         0Gm3KztQw29iQizfFb+/VAwxSpvjfh+jYpizz0wnNmK6xmggJdv5cK9d67vvrb2K9rmn
         k04TTtP03eWbY6kpNnKCbQNxO4fKd9EqDm6/qltBOse7KzGiArN8/rqJ2jnBeeYqG8sa
         UnXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6tiT0juHAG7LVhaT0F44eBAB2bgXNLxaZJxsTDj1mbs=;
        b=OJAHNHE/CTbsGaZ/aOQSxObPK4VdqsWuv38BN4tkDT2PW4EcQcXb7I8lB5jkLQg91n
         D40xf5HAAKdKZtr31Lc0mCuHmLuPh3j508Iw+ieR55/N5mCFtotuG7Wui2vLdSh4Lz/7
         0LxsKIpGWowrLjAfKkHzZXGuzy1eCXBnmNTm9pNMs2a+zd12LH6zMHCBo7IxskHG6NwL
         oOi2ewkE+8lRHw5NHrlrI4MpKa+sCfPdfv0nbCSedzPKavY6IcR4s1pKYIBsZa37gdWE
         A0uJnUnodksiKdWN2a8fHRgjgyiVMF/pzMLTrSeO3PFrfpM9KBFlV77e1k/jt/zgbJZG
         2eJQ==
X-Gm-Message-State: AOAM530SFh9oJFaCPd8UKDtlDIsZ1l50nxj5bJ/9gmXnN/FkvxJubVyG
        Y4D48RyW2Z4GOuwLv08w/2LAe59cx5EHQTBdfLcASF/+ICKrAQ==
X-Google-Smtp-Source: ABdhPJw+5V9QRIUiMsbYFXylIMP7U2FjMFoDHK7Od/aASZsK9vB0RImYeHNWQKIGYWgwqeY2viuQSQeZYLjUSnNs6U8=
X-Received: by 2002:a92:c54e:: with SMTP id a14mr1190089ilj.285.1613006803830;
 Wed, 10 Feb 2021 17:26:43 -0800 (PST)
MIME-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com> <20210210230625.550939-11-seanjc@google.com>
In-Reply-To: <20210210230625.550939-11-seanjc@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Feb 2021 17:26:33 -0800
Message-ID: <CANgfPd8PVLh0-+s5R6A_AXG6XZvo0GbEFrAu1zASWgeP_Zy4LQ@mail.gmail.com>
Subject: Re: [PATCH 10/15] KVM: selftests: Remove perf_test_args.host_page_size
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 3:06 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Remove perf_test_args.host_page_size and instead use getpagesize() so
> that it's somewhat obvious that, for tests that care about the host page
> size, they care about the system page size, not the hardware page size,
> e.g. that the logic is unchanged if hugepages are in play.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  tools/testing/selftests/kvm/demand_paging_test.c          | 8 ++++----
>  tools/testing/selftests/kvm/include/perf_test_util.h      | 1 -
>  tools/testing/selftests/kvm/lib/perf_test_util.c          | 6 ++----
>  .../selftests/kvm/memslot_modification_stress_test.c      | 2 +-
>  4 files changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 0cbf111e6c21..b937a65b0e6d 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -83,7 +83,7 @@ static int handle_uffd_page_request(int uffd, uint64_t addr)
>
>         copy.src = (uint64_t)guest_data_prototype;
>         copy.dst = addr;
> -       copy.len = perf_test_args.host_page_size;
> +       copy.len = getpagesize();
>         copy.mode = 0;
>
>         clock_gettime(CLOCK_MONOTONIC, &start);
> @@ -100,7 +100,7 @@ static int handle_uffd_page_request(int uffd, uint64_t addr)
>         PER_PAGE_DEBUG("UFFDIO_COPY %d \t%ld ns\n", tid,
>                        timespec_to_ns(ts_diff));
>         PER_PAGE_DEBUG("Paged in %ld bytes at 0x%lx from thread %d\n",
> -                      perf_test_args.host_page_size, addr, tid);
> +                      getpagesize(), addr, tid);
>
>         return 0;
>  }
> @@ -271,10 +271,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>
>         perf_test_args.wr_fract = 1;
>
> -       guest_data_prototype = malloc(perf_test_args.host_page_size);
> +       guest_data_prototype = malloc(getpagesize());
>         TEST_ASSERT(guest_data_prototype,
>                     "Failed to allocate buffer for guest data pattern");
> -       memset(guest_data_prototype, 0xAB, perf_test_args.host_page_size);
> +       memset(guest_data_prototype, 0xAB, getpagesize());
>
>         vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
>         TEST_ASSERT(vcpu_threads, "Memory allocation failed");
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index cccf1c44bddb..223fe6b79a04 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -28,7 +28,6 @@ struct perf_test_vcpu_args {
>
>  struct perf_test_args {
>         struct kvm_vm *vm;
> -       uint64_t host_page_size;
>         uint64_t gpa;
>         uint64_t guest_page_size;
>         int wr_fract;
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 03f125236021..982a86c8eeaa 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -57,8 +57,6 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>
>         pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>
> -       pta->host_page_size = getpagesize();
> -
>         /*
>          * Snapshot the non-huge page size.  This is used by the guest code to
>          * access/dirty pages at the logging granularity.
> @@ -68,7 +66,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>         guest_num_pages = vm_adjust_num_guest_pages(mode,
>                                 (vcpus * vcpu_memory_bytes) / pta->guest_page_size);
>
> -       TEST_ASSERT(vcpu_memory_bytes % pta->host_page_size == 0,
> +       TEST_ASSERT(vcpu_memory_bytes % getpagesize() == 0,
>                     "Guest memory size is not host page size aligned.");
>         TEST_ASSERT(vcpu_memory_bytes % pta->guest_page_size == 0,
>                     "Guest memory size is not guest page size aligned.");
> @@ -88,7 +86,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>                     guest_num_pages, vm_get_max_gfn(vm), vcpus, vcpu_memory_bytes);
>
>         pta->gpa = (vm_get_max_gfn(vm) - guest_num_pages) * pta->guest_page_size;
> -       pta->gpa &= ~(pta->host_page_size - 1);
> +       pta->gpa &= ~(getpagesize() - 1);
>         if (backing_src == VM_MEM_SRC_ANONYMOUS_THP ||
>             backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB)
>                 pta->gpa &= ~(KVM_UTIL_HUGEPAGE_ALIGNMENT - 1);
> diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> index 569bb1f55bdf..b3b8f08e91ad 100644
> --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> @@ -123,7 +123,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                            p->nr_memslot_modifications,
>                            perf_test_args.gpa +
>                            (guest_percpu_mem_size * nr_vcpus) +
> -                          perf_test_args.host_page_size +
> +                          getpagesize() +
>                            perf_test_args.guest_page_size);
>
>         run_vcpus = false;
> --
> 2.30.0.478.g8a0d178c01-goog
>
