Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE6E22E46D
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 05:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgG0D3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jul 2020 23:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgG0D3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jul 2020 23:29:23 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898CDC0619D2;
        Sun, 26 Jul 2020 20:29:23 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id l84so634324oig.10;
        Sun, 26 Jul 2020 20:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6yKlaBSWRYtFbLh+hPRBH7MDAZ6KKac4QvWCCFjrjmc=;
        b=ms3HKQCxFeS2AOUxLb5rlSA4Cr3sUD6ZWFpPB4bwt5e+bRRQBpUss2l3sKiJxk2IYl
         UdVZoZKqqY3b24VA6Pa9x3G1QgCy5f8wWV6CpeQq+C7odFoVVLZzSuXo2o3pJg4EYts2
         TWx3NWJjygf5JpIbqptGnJm/+V7cxABWdUgcgrtH/+aI6YyPr4hR7ZzsREveSyjAQSrd
         DqntnFktk+NhjxkPl9tygrM3b3LdxgY7pGznp5a/eKh8SmZeol71I98mooapptjeWdV9
         bt/3V1huVjdXsuOkYUPmsdXK+lr1vQMymEGmBZKorcAtKL5ujtDw5KIzYX+tOcSwf85I
         UFHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6yKlaBSWRYtFbLh+hPRBH7MDAZ6KKac4QvWCCFjrjmc=;
        b=c5/CeXpB3tYeBHPR88zzgn4PcrzMwVdcfgUsfffLGnL+POvgmLkEaBqT5IepDsfqyC
         y+1XRd6dz8plJGMqMY68uDRRScaIb+nw7L0CEP3qgRLEfaRIyeQ2b7O+ZiwE4dFdRgfV
         v2VsUPCeC1LH71jMjIIpqLHzpZPTVdJSskcid30Pnu7FzweIJ+GWuCIWF284G5VrpQ5Z
         nNHLB4EL5lpQDy14Zzj3VHGAeXhSUqGQwIerbnq1p1wnn1mPv7+p9BgIA4h+u0Hj33Af
         1M0Y+OqsSPRgfsRQRkC+I4VS2I+Yr4N/BvSzG7jH8cONOHajwRMPL1R0Pdm09PkYrijM
         n+eQ==
X-Gm-Message-State: AOAM532LiNOxzd1qRTOUyN+hHYWd+KGdJzVnClyk6hFeuyaxSbVu/7Zr
        E4YB4cz7kcB5qJxbZtLKdGV8b0JWhCarhagmgC0=
X-Google-Smtp-Source: ABdhPJzJ3wSTSW4ZLU71+niW7giMZBPHMjGyJwxm4g/gZGOgRtzL13Brf02QTyo2kiGRjtYSaEM7M8DV+3oM+v4bOUk=
X-Received: by 2002:aca:5842:: with SMTP id m63mr17024204oib.5.1595820562707;
 Sun, 26 Jul 2020 20:29:22 -0700 (PDT)
MIME-Version: 1.0
References: <1595323468-4380-1-git-send-email-wanpengli@tencent.com>
 <1595323468-4380-2-git-send-email-wanpengli@tencent.com> <87lfjdp2dd.fsf@vitty.brq.redhat.com>
In-Reply-To: <87lfjdp2dd.fsf@vitty.brq.redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 27 Jul 2020 11:29:11 +0800
Message-ID: <CANRm+Cw5CqBvC+a9FbJmCjckOQdcsN+UiEYOvJfkexjp2wy0Og@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: LAPIC: Set the TDCR settable bits
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Jul 2020 at 18:51, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Wanpeng Li <kernellwp@gmail.com> writes:
>
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Only bits 0, 1, and 3 are settable, others are reserved for APIC_TDCR.
> > Let's record the settable value in the virtual apic page.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 4ce2ddd..8f7a14d 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -2068,7 +2068,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
> >       case APIC_TDCR: {
> >               uint32_t old_divisor = apic->divide_count;
> >
> > -             kvm_lapic_set_reg(apic, APIC_TDCR, val);
> > +             kvm_lapic_set_reg(apic, APIC_TDCR, val & 0xb);
> >               update_divide_count(apic);
> >               if (apic->divide_count != old_divisor &&
> >                               apic->lapic_timer.period) {
>
> AFAIU bit 2 should be 0 and other upper bits are reserved. Checking on
> bare hardware,
>
> # wrmsr 0x83e 0xb
> # rdmsr 0x83e
> b
> # wrmsr 0x83e 0xc
> wrmsr: CPU 0 cannot set MSR 0x0000083e to 0x000000000000000c
> # rdmsr 0x83e
> b
>
> Shouldn't we fail the write in case (val & ~0xb) ?

Sorry for the late response since I just come back from vacation. I
can remove the "others are reserved" in patch description for the next
version. It is a little different between Intel and AMD, Intel's bit 2
is 0 and AMD is reserved. On bare-metal, Intel will refuse to set
APIC_TDCR once bits except 0, 1, 3 are setting, however, AMD will
accept bits 0, 1, 3 and ignore other bits setting as patch does.
Before the patch, we can get back anything what we set to the
APIC_TDCR, this patch improves it.

    Wanpeng
