Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44886B3440
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 03:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjCJC2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 21:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjCJC2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 21:28:54 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C00FA7A9E
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 18:28:52 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id a4-20020a056830008400b0069432af1380so2181974oto.13
        for <kvm@vger.kernel.org>; Thu, 09 Mar 2023 18:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678415331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3pU6ySJSXj+2B0JGqj0iTBYA4wuiPU2243tS+OTzYls=;
        b=nUTsMdMLd5wvUp5SCex7ZYoMNlfHOLgJJPnpykv5JPOXWfNcEe14vCzaFOOe2PB9NF
         77Dehi6f4A+Xn1xQ5MSLILtThT7ZdDp54UnEmwbCiixpBzq1z112M9Zb2zOdbJHGaOKQ
         mVaWNf8graMWTdHu9j/ty/KQ+eofoWig79+SZncxx6HOZC6b8oUgWWk0mWzCLELo3wmm
         rRixK4LYuTj8R/i6in0AEVEuc2NvulHoAjg1YPY4vxlWPiRIMqdu3BhmP4HwK5Nv0cY6
         LJemLecX6iPcZnhiod2ecL+xeFqk3OVRcAvdoF8Zd23oKkqvLfqViOGuWYmdpk3jIMec
         C9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678415331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3pU6ySJSXj+2B0JGqj0iTBYA4wuiPU2243tS+OTzYls=;
        b=y5WD8bXoP2nLPmMwenyx4JxLhNBb9MnFO0p3XnQKl5bWaxkaakhgxNCi0TBy78lzI+
         7bK3WpGBJ388N8O5XiOE2i0Wecr2YQkgIHZ7cZMNuH9M4GSt/Mttz4YiX2DPFJcxJxvN
         OWFWr5kkFTD7La8fBIIoMe0BddM/KzFVABIjPzSJeAhq+GKQNxVNO9qSQ2RpxXKEjIfZ
         AoYyHdLyjV3fxDHaltkOHElIqkSl7em2spiDpltD8D6IpfDdZakXjCHZl6uGpdC729JC
         0CvlnPDackLUYR0qZFY5OjNB7gfdxeG0QM0gsNLX3GfIvo1oJJN1ThMmhrOgP1wqpPrj
         k2mQ==
X-Gm-Message-State: AO0yUKUfVojFQiY5tBOBRGw43PBNUAywGrrcoCmlajFPnK/SyPYsncD+
        mz7Wbg7rwvtGuABczd8vC+YjqMZwvSILaVmIjOtbRg==
X-Google-Smtp-Source: AK7set8yleViLGb59eIMj0H8CbfeqXyQUC4ki+K4L+2iS4etpbofAXP3z+TPCyIgJ6De+4gSCSc2ydhCzJ/gyt/vlYg=
X-Received: by 2002:a9d:5f87:0:b0:68d:7557:f74c with SMTP id
 g7-20020a9d5f87000000b0068d7557f74cmr8085114oti.7.1678415331372; Thu, 09 Mar
 2023 18:28:51 -0800 (PST)
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-12-rananta@google.com>
 <CAAeT=FwdkFLzp0S+T7L_ppbaU5VvdfT1Uuubm3cjuDKykJchNQ@mail.gmail.com>
In-Reply-To: <CAAeT=FwdkFLzp0S+T7L_ppbaU5VvdfT1Uuubm3cjuDKykJchNQ@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 9 Mar 2023 18:28:40 -0800
Message-ID: <CAJHc60wW+9hwTFomJVWKwzG+3MUjGNAJe0M82p-266GwhO6cOw@mail.gmail.com>
Subject: Re: [REPOST PATCH 11/16] selftests: KVM: aarch64: Add vCPU migration
 test for PMU
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Mon, Mar 6, 2023 at 7:44=E2=80=AFPM Reiji Watanabe <reijiw@google.com> w=
rote:
>
> Hi Raghu,
>
> On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Implement a stress test for KVM by frequently force-migrating the
> > vCPU to random pCPUs in the system. This would validate the
> > save/restore functionality of KVM and starting/stopping of
> > PMU counters as necessary.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/vpmu_test.c | 195 +++++++++++++++++-
> >  1 file changed, 193 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/te=
sting/selftests/kvm/aarch64/vpmu_test.c
> > index 5c166df245589..0c9d801f4e602 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> > @@ -19,9 +19,15 @@
> >   * higher exception levels (EL2, EL3). Verify this functionality by
> >   * configuring and trying to count the events for EL2 in the guest.
> >   *
> > + * 4. Since the PMU registers are per-cpu, stress KVM by frequently
> > + * migrating the guest vCPU to random pCPUs in the system, and check
> > + * if the vPMU is still behaving as expected.
> > + *
> >   * Copyright (c) 2022 Google LLC.
> >   *
> >   */
> > +#define _GNU_SOURCE
> > +
> >  #include <kvm_util.h>
> >  #include <processor.h>
> >  #include <test_util.h>
> > @@ -30,6 +36,11 @@
> >  #include <linux/arm-smccc.h>
> >  #include <linux/bitfield.h>
> >  #include <linux/bitmap.h>
> > +#include <stdlib.h>
> > +#include <pthread.h>
> > +#include <sys/sysinfo.h>
> > +
> > +#include "delay.h"
> >
> >  /* The max number of the PMU event counters (excluding the cycle count=
er) */
> >  #define ARMV8_PMU_MAX_GENERAL_COUNTERS (ARMV8_PMU_MAX_COUNTERS - 1)
> > @@ -37,6 +48,8 @@
> >  /* The max number of event numbers that's supported */
> >  #define ARMV8_PMU_MAX_EVENTS           64
> >
> > +#define msecs_to_usecs(msec)           ((msec) * 1000LL)
> > +
> >  /*
> >   * The macros and functions below for reading/writing PMEV{CNTR,TYPER}=
<n>_EL0
> >   * were basically copied from arch/arm64/kernel/perf_event.c.
> > @@ -265,6 +278,7 @@ enum test_stage {
> >         TEST_STAGE_COUNTER_ACCESS =3D 1,
> >         TEST_STAGE_KVM_EVENT_FILTER,
> >         TEST_STAGE_KVM_EVTYPE_FILTER,
> > +       TEST_STAGE_VCPU_MIGRATION,
> >  };
> >
> >  struct guest_data {
> > @@ -275,6 +289,19 @@ struct guest_data {
> >
> >  static struct guest_data guest_data;
> >
> > +#define VCPU_MIGRATIONS_TEST_ITERS_DEF         1000
> > +#define VCPU_MIGRATIONS_TEST_MIGRATION_FREQ_MS 2
> > +
> > +struct test_args {
> > +       int vcpu_migration_test_iter;
> > +       int vcpu_migration_test_migrate_freq_ms;
> > +};
> > +
> > +static struct test_args test_args =3D {
> > +       .vcpu_migration_test_iter =3D VCPU_MIGRATIONS_TEST_ITERS_DEF,
> > +       .vcpu_migration_test_migrate_freq_ms =3D VCPU_MIGRATIONS_TEST_M=
IGRATION_FREQ_MS,
> > +};
> > +
> >  static void guest_sync_handler(struct ex_regs *regs)
> >  {
> >         uint64_t esr, ec;
> > @@ -352,7 +379,6 @@ static bool pmu_event_is_supported(uint64_t event)
> >                 GUEST_ASSERT_3(!(_tval & mask), _tval, mask, set_expect=
ed);\
> >  }
> >
> > -
> >  /*
> >   * Extra instructions inserted by the compiler would be difficult to c=
ompensate
> >   * for, so hand assemble everything between, and including, the PMCR a=
ccesses
> > @@ -459,6 +485,13 @@ static void test_event_count(uint64_t event, int p=
mc_idx, bool expect_count)
> >         }
> >  }
> >
> > +static void test_basic_pmu_functionality(void)
> > +{
> > +       /* Test events on generic and cycle counters */
> > +       test_instructions_count(0, true);
> > +       test_cycles_count(true);
> > +}
> > +
> >  /*
> >   * Check if @mask bits in {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers
> >   * are set or cleared as specified in @set_expected.
> > @@ -748,6 +781,16 @@ static void guest_evtype_filter_test(void)
> >         GUEST_ASSERT_2(cnt =3D=3D 0, cnt, typer);
> >  }
> >
> > +static void guest_vcpu_migration_test(void)
> > +{
> > +       /*
> > +        * While the userspace continuously migrates this vCPU to rando=
m pCPUs,
> > +        * run basic PMU functionalities and verify the results.
> > +        */
> > +       while (test_args.vcpu_migration_test_iter--)
> > +               test_basic_pmu_functionality();
> > +}
> > +
> >  static void guest_code(void)
> >  {
> >         switch (guest_data.test_stage) {
> > @@ -760,6 +803,9 @@ static void guest_code(void)
> >         case TEST_STAGE_KVM_EVTYPE_FILTER:
> >                 guest_evtype_filter_test();
> >                 break;
> > +       case TEST_STAGE_VCPU_MIGRATION:
> > +               guest_vcpu_migration_test();
> > +               break;
> >         default:
> >                 GUEST_ASSERT_1(0, guest_data.test_stage);
> >         }
> > @@ -837,6 +883,7 @@ create_vpmu_vm(void *guest_code, struct kvm_pmu_eve=
nt_filter *pmu_event_filters)
> >
> >         vpmu_vm->vm =3D vm =3D vm_create(1);
> >         vm_init_descriptor_tables(vm);
> > +
> >         /* Catch exceptions for easier debugging */
> >         for (ec =3D 0; ec < ESR_EC_NUM; ec++) {
> >                 vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT, ec,
> > @@ -881,6 +928,8 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
> >         struct ucall uc;
> >
> >         sync_global_to_guest(vcpu->vm, guest_data);
> > +       sync_global_to_guest(vcpu->vm, test_args);
> > +
> >         vcpu_run(vcpu);
> >         switch (get_ucall(vcpu, &uc)) {
> >         case UCALL_ABORT:
> > @@ -1098,11 +1147,112 @@ static void run_kvm_evtype_filter_test(void)
> >         destroy_vpmu_vm(vpmu_vm);
> >  }
> >
> > +struct vcpu_migrate_data {
> > +       struct vpmu_vm *vpmu_vm;
> > +       pthread_t *pt_vcpu;
>
> Nit: Originally, I wasn't sure what 'pt' stands for.
> Also, the 'pt_vcpu' made me think this would be a pointer to a vCPU.
> Perhaps renaming this to 'vcpu_pthread' might be more clear ?
>
Haha, no problem. I'll change it to vcpu_pthread.
>
> > +       bool vcpu_done;
> > +};
> > +
> > +static void *run_vcpus_migrate_test_func(void *arg)
> > +{
> > +       struct vcpu_migrate_data *migrate_data =3D arg;
> > +       struct vpmu_vm *vpmu_vm =3D migrate_data->vpmu_vm;
> > +
> > +       run_vcpu(vpmu_vm->vcpu);
> > +       migrate_data->vcpu_done =3D true;
> > +
> > +       return NULL;
> > +}
> > +
> > +static uint32_t get_pcpu(void)
> > +{
> > +       uint32_t pcpu;
> > +       unsigned int nproc_conf;
> > +       cpu_set_t online_cpuset;
> > +
> > +       nproc_conf =3D get_nprocs_conf();
> > +       sched_getaffinity(0, sizeof(cpu_set_t), &online_cpuset);
> > +
> > +       /* Randomly find an available pCPU to place the vCPU on */
> > +       do {
> > +               pcpu =3D rand() % nproc_conf;
> > +       } while (!CPU_ISSET(pcpu, &online_cpuset));
> > +
> > +       return pcpu;
> > +}
> > +
> > +static int migrate_vcpu(struct vcpu_migrate_data *migrate_data)
>
> Nit: You might want to pass a pthread_t rather than migrate_data
> unless the function uses some more fields of the data in the
> following patches.
>
The upcoming patch, which introduces multiple-vcpus, moves
migrate_date into a global array (one element per-vCPU). That patch
passes only the vcpu index as an arg to migrate_vcpu().
I originally thought we would embed more stuff into migrate_data, and
passed this. But I guess I can just pass pthread_t.

> > +{
> > +       int ret;
> > +       cpu_set_t cpuset;
> > +       uint32_t new_pcpu =3D get_pcpu();
> > +
> > +       CPU_ZERO(&cpuset);
> > +       CPU_SET(new_pcpu, &cpuset);
> > +
> > +       pr_debug("Migrating vCPU to pCPU: %u\n", new_pcpu);
> > +
> > +       ret =3D pthread_setaffinity_np(*migrate_data->pt_vcpu, sizeof(c=
puset), &cpuset);
> > +
> > +       /* Allow the error where the vCPU thread is already finished */
> > +       TEST_ASSERT(ret =3D=3D 0 || ret =3D=3D ESRCH,
> > +                   "Failed to migrate the vCPU to pCPU: %u; ret: %d\n"=
, new_pcpu, ret);
> > +
> > +       return ret;
> > +}
> > +
> > +static void *vcpus_migrate_func(void *arg)
> > +{
> > +       struct vcpu_migrate_data *migrate_data =3D arg;
> > +
> > +       while (!migrate_data->vcpu_done) {
> > +               usleep(msecs_to_usecs(test_args.vcpu_migration_test_mig=
rate_freq_ms));
> > +               migrate_vcpu(migrate_data);
> > +       }
> > +
> > +       return NULL;
> > +}
> > +
> > +static void run_vcpu_migration_test(uint64_t pmcr_n)
> > +{
> > +       int ret;
> > +       struct vpmu_vm *vpmu_vm;
> > +       pthread_t pt_vcpu, pt_sched;
> > +       struct vcpu_migrate_data migrate_data =3D {
> > +               .pt_vcpu =3D &pt_vcpu,
> > +               .vcpu_done =3D false,
> > +       };
> > +
> > +       __TEST_REQUIRE(get_nprocs() >=3D 2, "At least two pCPUs needed =
for vCPU migration test");
>
> Considering that get_pcpu() chooses the target CPU from CPUs returned
> from sched_getaffinity(), I would think the test should use the number of
> the bits set in the returned cpu_set_t from sched_getaffinity() here
> instead of get_nprocs(), as those numbers could be different (e.g.  if th=
e
> test runs with taskset with a subset of the CPUs on the system).
>
I'm not familiar with tasksets, but if you feel the current approach
could cause problems, I'll switch to your suggestion. Thanks.
>
> > +
> > +       guest_data.test_stage =3D TEST_STAGE_VCPU_MIGRATION;
> > +       guest_data.expected_pmcr_n =3D pmcr_n;
> > +
> > +       migrate_data.vpmu_vm =3D vpmu_vm =3D create_vpmu_vm(guest_code,=
 NULL);
> > +
> > +       /* Initialize random number generation for migrating vCPUs to r=
andom pCPUs */
> > +       srand(time(NULL));
> > +
> > +       /* Spawn a vCPU thread */
> > +       ret =3D pthread_create(&pt_vcpu, NULL, run_vcpus_migrate_test_f=
unc, &migrate_data);
> > +       TEST_ASSERT(!ret, "Failed to create the vCPU thread");
> > +
> > +       /* Spawn a scheduler thread to force-migrate vCPUs to various p=
CPUs */
> > +       ret =3D pthread_create(&pt_sched, NULL, vcpus_migrate_func, &mi=
grate_data);
>
> Why do you want to spawn another thread to run vcpus_migrate_func(),
> rather than calling that from the current thread ?
>
>
I suppose it should be fine calling from the current thread (unless
I'm forgetting a reason why I had a similar behavior in arch_timer
test).

Thank you.
Raghavendra
> > +       TEST_ASSERT(!ret, "Failed to create the scheduler thread for mi=
grating the vCPUs");
> > +
> > +       pthread_join(pt_sched, NULL);
> > +       pthread_join(pt_vcpu, NULL);
> > +
> > +       destroy_vpmu_vm(vpmu_vm);
> > +}
> > +
> >  static void run_tests(uint64_t pmcr_n)
> >  {
> >         run_counter_access_tests(pmcr_n);
> >         run_kvm_event_filter_test();
> >         run_kvm_evtype_filter_test();
> > +       run_vcpu_migration_test(pmcr_n);
> >  }
> >
> >  /*
> > @@ -1121,12 +1271,53 @@ static uint64_t get_pmcr_n_limit(void)
> >         return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
> >  }
> >
> > -int main(void)
> > +static void print_help(char *name)
> > +{
> > +       pr_info("Usage: %s [-h] [-i vcpu_migration_test_iterations] [-m=
 vcpu_migration_freq_ms]\n",
> > +               name);
> > +       pr_info("\t-i: Number of iterations of vCPU migrations test (de=
fault: %u)\n",
> > +               VCPU_MIGRATIONS_TEST_ITERS_DEF);
> > +       pr_info("\t-m: Frequency (in ms) of vCPUs to migrate to differe=
nt pCPU. (default: %u)\n",
> > +               VCPU_MIGRATIONS_TEST_MIGRATION_FREQ_MS);
> > +       pr_info("\t-h: print this help screen\n");
> > +}
> > +
> > +static bool parse_args(int argc, char *argv[])
> > +{
> > +       int opt;
> > +
> > +       while ((opt =3D getopt(argc, argv, "hi:m:")) !=3D -1) {
> > +               switch (opt) {
> > +               case 'i':
> > +                       test_args.vcpu_migration_test_iter =3D
> > +                               atoi_positive("Nr vCPU migration iterat=
ions", optarg);
> > +                       break;
> > +               case 'm':
> > +                       test_args.vcpu_migration_test_migrate_freq_ms =
=3D
> > +                               atoi_positive("vCPU migration frequency=
", optarg);
> > +                       break;
> > +               case 'h':
> > +               default:
> > +                       goto err;
> > +               }
> > +       }
> > +
> > +       return true;
> > +
> > +err:
> > +       print_help(argv[0]);
> > +       return false;
> > +}
> > +
> > +int main(int argc, char *argv[])
> >  {
> >         uint64_t pmcr_n;
> >
> >         TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
> >
> > +       if (!parse_args(argc, argv))
> > +               exit(KSFT_SKIP);
> > +
> >         pmcr_n =3D get_pmcr_n_limit();
> >         run_tests(pmcr_n);
> >
> > --
> > 2.39.1.581.gbfd45094c4-goog
> >
>
> Thanks,
> Reiji
