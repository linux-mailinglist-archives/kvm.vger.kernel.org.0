Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3007D604EB0
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 19:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbiJSRcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 13:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiJSRcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 13:32:17 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97D61BF21D
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 10:32:07 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-367b8adf788so11627377b3.2
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 10:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Us5mvL9wlJ8ZsvYHuPVkt2Lu8S8whYP0vpSElqpTpJQ=;
        b=NrsOQn6xYFkLIRLGjV+vXtY/BG/Rmp00VWQ3YQ3eMYVuKNVcWVPB0Op6WBIKGdsx+O
         WhOcWPXkbe3gtHcWlzSr9cK0GpMxfuGeWvRvlsxos1czt2W25C8i9vIaCpNEbh820BrS
         Kdq32JkTv+LRxh4I7Htq6zx7RXTuii3Q9j51LOKj2IQcq/k8Ym0Ja/ChLZHADO2wtacy
         w2Ej/NYnHmomZOR3B8hYUNy5Rp1DkFIhjTMcbmpJlHf3DvqKs10e7esB4GKNh82ugqEw
         BQoFcE3h+yThRO8DHciZFoe+L5OnJWAq/NPO1Zx0x9m5OBzlywNmOJmp+UPlwSoHno+N
         BxJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Us5mvL9wlJ8ZsvYHuPVkt2Lu8S8whYP0vpSElqpTpJQ=;
        b=u3F/c5k3up7cVtLZp0bkJrQpv6ZF2F/Q6M6Dsz9WXGuMPaALijbtIllg7xKDwH2cWW
         lnKFDZs3PycWI1PFx0eb+vwY/yvl8D6yn6JmMRTRuoF2u7bXP3zX5lQbxknHXqDtwC0G
         pGtAIgeA+FP4j37Hz1RhbAhuIuw5XPpA8leQkW7OFMLXa6S7F/EBF33Z0BRHQZ9tHdXR
         x/FR+qAWppmwqDOusavtdSJVePDbC3wO+ilh/Z3OhllMew2bYfnYiHCrV4oLWKkmsSA7
         wd9Q3LXpj1qfc8WihUG6r7iJ4G5iVtFRt8oB4KYlpAevlm5NXHa0iK/xIQTyCYW2TUhT
         3BUA==
X-Gm-Message-State: ACrzQf1jwD2ieSNBrfQT+0ucedypc9mt8DtbNkIWYBU6F69H823Qjl01
        fvsSveAocI/uc9UXcGAsdNMNNS893qGiKMl5G7GmDw==
X-Google-Smtp-Source: AMsMyM7nI9Ov6Q3MUA7r/UWgoM3LIUkF8/NjVSPGq9y5ZcXpRkuJyIWIVOVnlSv3B1cshOB97Gz7N3B5eSJGX584ys4=
X-Received: by 2002:a81:9204:0:b0:358:89e9:cff9 with SMTP id
 j4-20020a819204000000b0035889e9cff9mr7591053ywg.168.1666200726684; Wed, 19
 Oct 2022 10:32:06 -0700 (PDT)
MIME-Version: 1.0
References: <20221017162448.257173-1-wei.w.wang@intel.com> <Y1Az6y1X4reOp2n6@google.com>
In-Reply-To: <Y1Az6y1X4reOp2n6@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 19 Oct 2022 10:31:40 -0700
Message-ID: <CALzav=f71jq9Sar-C5skzeDU0iGv=v0pQXq++L=ee6a6+AUbCw@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: selftests: name the threads
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, vipinsh@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 19, 2022 at 10:29 AM David Matlack <dmatlack@google.com> wrote:
>
> On Tue, Oct 18, 2022 at 12:24:48AM +0800, Wei Wang wrote:
> > Name the threads to facilitate debugging, performance tuning,
> > runtime pining etc. pthread_create_with_name is used to create
> > general threads with user specified name, and kvm_vcpu_thread_create
> > is used to create vcpu threads with name in "vcpu##id" format.
> >
> > An example is shown below reported from "top". With naming the
> > vcpu threads, the per-vcpu info becomes more noticeable.
> >
> > PID  USER PR  NI VIRT    RES  SHR  S  %CPU  %MEM TIME+   COMMAND
> > 4464 root 20  0  4248684 4.0g 1628 R  99.9  26.2 0:50.97 dirty_log_perf_
> > 4467 root 20  0  4248684 4.0g 1628 R  99.9  26.2 0:50.93 vcpu0
> > 4469 root 20  0  4248684 4.0g 1628 R  99.9  26.2 0:50.93 vcpu2
> > 4470 root 20  0  4248684 4.0g 1628 R  99.9  26.2 0:50.94 vcpu3
> > 4468 root 20  0  4248684 4.0g 1628 R  99.7  26.2 0:50.93 vcpu1
> >
> > pthread.h is included in kvm_util.h, so remove it from the files
> > that have already included kvm_util.h.
> >
> > Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> > ---
> >  .../selftests/kvm/aarch64/arch_timer.c        | 16 ++-----
> >  .../selftests/kvm/access_tracking_perf_test.c |  1 -
> >  .../selftests/kvm/demand_paging_test.c        |  5 +-
> >  .../selftests/kvm/dirty_log_perf_test.c       |  1 -
> >  tools/testing/selftests/kvm/dirty_log_test.c  |  2 +-
> >  .../selftests/kvm/hardware_disable_test.c     | 17 ++-----
> >  .../testing/selftests/kvm/include/kvm_util.h  |  8 ++++
> >  .../selftests/kvm/include/perf_test_util.h    |  2 -
> >  .../selftests/kvm/kvm_page_table_test.c       |  5 +-
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 47 +++++++++++++++++++
> >  .../selftests/kvm/lib/perf_test_util.c        |  3 +-
> >  .../selftests/kvm/max_guest_memory_test.c     |  4 +-
> >  .../kvm/memslot_modification_stress_test.c    |  1 -
> >  .../testing/selftests/kvm/memslot_perf_test.c |  3 +-
> >  tools/testing/selftests/kvm/rseq_test.c       |  5 +-
> >  .../selftests/kvm/set_memory_region_test.c    |  3 +-
> >  tools/testing/selftests/kvm/steal_time.c      |  4 +-
> >  .../selftests/kvm/x86_64/mmio_warning_test.c  |  3 +-
> >  .../selftests/kvm/x86_64/sev_migrate_tests.c  |  1 -
> >  .../selftests/kvm/x86_64/tsc_scaling_sync.c   |  4 +-
> >  .../kvm/x86_64/ucna_injection_test.c          |  1 -
> >  .../selftests/kvm/x86_64/xapic_ipi_test.c     | 10 ++--
> >  22 files changed, 85 insertions(+), 61 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > index 574eb73f0e90..14f56327ca28 100644
> > --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > @@ -23,7 +23,6 @@
> >  #define _GNU_SOURCE
> >
> >  #include <stdlib.h>
> > -#include <pthread.h>
> >  #include <linux/kvm.h>
> >  #include <linux/sizes.h>
> >  #include <linux/bitmap.h>
> > @@ -314,28 +313,23 @@ static void test_run(struct kvm_vm *vm)
> >  {
> >       pthread_t pt_vcpu_migration;
> >       unsigned int i;
> > -     int ret;
> >
> >       pthread_mutex_init(&vcpu_done_map_lock, NULL);
> >       vcpu_done_map = bitmap_zalloc(test_args.nr_vcpus);
> >       TEST_ASSERT(vcpu_done_map, "Failed to allocate vcpu done bitmap\n");
> >
> > -     for (i = 0; i < (unsigned long)test_args.nr_vcpus; i++) {
> > -             ret = pthread_create(&pt_vcpu_run[i], NULL, test_vcpu_run,
> > -                                  (void *)(unsigned long)i);
> > -             TEST_ASSERT(!ret, "Failed to create vCPU-%d pthread\n", i);
> > -     }
> > +     for (i = 0; i < (unsigned long)test_args.nr_vcpus; i++)
> > +             kvm_create_vcpu_thread(&pt_vcpu_run[i], NULL,
> > +                             test_vcpu_run, (void *)(unsigned long)i, i);
> >
> >       /* Spawn a thread to control the vCPU migrations */
> >       if (test_args.migration_freq_ms) {
> >               srand(time(NULL));
> >
> > -             ret = pthread_create(&pt_vcpu_migration, NULL,
> > -                                     test_vcpu_migration, NULL);
> > -             TEST_ASSERT(!ret, "Failed to create the migration pthread\n");
> > +             pthread_create_with_name(&pt_vcpu_migration, NULL,
> > +                             test_vcpu_migration, NULL, "control-thread");
> >       }
> >
> > -
> >       for (i = 0; i < test_args.nr_vcpus; i++)
> >               pthread_join(pt_vcpu_run[i], NULL);
> >
> > diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> > index 76c583a07ea2..b61ecc907d61 100644
> > --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> > +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> > @@ -37,7 +37,6 @@
> >   */
> >  #include <inttypes.h>
> >  #include <limits.h>
> > -#include <pthread.h>
> >  #include <sys/mman.h>
> >  #include <sys/types.h>
> >  #include <sys/stat.h>
> > diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
> > index 779ae54f89c4..f75d531008e8 100644
> > --- a/tools/testing/selftests/kvm/demand_paging_test.c
> > +++ b/tools/testing/selftests/kvm/demand_paging_test.c
> > @@ -14,7 +14,6 @@
> >  #include <stdlib.h>
> >  #include <time.h>
> >  #include <poll.h>
> > -#include <pthread.h>
> >  #include <linux/userfaultfd.h>
> >  #include <sys/syscall.h>
> >
> > @@ -260,8 +259,8 @@ static void setup_demand_paging(struct kvm_vm *vm,
> >       uffd_args->uffd = uffd;
> >       uffd_args->pipefd = pipefd;
> >       uffd_args->delay = uffd_delay;
> > -     pthread_create(uffd_handler_thread, NULL, uffd_handler_thread_fn,
> > -                    uffd_args);
> > +     pthread_create_with_name(uffd_handler_thread, NULL,
> > +             uffd_handler_thread_fn, uffd_args, "uffd-handler-thread");
> >
> >       PER_VCPU_DEBUG("Created uffd thread for HVA range [%p, %p)\n",
> >                      hva, hva + len);
> > diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > index f99e39a672d3..5cf9080b3864 100644
> > --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > @@ -11,7 +11,6 @@
> >  #include <stdio.h>
> >  #include <stdlib.h>
> >  #include <time.h>
> > -#include <pthread.h>
> >  #include <linux/bitmap.h>
> >
> >  #include "kvm_util.h"
> > diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> > index b5234d6efbe1..c7a30b4dd33a 100644
> > --- a/tools/testing/selftests/kvm/dirty_log_test.c
> > +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> > @@ -772,7 +772,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >       host_clear_count = 0;
> >       host_track_next_count = 0;
> >
> > -     pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
> > +     kvm_create_vcpu_thread(&vcpu_thread, NULL, vcpu_worker, vcpu, 0);
> >
> >       while (iteration < p->iterations) {
> >               /* Give the vcpu thread some time to dirty some pages */
> > diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c b/tools/testing/selftests/kvm/hardware_disable_test.c
> > index f5d59b9934f1..c22b8445a809 100644
> > --- a/tools/testing/selftests/kvm/hardware_disable_test.c
> > +++ b/tools/testing/selftests/kvm/hardware_disable_test.c
> > @@ -8,7 +8,6 @@
> >  #define _GNU_SOURCE
> >
> >  #include <fcntl.h>
> > -#include <pthread.h>
> >  #include <semaphore.h>
> >  #include <stdint.h>
> >  #include <stdlib.h>
> > @@ -59,15 +58,6 @@ static void *sleeping_thread(void *arg)
> >       pthread_exit(NULL);
> >  }
> >
> > -static inline void check_create_thread(pthread_t *thread, pthread_attr_t *attr,
> > -                                    void *(*f)(void *), void *arg)
> > -{
> > -     int r;
> > -
> > -     r = pthread_create(thread, attr, f, arg);
> > -     TEST_ASSERT(r == 0, "%s: failed to create thread", __func__);
> > -}
> > -
> >  static inline void check_set_affinity(pthread_t thread, cpu_set_t *cpu_set)
> >  {
> >       int r;
> > @@ -104,12 +94,13 @@ static void run_test(uint32_t run)
> >       for (i = 0; i < VCPU_NUM; ++i) {
> >               vcpu = vm_vcpu_add(vm, i, guest_code);
> >
> > -             check_create_thread(&threads[i], NULL, run_vcpu, vcpu);
> > +             kvm_create_vcpu_thread(&threads[i], NULL, run_vcpu, vcpu, i);
> >               check_set_affinity(threads[i], &cpu_set);
> >
> >               for (j = 0; j < SLEEPING_THREAD_NUM; ++j) {
> > -                     check_create_thread(&throw_away, NULL, sleeping_thread,
> > -                                         (void *)NULL);
> > +                     pthread_create_with_name(&throw_away, NULL,
> > +                                              sleeping_thread, (void *)NULL,
> > +                                              "sleeping-thread");
> >                       check_set_affinity(throw_away, &cpu_set);
> >               }
> >       }
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> > index c9286811a4cb..b7f0295d928e 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> > @@ -7,7 +7,15 @@
> >  #ifndef SELFTEST_KVM_UTIL_H
> >  #define SELFTEST_KVM_UTIL_H
> >
> > +#include <pthread.h>
> > +
> >  #include "kvm_util_base.h"
> >  #include "ucall_common.h"
> >
> > +void pthread_create_with_name(pthread_t *thread, const pthread_attr_t *attr,
> > +                     void *(*start_routine)(void *), void *arg, char *name);
> > +
> > +void kvm_create_vcpu_thread(pthread_t *thread, const pthread_attr_t *attr,
> > +             void *(*start_routine)(void *), void *arg, int vcpu_id);
> > +
> >  #endif /* SELFTEST_KVM_UTIL_H */
> > diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> > index eaa88df0555a..cb6971c8740f 100644
> > --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> > +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> > @@ -8,8 +8,6 @@
> >  #ifndef SELFTEST_KVM_PERF_TEST_UTIL_H
> >  #define SELFTEST_KVM_PERF_TEST_UTIL_H
> >
> > -#include <pthread.h>
> > -
> >  #include "kvm_util.h"
> >
> >  /* Default guest test virtual memory offset */
> > diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
> > index f42c6ac6d71d..1e41dca7f67d 100644
> > --- a/tools/testing/selftests/kvm/kvm_page_table_test.c
> > +++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
> > @@ -14,7 +14,6 @@
> >  #include <stdio.h>
> >  #include <stdlib.h>
> >  #include <time.h>
> > -#include <pthread.h>
> >  #include <semaphore.h>
> >
> >  #include "test_util.h"
> > @@ -359,8 +358,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> >       *current_stage = KVM_BEFORE_MAPPINGS;
> >
> >       for (i = 0; i < nr_vcpus; i++)
> > -             pthread_create(&vcpu_threads[i], NULL, vcpu_worker,
> > -                            test_args.vcpus[i]);
> > +             kvm_create_vcpu_thread(&vcpu_threads[i], NULL,
> > +                                    vcpu_worker, test_args.vcpus[i], i);
> >
> >       vcpus_complete_new_stage(*current_stage);
> >       pr_info("Started all vCPUs successfully\n");
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index f1cb1627161f..c252c912f1ba 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -2021,3 +2021,50 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
> >               break;
> >       }
> >  }
> > +
> > +/*
> > + * Create a named thread
> > + *
> > + * Input Args:
>
> thread is missing here
>
> > + *   attr - the attributes for the new thread
> > + *   start_routine - the routine to run in the thread context
> > + *   arg - the argument passed to start_routine
> > + *   name - the name of the thread
> > + *
> > + * Output Args:
> > + *   thread - the thread to be created
> > + *
> > + * Create a thread with user specified name.
> > + */
> > +void pthread_create_with_name(pthread_t *thread, const pthread_attr_t *attr,
> > +                     void *(*start_routine)(void *), void *arg, char *name)
> > +{
> > +     int r;
> > +
> > +     r = pthread_create(thread, attr, start_routine, arg);
> > +     TEST_ASSERT(!r, "thread(%s) creation failed, r = %d", name, r);
> > +     pthread_setname_np(*thread, name);
> > +}
> > +
> > +/*
> > + * Create a vcpu thread
> > + *
> > + * Input Args:
>
> thread is missing here
>
> > + *   attr - the attributes for the new thread
> > + *   start_routine - the routine to run in the thread context
> > + *   arg - the argument passed to start_routine
> > + *   vcpu_id - the id of the vcpu
> > + *
> > + * Output Args:
> > + *   thread - the thread to be created
> > + *
> > + * Create a vcpu thread with the name in "vcpu##id" format.
> > + */
> > +void kvm_create_vcpu_thread(pthread_t *thread, const pthread_attr_t *attr,
>
> If I'm reading the patch correctly, attr is always NULL for vCPU
> threads, so just drop it until we need it?
>
> > +                     void *(*start_routine)(void *), void *arg, int vcpu_id)
>
> I think it would be helpful to tie the vcpu_id to something real, rather
> than leaving it up to the caller. How about passing in the struct
> kvm_vcpu here and using vcpu->id in the thread name?
>
> Another cleanup we could do on top of this series would be to stash the
> vCPU pthread_t into struct kvm_vcpu, which would eliminate another
> parameter here and make this API super clean:
>
> void vcpu_create_thread(struct kvm_vcpu *vcpu, void *(*fn)(void *), void *arg)
> {
>         ...
> }
>
> > +{
> > +     char vcpu_name[6];
> > +
> > +     sprintf(vcpu_name, "%s%d", "vcpu", vcpu_id);
>
> There's no need to dynamically insert "vcpu". Also, could we include a
> dash to make the name slightly easier to parse? Putting it together...
>
>         char vcpu_name[16];
>
>         sprintf(vcpu_name, "vcpu-%d", vcpu_id);

Oh and I forgot to mention, vcpu_name[6] is too small of a buffer
since there can be more than 10 vCPUs (honestly, even more than 100 is
quite normal).

>
> > +     pthread_create_with_name(thread, attr, start_routine, arg, vcpu_name);
> > +}
> > diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > index 9618b37c66f7..4e57181daffc 100644
> > --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> > +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > @@ -274,7 +274,8 @@ void perf_test_start_vcpu_threads(int nr_vcpus,
> >               vcpu->vcpu_idx = i;
> >               WRITE_ONCE(vcpu->running, false);
> >
> > -             pthread_create(&vcpu->thread, NULL, vcpu_thread_main, vcpu);
> > +             kvm_create_vcpu_thread(&vcpu->thread, NULL,
> > +                                    vcpu_thread_main, vcpu, i);
> >       }
> >
> >       for (i = 0; i < nr_vcpus; i++) {
> > diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
> > index 9a6e4f3ad6b5..04524694e2b6 100644
> > --- a/tools/testing/selftests/kvm/max_guest_memory_test.c
> > +++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
> > @@ -3,7 +3,6 @@
> >
> >  #include <stdio.h>
> >  #include <stdlib.h>
> > -#include <pthread.h>
> >  #include <semaphore.h>
> >  #include <sys/types.h>
> >  #include <signal.h>
> > @@ -110,7 +109,8 @@ static pthread_t *spawn_workers(struct kvm_vm *vm, struct kvm_vcpu **vcpus,
> >               info[i].vcpu = vcpus[i];
> >               info[i].start_gpa = gpa;
> >               info[i].end_gpa = gpa + nr_bytes;
> > -             pthread_create(&threads[i], NULL, vcpu_worker, &info[i]);
> > +             kvm_create_vcpu_thread(&threads[i], NULL,
> > +                                    vcpu_worker, &info[i], i);
> >       }
> >       return threads;
> >  }
> > diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> > index 6ee7e1dde404..769300181597 100644
> > --- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> > +++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
> > @@ -16,7 +16,6 @@
> >  #include <asm/unistd.h>
> >  #include <time.h>
> >  #include <poll.h>
> > -#include <pthread.h>
> >  #include <linux/bitmap.h>
> >  #include <linux/bitops.h>
> >  #include <linux/userfaultfd.h>
> > diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
> > index 44995446d942..041a07acba3d 100644
> > --- a/tools/testing/selftests/kvm/memslot_perf_test.c
> > +++ b/tools/testing/selftests/kvm/memslot_perf_test.c
> > @@ -6,7 +6,6 @@
> >   *
> >   * Basic guest setup / host vCPU thread code lifted from set_memory_region_test.
> >   */
> > -#include <pthread.h>
> >  #include <sched.h>
> >  #include <semaphore.h>
> >  #include <stdatomic.h>
> > @@ -332,7 +331,7 @@ static void launch_vm(struct vm_data *data)
> >  {
> >       pr_info_v("Launching the test VM\n");
> >
> > -     pthread_create(&data->vcpu_thread, NULL, vcpu_worker, data);
> > +     kvm_create_vcpu_thread(&data->vcpu_thread, NULL, vcpu_worker, data, 0);
> >
> >       /* Ensure the guest thread is spun up. */
> >       wait_for_vcpu();
> > diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> > index 6f88da7e60be..11e0b1b7abb1 100644
> > --- a/tools/testing/selftests/kvm/rseq_test.c
> > +++ b/tools/testing/selftests/kvm/rseq_test.c
> > @@ -2,7 +2,6 @@
> >  #define _GNU_SOURCE /* for program_invocation_short_name */
> >  #include <errno.h>
> >  #include <fcntl.h>
> > -#include <pthread.h>
> >  #include <sched.h>
> >  #include <stdio.h>
> >  #include <stdlib.h>
> > @@ -226,8 +225,8 @@ int main(int argc, char *argv[])
> >       vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> >       ucall_init(vm, NULL);
> >
> > -     pthread_create(&migration_thread, NULL, migration_worker,
> > -                    (void *)(unsigned long)syscall(SYS_gettid));
> > +     pthread_create_with_name(&migration_thread, NULL, migration_worker,
> > +            (void *)(unsigned long)syscall(SYS_gettid), "migration-thread");
> >
> >       for (i = 0; !done; i++) {
> >               vcpu_run(vcpu);
> > diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
> > index 0d55f508d595..4c9ab5595a22 100644
> > --- a/tools/testing/selftests/kvm/set_memory_region_test.c
> > +++ b/tools/testing/selftests/kvm/set_memory_region_test.c
> > @@ -1,7 +1,6 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  #define _GNU_SOURCE /* for program_invocation_short_name */
> >  #include <fcntl.h>
> > -#include <pthread.h>
> >  #include <sched.h>
> >  #include <semaphore.h>
> >  #include <signal.h>
> > @@ -134,7 +133,7 @@ static struct kvm_vm *spawn_vm(struct kvm_vcpu **vcpu, pthread_t *vcpu_thread,
> >       hva = addr_gpa2hva(vm, MEM_REGION_GPA);
> >       memset(hva, 0, 2 * 4096);
> >
> > -     pthread_create(vcpu_thread, NULL, vcpu_worker, *vcpu);
> > +     kvm_create_vcpu_thread(vcpu_thread, NULL, vcpu_worker, *vcpu, 0);
> >
> >       /* Ensure the guest thread is spun up. */
> >       wait_for_vcpu();
> > diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
> > index db8967f1a17b..be93a333ce04 100644
> > --- a/tools/testing/selftests/kvm/steal_time.c
> > +++ b/tools/testing/selftests/kvm/steal_time.c
> > @@ -8,7 +8,6 @@
> >  #include <stdio.h>
> >  #include <time.h>
> >  #include <sched.h>
> > -#include <pthread.h>
> >  #include <linux/kernel.h>
> >  #include <asm/kvm.h>
> >  #include <asm/kvm_para.h>
> > @@ -290,7 +289,8 @@ int main(int ac, char **av)
> >
> >               /* Steal time from the VCPU. The steal time thread has the same CPU affinity as the VCPUs. */
> >               run_delay = get_run_delay();
> > -             pthread_create(&thread, &attr, do_steal_time, NULL);
> > +             pthread_create_with_name(&thread, &attr, do_steal_time,
> > +                                      NULL, "steal-time-thread");
> >               do
> >                       sched_yield();
> >               while (get_run_delay() - run_delay < MIN_RUN_DELAY_NS);
> > diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
> > index fb02581953a3..abbd5a4f2828 100644
> > --- a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
> > @@ -16,7 +16,6 @@
> >  #include <kvm_util.h>
> >  #include <linux/kvm.h>
> >  #include <processor.h>
> > -#include <pthread.h>
> >  #include <stdio.h>
> >  #include <stdlib.h>
> >  #include <string.h>
> > @@ -69,7 +68,7 @@ void test(void)
> >       tc.run = run;
> >       srand(getpid());
> >       for (i = 0; i < NTHREAD; i++) {
> > -             pthread_create(&th[i], NULL, thr, (void *)(uintptr_t)&tc);
> > +             kvm_create_vcpu_thread(&th[i], NULL, thr, (void *)(uintptr_t)&tc, i);
> >               usleep(rand() % 10000);
> >       }
> >       for (i = 0; i < NTHREAD; i++)
> > diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> > index c7ef97561038..b00ba08a19eb 100644
> > --- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> > +++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
> > @@ -5,7 +5,6 @@
> >  #include <sys/ioctl.h>
> >  #include <stdlib.h>
> >  #include <errno.h>
> > -#include <pthread.h>
> >
> >  #include "test_util.h"
> >  #include "kvm_util.h"
> > diff --git a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
> > index 47139aab7408..a6511c399173 100644
> > --- a/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
> > +++ b/tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
> > @@ -15,7 +15,6 @@
> >  #include <time.h>
> >  #include <sched.h>
> >  #include <signal.h>
> > -#include <pthread.h>
> >
> >  #define NR_TEST_VCPUS 20
> >
> > @@ -102,7 +101,8 @@ int main(int argc, char *argv[])
> >       pthread_t cpu_threads[NR_TEST_VCPUS];
> >       unsigned long cpu;
> >       for (cpu = 0; cpu < NR_TEST_VCPUS; cpu++)
> > -             pthread_create(&cpu_threads[cpu], NULL, run_vcpu, (void *)cpu);
> > +             kvm_create_vcpu_thread(&cpu_threads[cpu], NULL,
> > +                                    run_vcpu, (void *)cpu, cpu);
> >
> >       unsigned long failures = 0;
> >       for (cpu = 0; cpu < NR_TEST_VCPUS; cpu++) {
> > diff --git a/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c b/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
> > index a897c7fd8abe..24a89a3a11db 100644
> > --- a/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
> > @@ -19,7 +19,6 @@
> >   */
> >
> >  #define _GNU_SOURCE /* for program_invocation_short_name */
> > -#include <pthread.h>
> >  #include <inttypes.h>
> >  #include <string.h>
> >  #include <time.h>
> > diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
> > index 3d272d7f961e..8bdef8e0f2b0 100644
> > --- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
> > +++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
> > @@ -22,7 +22,6 @@
> >
> >  #define _GNU_SOURCE /* for program_invocation_short_name */
> >  #include <getopt.h>
> > -#include <pthread.h>
> >  #include <inttypes.h>
> >  #include <string.h>
> >  #include <time.h>
> > @@ -393,7 +392,6 @@ void get_cmdline_args(int argc, char *argv[], int *run_secs,
> >
> >  int main(int argc, char *argv[])
> >  {
> > -     int r;
> >       int wait_secs;
> >       const int max_halter_wait = 10;
> >       int run_secs = 0;
> > @@ -436,9 +434,8 @@ int main(int argc, char *argv[])
> >       params[1].pipis_rcvd = pipis_rcvd;
> >
> >       /* Start halter vCPU thread and wait for it to execute first HLT. */
> > -     r = pthread_create(&threads[0], NULL, vcpu_thread, &params[0]);
> > -     TEST_ASSERT(r == 0,
> > -                 "pthread_create halter failed errno=%d", errno);
> > +     kvm_create_vcpu_thread(&threads[0], NULL,
> > +                            vcpu_thread, &params[0], 0);
> >       fprintf(stderr, "Halter vCPU thread started\n");
> >
> >       wait_secs = 0;
> > @@ -455,8 +452,7 @@ int main(int argc, char *argv[])
> >               "Halter vCPU thread reported its APIC ID: %u after %d seconds.\n",
> >               data->halter_apic_id, wait_secs);
> >
> > -     r = pthread_create(&threads[1], NULL, vcpu_thread, &params[1]);
> > -     TEST_ASSERT(r == 0, "pthread_create sender failed errno=%d", errno);
> > +     kvm_create_vcpu_thread(&threads[1], NULL, vcpu_thread, &params[1], 1);
> >
> >       fprintf(stderr,
> >               "IPI sender vCPU thread started. Letting vCPUs run for %d seconds.\n",
> > --
> > 2.27.0
> >
