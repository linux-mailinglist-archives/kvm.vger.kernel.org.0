Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A73A7CC979
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 19:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbjJQRHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 13:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjJQRHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 13:07:52 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5530694
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 10:07:50 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id e9e14a558f8ab-3514ece5ed4so3465ab.1
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 10:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697562469; x=1698167269; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AwAE5rwxFD5ih2zUiwM3b5hA/j9L2Ic5BRNntK8YaPY=;
        b=n5wr3dB+wRK5t1w+qzeGt2eEYkXBFDcTR9M29515ZJfms6Z8l5MHBKPlTJavjkaCmq
         /Mb1ISG87pFUHd6SVz9tzgX5yhmLGiVhyKotfj/An+B0CIVMj0MMUieasGN9p25Hd5J5
         QvKf3DflLtdnLS+AX8uRgpuFExfKfrkJuum7/hCw4Xfi744MX1Bq69axRgZvAEQpcjaU
         axF6XS784G5HxcDuIlsMpqNpBC2qY7QIuKm9XbkfM7kuM5gd/CKwgYrzEo9K/pqiovUN
         Q4Wmi0y2KtGTbjCUHnokeGz5IqfTn3dH+llMjc9Oanlr6mJEyHFyPWaYx2EcdhUDfECa
         SwmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697562469; x=1698167269;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AwAE5rwxFD5ih2zUiwM3b5hA/j9L2Ic5BRNntK8YaPY=;
        b=UKH2dkFqnUlzUoRkRg0bCQC7Viz6QI74DkLdlOYe7azQfsMD+bdq4SX9XieFwWhPU9
         bTvhEzyyuQpZ4CzSHeLBWd8V/mIdkJBHXoI7/gM0G0sufwOR2v7PCsfvSp6JP+QnL//U
         /KcoJ9yrC5khMevW8wh9+KPGaLC2Uz96QVLAuXPCenE8bVD1ryBKdNiIZujcI8k8k8Xw
         NoKll12hSNij5b9Iy0KEVq+st25hRMBl+R7qrNH9PKttMBi0PHS/aA0b3ZP1K9dnXNbK
         CNFWtobMabhHp1tVLtVjmlbGSHTFaIQi1o3qSjpvqpbp1S4YG3fnRj3aYcDiHDogbpCJ
         ECmQ==
X-Gm-Message-State: AOJu0Yy5Pklp9NDq0/tfCHfUzwAO0ZB7VS6t+OSxuC/m/43wOZG/LvlK
        xbrxh6nkP5dewMxFkE23Z00P4+3c/H4fCCCI9/JeuA==
X-Google-Smtp-Source: AGHT+IGAhiIrn4CMYtasLTuCeOD39KiBp+RhUL0BROg0inwiM6w8DlE0Vc9jFnbRiOUxsN5DLfjuGbgEJRMFVm13DH0=
X-Received: by 2002:a92:cf42:0:b0:357:9e3e:b63 with SMTP id
 c2-20020a92cf42000000b003579e3e0b63mr5811ilr.9.1697562469516; Tue, 17 Oct
 2023 10:07:49 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-11-rananta@google.com>
 <66eade47-54bb-bcf4-931a-9acfbdd5483d@redhat.com>
In-Reply-To: <66eade47-54bb-bcf4-931a-9acfbdd5483d@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 17 Oct 2023 10:07:37 -0700
Message-ID: <CAJHc60wZHUsqGgm_KCtp=8qWAKeTLThXQ69dL1aMFs_fyD80LA@mail.gmail.com>
Subject: Re: [PATCH v7 10/12] KVM: selftests: aarch64: Introduce
 vpmu_counter_access test
To:     Eric Auger <eauger@redhat.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On Tue, Oct 17, 2023 at 7:51=E2=80=AFAM Eric Auger <eauger@redhat.com> wrot=
e:
>
> Hi Raghavendra,
> On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > Introduce vpmu_counter_access test for arm64 platforms.
> > The test configures PMUv3 for a vCPU, sets PMCR_EL0.N for the vCPU,
> > and check if the guest can consistently see the same number of the
> > PMU event counters (PMCR_EL0.N) that userspace sets.
> > This test case is done with each of the PMCR_EL0.N values from
> > 0 to 31 (With the PMCR_EL0.N values greater than the host value,
> > the test expects KVM_SET_ONE_REG for the PMCR_EL0 to fail).
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../kvm/aarch64/vpmu_counter_access.c         | 247 ++++++++++++++++++
> >  2 files changed, 248 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_ac=
cess.c
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selft=
ests/kvm/Makefile
> > index a3bb36fb3cfc..416700aa196c 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -149,6 +149,7 @@ TEST_GEN_PROGS_aarch64 +=3D aarch64/smccc_filter
> >  TEST_GEN_PROGS_aarch64 +=3D aarch64/vcpu_width_config
> >  TEST_GEN_PROGS_aarch64 +=3D aarch64/vgic_init
> >  TEST_GEN_PROGS_aarch64 +=3D aarch64/vgic_irq
> > +TEST_GEN_PROGS_aarch64 +=3D aarch64/vpmu_counter_access
> >  TEST_GEN_PROGS_aarch64 +=3D access_tracking_perf_test
> >  TEST_GEN_PROGS_aarch64 +=3D demand_paging_test
> >  TEST_GEN_PROGS_aarch64 +=3D dirty_log_test
> > diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c =
b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > new file mode 100644
> > index 000000000000..58949b17d76e
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> > @@ -0,0 +1,247 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * vpmu_counter_access - Test vPMU event counter access
> > + *
> > + * Copyright (c) 2022 Google LLC.
> 2023 ;-)
Will fix in v8.
> > + *
> > + * This test checks if the guest can see the same number of the PMU ev=
ent
> > + * counters (PMCR_EL0.N) that userspace sets.
> > + * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the hos=
t.
> > + */
> > +#include <kvm_util.h>
> > +#include <processor.h>
> > +#include <test_util.h>
> > +#include <vgic.h>
> > +#include <perf/arm_pmuv3.h>
> > +#include <linux/bitfield.h>
> > +
> > +/* The max number of the PMU event counters (excluding the cycle count=
er) */
> > +#define ARMV8_PMU_MAX_GENERAL_COUNTERS       (ARMV8_PMU_MAX_COUNTERS -=
 1)
> > +
> > +struct vpmu_vm {
> > +     struct kvm_vm *vm;
> > +     struct kvm_vcpu *vcpu;
> > +     int gic_fd;
> > +};
> > +
> > +static struct vpmu_vm vpmu_vm;
> > +
> > +static uint64_t get_pmcr_n(uint64_t pmcr)
> > +{
> > +     return (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
> > +}
> > +
> > +static void set_pmcr_n(uint64_t *pmcr, uint64_t pmcr_n)
> > +{
> > +     *pmcr =3D *pmcr & ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHI=
FT);
> > +     *pmcr |=3D (pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
> > +}
> > +
> > +static void guest_sync_handler(struct ex_regs *regs)
> > +{
> > +     uint64_t esr, ec;
> > +
> > +     esr =3D read_sysreg(esr_el1);
> > +     ec =3D (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
> > +     __GUEST_ASSERT(0, "PC: 0x%lx; ESR: 0x%lx; EC: 0x%lx", regs->pc, e=
sr, ec);
> > +}
> > +
> > +/*
> > + * The guest is configured with PMUv3 with @expected_pmcr_n number of
> > + * event counters.
> > + * Check if @expected_pmcr_n is consistent with PMCR_EL0.N.
> > + */
> > +static void guest_code(uint64_t expected_pmcr_n)
> > +{
> > +     uint64_t pmcr, pmcr_n;
> > +
> > +     __GUEST_ASSERT(expected_pmcr_n <=3D ARMV8_PMU_MAX_GENERAL_COUNTER=
S,
> > +                     "Expected PMCR.N: 0x%lx; ARMv8 general counters: =
0x%lx",
> > +                     expected_pmcr_n, ARMV8_PMU_MAX_GENERAL_COUNTERS);
> > +
> > +     pmcr =3D read_sysreg(pmcr_el0);
> > +     pmcr_n =3D get_pmcr_n(pmcr);
> > +
> > +     /* Make sure that PMCR_EL0.N indicates the value userspace set */
> > +     __GUEST_ASSERT(pmcr_n =3D=3D expected_pmcr_n,
> > +                     "Expected PMCR.N: 0x%lx, PMCR.N: 0x%lx",
> > +                     pmcr_n, expected_pmcr_n);
> > +
> > +     GUEST_DONE();
> > +}
> > +
> > +#define GICD_BASE_GPA        0x8000000ULL
> > +#define GICR_BASE_GPA        0x80A0000ULL
> > +
> > +/* Create a VM that has one vCPU with PMUv3 configured. */
> > +static void create_vpmu_vm(void *guest_code)
> > +{
> > +     struct kvm_vcpu_init init;
> > +     uint8_t pmuver, ec;
> > +     uint64_t dfr0, irq =3D 23;
> > +     struct kvm_device_attr irq_attr =3D {
> > +             .group =3D KVM_ARM_VCPU_PMU_V3_CTRL,
> > +             .attr =3D KVM_ARM_VCPU_PMU_V3_IRQ,
> > +             .addr =3D (uint64_t)&irq,
> > +     };
> > +     struct kvm_device_attr init_attr =3D {
> > +             .group =3D KVM_ARM_VCPU_PMU_V3_CTRL,
> > +             .attr =3D KVM_ARM_VCPU_PMU_V3_INIT,
> > +     };
> > +
> > +     /* The test creates the vpmu_vm multiple times. Ensure a clean st=
ate */
> > +     memset(&vpmu_vm, 0, sizeof(vpmu_vm));
> > +
> > +     vpmu_vm.vm =3D vm_create(1);
> > +     vm_init_descriptor_tables(vpmu_vm.vm);
> > +     for (ec =3D 0; ec < ESR_EC_NUM; ec++) {
> > +             vm_install_sync_handler(vpmu_vm.vm, VECTOR_SYNC_CURRENT, =
ec,
> > +                                     guest_sync_handler);
> > +     }
> > +
> > +     /* Create vCPU with PMUv3 */
> > +     vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
> > +     init.features[0] |=3D (1 << KVM_ARM_VCPU_PMU_V3);
> > +     vpmu_vm.vcpu =3D aarch64_vcpu_add(vpmu_vm.vm, 0, &init, guest_cod=
e);
> > +     vcpu_init_descriptor_tables(vpmu_vm.vcpu);
> > +     vpmu_vm.gic_fd =3D vgic_v3_setup(vpmu_vm.vm, 1, 64,
> > +                                     GICD_BASE_GPA, GICR_BASE_GPA);
> __TEST_REQUIRE(vpmu_vm.gic_fd >=3D 0, "Failed to create vgic-v3, skipping=
");
> as done in some other tests
>
I'll add this in v8.
> > +
> > +     /* Make sure that PMUv3 support is indicated in the ID register *=
/
> > +     vcpu_get_reg(vpmu_vm.vcpu,
> > +                  KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
> > +     pmuver =3D FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), dfr0=
);
> > +     TEST_ASSERT(pmuver !=3D ID_AA64DFR0_PMUVER_IMP_DEF &&
> > +                 pmuver >=3D ID_AA64DFR0_PMUVER_8_0,
> > +                 "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pm=
uver);
> > +
> > +     /* Initialize vPMU */
> > +     vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
> > +     vcpu_ioctl(vpmu_vm.vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
> > +}
> > +
> > +static void destroy_vpmu_vm(void)
> > +{
> > +     close(vpmu_vm.gic_fd);
> > +     kvm_vm_free(vpmu_vm.vm);
> > +}
> > +
> > +static void run_vcpu(struct kvm_vcpu *vcpu, uint64_t pmcr_n)
> > +{
> > +     struct ucall uc;
> > +
> > +     vcpu_args_set(vcpu, 1, pmcr_n);
> > +     vcpu_run(vcpu);
> > +     switch (get_ucall(vcpu, &uc)) {
> > +     case UCALL_ABORT:
> > +             REPORT_GUEST_ASSERT(uc);
> > +             break;
> > +     case UCALL_DONE:
> > +             break;
> > +     default:
> > +             TEST_FAIL("Unknown ucall %lu", uc.cmd);
> > +             break;
> > +     }
> > +}
> > +
> > +/*
> > + * Create a guest with one vCPU, set the PMCR_EL0.N for the vCPU to @p=
mcr_n,
> > + * and run the test.
> > + */
> > +static void run_test(uint64_t pmcr_n)
> > +{
> > +     struct kvm_vcpu *vcpu;
> > +     uint64_t sp, pmcr;
> > +     struct kvm_vcpu_init init;
> > +
> > +     pr_debug("Test with pmcr_n %lu\n", pmcr_n);
> > +     create_vpmu_vm(guest_code);
> > +
> > +     vcpu =3D vpmu_vm.vcpu;
> > +
> > +     /* Save the initial sp to restore them later to run the guest aga=
in */
> > +     vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1), &sp);
> > +
> > +     /* Update the PMCR_EL0.N with @pmcr_n */
> > +     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
> > +     set_pmcr_n(&pmcr, pmcr_n);
> > +     vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
> > +
> > +     run_vcpu(vcpu, pmcr_n);
> > +
> > +     /*
> > +      * Reset and re-initialize the vCPU, and run the guest code again=
 to
> > +      * check if PMCR_EL0.N is preserved.
> > +      */
> > +     vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
> > +     init.features[0] |=3D (1 << KVM_ARM_VCPU_PMU_V3);
> > +     aarch64_vcpu_setup(vcpu, &init);
> > +     vcpu_init_descriptor_tables(vcpu);
> > +     vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), sp);
> > +     vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code)=
;
> > +
> > +     run_vcpu(vcpu, pmcr_n);
> > +
> > +     destroy_vpmu_vm();
> > +}
> > +
> > +/*
> > + * Create a guest with one vCPU, and attempt to set the PMCR_EL0.N for
> > + * the vCPU to @pmcr_n, which is larger than the host value.
> > + * The attempt should fail as @pmcr_n is too big to set for the vCPU.
> > + */
> > +static void run_error_test(uint64_t pmcr_n)
> > +{
> > +     struct kvm_vcpu *vcpu;
> > +     uint64_t pmcr, pmcr_orig;
> > +
> > +     pr_debug("Error test with pmcr_n %lu (larger than the host)\n", p=
mcr_n);
> > +     create_vpmu_vm(guest_code);
> > +     vcpu =3D vpmu_vm.vcpu;
> > +
> > +     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr_orig);
> > +     pmcr =3D pmcr_orig;
> > +
> > +     /*
> > +      * Setting a larger value of PMCR.N should not modify the field, =
and
> > +      * return a success.
> > +      */
> > +     set_pmcr_n(&pmcr, pmcr_n);
> > +     vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
> > +     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
> > +     TEST_ASSERT(pmcr_orig =3D=3D pmcr,
> > +                 "PMCR.N modified by KVM to a larger value (PMCR: 0x%l=
x) for pmcr_n: 0x%lx\n",
> > +                 pmcr, pmcr_n);
> nit: you could introduce a set_pmcr_n() routine  which creates the
> vpmu_vm and set the PMCR.N and check whether the setting is applied. An
> arg could tell the helper whether this is supposed to fail. This could
> be used in both run_error_test and run_test which both mostly use the
> same code.
Good idea. I'll think about it..

Thank you.
Raghavendra
> > +
> > +     destroy_vpmu_vm();
> > +}
> > +
> > +/*
> > + * Return the default number of implemented PMU event counters excludi=
ng
> > + * the cycle counter (i.e. PMCR_EL0.N value) for the guest.
> > + */
> > +static uint64_t get_pmcr_n_limit(void)
> > +{
> > +     uint64_t pmcr;
> > +
> > +     create_vpmu_vm(guest_code);
> > +     vcpu_get_reg(vpmu_vm.vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr=
);
> > +     destroy_vpmu_vm();
> > +     return get_pmcr_n(pmcr);
> > +}
> > +
> > +int main(void)
> > +{
> > +     uint64_t i, pmcr_n;
> > +
> > +     TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
> > +
> > +     pmcr_n =3D get_pmcr_n_limit();
> > +     for (i =3D 0; i <=3D pmcr_n; i++)
> > +             run_test(i);
> > +
> > +     for (i =3D pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
> > +             run_error_test(i);
> > +
> > +     return 0;
> > +}
>
> Besides this looks good to me.
>
> Thanks
>
> Eric
>
