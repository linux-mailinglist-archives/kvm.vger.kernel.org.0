Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F24D465D3D
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 05:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345143AbhLBEMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 23:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344656AbhLBEMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 23:12:49 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52553C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 20:09:27 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso1456193pji.0
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 20:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2N85QHtDMNcBqsgUwNly3z4kS+qEOu6OLU80+PIlv/c=;
        b=Phoo5/g80FaemunXqyG1I+YbjABSqeRplXEqYyMMT7Cvi373UIlpQe61OVvHGotCg+
         16pkBNhUK2s3U08jCwz0+3oNImVKoUFceWbyc6XHIMZ9V7GbGhrHWfgqnDQI3IjvqDPT
         MiiZy7u0ihoL1mw9Q3ajy0QEPGuktRjlbefm9IRX7WEPO7BnxLo4vwgBMyyZp0xBDA8V
         h0f1xpM/8yZ8mtzNmh3kEv9zAmDL4QVH+Gag1BwOEuAWeQmppgHKgtb5CYAp/vBK8duO
         sQR309sohYF2q2FWl14qvATrQuRZ+aOQjzgIQxebFthDCoRTd8pn70E5gch8lx3xLwDG
         Tg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2N85QHtDMNcBqsgUwNly3z4kS+qEOu6OLU80+PIlv/c=;
        b=5vwrLyovjGoD9tPF6lVxLysv5CMyt56GGwPl5aDjFB39uoYTPbJFC5YTu0UUZiB6HH
         7mdFkFHZIM6gB6pRDeaijC7LhvUICflUQCImu2IP6/oYsXGyz0iEQIdmbTSOSAzKMZCI
         EGwLn9PgrlV8g0qV7VQAiK8k1T0LMVy203+ZUK7Ur5pVDHDTWYedDqkEoX/jpzZ/BJjE
         o0Z33JKCHbQe+qkxzE+9kYMfeskJp2KH3uJw7iYur+1pafEcb9m/uVbmnq47ZJz9rkEs
         jtt5pVF+6kwHdaRTYl72TiArKixTDvLAG5SxnBEs7ruxXLNS6T4tgx2AJDSUh8n+d64O
         8rFg==
X-Gm-Message-State: AOAM5337VzbyR47cv6Df+Ejr0sEBGFrMd1weT8MrdUhj/VFxjwHMDrB/
        oZbbW5aQuOu4KlRQNE/1+yYFKivyHfT1t6FJoTK34w==
X-Google-Smtp-Source: ABdhPJxsDlo8TGgs6j5Z1iLI19iMEZz85qkEhEpAtj8o6pHeb9vqLMAXvoMausmI1cxcdMPdMSLuTqlM1DnoGFHZcBA=
X-Received: by 2002:a17:90a:e506:: with SMTP id t6mr3046830pjy.9.1638418166415;
 Wed, 01 Dec 2021 20:09:26 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-4-reijiw@google.com>
 <YaeTs4rUZ9uNNQU7@monolith.localdoman>
In-Reply-To: <YaeTs4rUZ9uNNQU7@monolith.localdoman>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 1 Dec 2021 20:09:10 -0800
Message-ID: <CAAeT=FwktER+aKh4tCEHWQTOSeUkHJzmtPgYjhE=Vv5YMid8WQ@mail.gmail.com>
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

On Wed, Dec 1, 2021 at 7:24 AM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi Reiji,
>
> On Tue, Nov 16, 2021 at 10:43:33PM -0800, Reiji Watanabe wrote:
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
>
> What happens if the a new feature is added and the field has a particular
> meaning? How are you going to deal with old userspace implementations that
> use a value here which now is not allowed or it affects the guest?

With this v3 series, unless KVM is changed for the new field,
a new feature will be treated as lower safe (that's the default).
If the field won't fit any of those cases, FCT_IGNORE needs to be
used for the field, and the ID register specific validation function,
which will be registered in id_reg_info, needs to validate the field.

Old userspace implementation shouldn't be affected because the default
values (the values right after the first KVM_ARM_VCPU_INIT) for
ID registers won't be changed by this series (patch-9 changes
AA64DFR0.PMUVER/DFR0.PERFMON but it is due to a bug fix), and the
default value, which is basically same as @limit (or indicates
less or smaller level of features than @limit for features that
can be configured by KVM_ARM_VCPU_INIT, etc), is always allowed
by arm64_check_feature_one().

Having said that, arm64_check_feature_one() will be gone from the next
version, and the similar checking will be done by a new function in
arch/arm64/kernel/cpufeature.c that will use arm64_ftr_bits instead.

  https://lore.kernel.org/all/CAAeT=FxwzRF0YZmmoEmq3xRHnhun-BCx_FeEQrOVLgzwseSy4w@mail.gmail.com/

Unless KVM is changed for the new field, it will be validated based
on arm64_ftr_bits for the field.  If KVM needs to handle the field
differently, then we will have the new function ignore the field,
and will have the ID register specific validation function handle
the field.

Thanks,
Reiji
