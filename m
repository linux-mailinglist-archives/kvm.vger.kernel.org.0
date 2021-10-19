Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790F2432F5D
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 09:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbhJSH2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 03:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhJSH2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 03:28:49 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B042C06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 00:26:37 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id f11so12969551pfc.12
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 00:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TZsnArjQXGb3FVehn4IXX1giy8TDt6f3zBASxkjGLiw=;
        b=qWlenUnqNZ7nZNROncqJYk99I1T7GOarPCSu7J40Hck5yCd96rDh8QcgS3DkBXv3wM
         S7RlfyLYU1oYadQ3CHXhZ3GsigyjFen45T9OO1rkdXCz7XHAL+3OYSC/aOgMsFhu7mPV
         wNx5/LyANPTrOjST4G0SG4v00JbPY5SxnHRGiPIFeZbSMRhXaWTBnAWyYTOJvLtJdEST
         hbPCznfNwedtvMO+5+tyg4Zrw8lDX9gQYSxg3JATetggiYvTdGnReyUtnjqVrgTWw1LP
         /EGDVjcCN+w2yKsu65bgNWjwsTMtnw8febS124p/0yFOtCIGHQ7Z1fbbrMjoha3KZSnf
         l74g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TZsnArjQXGb3FVehn4IXX1giy8TDt6f3zBASxkjGLiw=;
        b=WSvs4Gv+B9Djbq0yYkl4bF4WmRCSQfhErayZ9gyCK6sKoRzQwfZ8aI5xgkUYEdjowj
         Bz963NzaAtuNICcRNhI8DdPcqBkFbPkbL2AiEKCDqZkXG5bYUm+kqyzM7Wyvag0DVTK+
         Vv7PgmkYQQm5jt9I6klPKE+0HC3S1uNHjmDuqYiXLoZvBT9p8SGV6xH7ZFF6gs0wGGQ0
         SiRfis+krfulISOEQ0tJBBIW/+NL00Iomr9N4IxF27AEzSB5wj9wz9eydDVM4eLZRhEB
         pFDYXu7BZB+tYeNbZbuWdncr9Qqel8BgijdORSu7nUmyCVR+7W3JgFp+hx4dyI352a5r
         /crg==
X-Gm-Message-State: AOAM53224UZb5AMATau7i02vyGdIK1FpdxPerRZWgXXP4NaLCcshK0gf
        HdgRwCnTG06uEonjfUF26k2e78hM+y2TK1km0af+5A==
X-Google-Smtp-Source: ABdhPJzrW+teVrbB2KqawlIVqrHx016W81nKcc3Y52aKnMYsMBBUBMJkczXFMTS1WJZ+6FozzD2SNsvZfXSeDQsJAlg=
X-Received: by 2002:aa7:8246:0:b0:44b:4870:1b09 with SMTP id
 e6-20020aa78246000000b0044b48701b09mr34520177pfn.82.1634628396376; Tue, 19
 Oct 2021 00:26:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com> <20211012043535.500493-4-reijiw@google.com>
 <20211015133038.xfyez4rvxbs5ihmg@gator> <CAAeT=Fy-enk=X_PaRSDEKQ01yQzdyU=bcpq8cuCZhtpzC=JvnQ@mail.gmail.com>
 <20211018144215.fvz7lrqiqlwhadms@gator.home> <CAAeT=FyvRg7cD9-N81BM4gz0FaZHcaoWWQptniB5zDKdL=OkXg@mail.gmail.com>
 <20211019062516.smjbbil5ugbipwno@gator.home>
In-Reply-To: <20211019062516.smjbbil5ugbipwno@gator.home>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 19 Oct 2021 00:26:20 -0700
Message-ID: <CAAeT=Fx4geQrp_X75uKm8e85bRUWtxRbubYQ3vUXaVgC85srtQ@mail.gmail.com>
Subject: Re: [RFC PATCH 03/25] KVM: arm64: Introduce a validation function for
 an ID register
To:     Andrew Jones <drjones@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
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

I've just noticed that I mistakenly dropped all the CC-list
when I replied to Andrew's first email.
So, I've added all of them back.  I'm sorry for the mistake.

The following email still includes all the discussion with Andrew
except for the first comment about using @<param> for the source
code comments of arm64_check_features(), which I will fix in v2.

On Mon, Oct 18, 2021 at 11:25 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Oct 18, 2021 at 03:59:35PM -0700, Reiji Watanabe wrote:
> > > > > > +int arm64_check_features(u32 sys_reg, u64 val, u64 limit)
> > > > > > +{
> > > > > > +     struct arm64_ftr_reg *reg = get_arm64_ftr_reg(sys_reg);
> > > > > > +     const struct arm64_ftr_bits *ftrp;
> > > > > > +     u64 exposed_mask = 0;
> > > > > > +
> > > > > > +     if (!reg)
> > > > > > +             return -ENOENT;
> > > > > > +
> > > > > > +     for (ftrp = reg->ftr_bits; ftrp->width; ftrp++) {
> > > > > > +             if (arm64_ftr_value(ftrp, val) > arm64_ftr_value(ftrp, limit))
> > > > >
> > > > > Hmm. Are we sure that '>' is the correct operator for all comparisons? It
> > > > > seems like we need a arm64_ftr_compare() function that takes
> > > > > arm64_ftr_bits.type and .sign into account.
> > > >
> > > > Thank you for bringing up this point.
> > > >
> > > > I agree that '>' is not always the appropriate operator (mostly
> > > > inappropriate) for cases where .type is not FTR_LOWER_SAFE.
> > > > (The code takes .sign into account though)
> > > >
> > > > Looking at each field with .type != FTR_LOWER_SAFE, I don't think
> > > > we can simply determine how to check the field based on .type
> > > > because the appropriate way highly depends on the field.
> > > >
> > > >  - For ID_AA64DFR0_EL1.PMUVER/DEBUGVER (FTR_EXACT),
> > > >    we can simply use '>'.
> > > >  - For ID_AA64ISAR1_EL1.APA/API (FTR_EXACT),
> > > >    it looks like those fields must match between val and limit or
> > > >    the ones in val can be zero.
> > > >  - For ID_AA64MMFR0.TGRAN4_2/TGRAN64_2/TGRAN16_2 (FTR_EXACT),
> > > >    when the field indicates 0x2 (4KB/64KB/16KB granule support at
> > > >    stage 2) in the limit, 0x1 (4KB/64KB/16KB granule not supported
> > > >    at stage 2) in val can be allowed, but 0x0 (identified in the
> > > >    ID_AA64MMFR0_EL1.TGRAN4/TGRAN64/TGRAN16) cannot simply be allowed.
> > > >  - For ID_AA64MMFR1_EL1.SPECSEI (FTR_HIGHER_SAFE),
> > > >    it looks like '<' is a safer option (I'm not so sure how it is
> > > >    actually used though).
> > > >
> > > > Currently, I am looking at including those fields in ignore_mask of
> > > > their id_reg_info (for the function ignore the fields) and updating
> > > > its validate function for them (except for ID_AA64DFR0_EL1.PMUVER
> > > > and DEBUGVER, which we can use the function for).
> > >
> > > Yes, in the least I think we need to document the limitations of this
> > > arm64_check_features() function in a comment. I still wonder if we
> > > shouldn't implement a arm64_ftr_compare() which makes appropriate
> > > comparisons, even if it has to key off the register fields to determine
> > > what that comparison should be. Either that, or maybe we shouldn't try
> > > to introduce a common arm64_check_features() at all and we should just
> > > handle each register needed by KVM in its specific way.
> >
> > I understand your point and I completely agree with your comment above.
> > Yes, the function's comparison should be done based on arm64_ftr_bits
> > as long as it is in the file using arm64_ftr_bits.
> > I will fix this in v2.
> >
> >
> > > > > > +                     return -E2BIG;
> > > > > > +
> > > > > > +             exposed_mask |= arm64_ftr_mask(ftrp);
> > > > > > +     }
> > > > > > +
> > > > > > +     if (val & ~exposed_mask)
> > > > > > +             return -E2BIG;
> > > > >
> > > > > I'm not sure we want this. I think it implies that any RAO bits need to be
> > > > > cleared before calling this function, which could be inconvenient.
> > > >
> > > > # Does 'RA0' mean RAZ (read as zero) ?
> > >
> > > RAO (O, not 0) means read-as-one.
> >
> > Uh, that was O, I see...
> > That's why I wasn't able to find the word in ARM Glossary.  Thank you !
> >
> >
> > > > The code is used to check if any feature fields that the host
> > > > kernel doesn't recognize (arm64_ftr_bits is not defined for
> > > > the field) yet are not exposed to the guest.  So, removing the
> > > > checking would be inconvenient for the use case (in the current
> > > > version of the series at least).
> > > >
> > > > On the other hand, I agree it might be inconvenient for some
> > > > potential use cases.  One of the solutions that I could think of
> > > > now would be making the checking conditional by adding another
> > > > parameter (so its caller can choose the behavior).
> > > > I will be happy to make the change when we need it.
> > >
> > > I agree with wanting to avoid bits that shouldn't be set from being set,
> > > but the read-as-one bits will be set, but they won't show up in ftr_bits.
> >
> > I would guess you meant RES1 rather than RAO (or not ?).
> > (I would think RAO is more like for a specific CPU hardware rather
> >  than for CPU architecture specification)
> >
> > For every single register in cpufeature.c that has arm64_ftr_bits,
> > I checked 'Field descriptions' from the page below.
> >   https://developer.arm.com/documentation/ddi0595/2021-03/AArch64-Registers
> >
> > I found one register that has a RES1 field, which is bit 31 of CTR_EL0.
> > (I didn't find any field that is defined as RAO though)
> > The RES1 field is actually defined in ftr_ctr as follows.
> > -------------------------------------------------------------------
> > <arch/arm64/kernel/cpufeature.c>
> >
> > <...>
> > static const struct arm64_ftr_bits ftr_ctr[] = {
> >         ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, 31, 1, 1), /* RES1 */
> >         ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
> > CTR_DIC_SHIFT, 1, 1),
> >         ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE,
> > CTR_IDC_SHIFT, 1, 1),
> > <...>
> > -------------------------------------------------------------------
> >
> > It looks like RES1 field is okay.
> > Or do you have any specific registers/fields that you are
> > concerned about ?
>
> You're right, I meant the RES1 bits that we set ourselves, not bits HW
> presents as ones. And, as you've confirmed RES1 is covered by
> arm64_ftr_bits, then I apologize for the noise.

No, it wasn't noise.  It was good for me to confirm that.
Thank you so much for the comment.

Regards,
Reiji
