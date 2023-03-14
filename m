Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D1A6B8AEF
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 07:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjCNGJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 02:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCNGJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 02:09:38 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EC55DC90
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 23:09:35 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-176b90e14a9so16195919fac.9
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 23:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678774174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oa/b1JmJ+JRpVd0DcgNo1vC8GPNb+zSNtZxPqUlZQ0s=;
        b=rZ7hxfOJ9+83Laoko1Jr0AzUIPeGjHXESHYWt5VRKfLweIbJ7t8RNxZmkGg4xIi/em
         qM9PazwYLKjh2CC5BtM76tOmm2ufhvdRUv+UsV3F/uVyjJN9o6y6ZFjIo65WOaJg/n8U
         hbn2K4ctq8wgmqzRKwaTnkpbdkR57bKEUiqYMWGTixFt2LRlgZTGM5I/Z8aCQtnFHLN+
         zyOmDoOcStqtQlXV/gXE+6bJw1cAQLCugmwHA692xq+Ez64wLBqLVPRRZ44FgBf6PCTb
         Q1/4fDiNGo6zr8AxeefwEQlHRPet4A77nr37Ta0PRFrPSy8+4yyEWB110zYTxH6qpCZe
         PiEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678774174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oa/b1JmJ+JRpVd0DcgNo1vC8GPNb+zSNtZxPqUlZQ0s=;
        b=otUOy+9u9jrqRWQlHEtqmYTsQlNeOeIb96rq3eBdzX2yO9loI2QMi3UKcpy+ysUfAJ
         a3YIjzhW6MKdbSVQwlmIVkpajo0mcnbwFsrWxL6pbBJtq0GdfwQMGeUJ4V2iT36SsaK0
         XjLZaTl1qtsIaY1NAUQXYz2poN5p8xWjCu1oqvQfO+0Rd0NJkrwpHuowq/KqxZW+A7Nc
         /uMQ1ua7jKO1cmxkrJxoiO0E04Bgn9oU4b+PqQmJnrQfIECrmqO+vBVbf5F5dpK6scB6
         AEDVVC+03UunGX49tTJV+8PnOxCK+2sxd1p5G6h75OI+kHPQ7iGeiPlAS7IQthGcM32P
         P7ZQ==
X-Gm-Message-State: AO0yUKWEem6Sz6yCmF8UAkgB4XmpYSOd2obOWLuhrZqJJfauTg7FgHIT
        MUvG8klas+HHuY+SJE5wu9Pr1f8Rm6tFD/NCtQiyqw==
X-Google-Smtp-Source: AK7set/Bk6uDTyz4XrKEWOhz6PY9GlE2aWSo8Fs7XMFkyiMIHEj216SdnY8+TwU404T2REnC+HZ6ELR4NuBAtt0PoOs=
X-Received: by 2002:a05:6870:bf8b:b0:177:ac40:8f6d with SMTP id
 av11-20020a056870bf8b00b00177ac408f6dmr2219059oac.8.1678774174080; Mon, 13
 Mar 2023 23:09:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230228062246.1222387-1-jingzhangos@google.com>
 <20230228062246.1222387-5-jingzhangos@google.com> <CAAeT=Fzm_O-fbk2+jCExtnk7x4XXO1UwiviMmn0BU53A7Ea9WQ@mail.gmail.com>
 <CAAdAUtiSfMUHwBmFwvSpo5TdsdSDiEQWqJacg7YNzU_8b+AkDw@mail.gmail.com>
 <CAAeT=FzokuakbRG5U75zCbGzgB-DN17pq+MTLCH1+4iXL7vLHQ@mail.gmail.com>
 <CAAdAUth+aVv+njiCQkvWZYC=5J+iKiLuJLO4FrJT20amkVwxrQ@mail.gmail.com> <CAAeT=FyYs1uFPZ3wBZ_Y=Q+1hJ5WCXf6NeWkO5s8-D7whJ1LDw@mail.gmail.com>
In-Reply-To: <CAAeT=FyYs1uFPZ3wBZ_Y=Q+1hJ5WCXf6NeWkO5s8-D7whJ1LDw@mail.gmail.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 13 Mar 2023 23:09:21 -0700
Message-ID: <CAAdAUthL6ETHRNqouYY0kM2ACN4p9CMzTEOHKVrk0nDTEK6EOA@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
To:     Reiji Watanabe <reijiw@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
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

Hi Reiji,

On Mon, Mar 13, 2023 at 10:14=E2=80=AFPM Reiji Watanabe <reijiw@google.com>=
 wrote:
>
> On Mon, Mar 13, 2023 at 9:37=E2=80=AFPM Jing Zhang <jingzhangos@google.co=
m> wrote:
> >
> > Hi Reiji,
> >
> > On Sun, Mar 12, 2023 at 9:13=E2=80=AFPM Reiji Watanabe <reijiw@google.c=
om> wrote:
> > >
> > > Hi Jing,
> > >
> > > On Thu, Mar 9, 2023 at 6:38=E2=80=AFPM Jing Zhang <jingzhangos@google=
.com> wrote:
> > > >
> > > > Hi Reiji,
> > > >
> > > > On Wed, Mar 8, 2023 at 8:42 AM Reiji Watanabe <reijiw@google.com> w=
rote:
> > > > >
> > > > > Hi Jing,
> > > > >
> > > > > On Mon, Feb 27, 2023 at 10:23=E2=80=AFPM Jing Zhang <jingzhangos@=
google.com> wrote:
> > > > > >
> > > > > > With per guest ID registers, PMUver settings from userspace
> > > > > > can be stored in its corresponding ID register.
> > > > > >
> > > > > > No functional change intended.
> > > > > >
> > > > > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > > > > ---
> > > > > >  arch/arm64/include/asm/kvm_host.h | 11 ++++---
> > > > > >  arch/arm64/kvm/arm.c              |  6 ----
> > > > > >  arch/arm64/kvm/id_regs.c          | 52 +++++++++++++++++++++++=
+-------
> > > > > >  include/kvm/arm_pmu.h             |  6 ++--
> > > > > >  4 files changed, 51 insertions(+), 24 deletions(-)
> > > > > >
> > > > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/inc=
lude/asm/kvm_host.h
> > > > > > index f64347eb77c2..effb61a9a855 100644
> > > > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > > > @@ -218,6 +218,12 @@ struct kvm_arch {
> > > > > >  #define KVM_ARCH_FLAG_EL1_32BIT                               =
 4
> > > > > >         /* PSCI SYSTEM_SUSPEND enabled for the guest */
> > > > > >  #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED           5
> > > > > > +       /*
> > > > > > +        * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVe=
r_IMP_DEF
> > > > > > +        * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_I=
MPDEF from
> > > > > > +        * userspace for VCPUs without PMU.
> > > > > > +        */
> > > > > > +#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU             6
> > > > > >
> > > > > >         unsigned long flags;
> > > > > >
> > > > > > @@ -230,11 +236,6 @@ struct kvm_arch {
> > > > > >
> > > > > >         cpumask_var_t supported_cpus;
> > > > > >
> > > > > > -       struct {
> > > > > > -               u8 imp:4;
> > > > > > -               u8 unimp:4;
> > > > > > -       } dfr0_pmuver;
> > > > > > -
> > > > > >         /* Hypercall features firmware registers' descriptor */
> > > > > >         struct kvm_smccc_features smccc_feat;
> > > > > >
> > > > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > > > index c78d68d011cb..fb2de2cb98cb 100644
> > > > > > --- a/arch/arm64/kvm/arm.c
> > > > > > +++ b/arch/arm64/kvm/arm.c
> > > > > > @@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsi=
gned long type)
> > > > > >         kvm_arm_set_default_id_regs(kvm);
> > > > > >         kvm_arm_init_hypercalls(kvm);
> > > > > >
> > > > > > -       /*
> > > > > > -        * Initialise the default PMUver before there is a chan=
ce to
> > > > > > -        * create an actual PMU.
> > > > > > -        */
> > > > > > -       kvm->arch.dfr0_pmuver.imp =3D kvm_arm_pmu_get_pmuver_li=
mit();
> > > > > > -
> > > > > >         return 0;
> > > > > >
> > > > > >  err_free_cpumask:
> > > > > > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.=
c
> > > > > > index 36859e4caf02..21ec8fc10d79 100644
> > > > > > --- a/arch/arm64/kvm/id_regs.c
> > > > > > +++ b/arch/arm64/kvm/id_regs.c
> > > > > > @@ -21,9 +21,12 @@
> > > > > >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> > > > > >  {
> > > > > >         if (kvm_vcpu_has_pmu(vcpu))
> > > > > > -               return vcpu->kvm->arch.dfr0_pmuver.imp;
> > > > > > -
> > > > > > -       return vcpu->kvm->arch.dfr0_pmuver.unimp;
> > > > > > +               return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0=
_EL1_PMUVer),
> > > > > > +                               IDREG(vcpu->kvm, SYS_ID_AA64DFR=
0_EL1));
> > > > > > +       else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &=
vcpu->kvm->arch.flags))
> > > > > > +               return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
> > > > > > +       else
> > > > > > +               return 0;
> > > > > >  }
> > > > > >
> > > > > >  static u8 perfmon_to_pmuver(u8 perfmon)
> > > > > > @@ -256,10 +259,19 @@ static int set_id_aa64dfr0_el1(struct kvm=
_vcpu *vcpu,
> > > > > >         if (val)
> > > > > >                 return -EINVAL;
> > > > > >
> > > > > > -       if (valid_pmu)
> > > > > > -               vcpu->kvm->arch.dfr0_pmuver.imp =3D pmuver;
> > > > > > -       else
> > > > > > -               vcpu->kvm->arch.dfr0_pmuver.unimp =3D pmuver;
> > > > > > +       if (valid_pmu) {
> > > > > > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM=
64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > > > > > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D
> > > > > > +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DF=
R0_EL1_PMUVer), pmuver);
> > > > > > +
> > > > > > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ARM64_F=
EATURE_MASK(ID_DFR0_EL1_PerfMon);
> > > > > > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D
> > > > > > +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_E=
L1_PerfMon), pmuver);
> > > > >
> > > > > The pmuver must be converted to perfmon for ID_DFR0_EL1.
> > > > Yes, wil fix it.
> > > > >
> > > > > Also, I think those registers should be updated atomically, altho=
ugh PMUver
> > > > > specified by userspace will be normally the same for all vCPUs wi=
th
> > > > > PMUv3 configured (I have the same comment for set_id_dfr0_el1()).
> > > > >
> > > > I think there is no race condition here. No corrupted data would be
> > > > set in the field, right?
> > >
> > > If userspace tries to set inconsistent values of PMUver/Perfmon
> > > for vCPUs with vPMU configured at the same time, PMUver and Perfmon
> > > won't be consistent even with this KVM code.
> > > It won't be sane userspace though :)
> > >
> > I am still not convinced. I don't believe a VM would set AArch64 and
> > AArch32 ID registers at the same time.
>
> Difference threads will set (restore) those registers for
> different vCPUs in parallel, although those data are shared per VM.
> (e.g. kvm_arm_set_fw_reg_bmap() addresses the similar case)
>
> > Anyway, let's see if there are
> > any ideas from others before adding the lockings.
> > > > >
> > > > > > +       } else if (pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_IMP_DEF=
) {
> > > > > > +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vc=
pu->kvm->arch.flags);
> > > > > > +       } else {
> > > > > > +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &=
vcpu->kvm->arch.flags);
> > > > > > +       }
> > > > > >
> > > > > >         return 0;
> > > > > >  }
> > > > > > @@ -296,10 +308,19 @@ static int set_id_dfr0_el1(struct kvm_vcp=
u *vcpu,
> > > > > >         if (val)
> > > > > >                 return -EINVAL;
> > > > > >
> > > > > > -       if (valid_pmu)
> > > > > > -               vcpu->kvm->arch.dfr0_pmuver.imp =3D perfmon_to_=
pmuver(perfmon);
> > > > > > -       else
> > > > > > -               vcpu->kvm->arch.dfr0_pmuver.unimp =3D perfmon_t=
o_pmuver(perfmon);
> > > > > > +       if (valid_pmu) {
> > > > > > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ARM64_F=
EATURE_MASK(ID_DFR0_EL1_PerfMon);
> > > > > > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D FIELD_PR=
EP(
> > > > > > +                       ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon)=
, perfmon_to_pmuver(perfmon));
> > > > >
> > > > > The perfmon value should be set for ID_DFR0_EL1 (not pmuver).
> > > > >
> > > > Sure, will fix it.
> > > > > > +
> > > > > > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM=
64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > > > > > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D FIEL=
D_PREP(
> > > > > > +                       ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUV=
er), perfmon_to_pmuver(perfmon));
> > > > > > +       } else if (perfmon =3D=3D ID_DFR0_EL1_PerfMon_IMPDEF) {
> > > > > > +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vc=
pu->kvm->arch.flags);
> > > > > > +       } else {
> > > > > > +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &=
vcpu->kvm->arch.flags);
> > > > > > +       }
> > > > > >
> > > > > >         return 0;
> > > > > >  }
> > > > > > @@ -543,4 +564,13 @@ void kvm_arm_set_default_id_regs(struct kv=
m *kvm)
> > > > > >         }
> > > > > >
> > > > > >         IDREG(kvm, SYS_ID_AA64PFR0_EL1) =3D val;
> > > > > > +
> > > > > > +       /*
> > > > > > +        * Initialise the default PMUver before there is a chan=
ce to
> > > > > > +        * create an actual PMU.
> > > > > > +        */
> > > > > > +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEATURE_MAS=
K(ID_AA64DFR0_EL1_PMUVer);
> > > > > > +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=3D
> > > > > > +               FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_P=
MUVer),
> > > > > > +                          kvm_arm_pmu_get_pmuver_limit());
> > > > > >  }
> > > > > > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > > > > > index 628775334d5e..eef67b7d9751 100644
> > > > > > --- a/include/kvm/arm_pmu.h
> > > > > > +++ b/include/kvm/arm_pmu.h
> > > > > > @@ -92,8 +92,10 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vc=
pu *vcpu);
> > > > > >  /*
> > > > > >   * Evaluates as true when emulating PMUv3p5, and false otherwi=
se.
> > > > > >   */
> > > > > > -#define kvm_pmu_is_3p5(vcpu)                                  =
         \
> > > > > > -       (vcpu->kvm->arch.dfr0_pmuver.imp >=3D ID_AA64DFR0_EL1_P=
MUVer_V3P5)
> > > > > > +#define kvm_pmu_is_3p5(vcpu)                                  =
                                 \
> > > > > > +       (kvm_vcpu_has_pmu(vcpu) &&                             =
                                 \
> > > > >
> > > > > What is the reason for adding this kvm_vcpu_has_pmu() checking ?
> > > > > I don't think this patch's changes necessitated this.
> > > > For the same VM, is it possible that some VCPUs would have PMU, but
> > > > some may not have?
> > > > That's why the kvm_vcpu_has_pmu is added here.
> > >
> > > Yes, it's possible. But, it doesn't appear that this patch or any
> > > patches in the series adds a code that newly uses the macro.
> > > I believe this macro is always used for the vCPUs with vPMU
> > > configured currently.
> > > Did you find a case where this is used for vCPUs with no vPMU ?
> > >
> > > If this change tries to address an existing issue, I think it would
> > > be nicer to fix this in a separate patch. Or it would be helpful
> > > if you could add an explanation in the commit log at least.
> > I don't think we should assume the potential users for the macro. Only
> > adding kvm_vcpu_has_pmu() in the macro can have the same semantics as
> > the original macro.
> > The original macro would return false if it is used by a vCPU without
> > vPMU. I think we should keep it as the same.
>
> The original macro always uses dfr0_pmuver.imp, which is the PMU version
> for vCPUs with PMU configured.  So, if the macro is used for vCPUs
> with no PMU configured, it might return true (it depends on the value
> of dfr0_pmuver.imp).
> Or am I missing something ??
After double checking the code, I think you are right. The
kvm_vcpu_has_pmu() is not necessary.
>
> Thank you,
> Reiji
Thanks,
Jing
