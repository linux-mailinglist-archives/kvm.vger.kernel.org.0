Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65035709E77
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 19:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjESRo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 13:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjESRoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 13:44:55 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409CAF9
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 10:44:54 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-19a27f1cd6dso763647fac.0
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 10:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684518293; x=1687110293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vw7bAWgQhs8itST8AjGS8yGdpD9mxTcuVC3kzh8kFuo=;
        b=PWi5jHF3pokk4Sa9MYBtQ0lNlBRkLeuvQ//QadVxk9RBEqdn8hjv1829DLhkvxX2gj
         CkmZVWmYixfFGlOI4NCXC8/34eKJ6dmMQshj6YPNUPqPTYaEYtlz3VQbKi8b+hpV1Ui+
         FqtU0U4+jao+bzswF9zFpp7o3cGj268oafz8ZV5EP2t8sp7U6459eb9krVBG9k2bYbW6
         E3VT/wuIOPq4CqRiRIakPhC5nEKdBl3Ne0rjuBkcrNlxWpuUFhRX9mH5Sh4cMEKp+5cp
         3Tb13qVggsCHb3D55zb/k2tRPPhMJPFN9tiIgfINVg93BSLIpob1ZmIqoKV6Y2JovRo3
         2rig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684518293; x=1687110293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vw7bAWgQhs8itST8AjGS8yGdpD9mxTcuVC3kzh8kFuo=;
        b=JRcCAZHvrnZL/ig1evNm9Tn7yQvBfszU1nA5A1mgZ//qKFfikoOoIW1Kl3Fq6EUYhU
         VL7daghlFieYpoVxoLPEu8zy7o3/aeejHRU+6aRIQnt33hZGmvNwwS0PBzBkQ7wYG9JX
         UggQ3w1SB9pXGUxQvXCbmexYbnjKgEzQBKprNSzUjCJNQMlSvDBfvk2fguh5O5GHhAXH
         P2SikO4MPNz4jKVWO9ACCRkRNskJqeYSm9X/e3g0HpgVwrCMH8M+cgUx5siE9vSWz53Z
         WMv13GCcfPbuydiFfLr3cZF4nwV0RBrNcubCukf1KZGkVPcuKZ2G+M321eal8q59xdE8
         UG9w==
X-Gm-Message-State: AC+VfDy1OVHhFMX/vSjv7Upio5ggSmx6UWbM5vUiPCdxBs+pcqLnrGgX
        4kIkDlVX0txvJ6b8blgejFGiHuSB8AI/NV/kyNPZrTvEaJVhFnnKoG4=
X-Google-Smtp-Source: ACHHUZ6HXe/5cXwt9PSd3tPJ1pf0xuOmp/yLfNEnegpXA7TASv2SXi+CKk0/iuRI+iWVjoj4kYg1sy1fj/hVhkc7ZRw=
X-Received: by 2002:a05:6870:e0c6:b0:199:fa90:a62 with SMTP id
 a6-20020a056870e0c600b00199fa900a62mr3677372oab.8.1684518293349; Fri, 19 May
 2023 10:44:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230517061015.1915934-1-jingzhangos@google.com>
 <20230517061015.1915934-2-jingzhangos@google.com> <2e727b02fe9141098ed474ef49ddc495@huawei.com>
 <CAAdAUtiWkqaymY3e3=m3YHw9FNGYf6rsFsAVkFKpUh-p9nd+gQ@mail.gmail.com> <f8ad69243ac5407f8d4d78689bba8c9a@huawei.com>
In-Reply-To: <f8ad69243ac5407f8d4d78689bba8c9a@huawei.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Fri, 19 May 2023 10:44:41 -0700
Message-ID: <CAAdAUtiR9JWm7V++9jNPPznc4jBG9sDgkfDMW5Vck610O3XCUw@mail.gmail.com>
Subject: Re: [PATCH v9 1/5] KVM: arm64: Save ID registers' sanitized value per guest
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
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
        Reiji Watanabe <reijiw@google.com>,
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

HI Shameerali,

On Fri, May 19, 2023 at 1:08=E2=80=AFAM Shameerali Kolothum Thodi
<shameerali.kolothum.thodi@huawei.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Jing Zhang [mailto:jingzhangos@google.com]
> > Sent: 18 May 2023 20:49
> > To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> > Cc: KVM <kvm@vger.kernel.org>; KVMARM <kvmarm@lists.linux.dev>;
> > ARMLinux <linux-arm-kernel@lists.infradead.org>; Marc Zyngier
> > <maz@kernel.org>; Oliver Upton <oupton@google.com>; Will Deacon
> > <will@kernel.org>; Paolo Bonzini <pbonzini@redhat.com>; James Morse
> > <james.morse@arm.com>; Alexandru Elisei <alexandru.elisei@arm.com>;
> > Suzuki K Poulose <suzuki.poulose@arm.com>; Fuad Tabba
> > <tabba@google.com>; Reiji Watanabe <reijiw@google.com>; Raghavendra
> > Rao Ananta <rananta@google.com>
> > Subject: Re: [PATCH v9 1/5] KVM: arm64: Save ID registers' sanitized va=
lue
> > per guest
> >
> > Hi Shameerali,
> >
> > On Thu, May 18, 2023 at 12:17=E2=80=AFAM Shameerali Kolothum Thodi
> > <shameerali.kolothum.thodi@huawei.com> wrote:
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: Jing Zhang [mailto:jingzhangos@google.com]
> > > > Sent: 17 May 2023 07:10
> > > > To: KVM <kvm@vger.kernel.org>; KVMARM <kvmarm@lists.linux.dev>;
> > > > ARMLinux <linux-arm-kernel@lists.infradead.org>; Marc Zyngier
> > > > <maz@kernel.org>; Oliver Upton <oupton@google.com>
> > > > Cc: Will Deacon <will@kernel.org>; Paolo Bonzini
> > <pbonzini@redhat.com>;
> > > > James Morse <james.morse@arm.com>; Alexandru Elisei
> > > > <alexandru.elisei@arm.com>; Suzuki K Poulose
> > <suzuki.poulose@arm.com>;
> > > > Fuad Tabba <tabba@google.com>; Reiji Watanabe <reijiw@google.com>;
> > > > Raghavendra Rao Ananta <rananta@google.com>; Jing Zhang
> > > > <jingzhangos@google.com>
> > > > Subject: [PATCH v9 1/5] KVM: arm64: Save ID registers' sanitized va=
lue
> > per
> > > > guest
> > > >
> > > > Introduce id_regs[] in kvm_arch as a storage of guest's ID register=
s,
> > > > and save ID registers' sanitized value in the array at KVM_CREATE_V=
M.
> > > > Use the saved ones when ID registers are read by the guest or
> > > > userspace (via KVM_GET_ONE_REG).
> > > >
> > > > No functional change intended.
> > > >
> > > > Co-developed-by: Reiji Watanabe <reijiw@google.com>
> > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_host.h | 20 +++++++++
> > > >  arch/arm64/kvm/arm.c              |  1 +
> > > >  arch/arm64/kvm/sys_regs.c         | 69
> > > > +++++++++++++++++++++++++------
> > > >  arch/arm64/kvm/sys_regs.h         |  7 ++++
> > > >  4 files changed, 85 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h
> > > > b/arch/arm64/include/asm/kvm_host.h
> > > > index 7e7e19ef6993..949a4a782844 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -178,6 +178,21 @@ struct kvm_smccc_features {
> > > >       unsigned long vendor_hyp_bmap;
> > > >  };
> > > >
> > > > +/*
> > > > + * Emulated CPU ID registers per VM
> > > > + * (Op0, Op1, CRn, CRm, Op2) of the ID registers to be saved in it
> > > > + * is (3, 0, 0, crm, op2), where 1<=3Dcrm<8, 0<=3Dop2<8.
> > > > + *
> > > > + * These emulated idregs are VM-wide, but accessed from the contex=
t of
> > a
> > > > vCPU.
> > > > + * Access to id regs are guarded by kvm_arch.config_lock.
> > > > + */
> > > > +#define KVM_ARM_ID_REG_NUM   56
> > > > +#define IDREG_IDX(id)                (((sys_reg_CRm(id) - 1) << 3)=
 |
> > sys_reg_Op2(id))
> > > > +#define IDREG(kvm, id)
> > ((kvm)->arch.idregs.regs[IDREG_IDX(id)])
> > > > +struct kvm_idregs {
> > > > +     u64 regs[KVM_ARM_ID_REG_NUM];
> > > > +};
> > > >
> > >
> > > Not sure we really need this struct here. Why can't this array be mov=
ed to
> > > struct kvm_arch directly?
> > It was put in kvm_arch directly before, then got into its own
> > structure in v5 according to the comments here:
> > https://lore.kernel.org/all/861qlaxzyw.wl-maz@kernel.org/#t
>
> Ok.
>
> > > >  typedef unsigned int pkvm_handle_t;
> > > >
> > > >  struct kvm_protected_vm {
> > > > @@ -253,6 +268,9 @@ struct kvm_arch {
> > > >       struct kvm_smccc_features smccc_feat;
> > > >       struct maple_tree smccc_filter;
> > > >
> > > > +     /* Emulated CPU ID registers */
> > > > +     struct kvm_idregs idregs;
> > > > +
> > > >       /*
> > > >        * For an untrusted host VM, 'pkvm.handle' is used to lookup
> > > >        * the associated pKVM instance in the hypervisor.
> > > > @@ -1045,6 +1063,8 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm
> > > > *kvm,
> > > >  int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
> > > >                                   struct kvm_arm_counter_offset
> > *offset);
> > > >
> > > > +void kvm_arm_init_id_regs(struct kvm *kvm);
> > > > +
> > > >  /* Guest/host FPSIMD coordination helpers */
> > > >  int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
> > > >  void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
> > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > index 14391826241c..774656a0718d 100644
> > > > --- a/arch/arm64/kvm/arm.c
> > > > +++ b/arch/arm64/kvm/arm.c
> > > > @@ -163,6 +163,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned
> > > > long type)
> > > >
> > > >       set_default_spectre(kvm);
> > > >       kvm_arm_init_hypercalls(kvm);
> > > > +     kvm_arm_init_id_regs(kvm);
> > > >
> > > >       /*
> > > >        * Initialise the default PMUver before there is a chance to
> > > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > > index 71b12094d613..d2ee3a1c7f03 100644
> > > > --- a/arch/arm64/kvm/sys_regs.c
> > > > +++ b/arch/arm64/kvm/sys_regs.c
> > > > @@ -41,6 +41,7 @@
> > > >   * 64bit interface.
> > > >   */
> > > >
> > > > +static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id=
);
> > > >  static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
> > > >
> > > >  static bool read_from_write_only(struct kvm_vcpu *vcpu,
> > > > @@ -364,7 +365,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu=
,
> > > >                         struct sys_reg_params *p,
> > > >                         const struct sys_reg_desc *r)
> > > >  {
> > > > -     u64 val =3D read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > > > +     u64 val =3D kvm_arm_read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
> > > >       u32 sr =3D reg_to_encoding(r);
> > > >
> > > >       if (!(val & (0xfUL << ID_AA64MMFR1_EL1_LO_SHIFT))) {
> > > > @@ -1208,16 +1209,9 @@ static u8 pmuver_to_perfmon(u8 pmuver)
> > > >       }
> > > >  }
> > > >
> > > > -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > > > -static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct sys_reg=
_desc
> > > > const *r)
> > > > +static u64 kvm_arm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id=
)
> > > >  {
> > > > -     u32 id =3D reg_to_encoding(r);
> > > > -     u64 val;
> > > > -
> > > > -     if (sysreg_visible_as_raz(vcpu, r))
> > > > -             return 0;
> > > > -
> > > > -     val =3D read_sanitised_ftr_reg(id);
> > > > +     u64 val =3D IDREG(vcpu->kvm, id);
> > > >
> > > >       switch (id) {
> > > >       case SYS_ID_AA64PFR0_EL1:
> > > > @@ -1280,6 +1274,26 @@ static u64 read_id_reg(const struct
> > kvm_vcpu
> > > > *vcpu, struct sys_reg_desc const *r
> > > >       return val;
> > > >  }
> > > >
> > > > +/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > > > +static u64 read_id_reg(const struct kvm_vcpu *vcpu, struct
> > sys_reg_desc
> > > > const *r)
> > > > +{
> > > > +     if (sysreg_visible_as_raz(vcpu, r))
> > > > +             return 0;
> > > > +
> > > > +     return kvm_arm_read_id_reg(vcpu, reg_to_encoding(r));
> > > > +}
> > > > +
> > > > +/*
> > > > + * Return true if the register's (Op0, Op1, CRn, CRm, Op2) is
> > > > + * (3, 0, 0, crm, op2), where 1<=3Dcrm<8, 0<=3Dop2<8.
> > > > + */
> > > > +static inline bool is_id_reg(u32 id)
> > > > +{
> > > > +     return (sys_reg_Op0(id) =3D=3D 3 && sys_reg_Op1(id) =3D=3D 0 =
&&
> > > > +             sys_reg_CRn(id) =3D=3D 0 && sys_reg_CRm(id) >=3D 1 &&
> > > > +             sys_reg_CRm(id) < 8);
> > > > +}
> > > > +
> > > >  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
> > > >                                 const struct sys_reg_desc *r)
> > > >  {
> > > > @@ -2244,8 +2258,8 @@ static bool trap_dbgdidr(struct kvm_vcpu
> > *vcpu,
> > > >       if (p->is_write) {
> > > >               return ignore_write(vcpu, p);
> > > >       } else {
> > > > -             u64 dfr =3D
> > read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
> > > > -             u64 pfr =3D
> > read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
> > > > +             u64 dfr =3D kvm_arm_read_id_reg(vcpu,
> > SYS_ID_AA64DFR0_EL1);
> > > > +             u64 pfr =3D kvm_arm_read_id_reg(vcpu,
> > SYS_ID_AA64PFR0_EL1);
> > >
> > > Does this change the behavior slightly as now within the
> > kvm_arm_read_id_reg()
> > > the val will be further adjusted based on KVM/vCPU?
> > That's a good question. Although the actual behavior would be the same
> > no matter read idreg with read_sanitised_ftr_reg or
> > kvm_arm_read_id_reg, it is possible that the behavior would change
> > potentially in the future.
> > Since now every guest has its own idregs, for every guest, the idregs
> > should be read from kvm_arm_read_id_reg instead of
> > read_sanitised_ftr_reg.
> > The point is, for trap_dbgdidr, we should read AA64DFR0/AA64PFR0 from
> > host or the VM-scope?
>
> Ok. I was just double checking whether it changes the behavior now itself=
 or
> not as we claim no functional changes in this series. As far as host vs V=
M
> scope, I am not sure as well. From a quick look through the history of de=
bug
> support, couldn=E2=80=99t find anything that mandates host values though.
>
> Thanks,
> Shameer
>
Thanks for the investigation. Let's keep it this way now and see if
there are any other comments.

Jing
