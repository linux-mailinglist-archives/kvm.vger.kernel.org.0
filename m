Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40963678C32
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 00:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbjAWXmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 18:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjAWXmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 18:42:43 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3905A1207B
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 15:42:41 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id g11so11040158eda.12
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 15:42:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0xH4PPFL6mtcmDWY5apzAu+fxbrv5KEUcCtxP+OgiYE=;
        b=T+6ynWbbky8Wo3C2A+sTda2eJTISOyFiS7nWYnRIqWkI1Da91vfhq23esWpVZtKnCZ
         wpmlMioGw9iojPLqr/q+Xg5rcAc9JU+Ex1AIjxs3I9WSGlHJCSTDlxKL3WVjIbfRed7N
         iqDQDvS8A1nJ29rvX/W0a0pMYj/plVyWlJXrwnYK/IvV6JdfmoqLgINt716zpKM7UYr5
         B7cT9vU+rC0o8gu/+fRK9bRdOIBA9wct3rdN2pBnxOxqnNt/B1CqQj2E3JqKRF0OMv6k
         ItmjfjzvW5Qa8KduBqPWhgYwOfAs1E05Xlaaqs8kZtkR/81uQujKAVZo+2jaYWjX6WUc
         vEPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0xH4PPFL6mtcmDWY5apzAu+fxbrv5KEUcCtxP+OgiYE=;
        b=uAepGnVFKqlAleJZd9K07iVC2B18ayPUDP12eEL67V2VAT7uyHQadm4yI5RT9jJ/g7
         GbvvV+VydeW0/pfaYD9MY8F2KyxesiTtFaEUuUv4ztWqMOCglhPWEOXjyXA8iMaMiI0X
         MK37SsCZVE5SWLTx2RciKs0HSRFyB4qhJQV7vcWgixronUSn0dPStCg3VhjpQDdCE+eC
         fEVNU32ecqinzGxLPYISDR8gmmMLdXd7XbkLG2R3IMzVF+3Wuyv70uIDlrTqBBtti55p
         dfruyjmdp+Zn7tGH3/3Hn1sGkTvshJ4MmIwgiMoenUxBapDEDdwgbL/M21U2kQSltRBL
         +GBg==
X-Gm-Message-State: AFqh2kpwf8ck76ZunMoPS9DEy/7a0L8cChRdgaV1GMVzW+LkOBMie9eY
        h69ZkaumGVjyUgqIs+U7oHeDfwL8w1Tn+xt9QvHlqg==
X-Google-Smtp-Source: AMrXdXvKWQDaer4NeXqVtysWKURbitev/8gE9w/gsvOAvOxtqxYFMIq7NHeAdpPYQrGZZe9TZw/Q5jsNwbc6eNFkLMM=
X-Received: by 2002:a05:6402:43c8:b0:49b:62c9:4fe with SMTP id
 p8-20020a05640243c800b0049b62c904femr3365534edc.0.1674517359381; Mon, 23 Jan
 2023 15:42:39 -0800 (PST)
MIME-Version: 1.0
References: <20230123190329.520285-1-bgardon@google.com> <20230123190329.520285-3-bgardon@google.com>
 <CAHVum0fcn1c17TzyTOyJPML=ApNHWFr1PA0fUAOEUnP1_GO06g@mail.gmail.com>
In-Reply-To: <CAHVum0fcn1c17TzyTOyJPML=ApNHWFr1PA0fUAOEUnP1_GO06g@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 23 Jan 2023 15:42:27 -0800
Message-ID: <CANgfPd-QzO+_-1kjwgxV1X_3G4XYrfVwZKdG2LQpgoG1ja=xgg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] selftests: KVM: Add page splitting test
To:     Vipin Sharma <vipinsh@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>
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

On Mon, Jan 23, 2023 at 1:32 PM Vipin Sharma <vipinsh@google.com> wrote:
>
> On Mon, Jan 23, 2023 at 11:03 AM Ben Gardon <bgardon@google.com> wrote:
> >
> > Add a test for page splitting during dirty logging and for hugepage
> > recovery after dirty logging.
> >
> > Page splitting represents non-trivial behavior, which is complicated
> > by MANUAL_PROTECT mode, which causes pages to be split on the first
> > clear, instead of when dirty logging is enabled.
> >
> > Add a test which makes asserions about page counts to help define the
>
> nit: assertions
>
> > expected behavior of page splitting and to provid needed coverage of the
>
> nit: provide
>
> > behavior. This also helps ensure that a failure in eager page splitting
> > is not covered up by splitting in the vCPU path.
> >
> > Tested by running the test on an Intel Haswell machine w/wo
> > MANUAL_PROTECT.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../selftests/kvm/include/kvm_util_base.h     |   1 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c    |   5 +
> >  .../kvm/x86_64/page_splitting_test.c          | 278 ++++++++++++++++++
> >  4 files changed, 285 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/x86_64/page_splitting_test.c
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 1750f91dd9362..057ebd709e77a 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -76,6 +76,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/monitor_mwait_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
> > +TEST_GEN_PROGS_x86_64 += x86_64/page_splitting_test
>
> Should the test be named dirty_log_page_splitting_test or
> dirty_log_page_split_and_recovery_test?
>
> page_splitting_test name is very generic and does not convey much information.

Sure, we can do that. It's certainly a more descriptive name.

>
> >  TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
> >  TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index fbc2a79369b8b..a089c356f354e 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -213,6 +213,7 @@ extern const struct vm_guest_mode_params vm_guest_mode_params[];
> >  int open_path_or_exit(const char *path, int flags);
> >  int open_kvm_dev_path_or_exit(void);
> >
> > +bool get_kvm_param_bool(const char *param);
> >  bool get_kvm_intel_param_bool(const char *param);
> >  bool get_kvm_amd_param_bool(const char *param);
> >
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index 56d5ea949cbbe..fa6d69f731990 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -80,6 +80,11 @@ static bool get_module_param_bool(const char *module_name, const char *param)
> >         TEST_FAIL("Unrecognized value '%c' for boolean module param", value);
> >  }
> >
> > +bool get_kvm_param_bool(const char *param)
> > +{
> > +       return get_module_param_bool("kvm", param);
> > +}
> > +
> >  bool get_kvm_intel_param_bool(const char *param)
> >  {
> >         return get_module_param_bool("kvm_intel", param);
> > diff --git a/tools/testing/selftests/kvm/x86_64/page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/page_splitting_test.c
> > new file mode 100644
> > index 0000000000000..2b4a28e6a95de
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/x86_64/page_splitting_test.c
> > @@ -0,0 +1,278 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * KVM dirty logging page splitting test
> > + *
> > + * Based on dirty_log_perf.c
> > + *
> > + * Copyright (C) 2018, Red Hat, Inc.
>
> Delete?
>
> > + * Copyright (C) 2020, Google, Inc.
>
> 2023

As a mere engineer, copyright notices scare me and I don't know the
rules for when to update things and when to add or remove credit.
It seems kind of silly to have these notices in the first place so I'm
generally inclined to skip them but if I'm copying the base code from
an existing file and modifying it, as I did here, it seems appropriate
to at least copy the copyright notice?
I'm not sure when these would ever matter in practice.

>
>
> > + */
> > +
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <time.h>
> > +#include <pthread.h>
> > +#include <linux/bitmap.h>
> > +
> > +#include "kvm_util.h"
> > +#include "test_util.h"
> > +#include "memstress.h"
> > +#include "guest_modes.h"
> > +
> > +#define VCPUS          2
> > +#define SLOTS          2
> > +#define ITERATIONS     2
> > +
> > +static uint64_t guest_percpu_mem_size = DEFAULT_PER_VCPU_MEM_SIZE;
> > +
> > +static enum vm_mem_backing_src_type backing_src = VM_MEM_SRC_ANONYMOUS_HUGETLB;
> > +
> > +static u64 dirty_log_manual_caps;
> > +static bool host_quit;
> > +static int iteration;
> > +static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
> > +
> > +struct kvm_page_stats {
> > +       uint64_t pages_4k;
> > +       uint64_t pages_2m;
> > +       uint64_t pages_1g;
> > +       uint64_t hugepages;
> > +};
> > +
> > +static void get_page_stats(struct kvm_vm *vm, struct kvm_page_stats *stats, const char *stage)
> > +{
> > +       stats->pages_4k = vm_get_stat(vm, "pages_4k");
> > +       stats->pages_2m = vm_get_stat(vm, "pages_2m");
> > +       stats->pages_1g = vm_get_stat(vm, "pages_1g");
> > +       stats->hugepages = stats->pages_2m + stats->pages_1g;
> > +
> > +       pr_debug("\nGetting stats after %s: 4K: %ld 2M: %ld 1G: %ld huge: %ld\n",
> > +                stage, stats->pages_4k, stats->pages_2m, stats->pages_1g,
> > +                stats->hugepages);
> > +}
> > +
> > +static void run_vcpus_get_page_stats(struct kvm_vm *vm, struct kvm_page_stats *stats, const char *stage)
> > +{
> > +       int i;
> > +
> > +       iteration++;
> > +       for (i = 0; i < VCPUS; i++) {
> > +               while (READ_ONCE(vcpu_last_completed_iteration[i]) !=
> > +                      iteration)
> > +                       ;
> > +       }
> > +
> > +       get_page_stats(vm, stats, stage);
> > +}
> > +
> > +static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
> > +{
> > +       struct kvm_vcpu *vcpu = vcpu_args->vcpu;
> > +       int vcpu_idx = vcpu_args->vcpu_idx;
> > +       struct kvm_run *run;
> > +
> > +       run = vcpu->run;
> > +
> > +       while (!READ_ONCE(host_quit)) {
> > +               int current_iteration = READ_ONCE(iteration);
> > +
> > +               vcpu_run(vcpu);
> > +
> > +               TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
> > +                           "Invalid guest sync status: exit_reason=%s\n",
> > +                           exit_reason_str(run->exit_reason));
> > +
> > +               vcpu_last_completed_iteration[vcpu_idx] = current_iteration;
> > +
> > +               /* Wait for the start of the next iteration to be signaled. */
> > +               while (current_iteration == READ_ONCE(iteration) &&
> > +                      READ_ONCE(iteration) >= 0 &&
> > +                      !READ_ONCE(host_quit))
> > +                       ;
> > +       }
> > +}
> > +
> > +static void run_test(enum vm_guest_mode mode, void *unused)
> > +{
> > +       struct kvm_vm *vm;
> > +       unsigned long **bitmaps;
> > +       uint64_t guest_num_pages;
> > +       uint64_t host_num_pages;
> > +       uint64_t pages_per_slot;
> > +       int i;
> > +       uint64_t total_4k_pages;
> > +       struct kvm_page_stats stats_populated;
> > +       struct kvm_page_stats stats_dirty_logging_enabled;
> > +       struct kvm_page_stats stats_dirty_pass[ITERATIONS];
> > +       struct kvm_page_stats stats_clear_pass[ITERATIONS];
> > +       struct kvm_page_stats stats_dirty_logging_disabled;
> > +       struct kvm_page_stats stats_repopulated;
> > +
> > +       vm = memstress_create_vm(mode, VCPUS, guest_percpu_mem_size,
> > +                                SLOTS, backing_src, false);
> > +
> > +       guest_num_pages = (VCPUS * guest_percpu_mem_size) >> vm->page_shift;
> > +       guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
> > +       host_num_pages = vm_num_host_pages(mode, guest_num_pages);
> > +       pages_per_slot = host_num_pages / SLOTS;
> > +
> > +       bitmaps = memstress_alloc_bitmaps(SLOTS, pages_per_slot);
> > +
> > +       if (dirty_log_manual_caps)
> > +               vm_enable_cap(vm, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2,
> > +                             dirty_log_manual_caps);
> > +
> > +       /* Start the iterations */
> > +       iteration = -1;
> > +       host_quit = false;
> > +
> > +       for (i = 0; i < VCPUS; i++)
> > +               vcpu_last_completed_iteration[i] = -1;
> > +
> > +       memstress_start_vcpu_threads(VCPUS, vcpu_worker);
> > +
> > +       run_vcpus_get_page_stats(vm, &stats_populated, "populating memory");
> > +
> > +       /* Enable dirty logging */
> > +       memstress_enable_dirty_logging(vm, SLOTS);
> > +
> > +       get_page_stats(vm, &stats_dirty_logging_enabled, "enabling dirty logging");
> > +
> > +       while (iteration < ITERATIONS) {
> > +               run_vcpus_get_page_stats(vm, &stats_dirty_pass[iteration - 1],
> > +                                        "dirtying memory");
> > +
> > +               memstress_get_dirty_log(vm, bitmaps, SLOTS);
> > +
> > +               if (dirty_log_manual_caps) {
> > +                       memstress_clear_dirty_log(vm, bitmaps, SLOTS, pages_per_slot);
> > +
> > +                       get_page_stats(vm, &stats_clear_pass[iteration - 1], "clearing dirty log");
> > +               }
> > +       }
> > +
> > +       /* Disable dirty logging */
> > +       memstress_disable_dirty_logging(vm, SLOTS);
> > +
> > +       get_page_stats(vm, &stats_dirty_logging_disabled, "disabling dirty logging");
> > +
> > +       /* Run vCPUs again to fault pages back in. */
> > +       run_vcpus_get_page_stats(vm, &stats_repopulated, "repopulating memory");
> > +
> > +       /*
> > +        * Tell the vCPU threads to quit.  No need to manually check that vCPUs
> > +        * have stopped running after disabling dirty logging, the join will
> > +        * wait for them to exit.
> > +        */
> > +       host_quit = true;
> > +       memstress_join_vcpu_threads(VCPUS);
> > +
> > +       memstress_free_bitmaps(bitmaps, SLOTS);
> > +       memstress_destroy_vm(vm);
> > +
> > +       /* Make assertions about the page counts. */
> > +       total_4k_pages = stats_populated.pages_4k;
> > +       total_4k_pages += stats_populated.pages_2m * 512;
> > +       total_4k_pages += stats_populated.pages_1g * 512 * 512;
> > +
> > +       /*
> > +        * Check that all huge pages were split. Since large pages can only
> > +        * exist in the data slot, and the vCPUs should have dirtied all pages
> > +        * in the data slot, there should be no huge pages left after splitting.
> > +        * Splitting happens at dirty log enable time without
> > +        * KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 and after the first clear pass
> > +        * with that capability.
> > +        */
> > +       if (dirty_log_manual_caps) {
> > +               TEST_ASSERT(stats_clear_pass[0].hugepages == 0,
> > +                           "Unexpected huge page count after splitting. Expected 0, got %ld",
> > +                           stats_clear_pass[0].hugepages);
> > +               TEST_ASSERT(stats_clear_pass[0].pages_4k == total_4k_pages,
> > +                           "All memory should be mapped at 4k. Expected %ld 4k pages, got %ld",
> > +                           total_4k_pages, stats_clear_pass[0].pages_4k);
> > +               TEST_ASSERT(stats_dirty_logging_enabled.hugepages == stats_populated.hugepages,
> > +                           "Huge page count should not have changed from enabling dirty logging. Expected %ld, got %ld",
> > +                           stats_populated.hugepages, stats_dirty_logging_enabled.hugepages);
> > +       } else {
> > +               TEST_ASSERT(stats_dirty_logging_enabled.hugepages == 0,
> > +                           "Unexpected huge page count after splitting. Expected 0, got %ld",
> > +                           stats_dirty_logging_enabled.hugepages);
> > +               TEST_ASSERT(stats_dirty_logging_enabled.pages_4k == total_4k_pages,
> > +                           "All memory should be mapped at 4k. Expected %ld 4k pages, got %ld",
> > +                           total_4k_pages, stats_dirty_logging_enabled.pages_4k);
> > +       }
> > +
> > +       /*
> > +        * Once dirty logging is disabled and the vCPUs have touched all their
> > +        * memory again, the page counts should be the same as they were
> > +        * right after initial population of memory.
> > +        */
> > +       TEST_ASSERT(stats_populated.pages_4k == stats_repopulated.pages_4k,
> > +                   "4k page count did not return to its initial value after "
> > +                   "dirty logging. Expected %ld, got %ld",
> > +                   stats_populated.pages_4k, stats_repopulated.pages_4k);
> > +       TEST_ASSERT(stats_populated.pages_2m == stats_repopulated.pages_2m,
> > +                   "2m page count did not return to its initial value after "
> > +                   "dirty logging. Expected %ld, got %ld",
> > +                   stats_populated.pages_2m, stats_repopulated.pages_2m);
> > +       TEST_ASSERT(stats_populated.pages_1g == stats_repopulated.pages_1g,
> > +                   "1g page count did not return to its initial value after "
> > +                   "dirty logging. Expected %ld, got %ld",
> > +                   stats_populated.pages_1g, stats_repopulated.pages_1g);
> > +}
>
> I know David suggested in the previous version to use __ASSERT_EQ().
>
> I will recommend using __ASSERT_EQ(). If you make the variables name
> meaningful then that should be sufficient in showing the expected
> intent. Some examples:
> ASSERT_EQ(after_clear_dirty_log.hugepages, 0);
> ASSERT_EQ(after_clear_dirty_log.pages_4k, total_4k_pages);
> ASSERT_EQ(after_enable_dirty_log.hugepages, initial_state.hugepages);
> ASSERT_EQ(initial_state.pages_4k, after_disable_dirty_logging.pages_4k);
> ...
>
> This makes code cleaner and error messages printed also self sufficient.

Alright, that's 2 votes for ASSERT_EQ, so I'll change it.

>
> > +
> > +static void help(char *name)
> > +{
> > +       puts("");
> > +       printf("usage: %s [-h] [-b vcpu bytes] [-s mem type]\n",
> > +              name);
> > +       puts("");
> > +       printf(" -b: specify the size of the memory region which should be\n"
> > +              "     dirtied by each vCPU. e.g. 10M or 3G.\n"
> > +              "     (default: 1G)\n");
> > +       backing_src_help("-s");
> > +       puts("");
> > +       exit(0);
>
> This should not be exit(0) if a user passed the wrong option.

Huh. That's a fair point, though many other tests also exit 0 after
printing the help text. Annoyingly that would require exiting with a
different code depending on whether the help text was printed because
of the -h or a bad option but that's not too hard.

>
> > +}
> > +
> > +int main(int argc, char *argv[])
> > +{
> > +       int opt;
> > +
> > +       TEST_REQUIRE(get_kvm_param_bool("eager_page_split"));
> > +       TEST_REQUIRE(get_kvm_param_bool("tdp_mmu"));
> > +
> > +       while ((opt = getopt(argc, argv, "b:hs:")) != -1) {
> > +               switch (opt) {
> > +               case 'b':
> > +                       guest_percpu_mem_size = parse_size(optarg);
> > +                       break;
> > +               case 's':
> > +                       backing_src = parse_backing_src_type(optarg);
> > +                       break;
> > +               case 'h':
> > +               default:
> > +                       help(argv[0]);
> > +                       break;
> > +               }
> > +       }
> > +
> > +       if (!is_backing_src_hugetlb(backing_src)) {
> > +               pr_info("This test will only work reliably with HugeTLB memory. "
> > +                       "It can work with THP, but that is best effort.");
> > +               return KSFT_SKIP;
> > +       }
> > +
> > +       guest_modes_append_default();
> > +
> > +       dirty_log_manual_caps = 0;
> > +       for_each_guest_mode(run_test, NULL);
> > +
> > +       dirty_log_manual_caps =
> > +               kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
>
> Shouldn't the check be done in the beginning and skip the test f it is
> not supported?

Hmmm, we'd only want to skip this second run of the test, so we
probably wouldn't want to exit with an error.
Exiting early is probably reasonable though.

>
> > +       dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
> > +                                 KVM_DIRTY_LOG_INITIALLY_SET);
> > +       for_each_guest_mode(run_test, NULL);
> > +
> > +       return 0;
> > +}
> > --
> > 2.39.1.405.gd4c25cc71f-goog
> >
