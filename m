Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C433F14F9
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 10:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbhHSIRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 04:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbhHSIRJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 04:17:09 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC06C061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 01:16:33 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id i9so10975704lfg.10
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 01:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yIjfNruIRqoaZMP1dFgzuYg2bekGFWIjBtMbeKsjOv4=;
        b=Uh1Rb4Tubmyt9cse91ISt5kDTlQA5cOUNtpTo3ndsgr8Ck+k+NFexFFUz7dyuM2H3t
         m3kAPtmzO3DBlZuQbQOS1BGJjUv9r6yFgy0WnVgPSxucBCkqke5QvTkuTCy+8oy0eOTb
         JkmkswyVt1D3ZoaYkI5dov/HLiOeTx2Mr0bQ2TJFhtusQPTrCpPomFM4IItSUMn8JFmy
         Q9HWWiKPZA6ri/QVNnb34rhV/YDwcBDhhZlbiewsQu0Tsb8x3P4CosXJJGeXo3yOBl4Y
         D8HnhI1tOhAnkfLZwT3K4kw7633qGlsmUBv1GFT8pq0ffBfsjvKvZ0yKkegYDWU7Uxxr
         5cGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yIjfNruIRqoaZMP1dFgzuYg2bekGFWIjBtMbeKsjOv4=;
        b=rbZGc9p06kYl8PmcjeVtyzMl9fBIWLv65Ws4f0VCZb0Jp0sZeAR1JO9n022XzETM1K
         z3cvEytZpWhZlAcpDgAELbCwRsOdBLoGDh53r0jz4LaiE+KkX6XrYK3j5eOovB6rZIC9
         iOEHr2Q/UWTMJ6lpbYU2SuCt7c1h6mlu7HdtwIIYz+y+fTtGYrnPwbF+3nD+1Ux1iYCD
         ce0fRwh6AExZiXrsBMGsjjn58zK6630V6winpfs04f1hXkSFiUaXNrVvzEY3wcIxSxKm
         OAoKz2RNIRD18ZXndWdgG+wGeLKkKE3E1DZM7VblJOzX77olUebW0gxTpLSTMUslQmXQ
         cEGw==
X-Gm-Message-State: AOAM5312Zb2F+COpCfZsXX7dwQR7Z+a7PKJBqhPoKjpMOwzd9HdSn46q
        +rUtGKpN/mht/v6pwv/SvtJfxBLjHNUiYwJWpTXfrA==
X-Google-Smtp-Source: ABdhPJwrWW9U4piKXkDbBKX+qAG8nI3LRbhJGUFw/CctYUBkZ/9YzEYznpDVd1/rjsXd1dFJ2yjXMXs2F+/onMOvPlM=
X-Received: by 2002:a05:6512:4025:: with SMTP id br37mr9473510lfb.23.1629360990837;
 Thu, 19 Aug 2021 01:16:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210818213205.598471-1-ricarkol@google.com> <CAOQ_QshVenuri8WdZdEis4szCv03U0KRNt4CqDNtvUBsqBqUoA@mail.gmail.com>
 <YR1/YEY8DX+r05nt@google.com> <CAOQ_Qsgy7d7pWc=0AHpR2LHO67Z=gCa-TV46NxXMsFP8yqOzTw@mail.gmail.com>
 <877dghsvvt.wl-maz@kernel.org>
In-Reply-To: <877dghsvvt.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 19 Aug 2021 01:16:19 -0700
Message-ID: <CAOQ_QsiwWHWM_p8KOdehtCFP_yUzsCp7uF0ePXn9EGmvfYD7Aw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: vgic: drop WARN from vgic_get_irq
To:     Marc Zyngier <maz@kernel.org>
Cc:     Ricardo Koller <ricarkol@google.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, james.morse@arm.com, Alexandru.Elisei@arm.com,
        drjones@redhat.com, catalin.marinas@arm.com,
        suzuki.poulose@arm.com, jingzhangos@google.com, pshier@google.com,
        rananta@google.com, reijiw@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021 at 1:04 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 19 Aug 2021 08:41:19 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > On Wed, Aug 18, 2021 at 2:45 PM Ricardo Koller <ricarkol@google.com> wrote:
> > >
> > > On Wed, Aug 18, 2021 at 02:34:03PM -0700, Oliver Upton wrote:
> > > > Hi Ricardo,
> > > >
> > > > On Wed, Aug 18, 2021 at 2:32 PM Ricardo Koller <ricarkol@google.com> wrote:
> > > > >
> > > > > vgic_get_irq(intid) is used all over the vgic code in order to get a
> > > > > reference to a struct irq. It warns whenever intid is not a valid number
> > > > > (like when it's a reserved IRQ number). The issue is that this warning
> > > > > can be triggered from userspace (e.g., KVM_IRQ_LINE for intid 1020).
> > > > >
> > > > > Drop the WARN call from vgic_get_irq.
> > > > >
> > > > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > > > ---
> > > > >  arch/arm64/kvm/vgic/vgic.c | 1 -
> > > > >  1 file changed, 1 deletion(-)
> > > > >
> > > > > diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> > > > > index 111bff47e471..81cec508d413 100644
> > > > > --- a/arch/arm64/kvm/vgic/vgic.c
> > > > > +++ b/arch/arm64/kvm/vgic/vgic.c
> > > > > @@ -106,7 +106,6 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
> > > > >         if (intid >= VGIC_MIN_LPI)
> > > > >                 return vgic_get_lpi(kvm, intid);
> > > > >
> > > > > -       WARN(1, "Looking up struct vgic_irq for reserved INTID");
> > > >
> > > > Could we maybe downgrade the message to WARN_ONCE() (to get a stack)
> > > > or pr_warn_ratelimited()? I agree it is problematic that userspace can
> > > > cause this WARN to fire, but it'd be helpful for debugging too.
> > > >
> > >
> > > Was thinking about that, until I found this in bug.h:
> > >
> > >         /*
> > >          * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
> > >          * significant kernel issues that need prompt attention if they should ever
> > >          * appear at runtime.
> > >          *
> > >          * Do not use these macros when checking for invalid external inputs
> > >          * (e.g. invalid system call arguments, or invalid data coming from
> > >          * network/devices),
> > >
> > > Just in case, KVM_IRQ_LINE returns -EINVAL for an invalid intid (like
> > > 1020). I think it's more appropriate for the vmm to log it. What do you
> > > think?
> >
> > vgic_get_irq() is called in a bunch of other places though, right?
> > IOW, intid doesn't necessarily come from userspace. In fact, I believe
> > KVM_IRQ_LINE is the only place we pass a value from userspace to
> > vgic_get_irq() (don't quote me on that).
> >
> > Perhaps instead the fix could be to explicitly check that the intid
> > from userspace is valid and exit early rather than count on
> > vgic_get_irq() to do the right thing.
>
> vgic_get_irq() is designed to do the right thing. Returning NULL is
> the way it reports an error, and this NULL value is already checked at
> when directly provided either by the VMM or the guest. If we missed
> any of those, that would be what needs addressing.  Obtaining a NULL
> pointer is a good way to catch those.
>
> In general, the kernel log is not how we report userspace errors (we
> have been there before...). It is slow, noisy, unclear and ultimately
> leaks information.

Absolutely. My comments were aimed at calls to vgic_get_irq() where
intid is coming from the kernel, not userspace. That being said,
probably no good reason to buy a full fat WARN() in a function such as
this one.  I'm done waffling on this one liner now :)

Reviewed-by: Oliver Upton <oupton@google.com>

> If you really want something, then a pr_debug is a
> potential tool as it can be dynamically enabled with the right
> configuration.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
