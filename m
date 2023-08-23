Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94DEF785CF8
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 18:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbjHWQGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 12:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbjHWQGT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 12:06:19 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A757E6E
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 09:06:14 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-40a47e8e38dso301651cf.1
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 09:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692806773; x=1693411573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C7pbYc3cWzUuemTPAl/D1nSHc5zEIFeD9puZanDYIGs=;
        b=2TTKoEKSSROueBqUfTiWRuUIf/t+jJXyxLv+JoXQUYIMNvA3U7woiSez1H6yLxFb/u
         Uvmww63a5/ZjqeUquvgFAEMNlKEcNISwGHjWKNeMLWUEXn2dQH7DjhNaEKg1iNNa6zro
         drI9+sV5Yyolacc5wequgp+RkcMYzvGrgglnnF4hX35gpl6rwFDWDdWclZOyYns17ZO+
         qKD1Qbkv4+gL0n4ObjzKb/S3PloaVEMGFu7m6HWQiUtamYwzIXtiW2zpagZqwqPBBcK7
         k25sBpTKMklbEpQAXAwNCcCBf/hmOFLXhlRt8rFqr7RJ+MBN/Hf7Py5FBd6mC/BCnY84
         A+zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692806773; x=1693411573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C7pbYc3cWzUuemTPAl/D1nSHc5zEIFeD9puZanDYIGs=;
        b=fBg+Ez6PTxYjvOlQfgsDhkbor6mQSRKxJrfC8a/l9JeEs2N1ZBFVItwDdIMrw1pNB7
         7mjsyurKD8d1k5ygwNRUU5aou5sIveAiLG8l1BYmxNEoJg4x/P0VEVPnz23AU2j5vIl2
         5j3Tnx/kbImonn1m0YRgybwMNvsQlaIbyntvQCxn5U2lKYByLs0gSuQ379S8DAXYC/jP
         G0rf0uSBS/LZUYG7yS164jlReCGirpOVrCgIyLi7iT7AAURrsKFmG/mpoxtf4/PNB1HQ
         v2H5cJo7hzXJYBv82gULU1ziQd43DSNW5CLODQ29wiPHKJwaR59si8qDXOMSQ4RVOhIe
         Pgbg==
X-Gm-Message-State: AOJu0YwONpd9ds8Chz1odQ6ht0O0Y7etrXjLwrvbd2VvhRpbM1Y+cfmp
        YtPLZzqNHROvzW2ospWMNFo6vs+LT9NANrhBWz974A==
X-Google-Smtp-Source: AGHT+IGV1CYyxAdrvhOhjVX5heWnvD4h1VweRqaPWtGenmweevOV0fIK1K68madw/WFYQPk3NLfqn/Vo6ILUVZh/DSE=
X-Received: by 2002:a05:622a:38f:b0:40f:d1f4:aa58 with SMTP id
 j15-20020a05622a038f00b0040fd1f4aa58mr505066qtx.8.1692806773226; Wed, 23 Aug
 2023 09:06:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-9-rananta@google.com>
 <1c6c07af-f6d0-89a6-1b7d-164ca100ac88@redhat.com>
In-Reply-To: <1c6c07af-f6d0-89a6-1b7d-164ca100ac88@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 23 Aug 2023 09:06:02 -0700
Message-ID: <CAJHc60x=rZTpeJ3PDUWmc08Aziow6S+2nndcL90vHfru5GhXtA@mail.gmail.com>
Subject: Re: [PATCH v5 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
To:     Shaoqin Huang <shahuang@redhat.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
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

On Tue, Aug 22, 2023 at 3:06=E2=80=AFAM Shaoqin Huang <shahuang@redhat.com>=
 wrote:
>
> Hi Raghavendra,
>
> On 8/17/23 08:30, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > KVM does not yet support userspace modifying PMCR_EL0.N (With
> > the previous patch, KVM ignores what is written by upserspace).
> > Add support userspace limiting PMCR_EL0.N.
> >
> > Disallow userspace to set PMCR_EL0.N to a value that is greater
> > than the host value (KVM_SET_ONE_REG will fail), as KVM doesn't
> > support more event counters than the host HW implements.
> > Although this is an ABI change, this change only affects
> > userspace setting PMCR_EL0.N to a larger value than the host.
> > As accesses to unadvertised event counters indices is CONSTRAINED
> > UNPREDICTABLE behavior, and PMCR_EL0.N was reset to the host value
> > on every vCPU reset before this series, I can't think of any
> > use case where a user space would do that.
> >
> > Also, ignore writes to read-only bits that are cleared on vCPU reset,
> > and RES{0,1} bits (including writable bits that KVM doesn't support
> > yet), as those bits shouldn't be modified (at least with
> > the current KVM).
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >   arch/arm64/include/asm/kvm_host.h |  3 ++
> >   arch/arm64/kvm/pmu-emul.c         |  1 +
> >   arch/arm64/kvm/sys_regs.c         | 49 +++++++++++++++++++++++++++++-=
-
> >   3 files changed, 51 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index 0f2dbbe8f6a7e..c15ec365283d1 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -259,6 +259,9 @@ struct kvm_arch {
> >       /* PMCR_EL0.N value for the guest */
> >       u8 pmcr_n;
> >
> > +     /* Limit value of PMCR_EL0.N for the guest */
> > +     u8 pmcr_n_limit;
> > +
> >       /* Hypercall features firmware registers' descriptor */
> >       struct kvm_smccc_features smccc_feat;
> >       struct maple_tree smccc_filter;
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index ce7de6bbdc967..39ad56a71ad20 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -896,6 +896,7 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_=
pmu *arm_pmu)
> >        * while the latter does not.
> >        */
> >       kvm->arch.pmcr_n =3D arm_pmu->num_events - 1;
> > +     kvm->arch.pmcr_n_limit =3D arm_pmu->num_events - 1;
> >
> >       return 0;
> >   }
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 2075901356c5b..c01d62afa7db4 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1086,6 +1086,51 @@ static int get_pmcr(struct kvm_vcpu *vcpu, const=
 struct sys_reg_desc *r,
> >       return 0;
> >   }
> >
> > +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
r,
> > +                 u64 val)
> > +{
> > +     struct kvm *kvm =3D vcpu->kvm;
> > +     u64 new_n, mutable_mask;
> > +     int ret =3D 0;
> > +
> > +     new_n =3D FIELD_GET(ARMV8_PMU_PMCR_N, val);
> > +
> > +     mutex_lock(&kvm->arch.config_lock);
> > +     if (unlikely(new_n !=3D kvm->arch.pmcr_n)) {
> > +             /*
> > +              * The vCPU can't have more counters than the PMU
> > +              * hardware implements.
> > +              */
> > +             if (new_n <=3D kvm->arch.pmcr_n_limit)
> > +                     kvm->arch.pmcr_n =3D new_n;
> > +             else
> > +                     ret =3D -EINVAL;
> > +     }
> > +     mutex_unlock(&kvm->arch.config_lock);
>
> Another thing I am just wonder is that should we block any modification
> to the pmcr_n after vm start to run? Like add one more checking
> kvm_vm_has_ran_once() at the beginning of the set_pmcr() function.
>
Thanks for bringing it up. Reiji and I discussed about this. Checking
for kvm_vm_has_ran_once() will be a good move, however, it will go
against the ABI expectations of setting the PMCR. I'd like others to
weigh in on this as well. What do you think?

Thank you.
Raghavendra
> Thanks,
> Shaoqin
>
> > +     if (ret)
> > +             return ret;
> > +
> > +     /*
> > +      * Ignore writes to RES0 bits, read only bits that are cleared on
> > +      * vCPU reset, and writable bits that KVM doesn't support yet.
> > +      * (i.e. only PMCR.N and bits [7:0] are mutable from userspace)
> > +      * The LP bit is RES0 when FEAT_PMUv3p5 is not supported on the v=
CPU.
> > +      * But, we leave the bit as it is here, as the vCPU's PMUver migh=
t
> > +      * be changed later (NOTE: the bit will be cleared on first vCPU =
run
> > +      * if necessary).
> > +      */
> > +     mutable_mask =3D (ARMV8_PMU_PMCR_MASK | ARMV8_PMU_PMCR_N);
> > +     val &=3D mutable_mask;
> > +     val |=3D (__vcpu_sys_reg(vcpu, r->reg) & ~mutable_mask);
> > +
> > +     /* The LC bit is RES1 when AArch32 is not supported */
> > +     if (!kvm_supports_32bit_el0())
> > +             val |=3D ARMV8_PMU_PMCR_LC;
> > +
> > +     __vcpu_sys_reg(vcpu, r->reg) =3D val;
> > +     return 0;
> > +}
> > +
> >   /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in o=
ne go */
> >   #define DBG_BCR_BVR_WCR_WVR_EL1(n)                                  \
> >       { SYS_DESC(SYS_DBGBVRn_EL1(n)),                                 \
> > @@ -2147,8 +2192,8 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >       { SYS_DESC(SYS_CTR_EL0), access_ctr },
> >       { SYS_DESC(SYS_SVCR), undef_access },
> >
> > -     { PMU_SYS_REG(PMCR_EL0), .access =3D access_pmcr,
> > -       .reset =3D reset_pmcr, .reg =3D PMCR_EL0, .get_user =3D get_pmc=
r },
> > +     { PMU_SYS_REG(PMCR_EL0), .access =3D access_pmcr, .reset =3D rese=
t_pmcr,
> > +       .reg =3D PMCR_EL0, .get_user =3D get_pmcr, .set_user =3D set_pm=
cr },
> >       { PMU_SYS_REG(PMCNTENSET_EL0),
> >         .access =3D access_pmcnten, .reg =3D PMCNTENSET_EL0 },
> >       { PMU_SYS_REG(PMCNTENCLR_EL0),
>
> --
> Shaoqin
>
