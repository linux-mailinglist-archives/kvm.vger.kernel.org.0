Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1BF07CB559
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 23:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbjJPVgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 17:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbjJPVgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 17:36:07 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B286A7
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 14:36:05 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id d75a77b69052e-419b53acc11so44651cf.0
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 14:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697492164; x=1698096964; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gG0OkIWDPYdZRvQuvf3btCaImiKQgqO1e18TbAYg8Pg=;
        b=0hHW1d/7AzYtGkXWKlamJWLlz+dMcyRD4KvAOQfrXkAwAu7uewBUozkfLwYDcPSQzq
         ToUFpDvEm2ghWHmqgesqcR4/DO2oIC4fzBM0AVj5ukCdgijehzH4eDbXeMgADxSKUR/r
         0YoG4m5wY0xHsIQQN4jP7RLmn43GxJJLfRi2mQwmX2LyyeNDbOmF1I75D7KpwPCDxDCb
         Ax303E9zMx7ZWfXlUcahck+XF9sv9X/zjzsd2CUsSTo8d2UeFjbOVfiV7+8XQD7m0Q9S
         5bsmdZ2CT3gn4m4ZyenjTTEjaWyhBHWXl1IC25CFJzn83HDbCCrSesuf0AcAW19FwZgG
         qORQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697492164; x=1698096964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gG0OkIWDPYdZRvQuvf3btCaImiKQgqO1e18TbAYg8Pg=;
        b=nh7DQnmGXKn3SeWkOlNrH6iDsydLyexciqTQy0oHVEV2OoPaeroBdcXNt8bPXS9alU
         PoXOR6YUhgigbwG4LCyvUDnddZDgvPB+VEunr+iVF8LEk4etpx2OUx0yZZCAMAcAXkLC
         jHCU7GWWUSn8VIkAgR37oGI8tKw/TiNvE8hIU0xqNVIEH76/s1IkyvxieUx80MflQcWy
         O4sFkEy+krsPO/exlb3F8vMi3p1SosJXTMKHzEOTRvj14A+ECPoWpwswoswW0gkVG10H
         FaY5RQdqo9bRMUfUm7tfZ3IQHfaE5H5QrqarrVCymS1JbtWogUkYN9vMhEHEVZbdsMdK
         uFBA==
X-Gm-Message-State: AOJu0YxckxJKbmOgfxcRMZl9TyTjXVcpNq3cD1k+DOMPRHxJZSsJCCRl
        Ozq5A2+XF/8QBZjDlMszGDli4VUnjQ5VP2impwnwFQ==
X-Google-Smtp-Source: AGHT+IGiZ5BGU5400y71INeUK7EWTSUyP0Peqa8/UWdHZGXz4uUZXSH6XpGpm7cIwuhSjMBV95+dfOrxfv9aNZqsJTg=
X-Received: by 2002:a05:622a:760f:b0:410:9855:acd with SMTP id
 kg15-20020a05622a760f00b0041098550acdmr76659qtb.14.1697492164218; Mon, 16 Oct
 2023 14:36:04 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-8-rananta@google.com>
 <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com> <CAJHc60zpH8Y8h72=jUbshGoqye20FaHRcsb+TFDxkk7rhJAUxQ@mail.gmail.com>
 <ZS2L6uIlUtkltyrF@linux.dev>
In-Reply-To: <ZS2L6uIlUtkltyrF@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 16 Oct 2023 14:35:52 -0700
Message-ID: <CAJHc60wvMSHuLuRsZJOn7+r7LxZ661xEkDfqxGHed5Y+95Fxeg@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based
 on the associated PMU
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Sebastian Ott <sebott@redhat.com>, Marc Zyngier <maz@kernel.org>,
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

On Mon, Oct 16, 2023 at 12:16=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Mon, Oct 16, 2023 at 12:02:27PM -0700, Raghavendra Rao Ananta wrote:
> > On Mon, Oct 16, 2023 at 6:35=E2=80=AFAM Sebastian Ott <sebott@redhat.co=
m> wrote:
> > >
> > > On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
> > > > u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
> > > > {
> > > > -     return __vcpu_sys_reg(vcpu, PMCR_EL0);
> > > > +     u64 pmcr =3D __vcpu_sys_reg(vcpu, PMCR_EL0) &
> > > > +                     ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_S=
HIFT);
> > > > +
> > > > +     return pmcr | ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_=
N_SHIFT);
> > > > }
> > > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > > index ff0f7095eaca..c750722fbe4a 100644
> > > > --- a/arch/arm64/kvm/sys_regs.c
> > > > +++ b/arch/arm64/kvm/sys_regs.c
> > > > @@ -745,12 +745,8 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, c=
onst struct sys_reg_desc *r)
> > > > {
> > > >       u64 pmcr;
> > > >
> > > > -     /* No PMU available, PMCR_EL0 may UNDEF... */
> > > > -     if (!kvm_arm_support_pmu_v3())
> > > > -             return 0;
> > > > -
> > > >       /* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> > > > -     pmcr =3D read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << AR=
MV8_PMU_PMCR_N_SHIFT);
> > > > +     pmcr =3D kvm_vcpu_read_pmcr(vcpu) & (ARMV8_PMU_PMCR_N_MASK <<=
 ARMV8_PMU_PMCR_N_SHIFT);
> > >
> > > pmcr =3D ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
> > > Would that maybe make it more clear what is done here?
> > >
> > Since we require the entire PMCR register, and not just the PMCR.N
> > field, I think using kvm_vcpu_read_pmcr() would be technically
> > correct, don't you think?
>
> No, this isn't using the entire PMCR value, it is just grabbing
> PMCR_EL0.N.
>
Oh sorry, my bad.
> What's the point of doing this in the first place? The implementation of
> kvm_vcpu_read_pmcr() is populating PMCR_EL0.N using the VM-scoped value.
>
I guess originally the change replaced read_sysreg(pmcr_el0) with
kvm_vcpu_read_pmcr(vcpu) to maintain consistency with others.
But if you and Sebastian feel that it's an overkill and directly
getting the value via vcpu->kvm->arch.pmcr_n is more readable, I'm
happy to make the change.

Thank you.
Raghavendra
> --
> Thanks,
> Oliver
