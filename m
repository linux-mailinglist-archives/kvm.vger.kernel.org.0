Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93E5465D6F
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 05:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355469AbhLBEfv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 23:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355426AbhLBEfu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 23:35:50 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62821C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 20:32:28 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so2335160pjj.0
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 20:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8rvJ5T05QfgQ/0xbWVKbFRATuno8nIJscBY1KnwGKhk=;
        b=oO+9u3nK2pQFBxkIoro2nojtnTGe7iO4C7T3vBVDwa+J46ODBWJ0fCBZvzOW+0lq1I
         R63+rBaoUPTUopkTjxXyhdTg4YIcSmFJabG5vdITmKJYE+PXNCMFmD4cSdJuR6ceiDvL
         pZBuvxZfvo9yepzyT2HXSYN4oYYxHOcihUNWuyqkbmuVczSFsamroF0FOINFfNyTL7CT
         2NlceFXsJXl+embGE2tXprtrRO0zQBWChw9fAgw4wMXwGgeDD+OgqnUBkETORHs1LF1d
         gS/LHxWH9v91E9DyncpepGvkP84bxSyNv8yKUg2Un4E5rVRb69J9AbAu4vXzUIMyMA8G
         I/oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8rvJ5T05QfgQ/0xbWVKbFRATuno8nIJscBY1KnwGKhk=;
        b=4w6HMRE+M1rx494fwPx0EXCnTeP7olCVY65ct+bgAhJQHCZsZ/bkjhnHCxyif8FuzO
         5Kkr+spKa6rUYg6gIeAI/as3g+tuoMmoN4tYXaQN2zcMyz/JoqZ4LqJqe4V3nE1kO7He
         RDyMQaqSXb48nzkaI/IDluQkDm3rdZsTbZeuGk1eWoUYFC9IsvfG+rp6obl82tdq/bhs
         abv4uIomgp9TGQ9W5Jt8Q0h4bJ344QjJn7c3a66fCSjQakFJvhZqyp0aGhbkcLi6+26M
         fO4Vvcbb8fvBhoYBTRQqmTvU9fAAk9U5q1tSh6GOSpojuv1+LE93GL6Bg82XM6xdFQU9
         Lapg==
X-Gm-Message-State: AOAM532Fkl8Ugzlp0BxSAcawhbtbqhZd+OGNGB1UcC/r7lJsB5dBlbuJ
        0jScNVSfGyvY02CJy2oeLeSwYl0EYaX5gH64HCiSZA==
X-Google-Smtp-Source: ABdhPJwKub6Ck7zsdN7/RUb6dsWfgbAY1fjl7ZmwksvsuL1KdsVm4b+G4sU3OB/MPKhtmVVqjpcYFSMk9E5TgCkyeUI=
X-Received: by 2002:a17:902:aa43:b0:142:6919:73da with SMTP id
 c3-20020a170902aa4300b00142691973damr12697141plr.39.1638419547662; Wed, 01
 Dec 2021 20:32:27 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-4-reijiw@google.com>
 <87k0h1sn0q.wl-maz@kernel.org> <CAAeT=FxwzRF0YZmmoEmq3xRHnhun-BCx_FeEQrOVLgzwseSy4w@mail.gmail.com>
 <YaeXC/3NR2BD7uM0@monolith.localdoman>
In-Reply-To: <YaeXC/3NR2BD7uM0@monolith.localdoman>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 1 Dec 2021 20:32:11 -0800
Message-ID: <CAAeT=FygYm6KpjuQpVxEN1mBcrG=3zc5TpuRjuh9CfR5m_mbow@mail.gmail.com>
Subject: Re: [RFC PATCH v3 03/29] KVM: arm64: Introduce struct id_reg_info
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
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

Hi Alex,

On Wed, Dec 1, 2021 at 7:39 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi Reiji,
>
> On Wed, Nov 24, 2021 at 09:27:32PM -0800, Reiji Watanabe wrote:
> > On Sun, Nov 21, 2021 at 4:37 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Wed, 17 Nov 2021 06:43:33 +0000,
> > > Reiji Watanabe <reijiw@google.com> wrote:
> > > >
> > > > This patch lays the groundwork to make ID registers writable.
> > > >
> > > > Introduce struct id_reg_info for an ID register to manage the
> > > > register specific control of its value for the guest, and provide set
> > > > of functions commonly used for ID registers to make them writable.
> > > >
> > > > The id_reg_info is used to do register specific initialization,
> > > > validation of the ID register and etc.  Not all ID registers must
> > > > have the id_reg_info. ID registers that don't have the id_reg_info
> > > > are handled in a common way that is applied to all ID registers.
> > > >
> > > > At present, changing an ID register from userspace is allowed only
> > > > if the ID register has the id_reg_info, but that will be changed
> > > > by the following patches.
> > > >
> > > > No ID register has the structure yet and the following patches
> > > > will add the id_reg_info for some ID registers.
> > > >
> > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/sysreg.h |   1 +
> > > >  arch/arm64/kvm/sys_regs.c       | 226 ++++++++++++++++++++++++++++++--
> > > >  2 files changed, 218 insertions(+), 9 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > > > index 16b3f1a1d468..597609f26331 100644
> > > > --- a/arch/arm64/include/asm/sysreg.h
> > > > +++ b/arch/arm64/include/asm/sysreg.h
> > > > @@ -1197,6 +1197,7 @@
> > > >  #define ICH_VTR_TDS_MASK     (1 << ICH_VTR_TDS_SHIFT)
> > > >
> > > >  #define ARM64_FEATURE_FIELD_BITS     4
> > > > +#define ARM64_FEATURE_FIELD_MASK     ((1ull << ARM64_FEATURE_FIELD_BITS) - 1)
> > > >
> > > >  /* Create a mask for the feature bits of the specified feature. */
> > > >  #define ARM64_FEATURE_MASK(x)        (GENMASK_ULL(x##_SHIFT + ARM64_FEATURE_FIELD_BITS - 1, x##_SHIFT))
> > > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > > index 5608d3410660..1552cd5581b7 100644
> > > > --- a/arch/arm64/kvm/sys_regs.c
> > > > +++ b/arch/arm64/kvm/sys_regs.c
> > > > @@ -265,6 +265,181 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
> > > >               return read_zero(vcpu, p);
> > > >  }
> > > >
> > > > +/*
> > > > + * A value for FCT_LOWER_SAFE must be zero and changing that will affect
> > > > + * ftr_check_types of id_reg_info.
> > > > + */
> > > > +enum feature_check_type {
> > > > +     FCT_LOWER_SAFE = 0,
> > > > +     FCT_HIGHER_SAFE,
> > > > +     FCT_HIGHER_OR_ZERO_SAFE,
> > > > +     FCT_EXACT,
> > > > +     FCT_EXACT_OR_ZERO_SAFE,
> > > > +     FCT_IGNORE,     /* Don't check (any value is fine) */
> > > > +};
> > > > +
> > > > +static int arm64_check_feature_one(enum feature_check_type type, int val,
> > > > +                                int limit)
> > > > +{
> > > > +     bool is_safe = false;
> > > > +
> > > > +     if (val == limit)
> > > > +             return 0;
> > > > +
> > > > +     switch (type) {
> > > > +     case FCT_LOWER_SAFE:
> > > > +             is_safe = (val <= limit);
> > > > +             break;
> > > > +     case FCT_HIGHER_OR_ZERO_SAFE:
> > > > +             if (val == 0) {
> > > > +                     is_safe = true;
> > > > +                     break;
> > > > +             }
> > > > +             fallthrough;
> > > > +     case FCT_HIGHER_SAFE:
> > > > +             is_safe = (val >= limit);
> > > > +             break;
> > > > +     case FCT_EXACT:
> > > > +             break;
> > > > +     case FCT_EXACT_OR_ZERO_SAFE:
> > > > +             is_safe = (val == 0);
> > > > +             break;
> > > > +     case FCT_IGNORE:
> > > > +             is_safe = true;
> > > > +             break;
> > > > +     default:
> > > > +             WARN_ONCE(1, "Unexpected feature_check_type (%d)\n", type);
> > > > +             break;
> > > > +     }
> > > > +
> > > > +     return is_safe ? 0 : -1;
> > > > +}
> > > > +
> > > > +#define      FCT_TYPE_MASK           0x7
> > > > +#define      FCT_TYPE_SHIFT          1
> > > > +#define      FCT_SIGN_MASK           0x1
> > > > +#define      FCT_SIGN_SHIFT          0
> > > > +#define      FCT_TYPE(val)   ((val >> FCT_TYPE_SHIFT) & FCT_TYPE_MASK)
> > > > +#define      FCT_SIGN(val)   ((val >> FCT_SIGN_SHIFT) & FCT_SIGN_MASK)
> > > > +
> > > > +#define      MAKE_FCT(shift, type, sign)                             \
> > > > +     ((u64)((((type) & FCT_TYPE_MASK) << FCT_TYPE_SHIFT) |   \
> > > > +            (((sign) & FCT_SIGN_MASK) << FCT_SIGN_SHIFT)) << (shift))
> > > > +
> > > > +/* For signed field */
> > > > +#define      S_FCT(shift, type)      MAKE_FCT(shift, type, 1)
> > > > +/* For unigned field */
> > > > +#define      U_FCT(shift, type)      MAKE_FCT(shift, type, 0)
> > > > +
> > > > +/*
> > > > + * @val and @lim are both a value of the ID register. The function checks
> > > > + * if all features indicated in @val can be supported for guests on the host,
> > > > + * which supports features indicated in @lim. @check_types indicates how
> > > > + * features in the ID register needs to be checked.
> > > > + * See comments for id_reg_info's ftr_check_types field for more detail.
> > > > + */
> > > > +static int arm64_check_features(u64 check_types, u64 val, u64 lim)
> > > > +{
> > > > +     int i;
> > > > +
> > > > +     for (i = 0; i < 64; i += ARM64_FEATURE_FIELD_BITS) {
> > > > +             u8 ftr_check = (check_types >> i) & ARM64_FEATURE_FIELD_MASK;
> > > > +             bool is_sign = FCT_SIGN(ftr_check);
> > > > +             enum feature_check_type fctype = FCT_TYPE(ftr_check);
> > > > +             int fval, flim, ret;
> > > > +
> > > > +             fval = cpuid_feature_extract_field(val, i, is_sign);
> > > > +             flim = cpuid_feature_extract_field(lim, i, is_sign);
> > > > +
> > > > +             ret = arm64_check_feature_one(fctype, fval, flim);
> > > > +             if (ret)
> > > > +                     return -E2BIG;
> > > > +     }
> > > > +     return 0;
> > > > +}
> > >
> > > All this logic seems to reinvent what we already have in
> > > arch/arm64/kernel/cpufeature.c. I'd rather we rely on it and maintain
> > > a single idreg handling library.
> > >
> > > Could you outline what is missing in the cpufeature code that requires
> > > you to invent your own? I'm sure Suzuki could help here to make it
> > > directly usable.
> >
> > The issue is that there are some fields whose arm64_ftr_bits don't
> > match what (I think) I need.  However, looking into that option again,
> > it seems that the number of such fields are fewer than I originally
> > thought (I misunderstood some earlier).
> >
> > They are just three fields below.  The common checking process can be
> > skipped for those fields (will restore ignore_mask field in id_reg_info
> > as I had in v1 patch, which is treated like FCT_IGNORE in the v3 patch),
> > and I will have their ID register specific validation function do
> > what I want to check into the fields.
> >
> >  - AA64DFR0.DEBUGVER:
> >    Its .type is FTR_EXACT.
> >    I want to treat its .type as FTR_LOWER_SAFE for the check.
> >
> >  - AA64DFR0.PMUVER:
> >    Its .sign is FTR_SIGNED and .type is FTR_EXACT.
> >    I want to treat its .sign as FTR_UNSIGNED and .type as
> >    FTR_LOWER_SAFE for the check.
> >
> >  - DFR0.PERFMON:
> >    Its .sign is FTR_SIGNED (Its .type is FTR_LOWER_SAFE).
> >    I want to treat its .sign field as FTR_UNSIGNED for the check.
> >
> >    (NOTE: For PMUVER and PERFMON, Arm ARM says "if the field value
> >     is not 0xf the field is treated as an unsigned value")
> >
>
> I don't think it's required that you use the same ID register field
> definitions from cpufeature.c, you can create your own field definitions
> for the KVM registers if they are different. But if you use the same
> structs and field attributes from cpufeature.h, then you can reuse the
> functions from cpufeature.c. I think that's what Marc was suggesting
> (someone please correct me if I'm wrong).
>
> The way Linux handles cpu features is already complicated, I think reusing
> the same mechanism would be preferable from a maintenance and correctness
> perspective. Unless you need something that is missing from cpu features
> for which is unreasonable or impossible to add support.

Thank you for your comments ! I will explore a way that is easy to
maintain for both cpufeature.c and KVM.  Since almost all ID register
fields can be handled in the same way as cpufeature.c, I will probably
use the same ID register fields though.

Thanks,
Reiji
