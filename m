Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7682AE231
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 22:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731657AbgKJVxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 16:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgKJVxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 16:53:08 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84196C0613D1
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 13:53:08 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id n129so30879iod.5
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 13:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3YuNDIf9dBd03PkFUy2YbQL4Oucdu3VhLYsWgxVxNak=;
        b=OLBvvaFAPEZeC1riRm825u5x6qmHLHga5J/YddupRa5ZlOqIpZ2Iia+3Mi7WouzGKx
         VfTiUpZyktADW/o9yvMvvL9tsgYdTlsOfMwZhc0A7hLHT6kYnCgRwZPduf2XGvwB23pV
         8yoC5+qE8zeib8QsmJGFch+MU9EmxrylWDzLvVwonyYelZrue47zGchmb7kuNOzqOTUp
         36COxx043wS3M109GJf2LXF+nsICzNrDbuPaj5oPqRRE9O8+AwVW62WuQmQrXKzKDxJN
         qoYv0KyogjM0Ons2mQESUzJ7yEeI19n7SpTxnqjB2fob9PVzMOq+XuBA68FnQXzYl4A8
         zncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3YuNDIf9dBd03PkFUy2YbQL4Oucdu3VhLYsWgxVxNak=;
        b=h35jcOAarosrx16FNmWav3IcNGGH9r0E/ianDwq7+Xs3qr6/nEQJMTUKRzz5DrgMcv
         y/b8lc3eTS7U5sWzlFOhXs3zcXYBpMC129T1NlnW4RsLZ8N0IYROVyloJ1Eq+1qIlx/c
         Sg+vhyfAe1WzdVN2ac3IvKqAqOOLXqGYt82Fd+BfvHJlhInhbJV1goMpuE69noMp7Dso
         oo5yAApHuFmhukdoTAp0od31Z2boGAIt4xFThVQvO5jHNsVvRifGFw65FkVXiIlkuN/3
         8c0Z1ucKPxGjkntzpf0hr941FIISfWEPrPJvhxiRWVT9GBrrUiL5p6vFORPnGcnq6IJv
         JDxw==
X-Gm-Message-State: AOAM5300kIMDnYKF3OGBEZoYQoFm6gkD9R/yxsJ7H2SWqpdXHtDooCNh
        mfkZx8NvVTplpl9L+BHGY7xW0SR503te8JXdOH119Q==
X-Google-Smtp-Source: ABdhPJxKeKgFQAj3G5duuba6EmQ8ocF4+ozxd9Kwvsbcuxa2W7JU4XWXLm/fvLxGsPJ69xp1Ioj3bZkBKWy0rxlD024=
X-Received: by 2002:a5e:d515:: with SMTP id e21mr16044239iom.9.1605045187461;
 Tue, 10 Nov 2020 13:53:07 -0800 (PST)
MIME-Version: 1.0
References: <20201110204802.417521-1-drjones@redhat.com> <20201110204802.417521-4-drjones@redhat.com>
In-Reply-To: <20201110204802.417521-4-drjones@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 10 Nov 2020 13:52:56 -0800
Message-ID: <CANgfPd-n6bvTedc++Pmq0uS0erqRVJGzWjzVECbHjJw2e-5e2A@mail.gmail.com>
Subject: Re: [PATCH 3/8] KVM: selftests: Factor out guest mode code
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 10, 2020 at 12:48 PM Andrew Jones <drjones@redhat.com> wrote:
>
> demand_paging_test, dirty_log_test, and dirty_log_perf_test have
> redundant guest mode code. Factor it out.
>
> Also, while adding a new include, remove the ones we don't need.
>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   2 +-
>  .../selftests/kvm/demand_paging_test.c        | 107 ++++-----------
>  .../selftests/kvm/dirty_log_perf_test.c       | 119 +++++------------
>  tools/testing/selftests/kvm/dirty_log_test.c  | 125 ++++++------------
>  .../selftests/kvm/include/guest_modes.h       |  21 +++
>  tools/testing/selftests/kvm/lib/guest_modes.c |  70 ++++++++++
>  6 files changed, 188 insertions(+), 256 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/guest_modes.h
>  create mode 100644 tools/testing/selftests/kvm/lib/guest_modes.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 3d14ef77755e..ca6b64d9ab64 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -33,7 +33,7 @@ ifeq ($(ARCH),s390)
>         UNAME_M := s390x
>  endif
>
> -LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c lib/test_util.c
> +LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c
>  LIBKVM_x86_64 = lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
>  LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c
>  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c
> diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> index 3d96a7bfaff3..946161a9ce2d 100644
> --- a/tools/testing/selftests/kvm/demand_paging_test.c
> +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> @@ -7,23 +7,20 @@
>   * Copyright (C) 2019, Google, Inc.
>   */
>
> -#define _GNU_SOURCE /* for program_invocation_name */
> +#define _GNU_SOURCE /* for program_invocation_name and pipe2 */

What is the purpose of pipe2 in this patch / why add it to this
comment but not the comments in the other files modified here?

>
>  #include <stdio.h>
>  #include <stdlib.h>
> -#include <sys/syscall.h>
> -#include <unistd.h>
> -#include <asm/unistd.h>
>  #include <time.h>
>  #include <poll.h>
>  #include <pthread.h>
> -#include <linux/bitmap.h>
> -#include <linux/bitops.h>
>  #include <linux/userfaultfd.h>
> +#include <sys/syscall.h>
>
> -#include "perf_test_util.h"
> -#include "processor.h"
> +#include "kvm_util.h"
>  #include "test_util.h"
> +#include "perf_test_util.h"
> +#include "guest_modes.h"
>
>  #ifdef __NR_userfaultfd
>
> @@ -248,9 +245,14 @@ static int setup_demand_paging(struct kvm_vm *vm,
>         return 0;
>  }
>
> -static void run_test(enum vm_guest_mode mode, bool use_uffd,
> -                    useconds_t uffd_delay)
> +struct test_params {
> +       bool use_uffd;
> +       useconds_t uffd_delay;
> +};
> +
> +static void run_test(enum vm_guest_mode mode, void *arg)
>  {
> +       struct test_params *p = arg;
>         pthread_t *vcpu_threads;
>         pthread_t *uffd_handler_threads = NULL;
>         struct uffd_handler_args *uffd_args = NULL;
> @@ -275,7 +277,7 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
>
>         add_vcpus(vm, nr_vcpus, guest_percpu_mem_size);
>
> -       if (use_uffd) {
> +       if (p->use_uffd) {
>                 uffd_handler_threads =
>                         malloc(nr_vcpus * sizeof(*uffd_handler_threads));
>                 TEST_ASSERT(uffd_handler_threads, "Memory allocation failed");
> @@ -308,7 +310,7 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
>                         r = setup_demand_paging(vm,
>                                                 &uffd_handler_threads[vcpu_id],
>                                                 pipefds[vcpu_id * 2],
> -                                               uffd_delay, &uffd_args[vcpu_id],
> +                                               p->uffd_delay, &uffd_args[vcpu_id],
>                                                 vcpu_hva, guest_percpu_mem_size);
>                         if (r < 0)
>                                 exit(-r);
> @@ -339,7 +341,7 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
>
>         pr_info("All vCPU threads joined\n");
>
> -       if (use_uffd) {
> +       if (p->use_uffd) {
>                 char c;
>
>                 /* Tell the user fault fd handler threads to quit */
> @@ -362,38 +364,19 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
>
>         free(guest_data_prototype);
>         free(vcpu_threads);
> -       if (use_uffd) {
> +       if (p->use_uffd) {
>                 free(uffd_handler_threads);
>                 free(uffd_args);
>                 free(pipefds);
>         }
>  }
>
> -struct guest_mode {
> -       bool supported;
> -       bool enabled;
> -};
> -static struct guest_mode guest_modes[NUM_VM_MODES];
> -
> -#define guest_mode_init(mode, supported, enabled) ({ \
> -       guest_modes[mode] = (struct guest_mode){ supported, enabled }; \
> -})
> -
>  static void help(char *name)
>  {
> -       int i;
> -
>         puts("");
>         printf("usage: %s [-h] [-m mode] [-u] [-d uffd_delay_usec]\n"
>                "          [-b memory] [-v vcpus]\n", name);
> -       printf(" -m: specify the guest mode ID to test\n"
> -              "     (default: test all supported modes)\n"
> -              "     This option may be used multiple times.\n"
> -              "     Guest mode IDs:\n");
> -       for (i = 0; i < NUM_VM_MODES; ++i) {
> -               printf("         %d:    %s%s\n", i, vm_guest_mode_string(i),
> -                      guest_modes[i].supported ? " (supported)" : "");
> -       }
> +       guest_modes_help();
>         printf(" -u: use User Fault FD to handle vCPU page\n"
>                "     faults.\n");
>         printf(" -d: add a delay in usec to the User Fault\n"
> @@ -410,53 +393,22 @@ static void help(char *name)
>  int main(int argc, char *argv[])
>  {
>         int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
> -       bool mode_selected = false;
> -       unsigned int mode;
> -       int opt, i;
> -       bool use_uffd = false;
> -       useconds_t uffd_delay = 0;
> -
> -#ifdef __x86_64__
> -       guest_mode_init(VM_MODE_PXXV48_4K, true, true);
> -#endif
> -#ifdef __aarch64__
> -       guest_mode_init(VM_MODE_P40V48_4K, true, true);
> -       guest_mode_init(VM_MODE_P40V48_64K, true, true);
> -       {
> -               unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> -
> -               if (limit >= 52)
> -                       guest_mode_init(VM_MODE_P52V48_64K, true, true);
> -               if (limit >= 48) {
> -                       guest_mode_init(VM_MODE_P48V48_4K, true, true);
> -                       guest_mode_init(VM_MODE_P48V48_64K, true, true);
> -               }
> -       }
> -#endif
> -#ifdef __s390x__
> -       guest_mode_init(VM_MODE_P40V48_4K, true, true);
> -#endif
> +       struct test_params p = {};
> +       int opt;
> +
> +       guest_modes_append_default();
>
>         while ((opt = getopt(argc, argv, "hm:ud:b:v:")) != -1) {
>                 switch (opt) {
>                 case 'm':
> -                       if (!mode_selected) {
> -                               for (i = 0; i < NUM_VM_MODES; ++i)
> -                                       guest_modes[i].enabled = false;
> -                               mode_selected = true;
> -                       }
> -                       mode = strtoul(optarg, NULL, 10);
> -                       TEST_ASSERT(mode < NUM_VM_MODES,
> -                                   "Guest mode ID %d too big", mode);
> -                       guest_modes[mode].enabled = true;
> +                       guest_modes_cmdline(optarg);
>                         break;
>                 case 'u':
> -                       use_uffd = true;
> +                       p.use_uffd = true;
>                         break;
>                 case 'd':
> -                       uffd_delay = strtoul(optarg, NULL, 0);
> -                       TEST_ASSERT(uffd_delay >= 0,
> -                                   "A negative UFFD delay is not supported.");
> +                       p.uffd_delay = strtoul(optarg, NULL, 0);
> +                       TEST_ASSERT(p.uffd_delay >= 0, "A negative UFFD delay is not supported.");
>                         break;
>                 case 'b':
>                         guest_percpu_mem_size = parse_size(optarg);
> @@ -473,14 +425,7 @@ int main(int argc, char *argv[])
>                 }
>         }
>
> -       for (i = 0; i < NUM_VM_MODES; ++i) {
> -               if (!guest_modes[i].enabled)
> -                       continue;
> -               TEST_ASSERT(guest_modes[i].supported,
> -                           "Guest mode ID %d (%s) not supported.",
> -                           i, vm_guest_mode_string(i));
> -               run_test(i, use_uffd, uffd_delay);
> -       }
> +       for_each_guest_mode(run_test, &p);
>
>         return 0;
>  }
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index b9115e8ef0ed..b448c17bd7aa 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -12,16 +12,14 @@
>
>  #include <stdio.h>
>  #include <stdlib.h>
> -#include <unistd.h>
>  #include <time.h>
>  #include <pthread.h>
>  #include <linux/bitmap.h>
> -#include <linux/bitops.h>
>
>  #include "kvm_util.h"
> -#include "perf_test_util.h"
> -#include "processor.h"
>  #include "test_util.h"
> +#include "perf_test_util.h"
> +#include "guest_modes.h"
>
>  /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
>  #define TEST_HOST_LOOP_N               2UL
> @@ -88,9 +86,15 @@ static void *vcpu_worker(void *data)
>         return NULL;
>  }
>
> -static void run_test(enum vm_guest_mode mode, unsigned long iterations,
> -                    uint64_t phys_offset, int wr_fract)
> +struct test_params {
> +       unsigned long iterations;
> +       uint64_t phys_offset;
> +       int wr_fract;
> +};
> +
> +static void run_test(enum vm_guest_mode mode, void *arg)
>  {
> +       struct test_params *p = arg;
>         pthread_t *vcpu_threads;
>         struct kvm_vm *vm;
>         unsigned long *bmap;
> @@ -105,7 +109,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>
>         vm = create_vm(mode, nr_vcpus, guest_percpu_mem_size);
>
> -       perf_test_args.wr_fract = wr_fract;
> +       perf_test_args.wr_fract = p->wr_fract;
>
>         guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
>         guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
> @@ -147,7 +151,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>         pr_info("Enabling dirty logging time: %ld.%.9lds\n\n",
>                 ts_diff.tv_sec, ts_diff.tv_nsec);
>
> -       while (iteration < iterations) {
> +       while (iteration < p->iterations) {
>                 /*
>                  * Incrementing the iteration number will start the vCPUs
>                  * dirtying memory again.
> @@ -189,9 +193,9 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>         pr_info("Disabling dirty logging time: %ld.%.9lds\n",
>                 ts_diff.tv_sec, ts_diff.tv_nsec);
>
> -       avg = timespec_div(get_dirty_log_total, iterations);
> +       avg = timespec_div(get_dirty_log_total, p->iterations);
>         pr_info("Get dirty log over %lu iterations took %ld.%.9lds. (Avg %ld.%.9lds/iteration)\n",
> -               iterations, get_dirty_log_total.tv_sec,
> +               p->iterations, get_dirty_log_total.tv_sec,
>                 get_dirty_log_total.tv_nsec, avg.tv_sec, avg.tv_nsec);
>
>         free(bmap);
> @@ -200,20 +204,8 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>         kvm_vm_free(vm);
>  }
>
> -struct guest_mode {
> -       bool supported;
> -       bool enabled;
> -};
> -static struct guest_mode guest_modes[NUM_VM_MODES];
> -
> -#define guest_mode_init(mode, supported, enabled) ({ \
> -       guest_modes[mode] = (struct guest_mode){ supported, enabled }; \
> -})
> -
>  static void help(char *name)
>  {
> -       int i;
> -
>         puts("");
>         printf("usage: %s [-h] [-i iterations] [-p offset] "
>                "[-m mode] [-b vcpu bytes] [-v vcpus]\n", name);
> @@ -222,14 +214,7 @@ static void help(char *name)
>                TEST_HOST_LOOP_N);
>         printf(" -p: specify guest physical test memory offset\n"
>                "     Warning: a low offset can conflict with the loaded test code.\n");
> -       printf(" -m: specify the guest mode ID to test "
> -              "(default: test all supported modes)\n"
> -              "     This option may be used multiple times.\n"
> -              "     Guest mode IDs:\n");
> -       for (i = 0; i < NUM_VM_MODES; ++i) {
> -               printf("         %d:    %s%s\n", i, vm_guest_mode_string(i),
> -                      guest_modes[i].supported ? " (supported)" : "");
> -       }
> +       guest_modes_help();
>         printf(" -b: specify the size of the memory region which should be\n"
>                "     dirtied by each vCPU. e.g. 10M or 3G.\n"
>                "     (default: 1G)\n");
> @@ -244,69 +229,38 @@ static void help(char *name)
>
>  int main(int argc, char *argv[])
>  {
> -       unsigned long iterations = TEST_HOST_LOOP_N;
> -       bool mode_selected = false;
> -       uint64_t phys_offset = 0;
> -       unsigned int mode;
> -       int opt, i;
> -       int wr_fract = 1;
> -
> -#ifdef __x86_64__
> -       guest_mode_init(VM_MODE_PXXV48_4K, true, true);
> -#endif
> -#ifdef __aarch64__
> -       guest_mode_init(VM_MODE_P40V48_4K, true, true);
> -       guest_mode_init(VM_MODE_P40V48_64K, true, true);
> -
> -       {
> -               unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> -
> -               if (limit >= 52)
> -                       guest_mode_init(VM_MODE_P52V48_64K, true, true);
> -               if (limit >= 48) {
> -                       guest_mode_init(VM_MODE_P48V48_4K, true, true);
> -                       guest_mode_init(VM_MODE_P48V48_64K, true, true);
> -               }
> -       }
> -#endif
> -#ifdef __s390x__
> -       guest_mode_init(VM_MODE_P40V48_4K, true, true);
> -#endif
> +       int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
> +       struct test_params p = {
> +               .iterations = TEST_HOST_LOOP_N,
> +               .wr_fract = 1,
> +       };
> +       int opt;
> +
> +       guest_modes_append_default();
>
>         while ((opt = getopt(argc, argv, "hi:p:m:b:f:v:")) != -1) {
>                 switch (opt) {
>                 case 'i':
> -                       iterations = strtol(optarg, NULL, 10);
> +                       p.iterations = strtol(optarg, NULL, 10);
>                         break;
>                 case 'p':
> -                       phys_offset = strtoull(optarg, NULL, 0);
> +                       p.phys_offset = strtoull(optarg, NULL, 0);
>                         break;
>                 case 'm':
> -                       if (!mode_selected) {
> -                               for (i = 0; i < NUM_VM_MODES; ++i)
> -                                       guest_modes[i].enabled = false;
> -                               mode_selected = true;
> -                       }
> -                       mode = strtoul(optarg, NULL, 10);
> -                       TEST_ASSERT(mode < NUM_VM_MODES,
> -                                   "Guest mode ID %d too big", mode);
> -                       guest_modes[mode].enabled = true;
> +                       guest_modes_cmdline(optarg);
>                         break;
>                 case 'b':
>                         guest_percpu_mem_size = parse_size(optarg);
>                         break;
>                 case 'f':
> -                       wr_fract = atoi(optarg);
> -                       TEST_ASSERT(wr_fract >= 1,
> +                       p.wr_fract = atoi(optarg);
> +                       TEST_ASSERT(p.wr_fract >= 1,
>                                     "Write fraction cannot be less than one");
>                         break;
>                 case 'v':
>                         nr_vcpus = atoi(optarg);
> -                       TEST_ASSERT(nr_vcpus > 0,
> -                                   "Must have a positive number of vCPUs");
> -                       TEST_ASSERT(nr_vcpus <= MAX_VCPUS,
> -                                   "This test does not currently support\n"
> -                                   "more than %d vCPUs.", MAX_VCPUS);
> +                       TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
> +                                   "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
>                         break;
>                 case 'h':
>                 default:
> @@ -315,18 +269,11 @@ int main(int argc, char *argv[])
>                 }
>         }
>
> -       TEST_ASSERT(iterations >= 2, "The test should have at least two iterations");
> +       TEST_ASSERT(p.iterations >= 2, "The test should have at least two iterations");
>
> -       pr_info("Test iterations: %"PRIu64"\n", iterations);
> +       pr_info("Test iterations: %"PRIu64"\n", p.iterations);
>
> -       for (i = 0; i < NUM_VM_MODES; ++i) {
> -               if (!guest_modes[i].enabled)
> -                       continue;
> -               TEST_ASSERT(guest_modes[i].supported,
> -                           "Guest mode ID %d (%s) not supported.",
> -                           i, vm_guest_mode_string(i));
> -               run_test(i, iterations, phys_offset, wr_fract);
> -       }
> +       for_each_guest_mode(run_test, &p);
>
>         return 0;
>  }
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index 54da9cc20db4..1b7375d2acea 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -9,14 +9,13 @@
>
>  #include <stdio.h>
>  #include <stdlib.h>
> -#include <unistd.h>
> -#include <time.h>
>  #include <pthread.h>
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
>
> -#include "test_util.h"
>  #include "kvm_util.h"
> +#include "test_util.h"
> +#include "guest_modes.h"
>  #include "processor.h"
>
>  #define VCPU_ID                                1
> @@ -375,9 +374,15 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
>  #define DIRTY_MEM_BITS 30 /* 1G */
>  #define PAGE_SHIFT_4K  12
>
> -static void run_test(enum vm_guest_mode mode, unsigned long iterations,
> -                    unsigned long interval, uint64_t phys_offset)
> +struct test_params {
> +       unsigned long iterations;
> +       unsigned long interval;
> +       uint64_t phys_offset;
> +};
> +
> +static void run_test(enum vm_guest_mode mode, void *arg)
>  {
> +       struct test_params *p = arg;
>         pthread_t vcpu_thread;
>         struct kvm_vm *vm;
>         unsigned long *bmap;
> @@ -412,12 +417,12 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>         host_page_size = getpagesize();
>         host_num_pages = vm_num_host_pages(mode, guest_num_pages);
>
> -       if (!phys_offset) {
> +       if (!p->phys_offset) {
>                 guest_test_phys_mem = (vm_get_max_gfn(vm) -
>                                        guest_num_pages) * guest_page_size;
>                 guest_test_phys_mem &= ~(host_page_size - 1);
>         } else {
> -               guest_test_phys_mem = phys_offset;
> +               guest_test_phys_mem = p->phys_offset;
>         }
>
>  #ifdef __s390x__
> @@ -464,9 +469,9 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>
>         pthread_create(&vcpu_thread, NULL, vcpu_worker, vm);
>
> -       while (iteration < iterations) {
> +       while (iteration < p->iterations) {
>                 /* Give the vcpu thread some time to dirty some pages */
> -               usleep(interval * 1000);
> +               usleep(p->interval * 1000);
>                 log_mode_collect_dirty_pages(vm, TEST_MEM_SLOT_INDEX,
>                                              bmap, host_num_pages);
>                 vm_dirty_log_verify(mode, bmap);
> @@ -488,20 +493,8 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>         kvm_vm_free(vm);
>  }
>
> -struct guest_mode {
> -       bool supported;
> -       bool enabled;
> -};
> -static struct guest_mode guest_modes[NUM_VM_MODES];
> -
> -#define guest_mode_init(mode, supported, enabled) ({ \
> -       guest_modes[mode] = (struct guest_mode){ supported, enabled }; \
> -})
> -
>  static void help(char *name)
>  {
> -       int i;
> -
>         puts("");
>         printf("usage: %s [-h] [-i iterations] [-I interval] "
>                "[-p offset] [-m mode]\n", name);
> @@ -515,70 +508,34 @@ static void help(char *name)
>         printf(" -M: specify the host logging mode "
>                "(default: run all log modes).  Supported modes: \n\t");
>         log_modes_dump();
> -       printf(" -m: specify the guest mode ID to test "
> -              "(default: test all supported modes)\n"
> -              "     This option may be used multiple times.\n"
> -              "     Guest mode IDs:\n");
> -       for (i = 0; i < NUM_VM_MODES; ++i) {
> -               printf("         %d:    %s%s\n", i, vm_guest_mode_string(i),
> -                      guest_modes[i].supported ? " (supported)" : "");
> -       }
> +       guest_modes_help();
>         puts("");
>         exit(0);
>  }
>
>  int main(int argc, char *argv[])
>  {
> -       unsigned long iterations = TEST_HOST_LOOP_N;
> -       unsigned long interval = TEST_HOST_LOOP_INTERVAL;
> -       bool mode_selected = false;
> -       uint64_t phys_offset = 0;
> -       unsigned int mode;
> -       int opt, i, j;
> -
> -#ifdef __x86_64__
> -       guest_mode_init(VM_MODE_PXXV48_4K, true, true);
> -#endif
> -#ifdef __aarch64__
> -       guest_mode_init(VM_MODE_P40V48_4K, true, true);
> -       guest_mode_init(VM_MODE_P40V48_64K, true, true);
> -
> -       {
> -               unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> +       struct test_params p = {
> +               .iterations = TEST_HOST_LOOP_N,
> +               .interval = TEST_HOST_LOOP_INTERVAL,
> +       };
> +       int opt, i;
>
> -               if (limit >= 52)
> -                       guest_mode_init(VM_MODE_P52V48_64K, true, true);
> -               if (limit >= 48) {
> -                       guest_mode_init(VM_MODE_P48V48_4K, true, true);
> -                       guest_mode_init(VM_MODE_P48V48_64K, true, true);
> -               }
> -       }
> -#endif
> -#ifdef __s390x__
> -       guest_mode_init(VM_MODE_P40V48_4K, true, true);
> -#endif
> +       guest_modes_append_default();
>
>         while ((opt = getopt(argc, argv, "hi:I:p:m:M:")) != -1) {
>                 switch (opt) {
>                 case 'i':
> -                       iterations = strtol(optarg, NULL, 10);
> +                       p.iterations = strtol(optarg, NULL, 10);
>                         break;
>                 case 'I':
> -                       interval = strtol(optarg, NULL, 10);
> +                       p.interval = strtol(optarg, NULL, 10);
>                         break;
>                 case 'p':
> -                       phys_offset = strtoull(optarg, NULL, 0);
> +                       p.phys_offset = strtoull(optarg, NULL, 0);
>                         break;
>                 case 'm':
> -                       if (!mode_selected) {
> -                               for (i = 0; i < NUM_VM_MODES; ++i)
> -                                       guest_modes[i].enabled = false;
> -                               mode_selected = true;
> -                       }
> -                       mode = strtoul(optarg, NULL, 10);
> -                       TEST_ASSERT(mode < NUM_VM_MODES,
> -                                   "Guest mode ID %d too big", mode);
> -                       guest_modes[mode].enabled = true;
> +                       guest_modes_cmdline(optarg);
>                         break;
>                 case 'M':
>                         if (!strcmp(optarg, "all")) {
> @@ -607,32 +564,24 @@ int main(int argc, char *argv[])
>                 }
>         }
>
> -       TEST_ASSERT(iterations > 2, "Iterations must be greater than two");
> -       TEST_ASSERT(interval > 0, "Interval must be greater than zero");
> +       TEST_ASSERT(p.iterations > 2, "Iterations must be greater than two");
> +       TEST_ASSERT(p.interval > 0, "Interval must be greater than zero");
>
>         pr_info("Test iterations: %"PRIu64", interval: %"PRIu64" (ms)\n",
> -               iterations, interval);
> +               p.iterations, p.interval);
>
>         srandom(time(0));
>
> -       for (i = 0; i < NUM_VM_MODES; ++i) {
> -               if (!guest_modes[i].enabled)
> -                       continue;
> -               TEST_ASSERT(guest_modes[i].supported,
> -                           "Guest mode ID %d (%s) not supported.",
> -                           i, vm_guest_mode_string(i));
> -               if (host_log_mode_option == LOG_MODE_ALL) {
> -                       /* Run each log mode */
> -                       for (j = 0; j < LOG_MODE_NUM; j++) {
> -                               pr_info("Testing Log Mode '%s'\n",
> -                                       log_modes[j].name);
> -                               host_log_mode = j;
> -                               run_test(i, iterations, interval, phys_offset);
> -                       }
> -               } else {
> -                       host_log_mode = host_log_mode_option;
> -                       run_test(i, iterations, interval, phys_offset);
> +       if (host_log_mode_option == LOG_MODE_ALL) {
> +               /* Run each log mode */
> +               for (i = 0; i < LOG_MODE_NUM; i++) {
> +                       pr_info("Testing Log Mode '%s'\n", log_modes[i].name);
> +                       host_log_mode = i;
> +                       for_each_guest_mode(run_test, &p);
>                 }
> +       } else {
> +               host_log_mode = host_log_mode_option;
> +               for_each_guest_mode(run_test, &p);
>         }
>
>         return 0;
> diff --git a/tools/testing/selftests/kvm/include/guest_modes.h b/tools/testing/selftests/kvm/include/guest_modes.h
> new file mode 100644
> index 000000000000..b691df33e64e
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/guest_modes.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2020, Red Hat, Inc.
> + */
> +#include "kvm_util.h"
> +
> +struct guest_mode {
> +       bool supported;
> +       bool enabled;
> +};
> +
> +extern struct guest_mode guest_modes[NUM_VM_MODES];
> +
> +#define guest_mode_append(mode, supported, enabled) ({ \
> +       guest_modes[mode] = (struct guest_mode){ supported, enabled }; \
> +})
> +
> +void guest_modes_append_default(void);
> +void for_each_guest_mode(void (*func)(enum vm_guest_mode, void *), void *arg);
> +void guest_modes_help(void);
> +void guest_modes_cmdline(const char *arg);
> diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
> new file mode 100644
> index 000000000000..25bff307c71f
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
> @@ -0,0 +1,70 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2020, Red Hat, Inc.
> + */
> +#include "guest_modes.h"
> +
> +struct guest_mode guest_modes[NUM_VM_MODES];
> +
> +void guest_modes_append_default(void)
> +{
> +       guest_mode_append(VM_MODE_DEFAULT, true, true);
> +
> +#ifdef __aarch64__
> +       guest_mode_append(VM_MODE_P40V48_64K, true, true);
> +       {
> +               unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> +               if (limit >= 52)
> +                       guest_mode_append(VM_MODE_P52V48_64K, true, true);
> +               if (limit >= 48) {
> +                       guest_mode_append(VM_MODE_P48V48_4K, true, true);
> +                       guest_mode_append(VM_MODE_P48V48_64K, true, true);
> +               }
> +       }
> +#endif
> +}
> +
> +void for_each_guest_mode(void (*func)(enum vm_guest_mode, void *), void *arg)
> +{
> +       int i;
> +
> +       for (i = 0; i < NUM_VM_MODES; ++i) {
> +               if (!guest_modes[i].enabled)
> +                       continue;
> +               TEST_ASSERT(guest_modes[i].supported,
> +                           "Guest mode ID %d (%s) not supported.",
> +                           i, vm_guest_mode_string(i));
> +               func(i, arg);
> +       }
> +}
> +
> +void guest_modes_help(void)
> +{
> +       int i;
> +
> +       printf(" -m: specify the guest mode ID to test\n"
> +              "     (default: test all supported modes)\n"
> +              "     This option may be used multiple times.\n"
> +              "     Guest mode IDs:\n");
> +       for (i = 0; i < NUM_VM_MODES; ++i) {
> +               printf("         %d:    %s%s\n", i, vm_guest_mode_string(i),
> +                      guest_modes[i].supported ? " (supported)" : "");
> +       }
> +}
> +
> +void guest_modes_cmdline(const char *arg)
> +{
> +       static bool mode_selected;
> +       unsigned int mode;
> +       int i;
> +
> +       if (!mode_selected) {
> +               for (i = 0; i < NUM_VM_MODES; ++i)
> +                       guest_modes[i].enabled = false;
> +               mode_selected = true;
> +       }
> +
> +       mode = strtoul(optarg, NULL, 10);
> +       TEST_ASSERT(mode < NUM_VM_MODES, "Guest mode ID %d too big", mode);
> +       guest_modes[mode].enabled = true;
> +}
> --
> 2.26.2
>
