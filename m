Return-Path: <kvm+bounces-72621-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QFXRLxp2p2mehgAAu9opvQ
	(envelope-from <kvm+bounces-72621-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:00:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D024E1F897C
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 01:00:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 850CE30318B5
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 23:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BCEC377EDA;
	Tue,  3 Mar 2026 23:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OIGdKNjX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601E5375F91
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 23:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772582372; cv=pass; b=PWQbL1wYo3smmC9aWaA93SmNVbDH+76fY0/Q7z15SNwZYbZeKF9FJn90Q33bs1OYBQGkCic01GeHB90EGrC3mF5rnE+xCO0A9bywno2bvyndMZCmffEGvhdoPzgkBNz8CVZTnr5vyPrxwRaU8/6lmZd4L80/HivOuIJLh2BWM/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772582372; c=relaxed/simple;
	bh=APhesqxwUs7/BaWvsWn2ISP5EFhgcxF9REnk3zU+5Ps=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hHVz35VoVXEwwvgSj7OcF779cYZ+cBTminSr87lplpyMpWY3Okh18UC3OeUKlUO+IqjMSh+omNh+2RpkLQoyUqpgk5Acyzb782IIqp/suXosEM/ejvEYyG2h8HhKAAlmkbLpPPTkIWQWSCQTaj5dac2mGdJmzvkKjxdIj321xFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OIGdKNjX; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5069a785ed2so778741cf.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 15:59:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772582369; cv=none;
        d=google.com; s=arc-20240605;
        b=bZtxNK1lsZ05ReecbuftMhw47XCzZ61INfSZVOD/NWQDESEHNnyl51aTYUG2W7H8ci
         5JCwixJhCCY8K6zlLc/PwbY4cTH6M6GULTSBpKCoId9qtv9wzQF3AZU3HV5xE9X09dQW
         FAg1sDXp0Y7V4vFX2w+770ZOz86VD/D8YgDsxHkS7UUsWXmP/GaxVFSSRlGYZcsSdvna
         w9mITej0rcxcbQ98bxLBl34aYBxhaQOjNAtwcGwf3DxAEOL54SWnmTe6ARIbH8C1LuBg
         qzdVVS+lGrGJoh35UdAazLGHmwR6atBpLLATQVfV4jHjbrCD05TOKyYzXtpUNPiYBvYd
         hR4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=px1Y/hYXvoU5IMfti8a7poEyLQrLWhXDu0pMI3HLqtI=;
        fh=28+DTCNyFK+MwIN9RklOEcMjqmSnZ/aPvg96ozVEdDM=;
        b=QAyGxxSMVl8gzHA9LXQ+fKqPAG/MX6VOq5245dlVkxmbhqPTYAObZJK60/D/j9w1ey
         0GirTQQU/LptNWFZjwoXltocv/RqVn5ppSH8NcfMPh5uwgyaROjtyLLJ6i50fQtj0g7O
         sK/g2cqVziB5MKvip0k6K4znxA77PtqAxJ++j3wCitGdJPVZ0Av/T7mUoLXDL8AUu0+3
         rIlFywCYVb4EXrbXzL9CICH21FMjn5n8QWOt/0+MZOSOWv51u6rHeZqr2imS5sQzpeF8
         XgWQ9ML2x26nhi/4eCKak1Ih6l6EpH3GolBK9pkKp4pteGtPCneYIHJ1LCVvNlCiW/i9
         Y43w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772582369; x=1773187169; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=px1Y/hYXvoU5IMfti8a7poEyLQrLWhXDu0pMI3HLqtI=;
        b=OIGdKNjXC3MvyLQPkBFJZegkhHE885kGH5cIQIGhzpnbzynLqb7VnbMsmoSSY7BTg9
         zT7SPj3/9UV3MdYnkhttMaiuU5dcqTxVBs1h1Ah9f+UbNdFCT8X2Stvhev3bx1q3Wj6r
         FDkMA8JdQ3+luPCDPVmSKqP/Jv7SdxQ5SNE5iPM5Kl6zFIlNps3L9WRjVPpvqmUNjB/h
         XmZNdKFGwvEjUIRRrgYWsw8lqiRNVPaZrmoKTvofh7nyGPo4Gt6rfOMjtxU61ChTmoqS
         upPt/QwAV7UF5wDU5RORWqWaGRxC2FZIhoyv2BlDZ+EcZpR6VEZ+ogo5TuZ5X4VW2qer
         loKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772582369; x=1773187169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=px1Y/hYXvoU5IMfti8a7poEyLQrLWhXDu0pMI3HLqtI=;
        b=vEWwyplO6RRU5uhSIWEbbmJWSCIbbVnC7bwFnkmB3DZQepVPuj8DtVk1EqubRMUwu9
         Dvp1RlavC79mcRwqC0/TCW6PIPuH+LYUv7d2ssd7ViKpqlyibbrHekMFrnuwA8B+WA3J
         q1KWAi7aK7rGjfDSnAAvyslZWSZb+rMqx9BUte/5Lz03rnIxE+843FmXtl2IkcchwPZQ
         0OIR5Ouv5MNvPLFDX0lwvXx5hZ1d5ZBrH9tQPjNOVd3NBIuZ0PtxO3lxQs+mlHvSoyQ2
         asJSah2HCcGYpwzxNSomYc8V+EYDkKZFZJLTjnJDOIYR/Frwg11LbfN1SB4B1uF2ujn5
         ry7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWuyeqLS4E3VUEp/EZi8MzlE6isOzvJpzZRsYXqSphZLgTVRYEnaqfORLr76UpEOShRZqU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1Qfa3hr6ahM0IcMtX4YqCvoCAYigdfDh9b/VSXvKUSUS62HiQ
	v1D41cmXJPr0h54EUrlfqCmnq1HnBvgQFLKJL/I1w9l0oL5AKnivD7pVgzHNLu5dkflJ4XkBSJx
	qcRdL81nVnKcXNWDv2jpTJ70cwZoLpCrqf30HTBRZ
X-Gm-Gg: ATEYQzxlAucp6cuUjVOsZJVgQ8AgUeLX0v1doEMA18AI1rsjkdht7A9S9ZliUNk3KLN
	68QWtm33759ev87y6ljUP8dUpD+jun9zJP2AT7pGRNsOwzgwaS55IERgeNw+SFrPtZhoxwJQa+e
	06PoAqGSNf/tUA4LEe/M7A1KpkaSbjMp1PgD4q1/jVK2hsVHV/yG+SMOf1E0Z0+HWiwer18vsuM
	AIqH3p0Qgh8xebssm3skhrwSjpr8IZsNJlVLo0ATM1qGdxzVrsN3ujkFbqlGRKjbLJCHHn+h/Mh
	TcvN2DZVQ2D5sYQao7KftYIvNkZNkYErrlKw
X-Received: by 2002:a05:622a:14ca:b0:4f3:7b37:81b with SMTP id
 d75a77b69052e-5075fea9c02mr43750861cf.18.1772582368589; Tue, 03 Mar 2026
 15:59:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com> <20260226070609.3072570-4-surenb@google.com>
 <72ff2fc0-07fe-4964-9a1e-eccf8c7ed6a7@lucifer.local>
In-Reply-To: <72ff2fc0-07fe-4964-9a1e-eccf8c7ed6a7@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 3 Mar 2026 15:59:17 -0800
X-Gm-Features: AaiRm509RYF3etasX2xFgZmAhKSXZQCXlropJgc5ZcJilpJ6cUQUI8sknzWfQIY
Message-ID: <CAJuCfpG_bekxrHd49qyUBR2K7V8o7DrOvc-ZR7M8dAC-Hyp5ng@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mm: use vma_start_write_killable() in process_vma_walk_lock()
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
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D024E1F897C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72621-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[linux-foundation.org,infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,oracle.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[42];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On Mon, Mar 2, 2026 at 7:25=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Feb 25, 2026 at 11:06:09PM -0800, Suren Baghdasaryan wrote:
> > Replace vma_start_write() with vma_start_write_killable() when
> > process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> > Adjust its direct and indirect users to check for a possible error
> > and handle it. Ensure users handle EINTR correctly and do not ignore
> > it.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Have raised concerns below but also this feels like you're trying to do a=
 bit
> too much in one patch here, probably worth splitting out based on the dif=
ferent
> parts you changed.
>
> > ---
> >  arch/s390/kvm/kvm-s390.c |  2 +-
> >  fs/proc/task_mmu.c       |  5 ++++-
> >  mm/mempolicy.c           | 14 +++++++++++---
> >  mm/pagewalk.c            | 20 ++++++++++++++------
> >  mm/vma.c                 | 22 ++++++++++++++--------
> >  mm/vma.h                 |  6 ++++++
> >  6 files changed, 50 insertions(+), 19 deletions(-)
> >
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index 7a175d86cef0..337e4f7db63a 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -2948,7 +2948,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned=
 int ioctl, unsigned long arg)
> >               }
> >               /* must be called without kvm->lock */
> >               r =3D kvm_s390_handle_pv(kvm, &args);
> > -             if (copy_to_user(argp, &args, sizeof(args))) {
> > +             if (r !=3D -EINTR && copy_to_user(argp, &args, sizeof(arg=
s))) {
>
> This is horribly ugly, and if we were already filtering any other instanc=
e of
> -EINTR (if they're even possible from copy_to_user()) why is -EINTR being
> treated in a special way?
>
> I honestly _hate_ this if (errcode !=3D -EINTR) { ... } pattern in genera=
l, I'd
> really rather we didn't.
>
> It's going to bitrot and people are going to assume it's for some _very g=
ood
> reason_ and nobody will understand why it's getting special treatment...
>
> Surely a fatal signal would have previously resulted in -EFAULT before wh=
ich is
> a similar situation so most consistent would be to keep filtering no?

Current code ignores any error coming from kvm_s390_handle_pv() and
proceeds with copy_to_user(), possibly overriding the former error. I
don't really know if this is an oversight or an intentional behavior,
so I wanted to minimize possible side effects. I guess I should try to
fix it properly (or learn why this was done this way). I'll post a
separate patch to error out immediately if kvm_s390_handle_pv() fails
and will ask s390 experts for review.

>
> >                       r =3D -EFAULT;
> >                       break;
> >               }
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index e091931d7ca1..1238a2988eb6 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -1797,6 +1797,7 @@ static ssize_t clear_refs_write(struct file *file=
, const char __user *buf,
> >               struct clear_refs_private cp =3D {
> >                       .type =3D type,
> >               };
> > +             int err;
> >
> >               if (mmap_write_lock_killable(mm)) {
> >                       count =3D -EINTR;
> > @@ -1824,7 +1825,9 @@ static ssize_t clear_refs_write(struct file *file=
, const char __user *buf,
> >                                               0, mm, 0, -1UL);
> >                       mmu_notifier_invalidate_range_start(&range);
> >               }
> > -             walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
> > +             err =3D walk_page_range(mm, 0, -1, &clear_refs_walk_ops, =
&cp);
> > +             if (err < 0)
>
> Again with this < 0 :) let's be consistent, if (err).

Ack.

>
> > +                     count =3D err;
> >               if (type =3D=3D CLEAR_REFS_SOFT_DIRTY) {
> >                       mmu_notifier_invalidate_range_end(&range);
> >                       flush_tlb_mm(mm);
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 90939f5bde02..3c8b3dfc9c56 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -988,6 +988,8 @@ queue_pages_range(struct mm_struct *mm, unsigned lo=
ng start, unsigned long end,
> >                       &queue_pages_lock_vma_walk_ops : &queue_pages_wal=
k_ops;
>
> There's a comment above:
>
>  * queue_pages_range() may return:
>  * 0 - all pages already on the right node, or successfully queued for mo=
ving
>  *     (or neither strict checking nor moving requested: only range check=
ing).
>  * >0 - this number of misplaced folios could not be queued for moving
>  *      (a hugetlbfs page or a transparent huge page being counted as 1).
>  * -EIO - a misplaced page found, when MPOL_MF_STRICT specified without M=
OVEs.
>  * -EFAULT - a hole in the memory range, when MPOL_MF_DISCONTIG_OK unspec=
ified.
>  */
>
> You should add the -EINTR to it.

Ack.

>
> >
> >       err =3D walk_page_range(mm, start, end, ops, &qp);
> > +     if (err =3D=3D -EINTR)
> > +             return err;
>
> Again, you're special casing without really any justification here. Let's=
 please
> not special case -EINTR unless you have a _really good_ reason to.
>
> And also - if we fail to walk the page range because we couldn't get a VM=
A write
> lock, that's ok. The walk failed. There's nothing to unlock, because we d=
idn't
> even get the write lock in the first place, so there's no broken state, i=
t's as
> if we failed at some other point right?
>
> So I don't see why we're special casing this _at all_.

I want to avoid possible -EINTR code override with -EFAULT in the code belo=
w.
walk_page_range() can return -EINVAL and any other error that
ops->pte_hole or ops->test_walk might return. We might be fine
treating all of them as -EFAULT but masking -EINTR seems wrong to me.
I don't really know a better way to deal with this but if you have a
good alternative I would really appreciate it.

>
> >
> >       if (!qp.first)
> >               /* whole range in hole */
> > @@ -1309,9 +1311,14 @@ static long migrate_to_node(struct mm_struct *mm=
, int source, int dest,
> >                                     flags | MPOL_MF_DISCONTIG_OK, &page=
list);
> >       mmap_read_unlock(mm);
>
>
> >
> > +     if (nr_failed =3D=3D -EINTR)
> > +             err =3D nr_failed;
>
> Ugh please don't, that's REALLY horrible.
>
> Actually the only way you'd get a write lock happening in the walk_page_r=
ange()
> is if flags & MPOL_MF_WRLOCK, menaing queue_pages_lock_vma_walk_ops are u=
sed
> which specifies .walk_lock =3D PGWALK_WRLOCK.
>
> And this flag is only set in do_mbind(), not in migrate_to_node().
>
> So this check is actually totally unnecessary. You'll never get -EINTR he=
re.

Ah, good point. I'll drop this part.

>
> Maybe this code needs some refactoring though in general... yikes.

Right.

>
> > +
> >       if (!list_empty(&pagelist)) {
> > -             err =3D migrate_pages(&pagelist, alloc_migration_target, =
NULL,
> > -                     (unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL, NU=
LL);
> > +             if (!err)
> > +                     err =3D migrate_pages(&pagelist, alloc_migration_=
target,
> > +                                         NULL, (unsigned long)&mtc,
> > +                                         MIGRATE_SYNC, MR_SYSCALL, NUL=
L);
>
> Given the above, this is unnecessary too.

Ack. Will drop.

>
> >               if (err)
> >                       putback_movable_pages(&pagelist);
> >       }
> > @@ -1611,7 +1618,8 @@ static long do_mbind(unsigned long start, unsigne=
d long len,
> >                               MR_MEMPOLICY_MBIND, NULL);
> >       }
> >
> > -     if (nr_failed && (flags & MPOL_MF_STRICT))
> > +     /* Do not mask EINTR */
>
> Useless comment... You're not explaining why, and it's obvious what you'r=
e doing.
>
> > +     if ((err !=3D -EINTR) && (nr_failed && (flags & MPOL_MF_STRICT)))
>
> Weird use of parens...
>
> And again why are we treating -EINTR in a special way?

Ah, actually I don't think I need this here. If queue_pages_range()
fails nr_failed gets reset to 0, so the original error won't be masked
as -EIO. I'll drop this part.

>
> >               err =3D -EIO;
> >       if (!list_empty(&pagelist))
> >               putback_movable_pages(&pagelist);
> > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > index a94c401ab2cf..dc9f7a7709c6 100644
> > --- a/mm/pagewalk.c
> > +++ b/mm/pagewalk.c
> > @@ -425,14 +425,13 @@ static inline void process_mm_walk_lock(struct mm=
_struct *mm,
> >               mmap_assert_write_locked(mm);
> >  }
> >
> > -static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> > +static inline int process_vma_walk_lock(struct vm_area_struct *vma,
> >                                        enum page_walk_lock walk_lock)
> >  {
> >  #ifdef CONFIG_PER_VMA_LOCK
> >       switch (walk_lock) {
> >       case PGWALK_WRLOCK:
> > -             vma_start_write(vma);
> > -             break;
> > +             return vma_start_write_killable(vma);
> >       case PGWALK_WRLOCK_VERIFY:
> >               vma_assert_write_locked(vma);
> >               break;
> > @@ -444,6 +443,7 @@ static inline void process_vma_walk_lock(struct vm_=
area_struct *vma,
> >               break;
> >       }
> >  #endif
> > +     return 0;
> >  }
> >
> >  /*
> > @@ -487,7 +487,9 @@ int walk_page_range_mm_unsafe(struct mm_struct *mm,=
 unsigned long start,
> >                       if (ops->pte_hole)
> >                               err =3D ops->pte_hole(start, next, -1, &w=
alk);
> >               } else { /* inside vma */
> > -                     process_vma_walk_lock(vma, ops->walk_lock);
> > +                     err =3D process_vma_walk_lock(vma, ops->walk_lock=
);
> > +                     if (err)
> > +                             break;
> >                       walk.vma =3D vma;
> >                       next =3D min(end, vma->vm_end);
> >                       vma =3D find_vma(mm, vma->vm_end);
> > @@ -704,6 +706,7 @@ int walk_page_range_vma_unsafe(struct vm_area_struc=
t *vma, unsigned long start,
> >               .vma            =3D vma,
> >               .private        =3D private,
> >       };
> > +     int err;
> >
> >       if (start >=3D end || !walk.mm)
> >               return -EINVAL;
> > @@ -711,7 +714,9 @@ int walk_page_range_vma_unsafe(struct vm_area_struc=
t *vma, unsigned long start,
> >               return -EINVAL;
> >
> >       process_mm_walk_lock(walk.mm, ops->walk_lock);
> > -     process_vma_walk_lock(vma, ops->walk_lock);
> > +     err =3D process_vma_walk_lock(vma, ops->walk_lock);
> > +     if (err)
> > +             return err;
> >       return __walk_page_range(start, end, &walk);
> >  }
> >
> > @@ -734,6 +739,7 @@ int walk_page_vma(struct vm_area_struct *vma, const=
 struct mm_walk_ops *ops,
> >               .vma            =3D vma,
> >               .private        =3D private,
> >       };
> > +     int err;
> >
> >       if (!walk.mm)
> >               return -EINVAL;
> > @@ -741,7 +747,9 @@ int walk_page_vma(struct vm_area_struct *vma, const=
 struct mm_walk_ops *ops,
> >               return -EINVAL;
> >
> >       process_mm_walk_lock(walk.mm, ops->walk_lock);
> > -     process_vma_walk_lock(vma, ops->walk_lock);
> > +     err =3D process_vma_walk_lock(vma, ops->walk_lock);
> > +     if (err)
> > +             return err;
> >       return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
> >  }
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 9f2664f1d078..46bbad6e64a4 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -998,14 +998,18 @@ static __must_check struct vm_area_struct *vma_me=
rge_existing_range(
> >       if (anon_dup)
> >               unlink_anon_vmas(anon_dup);
> >
> > -     /*
> > -      * This means we have failed to clone anon_vma's correctly, but n=
o
> > -      * actual changes to VMAs have occurred, so no harm no foul - if =
the
> > -      * user doesn't want this reported and instead just wants to give=
 up on
> > -      * the merge, allow it.
> > -      */
> > -     if (!vmg->give_up_on_oom)
> > -             vmg->state =3D VMA_MERGE_ERROR_NOMEM;
> > +     if (err =3D=3D -EINTR) {
> > +             vmg->state =3D VMA_MERGE_ERROR_INTR;
>
> Yeah this is incorrect. You seem adament in passing through -EINTR _no
> matter what_ :)

You got me figured out ;)

>
> There are callers that don't care at all if the merge failed, whether thr=
ough
> oom or VMA write lock not being acquired.

Ah, I see. I was a bit puzzled by this vmg->give_up_on_oom flag. I
think what you are saying is that errors from
vma_merge_existing_range() are ignored unless this flag is set and
even then the only possible error is ENOMEM.

>
> There's really no benefit in exiting early here I don't think, the subseq=
uent
> split will call vma_start_write_killable() anyway.

But are we always calling split after the merge?

>
> So I think this adds a lot of complexity and mess for nothing.
>
> So can we drop all this change to the merge logic please?

Ok but is there a good reason for this unusual error handling logic in
vma_merge_existing_range()?

>
> > +     } else {
> > +             /*
> > +              * This means we have failed to clone anon_vma's correctl=
y,
> > +              * but no actual changes to VMAs have occurred, so no har=
m no
> > +              * foul - if the user doesn't want this reported and inst=
ead
> > +              * just wants to give up on the merge, allow it.
> > +              */
> > +             if (!vmg->give_up_on_oom)
> > +                     vmg->state =3D VMA_MERGE_ERROR_NOMEM;
> > +     }
> >       return NULL;
> >  }
> >
> > @@ -1681,6 +1685,8 @@ static struct vm_area_struct *vma_modify(struct v=
ma_merge_struct *vmg)
> >       merged =3D vma_merge_existing_range(vmg);
> >       if (merged)
> >               return merged;
> > +     if (vmg_intr(vmg))
> > +             return ERR_PTR(-EINTR);
> >       if (vmg_nomem(vmg))
> >               return ERR_PTR(-ENOMEM);
> >
> > diff --git a/mm/vma.h b/mm/vma.h
> > index eba388c61ef4..fe4560f81f4f 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -56,6 +56,7 @@ struct vma_munmap_struct {
> >  enum vma_merge_state {
> >       VMA_MERGE_START,
> >       VMA_MERGE_ERROR_NOMEM,
> > +     VMA_MERGE_ERROR_INTR,
> >       VMA_MERGE_NOMERGE,
> >       VMA_MERGE_SUCCESS,
> >  };
> > @@ -226,6 +227,11 @@ static inline bool vmg_nomem(struct vma_merge_stru=
ct *vmg)
> >       return vmg->state =3D=3D VMA_MERGE_ERROR_NOMEM;
> >  }
> >
> > +static inline bool vmg_intr(struct vma_merge_struct *vmg)
> > +{
> > +     return vmg->state =3D=3D VMA_MERGE_ERROR_INTR;
> > +}
> > +
> >  /* Assumes addr >=3D vma->vm_start. */
> >  static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
> >                                      unsigned long addr)
> > --
> > 2.53.0.414.gf7e9f6c205-goog
> >
>

