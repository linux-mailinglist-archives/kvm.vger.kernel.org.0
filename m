Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4D1459845
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 00:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhKVXL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 18:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhKVXLy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 18:11:54 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDA1C061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 15:08:46 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so1222839pjb.1
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 15:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C3M3VDAz8v2lptAuLdLoPEVMDwHdi1Hdtg7AjRZiumw=;
        b=fKL9TGp7QAW1czNovJUbKasEoTacuIJwSY1AqQgwbeopJv8CFaIdiM0hzs3L7PLrg4
         ge0QOTbv+eraAcABai9uZYMFC7GZLma7/WFLYfbiFdZ8iSdfR0eF4keejO4rlrJ3fP98
         Q3ECM7tpdpsihotxoSUiY9ciNSDInmqwudyy1Juqsjf90dEAmAhFUv2LfMcbbjBfR86B
         jvZ2xZqWDSKR8QO9xklb0SHOCtVZE5eV5sbB1jajJeFyfEQD9NLSqEk0bDHmdGfwd5mz
         c38x67Sr2mA66b1VyyECBy2IOEHYldxs9jN4Afhdix3o4fWfbZFbiykUCJRnOGVhl57x
         st+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C3M3VDAz8v2lptAuLdLoPEVMDwHdi1Hdtg7AjRZiumw=;
        b=u6+LsO3ux5wmSRjJxex7HSNkEAbMqRqTTikHz54eIKkMJsRkX3qr7g4UFNvMMQ8fT5
         Qyo3daomKyPX65iM3tSmhvYo3/RgHgW/FETnJLYkLxHfJGxYBHXicPJd2F1JjWCChuzY
         GsODkeRL+KVJNCyQ87zEg4/bR/i/silT592eDeZ6N9wF2EkiVQ/PlyL1pe1e8jf4k7rA
         c0NcpueCJ3Q0rOx61mlQwq35s1rbU73ffYcLYC3Jd0u166ViFEerSyJA4emgxLRawMu9
         je/OC2BHfFpASEhcwGgKfcaKFh+Py3H+EL4jnJpqx7rmLER2t8MGoMWpVhg+2HID+cPy
         N4Cg==
X-Gm-Message-State: AOAM53050uoiCUv/8wmfXyIRrNS6Zg8yoOtjHmDvTlT/mRJXjAapBxZU
        0hrZwz1oj0BgIyJ57rs0TAMl8A==
X-Google-Smtp-Source: ABdhPJyu6RVl1K5Li/JR7TjfZUoitw3SzM99pVCoNtfWZrGec4a7CbHV0+ttxU0FiMCLBc2dRL/ccg==
X-Received: by 2002:a17:902:c20d:b0:142:1009:585d with SMTP id 13-20020a170902c20d00b001421009585dmr1177081pll.83.1637622525819;
        Mon, 22 Nov 2021 15:08:45 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t2sm10064117pfd.36.2021.11.22.15.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 15:08:45 -0800 (PST)
Date:   Mon, 22 Nov 2021 23:08:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Subject: Re: [PATCH 15/28] KVM: x86/mmu: Take TDP MMU roots off list when
 invalidating all roots
Message-ID: <YZwi+TzVLQi5YlIX@google.com>
References: <20211120045046.3940942-1-seanjc@google.com>
 <20211120045046.3940942-16-seanjc@google.com>
 <CANgfPd8Kz41FpvooznGW2VLp8GZFei28FCjonr2+YEZoturi0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8Kz41FpvooznGW2VLp8GZFei28FCjonr2+YEZoturi0A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021, Ben Gardon wrote:
> On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Take TDP MMU roots off the list of roots when they're invalidated instead
> > of walking later on to find the roots that were just invalidated.  In
> > addition to making the flow more straightforward, this allows warning
> > if something attempts to elevate the refcount of an invalid root, which
> > should be unreachable (no longer on the list so can't be reached by MMU
> > notifier, and vCPUs must reload a new root before installing new SPTE).
> >
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> There are a bunch of awesome little cleanups and unrelated fixes
> included in this commit that could be factored out.
> 
> I'm skeptical of immediately moving the invalidated roots into another
> list as that seems like it has a lot of potential for introducing
> weird races.

I disagree, the entire premise of fast invalidate is that there can't be races,
i.e. mmu_lock must be held for write.  IMO, it's actually the opposite, as the only
reason leaving roots on the per-VM list doesn't have weird races is because slots_lock
is held.  If slots_lock weren't required to do a fast zap, which is feasible for the
TDP MMU since it doesn't rely on the memslots generation, then it would be possible
for multiple calls to kvm_tdp_mmu_zap_invalidated_roots() to run in parallel.  And in
that case, leaving roots on the per-VM list would lead to a single instance of a
"fast zap" zapping roots it didn't invalidate.  That's wouldn't be problematic per se,
but I don't like not having a clear "owner" of the invalidated root.

> I'm not sure it actually solves a problem either. Part of
> the motive from the commit description "this allows warning if
> something attempts to elevate the refcount of an invalid root" can be
> achieved already without moving the roots into a separate list.

Hmm, true in the sense that kvm_tdp_mmu_get_root() could be converted to a WARN,
but that would require tdp_mmu_next_root() to manually skip invalid roots.
kvm_tdp_mmu_get_vcpu_root_hpa() is naturally safe because page_role_for_level()
will never set the invalid flag.

I don't care too much about adding a manual check in tdp_mmu_next_root(), what I don't
like is that a WARN in kvm_tdp_mmu_get_root() wouldn't be establishing an invariant
that invalidated roots are unreachable, it would simply be forcing callers to check
role.invalid.

> Maybe this would seem more straightforward with some of the little
> cleanups factored out, but this feels more complicated to me.
> > @@ -124,6 +137,27 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
> >  {
> >         struct kvm_mmu_page *next_root;
> >
> > +       lockdep_assert_held(&kvm->mmu_lock);
> > +
> > +       /*
> > +        * Restart the walk if the previous root was invalidated, which can
> > +        * happen if the caller drops mmu_lock when yielding.  Restarting the
> > +        * walke is necessary because invalidating a root also removes it from
> 
> Nit: *walk
> 
> > +        * tdp_mmu_roots.  Restarting is safe and correct because invalidating
> > +        * a root is done if and only if _all_ roots are invalidated, i.e. any
> > +        * root on tdp_mmu_roots was added _after_ the invalidation event.
> > +        */
> > +       if (prev_root && prev_root->role.invalid) {
> > +               kvm_tdp_mmu_put_root(kvm, prev_root, shared);
> > +               prev_root = NULL;
> > +       }
> > +
> > +       /*
> > +        * Finding the next root must be done under RCU read lock.  Although
> > +        * @prev_root itself cannot be removed from tdp_mmu_roots because this
> > +        * task holds a reference, its next and prev pointers can be modified
> > +        * when freeing a different root.  Ditto for tdp_mmu_roots itself.
> > +        */
> 
> I'm not sure this is correct with the rest of the changes in this
> patch. The new version of invalidate_roots removes roots from the list
> immediately, even if they have a non-zero ref-count.

Roots don't have to be invalidated to be removed, e.g. if the last reference is
put due to kvm_mmu_reset_context().  Or did I misunderstand?

> >         rcu_read_lock();
> >
> >         if (prev_root)
> > @@ -230,10 +264,13 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> >         root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
> >         refcount_set(&root->tdp_mmu_root_count, 1);
> >
> > -       spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> > -       list_add_rcu(&root->link, &kvm->arch.tdp_mmu_roots);
> > -       spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> > -
> > +       /*
> > +        * Because mmu_lock must be held for write to ensure that KVM doesn't
> > +        * create multiple roots for a given role, this does not need to use
> > +        * an RCU-friendly variant as readers of tdp_mmu_roots must also hold
> > +        * mmu_lock in some capacity.
> > +        */
> 
> I doubt we're doing it now, but in principle we could allocate new
> roots with mmu_lock in read + tdp_mmu_pages_lock. That might be better
> than depending on the write lock.

We're not, this function does lockdep_assert_held_write(&kvm->mmu_lock) a few
lines above.  I don't have a preference between using mmu_lock.read+tdp_mmu_pages_lock
versus mmu_lock.write, but I do care that the current code doesn't incorrectly imply
that it's possible for something else to be walking the roots while this runs.

Either way, this should definitely be a separate patch, pretty sure I just lost
track of it.
 
> > +       list_add(&root->link, &kvm->arch.tdp_mmu_roots);
> >  out:
> >         return __pa(root->spt);
> >  }
