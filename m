Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB3B450387
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 12:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhKOLge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 06:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbhKOLg0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 06:36:26 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84E6C061746;
        Mon, 15 Nov 2021 03:33:30 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id s139so34070504oie.13;
        Mon, 15 Nov 2021 03:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TosILRA7RKaPNlvAEEPHYc2XtXbrS4wfssZDLHQY1kU=;
        b=TqRbFVwlKmOFpU+H9GDPhv1LKFQZDdPlnI+QYpcSwc8pcjEVCXrsNBSKE/7FeVzvcK
         rBS5Tklh8qvP5Kq4aQytUM/2dnahwo4vILCODJUC5Yn49zu5eNjpMEeWaKQ/foEpBe4b
         5d0p+9xMqVDTpG/kdqOIGm5f2rj7b6ILCKyWITxjmCEajD6RjPmfriuJC2azJ65rRgZU
         Hxtx/FHToELfe8c83NS7pxre1zwaGmXoGYUCU0wiXU4SUxiNPLUZXPkHq4l+F1+W3f80
         CHqAzXD0fR7o4bRpQ68XVcR8IIGiQKrpuKG7mPCEhsVMD3+mud2/qN1gMar84SkO+dSj
         Rf8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TosILRA7RKaPNlvAEEPHYc2XtXbrS4wfssZDLHQY1kU=;
        b=OlvIfHJGSIJrlbdn4rHyqT2d72JPYpfnLgL6btalSGq1aym2KoUe6kLV3gMKAQ+BVn
         E9QREHXa2MWUTG9NhXP/gp1GerxC9mXXYFkDBLmRd5aA5vu9/rdrJ2mFItQ7lP8wP2sU
         x9uoL9e1nxjip2qCPmz55+z3Zqbb16PANa/hy0t4IU9lDNOc8HB7K2MYoFcj0g+ykPST
         uKPYzW6tJx2A9thE90uaW8iqsRdPfBzjSA3lvDnXHMh4z10cCk7kqSaQevPzJpV1WXAV
         zk7epoFZNQ3O5Th0016q8V+JIBE0TI3jPAoUQz4bLM0BOLV9oatIJQ32VgBtKPEgwD+w
         2bUw==
X-Gm-Message-State: AOAM5302+L3LNLWcAvFHR4H1nonXcAx33gbGr5vethO8YfgXcfn0ve5o
        /9U6JLLtyCuMVLhU3vOkq7z+2q4Y1wJ6yUbNhlk=
X-Google-Smtp-Source: ABdhPJxyVQy/sHJZgZ4KvZEkvizBX0kZDKhCmgE7dJHGPhJHuh2wOeYIp+hUtH63bEwm2aiq4onVCaX5EsLeNGrkOVg=
X-Received: by 2002:a54:4486:: with SMTP id v6mr31506038oiv.90.1636976010344;
 Mon, 15 Nov 2021 03:33:30 -0800 (PST)
MIME-Version: 1.0
References: <20211114164312.GA28736@makvihas> <87o86leo34.fsf@redhat.com>
In-Reply-To: <87o86leo34.fsf@redhat.com>
From:   Vihas Mak <makvihas@gmail.com>
Date:   Mon, 15 Nov 2021 17:03:18 +0530
Message-ID: <CAH1kMwSvLj8oK46V8m+FUM=t8h5Zch_Pi+zui+AYq6efDR0Sgw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: fix cocci warnings
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> and I find '|=' to not be very natural with booleans. I'm not sure it's
> worth changing though.

I see. But there are many functions in which '|=' is used on booleans.
get_mmio_spte(), __rmap_write_protect(), kvm_handle_gfn_range and many more.
That's why I thought it would be better if the code follows the same convention.

Thanks,
Vihas


On Mon, Nov 15, 2021 at 3:29 PM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Vihas Mak <makvihas@gmail.com> writes:
>
> > change 0 to false and 1 to true to fix following cocci warnings:
> >
> >         arch/x86/kvm/mmu/mmu.c:1485:9-10: WARNING: return of 0/1 in function 'kvm_set_pte_rmapp' with return type bool
> >         arch/x86/kvm/mmu/mmu.c:1636:10-11: WARNING: return of 0/1 in function 'kvm_test_age_rmapp' with return type bool
> >
> > Signed-off-by: Vihas Mak <makvihas@gmail.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Cc: Wanpeng Li <wanpengli@tencent.com>
> > Cc: Jim Mattson <jmattson@google.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 337943799..2fcea4a78 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1454,7 +1454,7 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> >  {
> >       u64 *sptep;
> >       struct rmap_iterator iter;
> > -     int need_flush = 0;
> > +     bool need_flush = false;
> >       u64 new_spte;
> >       kvm_pfn_t new_pfn;
> >
> > @@ -1466,7 +1466,7 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> >               rmap_printk("spte %p %llx gfn %llx (%d)\n",
> >                           sptep, *sptep, gfn, level);
> >
> > -             need_flush = 1;
> > +             need_flush = true;
> >
> >               if (pte_write(pte)) {
> >                       pte_list_remove(kvm, rmap_head, sptep);
> > @@ -1482,7 +1482,7 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> >
> >       if (need_flush && kvm_available_flush_tlb_with_range()) {
> >               kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
> > -             return 0;
> > +             return false;
> >       }
> >
> >       return need_flush;
> > @@ -1623,8 +1623,8 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> >
> >       for_each_rmap_spte(rmap_head, &iter, sptep)
> >               if (is_accessed_spte(*sptep))
> > -                     return 1;
> > -     return 0;
> > +                     return true;
> > +     return false;
> >  }
> >
> >  #define RMAP_RECYCLE_THRESHOLD 1000
>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> One minor remark: 'kvm_set_pte_rmapp()' handler is passed to
> 'kvm_handle_gfn_range()' which does
>
>         bool ret = false;
>
>         for_each_slot_rmap_range(...)
>                 ret |= handler(...);
>
> and I find '|=' to not be very natural with booleans. I'm not sure it's
> worth changing though.
>
> --
> Vitaly
>
