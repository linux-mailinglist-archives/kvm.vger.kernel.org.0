Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0197A44DB5A
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 18:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbhKKR6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 12:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbhKKR6y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 12:58:54 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B3FC061766
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 09:56:05 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id x10so7947012ioj.9
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 09:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+ToQhGkfFpVoTcxttJL6Mc7eCm1RyGEG4CLD7joG/Sw=;
        b=H29lgqFYGO2bB7IRp10L+Gr14KWuMGFLcB5ISaTuZYu0EsGvfILDLuAn7ALNp5pEKr
         MU//SKSpMY5dMRb1YHXWyPDfn1iglMum1GP5EGDqwnkZgpApy0UlTZj5T9LNxi+CdDB5
         hJnBzLusiN+CEmuijTSo0M34Tt4MkrXfGpjn5lOmPdTQOqaTczfU/GndsSQGiedapH8/
         sBKcBA8sLGWRLYdY7GyqCdiuGCZTzoUXdjLA/pu6sa3G5BT3m7CPF7IOaX6MmlPUbOq2
         W8YpTcLXDotKC31H7HDp8CTH4xpAPG8AWnRjAuoHGtDmA/v2V+9jh1+/OgTSmMRPYxMc
         GkCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+ToQhGkfFpVoTcxttJL6Mc7eCm1RyGEG4CLD7joG/Sw=;
        b=PFOJKdZ2p4B/e03zd271bAv2k1eqFZ1VUmbIMLAQkydWauI78ZPXX+/Rw+QTsM+V4O
         wLHM+clHV0OBCDzqv0jZeNvk2Y6VyJWyU5/V4qSI3us/0dfCXIUhQLmccS2YDweDE6Bn
         NNVvAXUSb2lTAhxPpbO97ub/5QjK/HWhcUAu0u/F+P7gtnqLlkFl7PnDbW5VpMMuO5zv
         wihVHqs5aYBesn9l0y0I+H/g41UylBQPhZCdqXvwCc1aUP6teVIei2gLUXeYwNnOVY6E
         G6O0OUewG4ONmf/mm3/04F4MuoiC7GXtx6lTsC+LYjCrb+XVSJLDxoFC6kwrA9HFXFe1
         22fg==
X-Gm-Message-State: AOAM531emj6Jri7rEJZHty6LzVOnxdDmHxD+A4OlGqSswvSHuPFn7fkM
        BUo99VYNAod3R1CEBfADn5qfLy3N9bD4BQ6EtgYe0g==
X-Google-Smtp-Source: ABdhPJyNikY8Aq0TILOA6MPac66rB46p1dJGFBqPiOFaTYjaOTSa8CpqsWxsKf3C4jkWg+WEzV0ibyazm52kavQLIj0=
X-Received: by 2002:a5d:9d92:: with SMTP id ay18mr6224066iob.130.1636653364726;
 Thu, 11 Nov 2021 09:56:04 -0800 (PST)
MIME-Version: 1.0
References: <20211111000310.1435032-1-dmatlack@google.com> <20211111000310.1435032-13-dmatlack@google.com>
In-Reply-To: <20211111000310.1435032-13-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 11 Nov 2021 09:55:53 -0800
Message-ID: <CANgfPd-+X5=4dRcvnHojqcSqd1xvBjjpdeva7YdZwxptLYnOZQ@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] KVM: selftests: Sync perf_test_args to guest
 during VM creation
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021 at 4:03 PM David Matlack <dmatlack@google.com> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Copy perf_test_args to the guest during VM creation instead of relying on
> the caller to do so at their leisure.  Ideally, tests wouldn't even be
> able to modify perf_test_args, i.e. they would have no motivation to do
> the sync, but enforcing that is arguably a net negative for readability.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> [Set wr_fract=1 by default and add helper to override it since the new
>  access_tracking_perf_test needs to set it dynamically.]
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  .../selftests/kvm/access_tracking_perf_test.c        |  3 +--
>  tools/testing/selftests/kvm/demand_paging_test.c     |  5 -----
>  tools/testing/selftests/kvm/dirty_log_perf_test.c    |  4 +---
>  tools/testing/selftests/kvm/include/perf_test_util.h |  2 ++
>  tools/testing/selftests/kvm/lib/perf_test_util.c     | 12 ++++++++++++
>  .../selftests/kvm/memslot_modification_stress_test.c |  5 -----
>  6 files changed, 16 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> index fdef6c906388..5364a2ed7c68 100644
> --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> @@ -277,8 +277,7 @@ static void run_iteration(struct kvm_vm *vm, int vcpus, const char *description)
>  static void access_memory(struct kvm_vm *vm, int vcpus, enum access_type access,
>                           const char *description)
>  {
> -       perf_test_args.wr_fract = (access == ACCESS_READ) ? INT_MAX : 1;
> -       sync_global_to_guest(vm, perf_test_args);
> +       perf_test_set_wr_fract(vm, (access == ACCESS_READ) ? INT_MAX : 1);
>         iteration_work = ITERATION_ACCESS_MEMORY;
>         run_iteration(vm, vcpus, description);
>  }
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 0fee44f5e5ae..26f8fd8a57ec 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -295,8 +295,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
>                                  p->src_type, p->partition_vcpu_memory_access);
>
> -       perf_test_args.wr_fract = 1;
> -
>         demand_paging_size = get_backing_src_pagesz(p->src_type);
>
>         guest_data_prototype = malloc(demand_paging_size);
> @@ -345,9 +343,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                 }
>         }
>
> -       /* Export the shared variables to the guest */
> -       sync_global_to_guest(vm, perf_test_args);
> -
>         pr_info("Finished creating vCPUs and starting uffd threads\n");
>
>         clock_gettime(CLOCK_MONOTONIC, &start);
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 62f9cc2a3146..583b4d95aa98 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -189,7 +189,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                                  p->slots, p->backing_src,
>                                  p->partition_vcpu_memory_access);
>
> -       perf_test_args.wr_fract = p->wr_fract;
> +       perf_test_set_wr_fract(vm, p->wr_fract);
>
>         guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
>         guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
> @@ -207,8 +207,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
>         TEST_ASSERT(vcpu_threads, "Memory allocation failed");
>
> -       sync_global_to_guest(vm, perf_test_args);
> -
>         /* Start the iterations */
>         iteration = 0;
>         host_quit = false;
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index 91804be1cf53..74e3622b3a6e 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -43,4 +43,6 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>                                    bool partition_vcpu_memory_access);
>  void perf_test_destroy_vm(struct kvm_vm *vm);
>
> +void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
> +
>  #endif /* SELFTEST_KVM_PERF_TEST_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> index 13c8bc22f4e1..77f9eb5667c9 100644
> --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -94,6 +94,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>
>         pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
>
> +       /* By default vCPUs will write to memory. */
> +       pta->wr_fract = 1;
> +
>         /*
>          * Snapshot the non-huge page size.  This is used by the guest code to
>          * access/dirty pages at the logging granularity.
> @@ -157,6 +160,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
>
>         ucall_init(vm, NULL);
>
> +       /* Export the shared variables to the guest. */
> +       sync_global_to_guest(vm, perf_test_args);
> +
>         return vm;
>  }
>
> @@ -165,3 +171,9 @@ void perf_test_destroy_vm(struct kvm_vm *vm)
>         ucall_uninit(vm);
>         kvm_vm_free(vm);
>  }
> +
> +void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
> +{
> +       perf_test_args.wr_fract = wr_fract;
> +       sync_global_to_guest(vm, perf_test_args);
> +}
> diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> index 27af0bb8deb7..df431d0da1ee 100644
> --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> @@ -108,14 +108,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                                  VM_MEM_SRC_ANONYMOUS,
>                                  p->partition_vcpu_memory_access);
>
> -       perf_test_args.wr_fract = 1;
> -
>         vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
>         TEST_ASSERT(vcpu_threads, "Memory allocation failed");
>
> -       /* Export the shared variables to the guest */
> -       sync_global_to_guest(vm, perf_test_args);
> -
>         pr_info("Finished creating vCPUs\n");
>
>         for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
> --
> 2.34.0.rc1.387.gb447b232ab-goog
>
