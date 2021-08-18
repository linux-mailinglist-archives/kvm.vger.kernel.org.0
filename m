Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8E63F08D9
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 18:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhHRQQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 12:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbhHRQQY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 12:16:24 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A38C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 09:15:49 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id z2so5826754lft.1
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 09:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TEwIWTOJnfQKmJV+qBIqJECmU7WSd1FB63B1/YrgHdo=;
        b=JVjxnq5Ac0AQvgcOOvMtjdDPsrN54xX4jVMn5RGZCrTef9yRqK3/QpW/c90fA12Ke8
         lN2XkJNKxx+qy1Bk5sJE8Xuhu4MDo6tYI7/sR6MVwhbTSsKTUHPZHcFPYcHCP0AavmHq
         hdJMhXF1/gLrEAKpnc/oEkd25jaieCRSdUJBm3Yt76qiviUFUxW973pWfHu5MjimOxiE
         91pqHKW6d5oN9mFioICJAqCSGPJ7PmUODJWLT9bmphvJxbtx3FB6gr9IsHubalMUrpuA
         QYf9tiwU0NAvZur53Hdf9XUhdVxy3cuHYI6+NcWU9o3Klll/j3NDBWD2vJyEzgrf86bh
         ri0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TEwIWTOJnfQKmJV+qBIqJECmU7WSd1FB63B1/YrgHdo=;
        b=NuZYeoHEhej8suKSmW8cXX9zMPokCKHfKG2LHt1L66mramr5FOFWS4sUDm1m29FDGi
         NPF1htFLW6RChb4Ou6nFBBVgNFDTsS6Ga6oXle7mMBdA9Yx+OmGVgoEkrlDH15qyHrmQ
         w3GknC2fEM4M05xj4Zm/XPXfpLiePsA9fKJ2DjWBqBBMwkgBH23tjLXu3vCqF6pRV3bM
         Vjuo1BYf67+6BHKTF4uQ5luqB4IEDZZAftGmEudGNj9ua3Z4dPZ9ifGgFcPbQbLzSfeJ
         +PAgifYpdhEzdpLsa1CFAqtpQzpQaNCh5c0WpOkEfXGq0cNa3ygBdjd0sY9fv9FEAIwS
         Z3lg==
X-Gm-Message-State: AOAM5310TFz3PbpZnsTPQDb4MPxwRO+AXf7sWme/OliTsfY8SfYCw7bx
        GEOjAhyui62KhpumPOKoEDe0IEO6V/Gaj9hLJt9KMA==
X-Google-Smtp-Source: ABdhPJyE8PY3a0d08H2Xg5YuBgSUNy+RLivU5nzt1SmeEwZPucMWxSqfCxYh3qHqdjE1MeGo7wziEo0rVOSB5wGguRc=
X-Received: by 2002:a05:6512:31ce:: with SMTP id j14mr3107800lfe.646.1629303347173;
 Wed, 18 Aug 2021 09:15:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210817002639.3856694-1-jingzhangos@google.com> <87v943rx32.wl-maz@kernel.org>
In-Reply-To: <87v943rx32.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 18 Aug 2021 09:15:36 -0700
Message-ID: <CAAdAUtjFdEX73fTDu-+gGfPR=KqvvSzVRZ=vVGJe=8=iAJOv1A@mail.gmail.com>
Subject: Re: [PATCH] KVM: stats: Add VM stat for remote tlb flush requests
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Wed, Aug 18, 2021 at 1:11 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 17 Aug 2021 01:26:39 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Add a new stat that counts the number of times a remote TLB flush is
> > requested, regardless of whether it kicks vCPUs out of guest mode. This
> > allows us to look at how often flushes are initiated.
>
> nit: this is a very x86-centric view of things. On arm64, TLB
> invalidation is broadcast in HW, and does not interrupt the guest
> execution.
>
Understood. Thanks.
> >
> > Original-by: David Matlack <dmatlack@google.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c      | 1 +
> >  include/linux/kvm_host.h  | 3 ++-
> >  include/linux/kvm_types.h | 1 +
> >  virt/kvm/kvm_main.c       | 1 +
> >  4 files changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 0625bf2353c2..f5bb235bbb59 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -80,6 +80,7 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
> >   */
> >  void kvm_flush_remote_tlbs(struct kvm *kvm)
> >  {
> > +     ++kvm->stat.generic.remote_tlb_flush_requests;
> >       kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
> >  }
>
> We already have this queued for 5.15 [1].
I guess you mean the change for "remote_tlb_flush" has been queued,
not "remote_tlb_flush_requests"?
These two counters would have the same value for arm64, but not for
others (at least x86).
>
> Thanks,
>
>         M.
>
> [1] https://lore.kernel.org/r/20210727103251.16561-1-pbonzini@redhat.com
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
