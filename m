Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCE63D7C8B
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 19:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhG0Rsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 13:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhG0Rsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 13:48:39 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9775C061760
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 10:48:38 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id h63-20020a9d14450000b02904ce97efee36so14261898oth.7
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 10:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hirHjnieMlx0uLSMjf9Bez4E7tmDYC0RWntJ9sY1Y4U=;
        b=DkiBe+CvNLt7y+5WnZWaoVX+BUITXOV+CQ36UKsztAvM1GKqvJpGLOjvLWMKoiz/nn
         /p3QJBPV8mSmSgduJCPadwChAIDxrA70vHEtqoOf0z/eC3eXnQy8EEI38C1VZgGw8r1c
         96AXn0NpYpp5eO13Z2CMyVIvxf2JbrSM/Zh8w50bqAygCKIxVvA0gNys9QzGI8AeJoOb
         BJFEgGMxqpZRXlb377ZzyEevaWo0BzooJYilT2qQnsz/QFyWLrRGWlvA5Oymph0PkahV
         8macs/6FMoWQfHGU+Xo6kdgQPF5sRqkP8oJ6a4+lkJF8efkSgN2MhKV9r2GVXzSiEhwj
         peRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hirHjnieMlx0uLSMjf9Bez4E7tmDYC0RWntJ9sY1Y4U=;
        b=IdU9hwr0c7vZWhLwL4pw+UVm+xaKpGoTs4jhqWuyyfgBlXB5nLI0ZSmUOtg/0ORxeF
         tCWVIiquTxUb8ylqpkI5jMasGhX95WGV5/GWbP61vQq7bxjB68POobP2rXacYB+yn/DR
         BiEnCOJbneuefPkFWEceF5jEexUBCur/7JKq9iY6GEfBq/zOy5o6qAoJAcv3h3ENWmkX
         1iPHWhhGiEZXATgxkhJ3bX5v1BA6JJmyOx32MHjeBRgQF02WwwkRN/lgXgRAS5pP8m8Q
         d+Rn3FBYjRkYYUSU4Asc0BX4n6NNXOszoRy4cxpcECIfj5o5Cbt24cc+LyRGUx217/8k
         AI1w==
X-Gm-Message-State: AOAM531ym11r/ehx5asIQ5K2XbKXpzDBXjFIln1MYBBD5QKYJcpIgl/K
        5UlCFg4XcIyfwVtnCFu84Ze64VixXbwgK1W7pjaf8Q==
X-Google-Smtp-Source: ABdhPJwVBE2V0DHG9jgGk0UMUwFyNZpcHTcrWnDWATpaskugd/LxnivlTpZvR+JQcDXwBp0NecAwJJnLuIt9/OKYH8k=
X-Received: by 2002:a05:6830:242f:: with SMTP id k15mr16795416ots.72.1627408117842;
 Tue, 27 Jul 2021 10:48:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210713142023.106183-1-mlevitsk@redhat.com> <20210713142023.106183-9-mlevitsk@redhat.com>
 <c51d3f0b46bb3f73d82d66fae92425be76b84a68.camel@redhat.com>
 <YPXJQxLaJuoF6aXl@google.com> <64ed28249c1895a59c9f2e2aa2e4c09a381f69e5.camel@redhat.com>
 <YPnBxHwMJkTSBHfC@google.com> <714b56eb83e94aca19e35a8c258e6f28edc0a60d.camel@redhat.com>
In-Reply-To: <714b56eb83e94aca19e35a8c258e6f28edc0a60d.camel@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 27 Jul 2021 10:48:26 -0700
Message-ID: <CANgfPd_o5==utejx6iG9xfWrbKtsvGWNbB4yrmuA-NVj_r_a9A@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] KVM: x86: hyper-v: Deactivate APICv only when
 AutoEOI feature is in use
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm <kvm@vger.kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021 at 6:06 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> On Thu, 2021-07-22 at 19:06 +0000, Sean Christopherson wrote:
> > +Ben
> >
> > On Thu, Jul 22, 2021, Maxim Levitsky wrote:
> > > On Mon, 2021-07-19 at 18:49 +0000, Sean Christopherson wrote:
> > > > On Sun, Jul 18, 2021, Maxim Levitsky wrote:
> > > > > I am more inclined to fix this by just tracking if we hold the srcu
> > > > > lock on each VCPU manually, just as we track the srcu index anyway,
> > > > > and then kvm_request_apicv_update can use this to drop the srcu
> > > > > lock when needed.
> > > >
> > > > The entire approach of dynamically adding/removing the memslot seems doomed to
> > > > failure, and is likely responsible for the performance issues with AVIC, e.g. a
> > > > single vCPU temporarily inhibiting AVIC will zap all SPTEs _twice_; on disable
> > > > and again on re-enable.
> > > >
> > > > Rather than pile on more gunk, what about special casing the APIC access page
> > > > memslot in try_async_pf()?  E.g. zap the GFN in avic_update_access_page() when
> > > > disabling (and bounce through kvm_{inc,dec}_notifier_count()), and have the page
> > > > fault path skip directly to MMIO emulation without caching the MMIO info.  It'd
> > > > also give us a good excuse to rename try_async_pf() :-)
> > > >
> > > > If lack of MMIO caching is a performance problem, an alternative solution would
> > > > be to allow caching but add a helper to zap the MMIO SPTE and request all vCPUs to
> > > > clear their cache.
> > > >
> > > > It's all a bit gross, especially hijacking the mmu_notifier path, but IMO it'd be
> > > > less awful than the current memslot+SRCU mess.
> > >
> > > Hi!
> > >
> > > I am testing your approach and it actually works very well! I can't seem to break it.
> > >
> > > Could you explain why do I need to do something with kvm_{inc,dec}_notifier_count()) ?
> >
> > Glad you asked, there's one more change needed.  kvm_zap_gfn_range() currently
> > takes mmu_lock for read, but it needs to take mmu_lock for write for this case
> > (more way below).
> >
> > The existing users, update_mtrr() and kvm_post_set_cr0(), are a bit sketchy.  The
> > whole thing is a grey area because KVM is trying to ensure it honors the guest's
> > UC memtype for non-coherent DMA, but the inputs (CR0 and MTRRs) are per-vCPU,
> > i.e. for it to work correctly, the guest has to ensure all running vCPUs do the
> > same transition.  So in practice there's likely no observable bug, but it also
> > means that taking mmu_lock for read is likely pointless, because for things to
> > work the guest has to serialize all running vCPUs.
> >
> > Ben, any objection to taking mmu_lock for write in kvm_zap_gfn_range()?  It would
> > effectively revert commit 6103bc074048 ("KVM: x86/mmu: Allow zap gfn range to
> > operate under the mmu read lock"); see attached patch.  And we could even bump
> > the notifier count in that helper, e.g. on top of the attached:
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index b607e8763aa2..7174058e982b 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5568,6 +5568,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
> >
> >         write_lock(&kvm->mmu_lock);
> >
> > +       kvm_inc_notifier_count(kvm, gfn_start, gfn_end);
> > +
> >         if (kvm_memslots_have_rmaps(kvm)) {
> >                 for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> >                         slots = __kvm_memslots(kvm, i);
> > @@ -5598,6 +5600,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
> >         if (flush)
> >                 kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
> >
> > +       kvm_dec_notifier_count(kvm, gfn_start, gfn_end);
> > +
> >         write_unlock(&kvm->mmu_lock);
> >  }
> >
>
> I understand what you mean now. I thought that I need to change to code of the
> kvm_inc_notifier_count/kvm_dec_notifier_count.
>
>
>
>
> >
> >
> >
> > Back to Maxim's original question...
> >
> > Elevating mmu_notifier_count and bumping mmu_notifier_seq will will handle the case
> > where APICv is being disabled while a different vCPU is concurrently faulting in a
> > new mapping for the APIC page.  E.g. it handles this race:
> >
> >  vCPU0                                 vCPU1
> >                                        apic_access_memslot_enabled = true;
> >                                      #NPF on APIC
> >                                      apic_access_memslot_enabled==true, proceed with #NPF
> >  apic_access_memslot_enabled = false
> >  kvm_zap_gfn_range(APIC);
> >                                        __direct_map(APIC)
> >
> >  mov [APIC], 0 <-- succeeds, but KVM wants to intercept to emulate
>
> I understand this now. I guess this can't happen with original memslot disable
> which I guess has the needed locking and flushing to avoid this.
> (I didnt' study the code in depth thought)
>
> >
> >
> >
> > The elevated mmu_notifier_count and/or changed mmu_notifier_seq will cause vCPU1
> > to bail and resume the guest without fixing the #NPF.  After acquiring mmu_lock,
> > vCPU1 will see the elevated mmu_notifier_count (if kvm_zap_gfn_range() is about
> > to be called, or just finised) and/or a modified mmu_notifier_seq (after the
> > count was decremented).
> >
> > This is why kvm_zap_gfn_range() needs to take mmu_lock for write.  If it's allowed
> > to run in parallel with the page fault handler, there's no guarantee that the
> > correct apic_access_memslot_enabled will be observed.
>
> I understand now.
>
> So, Paolo, Ben Gardon, what do you think. Do you think this approach is feasable?
> Do you agree to revert the usage of the read lock?
>
> I will post a new series using this approach very soon, since I already have
> msot of the code done.
>
> Best regards,
>         Maxim Levitsky

From reading through this thread, it seems like switching from read
lock to write lock is only necessary for a small range of GFNs, (i.e.
the APIC access page) is that correct?
My initial reaction was that switching kvm_zap_gfn_range back to the
write lock would be terrible for performance, but given its only two
callers, I think it would actually be fine.
If you do that though, you should pass shared=false to
kvm_tdp_mmu_zap_gfn_range in that function, so that it knows it's
operating with exclusive access to the MMU lock.

>
> >
> >       if (is_tdp_mmu_fault)
> >               read_lock(&vcpu->kvm->mmu_lock);
> >       else
> >               write_lock(&vcpu->kvm->mmu_lock);
> >
> >       if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva)) <--- look here!
> >               goto out_unlock;
> >
> >       if (is_tdp_mmu_fault)
> >               r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
> >                                   pfn, prefault);
> >       else
> >               r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
> >                                prefault, is_tdp);
>
>
