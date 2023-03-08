Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F7D6AFDF7
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 05:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCHEoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 23:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjCHEoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 23:44:20 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD269CFC9
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 20:44:18 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id h11-20020a17090a2ecb00b00237c740335cso856843pjs.3
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 20:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678250658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8mLQfF6ZGKw2BR9aAplYP+Gj0qOysuIIakxQ46pVCDg=;
        b=tJgJoFS8sd0T9sKiG+DinK2idR8zn7Gq5TjsRiYFb1fnb0NiMRFO1OEzv0hxgCyb01
         SLYcRI8lamPxfvKw4MdwZ0S7hldTjbHf1onkWys7P6wug46YYch0dstfL2GhQAFKuOxt
         zNZOJB2k3oofOPMWlSaqU5Lzmb63FUFaYOub6FhQfISouG/MxjngXwbgnT1S+4YgbG4I
         CzVCxOXX5CCSyy5fwTZmu9g/Nydb+k1PAvhenVaBG7KLfpm30IzZs1a4ezxbxEc3T0ct
         g0pPArb2roXWSXAvITXl5hR1Jf4T6h279VLcPCVehH2StIy7/zJiqfeiaLKv6fNRQTbW
         pl8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678250658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8mLQfF6ZGKw2BR9aAplYP+Gj0qOysuIIakxQ46pVCDg=;
        b=zFhPZtLuARkpHrpAWGrulXbRqHWYrt/VBkVuWMR3BsgfAIa1tccwviOuK50lKCFUz2
         hr5oletpow5SpNSCq9q6woF73PKhv0ohnka22QIlp6EJ4sBNIfUjQr5tN2lDrObi5TA1
         0XuuL242aynwDtiAkXdXzC5XNMKIeRCJiA2RL8tf/V0e+fWivA04u1udIUJKIBFkQkn/
         2+aQd10uUw0w2xyAuNHH/QNh8jEoLAeRftATxRJP0JmJeaWfBX5CE3lyaI/du8GuYEVw
         EdmTH/fF9etoLK2r4ANVfEJlnaNMK2qWCfC1EqOlBW7H9d8o32olVIMP7bYnopWCdntA
         i2KQ==
X-Gm-Message-State: AO0yUKXd0HW+mSuxTMLpn4TQgFKit2hF7OVzcveINKnap/ntQ7IBvKj0
        ejQ8byKfDV9zMOAKYMt7U0Jl/W0yiaCgmzFHR/Cuag==
X-Google-Smtp-Source: AK7set8HG8ZsHU4Smobm3ok043bymkLE+2W6bR9JWvH1imsZ6MtoIw5FiKewVbHltbRx9O+UAuw//MaKYJVUehGjlqo=
X-Received: by 2002:a17:902:7e8b:b0:19e:8781:81b2 with SMTP id
 z11-20020a1709027e8b00b0019e878181b2mr6644153pla.5.1678250657701; Tue, 07 Mar
 2023 20:44:17 -0800 (PST)
MIME-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com> <20230215010717.3612794-17-rananta@google.com>
In-Reply-To: <20230215010717.3612794-17-rananta@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 7 Mar 2023 20:44:01 -0800
Message-ID: <CAAeT=FxJsY5NF8Bq5cAfm-Jc=Ln3CnDJYey49_TTLqQKvS+UNw@mail.gmail.com>
Subject: Re: [REPOST PATCH 16/16] selftests: KVM: aarch64: Extend the vCPU
 migration test to multi-vCPUs
To:     Raghavendra Rao Ananta <rananta@google.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghu,

On Tue, Feb 14, 2023 at 5:07=E2=80=AFPM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> To test KVM's handling of multiple vCPU contexts together, that are
> frequently migrating across random pCPUs in the system, extend the test
> to create a VM with multiple vCPUs and validate the behavior.
>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vpmu_test.c | 166 ++++++++++++------
>  1 file changed, 114 insertions(+), 52 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/test=
ing/selftests/kvm/aarch64/vpmu_test.c
> index 239fc7e06b3b9..c9d8e5f9a22ab 100644
> --- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> +++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
> @@ -19,11 +19,12 @@
>   * higher exception levels (EL2, EL3). Verify this functionality by
>   * configuring and trying to count the events for EL2 in the guest.
>   *
> - * 4. Since the PMU registers are per-cpu, stress KVM by frequently
> - * migrating the guest vCPU to random pCPUs in the system, and check
> - * if the vPMU is still behaving as expected. The sub-tests include
> - * testing basic functionalities such as basic counters behavior,
> - * overflow, overflow interrupts, and chained events.
> + * 4. Since the PMU registers are per-cpu, stress KVM by creating a
> + * multi-vCPU VM, then frequently migrate the guest vCPUs to random
> + * pCPUs in the system, and check if the vPMU is still behaving as
> + * expected. The sub-tests include testing basic functionalities such
> + * as basic counters behavior, overflow, overflow interrupts, and
> + * chained events.
>   *
>   * Copyright (c) 2022 Google LLC.
>   *
> @@ -348,19 +349,22 @@ struct guest_irq_data {
>         struct spinlock lock;
>  };
>
> -static struct guest_irq_data guest_irq_data;
> +static struct guest_irq_data guest_irq_data[KVM_MAX_VCPUS];
>
>  #define VCPU_MIGRATIONS_TEST_ITERS_DEF         1000
>  #define VCPU_MIGRATIONS_TEST_MIGRATION_FREQ_MS 2
> +#define VCPU_MIGRATIONS_TEST_NR_VPUS_DEF       2
>
>  struct test_args {
>         int vcpu_migration_test_iter;
>         int vcpu_migration_test_migrate_freq_ms;
> +       int vcpu_migration_test_nr_vcpus;
>  };
>
>  static struct test_args test_args =3D {
>         .vcpu_migration_test_iter =3D VCPU_MIGRATIONS_TEST_ITERS_DEF,
>         .vcpu_migration_test_migrate_freq_ms =3D VCPU_MIGRATIONS_TEST_MIG=
RATION_FREQ_MS,
> +       .vcpu_migration_test_nr_vcpus =3D VCPU_MIGRATIONS_TEST_NR_VPUS_DE=
F,
>  };
>
>  static void guest_sync_handler(struct ex_regs *regs)
> @@ -396,26 +400,34 @@ static void guest_validate_irq(int pmc_idx, uint32_=
t pmovsclr, uint32_t pmc_idx_
>         }
>  }
>
> +static struct guest_irq_data *get_irq_data(void)
> +{
> +       uint32_t cpu =3D guest_get_vcpuid();
> +
> +       return &guest_irq_data[cpu];
> +}
> +
>  static void guest_irq_handler(struct ex_regs *regs)
>  {
>         uint32_t pmc_idx_bmap;
>         uint64_t i, pmcr_n =3D get_pmcr_n();
>         uint32_t pmovsclr =3D read_pmovsclr();
>         unsigned int intid =3D gic_get_and_ack_irq();
> +       struct guest_irq_data *irq_data =3D get_irq_data();
>
>         /* No other IRQ apart from the PMU IRQ is expected */
>         GUEST_ASSERT_1(intid =3D=3D PMU_IRQ, intid);
>
> -       spin_lock(&guest_irq_data.lock);
> -       pmc_idx_bmap =3D READ_ONCE(guest_irq_data.pmc_idx_bmap);
> +       spin_lock(&irq_data->lock);
> +       pmc_idx_bmap =3D READ_ONCE(irq_data->pmc_idx_bmap);
>
>         for (i =3D 0; i < pmcr_n; i++)
>                 guest_validate_irq(i, pmovsclr, pmc_idx_bmap);
>         guest_validate_irq(ARMV8_PMU_CYCLE_COUNTER_IDX, pmovsclr, pmc_idx=
_bmap);
>
>         /* Mark IRQ as recived for the corresponding PMCs */
> -       WRITE_ONCE(guest_irq_data.irq_received_bmap, pmovsclr);
> -       spin_unlock(&guest_irq_data.lock);
> +       WRITE_ONCE(irq_data->irq_received_bmap, pmovsclr);
> +       spin_unlock(&irq_data->lock);
>
>         gic_set_eoi(intid);
>  }
> @@ -423,35 +435,40 @@ static void guest_irq_handler(struct ex_regs *regs)
>  static int pmu_irq_received(int pmc_idx)
>  {
>         bool irq_received;
> +       struct guest_irq_data *irq_data =3D get_irq_data();
>
> -       spin_lock(&guest_irq_data.lock);
> -       irq_received =3D READ_ONCE(guest_irq_data.irq_received_bmap) & BI=
T(pmc_idx);
> -       WRITE_ONCE(guest_irq_data.irq_received_bmap, guest_irq_data.pmc_i=
dx_bmap & ~BIT(pmc_idx));
> -       spin_unlock(&guest_irq_data.lock);
> +       spin_lock(&irq_data->lock);
> +       irq_received =3D READ_ONCE(irq_data->irq_received_bmap) & BIT(pmc=
_idx);
> +       WRITE_ONCE(irq_data->irq_received_bmap, irq_data->pmc_idx_bmap & =
~BIT(pmc_idx));
> +       spin_unlock(&irq_data->lock);
>
>         return irq_received;
>  }
>
>  static void pmu_irq_init(int pmc_idx)
>  {
> +       struct guest_irq_data *irq_data =3D get_irq_data();
> +
>         write_pmovsclr(BIT(pmc_idx));
>
> -       spin_lock(&guest_irq_data.lock);
> -       WRITE_ONCE(guest_irq_data.irq_received_bmap, guest_irq_data.pmc_i=
dx_bmap & ~BIT(pmc_idx));
> -       WRITE_ONCE(guest_irq_data.pmc_idx_bmap, guest_irq_data.pmc_idx_bm=
ap | BIT(pmc_idx));
> -       spin_unlock(&guest_irq_data.lock);
> +       spin_lock(&irq_data->lock);
> +       WRITE_ONCE(irq_data->irq_received_bmap, irq_data->pmc_idx_bmap & =
~BIT(pmc_idx));
> +       WRITE_ONCE(irq_data->pmc_idx_bmap, irq_data->pmc_idx_bmap | BIT(p=
mc_idx));
> +       spin_unlock(&irq_data->lock);
>
>         enable_irq(pmc_idx);
>  }
>
>  static void pmu_irq_exit(int pmc_idx)
>  {
> +       struct guest_irq_data *irq_data =3D get_irq_data();
> +
>         write_pmovsclr(BIT(pmc_idx));
>
> -       spin_lock(&guest_irq_data.lock);
> -       WRITE_ONCE(guest_irq_data.irq_received_bmap, guest_irq_data.pmc_i=
dx_bmap & ~BIT(pmc_idx));
> -       WRITE_ONCE(guest_irq_data.pmc_idx_bmap, guest_irq_data.pmc_idx_bm=
ap & ~BIT(pmc_idx));
> -       spin_unlock(&guest_irq_data.lock);
> +       spin_lock(&irq_data->lock);
> +       WRITE_ONCE(irq_data->irq_received_bmap, irq_data->pmc_idx_bmap & =
~BIT(pmc_idx));
> +       WRITE_ONCE(irq_data->pmc_idx_bmap, irq_data->pmc_idx_bmap & ~BIT(=
pmc_idx));
> +       spin_unlock(&irq_data->lock);
>
>         disable_irq(pmc_idx);
>  }
> @@ -783,7 +800,8 @@ static void test_event_count(uint64_t event, int pmc_=
idx, bool expect_count)
>  static void test_basic_pmu_functionality(void)
>  {
>         local_irq_disable();
> -       gic_init(GIC_V3, 1, (void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA)=
;
> +       gic_init(GIC_V3, test_args.vcpu_migration_test_nr_vcpus,
> +                       (void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
>         gic_irq_enable(PMU_IRQ);
>         local_irq_enable();
>
> @@ -1093,11 +1111,13 @@ static void guest_evtype_filter_test(void)
>
>  static void guest_vcpu_migration_test(void)
>  {
> +       int iter =3D test_args.vcpu_migration_test_iter;
> +
>         /*
>          * While the userspace continuously migrates this vCPU to random =
pCPUs,
>          * run basic PMU functionalities and verify the results.
>          */
> -       while (test_args.vcpu_migration_test_iter--)
> +       while (iter--)
>                 test_basic_pmu_functionality();
>  }
>
> @@ -1472,17 +1492,23 @@ static void run_kvm_evtype_filter_test(void)
>
>  struct vcpu_migrate_data {
>         struct vpmu_vm *vpmu_vm;
> -       pthread_t *pt_vcpu;
> -       bool vcpu_done;
> +       pthread_t *pt_vcpus;
> +       unsigned long *vcpu_done_map;
> +       pthread_mutex_t vcpu_done_map_lock;
>  };
>
> +struct vcpu_migrate_data migrate_data;
> +
>  static void *run_vcpus_migrate_test_func(void *arg)
>  {
> -       struct vcpu_migrate_data *migrate_data =3D arg;
> -       struct vpmu_vm *vpmu_vm =3D migrate_data->vpmu_vm;
> +       struct vpmu_vm *vpmu_vm =3D migrate_data.vpmu_vm;
> +       unsigned int vcpu_idx =3D (unsigned long)arg;
>
> -       run_vcpu(vpmu_vm->vcpus[0]);
> -       migrate_data->vcpu_done =3D true;
> +       run_vcpu(vpmu_vm->vcpus[vcpu_idx]);
> +
> +       pthread_mutex_lock(&migrate_data.vcpu_done_map_lock);
> +       __set_bit(vcpu_idx, migrate_data.vcpu_done_map);
> +       pthread_mutex_unlock(&migrate_data.vcpu_done_map_lock);
>
>         return NULL;
>  }
> @@ -1504,7 +1530,7 @@ static uint32_t get_pcpu(void)
>         return pcpu;
>  }
>
> -static int migrate_vcpu(struct vcpu_migrate_data *migrate_data)
> +static int migrate_vcpu(int vcpu_idx)
>  {
>         int ret;
>         cpu_set_t cpuset;
> @@ -1513,9 +1539,9 @@ static int migrate_vcpu(struct vcpu_migrate_data *m=
igrate_data)
>         CPU_ZERO(&cpuset);
>         CPU_SET(new_pcpu, &cpuset);
>
> -       pr_debug("Migrating vCPU to pCPU: %u\n", new_pcpu);
> +       pr_debug("Migrating vCPU %d to pCPU: %u\n", vcpu_idx, new_pcpu);
>
> -       ret =3D pthread_setaffinity_np(*migrate_data->pt_vcpu, sizeof(cpu=
set), &cpuset);
> +       ret =3D pthread_setaffinity_np(migrate_data.pt_vcpus[vcpu_idx], s=
izeof(cpuset), &cpuset);
>
>         /* Allow the error where the vCPU thread is already finished */
>         TEST_ASSERT(ret =3D=3D 0 || ret =3D=3D ESRCH,
> @@ -1526,48 +1552,74 @@ static int migrate_vcpu(struct vcpu_migrate_data =
*migrate_data)
>
>  static void *vcpus_migrate_func(void *arg)
>  {
> -       struct vcpu_migrate_data *migrate_data =3D arg;
> +       struct vpmu_vm *vpmu_vm =3D migrate_data.vpmu_vm;
> +       int i, n_done, nr_vcpus =3D vpmu_vm->nr_vcpus;
> +       bool vcpu_done;
>
> -       while (!migrate_data->vcpu_done) {
> +       do {
>                 usleep(msecs_to_usecs(test_args.vcpu_migration_test_migra=
te_freq_ms));
> -               migrate_vcpu(migrate_data);
> -       }
> +               for (n_done =3D 0, i =3D 0; i < nr_vcpus; i++) {
> +                       pthread_mutex_lock(&migrate_data.vcpu_done_map_lo=
ck);
> +                       vcpu_done =3D test_bit(i, migrate_data.vcpu_done_=
map);
> +                       pthread_mutex_unlock(&migrate_data.vcpu_done_map_=
lock);

Do we need to hold the lock here ?


> +
> +                       if (vcpu_done) {
> +                               n_done++;
> +                               continue;
> +                       }
> +
> +                       migrate_vcpu(i);
> +               }
> +
> +       } while (nr_vcpus !=3D n_done);
>
>         return NULL;
>  }
>
>  static void run_vcpu_migration_test(uint64_t pmcr_n)
>  {
> -       int ret;
> +       int i, nr_vcpus, ret;
>         struct vpmu_vm *vpmu_vm;
> -       pthread_t pt_vcpu, pt_sched;
> -       struct vcpu_migrate_data migrate_data =3D {
> -               .pt_vcpu =3D &pt_vcpu,
> -               .vcpu_done =3D false,
> -       };
> +       pthread_t pt_sched, *pt_vcpus;
>
>         __TEST_REQUIRE(get_nprocs() >=3D 2, "At least two pCPUs needed fo=
r vCPU migration test");
>
>         guest_data.test_stage =3D TEST_STAGE_VCPU_MIGRATION;
>         guest_data.expected_pmcr_n =3D pmcr_n;
>
> -       migrate_data.vpmu_vm =3D vpmu_vm =3D create_vpmu_vm(1, guest_code=
, NULL);
> +       nr_vcpus =3D test_args.vcpu_migration_test_nr_vcpus;
> +
> +       migrate_data.vcpu_done_map =3D bitmap_zalloc(nr_vcpus);
> +       TEST_ASSERT(migrate_data.vcpu_done_map, "Failed to create vCPU do=
ne bitmap");
> +       pthread_mutex_init(&migrate_data.vcpu_done_map_lock, NULL);
> +
> +       migrate_data.pt_vcpus =3D pt_vcpus =3D calloc(nr_vcpus, sizeof(*p=
t_vcpus));
> +       TEST_ASSERT(pt_vcpus, "Failed to create vCPU thread pointers");
> +
> +       migrate_data.vpmu_vm =3D vpmu_vm =3D create_vpmu_vm(nr_vcpus, gue=
st_code, NULL);
>
>         /* Initialize random number generation for migrating vCPUs to ran=
dom pCPUs */
>         srand(time(NULL));
>
> -       /* Spawn a vCPU thread */
> -       ret =3D pthread_create(&pt_vcpu, NULL, run_vcpus_migrate_test_fun=
c, &migrate_data);
> -       TEST_ASSERT(!ret, "Failed to create the vCPU thread");
> +       /* Spawn vCPU threads */
> +       for (i =3D 0; i < nr_vcpus; i++) {
> +               ret =3D pthread_create(&pt_vcpus[i], NULL,
> +                                       run_vcpus_migrate_test_func,  (vo=
id *)(unsigned long)i);
> +               TEST_ASSERT(!ret, "Failed to create the vCPU thread: %d",=
 i);
> +       }
>
>         /* Spawn a scheduler thread to force-migrate vCPUs to various pCP=
Us */
> -       ret =3D pthread_create(&pt_sched, NULL, vcpus_migrate_func, &migr=
ate_data);
> +       ret =3D pthread_create(&pt_sched, NULL, vcpus_migrate_func, NULL)=
;
>         TEST_ASSERT(!ret, "Failed to create the scheduler thread for migr=
ating the vCPUs");
>
>         pthread_join(pt_sched, NULL);
> -       pthread_join(pt_vcpu, NULL);
> +
> +       for (i =3D 0; i < nr_vcpus; i++)
> +               pthread_join(pt_vcpus[i], NULL);
>
>         destroy_vpmu_vm(vpmu_vm);
> +       free(pt_vcpus);
> +       bitmap_free(migrate_data.vcpu_done_map);
>  }
>
>  static void run_tests(uint64_t pmcr_n)
> @@ -1596,12 +1648,14 @@ static uint64_t get_pmcr_n_limit(void)
>
>  static void print_help(char *name)
>  {
> -       pr_info("Usage: %s [-h] [-i vcpu_migration_test_iterations] [-m v=
cpu_migration_freq_ms]\n",
> -               name);
> +       pr_info("Usage: %s [-h] [-i vcpu_migration_test_iterations] [-m v=
cpu_migration_freq_ms]"
> +               "[-n vcpu_migration_nr_vcpus]\n", name);
>         pr_info("\t-i: Number of iterations of vCPU migrations test (defa=
ult: %u)\n",
>                 VCPU_MIGRATIONS_TEST_ITERS_DEF);
>         pr_info("\t-m: Frequency (in ms) of vCPUs to migrate to different=
 pCPU. (default: %u)\n",
>                 VCPU_MIGRATIONS_TEST_MIGRATION_FREQ_MS);
> +       pr_info("\t-n: Number of vCPUs for vCPU migrations test. (default=
: %u)\n",
> +               VCPU_MIGRATIONS_TEST_NR_VPUS_DEF);
>         pr_info("\t-h: print this help screen\n");
>  }
>
> @@ -1609,7 +1663,7 @@ static bool parse_args(int argc, char *argv[])
>  {
>         int opt;
>
> -       while ((opt =3D getopt(argc, argv, "hi:m:")) !=3D -1) {
> +       while ((opt =3D getopt(argc, argv, "hi:m:n:")) !=3D -1) {
>                 switch (opt) {
>                 case 'i':
>                         test_args.vcpu_migration_test_iter =3D
> @@ -1619,6 +1673,14 @@ static bool parse_args(int argc, char *argv[])
>                         test_args.vcpu_migration_test_migrate_freq_ms =3D
>                                 atoi_positive("vCPU migration frequency",=
 optarg);
>                         break;
> +               case 'n':
> +                       test_args.vcpu_migration_test_nr_vcpus =3D
> +                               atoi_positive("Nr vCPUs for vCPU migratio=
ns", optarg);
> +                       if (test_args.vcpu_migration_test_nr_vcpus > KVM_=
MAX_VCPUS) {
> +                               pr_info("Max allowed vCPUs: %u\n", KVM_MA=
X_VCPUS);
> +                               goto err;
> +                       }
> +                       break;
>                 case 'h':
>                 default:
>                         goto err;
> --
> 2.39.1.581.gbfd45094c4-goog
>
>

Thanks,
Reiji
