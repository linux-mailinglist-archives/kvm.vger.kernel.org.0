Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC527CB544
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 23:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbjJPV3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 17:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbjJPV3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 17:29:13 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECA2A2
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 14:29:11 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1c9d4f08d7cso26025ad.0
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 14:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697491751; x=1698096551; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AFn29vyvgA1T7ugFUC1SqB09r0OPYYGNgXPaVYLCKMU=;
        b=weCY7jOfctptabA4Zj/I6ZRqxzn+1bu6HFG3JBoWKb1bkIvIKEqxaYJmBL48g8oIc8
         5JvhxDdQoLuNz/gOUYV65oZlXa0lUn6821vA7yXTv9MIm7OFEIJyp7bvAyN83pp7buzf
         MYFr2TdlIul24wDWqDCmaQTV8sqVw4N2Nm2gPNlFFt7FMOvaB46vJGFQvySQT9LvXNKc
         s6mJr27uOQy0WzIw80unXkeFQzoU7T467Qa9CtPUaZoSlyMh5viqnH0gAVyRX4rgizKU
         WO3V45LWrsTqzGuS7EVRp/OYwSuQYDl00tmT1f30CJXzrY7IkXy4/WJlT7dN0fKr6D3z
         +XvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697491751; x=1698096551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AFn29vyvgA1T7ugFUC1SqB09r0OPYYGNgXPaVYLCKMU=;
        b=ORb3QlXBA4y8rDMRwnVyTcIC/HV7ud9nkB12OypAryTfeDEjlvgygy4GOH69dM65cE
         Ch8caCVtVDfS8oun6fINIMWb6cto6fQg8YJZi81VxJIOIS+aA99usjlqOI0/q0bG2JZb
         z7GHvQojRz/kyCl3tnHRppRQWd+kmD3R7jyOthanUjZ08Hf9o6Mjf19WdEeLrMFZkRtE
         xsiA/1v6rv9GVnltpp2aCC0zWqbk3xXZc5F8cMYPsQ16hyYUPJlFzRGCxpmVDoAEihfQ
         LaJy5tGJML/czqLgofRt60+Vlft+LYFTgH2QoszWauyRPOMMKPPAIJKxsaZkXXmiEwJV
         SjxA==
X-Gm-Message-State: AOJu0Yxry9dzYMetQ2Hj4fTByMiFDJIdV4AP6QdulcTCjLPwMGzKbZP6
        MFqipac5y7DM6lf80+1wniirFjXwcoXD1JxZikfPvA==
X-Google-Smtp-Source: AGHT+IFsGl+8wNrA/ks0sS6VjqWheVjAe9z1hr9ReqDQIpul5xTW2Yy7iep+rQKRrsQYLhY6pzJauQHVj9HrMBR78ss=
X-Received: by 2002:a17:903:28d:b0:1c5:ca8d:136b with SMTP id
 j13-20020a170903028d00b001c5ca8d136bmr71796plr.14.1697491750564; Mon, 16 Oct
 2023 14:29:10 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-4-rananta@google.com>
 <53546f35-f2cc-4c75-171c-26719550f7df@redhat.com>
In-Reply-To: <53546f35-f2cc-4c75-171c-26719550f7df@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 16 Oct 2023 14:28:58 -0700
Message-ID: <CAJHc60wYyfsJPiFEyLYLyv9femNzDUXy+xFaGx59=2HrUGScyw@mail.gmail.com>
Subject: Re: [PATCH v7 03/12] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
 PMOVS{SET,CLR} on vCPU reset
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

On Mon, Oct 16, 2023 at 12:45=E2=80=AFPM Eric Auger <eauger@redhat.com> wro=
te:
>
> Hi Raghavendra,
>
> On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > On vCPU reset, PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
> > PMOVS{SET,CLR}_EL1 for a vCPU are reset by reset_pmu_reg().
> PMOVS{SET,CLR}_EL0?
Ah, yes. It should be PMOVS{SET,CLR}_EL0.

> > This function clears RAZ bits of those registers corresponding
> > to unimplemented event counters on the vCPU, and sets bits
> > corresponding to implemented event counters to a predefined
> > pseudo UNKNOWN value (some bits are set to 1).
> >
> > The function identifies (un)implemented event counters on the
> > vCPU based on the PMCR_EL0.N value on the host. Using the host
> > value for this would be problematic when KVM supports letting
> > userspace set PMCR_EL0.N to a value different from the host value
> > (some of the RAZ bits of those registers could end up being set to 1).
> >
> > Fix this by clearing the registers so that it can ensure
> > that all the RAZ bits are cleared even when the PMCR_EL0.N value
> > for the vCPU is different from the host value. Use reset_val() to
> > do this instead of fixing reset_pmu_reg(), and remove
> > reset_pmu_reg(), as it is no longer used.
> do you intend to restore the 'unknown' behavior at some point?
>
I believe Reiji's (original author) intention was to keep them
cleared, which would still imply an 'unknown' behavior. Do you think
there's an issue with this?

Thank you.
Raghavendra
> Thanks
>
> Eric
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 21 +--------------------
> >  1 file changed, 1 insertion(+), 20 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 818a52e257ed..3dbb7d276b0e 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -717,25 +717,6 @@ static unsigned int pmu_visibility(const struct kv=
m_vcpu *vcpu,
> >       return REG_HIDDEN;
> >  }
> >
> > -static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_d=
esc *r)
> > -{
> > -     u64 n, mask =3D BIT(ARMV8_PMU_CYCLE_IDX);
> > -
> > -     /* No PMU available, any PMU reg may UNDEF... */
> > -     if (!kvm_arm_support_pmu_v3())
> > -             return 0;
> > -
> > -     n =3D read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> > -     n &=3D ARMV8_PMU_PMCR_N_MASK;
> > -     if (n)
> > -             mask |=3D GENMASK(n - 1, 0);
> > -
> > -     reset_unknown(vcpu, r);
> > -     __vcpu_sys_reg(vcpu, r->reg) &=3D mask;
> > -
> > -     return __vcpu_sys_reg(vcpu, r->reg);
> > -}
> > -
> >  static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_=
desc *r)
> >  {
> >       reset_unknown(vcpu, r);
> > @@ -1115,7 +1096,7 @@ static bool access_pmuserenr(struct kvm_vcpu *vcp=
u, struct sys_reg_params *p,
> >         trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
> >
> >  #define PMU_SYS_REG(name)                                            \
> > -     SYS_DESC(SYS_##name), .reset =3D reset_pmu_reg,                  =
 \
> > +     SYS_DESC(SYS_##name), .reset =3D reset_val,                      =
 \
> >       .visibility =3D pmu_visibility
> >
> >  /* Macro to expand the PMEVCNTRn_EL0 register */
>
