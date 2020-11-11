Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B2F2AFD4F
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 02:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbgKLBbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 20:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbgKKXJN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 18:09:13 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7879C0613D1
        for <kvm@vger.kernel.org>; Wed, 11 Nov 2020 15:09:11 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id s24so4013977ioj.13
        for <kvm@vger.kernel.org>; Wed, 11 Nov 2020 15:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lTH2H2IYgYvM4LyOQX8ha9/vNjRDVowJQZ3bS2f+tR8=;
        b=iZ50ReG92WvKRsQDv8paiIliSM9X2tPHLw2ePYZbubIiPB7F+cPWqB1GoFdfNWRPdu
         AgyA9XJiltY+yxStBL+aXeWB3BgK8UxZ1B61awiuJXjSsEiLkDu7xdkEpJCbbb/6mFRl
         abUc6zVwB72gBF7oV4D4Y1/hkqF31b7kVK3+KvfwXeXRW19Ys0tkJupmhZg4gbVyJmxy
         6rIk4YySGHkqAiKgb3jVajNSfclXZCBun5HlO7n8azC6IJ3SD5HfEmK78mDCQqgAm3i2
         C4vgHLu1j/gXCCpSKfa5r9ReSLQ+5emjiIhBowJHjnghYZoydYZyShMexiiQeVJktSSY
         vR9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lTH2H2IYgYvM4LyOQX8ha9/vNjRDVowJQZ3bS2f+tR8=;
        b=l687q9Pyt2SSKPQjWur5SsF8UNsT8PPKPHlHTh7MJXhEE9IbKzsiNm8EC5Xt993k5u
         KiHaqahSunmIvSp8GululF04TT+iuhZDb5hEffqcQ2tfE6HQtnz5SnnbgSq13+COGmR1
         mk7MEIpanow8eeQW6F6taWFgRdyT8IelUE7UHVvRmov9mk1pDU0c7OflaL2IvTKfdPnv
         0tgaEU2jR4lECIJhsZJ3YYgzQ5quoaV+OkGV8ZRg84TlV7cI6PYBrVlAZ7o25qw4a0mq
         LOMpMjai/+MTZfNSwzFoDdxTPrUaRqI/1F4TEaywm8aEfhYDrjReGTTvOKiSTeOSNpwq
         ZuzA==
X-Gm-Message-State: AOAM532caZMlb+Apx2mEg82DsnGCqCmJbafifLqh+FMige3lbmBH9UuX
        5Jt3qXoV9AYXew4auM5uD9yR3HeEFx8Gr+Wt7+QUkA==
X-Google-Smtp-Source: ABdhPJwKSf+/g5HViVnsP6mssdgaz07ywNN5qRw3GhKKIqtibxUv9HocTFqXSHYGMbHqYF9fI3knLlROyu9XgmoiDdE=
X-Received: by 2002:a6b:8f8d:: with SMTP id r135mr19541854iod.134.1605136150609;
 Wed, 11 Nov 2020 15:09:10 -0800 (PST)
MIME-Version: 1.0
References: <20201111122636.73346-1-drjones@redhat.com> <20201111122636.73346-9-drjones@redhat.com>
In-Reply-To: <20201111122636.73346-9-drjones@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 11 Nov 2020 15:08:59 -0800
Message-ID: <CANgfPd_F5BAzs8p58QuqPS7HpxdfKzMUZF1XR_vwR90_97E7BQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/11] KVM: selftests: Implement perf_test_util more conventionally
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 11, 2020 at 4:27 AM Andrew Jones <drjones@redhat.com> wrote:
>
> It's not conventional C to put non-inline functions in header
> files. Create a source file for the functions instead. Also
> reduce the amount of globals and rename the functions to
> something less generic.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  tools/testing/selftests/kvm/Makefile          |   2 +-
>  .../selftests/kvm/demand_paging_test.c        |  11 +-
>  .../selftests/kvm/dirty_log_perf_test.c       |  20 +--
>  .../testing/selftests/kvm/include/kvm_util.h  |   1 +
>  .../selftests/kvm/include/perf_test_util.h    | 146 ++----------------
>  .../selftests/kvm/lib/perf_test_util.c        | 138 +++++++++++++++++
>  6 files changed, 169 insertions(+), 149 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/lib/perf_test_util.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index ca6b64d9ab64..120b02bf3f1e 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -33,7 +33,7 @@ ifeq ($(ARCH),s390)
>         UNAME_M := s390x
>  endif
>
> -LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c
> +LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
>  LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
>  LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
>  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index b0c41de32e9b..bdfbde51f9b8 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -36,12 +36,14 @@
>  #define PER_VCPU_DEBUG(...) _no_printf(__VA_ARGS__)
>  #endif
>
> +static int nr_vcpus = 1;
> +static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
>  static char *guest_data_prototype;
>
>  static void *vcpu_worker(void *data)
>  {
>         int ret;
> -       struct vcpu_args *vcpu_args = (struct vcpu_args *)data;
> +       struct perf_test_vcpu_args *vcpu_args = (struct perf_test_vcpu_args *)data;
>         int vcpu_id = vcpu_args->vcpu_id;
>         struct kvm_vm *vm = perf_test_args.vm;
>         struct kvm_run *run;
> @@ -263,7 +265,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         int vcpu_id;
>         int r;
>
> -       vm = create_vm(mode, nr_vcpus, guest_percpu_mem_size);
> +       vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size);
>
>         perf_test_args.wr_fract = 1;
>
> @@ -275,7 +277,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
>         TEST_ASSERT(vcpu_threads, "Memory allocation failed");
>
> -       add_vcpus(vm, nr_vcpus, guest_percpu_mem_size);
> +       perf_test_add_vcpus(vm, nr_vcpus, guest_percpu_mem_size);
>
>         if (p->use_uffd) {
>                 uffd_handler_threads =
> @@ -359,8 +361,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                 perf_test_args.vcpu_args[0].pages * nr_vcpus /
>                 ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
>
> -       ucall_uninit(vm);
> -       kvm_vm_free(vm);
> +       perf_test_destroy_vm(vm);
>
>         free(guest_data_prototype);
>         free(vcpu_threads);
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index c606dbb36244..f441a587c638 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -22,10 +22,13 @@
>  /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
>  #define TEST_HOST_LOOP_N               2UL
>
> +static int nr_vcpus = 1;
> +static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
> +
>  /* Host variables */
>  static bool host_quit;
>  static uint64_t iteration;
> -static uint64_t vcpu_last_completed_iteration[MAX_VCPUS];
> +static uint64_t vcpu_last_completed_iteration[KVM_MAX_VCPUS];
>
>  static void *vcpu_worker(void *data)
>  {
> @@ -37,7 +40,7 @@ static void *vcpu_worker(void *data)
>         struct timespec ts_diff;
>         struct timespec total = (struct timespec){0};
>         struct timespec avg;
> -       struct vcpu_args *vcpu_args = (struct vcpu_args *)data;
> +       struct perf_test_vcpu_args *vcpu_args = (struct perf_test_vcpu_args *)data;
>         int vcpu_id = vcpu_args->vcpu_id;
>
>         vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
> @@ -105,7 +108,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         struct timespec vcpu_dirty_total = (struct timespec){0};
>         struct timespec avg;
>
> -       vm = create_vm(mode, nr_vcpus, guest_percpu_mem_size);
> +       vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size);
>
>         perf_test_args.wr_fract = p->wr_fract;
>
> @@ -117,7 +120,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>         vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
>         TEST_ASSERT(vcpu_threads, "Memory allocation failed");
>
> -       add_vcpus(vm, nr_vcpus, guest_percpu_mem_size);
> +       perf_test_add_vcpus(vm, nr_vcpus, guest_percpu_mem_size);
>
>         sync_global_to_guest(vm, perf_test_args);
>
> @@ -143,7 +146,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>
>         /* Enable dirty logging */
>         clock_gettime(CLOCK_MONOTONIC, &start);
> -       vm_mem_region_set_flags(vm, TEST_MEM_SLOT_INDEX,
> +       vm_mem_region_set_flags(vm, PERF_TEST_MEM_SLOT_INDEX,
>                                 KVM_MEM_LOG_DIRTY_PAGES);
>         ts_diff = timespec_diff_now(start);
>         pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
> @@ -170,7 +173,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>                         iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
>
>                 clock_gettime(CLOCK_MONOTONIC, &start);
> -               kvm_vm_get_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap);
> +               kvm_vm_get_dirty_log(vm, PERF_TEST_MEM_SLOT_INDEX, bmap);
>
>                 ts_diff = timespec_diff_now(start);
>                 get_dirty_log_total = timespec_add(get_dirty_log_total,
> @@ -186,7 +189,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>
>         /* Disable dirty logging */
>         clock_gettime(CLOCK_MONOTONIC, &start);
> -       vm_mem_region_set_flags(vm, TEST_MEM_SLOT_INDEX, 0);
> +       vm_mem_region_set_flags(vm, PERF_TEST_MEM_SLOT_INDEX, 0);
>         ts_diff = timespec_diff_now(start);
>         pr_info("Disabling dirty logging time: %ld.%.9lds\n",
>                 ts_diff.tv_sec, ts_diff.tv_nsec);
> @@ -198,8 +201,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>
>         free(bmap);
>         free(vcpu_threads);
> -       ucall_uninit(vm);
> -       kvm_vm_free(vm);
> +       perf_test_destroy_vm(vm);
>  }
>
>  static void help(char *name)
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 011e8c6b4600..99fa84ed2db9 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -16,6 +16,7 @@
>
>  #include "sparsebit.h"
>
> +#define KVM_MAX_VCPUS 512
>
>  /*
>   * Callers of kvm_util only have an incomplete/opaque description of the
> diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> index 5f0719629a4e..81b0bcf71557 100644
> --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> @@ -9,35 +9,15 @@
>  #define SELFTEST_KVM_PERF_TEST_UTIL_H
>
>  #include "kvm_util.h"
> -#include "processor.h"
> -
> -#define MAX_VCPUS 512
> -
> -#define TEST_MEM_SLOT_INDEX            1
>
>  /* Default guest test virtual memory offset */
>  #define DEFAULT_GUEST_TEST_MEM         0xc0000000
>
>  #define DEFAULT_PER_VCPU_MEM_SIZE      (1 << 30) /* 1G */
>
> -/*
> - * Guest physical memory offset of the testing memory slot.
> - * This will be set to the topmost valid physical address minus
> - * the test memory size.
> - */
> -static uint64_t guest_test_phys_mem;
> -
> -/*
> - * Guest virtual memory offset of the testing memory slot.
> - * Must not conflict with identity mapped test code.
> - */
> -static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
> -static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
> -
> -/* Number of VCPUs for the test */
> -static int nr_vcpus = 1;
> +#define PERF_TEST_MEM_SLOT_INDEX       1
>
> -struct vcpu_args {
> +struct perf_test_vcpu_args {
>         uint64_t gva;
>         uint64_t pages;
>
> @@ -51,123 +31,21 @@ struct perf_test_args {
>         uint64_t guest_page_size;
>         int wr_fract;
>
> -       struct vcpu_args vcpu_args[MAX_VCPUS];
> +       struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
>  };
>
> -static struct perf_test_args perf_test_args;
> +extern struct perf_test_args perf_test_args;
>
>  /*
> - * Continuously write to the first 8 bytes of each page in the
> - * specified region.
> + * Guest physical memory offset of the testing memory slot.
> + * This will be set to the topmost valid physical address minus
> + * the test memory size.
>   */
> -static void guest_code(uint32_t vcpu_id)
> -{
> -       struct vcpu_args *vcpu_args = &perf_test_args.vcpu_args[vcpu_id];
> -       uint64_t gva;
> -       uint64_t pages;
> -       int i;
> -
> -       /* Make sure vCPU args data structure is not corrupt. */
> -       GUEST_ASSERT(vcpu_args->vcpu_id == vcpu_id);
> -
> -       gva = vcpu_args->gva;
> -       pages = vcpu_args->pages;
> -
> -       while (true) {
> -               for (i = 0; i < pages; i++) {
> -                       uint64_t addr = gva + (i * perf_test_args.guest_page_size);
> -
> -                       if (i % perf_test_args.wr_fract == 0)
> -                               *(uint64_t *)addr = 0x0123456789ABCDEF;
> -                       else
> -                               READ_ONCE(*(uint64_t *)addr);
> -               }
> -
> -               GUEST_SYNC(1);
> -       }
> -}
> -
> -static struct kvm_vm *create_vm(enum vm_guest_mode mode, int vcpus,
> -                               uint64_t vcpu_memory_bytes)
> -{
> -       struct kvm_vm *vm;
> -       uint64_t guest_num_pages;
> -
> -       pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
> -
> -       perf_test_args.host_page_size = getpagesize();
> -       perf_test_args.guest_page_size = vm_guest_mode_params[mode].page_size;
> -
> -       guest_num_pages = vm_adjust_num_guest_pages(mode,
> -                               (vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size);
> -
> -       TEST_ASSERT(vcpu_memory_bytes % perf_test_args.host_page_size == 0,
> -                   "Guest memory size is not host page size aligned.");
> -       TEST_ASSERT(vcpu_memory_bytes % perf_test_args.guest_page_size == 0,
> -                   "Guest memory size is not guest page size aligned.");
> -
> -       vm = vm_create_with_vcpus(mode, vcpus,
> -                                 (vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size,
> -                                 0, guest_code, NULL);
> -
> -       perf_test_args.vm = vm;
> -
> -       /*
> -        * If there should be more memory in the guest test region than there
> -        * can be pages in the guest, it will definitely cause problems.
> -        */
> -       TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
> -                   "Requested more guest memory than address space allows.\n"
> -                   "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
> -                   guest_num_pages, vm_get_max_gfn(vm), vcpus,
> -                   vcpu_memory_bytes);
> -
> -       guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
> -                             perf_test_args.guest_page_size;
> -       guest_test_phys_mem &= ~(perf_test_args.host_page_size - 1);
> -#ifdef __s390x__
> -       /* Align to 1M (segment size) */
> -       guest_test_phys_mem &= ~((1 << 20) - 1);
> -#endif
> -       pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
> -
> -       /* Add an extra memory slot for testing */
> -       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> -                                   guest_test_phys_mem,
> -                                   TEST_MEM_SLOT_INDEX,
> -                                   guest_num_pages, 0);
> -
> -       /* Do mapping for the demand paging memory slot */
> -       virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages, 0);
> -
> -       ucall_init(vm, NULL);
> -
> -       return vm;
> -}
> -
> -static void add_vcpus(struct kvm_vm *vm, int vcpus, uint64_t vcpu_memory_bytes)
> -{
> -       vm_paddr_t vcpu_gpa;
> -       struct vcpu_args *vcpu_args;
> -       int vcpu_id;
> -
> -       for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
> -               vcpu_args = &perf_test_args.vcpu_args[vcpu_id];
> -
> -#ifdef __x86_64__
> -               vcpu_set_cpuid(vm, vcpu_id, kvm_get_supported_cpuid());
> -#endif
> -
> -               vcpu_args->vcpu_id = vcpu_id;
> -               vcpu_args->gva = guest_test_virt_mem +
> -                                (vcpu_id * vcpu_memory_bytes);
> -               vcpu_args->pages = vcpu_memory_bytes /
> -                                  perf_test_args.guest_page_size;
> +extern uint64_t guest_test_phys_mem;
>
> -               vcpu_gpa = guest_test_phys_mem + (vcpu_id * vcpu_memory_bytes);
> -               pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
> -                        vcpu_id, vcpu_gpa, vcpu_gpa + vcpu_memory_bytes);
> -       }
> -}
> +struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
> +                               uint64_t vcpu_memory_bytes);
> +void perf_test_destroy_vm(struct kvm_vm *vm);
> +void perf_test_add_vcpus(struct kvm_vm *vm, int vcpus, uint64_t vcpu_memory_bytes);
>
>  #endif /* SELFTEST_KVM_PERF_TEST_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> new file mode 100644
> index 000000000000..63329f1e6398
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> @@ -0,0 +1,138 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2020, Google LLC.
> + */
> +
> +#include "kvm_util.h"
> +#include "perf_test_util.h"
> +#include "processor.h"
> +
> +struct perf_test_args perf_test_args;
> +
> +uint64_t guest_test_phys_mem;
> +
> +/*
> + * Guest virtual memory offset of the testing memory slot.
> + * Must not conflict with identity mapped test code.
> + */
> +static uint64_t guest_test_virt_mem = DEFAULT_GUEST_TEST_MEM;
> +
> +/*
> + * Continuously write to the first 8 bytes of each page in the
> + * specified region.
> + */
> +static void guest_code(uint32_t vcpu_id)
> +{
> +       struct perf_test_vcpu_args *vcpu_args = &perf_test_args.vcpu_args[vcpu_id];
> +       uint64_t gva;
> +       uint64_t pages;
> +       int i;
> +
> +       /* Make sure vCPU args data structure is not corrupt. */
> +       GUEST_ASSERT(vcpu_args->vcpu_id == vcpu_id);
> +
> +       gva = vcpu_args->gva;
> +       pages = vcpu_args->pages;
> +
> +       while (true) {
> +               for (i = 0; i < pages; i++) {
> +                       uint64_t addr = gva + (i * perf_test_args.guest_page_size);
> +
> +                       if (i % perf_test_args.wr_fract == 0)
> +                               *(uint64_t *)addr = 0x0123456789ABCDEF;
> +                       else
> +                               READ_ONCE(*(uint64_t *)addr);
> +               }
> +
> +               GUEST_SYNC(1);
> +       }
> +}
> +
> +struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
> +                                  uint64_t vcpu_memory_bytes)
> +{
> +       struct kvm_vm *vm;
> +       uint64_t guest_num_pages;
> +
> +       pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
> +
> +       perf_test_args.host_page_size = getpagesize();
> +       perf_test_args.guest_page_size = vm_guest_mode_params[mode].page_size;
> +
> +       guest_num_pages = vm_adjust_num_guest_pages(mode,
> +                               (vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size);
> +
> +       TEST_ASSERT(vcpu_memory_bytes % perf_test_args.host_page_size == 0,
> +                   "Guest memory size is not host page size aligned.");
> +       TEST_ASSERT(vcpu_memory_bytes % perf_test_args.guest_page_size == 0,
> +                   "Guest memory size is not guest page size aligned.");
> +
> +       vm = vm_create_with_vcpus(mode, vcpus,
> +                                 (vcpus * vcpu_memory_bytes) / perf_test_args.guest_page_size,
> +                                 0, guest_code, NULL);
> +
> +       perf_test_args.vm = vm;
> +
> +       /*
> +        * If there should be more memory in the guest test region than there
> +        * can be pages in the guest, it will definitely cause problems.
> +        */
> +       TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
> +                   "Requested more guest memory than address space allows.\n"
> +                   "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
> +                   guest_num_pages, vm_get_max_gfn(vm), vcpus,
> +                   vcpu_memory_bytes);
> +
> +       guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
> +                             perf_test_args.guest_page_size;
> +       guest_test_phys_mem &= ~(perf_test_args.host_page_size - 1);
> +#ifdef __s390x__
> +       /* Align to 1M (segment size) */
> +       guest_test_phys_mem &= ~((1 << 20) - 1);
> +#endif
> +       pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
> +
> +       /* Add an extra memory slot for testing */
> +       vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> +                                   guest_test_phys_mem,
> +                                   PERF_TEST_MEM_SLOT_INDEX,
> +                                   guest_num_pages, 0);
> +
> +       /* Do mapping for the demand paging memory slot */
> +       virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages, 0);
> +
> +       ucall_init(vm, NULL);
> +
> +       return vm;
> +}
> +
> +void perf_test_destroy_vm(struct kvm_vm *vm)
> +{
> +       ucall_uninit(vm);
> +       kvm_vm_free(vm);
> +}
> +
> +void perf_test_add_vcpus(struct kvm_vm *vm, int vcpus, uint64_t vcpu_memory_bytes)

NIT: Since we're actually creating the vcpus in vm_create_with_vcpus,
and renaming functions anyway, it might make sense to change this to
perf_test_setup_vcpus or similar here.
This could also be called from perf_test_create_vm and made static,
but that might be outside the scope of this commit. Either way works.

> +{
> +       vm_paddr_t vcpu_gpa;
> +       struct perf_test_vcpu_args *vcpu_args;
> +       int vcpu_id;
> +
> +       for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
> +               vcpu_args = &perf_test_args.vcpu_args[vcpu_id];
> +
> +#ifdef __x86_64__
> +               vcpu_set_cpuid(vm, vcpu_id, kvm_get_supported_cpuid());
> +#endif
> +
> +               vcpu_args->vcpu_id = vcpu_id;
> +               vcpu_args->gva = guest_test_virt_mem +
> +                                (vcpu_id * vcpu_memory_bytes);
> +               vcpu_args->pages = vcpu_memory_bytes /
> +                                  perf_test_args.guest_page_size;
> +
> +               vcpu_gpa = guest_test_phys_mem + (vcpu_id * vcpu_memory_bytes);
> +               pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
> +                        vcpu_id, vcpu_gpa, vcpu_gpa + vcpu_memory_bytes);
> +       }
> +}
> --
> 2.26.2
>
