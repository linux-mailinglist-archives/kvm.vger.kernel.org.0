Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934D2486AE9
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 21:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243574AbiAFUMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 15:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243549AbiAFUMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 15:12:36 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318FEC061201
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 12:12:36 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id a129so4271948oif.6
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 12:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vROeKx05r5S8zq2+fHHm+ECFUEqfMQWtVJfxmmZ8/Ww=;
        b=IwOxf8ihHeWh8Vk/JhKknys2TRVe23Nw7HM/81myIZiIRt+jJvpoy0BA/upwdcBAl1
         kEy65Evp0YMT8DcxieVwNBTYnb8LjpjnLrBmV6PL1WhT1sgXwWUiAGR8LpreT5W4U7/o
         hgpNgWq1JWBZxKb/lJ1ECeuxGk0y13t6uUAN+h2XAa+QWHIz3DMFVhcITAFXv85j0VeS
         408fSoxy2n+K4RjuRb43CvXO2Btl4Jf09YOZG+coa9ZhfJoKj+vO+7rjByazryTShDTh
         kJ9msuEmKX52Cm8vClodZ0cuYc9gyWAg6UHYP1rgHYpUGOxCji7HKp/xvsbPl1QlMc6/
         9+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vROeKx05r5S8zq2+fHHm+ECFUEqfMQWtVJfxmmZ8/Ww=;
        b=Ad7iJkZYvZEyM20oYOdECFJAwIrug2SYZeTjBkP+xdfNxRxKMyw76tem2EGVhRECCa
         9XkL+/JyrprnHod5MltcBM2owG+tQZGxy/r6/MzrKbCq7v4ZR4GsAp3ixCEfHipUyqJG
         j2wMROd4/7NpaFaN0mBC4ciRQgYpW5KxqhdXDeUO+kgEy+4QUaO+lIlGq5V++J1FyWpC
         eB5noAUBONsqEdMurY1asElnH9+fwhGEGdaqBAf9oMnpompGJKBepCuJnW5UCWsN36qm
         5VAlSA1pMaMn7GQnfLB1nrx0F+USpiIv5bQ6J0KEirg1tP+hDhnhD9hUAVjiZvRtBTJ+
         Fkqg==
X-Gm-Message-State: AOAM533YUFzK+MpEkGeNs0IREh0ArqGx84Uynku1/OSoR2T3pMTXVRsS
        XfwHV3EtPMnN5D34Y/m6yLzgzRAbA18F8c3/IH9S5A==
X-Google-Smtp-Source: ABdhPJxJ/MNcLpd6cu3C+bOIgnNNw2Mi1QOlfdVP1bmKYZXU3eundgFPCP8MKIkL04TZL9XRZB087Sxf1sixo2k3q8c=
X-Received: by 2002:a05:6808:1b22:: with SMTP id bx34mr5205268oib.68.1641499955018;
 Thu, 06 Jan 2022 12:12:35 -0800 (PST)
MIME-Version: 1.0
References: <20220106032118.34459-1-likexu@tencent.com> <YdcwXIANeB3fOWOI@google.com>
In-Reply-To: <YdcwXIANeB3fOWOI@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 6 Jan 2022 12:12:23 -0800
Message-ID: <CALMp9eSv7ZQmVsb49iPbw0gkJhYgKPGsFuw6UtEeNZ3FsBwRwA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86/pmu: Make top-down.slots event unavailable in
 supported leaf
To:     Sean Christopherson <seanjc@google.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 6, 2022 at 10:09 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jan 06, 2022, Like Xu wrote:
> > From: Like Xu <likexu@tencent.com>
> >
> > When we choose to disable the fourth fixed counter TOPDOWN.SLOTS,
> > we also need to comply with the specification and set 0AH.EBX.[bit 7]
> > to 1 if the guest (e.g. on the ICX) has a value of 0AH.EAX[31:24] > 7.
> >
> > Fixes: 2e8cd7a3b8287 ("kvm: x86: limit the maximum number of vPMU fixed counters to 3")
> > Signed-off-by: Like Xu <likexu@tencent.com>
> > ---
> > v1 -> v2 Changelog:
> > - Make it simpler to keep forward compatibility; (Sean)
> > - Wrap related comment at ~80 chars; (Sean)
> >
> > Previous:
> > https://lore.kernel.org/kvm/20220105050711.67280-1-likexu@tencent.com/
> >
> >  arch/x86/kvm/cpuid.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 0b920e12bb6d..4fe17a537084 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -782,6 +782,18 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >               eax.split.mask_length = cap.events_mask_len;
> >
> >               edx.split.num_counters_fixed = min(cap.num_counters_fixed, MAX_FIXED_COUNTERS);
> > +
> > +             /*
> > +              * The 8th Intel architectural event (Topdown Slots) will be supported
>
> Nit, the "8th" part is unnecessary information.
>
> > +              * if the 4th fixed counter exists && EAX[31:24] > 7 && EBX[7] = 0.
> > +              *
> > +              * Currently, KVM needs to set EAX[31:24] < 8 or EBX[7] == 1
> > +              * to make this event unavailable in a consistent way.
> > +              */
>
> This comment is now slightly stale.  It also doesn't say why the event is made
> unavailable.
>
> > +             if (edx.split.num_counters_fixed < 4 &&
>
> Rereading the changelog and the changelog of the Fixed commit, I don't think KVM
> should bother checking num_counters_fixed.  IIUC, cap.events_mask[7] should already
> be '1' if there are less than 4 fixed counters in hardware, but at the same time
> there's no harm in being a bit overzealous.  That would help simplifiy the comment
> as there's no need to explain why num_counters_fixed is checked, e.g. the fact that
> Topdown Slots uses the 4th fixed counter is irrelevant with respect to the legality
> of setting EBX[7]=1 to hide an unsupported event.

I was under the impression that the CPUID.0AH:EBX bits were
independent of the fixed counters. That is, if CPUID.0AH:EAX[31:24] >
7 and CPUID.0AH:EBX[7] is clear, then one should be able to program a
general purpose counter with event selector A4H and umask 01H,
regardless of whether or not fixed counter 4 exists.

>
>                 /*
>                  * Hide Intel's Topdown Slots architectural event, it's not yet
>                  * supported by KVM.
>                  */
>                 if (eax.split.mask_length > 7)
>                         cap.events_mask |= BIT_ULL(7);
>
> > +                 eax.split.mask_length > 7)
> > +                     cap.events_mask |= BIT_ULL(7);
> > +
> >               edx.split.bit_width_fixed = cap.bit_width_fixed;
> >               if (cap.version)
> >                       edx.split.anythread_deprecated = 1;
> > --
> > 2.33.1
> >
