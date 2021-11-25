Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DBF45D454
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 06:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237478AbhKYFdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 00:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244755AbhKYFbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 00:31:00 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3EBC06175B
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 21:27:49 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id s137so4191081pgs.5
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 21:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gClVFnt93BJcJvJ1F1i/qjirYE9d2TljWTrn5X37rk0=;
        b=Fg0FUDy33jPMuHDFySVwszw2uPxezOxi79hsMxf1iHNPvUkW8jW98XRkDkAbelYrCI
         jbOWh2Uqjum1cIsqsbV/Pajq2oXvhLDqqunBlLDV2e9uRz21AF5Yo98aCHyBuURlKMIR
         Soz17q3ZhC5wk9ib7QElv6JRcRgrAwKkvSeD8FeFt0860SUC7F7VnplY+Q/d8nkRfle5
         b6iSxBO67sTrVUapNYbd6wG2hcd58VvHNHifGExXOq041BrR1jCRD+03k4cLgzzgyWJY
         0LtAjdezMloLhi4XpdfDqpSnM1mmWZJDDaPqez0Llaw+aWft1Z3OHXJmDyu8F0srUSZZ
         kXFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gClVFnt93BJcJvJ1F1i/qjirYE9d2TljWTrn5X37rk0=;
        b=EIBR3a6bxNiSCf8Cuut1Ta8/js+3AWDSEIfNvdFxbU6nexRlC0l7GVSOU0teyzMFOe
         u2sVicE5qFwK2+I9q7bNyyM+u193PUsZ0y8f7xOgUDB4749cOaNa81eKrrgj1c8XW+yC
         GDwwfLvyN4+faXH1VWlIPW+4zebr2F43OFgB3t+1wI4Qf0Jju/rK2V58u9m6Uw9+SP67
         B60eIUubZiZWREeM1lJ559srY+EmAcgHwbjUZiaYrhxwedl4X81y97nr5CaRUuUgwqsz
         FzOV4xwk6T2LYLRwGHhNUwpCYPPDEhNd52+YCfIB9bnz+TuQH6MSlJj4O6l+L3xg7viF
         ogUA==
X-Gm-Message-State: AOAM530lEEe6m4EHEj1uijUChS6qLa2AtbhTTVDdTRo1s++13vmn15qy
        MAp3hIeg0tcmzP2f1udmMzHFDIEnnpSEAuj1aREH9Q==
X-Google-Smtp-Source: ABdhPJwzbJzsDAy1mY0ilVm0ZDrIO+pBpVUuL1aVdmnn3Tahk97WQeVSKMAWM2Jt5INeqhFtguMKer9ZGVlQNJoteiU=
X-Received: by 2002:a63:8541:: with SMTP id u62mr5530006pgd.433.1637818068649;
 Wed, 24 Nov 2021 21:27:48 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-4-reijiw@google.com>
 <87k0h1sn0q.wl-maz@kernel.org>
In-Reply-To: <87k0h1sn0q.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 24 Nov 2021 21:27:32 -0800
Message-ID: <CAAeT=FxwzRF0YZmmoEmq3xRHnhun-BCx_FeEQrOVLgzwseSy4w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 03/29] KVM: arm64: Introduce struct id_reg_info
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 21, 2021 at 4:37 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 17 Nov 2021 06:43:33 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > This patch lays the groundwork to make ID registers writable.
> >
> > Introduce struct id_reg_info for an ID register to manage the
> > register specific control of its value for the guest, and provide set
> > of functions commonly used for ID registers to make them writable.
> >
> > The id_reg_info is used to do register specific initialization,
> > validation of the ID register and etc.  Not all ID registers must
> > have the id_reg_info. ID registers that don't have the id_reg_info
> > are handled in a common way that is applied to all ID registers.
> >
> > At present, changing an ID register from userspace is allowed only
> > if the ID register has the id_reg_info, but that will be changed
> > by the following patches.
> >
> > No ID register has the structure yet and the following patches
> > will add the id_reg_info for some ID registers.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/sysreg.h |   1 +
> >  arch/arm64/kvm/sys_regs.c       | 226 ++++++++++++++++++++++++++++++--
> >  2 files changed, 218 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index 16b3f1a1d468..597609f26331 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -1197,6 +1197,7 @@
> >  #define ICH_VTR_TDS_MASK     (1 << ICH_VTR_TDS_SHIFT)
> >
> >  #define ARM64_FEATURE_FIELD_BITS     4
> > +#define ARM64_FEATURE_FIELD_MASK     ((1ull << ARM64_FEATURE_FIELD_BITS) - 1)
> >
> >  /* Create a mask for the feature bits of the specified feature. */
> >  #define ARM64_FEATURE_MASK(x)        (GENMASK_ULL(x##_SHIFT + ARM64_FEATURE_FIELD_BITS - 1, x##_SHIFT))
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 5608d3410660..1552cd5581b7 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -265,6 +265,181 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
> >               return read_zero(vcpu, p);
> >  }
> >
> > +/*
> > + * A value for FCT_LOWER_SAFE must be zero and changing that will affect
> > + * ftr_check_types of id_reg_info.
> > + */
> > +enum feature_check_type {
> > +     FCT_LOWER_SAFE = 0,
> > +     FCT_HIGHER_SAFE,
> > +     FCT_HIGHER_OR_ZERO_SAFE,
> > +     FCT_EXACT,
> > +     FCT_EXACT_OR_ZERO_SAFE,
> > +     FCT_IGNORE,     /* Don't check (any value is fine) */
> > +};
> > +
> > +static int arm64_check_feature_one(enum feature_check_type type, int val,
> > +                                int limit)
> > +{
> > +     bool is_safe = false;
> > +
> > +     if (val == limit)
> > +             return 0;
> > +
> > +     switch (type) {
> > +     case FCT_LOWER_SAFE:
> > +             is_safe = (val <= limit);
> > +             break;
> > +     case FCT_HIGHER_OR_ZERO_SAFE:
> > +             if (val == 0) {
> > +                     is_safe = true;
> > +                     break;
> > +             }
> > +             fallthrough;
> > +     case FCT_HIGHER_SAFE:
> > +             is_safe = (val >= limit);
> > +             break;
> > +     case FCT_EXACT:
> > +             break;
> > +     case FCT_EXACT_OR_ZERO_SAFE:
> > +             is_safe = (val == 0);
> > +             break;
> > +     case FCT_IGNORE:
> > +             is_safe = true;
> > +             break;
> > +     default:
> > +             WARN_ONCE(1, "Unexpected feature_check_type (%d)\n", type);
> > +             break;
> > +     }
> > +
> > +     return is_safe ? 0 : -1;
> > +}
> > +
> > +#define      FCT_TYPE_MASK           0x7
> > +#define      FCT_TYPE_SHIFT          1
> > +#define      FCT_SIGN_MASK           0x1
> > +#define      FCT_SIGN_SHIFT          0
> > +#define      FCT_TYPE(val)   ((val >> FCT_TYPE_SHIFT) & FCT_TYPE_MASK)
> > +#define      FCT_SIGN(val)   ((val >> FCT_SIGN_SHIFT) & FCT_SIGN_MASK)
> > +
> > +#define      MAKE_FCT(shift, type, sign)                             \
> > +     ((u64)((((type) & FCT_TYPE_MASK) << FCT_TYPE_SHIFT) |   \
> > +            (((sign) & FCT_SIGN_MASK) << FCT_SIGN_SHIFT)) << (shift))
> > +
> > +/* For signed field */
> > +#define      S_FCT(shift, type)      MAKE_FCT(shift, type, 1)
> > +/* For unigned field */
> > +#define      U_FCT(shift, type)      MAKE_FCT(shift, type, 0)
> > +
> > +/*
> > + * @val and @lim are both a value of the ID register. The function checks
> > + * if all features indicated in @val can be supported for guests on the host,
> > + * which supports features indicated in @lim. @check_types indicates how
> > + * features in the ID register needs to be checked.
> > + * See comments for id_reg_info's ftr_check_types field for more detail.
> > + */
> > +static int arm64_check_features(u64 check_types, u64 val, u64 lim)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < 64; i += ARM64_FEATURE_FIELD_BITS) {
> > +             u8 ftr_check = (check_types >> i) & ARM64_FEATURE_FIELD_MASK;
> > +             bool is_sign = FCT_SIGN(ftr_check);
> > +             enum feature_check_type fctype = FCT_TYPE(ftr_check);
> > +             int fval, flim, ret;
> > +
> > +             fval = cpuid_feature_extract_field(val, i, is_sign);
> > +             flim = cpuid_feature_extract_field(lim, i, is_sign);
> > +
> > +             ret = arm64_check_feature_one(fctype, fval, flim);
> > +             if (ret)
> > +                     return -E2BIG;
> > +     }
> > +     return 0;
> > +}
>
> All this logic seems to reinvent what we already have in
> arch/arm64/kernel/cpufeature.c. I'd rather we rely on it and maintain
> a single idreg handling library.
>
> Could you outline what is missing in the cpufeature code that requires
> you to invent your own? I'm sure Suzuki could help here to make it
> directly usable.

The issue is that there are some fields whose arm64_ftr_bits don't
match what (I think) I need.  However, looking into that option again,
it seems that the number of such fields are fewer than I originally
thought (I misunderstood some earlier).

They are just three fields below.  The common checking process can be
skipped for those fields (will restore ignore_mask field in id_reg_info
as I had in v1 patch, which is treated like FCT_IGNORE in the v3 patch),
and I will have their ID register specific validation function do
what I want to check into the fields.

 - AA64DFR0.DEBUGVER:
   Its .type is FTR_EXACT.
   I want to treat its .type as FTR_LOWER_SAFE for the check.

 - AA64DFR0.PMUVER:
   Its .sign is FTR_SIGNED and .type is FTR_EXACT.
   I want to treat its .sign as FTR_UNSIGNED and .type as
   FTR_LOWER_SAFE for the check.

 - DFR0.PERFMON:
   Its .sign is FTR_SIGNED (Its .type is FTR_LOWER_SAFE).
   I want to treat its .sign field as FTR_UNSIGNED for the check.

   (NOTE: For PMUVER and PERFMON, Arm ARM says "if the field value
    is not 0xf the field is treated as an unsigned value")

Thanks,
Reiji
