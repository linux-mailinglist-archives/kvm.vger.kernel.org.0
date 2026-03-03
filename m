Return-Path: <kvm+bounces-72615-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YJcsNq5cp2lBhAAAu9opvQ
	(envelope-from <kvm+bounces-72615-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 23:11:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 78B351F7E20
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 23:11:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 27B0230AD88F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 22:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC4E13932C1;
	Tue,  3 Mar 2026 22:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PYTU+uL9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F39386C09
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 22:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772575907; cv=pass; b=sE3NlREoMgQdO/zIMBrrKZmZWLRQhWVon19Y/fLvN269BzT1YK7lm47/IBOUZh/UmU0lhngC87oxGlqrr0R0KQO5SqNviNJZNna5A0fR9W6M7e8P6k81PEfzhSlFYZ9ko/BpJjJyPssoJmQP66DN5JUSABtLd71yShTlyyGaVrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772575907; c=relaxed/simple;
	bh=90V/157hEoiLn/YFuwsvngw3LEZGLAZdrTLVDlVHEDw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qZu7ZfhiZfq1E3tLz4UNXfXm0vdXpTtE23GQW3KBYYTE595Thunp8e7qUt7pTUEE0Bp6bWpT3f1skPZFuqgRaLWO7PZ07pVzZkuf9ei35fG4fdaTyIhfOkQHMkhTmn8V2GZKEcFFew9lZybxBeyaFngasaEjqeNSw8ez0M5I/rM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PYTU+uL9; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-505d3baf1a7so685811cf.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 14:11:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772575904; cv=none;
        d=google.com; s=arc-20240605;
        b=ka8ZPHxEZaTcXSnNMZxcNOQc0NPp0kKOLHNQT7KFYuQu8IRYIl6KXoYotgCtwh2iL3
         ZHsRPAldvGEYTLACj47VIEx4yNCq5hvQWKzSq8gtcPZw1513TLjeTA4C1FkkPSEcfv3O
         2004Ou4ZhnIRwBnd3tgcNEtsntVUvyJKWpvRQFkfXtSlqgMCp6hz3sdtsm+1K6nZQJA0
         xO2OapqXE39Uoc8im1OABVNb6atGqnwKPSb2UmgPTJpZ8LPrXzt4jJamoE+fkFyJYGsf
         boPzLdqJB3rn+J6xlh9yK2T5IWa+EIJhr42gb1nwZatL2l2g8pRYaS6PWYv7F4bETVrr
         rb4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yeMbGAwWny5te0R5lxckOgcICv/7rim25Dh0RTq8uiY=;
        fh=zMD32I1FUL21rl/n51QeiRWjTRAn6OOyY6HwypNQRuA=;
        b=GH9G39mw/uD2/kh2f1aUHXwJ5KvMlGf+Gu4lP2EJLQ0FEAPRhNhjAuA3NGdvOXtDYf
         GBISP+3E6iBP8vacGovC/J6wGYEdttjIYcnY2GRYuEdx5DzzMcK+OkN3U3stB8fZoVtm
         NpgIqkvhi6irY9rLfBgzT0ZCC7y1lRlPluf7zgEpACPzaW6nUpVWpSvAVftrm1GuYUdh
         ffy5OFyTJ8uCXoIAOqH2CCBL4tSj2JtOWstR5dPv5tXJBz+0hvVqQc41GHKCP4RQmbrC
         l1GoYnIDU/KLRO5WZfy6UixgwJJnB4eZ2lU7MH6Wmkto/W8H4XX1ro8nfl/gm0ul6Sno
         4Vzw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772575904; x=1773180704; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yeMbGAwWny5te0R5lxckOgcICv/7rim25Dh0RTq8uiY=;
        b=PYTU+uL9EWKSh+VtCCM/DONed5Bf9MSR4T6U9DX6HFSXmwpnu8EYVJcIw16m1loPxv
         5lxCCm0UiMXNU/zWN8LU59khj7ZRPyPaIdNRA2+ZPy8GY/bjzFUN75SqjCuEMhP+pDV4
         WxpWMuV/SUczH86L9e6LjYxApfQvFcD/5Q4wfPKuSjsfYQy4NpTHZkn6IuEfe0KBesPD
         Bz+/P4QqPzvUSvBs6whtsYngWYql9ZRVSJ+NG0JRqxnJesJyKXwCZSdOcWBzStFdNxgb
         zC/8/Zb0HmZsLUXO43v0QkSm8AvIgxLymZqr5KQDhcVqarlIBqCVW0XUwtXe3xWuWxcF
         kXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772575904; x=1773180704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yeMbGAwWny5te0R5lxckOgcICv/7rim25Dh0RTq8uiY=;
        b=rtJWe0BMWKJI4HtEP5J/vaIiPYUdDdKAQ3lT5/f4j4glu+2Akj8jNg9BMFAw6OCwN1
         EdXQKH3T6SnODRGVDoao4OB0xPGOgwx0yearNkvlVZ7FZ/H/K1eWS4r1n7gklSgwo0VW
         BFCDW+h/G8dELOQWvCfcQ5nX1MoBILgM8/pP3xbX8rZ6B5bPfaFpv4jvTRabRefDmoB+
         5a4rjIOU9TPcwjMMU/gIYw/qGjuBzoQQUdLH60MxHqHznkBlauqV3+Y8yRc8D4y26bvz
         SktuFBu5lWTtLJvX9TEVocJW4vULW9+eDOKqs/p5gC5pVz82hiAQ+y3r7zTi4Umv7lqF
         V5vQ==
X-Forwarded-Encrypted: i=1; AJvYcCUd36fEfnvUdA15l2NDvL5aXRP6KpCTA6O7+MJq1b+WjjVay7dBZ7AVGusWCZ8hV722q6E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIKTMcitL+iCzLKciIeaLpu1v4FsRzYM513Ijti0HFyYwLSjL7
	mUBDwMvy9TPz9Omcwv+wJnMVg3Q4LH43G4H2STDdiJFlOXkMc+tiyrkpeCaPMLzLxk6kXmwSs/C
	x2p/ueGNxHmYjFrPXaCL5MPnwJrWDBlmjgaupO+yr
X-Gm-Gg: ATEYQzzzB+pqCyrPn2l0NVrdO10nXg9KrCmwxTqlli264UWw+unEEMbPYIcBfE5O0cT
	vKmdbk8hqnGI1GPhqdnONLbU16WruCDp6WnrJqlnv/8NySEyturExK4hzAPUBPOkz6janURg9EY
	jkCnQ+VsaIC1IU4YC/PhUEaP0XpAkRc8j6b5QHTiuiwkovbt/4LDGziSaUeur+KcQwja7T1/w3L
	t1HBMvcUs2YMnfOVEbCs6i1VBftZs+PPLCisSpcbxmmmG57Xc8hhT9U89PwYNO937EkpYTWoG9S
	3i5bBhYQilxzIu4tT07lazx+UMd1RAzm4z4E
X-Received: by 2002:ac8:5995:0:b0:4ff:cb72:7c03 with SMTP id
 d75a77b69052e-507617532dcmr42643221cf.3.1772575902807; Tue, 03 Mar 2026
 14:11:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com> <20260226070609.3072570-3-surenb@google.com>
 <74bffc7a-2b8c-40ae-ab02-cd0ced082e18@lucifer.local>
In-Reply-To: <74bffc7a-2b8c-40ae-ab02-cd0ced082e18@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 3 Mar 2026 14:11:31 -0800
X-Gm-Features: AaiRm52GeRuktmb3a-F5qHS-ApbVylv6oemncyiCCOu1fQ0E748xv9AEAopTYJI
Message-ID: <CAJuCfpHBfhKFeWAtQo4r-ofVtO=5MvG+OToEgc2DEY+cuZDSGw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: replace vma_start_write() with vma_start_write_killable()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 78B351F7E20
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72615-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[43];
	FREEMAIL_CC(0.00)[linux-foundation.org,infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,oracle.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vmg.target:url,infradead.org:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid,oracle.com:email]
X-Rspamd-Action: no action

On Mon, Mar 2, 2026 at 6:53=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Feb 25, 2026 at 11:06:08PM -0800, Suren Baghdasaryan wrote:
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
>
> Surprise surprise :))
>
> >
> > 4. mpol_rebind_mm() which is used by cpusset controller for migrations
>
> Incredibly nitty but cpusset -> cpuset?

Ack.

>
> > and operates on a remote mm. Incomplete operations here would result
> > in an inconsistent cgroup state.
> >
> > 5. vm_flags_{set|mod|clear} require refactoring that involves moving
> > vma_start_write() out of these functions and replacing it with
> > vma_assert_write_locked(), then callers of these functions should
> > lock the vma themselves using vma_start_write_killable() whenever
> > possible.
>
> This should be dealt with by my ongoing mmap_prepare, vma flags work.

That would be great! It makes it much simpler once you are done with
that refactoring.

>
> >
> > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com> # powerpc
>
> Overall I'm a little concerned about whether callers can handle -EINTR in=
 all
> cases, have you checked? Might we cause some weirdness in userspace if a =
syscall
> suddenly returns -EINTR when before it didn't?

I did check the kernel users and put the patchset through AI reviews.
I haven't checked if any of the affected syscalls do not advertise
-EINTR as a possible error. Adding that to my todo list for the next
respin.

>
> Also maybe we should update the manpages to reflect this, as semi-usless =
as the
> 'possible error codes' sections are...

Ok, I'll check which syscalls need to be updated and will note that in
cover letter. Once the patchset is accepted I'll update the manpages
for them.

>
> > ---
> >  arch/powerpc/kvm/book3s_hv_uvmem.c |  5 +-
> >  mm/khugepaged.c                    |  5 +-
> >  mm/madvise.c                       |  4 +-
> >  mm/memory.c                        |  2 +
> >  mm/mempolicy.c                     |  8 ++-
> >  mm/mlock.c                         | 21 +++++--
> >  mm/mprotect.c                      |  4 +-
> >  mm/mremap.c                        |  4 +-
> >  mm/vma.c                           | 93 +++++++++++++++++++++---------
> >  mm/vma_exec.c                      |  6 +-
> >  10 files changed, 109 insertions(+), 43 deletions(-)
> >
> > diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book=
3s_hv_uvmem.c
> > index 5fbb95d90e99..0a28b48a46b8 100644
> > --- a/arch/powerpc/kvm/book3s_hv_uvmem.c
> > +++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
> > @@ -410,7 +410,10 @@ static int kvmppc_memslot_page_merge(struct kvm *k=
vm,
> >                       ret =3D H_STATE;
> >                       break;
> >               }
> > -             vma_start_write(vma);
> > +             if (vma_start_write_killable(vma)) {
> > +                     ret =3D H_STATE;
> > +                     break;
> > +             }
> >               /* Copy vm_flags to avoid partial modifications in ksm_ma=
dvise */
> >               vm_flags =3D vma->vm_flags;
> >               ret =3D ksm_madvise(vma, vma->vm_start, vma->vm_end,
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 1dd3cfca610d..6c92e31ee5fb 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1141,7 +1141,10 @@ static enum scan_result collapse_huge_page(struc=
t mm_struct *mm, unsigned long a
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_up_write;
> >       /* check if the pmd is still valid */
> > -     vma_start_write(vma);
> > +     if (vma_start_write_killable(vma)) {
> > +             result =3D SCAN_FAIL;
> > +             goto out_up_write;
> > +     }
> >       result =3D check_pmd_still_valid(mm, address, pmd);
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_up_write;
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index c0370d9b4e23..ccdaea6b3b15 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -173,7 +173,9 @@ static int madvise_update_vma(vm_flags_t new_flags,
> >       madv_behavior->vma =3D vma;
> >
> >       /* vm_flags is protected by the mmap_lock held in write mode. */
> > -     vma_start_write(vma);
> > +     if (vma_start_write_killable(vma))
> > +             return -EINTR;
> > +
> >       vm_flags_reset(vma, new_flags);
> >       if (set_new_anon_name)
> >               return replace_anon_vma_name(vma, anon_name);
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 07778814b4a8..691062154cf5 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -379,6 +379,8 @@ void free_pgd_range(struct mmu_gather *tlb,
> >   * page tables that should be removed.  This can differ from the vma m=
appings on
> >   * some archs that may have mappings that need to be removed outside t=
he vmas.
> >   * Note that the prev->vm_end and next->vm_start are often used.
> > + * We don't use vma_start_write_killable() because page tables should =
be freed
> > + * even if the task is being killed.
> >   *
> >   * The vma_end differs from the pg_end when a dup_mmap() failed and th=
e tree has
> >   * unrelated data to the mm_struct being torn down.
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 0e5175f1c767..90939f5bde02 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -1784,7 +1784,8 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned=
 long, start, unsigned long, le
> >               return -EINVAL;
> >       if (end =3D=3D start)
> >               return 0;
> > -     mmap_write_lock(mm);
> > +     if (mmap_write_lock_killable(mm))
> > +             return -EINTR;
>
> Hmm mmap write lock as well now :) I guess it makes sense here, esp given=
 mmap
> write lock part of VMA write lock.

Yeah, I thought while we are at it we can make this part a bit better too..=
.

>
>
> >       prev =3D vma_prev(&vmi);
> >       for_each_vma_range(vmi, vma, end) {
> >               /*
> > @@ -1801,13 +1802,16 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsign=
ed long, start, unsigned long, le
> >                       err =3D -EOPNOTSUPP;
> >                       break;
> >               }
> > +             if (vma_start_write_killable(vma)) {
> > +                     err =3D -EINTR;
> > +                     break;
> > +             }
> >               new =3D mpol_dup(old);
> >               if (IS_ERR(new)) {
> >                       err =3D PTR_ERR(new);
> >                       break;
> >               }
> >
> > -             vma_start_write(vma);
>
> Are we ok with moving this to before mpol_dup()? Does this matter? Confus=
ed as
> to why you moved this up?

I thought if locking fails, it would be better to check that earlier
before allocating a new mempolicy. That seems to be safe, but thinking
about this now, if allocation goes into direct reclaim and causes the
lock to be held for longer then that might not be such a hot idea...

>
> >               new->home_node =3D home_node;
> >               err =3D mbind_range(&vmi, vma, &prev, start, end, new);
> >               mpol_put(new);
> > diff --git a/mm/mlock.c b/mm/mlock.c
> > index 2f699c3497a5..c562c77c3ee0 100644
> > --- a/mm/mlock.c
> > +++ b/mm/mlock.c
> > @@ -420,7 +420,7 @@ static int mlock_pte_range(pmd_t *pmd, unsigned lon=
g addr,
> >   * Called for mlock(), mlock2() and mlockall(), to set @vma VM_LOCKED;
> >   * called for munlock() and munlockall(), to clear VM_LOCKED from @vma=
.
> >   */
>
> You should update the comment to reflect this possible return value.

Ack.

>
> > -static void mlock_vma_pages_range(struct vm_area_struct *vma,
> > +static int mlock_vma_pages_range(struct vm_area_struct *vma,
> >       unsigned long start, unsigned long end, vm_flags_t newflags)
> >  {
> >       static const struct mm_walk_ops mlock_walk_ops =3D {
> > @@ -441,7 +441,9 @@ static void mlock_vma_pages_range(struct vm_area_st=
ruct *vma,
> >        */
> >       if (newflags & VM_LOCKED)
> >               newflags |=3D VM_IO;
> > -     vma_start_write(vma);
> > +     if (vma_start_write_killable(vma))
> > +             return -EINTR;
> > +
> >       vm_flags_reset_once(vma, newflags);
> >
> >       lru_add_drain();
> > @@ -452,6 +454,7 @@ static void mlock_vma_pages_range(struct vm_area_st=
ruct *vma,
> >               newflags &=3D ~VM_IO;
> >               vm_flags_reset_once(vma, newflags);
> >       }
> > +     return 0;
> >  }
> >
> >  /*
> > @@ -501,10 +504,12 @@ static int mlock_fixup(struct vma_iterator *vmi, =
struct vm_area_struct *vma,
> >        */
> >       if ((newflags & VM_LOCKED) && (oldflags & VM_LOCKED)) {
> >               /* No work to do, and mlocking twice would be wrong */
>
> I'd move this comment down to the vm_flags_reset() line as it's not appli=
cable
> if we fail to get the lock.

Ack.

>
>
> > -             vma_start_write(vma);
> > +             ret =3D vma_start_write_killable(vma);
> > +             if (ret)
> > +                     goto out;
> >               vm_flags_reset(vma, newflags);
> >       } else {
> > -             mlock_vma_pages_range(vma, start, end, newflags);
> > +             ret =3D mlock_vma_pages_range(vma, start, end, newflags);
> >       }
> >  out:
> >       *prev =3D vma;
> > @@ -733,9 +738,13 @@ static int apply_mlockall_flags(int flags)
> >
> >               error =3D mlock_fixup(&vmi, vma, &prev, vma->vm_start, vm=
a->vm_end,
> >                                   newflags);
> > -             /* Ignore errors, but prev needs fixing up. */
> > -             if (error)
> > +             /* Ignore errors except EINTR, but prev needs fixing up. =
*/
>
> Well, except you're not fixing it up on -EINTR? This comment should be re=
done.

Hmm, should we fixup if the process is terminating? Does it matter at
this point?

>
> But I wonder if this is correct? We are ignoring all other errors that
> interrupted the operation, so why are we special casing -EINTR?

Well, -EINTR means all the work you are doing here is useless because
the process is about to go away. So, in that respect I think it's
different from other errors.

>
> > +             if (error) {
> > +                     if (error =3D=3D -EINTR)
> > +                             return error;
> > +
> >                       prev =3D vma;
> > +             }
> >               cond_resched();
> >       }
> >  out:
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index c0571445bef7..49dbb7156936 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -765,7 +765,9 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu=
_gather *tlb,
> >        * vm_flags and vm_page_prot are protected by the mmap_lock
> >        * held in write mode.
> >        */
> > -     vma_start_write(vma);
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error < 0)
>
> Weird inconstency here, this should be if (error).

Ack.

>
> > +             goto fail;
> >       vm_flags_reset_once(vma, newflags);
> >       if (vma_wants_manual_pte_write_upgrade(vma))
> >               mm_cp_flags |=3D MM_CP_TRY_CHANGE_WRITABLE;
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index 2be876a70cc0..aef1e5f373c7 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -1286,7 +1286,9 @@ static unsigned long move_vma(struct vma_remap_st=
ruct *vrm)
> >               return -ENOMEM;
> >
> >       /* We don't want racing faults. */
> > -     vma_start_write(vrm->vma);
> > +     err =3D vma_start_write_killable(vrm->vma);
> > +     if (err)
> > +             return err;
> >
> >       /* Perform copy step. */
> >       err =3D copy_vma_and_data(vrm, &new_vma);
> > diff --git a/mm/vma.c b/mm/vma.c
> > index bb4d0326fecb..9f2664f1d078 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -530,6 +530,13 @@ __split_vma(struct vma_iterator *vmi, struct vm_ar=
ea_struct *vma,
> >       if (err)
> >               goto out_free_vmi;
> >
> > +     err =3D vma_start_write_killable(vma);
> > +     if (err)
> > +             goto out_free_mpol;
> > +     err =3D vma_start_write_killable(new);
> > +     if (err)
> > +             goto out_free_mpol;
> > +
> >       err =3D anon_vma_clone(new, vma, VMA_OP_SPLIT);
> >       if (err)
> >               goto out_free_mpol;
> > @@ -540,9 +547,6 @@ __split_vma(struct vma_iterator *vmi, struct vm_are=
a_struct *vma,
> >       if (new->vm_ops && new->vm_ops->open)
> >               new->vm_ops->open(new);
> >
> > -     vma_start_write(vma);
> > -     vma_start_write(new);
> > -
>
> Again you're changing ordering seemingly arbitrarily.

I moved it up to avoid undoing all the work above (vm_ops->open,
vma_dup_policy, vma_iter_prealloc, vm_area_dup,..)

> I think this is actually a
> more problematic case as you're now invoking vm_ops->open() with a VMA wr=
ite
> lock held.

Are you concerned about potential increased duration of the vma lock
being held or that open() might try to take that lock itself (which is
not a problem because vma write locks are reentrant)? Maybe some other
concern I'm missing?

>
> So I think you should keep the existing position.

If we do that then we would have to undo a bunch of operations. I'm
fine adding that if there are reasons to avoid this move.

>
> >       init_vma_prep(&vp, vma);
> >       vp.insert =3D new;
> >       vma_prepare(&vp);
> > @@ -895,16 +899,22 @@ static __must_check struct vm_area_struct *vma_me=
rge_existing_range(
> >       }
> >
> >       /* No matter what happens, we will be adjusting middle. */
> > -     vma_start_write(middle);
> > +     err =3D vma_start_write_killable(middle);
> > +     if (err)
> > +             goto abort;
> >
> >       if (merge_right) {
> > -             vma_start_write(next);
> > +             err =3D vma_start_write_killable(next);
> > +             if (err)
> > +                     goto abort;
> >               vmg->target =3D next;
> >               sticky_flags |=3D (next->vm_flags & VM_STICKY);
> >       }
> >
> >       if (merge_left) {
> > -             vma_start_write(prev);
> > +             err =3D vma_start_write_killable(prev);
> > +             if (err)
> > +                     goto abort;
> >               vmg->target =3D prev;
> >               sticky_flags |=3D (prev->vm_flags & VM_STICKY);
> >       }
> > @@ -1155,10 +1165,12 @@ int vma_expand(struct vma_merge_struct *vmg)
> >       struct vm_area_struct *next =3D vmg->next;
> >       bool remove_next =3D false;
> >       vm_flags_t sticky_flags;
> > -     int ret =3D 0;
> > +     int ret;
> >
> >       mmap_assert_write_locked(vmg->mm);
> > -     vma_start_write(target);
> > +     ret =3D vma_start_write_killable(target);
> > +     if (ret)
> > +             return ret;
> >
> >       if (next && target !=3D next && vmg->end =3D=3D next->vm_end)
> >               remove_next =3D true;
> > @@ -1187,6 +1199,9 @@ int vma_expand(struct vma_merge_struct *vmg)
> >        * we don't need to account for vmg->give_up_on_mm here.
> >        */
> >       if (remove_next) {
> > +             ret =3D vma_start_write_killable(next);
> > +             if (ret)
> > +                     return ret;
> >               ret =3D dup_anon_vma(target, next, &anon_dup);
> >               if (ret)
> >                       return ret;
> > @@ -1197,10 +1212,8 @@ int vma_expand(struct vma_merge_struct *vmg)
> >                       return ret;
> >       }
> >
> > -     if (remove_next) {
> > -             vma_start_write(next);
> > +     if (remove_next)
> >               vmg->__remove_next =3D true;
> > -     }
>
> Hmm you're moving the ordering of things around again :) You should have =
made
> this change as part of patch 1 anyway first so this patch wouldn't have a
> refactoring in it too.
>
> Top of rmap.c suggests you _can_ take the VMA write lock prior to trying =
the dup
> but I'm just not sure why you'd want to switch these around in this patch=
?
>
> Can we try to keep original ordering unless there's a really good reason =
not to?

Again, I'm trying to avoid undoing things if locking fails but this
function already has rollback code, so I can reuse it. I'll keep the
old placement here.

>
> >       if (commit_merge(vmg))
> >               goto nomem;
> >
> > @@ -1233,6 +1246,7 @@ int vma_shrink(struct vma_iterator *vmi, struct v=
m_area_struct *vma,
> >              unsigned long start, unsigned long end, pgoff_t pgoff)
> >  {
> >       struct vma_prepare vp;
> > +     int err;
> >
> >       WARN_ON((vma->vm_start !=3D start) && (vma->vm_end !=3D end));
> >
> > @@ -1244,7 +1258,11 @@ int vma_shrink(struct vma_iterator *vmi, struct =
vm_area_struct *vma,
> >       if (vma_iter_prealloc(vmi, NULL))
> >               return -ENOMEM;
> >
> > -     vma_start_write(vma);
> > +     err =3D vma_start_write_killable(vma);
> > +     if (err) {
> > +             vma_iter_free(vmi);
> > +             return err;
> > +     }
> >
> >       init_vma_prep(&vp, vma);
> >       vma_prepare(&vp);
> > @@ -1434,7 +1452,9 @@ static int vms_gather_munmap_vmas(struct vma_munm=
ap_struct *vms,
> >                       if (error)
> >                               goto end_split_failed;
> >               }
> > -             vma_start_write(next);
> > +             error =3D vma_start_write_killable(next);
> > +             if (error)
> > +                     goto munmap_gather_failed;
> >               mas_set(mas_detach, vms->vma_count++);
> >               error =3D mas_store_gfp(mas_detach, next, GFP_KERNEL);
> >               if (error)
> > @@ -1828,12 +1848,17 @@ static void vma_link_file(struct vm_area_struct=
 *vma, bool hold_rmap_lock)
> >  static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
> >  {
> >       VMA_ITERATOR(vmi, mm, 0);
> > +     int err;
> >
> >       vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
> >       if (vma_iter_prealloc(&vmi, vma))
> >               return -ENOMEM;
> >
> > -     vma_start_write(vma);
> > +     err =3D vma_start_write_killable(vma);
> > +     if (err) {
> > +             vma_iter_free(&vmi);
> > +             return err;
> > +     }
> >       vma_iter_store_new(&vmi, vma);
> >       vma_link_file(vma, /* hold_rmap_lock=3D */false);
> >       mm->map_count++;
> > @@ -2215,9 +2240,8 @@ int mm_take_all_locks(struct mm_struct *mm)
> >        * is reached.
> >        */
> >       for_each_vma(vmi, vma) {
> > -             if (signal_pending(current))
> > +             if (signal_pending(current) || vma_start_write_killable(v=
ma))
> >                       goto out_unlock;
> > -             vma_start_write(vma);
> >       }
> >
> >       vma_iter_init(&vmi, mm, 0);
> > @@ -2522,6 +2546,11 @@ static int __mmap_new_vma(struct mmap_state *map=
, struct vm_area_struct **vmap)
> >       if (!vma)
> >               return -ENOMEM;
> >
> > +     /* Lock the VMA since it is modified after insertion into VMA tre=
e */
> > +     error =3D vma_start_write_killable(vma);
> > +     if (error)
> > +             goto free_vma;
> > +
>
> You're doing it again :)
>
> Can we please keep the lock acquisition at the point it is in unless ther=
e's a
> really good reason not to.
>
> And if there is a good reason, please do it in another commit prior to th=
e
> massive 'change everything' one so it's more easily reviewable :)

The reason for this one is that I want to avoid undoing
__mmap_new_file_vma() if we fail to lock the VMA later. Undoing that
one would be messy, so I would prefer locking it earlier. These
operations are already performed under the mmap write lock. Is that
really a problem if we write-lock the VMA as well?

>
> >       vma_iter_config(vmi, map->addr, map->end);
> >       vma_set_range(vma, map->addr, map->end, map->pgoff);
> >       vm_flags_init(vma, map->vm_flags);
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
> > @@ -2864,6 +2891,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct=
 vm_area_struct *vma,
> >                unsigned long addr, unsigned long len, vm_flags_t vm_fla=
gs)
> >  {
> >       struct mm_struct *mm =3D current->mm;
> > +     int err =3D -ENOMEM;
>
> I hate this 'default error code' pattern, it's a code smell. Please updat=
e
> everything that jumps to the failure case to set err, and leave this
> uninitialised.
>
> We've had real bugs come out of this before!

Ack.

>
> >
> >       /*
> >        * Check against address space limits by the changed size
> > @@ -2908,7 +2936,10 @@ int do_brk_flags(struct vma_iterator *vmi, struc=
t vm_area_struct *vma,
> >       vma_set_range(vma, addr, addr + len, addr >> PAGE_SHIFT);
> >       vm_flags_init(vma, vm_flags);
> >       vma->vm_page_prot =3D vm_get_page_prot(vm_flags);
> > -     vma_start_write(vma);
> > +     if (vma_start_write_killable(vma)) {
> > +             err =3D -EINTR;
> > +             goto mas_store_fail;
> > +     }
> >       if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
> >               goto mas_store_fail;
> >
> > @@ -2928,7 +2959,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct=
 vm_area_struct *vma,
> >       vm_area_free(vma);
> >  unacct_fail:
> >       vm_unacct_memory(len >> PAGE_SHIFT);
> > -     return -ENOMEM;
> > +     return err;
> >  }
> >
> >  /**
> > @@ -3089,7 +3120,7 @@ int expand_upwards(struct vm_area_struct *vma, un=
signed long address)
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
>
> Nitty, but this kinda sucks as a label name, generally when the error lab=
el
> contains 'free' it is free_xxx where 'xxx' is some specific thing.
>
> So somethiing like 'fail' would be good.

Ack. Will change to something more appropriate.

>
> >       vma_iter_free(&vmi);
> >       validate_mm(mm);
> >       return error;
> > @@ -3174,7 +3208,7 @@ int expand_downwards(struct vm_area_struct *vma, =
unsigned long address)
> >  {
> >       struct mm_struct *mm =3D vma->vm_mm;
> >       struct vm_area_struct *prev;
> > -     int error =3D 0;
> > +     int error;
> >       VMA_ITERATOR(vmi, mm, vma->vm_start);
> >
> >       if (!(vma->vm_flags & VM_GROWSDOWN))
> > @@ -3205,12 +3239,14 @@ int expand_downwards(struct vm_area_struct *vma=
, unsigned long address)
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
> > @@ -3240,6 +3276,7 @@ int expand_downwards(struct vm_area_struct *vma, =
unsigned long address)
> >               }
> >       }
> >       anon_vma_unlock_write(vma->anon_vma);
> > +free:
>
> Obviously same comment her :)

Ack.

>
> >       vma_iter_free(&vmi);
> >       validate_mm(mm);
> >       return error;
> > diff --git a/mm/vma_exec.c b/mm/vma_exec.c
> > index 8134e1afca68..a4addc2a8480 100644
> > --- a/mm/vma_exec.c
> > +++ b/mm/vma_exec.c
> > @@ -40,6 +40,7 @@ int relocate_vma_down(struct vm_area_struct *vma, uns=
igned long shift)
> >       struct vm_area_struct *next;
> >       struct mmu_gather tlb;
> >       PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
> > +     int err;
> >
> >       BUG_ON(new_start > new_end);
> >
> > @@ -55,8 +56,9 @@ int relocate_vma_down(struct vm_area_struct *vma, uns=
igned long shift)
> >        * cover the whole range: [new_start, old_end)
> >        */
> >       vmg.target =3D vma;
> > -     if (vma_expand(&vmg))
> > -             return -ENOMEM;
> > +     err =3D vma_expand(&vmg);
> > +     if (err)
> > +             return err;
>
> Hmm. But before we were filtering the errors and now we're not... I guess=
 not an
> issue as before it could _only_ return -ENOMEM, but again, are we sure al=
l
> callers are fine with -EINTR I guess :)

This function is called only from setup_arg_pages() and all its
callers end up being linux_binfmt.load_binary handlers. The returned
error propagates all the way to execve() and its friends. And with my
extreme "luck" the execve syscall lists probably every single possible
error code except EINTR :) This is depressing...

Thanks for the detailed review, Lorenzo! I guess we need to discuss
these lock moves a bit more before I start on the new version.

>
> >
> >       /*
> >        * move the page tables downwards, on failure we rely on
> > --
> > 2.53.0.414.gf7e9f6c205-goog
> >
>
> Cheers, Lorenzo
>

