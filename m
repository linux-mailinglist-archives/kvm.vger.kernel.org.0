Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB4970C43B
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 19:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbjEVR1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 13:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjEVR1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 13:27:24 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE335E9
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 10:27:22 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-19e69a8c58bso470281fac.3
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 10:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684776442; x=1687368442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lGm3z+8llPSaHrhufRl+ALYbuFw178Ej6kpXrs2ZlzI=;
        b=2wqombPCf7WPKNQM2EjxgGkKnwrxzLl2f3DzoR9kCpV2cqMHrA1XfaBPXnmq4uUOuS
         97MIwirv92Ex5GktbR/0ymWxMEHLsZhB14IWSo4kBmwiF6PopdmCDbYcAoWdXHxNBJ3S
         2RA4iku9fQ7zRJOXYRQNCG/qKHPvQht5xfhfgfpWI0oj2CvTRpIvZFQWygo9BIVQ5PQW
         AHzgbPht50JWbgWsOuciMwoVOXfULwcMOTggCSmP7WaxBTu9rE1m7MShuL4UUNonihjM
         K2sSkEVtNFtrXLrQmJlpkM84Avej5bqcq/oVYFuC3nUcIQs7r9RAFtZHzMD9hHnOLq5m
         Ingw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684776442; x=1687368442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lGm3z+8llPSaHrhufRl+ALYbuFw178Ej6kpXrs2ZlzI=;
        b=YYmjBRGX9ULqE6r/yMhQEBTkDB9Caiz5IgPdM9NKcy6VEc5TMNrfudVA9uG0qyjvbH
         DOLdeRXSjkr7St+HAshUb2SPgxXsbxj5ddlfh1GqeFCfqFPG4B3ECY8AudTKgekWCl1b
         tM7WzAnSUONIRCbFVsi7+TFreMlwBs2JmigE+/hKxa78Q+GKTccIejKNdsN0e8dUck9a
         fVEi1DnUiPKo8h+UG0JSEZtJbqSvpKmwu5nElzSe8+0DnD3OykW9ffjXht6SijgXq9pI
         YR1eQJkLdB2/u6e/7PqkMqR1OM+BWRJgNMAKD+Yp9m32RXxVkbpX7m6VlW77eqonjTYY
         w+FQ==
X-Gm-Message-State: AC+VfDwCuUVISpu3CBo/LmdCCA43FFgTxNwUHnySrqlwHu6/BRXRumXZ
        4dSqNXsup+coHNJrlEL/LS2u0isqbugZmTZkTwuKzg==
X-Google-Smtp-Source: ACHHUZ461r+BzuxQBLYMmN7k1+CnkmCzG8f9pz6NXjsm/LQLuY26EzzOYIKFdA8ytJnZI/NyCJl/MrTADUyEl9fl/c0=
X-Received: by 2002:a05:6870:a2c4:b0:19a:733:53c3 with SMTP id
 w4-20020a056870a2c400b0019a073353c3mr6233830oak.35.1684776442152; Mon, 22 May
 2023 10:27:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230517061015.1915934-1-jingzhangos@google.com>
 <20230517061015.1915934-2-jingzhangos@google.com> <2e727b02fe9141098ed474ef49ddc495@huawei.com>
 <CAAdAUtiWkqaymY3e3=m3YHw9FNGYf6rsFsAVkFKpUh-p9nd+gQ@mail.gmail.com>
 <f8ad69243ac5407f8d4d78689bba8c9a@huawei.com> <CAAdAUtiR9JWm7V++9jNPPznc4jBG9sDgkfDMW5Vck610O3XCUw@mail.gmail.com>
 <20230519221636.jey62kmyrsncuytu@google.com>
In-Reply-To: <20230519221636.jey62kmyrsncuytu@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Mon, 22 May 2023 10:27:10 -0700
Message-ID: <CAAdAUtitsbDxAcgH4aFogjLubX3w0fFbYgU+JRgprynxZB2QzA@mail.gmail.com>
Subject: Re: [PATCH v9 1/5] KVM: arm64: Save ID registers' sanitized value per guest
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On Fri, May 19, 2023 at 3:16=E2=80=AFPM Reiji Watanabe <reijiw@google.com> =
wrote:
>
> On Fri, May 19, 2023 at 10:44:41AM -0700, Jing Zhang wrote:
> > HI Shameerali,
> >
> > On Fri, May 19, 2023 at 1:08=E2=80=AFAM Shameerali Kolothum Thodi
> > <shameerali.kolothum.thodi@huawei.com> wrote:
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: Jing Zhang [mailto:jingzhangos@google.com]
> > > > Sent: 18 May 2023 20:49
> > > > To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com=
>
> > > > Cc: KVM <kvm@vger.kernel.org>; KVMARM <kvmarm@lists.linux.dev>;
> > > > ARMLinux <linux-arm-kernel@lists.infradead.org>; Marc Zyngier
> > > > <maz@kernel.org>; Oliver Upton <oupton@google.com>; Will Deacon
> > > > <will@kernel.org>; Paolo Bonzini <pbonzini@redhat.com>; James Morse
> > > > <james.morse@arm.com>; Alexandru Elisei <alexandru.elisei@arm.com>;
> > > > Suzuki K Poulose <suzuki.poulose@arm.com>; Fuad Tabba
> > > > <tabba@google.com>; Reiji Watanabe <reijiw@google.com>; Raghavendra
> > > > Rao Ananta <rananta@google.com>
> > > > Subject: Re: [PATCH v9 1/5] KVM: arm64: Save ID registers' sanitize=
d value
> > > > per guest
> > > >
> > > > Hi Shameerali,
> > > >
> > > > On Thu, May 18, 2023 at 12:17=E2=80=AFAM Shameerali Kolothum Thodi
> > > > <shameerali.kolothum.thodi@huawei.com> wrote:
> > > > >
> > > > >
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Jing Zhang [mailto:jingzhangos@google.com]
> > > > > > Sent: 17 May 2023 07:10
> > > > > > To: KVM <kvm@vger.kernel.org>; KVMARM <kvmarm@lists.linux.dev>;
> > > > > > ARMLinux <linux-arm-kernel@lists.infradead.org>; Marc Zyngier
> > > > > > <maz@kernel.org>; Oliver Upton <oupton@google.com>
> > > > > > Cc: Will Deacon <will@kernel.org>; Paolo Bonzini
> > > > <pbonzini@redhat.com>;
> > > > > > James Morse <james.morse@arm.com>; Alexandru Elisei
> > > > > > <alexandru.elisei@arm.com>; Suzuki K Poulose
> > > > <suzuki.poulose@arm.com>;
> > > > > > Fuad Tabba <tabba@google.com>; Reiji Watanabe <reijiw@google.co=
m>;
> > > > > > Raghavendra Rao Ananta <rananta@google.com>; Jing Zhang
> > > > > > <jingzhangos@google.com>
> > > > > > Subject: [PATCH v9 1/5] KVM: arm64: Save ID registers' sanitize=
d value
> > > > per
> > > > > > guest
> > > > > >
> > > > > > Introduce id_regs[] in kvm_arch as a storage of guest's ID regi=
sters,
> > > > > > and save ID registers' sanitized value in the array at KVM_CREA=
TE_VM.
> > > > > > Use the saved ones when ID registers are read by the guest or
> > > > > > userspace (via KVM_GET_ONE_REG).
> > > > > >
> > > > > > No functional change intended.
> > > > > >
> > > > > > Co-developed-by: Reiji Watanabe <reijiw@google.com>
> > > > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > > > > ---
> > > > > >  arch/arm64/include/asm/kvm_host.h | 20 +++++++++
> > > > > >  arch/arm64/kvm/arm.c              |  1 +
> > > > > >  arch/arm64/kvm/sys_regs.c         | 69
> > > > > > +++++++++++++++++++++++++------
> > > > > >  arch/arm64/kvm/sys_regs.h         |  7 ++++
> > > > > >  4 files changed, 85 insertions(+), 12 deletions(-)
> > > > > >
> > > > > > diff --git a/arch/arm64/include/asm/kvm_host.h
> > > > > > b/arch/arm64/include/asm/kvm_host.h
> > > > > > index 7e7e19ef6993..949a4a782844 100644
> > > > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > > > @@ -178,6 +178,21 @@ struct kvm_smccc_features {
> > > > > >       unsigned long vendor_hyp_bmap;
> > > > > >  };
> > > > > >
> > > > > > +/*
> > > > > > + * Emulated CPU ID registers per VM
> > > > > > + * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved i=
n it
> > > > > > + * is (3, 0, 0, crm, op2), where 1<=3Dcrm<8, 0<=3Dop2<8.
> > > > > > + *
> > > > > > + * These emulated idregs are VM-wide, but accessed from the co=
ntext of
> > > > a
> > > > > > vCPU.
> > > > > > + * Access to id regs are guarded by kvm_arch.config_lock.
>
> Nit: This statement doesn't seem to be true yet :)
Will remend it.
>
>
> > > > > > + */
> > > > > > +#define KVM_ARM_ID_REG_NUM   56
> > > > > > +#define IDREG_IDX(id)                (((sys_reg_CRm(id) - 1) <=
< 3) |
> > > > sys_reg_Op2(id))
> > > > > > +#define IDREG(kvm, id)
> > > > ((kvm)->arch.idregs.regs[IDREG_IDX(id)])
> > > > > > +struct kvm_idregs {
> > > > > > +     u64 regs[KVM_ARM_ID_REG_NUM];
> > > > > > +};
> > > > > >
> > > > >
> > > > > Not sure we really need this struct here. Why can't this array be=
 moved to
> > > > > struct kvm_arch directly?
> > > > It was put in kvm_arch directly before, then got into its own
> > > > structure in v5 according to the comments here:
> > > > https://lore.kernel.org/all/861qlaxzyw.wl-maz@kernel.org/#t
> > >
> > > Ok.
> > >
> > > > > >  typedef unsigned int pkvm_handle_t;
> > > > > >
> > > > > >  struct kvm_protected_vm {
> > > > > > @@ -253,6 +268,9 @@ struct kvm_arch {
> > > > > >       struct kvm_smccc_features smccc_feat;
> > > > > >       struct maple_tree smccc_filter;
> > > > > >
> > > > > > +     /* Emulated CPU ID registers */
> > > > > > +     struct kvm_idregs idregs;
> > > > > > +
> > > > > >       /*
> > > > > >        * For an untrusted host VM, 'pkvm.handle' is used to loo=
kup
> > > > > >        * the associated pKVM instance in the hypervisor.
> > > > > > @@ -1045,6 +1063,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm
> > > > > > *kvm,
> > > > > >  int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
> > > > > >                                   struct kvm_arm_counter_offset
> > > > *offset);
> > > > > >
> > > > > > +void kvm_arm_init_id_regs(struct kvm *kvm);
> > > > > > +
> > > > > >  /* Guest/host FPSIMD coordination helpers */
> > > > > >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> > > > > >  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> > > > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > > > index 14391826241c..774656a0718d 100644
> > > > > > --- a/arch/arm64/kvm/arm.c
> > > > > > +++ b/arch/arm64/kvm/arm.c
> > > > > > @@ -163,6 +163,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsig=
ned
> > > > > > long type)
> > > > > >
> > > > > >       set_default_spectre(kvm);
> > > > > >       kvm_arm_init_hypercalls(kvm);
> > > > > > +     kvm_arm_init_id_regs(kvm);
> > > > > >
> > > > > >       /*
> > > > > >        * Initialise the default PMUver before there is a chance=
 to
> > > > > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_reg=
s.c
> > > > > > index 71b12094d613..d2ee3a1c7f03 100644
> > > > > > --- a/arch/arm64/kvm/sys_regs.c
> > > > > > +++ b/arch/arm64/kvm/sys_regs.c
> > > > > > @@ -41,6 +41,7 @@
> > > > > >   * 64bit interface.
> > > > > >   */
> > > > > >
> > > > > > +static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u3=
2 id);
> > > > > >  static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
> > > > > >
> > > > > >  static bool read_from_write_only(struct kvm_vcpu *vcpu,
> > > > > > @@ -364,7 +365,7 @@ static bool trap_loregion(struct kvm_vcpu *=
vcpu,
> > > > > >                         struct sys_reg_params *p,
> > > > > >                         const struct sys_reg_desc *r)
> > > > > >  {
> > > > > > -     u64 val =3D read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > > > > > +     u64 val =3D kvm_arm_read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL=
1);
> > > > > >       u32 sr =3D reg_to_encoding(r);
> > > > > >
> > > > > >       if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
> > > > > > @@ -1208,16 +1209,9 @@ static u8 pmuver_to_perfmon(u8 pmuver)
> > > > > >       }
> > > > > >  }
> > > > > >
> > > > > > -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > > > > > -static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys=
_reg_desc
> > > > > > const *r)
> > > > > > +static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u3=
2 id)
> > > > > >  {
> > > > > > -     u32 id =3D reg_to_encoding(r);
> > > > > > -     u64 val;
> > > > > > -
> > > > > > -     if (sysreg_visible_as_raz(vcpu, r))
> > > > > > -             return 0;
> > > > > > -
> > > > > > -     val =3D read_sanitised_ftr_reg(id);
> > > > > > +     u64 val =3D IDREG(vcpu->kvm, id);
> > > > > >
> > > > > >       switch (id) {
> > > > > >       case SYS_ID_AA64PFR0_EL1:
> > > > > > @@ -1280,6 +1274,26 @@ static u64 read_id_reg(const struct
> > > > kvm_vcpu
> > > > > > *vcpu, struct sys_reg_desc const *r
> > > > > >       return val;
> > > > > >  }
> > > > > >
> > > > > > +/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > > > > > +static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct
> > > > sys_reg_desc
> > > > > > const *r)
> > > > > > +{
> > > > > > +     if (sysreg_visible_as_raz(vcpu, r))
> > > > > > +             return 0;
> > > > > > +
> > > > > > +     return kvm_arm_read_id_reg(vcpu, reg_to_encoding(r));
> > > > > > +}
> > > > > > +
> > > > > > +/*
> > > > > > + * Return true if the register's (Op0, Op1, CRn, CRm, Op2) is
> > > > > > + * (3, 0, 0, crm, op2), where 1<=3Dcrm<8, 0<=3Dop2<8.
> > > > > > + */
> > > > > > +static inline bool is_id_reg(u32 id)
> > > > > > +{
> > > > > > +     return (sys_reg_Op0(id) =3D=3D 3 && sys_reg_Op1(id) =3D=
=3D 0 &&
> > > > > > +             sys_reg_CRn(id) =3D=3D 0 && sys_reg_CRm(id) >=3D =
1 &&
> > > > > > +             sys_reg_CRm(id) < 8);
> > > > > > +}
> > > > > > +
> > > > > >  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
> > > > > >                                 const struct sys_reg_desc *r)
> > > > > >  {
> > > > > > @@ -2244,8 +2258,8 @@ static bool trap_dbgdidr(struct kvm_vcpu
> > > > *vcpu,
> > > > > >       if (p->is_write) {
> > > > > >               return ignore_write(vcpu, p);
> > > > > >       } else {
> > > > > > -             u64 dfr =3D
> > > > read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> > > > > > -             u64 pfr =3D
> > > > read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> > > > > > +             u64 dfr =3D kvm_arm_read_id_reg(vcpu,
> > > > SYS_ID_AA64DFR0_EL1);
> > > > > > +             u64 pfr =3D kvm_arm_read_id_reg(vcpu,
> > > > SYS_ID_AA64PFR0_EL1);
> > > > >
> > > > > Does this change the behavior slightly as now within the
> > > > kvm_arm_read_id_reg()
> > > > > the val will be further adjusted based on KVM/vCPU?
> > > > That's a good question. Although the actual behavior would be the s=
ame
> > > > no matter read idreg with read_sanitised_ftr_reg or
> > > > kvm_arm_read_id_reg, it is possible that the behavior would change
> > > > potentially in the future.
> > > > Since now every guest has its own idregs, for every guest, the idre=
gs
> > > > should be read from kvm_arm_read_id_reg instead of
> > > > read_sanitised_ftr_reg.
> > > > The point is, for trap_dbgdidr, we should read AA64DFR0/AA64PFR0 fr=
om
> > > > host or the VM-scope?
> > >
> > > Ok. I was just double checking whether it changes the behavior now it=
self or
> > > not as we claim no functional changes in this series. As far as host =
vs VM
> > > scope, I am not sure as well. From a quick look through the history o=
f debug
> > > support, couldn=E2=80=99t find anything that mandates host values tho=
ugh.
>
> We should use the VM-scope AA64DFR0/AA64PFR0 values here.
> As trap_dbgdidr() is the emulation code for the guest's reading DBGDIDR,
> its WRPs, BRPs, CTX_CMPs, and EL3 field must be consistent with the ones
> in the guest's AA64DFR0_EL1/AA64PFR0_EL1 values.
>
> As Jing said, it doesn't matter practically until we allow userspace to
> modify those fields though :)
>
> Thank you,
> Reiji

Thanks,
Jing
