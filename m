Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E14E3C6283
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 20:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbhGLSXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 14:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhGLSXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 14:23:53 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901DFC0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 11:21:04 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id u3so4549052plf.5
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 11:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q5qvOlyKCkVHWZg00XvNWOHkB+/VrXGriEoX+9NY8Dg=;
        b=qFIoHfpLN7fpPJj7YYVmA5Q5VA7xxSgMWkBIIdk/ai+U15NWsAo/pwbGAwVLLwFE1Q
         2kbIJ4IdH+Q3gGxT7xQlPEZISyEwhwFBLK23cDP6sZXc9ia/aLz51DMSAxJdxzfaWh7U
         BtDkEmfnt5Owoq9HYEjrPjNG7zy2h/LYTfgQxbCO34ibuT5HcWnuM5ztHhUH4x+CMCCs
         8hA3A6Eh88vGmTvyC8jjgTSYfqr+8U0eJcw21YhWpv+ntYz14g0A4eE8A6koU/mp0ru3
         t0zjdAQ4wL3UtoAJcW0ZajZDCTvyAGcCtKjr/GiVY6jrsFkNi7tHbkWn8iEEt/br4M2Q
         D5UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q5qvOlyKCkVHWZg00XvNWOHkB+/VrXGriEoX+9NY8Dg=;
        b=pq18KzJ+CiZVxJj8PK2WgDVZeNYb6EBQX5U7uEATYAqzqZkS/3zah0STJmBGw4jD5c
         bZ6tifErs+xT+lqaDbZBbMNC+cl1HEmG9fBMxHD39ph966PxPZo7elhMhy+krXUVJ8tD
         zXzbIZkNk5M1q2yDoxI3rVQ/6O1i5+wfUpo704pAdX+Fl8ORnKhPG26jwHFY0ljSta5I
         rhlp9SAvYtlYXXWi6wINnvCuhEzkAyEt0VrwNQuTWjaIL7yJSbm4SX1C45oqcYST0eAd
         qlTiTMcUfreUo+/jCu8toguVsUxws1VDmqr6ebVdpn7VSYz7pp7JQR2a9Nt5BvKp3bgx
         UlDA==
X-Gm-Message-State: AOAM532/Nx+3K4FPr4gSNeYE74IxRJsCAMJ3GtRmdNiG0OOvo3g6hV9k
        K7PHmJoyMy5vInEKuzevbDwCcA==
X-Google-Smtp-Source: ABdhPJziUtsTwhKed2AIcsXMhFysMZ2DZPbRIIymkOawmFwsl6DpnrbqCz1yt0oLbLgqGoZL8XvnVg==
X-Received: by 2002:a17:902:864c:b029:10d:8c9e:5f56 with SMTP id y12-20020a170902864cb029010d8c9e5f56mr350428plt.8.1626114063804;
        Mon, 12 Jul 2021 11:21:03 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id o72sm15840376pfg.44.2021.07.12.11.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 11:21:02 -0700 (PDT)
Date:   Mon, 12 Jul 2021 18:20:59 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: fast_page_fault support for the TDP
 MMU
Message-ID: <YOyIC9IQN9amnCU8@google.com>
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

On Mon, Jul 12, 2021 at 10:49:55AM -0700, Ben Gardon wrote:
> On Wed, Jun 30, 2021 at 2:48 PM David Matlack <dmatlack@google.com> wrote:
> >
> > Make fast_page_fault interoperate with the TDP MMU by leveraging
> > walk_shadow_page_lockless_{begin,end} to acquire the RCU read lock and
> > introducing a new helper function kvm_tdp_mmu_get_last_sptep_lockless to
> > grab the lowest level sptep.
> >
> > Suggested-by: Ben Gardon <bgardon@google.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c     | 55 +++++++++++++++++++++++++++-----------
> >  arch/x86/kvm/mmu/tdp_mmu.c | 36 +++++++++++++++++++++++++
> >  arch/x86/kvm/mmu/tdp_mmu.h |  2 ++
> >  3 files changed, 78 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 88c71a8a55f1..1d410278a4cc 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3105,15 +3105,45 @@ static bool is_access_allowed(u32 fault_err_code, u64 spte)
> >         return spte & PT_PRESENT_MASK;
> >  }
> >
> > +/*
> > + * Returns the last level spte pointer of the shadow page walk for the given
> > + * gpa, and sets *spte to the spte value. This spte may be non-preset.
> > + *
> > + * If no walk could be performed, returns NULL and *spte does not contain valid
> > + * data.
> > + *
> > + * Constraints:
> > + *  - Must be called between walk_shadow_page_lockless_{begin,end}.
> > + *  - The returned sptep must not be used after walk_shadow_page_lockless_end.
> > + */
> > +u64 *get_last_sptep_lockless(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte)
> > +{
> > +       struct kvm_shadow_walk_iterator iterator;
> > +       u64 old_spte;
> > +       u64 *sptep = NULL;
> > +
> > +       if (is_tdp_mmu(vcpu->arch.mmu))
> > +               return kvm_tdp_mmu_get_last_sptep_lockless(vcpu, gpa, spte);
> > +
> > +       for_each_shadow_entry_lockless(vcpu, gpa, iterator, old_spte) {
> > +               sptep = iterator.sptep;
> > +               *spte = old_spte;
> > +
> > +               if (!is_shadow_present_pte(old_spte))
> > +                       break;
> > +       }
> > +
> > +       return sptep;
> > +}
> > +
> >  /*
> >   * Returns one of RET_PF_INVALID, RET_PF_FIXED or RET_PF_SPURIOUS.
> >   */
> >  static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
> >  {
> > -       struct kvm_shadow_walk_iterator iterator;
> > -       struct kvm_mmu_page *sp;
> >         int ret = RET_PF_INVALID;
> >         u64 spte = 0ull;
> > +       u64 *sptep = NULL;
> >         uint retry_count = 0;
> >
> >         if (!page_fault_can_be_fast(error_code))
> > @@ -3122,16 +3152,14 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
> >         walk_shadow_page_lockless_begin(vcpu);
> >
> >         do {
> > +               struct kvm_mmu_page *sp;
> >                 u64 new_spte;
> >
> > -               for_each_shadow_entry_lockless(vcpu, gpa, iterator, spte)
> > -                       if (!is_shadow_present_pte(spte))
> > -                               break;
> > -
> > +               sptep = get_last_sptep_lockless(vcpu, gpa, &spte);
> >                 if (!is_shadow_present_pte(spte))
> >                         break;
> >
> > -               sp = sptep_to_sp(iterator.sptep);
> > +               sp = sptep_to_sp(sptep);
> >                 if (!is_last_spte(spte, sp->role.level))
> >                         break;
> >
> > @@ -3189,8 +3217,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
> >                  * since the gfn is not stable for indirect shadow page. See
> >                  * Documentation/virt/kvm/locking.rst to get more detail.
> >                  */
> > -               if (fast_pf_fix_direct_spte(vcpu, sp, iterator.sptep, spte,
> > -                                           new_spte)) {
> > +               if (fast_pf_fix_direct_spte(vcpu, sp, sptep, spte, new_spte)) {
> >                         ret = RET_PF_FIXED;
> >                         break;
> >                 }
> > @@ -3203,7 +3230,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
> >
> >         } while (true);
> >
> > -       trace_fast_page_fault(vcpu, gpa, error_code, iterator.sptep, spte, ret);
> > +       trace_fast_page_fault(vcpu, gpa, error_code, sptep, spte, ret);
> >         walk_shadow_page_lockless_end(vcpu);
> >
> >         return ret;
> > @@ -3838,11 +3865,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> >         if (page_fault_handle_page_track(vcpu, error_code, gfn))
> >                 return RET_PF_EMULATE;
> >
> > -       if (!is_tdp_mmu_fault) {
> > -               r = fast_page_fault(vcpu, gpa, error_code);
> > -               if (r != RET_PF_INVALID)
> > -                       return r;
> > -       }
> > +       r = fast_page_fault(vcpu, gpa, error_code);
> > +       if (r != RET_PF_INVALID)
> > +               return r;
> >
> >         r = mmu_topup_memory_caches(vcpu, false);
> >         if (r)
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
> >         if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
> >                       new_spte) != iter->old_spte)
> >                 return false;
> 
> I'm a little nervous about not going through the handle_changed_spte
> flow for the TDP MMU, but as things are now, I think it's safe.
> 
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

I think documenting that this is only be meant to used as part of the
fast page fault handler is a simpler and less brittle approach. I can
also change the function names so there is no ambiguity that it is meant
for fast page fault handling. For example:
kvm_tdp_mmu_fast_pf_get_last_sptep().

> 
> > +               return rcu_dereference(sptep);
> > +
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
