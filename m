Return-Path: <kvm+bounces-71188-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0GNCKp3XlGkgIQIAu9opvQ
	(envelope-from <kvm+bounces-71188-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 22:03:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 28435150915
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 22:03:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CFB893023DF1
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4593783DE;
	Tue, 17 Feb 2026 21:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GqYF/ltg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8E625D1E9
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 21:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771362184; cv=pass; b=S5T8Jo+ZM4/x60YJMVCCHjhUxAO0ZrzEamUCisyuo8tADyaM0eoUqa3JV55EJsdndy4GV0/QunOhNSsr9DDmMp3Al0OPnxYhLKKDele4dQw9rvwzTB/Dj+ybNOf9FlodQJ38jmpedS/s50GmryfOGF2wibOYccZCHmQFVk3xb2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771362184; c=relaxed/simple;
	bh=vGTuZZMEtyg7nu5bmzFC4/6gBVZeVwYi2WDUEiFHq58=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=IWW14CdVr3wYD//tQjw70GMTJaJD8gcQJSsTBnIra9DHYsNN39lhV2OzsBMh/5cui7wYK5sDfmqP+X0pQKL02xNBJH4ppQfVKoIgM9md86586ah5n2k8bw1kitN6Kg6J6I/hWipmn0X/i2QREw1K9HtlqYyzkz+WoN5IKOauGq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GqYF/ltg; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-505d3baf1a7so33141cf.1
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 13:03:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771362181; cv=none;
        d=google.com; s=arc-20240605;
        b=fkVgHQLuBpAEtR7KUf4+2EuqKftmDOe7ubFlKJEx7+9DbBJSD3C5fT9JHx5SSY1EQH
         eHm2N1S0XDrl8VU2/oZt0T7craxu+zKofKnRMT7pBfvxt9OpZ6r81fOQH00QJj15MZkg
         DNSOVLXh9n5+hnZxS+C8lWoglQdwh+XSyvIJUMat6q3q8SPuj3c02x2IHRrWaofISD93
         g0xmA8Bu00WlFmF+TLUsE3arRkzeLioWBQ2N2bAjnWyf554+l1+/csykQph2uqmvLOa0
         cA4rfy6FRy0Y2ce0JZJVRhoVp1nphQx5cSJU5gDX5ulH39RWvnlbujwe824d3yzV34LT
         YuPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Qg7unfpae37+olsmr8ztHQ2bOQfrmh4+RuxK8GGnbgk=;
        fh=N+Ss3BaB4XeoeQHWtc/esNJ3O8pRc9/T5jeALNW2PNQ=;
        b=Gcyjn16Hrl+hnDfNThaDCsuwxx3vShERB3nNiiwSfLJ+UcdqCjOj+XWa3R6la21iPI
         3U784mrGTptXfEFmwutro5dejz26adKdmdTzrq8wmoplcIKx8ry5FUF3kVPcR2XxBCdB
         KNGyrxRwJqJOh+oKOtTSPqVjf0S0GEhM2M3fm0bVWOsX24K6UEY9N8usZJzfJ57soT/k
         GGUrcVqzZIUQkOpkSHe6O4uerJf9yfrmN2m0WA9JeQ/G9ZAQak+/1Cb2l39UDi8rGhyJ
         i6LGAOwV1sjntfnbuMDD4n5KOfJYdTbMo0DaN87UGUZ5bWu7rg/qLm2+hQlpjfrruOJI
         kCzw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771362181; x=1771966981; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qg7unfpae37+olsmr8ztHQ2bOQfrmh4+RuxK8GGnbgk=;
        b=GqYF/ltgoGtn/XGc4ESxXq3rNmfu49xfW+Vc1x0hwczUe4vH/iXTvunbTbyspgpHbA
         mdlNz0b7G20+39krPw9XRf+rowYNQTDcXR/+wvqiSiZl6NAj/GhKkntQUOaLTAkyo+gQ
         SHIBJcOSX+ib/0tHiF/IYX2Ts/xIHRsNyVSppHy2faKUhylQXpoJdriQ1miIgCkMn+jw
         mlCJBE/tBwWuYHUUteYGuDFSQijBLjW1b9WFlbWCIcJAqenlaiPbGdyzbzHypQ2aErui
         a5FbtkVvYFjLRh0ONGIMg9H+YP4qmcEfGnn9xVd6riXJmO3BPGX/qpqviEtk2RnqQkmK
         BVmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771362181; x=1771966981;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qg7unfpae37+olsmr8ztHQ2bOQfrmh4+RuxK8GGnbgk=;
        b=p3pujgkznKmwFagczN9FS4bP0dEs7QC9Fs/q+IM+l6HuIC6OttuiFptzHO/2dl9+VV
         tDUSdVFo9RfvVBPmcS/cvL7jLX/GL2pYLBV4QeQwvKrjXs54OVm2pEZkNuZ6HUp7x+iw
         USw4gUw4R55td+5tJjrB9dJfi+8TdhqTIZJ7LS28gtHDvpIg2e8tIrih2pvOMjW323V/
         zjboONX6p5P+U/KnjWkvzVqUdtW+78FIbWREDqp8IXu2+1VVAFG9PIQqlHKXGillPd+C
         wLCgg2tTGA7sFcAp4dgU/M/cqFknosqSPicoRL8fb6QZq3/KFnNCz91r3UWsGONZlXET
         C+pw==
X-Forwarded-Encrypted: i=1; AJvYcCWmgm++UDnwZxa4+WRapQdx15BCjXh+kR3Ic1JyWtCm0JUdCNCkvuA0N7Pv8Jxm9qcWCB8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHT5jFQlm95RTwaC7jmpvPvbuCPynWpqn93BBJnCpxWdoNnqwN
	HVk6DqxC5g68zpZG3Cn5LkhCX8jcCeNiNZrsyEFBAQC8nxsZ3++w1Ohpa5s2LVDXzMm3XH6RWEY
	YT5Iy02cIW2raEz+y7SvkusOQ6z8Cx87xtP0CN6CC
X-Gm-Gg: AZuq6aIjyH4WsuNuppI7EY0+eLFSdXFVX7xFOZSHnWf+BDMUpwaizrcez0yxFBCI4zk
	LzGIABlj95BT9vXANQE+B2OYR92B2WTi2SkYeNS3QN7zmMdWqSv1bObybBARM8Itc/9Ej1omwEx
	M74k/YmlWYR98k9PF0g9aJ0PIC8UzgBOiQVH2ZLqAsSgbbH0H0jGnt2wFz08F3rqgKpZXKaACTr
	Y+NHI0m+Fv2it/k4JT7XQPSvpMV0Mqa6Y2Oc8zZthNH8hUcbiZdJ5rasImVX2NjJimQZLErBZbb
	qpmxA+jK4IHjcGQ27L2JTm1z+gwF1UTKEoRCXg==
X-Received: by 2002:a05:622a:8c15:b0:4ed:ff79:e679 with SMTP id
 d75a77b69052e-506cdb80f2fmr23179661cf.19.1771362180478; Tue, 17 Feb 2026
 13:03:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260217163250.2326001-1-surenb@google.com> <20260217163250.2326001-3-surenb@google.com>
 <dtdfrko7uqif6flc4mefnlar7wnmrbyswfu7bvb2ar24gkeejo@ypzhmyklbeh7>
In-Reply-To: <dtdfrko7uqif6flc4mefnlar7wnmrbyswfu7bvb2ar24gkeejo@ypzhmyklbeh7>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 17 Feb 2026 13:02:48 -0800
X-Gm-Features: AaiRm52hFtG7L6yJLkbXYH1SBTkTSuw2iS_25yQRkmcsbZ2JjkS2e-zgf6Q_wu8
Message-ID: <CAJuCfpGViU4dDaLtPR8U0C+=FXO=1TuU-hT3fypNQO3LGOjbcA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm: replace vma_start_write() with vma_start_write_killable()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[oracle.com,google.com,linux-foundation.org,infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,redhat.com,arm.com,linux.dev,suse.cz,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71188-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[google.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:email,oracle.com:email,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 28435150915
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 11:19=E2=80=AFAM Liam R. Howlett
<Liam.Howlett@oracle.com> wrote:
>
> * Suren Baghdasaryan <surenb@google.com> [260217 11:33]:
> > Now that we have vma_start_write_killable() we can replace most of the
> > vma_start_write() calls with it, improving reaction time to the kill
> > signal.
> >
> > There are several places which are left untouched by this patch:
> >
> > 1. free_pgtables() because function should free page tables even if a
> > fatal signal is pending.
> >
> > 2. process_vma_walk_lock(), which requires changes in its callers and
> > will be handled in the next patch.
> >
> > 3. userfaultd code, where some paths calling vma_start_write() can
> > handle EINTR and some can't without a deeper code refactoring.
> >
> > 4. vm_flags_{set|mod|clear} require refactoring that involves moving
> > vma_start_write() out of these functions and replacing it with
> > vma_assert_write_locked(), then callers of these functions should
> > lock the vma themselves using vma_start_write_killable() whenever
> > possible.
> >
> > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com> # powerpc
> > ---
> >  arch/powerpc/kvm/book3s_hv_uvmem.c |  5 +-
> >  include/linux/mempolicy.h          |  5 +-
> >  mm/khugepaged.c                    |  5 +-
> >  mm/madvise.c                       |  4 +-
> >  mm/memory.c                        |  2 +
> >  mm/mempolicy.c                     | 23 ++++++--
> >  mm/mlock.c                         | 20 +++++--
> >  mm/mprotect.c                      |  4 +-
> >  mm/mremap.c                        |  4 +-
> >  mm/vma.c                           | 93 +++++++++++++++++++++---------
> >  mm/vma_exec.c                      |  6 +-
> >  11 files changed, 123 insertions(+), 48 deletions(-)
> >
>
> ...
>
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
>
> ...
>
> >
> >  static const struct mempolicy_operations mpol_ops[MPOL_MAX] =3D {
> > @@ -1785,9 +1793,15 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigne=
d long, start, unsigned long, le
> >               return -EINVAL;
> >       if (end =3D=3D start)
> >               return 0;
> > -     mmap_write_lock(mm);
> > +     if (mmap_write_lock_killable(mm))
> > +             return -EINTR;
> >       prev =3D vma_prev(&vmi);
> >       for_each_vma_range(vmi, vma, end) {
> > +             if (vma_start_write_killable(vma)) {
> > +                     err =3D -EINTR;
> > +                     break;
> > +             }
> > +
> >               /*
> >                * If any vma in the range got policy other than MPOL_BIN=
D
> >                * or MPOL_PREFERRED_MANY we return error. We don't reset
> > @@ -1808,7 +1822,6 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned=
 long, start, unsigned long, le
> >                       break;
> >               }
> >
> > -             vma_start_write(vma);
>
> Moving this vma_start_write() up means we will lock all vmas in the
> range regardless of if they are going to change.  Was that your
> intention?

No, I missed that this would result in unnecessary locks.

>
> It might be better to move the locking to later in the loop, prior to
> the mpol_dup(), but after skipping other vmas?

Yes, that's the right place for it. Will move.

>
> >               new->home_node =3D home_node;
> >               err =3D mbind_range(&vmi, vma, &prev, start, end, new);
>
> ...
>
> > diff --git a/mm/vma.c b/mm/vma.c
> > index bb4d0326fecb..1d21351282cf 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
>
> ...
>
> > @@ -2532,6 +2556,11 @@ static int __mmap_new_vma(struct mmap_state *map=
, struct vm_area_struct **vmap)
> >               goto free_vma;
> >       }
> >
> > +     /* Lock the VMA since it is modified after insertion into VMA tre=
e */
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error)
> > +             goto free_iter_vma;
> > +
> >       if (map->file)
> >               error =3D __mmap_new_file_vma(map, vma);
> >       else if (map->vm_flags & VM_SHARED)
> > @@ -2552,8 +2581,6 @@ static int __mmap_new_vma(struct mmap_state *map,=
 struct vm_area_struct **vmap)
> >       WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
> >  #endif
> >
> > -     /* Lock the VMA since it is modified after insertion into VMA tre=
e */
> > -     vma_start_write(vma);
> >       vma_iter_store_new(vmi, vma);
> >       map->mm->map_count++;
> >       vma_link_file(vma, map->hold_file_rmap_lock);
>
> This is a bit of a nit on the placement..
>
> Prior to this change, the write lock on the vma was taken next to where
> it was inserted in the tree.  Now the lock is taken between vma iterator
> preallocations and part of the vma setup.
>
> Would it make sense to put it closer to the vma allocation itself?  I
> think all that's needed to be set is the mm struct for the locking to
> work?

I guess locking the vma before vma_iter_prealloc() would save us
unnecessary alloc/free in case of a pending fatal signal. I'll move
the lock right after vm_area_alloc() so that the entire vma setup is
done on a locked vma.

>
>
> ...
>
> > @@ -3089,7 +3120,7 @@ int expand_upwards(struct vm_area_struct *vma, un=
signed long address)
>
> Good luck testing this one.

Yeah... Any suggestions for tests I should use?

>
> >       struct mm_struct *mm =3D vma->vm_mm;
> >       struct vm_area_struct *next;
> >       unsigned long gap_addr;
> > -     int error =3D 0;
> > +     int error;
> >       VMA_ITERATOR(vmi, mm, vma->vm_start);
> >
> >       if (!(vma->vm_flags & VM_GROWSUP))
> > @@ -3126,12 +3157,14 @@ int expand_upwards(struct vm_area_struct *vma, =
unsigned long address)
> >
> >       /* We must make sure the anon_vma is allocated. */
> >       if (unlikely(anon_vma_prepare(vma))) {
> > -             vma_iter_free(&vmi);
> > -             return -ENOMEM;
> > +             error =3D -ENOMEM;
> > +             goto free;
> >       }
> >
> >       /* Lock the VMA before expanding to prevent concurrent page fault=
s */
> > -     vma_start_write(vma);
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error)
> > +             goto free;
> >       /* We update the anon VMA tree. */
> >       anon_vma_lock_write(vma->anon_vma);
> >
> > @@ -3160,6 +3193,7 @@ int expand_upwards(struct vm_area_struct *vma, un=
signed long address)
> >               }
> >       }
> >       anon_vma_unlock_write(vma->anon_vma);
> > +free:
> >       vma_iter_free(&vmi);
> >       validate_mm(mm);
> >       return error;
>
> Looks okay.

Thanks for the review, Liam! I'll wait a couple of days and post the
v3 with fixes.

>
> ...
>
>
>

