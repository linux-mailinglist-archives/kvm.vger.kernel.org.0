Return-Path: <kvm+bounces-72704-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YGb3GWxlqGl3uQAAu9opvQ
	(envelope-from <kvm+bounces-72704-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:01:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 934D9204C35
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:01:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 27CD33053747
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 16:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2062A36AB46;
	Wed,  4 Mar 2026 16:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LE39/pb7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0C4279DAF;
	Wed,  4 Mar 2026 16:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772643511; cv=none; b=aG8+B3Ro6iTmLrVwFpuchFAVw2yJtjGLb5m3ygCU4fdQggOYw4Sy3XpdTrHoS5O0UtpdEbwyV857FksRk452y+5Y78OFstFcjt6Re7HHJa3XCOKHdcFgPHtIITMYEv1oR8JoQpxxzfu6SodUrT1Jlbbg8ASPBhIbjxo4YkPOg7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772643511; c=relaxed/simple;
	bh=gt8PqqovFf1xLv4Q1zVMfYqYqUK+EQak4A80Hc02NSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BXofiCfEx4for4Nwu7jUrOtUjVL8Vx3vGbLrI9Xvsw+F74fJ0k0f1ZMWi0VGnHpv5RzyHtLWuQftOUoy7RoAT1olTaL2FMyk0J63RpbSHhBV6y1UIp2E1/Dgk+7F84c2atTS4i5Do1tgvUKyoqQTGccMxx0Mp0u9b43yVeFrhDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LE39/pb7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506DAC2BC87;
	Wed,  4 Mar 2026 16:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772643510;
	bh=gt8PqqovFf1xLv4Q1zVMfYqYqUK+EQak4A80Hc02NSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LE39/pb7RAXXwTk/mO6o0YD6l/cJEy06Z7h9wmDYPF0vzF96PCX1vxT/dVeD0yVen
	 flpPxEgM8VbsEJseiAcr5h93ppXp+39Rm3wfGgoW96u812DuLAcCDud9UGBiKa9UGV
	 GMKh+UPgO4HVRyZOefc10YdzRFG4R6yY/DtZdVbD2mffN0kB2flzFUfyFdGmG/dRcC
	 YjRBJ2pD24GGvbkaGYriHDmS5BjdlgV51L3irEmEiLhB19/ssE6lg7LRIbF+QIPrru
	 uzPgIRDr2PNuSWqrRpXSKUmqvPPeL0RBbYudyrtxV7IxIJjPex2gHSaJOGpEH527vv
	 W+suMeggt8Bqw==
Date: Wed, 4 Mar 2026 16:58:27 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm: use vma_start_write_killable() in
 process_vma_walk_lock()
Message-ID: <50987b7f-39ec-479d-9700-317cb0b95e6e@lucifer.local>
References: <20260226070609.3072570-1-surenb@google.com>
 <20260226070609.3072570-4-surenb@google.com>
 <72ff2fc0-07fe-4964-9a1e-eccf8c7ed6a7@lucifer.local>
 <CAJuCfpG_bekxrHd49qyUBR2K7V8o7DrOvc-ZR7M8dAC-Hyp5ng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpG_bekxrHd49qyUBR2K7V8o7DrOvc-ZR7M8dAC-Hyp5ng@mail.gmail.com>
X-Rspamd-Queue-Id: 934D9204C35
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72704-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[oracle.com,linux-foundation.org,infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[43];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ljs@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,lucifer.local:mid,oracle.com:email]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 03:59:17PM -0800, Suren Baghdasaryan wrote:
> On Mon, Mar 2, 2026 at 7:25 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Wed, Feb 25, 2026 at 11:06:09PM -0800, Suren Baghdasaryan wrote:
> > > Replace vma_start_write() with vma_start_write_killable() when
> > > process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> > > Adjust its direct and indirect users to check for a possible error
> > > and handle it. Ensure users handle EINTR correctly and do not ignore
> > > it.
> > >
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >
> > Have raised concerns below but also this feels like you're trying to do a bit
> > too much in one patch here, probably worth splitting out based on the different
> > parts you changed.
> >
> > > ---
> > >  arch/s390/kvm/kvm-s390.c |  2 +-
> > >  fs/proc/task_mmu.c       |  5 ++++-
> > >  mm/mempolicy.c           | 14 +++++++++++---
> > >  mm/pagewalk.c            | 20 ++++++++++++++------
> > >  mm/vma.c                 | 22 ++++++++++++++--------
> > >  mm/vma.h                 |  6 ++++++
> > >  6 files changed, 50 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > > index 7a175d86cef0..337e4f7db63a 100644
> > > --- a/arch/s390/kvm/kvm-s390.c
> > > +++ b/arch/s390/kvm/kvm-s390.c
> > > @@ -2948,7 +2948,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> > >               }
> > >               /* must be called without kvm->lock */
> > >               r = kvm_s390_handle_pv(kvm, &args);
> > > -             if (copy_to_user(argp, &args, sizeof(args))) {
> > > +             if (r != -EINTR && copy_to_user(argp, &args, sizeof(args))) {
> >
> > This is horribly ugly, and if we were already filtering any other instance of
> > -EINTR (if they're even possible from copy_to_user()) why is -EINTR being
> > treated in a special way?
> >
> > I honestly _hate_ this if (errcode != -EINTR) { ... } pattern in general, I'd
> > really rather we didn't.
> >
> > It's going to bitrot and people are going to assume it's for some _very good
> > reason_ and nobody will understand why it's getting special treatment...
> >
> > Surely a fatal signal would have previously resulted in -EFAULT before which is
> > a similar situation so most consistent would be to keep filtering no?
>
> Current code ignores any error coming from kvm_s390_handle_pv() and
> proceeds with copy_to_user(), possibly overriding the former error. I
> don't really know if this is an oversight or an intentional behavior,
> so I wanted to minimize possible side effects. I guess I should try to
> fix it properly (or learn why this was done this way). I'll post a
> separate patch to error out immediately if kvm_s390_handle_pv() fails
> and will ask s390 experts for review.

Thanks!

>
> >
> > >                       r = -EFAULT;
> > >                       break;
> > >               }
> > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > index e091931d7ca1..1238a2988eb6 100644
> > > --- a/fs/proc/task_mmu.c
> > > +++ b/fs/proc/task_mmu.c
> > > @@ -1797,6 +1797,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> > >               struct clear_refs_private cp = {
> > >                       .type = type,
> > >               };
> > > +             int err;
> > >
> > >               if (mmap_write_lock_killable(mm)) {
> > >                       count = -EINTR;
> > > @@ -1824,7 +1825,9 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> > >                                               0, mm, 0, -1UL);
> > >                       mmu_notifier_invalidate_range_start(&range);
> > >               }
> > > -             walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
> > > +             err = walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
> > > +             if (err < 0)
> >
> > Again with this < 0 :) let's be consistent, if (err).
>
> Ack.

Thanks!

>
> >
> > > +                     count = err;
> > >               if (type == CLEAR_REFS_SOFT_DIRTY) {
> > >                       mmu_notifier_invalidate_range_end(&range);
> > >                       flush_tlb_mm(mm);
> > > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > > index 90939f5bde02..3c8b3dfc9c56 100644
> > > --- a/mm/mempolicy.c
> > > +++ b/mm/mempolicy.c
> > > @@ -988,6 +988,8 @@ queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
> > >                       &queue_pages_lock_vma_walk_ops : &queue_pages_walk_ops;
> >
> > There's a comment above:
> >
> >  * queue_pages_range() may return:
> >  * 0 - all pages already on the right node, or successfully queued for moving
> >  *     (or neither strict checking nor moving requested: only range checking).
> >  * >0 - this number of misplaced folios could not be queued for moving
> >  *      (a hugetlbfs page or a transparent huge page being counted as 1).
> >  * -EIO - a misplaced page found, when MPOL_MF_STRICT specified without MOVEs.
> >  * -EFAULT - a hole in the memory range, when MPOL_MF_DISCONTIG_OK unspecified.
> >  */
> >
> > You should add the -EINTR to it.
>
> Ack.

Thanks!

>
> >
> > >
> > >       err = walk_page_range(mm, start, end, ops, &qp);
> > > +     if (err == -EINTR)
> > > +             return err;
> >
> > Again, you're special casing without really any justification here. Let's please
> > not special case -EINTR unless you have a _really good_ reason to.
> >
> > And also - if we fail to walk the page range because we couldn't get a VMA write
> > lock, that's ok. The walk failed. There's nothing to unlock, because we didn't
> > even get the write lock in the first place, so there's no broken state, it's as
> > if we failed at some other point right?
> >
> > So I don't see why we're special casing this _at all_.
>
> I want to avoid possible -EINTR code override with -EFAULT in the code below.
> walk_page_range() can return -EINVAL and any other error that
> ops->pte_hole or ops->test_walk might return. We might be fine
> treating all of them as -EFAULT but masking -EINTR seems wrong to me.
> I don't really know a better way to deal with this but if you have a
> good alternative I would really appreciate it.

As per Matthew we needn't worry, and in any case if we want to check for fatal
signal early exit we can do if (fatal_signal_pending(current)) {} I think?

>
> >
> > >
> > >       if (!qp.first)
> > >               /* whole range in hole */
> > > @@ -1309,9 +1311,14 @@ static long migrate_to_node(struct mm_struct *mm, int source, int dest,
> > >                                     flags | MPOL_MF_DISCONTIG_OK, &pagelist);
> > >       mmap_read_unlock(mm);
> >
> >
> > >
> > > +     if (nr_failed == -EINTR)
> > > +             err = nr_failed;
> >
> > Ugh please don't, that's REALLY horrible.
> >
> > Actually the only way you'd get a write lock happening in the walk_page_range()
> > is if flags & MPOL_MF_WRLOCK, menaing queue_pages_lock_vma_walk_ops are used
> > which specifies .walk_lock = PGWALK_WRLOCK.
> >
> > And this flag is only set in do_mbind(), not in migrate_to_node().
> >
> > So this check is actually totally unnecessary. You'll never get -EINTR here.
>
> Ah, good point. I'll drop this part.

Thanks!

>
> >
> > Maybe this code needs some refactoring though in general... yikes.
>
> Right.
>
> >
> > > +
> > >       if (!list_empty(&pagelist)) {
> > > -             err = migrate_pages(&pagelist, alloc_migration_target, NULL,
> > > -                     (unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL, NULL);
> > > +             if (!err)
> > > +                     err = migrate_pages(&pagelist, alloc_migration_target,
> > > +                                         NULL, (unsigned long)&mtc,
> > > +                                         MIGRATE_SYNC, MR_SYSCALL, NULL);
> >
> > Given the above, this is unnecessary too.
>
> Ack. Will drop.

Thanks!

>
> >
> > >               if (err)
> > >                       putback_movable_pages(&pagelist);
> > >       }
> > > @@ -1611,7 +1618,8 @@ static long do_mbind(unsigned long start, unsigned long len,
> > >                               MR_MEMPOLICY_MBIND, NULL);
> > >       }
> > >
> > > -     if (nr_failed && (flags & MPOL_MF_STRICT))
> > > +     /* Do not mask EINTR */
> >
> > Useless comment... You're not explaining why, and it's obvious what you're doing.
> >
> > > +     if ((err != -EINTR) && (nr_failed && (flags & MPOL_MF_STRICT)))
> >
> > Weird use of parens...
> >
> > And again why are we treating -EINTR in a special way?
>
> Ah, actually I don't think I need this here. If queue_pages_range()
> fails nr_failed gets reset to 0, so the original error won't be masked
> as -EIO. I'll drop this part.

Thanks!

>
> >
> > >               err = -EIO;
> > >       if (!list_empty(&pagelist))
> > >               putback_movable_pages(&pagelist);
> > > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > > index a94c401ab2cf..dc9f7a7709c6 100644
> > > --- a/mm/pagewalk.c
> > > +++ b/mm/pagewalk.c
> > > @@ -425,14 +425,13 @@ static inline void process_mm_walk_lock(struct mm_struct *mm,
> > >               mmap_assert_write_locked(mm);
> > >  }
> > >
> > > -static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> > > +static inline int process_vma_walk_lock(struct vm_area_struct *vma,
> > >                                        enum page_walk_lock walk_lock)
> > >  {
> > >  #ifdef CONFIG_PER_VMA_LOCK
> > >       switch (walk_lock) {
> > >       case PGWALK_WRLOCK:
> > > -             vma_start_write(vma);
> > > -             break;
> > > +             return vma_start_write_killable(vma);
> > >       case PGWALK_WRLOCK_VERIFY:
> > >               vma_assert_write_locked(vma);
> > >               break;
> > > @@ -444,6 +443,7 @@ static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> > >               break;
> > >       }
> > >  #endif
> > > +     return 0;
> > >  }
> > >
> > >  /*
> > > @@ -487,7 +487,9 @@ int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
> > >                       if (ops->pte_hole)
> > >                               err = ops->pte_hole(start, next, -1, &walk);
> > >               } else { /* inside vma */
> > > -                     process_vma_walk_lock(vma, ops->walk_lock);
> > > +                     err = process_vma_walk_lock(vma, ops->walk_lock);
> > > +                     if (err)
> > > +                             break;
> > >                       walk.vma = vma;
> > >                       next = min(end, vma->vm_end);
> > >                       vma = find_vma(mm, vma->vm_end);
> > > @@ -704,6 +706,7 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
> > >               .vma            = vma,
> > >               .private        = private,
> > >       };
> > > +     int err;
> > >
> > >       if (start >= end || !walk.mm)
> > >               return -EINVAL;
> > > @@ -711,7 +714,9 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
> > >               return -EINVAL;
> > >
> > >       process_mm_walk_lock(walk.mm, ops->walk_lock);
> > > -     process_vma_walk_lock(vma, ops->walk_lock);
> > > +     err = process_vma_walk_lock(vma, ops->walk_lock);
> > > +     if (err)
> > > +             return err;
> > >       return __walk_page_range(start, end, &walk);
> > >  }
> > >
> > > @@ -734,6 +739,7 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
> > >               .vma            = vma,
> > >               .private        = private,
> > >       };
> > > +     int err;
> > >
> > >       if (!walk.mm)
> > >               return -EINVAL;
> > > @@ -741,7 +747,9 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
> > >               return -EINVAL;
> > >
> > >       process_mm_walk_lock(walk.mm, ops->walk_lock);
> > > -     process_vma_walk_lock(vma, ops->walk_lock);
> > > +     err = process_vma_walk_lock(vma, ops->walk_lock);
> > > +     if (err)
> > > +             return err;
> > >       return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
> > >  }
> > >
> > > diff --git a/mm/vma.c b/mm/vma.c
> > > index 9f2664f1d078..46bbad6e64a4 100644
> > > --- a/mm/vma.c
> > > +++ b/mm/vma.c
> > > @@ -998,14 +998,18 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
> > >       if (anon_dup)
> > >               unlink_anon_vmas(anon_dup);
> > >
> > > -     /*
> > > -      * This means we have failed to clone anon_vma's correctly, but no
> > > -      * actual changes to VMAs have occurred, so no harm no foul - if the
> > > -      * user doesn't want this reported and instead just wants to give up on
> > > -      * the merge, allow it.
> > > -      */
> > > -     if (!vmg->give_up_on_oom)
> > > -             vmg->state = VMA_MERGE_ERROR_NOMEM;
> > > +     if (err == -EINTR) {
> > > +             vmg->state = VMA_MERGE_ERROR_INTR;
> >
> > Yeah this is incorrect. You seem adament in passing through -EINTR _no
> > matter what_ :)
>
> You got me figured out ;)
>
> >
> > There are callers that don't care at all if the merge failed, whether through
> > oom or VMA write lock not being acquired.
>
> Ah, I see. I was a bit puzzled by this vmg->give_up_on_oom flag. I
> think what you are saying is that errors from
> vma_merge_existing_range() are ignored unless this flag is set and
> even then the only possible error is ENOMEM.
>
> >
> > There's really no benefit in exiting early here I don't think, the subsequent
> > split will call vma_start_write_killable() anyway.
>
> But are we always calling split after the merge?

We wouldn't if start == vma->vm_start and end == vma->vm_end but that'd be a nop
anyway :) [in vma_modify(), the only caller].

>
> >
> > So I think this adds a lot of complexity and mess for nothing.
> >
> > So can we drop all this change to the merge logic please?
>
> Ok but is there a good reason for this unusual error handling logic in
> vma_merge_existing_range()?

It's specifically so we can indicate _why_ the merge didn't succeed, because the
function returns NULL. Is checked in vma_modify().

Better this way than an ERR_PTR().


>
> >
> > > +     } else {
> > > +             /*
> > > +              * This means we have failed to clone anon_vma's correctly,
> > > +              * but no actual changes to VMAs have occurred, so no harm no
> > > +              * foul - if the user doesn't want this reported and instead
> > > +              * just wants to give up on the merge, allow it.
> > > +              */
> > > +             if (!vmg->give_up_on_oom)
> > > +                     vmg->state = VMA_MERGE_ERROR_NOMEM;
> > > +     }
> > >       return NULL;
> > >  }
> > >
> > > @@ -1681,6 +1685,8 @@ static struct vm_area_struct *vma_modify(struct vma_merge_struct *vmg)
> > >       merged = vma_merge_existing_range(vmg);
> > >       if (merged)
> > >               return merged;
> > > +     if (vmg_intr(vmg))
> > > +             return ERR_PTR(-EINTR);
> > >       if (vmg_nomem(vmg))
> > >               return ERR_PTR(-ENOMEM);
> > >
> > > diff --git a/mm/vma.h b/mm/vma.h
> > > index eba388c61ef4..fe4560f81f4f 100644
> > > --- a/mm/vma.h
> > > +++ b/mm/vma.h
> > > @@ -56,6 +56,7 @@ struct vma_munmap_struct {
> > >  enum vma_merge_state {
> > >       VMA_MERGE_START,
> > >       VMA_MERGE_ERROR_NOMEM,
> > > +     VMA_MERGE_ERROR_INTR,
> > >       VMA_MERGE_NOMERGE,
> > >       VMA_MERGE_SUCCESS,
> > >  };
> > > @@ -226,6 +227,11 @@ static inline bool vmg_nomem(struct vma_merge_struct *vmg)
> > >       return vmg->state == VMA_MERGE_ERROR_NOMEM;
> > >  }
> > >
> > > +static inline bool vmg_intr(struct vma_merge_struct *vmg)
> > > +{
> > > +     return vmg->state == VMA_MERGE_ERROR_INTR;
> > > +}
> > > +
> > >  /* Assumes addr >= vma->vm_start. */
> > >  static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
> > >                                      unsigned long addr)
> > > --
> > > 2.53.0.414.gf7e9f6c205-goog
> > >
> >

Cheers, Lorenzo

