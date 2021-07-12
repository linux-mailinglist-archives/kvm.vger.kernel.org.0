Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BEE3C6542
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 23:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhGLVGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 17:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhGLVGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 17:06:05 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ADDC0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 14:03:16 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id v14so2983034plg.9
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 14:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ThVuTOrd3dYAEEJRjDVU3NiFGGY4NsXeanubIT7E+8A=;
        b=f6vC1QkkFVyOj6YHZ0XbnUdqTCh/z6b7MZ2BIiAJqAe10iw267GjUP6YLPJcTbEJ9n
         895212u4pYe+Sb71r6MWCK2zGTP5b8TAskmyomxkLe5KqR8jKMbcyEJlhQxGycKRt5yo
         gJtcmkwMtm9gzeghGEdsLi1CpjKWFzrSEd87n180348SDfDVdIuvRDFal6Y1yK9r4G3g
         JVSu32MP+jamnq58FesPFODAQDWgXs5RtDLZXHKIX+MNomUVvB2kljsPWqZWncfcxnqZ
         tXdTURvEbYmB7t8ZICybwN7mvrwstXco+IMfMIcJhmKk+kYwNDVsrGm/5Jt0fV8MImGb
         whdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ThVuTOrd3dYAEEJRjDVU3NiFGGY4NsXeanubIT7E+8A=;
        b=V7DkOFPbxyqZc+2IM0zws2kAb2SN9CtpxyVHkiLs3nTZlWl0hp8znvo4Npmvc9OAyL
         Mh/YWLRjG6zOb5xFp+KbMVn3Tgq8J5FKkWHZ46b5o0X206/aEX/KBX6F+LOVkp6Z5nOj
         1iONt7vRrVJijI36HVFJa3mFe/brmG3Z7ST6sZNmMucOiQnUAAro9dDOGXihkybgXCCB
         nT5K6mPFCrtPcri0HlNB5/rA/qAoGkRAy4+mYoZiL3oXAW3cFkUe7rvFBVqSWOpOg+RG
         vteBDMpiW/GdgAYmG1nJQrtQo8OXX3yXLodXR0//851BzISFREjpfLcRvu025hLXus7R
         Qzwg==
X-Gm-Message-State: AOAM530D8U0kg/pWhMOLAqb2kQjZuIZHxIoRBC60Vh09jrsxMAd9mP3s
        rQU6Cz/+kfXAHaHjKyKY8WJDqg==
X-Google-Smtp-Source: ABdhPJyRzK97B/13GGmkcM6iOCjE1VLKvepudlBgRSYfUOleDf+vRvb0t+Te3cTGHdCr25dW4To9Gw==
X-Received: by 2002:a17:90a:c283:: with SMTP id f3mr812703pjt.138.1626123796223;
        Mon, 12 Jul 2021 14:03:16 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g6sm131719pfi.108.2021.07.12.14.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 14:03:15 -0700 (PDT)
Date:   Mon, 12 Jul 2021 21:03:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     David Matlack <dmatlack@google.com>, kvm <kvm@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: fast_page_fault support for the TDP
 MMU
Message-ID: <YOyuD7UJXHpNnXA2@google.com>
References: <20210630214802.1902448-1-dmatlack@google.com>
 <20210630214802.1902448-5-dmatlack@google.com>
 <CANgfPd_Ew2AcwegRxcwr+M_myVjyjq2UVz=pHqVuy-UnPWY_ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd_Ew2AcwegRxcwr+M_myVjyjq2UVz=pHqVuy-UnPWY_ew@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 12, 2021, Ben Gardon wrote:
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index c6fa8d00bf9f..2c9e0ed71fa0 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -527,6 +527,10 @@ static inline bool tdp_mmu_set_spte_atomic_no_dirty_log(struct kvm *kvm,
> >         if (is_removed_spte(iter->old_spte))
> >                 return false;
> >
> > +       /*
> > +        * TDP MMU sptes can also be concurrently cmpxchg'd in
> > +        * fast_pf_fix_direct_spte as part of fast_page_fault.
> > +        */

The cmpxchg64 part isn't what's interesting, it's just the means to the end.
Maybe reword slightly to focus on modifying SPTEs without holding mmu_lock, e.g.

	/*
	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs outside
	 * of mmu_lock.
	 */

> >         if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
> >                       new_spte) != iter->old_spte)
> >                 return false;
> 
> I'm a little nervous about not going through the handle_changed_spte
> flow for the TDP MMU, but as things are now, I think it's safe.

Ya, it would be nice to flow through the TDP MMU proper as we could also "restore"
__rcu.  That said, the fast #PF fix flow is unique and specific enough that I don't
think it's worth going out of our way to force the issue.

> > @@ -1546,3 +1550,35 @@ int kvm_tdp_mmu_get_walk_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> >
> >         return leaf;
> >  }
> > +
> > +/*
> > + * Must be called between kvm_tdp_mmu_walk_shadow_page_lockless_{begin,end}.
> > + *
> > + * The returned sptep must not be used after
> > + * kvm_tdp_mmu_walk_shadow_page_lockless_end.
> > + */
> > +u64 *kvm_tdp_mmu_get_last_sptep_lockless(struct kvm_vcpu *vcpu, u64 addr,
> > +                                        u64 *spte)
> > +{
> > +       struct tdp_iter iter;
> > +       struct kvm_mmu *mmu = vcpu->arch.mmu;
> > +       gfn_t gfn = addr >> PAGE_SHIFT;
> > +       tdp_ptep_t sptep = NULL;
> > +
> > +       tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
> > +               *spte = iter.old_spte;
> > +               sptep = iter.sptep;
> > +       }
> > +
> > +       if (sptep)

This check is unnecessary, even when using rcu_dereference.

> > +               /*
> > +                * Perform the rcu dereference here since we are passing the
> > +                * sptep up to the generic MMU code which does not know the
> > +                * synchronization details of the TDP MMU. This is safe as long
> > +                * as the caller obeys the contract that the sptep is not used
> > +                * after kvm_tdp_mmu_walk_shadow_page_lockless_end.
> > +                */
> 
> There's a little more to this contract:
> 1. The caller should only modify the SPTE using an atomic cmpxchg with
> the returned spte value.
> 2. The caller should not modify the mapped PFN or present <-> not
> present state of the SPTE.
> 3. There are other bits the caller can't modify too. (lpage, mt, etc.)
> 
> If the comments on this function don't document all the constraints on
> how the returned sptep can be used, it might be safer to specify that
> this is only meant to be used as part of the fast page fault handler.

Or maybe a less specific, but more scary comment?

> 
> > +               return rcu_dereference(sptep);

I still vote to use "(__force u64 *)" instead of rcu_dereference() to make it
clear we're cheating in order to share code with the legacy MMU.

	/*
	 * Squash the __rcu annotation, the legacy MMU doesn't rely on RCU to
	 * protect its page tables and so the common MMU code doesn't preserve
	 * the annotation.
	 *
	 * It goes without saying, but the caller must honor all TDP MMU
	 * contracts for accessing/modifying SPTEs outside of mmu_lock.
	 */
	return (__force u64 *)sptep;
	
> > +       return NULL;
> > +}
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> > index e9dde5f9c0ef..508a23bdf7da 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.h
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> > @@ -81,6 +81,8 @@ void kvm_tdp_mmu_walk_lockless_begin(void);
> >  void kvm_tdp_mmu_walk_lockless_end(void);
> >  int kvm_tdp_mmu_get_walk_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> >                                   int *root_level);
> > +u64 *kvm_tdp_mmu_get_last_sptep_lockless(struct kvm_vcpu *vcpu, u64 addr,
> > +                                        u64 *spte);
> >
> >  #ifdef CONFIG_X86_64
> >  bool kvm_mmu_init_tdp_mmu(struct kvm *kvm);
> > --
> > 2.32.0.93.g670b81a890-goog
> >
