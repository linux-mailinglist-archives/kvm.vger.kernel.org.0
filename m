Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E41E7CB319
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 21:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjJPTCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 15:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbjJPTCp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 15:02:45 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2805EA2
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 12:02:40 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1c9b70b9671so31865ad.1
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 12:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697482959; x=1698087759; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eOzjlLla6gf/R2odr013SLR7czPeJxtYfJ4GpduX1qQ=;
        b=aZlCyDRkQfvcKflCuPbSRvOdYXTqJCiW7XzJv5bkLwiCbMLbEn2H+w+kuEQuAZXAvW
         VFmdc6CMnUYxcIJQVxyJh9hZqqKgUAOC3Je/hJwCxsa2QdM4gxCymyBadG2VuIQgJylt
         Sd4ZRs9pvbKiuAMXd8SzDQvwZgpTNVeKqH8ftsfe8R1hW+ryzQ68UQTl2AKQB9+Wxqth
         bv6QWaaX2ppG1kL9gtN+8O8gmIUch/SNRCrj3FhLJFHIk6bSaorRE6b7xxNXd/pqWiaq
         zfCNO3eC7vjyCtPr3ZuRs+FoeBWta2GkWC3G8rFkGJu2WR8VjptzBFPQynIZhLj3Z3Ad
         JblA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697482959; x=1698087759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eOzjlLla6gf/R2odr013SLR7czPeJxtYfJ4GpduX1qQ=;
        b=HR0vf/tFvIFVnpZWiinxrXEguUGs++F+NQzK7awM0CmBfFamtixeOwnRuWVj3beCuZ
         Ccwf9Y7Jn9q4tn3N4/cAly/h/cwXoh+ZHj/U3+PBxzhCljTFRQ7HEDQ4bdy+zgIFZKgM
         IDrwZYOyVRfe0qpRBMCVrq/2gSWaoPZ5FPaGmmxTmXOMPF4rtwidOs7A4M+rDGMxXKeb
         q/ZoRVT9vGXXOe5NudqXsztFmR0I2SK+xe4+oY+uviJ9GyISOmiPPn07WZOUQMgcGWR7
         8okIlA0BLYVycyvBqKLBOqgb2oNpXchfmsbyVI99uVbM7HPpzUF70/20BVU02tY/a9jY
         mTMA==
X-Gm-Message-State: AOJu0Yx3awYhCkLZuNhkzS1iy2XXmGjN69oTrp4zqXIduYpHDY10KTOx
        VLVWuGPGVtGSydTokpE0Z5XxG5pH8cBQU1oGs57mZA==
X-Google-Smtp-Source: AGHT+IHqX1FgDxN0Mas1wc4pev7LzweHD3IABO+VgwAeIVNA6y5WXfAi4taMg2wCM+3ptaDOC8hcAkvkOunXNYaEWVM=
X-Received: by 2002:a17:903:1c1:b0:1c9:af6a:6d0d with SMTP id
 e1-20020a17090301c100b001c9af6a6d0dmr25087plh.9.1697482959233; Mon, 16 Oct
 2023 12:02:39 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-8-rananta@google.com>
 <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com>
In-Reply-To: <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 16 Oct 2023 12:02:27 -0700
Message-ID: <CAJHc60zpH8Y8h72=jUbshGoqye20FaHRcsb+TFDxkk7rhJAUxQ@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based
 on the associated PMU
To:     Sebastian Ott <sebott@redhat.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023 at 6:35=E2=80=AFAM Sebastian Ott <sebott@redhat.com> w=
rote:
>
> On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
> > u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
> > {
> > -     return __vcpu_sys_reg(vcpu, PMCR_EL0);
> > +     u64 pmcr =3D __vcpu_sys_reg(vcpu, PMCR_EL0) &
> > +                     ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT=
);
> > +
> > +     return pmcr | ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SH=
IFT);
> > }
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index ff0f7095eaca..c750722fbe4a 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -745,12 +745,8 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const=
 struct sys_reg_desc *r)
> > {
> >       u64 pmcr;
> >
> > -     /* No PMU available, PMCR_EL0 may UNDEF... */
> > -     if (!kvm_arm_support_pmu_v3())
> > -             return 0;
> > -
> >       /* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> > -     pmcr =3D read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_=
PMU_PMCR_N_SHIFT);
> > +     pmcr =3D kvm_vcpu_read_pmcr(vcpu) & (ARMV8_PMU_PMCR_N_MASK << ARM=
V8_PMU_PMCR_N_SHIFT);
>
> pmcr =3D ((u64)vcpu->kvm->arch.pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
> Would that maybe make it more clear what is done here?
>
Since we require the entire PMCR register, and not just the PMCR.N
field, I think using kvm_vcpu_read_pmcr() would be technically
correct, don't you think?

Thank you.
Raghavendra
