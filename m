Return-Path: <kvm+bounces-72831-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YIu3NImrqWlSBwEAu9opvQ
	(envelope-from <kvm+bounces-72831-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 17:12:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 957F521537E
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 17:12:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2E578304875A
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 16:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277D93CE4A6;
	Thu,  5 Mar 2026 16:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PsLT75oN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D683CE48A
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 16:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772727153; cv=pass; b=aX1/zgxZ0PDTsz5mqDh1N6+cIUWi82xrEYkUZzKjmPrXILIh+s0ZcLO5A+qjUQ3+YLpPeUqVbk2787F2XCLum9fOK85jUsuhq8IF3xJ5HJoyxQ6SI8g9B4ezOMF6WybesLHRUvi+nNDNglIdpNd+N5GpKla1Bzggim7VWcwXfRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772727153; c=relaxed/simple;
	bh=/MujJWqwTRzDR/unKMY3n6kEqv4LrGhHpEymwZFABX0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XgNmO9tmVlGzajKD9ursBgfEdUh1LjEv0HRy+CN0Ln4ulUNp9HF58ChmSHL4GJt1JcMIjttMubbSWtwdrEockSl92dQtZYdRECWeLdfh6B7mmhGBC/NRR1FWkOBg5jy6GxAWfwZawNc0APctundYCJGxZlRCF6eNTBSsE9aZEF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PsLT75oN; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-506a355aedfso599781cf.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 08:12:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772727149; cv=none;
        d=google.com; s=arc-20240605;
        b=TOMNlC9EZA+99FJsp334tiIbKHMrpQS3qaA48He9rOXplOJQX1Yatgj8GI616sR24t
         WXxzsKE/CAGAB0aM5QY821nXeTjSOT+vQMkgp/e9kRCVNVwFLJn/ylBXpINYfpxMGu8n
         kheD1X4DWHkKLognR6cS/kUhtac8+4/K/X1p5kvO1sz7tE/s0XzoEG5CHnzhaI0qdSgH
         FwgMtdR/vSVewSzk1q2toG3JBHpGDfkUsshgi3ZCPqnP9+GE+z+KwAz8B4L9a+zPDn6H
         iCTNRaxQ5ajxFZ/RtHK+CKq0hYH9NO4JPsTp5TNsvXsKxCG5nIdPwP+Ov2gz6/zLhkkL
         4h/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D9xcduMaGwL9FwPMCpELebLrVqeCBmti/yDZTZzj9fY=;
        fh=crTBLMYkmR86XjuwPBrBdEkSk7AY5KOiJ/yxLvgfsJg=;
        b=QfhKW08Je1kZNzzCslVLekmr8LtIAoMsYkzBNc/Fz8kxqLZkryiOV7s0DtLGRa0Cld
         OxHd7/+j7+zH7/pIH3MWzKTQxkh9/BXxWIQGNZ7vti4AlZ4r9ZqVUMoJwDiAz8We1hpL
         91r94gx86fj/XP9F8U/3P+INEa+2CFBLxhYx85Hme5nZ2tYB3554oYLXD50RUi0T33JL
         8R6uBkwuUf3xVj95PmJarjtk0mAUGUZz5jN+BhDFktVafJvCjxJuYBl1gE6EDoVKwlel
         FPXFlRTtx7eBx7F4sCzftLGkTsIvRzuDdScWwLGnolQkHwiBahbrheVgZkl+Nn6sNhMY
         Iouw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772727149; x=1773331949; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D9xcduMaGwL9FwPMCpELebLrVqeCBmti/yDZTZzj9fY=;
        b=PsLT75oNu8ep6bCNb/spFMM1OYgLrOITtmbRfje7Ir/JITX7qh96CdWYqDqbwXklv/
         d4DdJVf3K310rnRQI6qeu9uKzpeqieVKXPN/MzDu0z1WT/Fk0hnBUwBGysfNADZeY/r8
         noF7mYf+jyHAkEtm3YGfSogYYlAqBVQxi54MaVHIaXiZ0FdNVefJmaOYRqZ+e7ZKo3DX
         99qApP+Xoqi35Mq4rql12RWT8+zg0ZeYUMLETvwm56mZpfXOeMDe/ANfrDYs4qdw/B/e
         DcQVrGH2Co0yglzO6ScA7NVTld6FAG2CAfaDRQHFnwHKZ2skk4gEdjTgfYuZG82OOkNy
         mm5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772727149; x=1773331949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D9xcduMaGwL9FwPMCpELebLrVqeCBmti/yDZTZzj9fY=;
        b=J2O1AD64uxUjsQpq/vOlB+rTppdqGyL4Y8BB0LooIqY3hh0z8nzduOxmpoOHlwQVEk
         ToP4VbRy462Wb6tP3pry8F8YZedW2SzixsEHKWvn40Xpj5PX2XN0E9ZdGP6sOfyJYcLM
         fu00oqRsjCyaR14drPxsbPeIcnXs1VLDbUtntxt3h2LkuwNvi3kOp5NYOkYKChj4XSaP
         i2DESleEubZgLAm3f2EZQofDrOqGE94h9ZVxIQ3sa8IIO/jvHYE+TwqOHtK4GU0tjkOw
         B0W8xWDFO5QBqYiDSNc3CiGQ9rP7wPHqK13ioEb/9lYhcWoptS3Z1s2HBHa3BX8Tdzm+
         3gew==
X-Forwarded-Encrypted: i=1; AJvYcCUtT5+sATsbt2zoovVcQg0023IsI10JICpEjulySExqe54ES773wmV5tnSJOwF8nDD0BQc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIy30glD9kEEfrz7n3P6we9A7gHq/i3D4Q89tMBisiwGi0MKlK
	CczwwpHozAzbPdglqsx+dL52gYT6sYRE9ltrFS9VNTAF+eDnXewCoWzC8sFH8FlJKgbqxeephvK
	Ah7xRr08/TC1fcezqw8ClQUa24wjgdHYbiq/ntRth
X-Gm-Gg: ATEYQzzFPSEf5UUlCq52F8xEXX9n9XUu6m1u8C6cqLz84pXbz9wlv6IQ7UCvkx/FGbS
	eiofLxPff3XFsWbA+iokOWlMSB5q4zCxPzc4xFXgNVzsredlNyQHc8PRmShvae3o6kGXrjlM3Lx
	BX+cld0jDYSjj+IFwd4NSKPrMClF0KVJvYJdV1a7hUId+R2H1lU4aX7ezoDiPlU/iJsAK6IbeIr
	Ok/G9W7T7RMtB4uKZR4T7E5CAPCsdsyOMn/U34VUeUuCynEMjlER9oG6feGM/i5jHA2tcD192Er
	u/DVJpjARVFAfdhTp943pUry3h0Ef47dx9aLjDDryMC6Se9o
X-Received: by 2002:ac8:5710:0:b0:503:2d8f:4cd9 with SMTP id
 d75a77b69052e-508e5e5db04mr11948791cf.16.1772727147711; Thu, 05 Mar 2026
 08:12:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com> <20260226070609.3072570-4-surenb@google.com>
 <72ff2fc0-07fe-4964-9a1e-eccf8c7ed6a7@lucifer.local> <CAJuCfpG_bekxrHd49qyUBR2K7V8o7DrOvc-ZR7M8dAC-Hyp5ng@mail.gmail.com>
 <50987b7f-39ec-479d-9700-317cb0b95e6e@lucifer.local>
In-Reply-To: <50987b7f-39ec-479d-9700-317cb0b95e6e@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 5 Mar 2026 08:12:16 -0800
X-Gm-Features: AaiRm50LWno2c0MkglZEwe8geA6lFAl2tQxTaGHqUvTWhHATMXzeTZ4TnJgkQRQ
Message-ID: <CAJuCfpGEqjGZcMiY7RommSzO7tOrW8Zz-Web0o16zd+HX9JU3g@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mm: use vma_start_write_killable() in process_vma_walk_lock()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org, 
	willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
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
X-Rspamd-Queue-Id: 957F521537E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72831-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[43];
	FREEMAIL_CC(0.00)[oracle.com,linux-foundation.org,infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,redhat.com,arm.com,linux.dev,suse.cz,google.com,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid,oracle.com:email]
X-Rspamd-Action: no action

On Wed, Mar 4, 2026 at 8:58=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kernel=
.org> wrote:
>
> On Tue, Mar 03, 2026 at 03:59:17PM -0800, Suren Baghdasaryan wrote:
> > On Mon, Mar 2, 2026 at 7:25=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Wed, Feb 25, 2026 at 11:06:09PM -0800, Suren Baghdasaryan wrote:
> > > > Replace vma_start_write() with vma_start_write_killable() when
> > > > process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> > > > Adjust its direct and indirect users to check for a possible error
> > > > and handle it. Ensure users handle EINTR correctly and do not ignor=
e
> > > > it.
> > > >
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > >
> > > Have raised concerns below but also this feels like you're trying to =
do a bit
> > > too much in one patch here, probably worth splitting out based on the=
 different
> > > parts you changed.
> > >
> > > > ---
> > > >  arch/s390/kvm/kvm-s390.c |  2 +-
> > > >  fs/proc/task_mmu.c       |  5 ++++-
> > > >  mm/mempolicy.c           | 14 +++++++++++---
> > > >  mm/pagewalk.c            | 20 ++++++++++++++------
> > > >  mm/vma.c                 | 22 ++++++++++++++--------
> > > >  mm/vma.h                 |  6 ++++++
> > > >  6 files changed, 50 insertions(+), 19 deletions(-)
> > > >
> > > > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > > > index 7a175d86cef0..337e4f7db63a 100644
> > > > --- a/arch/s390/kvm/kvm-s390.c
> > > > +++ b/arch/s390/kvm/kvm-s390.c
> > > > @@ -2948,7 +2948,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsi=
gned int ioctl, unsigned long arg)
> > > >               }
> > > >               /* must be called without kvm->lock */
> > > >               r =3D kvm_s390_handle_pv(kvm, &args);
> > > > -             if (copy_to_user(argp, &args, sizeof(args))) {
> > > > +             if (r !=3D -EINTR && copy_to_user(argp, &args, sizeof=
(args))) {
> > >
> > > This is horribly ugly, and if we were already filtering any other ins=
tance of
> > > -EINTR (if they're even possible from copy_to_user()) why is -EINTR b=
eing
> > > treated in a special way?
> > >
> > > I honestly _hate_ this if (errcode !=3D -EINTR) { ... } pattern in ge=
neral, I'd
> > > really rather we didn't.
> > >
> > > It's going to bitrot and people are going to assume it's for some _ve=
ry good
> > > reason_ and nobody will understand why it's getting special treatment=
...
> > >
> > > Surely a fatal signal would have previously resulted in -EFAULT befor=
e which is
> > > a similar situation so most consistent would be to keep filtering no?
> >
> > Current code ignores any error coming from kvm_s390_handle_pv() and
> > proceeds with copy_to_user(), possibly overriding the former error. I
> > don't really know if this is an oversight or an intentional behavior,
> > so I wanted to minimize possible side effects. I guess I should try to
> > fix it properly (or learn why this was done this way). I'll post a
> > separate patch to error out immediately if kvm_s390_handle_pv() fails
> > and will ask s390 experts for review.
>
> Thanks!
>
> >
> > >
> > > >                       r =3D -EFAULT;
> > > >                       break;
> > > >               }
> > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > index e091931d7ca1..1238a2988eb6 100644
> > > > --- a/fs/proc/task_mmu.c
> > > > +++ b/fs/proc/task_mmu.c
> > > > @@ -1797,6 +1797,7 @@ static ssize_t clear_refs_write(struct file *=
file, const char __user *buf,
> > > >               struct clear_refs_private cp =3D {
> > > >                       .type =3D type,
> > > >               };
> > > > +             int err;
> > > >
> > > >               if (mmap_write_lock_killable(mm)) {
> > > >                       count =3D -EINTR;
> > > > @@ -1824,7 +1825,9 @@ static ssize_t clear_refs_write(struct file *=
file, const char __user *buf,
> > > >                                               0, mm, 0, -1UL);
> > > >                       mmu_notifier_invalidate_range_start(&range);
> > > >               }
> > > > -             walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp)=
;
> > > > +             err =3D walk_page_range(mm, 0, -1, &clear_refs_walk_o=
ps, &cp);
> > > > +             if (err < 0)
> > >
> > > Again with this < 0 :) let's be consistent, if (err).
> >
> > Ack.
>
> Thanks!
>
> >
> > >
> > > > +                     count =3D err;
> > > >               if (type =3D=3D CLEAR_REFS_SOFT_DIRTY) {
> > > >                       mmu_notifier_invalidate_range_end(&range);
> > > >                       flush_tlb_mm(mm);
> > > > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > > > index 90939f5bde02..3c8b3dfc9c56 100644
> > > > --- a/mm/mempolicy.c
> > > > +++ b/mm/mempolicy.c
> > > > @@ -988,6 +988,8 @@ queue_pages_range(struct mm_struct *mm, unsigne=
d long start, unsigned long end,
> > > >                       &queue_pages_lock_vma_walk_ops : &queue_pages=
_walk_ops;
> > >
> > > There's a comment above:
> > >
> > >  * queue_pages_range() may return:
> > >  * 0 - all pages already on the right node, or successfully queued fo=
r moving
> > >  *     (or neither strict checking nor moving requested: only range c=
hecking).
> > >  * >0 - this number of misplaced folios could not be queued for movin=
g
> > >  *      (a hugetlbfs page or a transparent huge page being counted as=
 1).
> > >  * -EIO - a misplaced page found, when MPOL_MF_STRICT specified witho=
ut MOVEs.
> > >  * -EFAULT - a hole in the memory range, when MPOL_MF_DISCONTIG_OK un=
specified.
> > >  */
> > >
> > > You should add the -EINTR to it.
> >
> > Ack.
>
> Thanks!
>
> >
> > >
> > > >
> > > >       err =3D walk_page_range(mm, start, end, ops, &qp);
> > > > +     if (err =3D=3D -EINTR)
> > > > +             return err;
> > >
> > > Again, you're special casing without really any justification here. L=
et's please
> > > not special case -EINTR unless you have a _really good_ reason to.
> > >
> > > And also - if we fail to walk the page range because we couldn't get =
a VMA write
> > > lock, that's ok. The walk failed. There's nothing to unlock, because =
we didn't
> > > even get the write lock in the first place, so there's no broken stat=
e, it's as
> > > if we failed at some other point right?
> > >
> > > So I don't see why we're special casing this _at all_.
> >
> > I want to avoid possible -EINTR code override with -EFAULT in the code =
below.
> > walk_page_range() can return -EINVAL and any other error that
> > ops->pte_hole or ops->test_walk might return. We might be fine
> > treating all of them as -EFAULT but masking -EINTR seems wrong to me.
> > I don't really know a better way to deal with this but if you have a
> > good alternative I would really appreciate it.
>
> As per Matthew we needn't worry, and in any case if we want to check for =
fatal
> signal early exit we can do if (fatal_signal_pending(current)) {} I think=
?

Ok, fatal_signal_pending() seems like a better alternative. Thanks!

>
> >
> > >
> > > >
> > > >       if (!qp.first)
> > > >               /* whole range in hole */
> > > > @@ -1309,9 +1311,14 @@ static long migrate_to_node(struct mm_struct=
 *mm, int source, int dest,
> > > >                                     flags | MPOL_MF_DISCONTIG_OK, &=
pagelist);
> > > >       mmap_read_unlock(mm);
> > >
> > >
> > > >
> > > > +     if (nr_failed =3D=3D -EINTR)
> > > > +             err =3D nr_failed;
> > >
> > > Ugh please don't, that's REALLY horrible.
> > >
> > > Actually the only way you'd get a write lock happening in the walk_pa=
ge_range()
> > > is if flags & MPOL_MF_WRLOCK, menaing queue_pages_lock_vma_walk_ops a=
re used
> > > which specifies .walk_lock =3D PGWALK_WRLOCK.
> > >
> > > And this flag is only set in do_mbind(), not in migrate_to_node().
> > >
> > > So this check is actually totally unnecessary. You'll never get -EINT=
R here.
> >
> > Ah, good point. I'll drop this part.
>
> Thanks!
>
> >
> > >
> > > Maybe this code needs some refactoring though in general... yikes.
> >
> > Right.
> >
> > >
> > > > +
> > > >       if (!list_empty(&pagelist)) {
> > > > -             err =3D migrate_pages(&pagelist, alloc_migration_targ=
et, NULL,
> > > > -                     (unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL=
, NULL);
> > > > +             if (!err)
> > > > +                     err =3D migrate_pages(&pagelist, alloc_migrat=
ion_target,
> > > > +                                         NULL, (unsigned long)&mtc=
,
> > > > +                                         MIGRATE_SYNC, MR_SYSCALL,=
 NULL);
> > >
> > > Given the above, this is unnecessary too.
> >
> > Ack. Will drop.
>
> Thanks!
>
> >
> > >
> > > >               if (err)
> > > >                       putback_movable_pages(&pagelist);
> > > >       }
> > > > @@ -1611,7 +1618,8 @@ static long do_mbind(unsigned long start, uns=
igned long len,
> > > >                               MR_MEMPOLICY_MBIND, NULL);
> > > >       }
> > > >
> > > > -     if (nr_failed && (flags & MPOL_MF_STRICT))
> > > > +     /* Do not mask EINTR */
> > >
> > > Useless comment... You're not explaining why, and it's obvious what y=
ou're doing.
> > >
> > > > +     if ((err !=3D -EINTR) && (nr_failed && (flags & MPOL_MF_STRIC=
T)))
> > >
> > > Weird use of parens...
> > >
> > > And again why are we treating -EINTR in a special way?
> >
> > Ah, actually I don't think I need this here. If queue_pages_range()
> > fails nr_failed gets reset to 0, so the original error won't be masked
> > as -EIO. I'll drop this part.
>
> Thanks!
>
> >
> > >
> > > >               err =3D -EIO;
> > > >       if (!list_empty(&pagelist))
> > > >               putback_movable_pages(&pagelist);
> > > > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > > > index a94c401ab2cf..dc9f7a7709c6 100644
> > > > --- a/mm/pagewalk.c
> > > > +++ b/mm/pagewalk.c
> > > > @@ -425,14 +425,13 @@ static inline void process_mm_walk_lock(struc=
t mm_struct *mm,
> > > >               mmap_assert_write_locked(mm);
> > > >  }
> > > >
> > > > -static inline void process_vma_walk_lock(struct vm_area_struct *vm=
a,
> > > > +static inline int process_vma_walk_lock(struct vm_area_struct *vma=
,
> > > >                                        enum page_walk_lock walk_loc=
k)
> > > >  {
> > > >  #ifdef CONFIG_PER_VMA_LOCK
> > > >       switch (walk_lock) {
> > > >       case PGWALK_WRLOCK:
> > > > -             vma_start_write(vma);
> > > > -             break;
> > > > +             return vma_start_write_killable(vma);
> > > >       case PGWALK_WRLOCK_VERIFY:
> > > >               vma_assert_write_locked(vma);
> > > >               break;
> > > > @@ -444,6 +443,7 @@ static inline void process_vma_walk_lock(struct=
 vm_area_struct *vma,
> > > >               break;
> > > >       }
> > > >  #endif
> > > > +     return 0;
> > > >  }
> > > >
> > > >  /*
> > > > @@ -487,7 +487,9 @@ int walk_page_range_mm_unsafe(struct mm_struct =
*mm, unsigned long start,
> > > >                       if (ops->pte_hole)
> > > >                               err =3D ops->pte_hole(start, next, -1=
, &walk);
> > > >               } else { /* inside vma */
> > > > -                     process_vma_walk_lock(vma, ops->walk_lock);
> > > > +                     err =3D process_vma_walk_lock(vma, ops->walk_=
lock);
> > > > +                     if (err)
> > > > +                             break;
> > > >                       walk.vma =3D vma;
> > > >                       next =3D min(end, vma->vm_end);
> > > >                       vma =3D find_vma(mm, vma->vm_end);
> > > > @@ -704,6 +706,7 @@ int walk_page_range_vma_unsafe(struct vm_area_s=
truct *vma, unsigned long start,
> > > >               .vma            =3D vma,
> > > >               .private        =3D private,
> > > >       };
> > > > +     int err;
> > > >
> > > >       if (start >=3D end || !walk.mm)
> > > >               return -EINVAL;
> > > > @@ -711,7 +714,9 @@ int walk_page_range_vma_unsafe(struct vm_area_s=
truct *vma, unsigned long start,
> > > >               return -EINVAL;
> > > >
> > > >       process_mm_walk_lock(walk.mm, ops->walk_lock);
> > > > -     process_vma_walk_lock(vma, ops->walk_lock);
> > > > +     err =3D process_vma_walk_lock(vma, ops->walk_lock);
> > > > +     if (err)
> > > > +             return err;
> > > >       return __walk_page_range(start, end, &walk);
> > > >  }
> > > >
> > > > @@ -734,6 +739,7 @@ int walk_page_vma(struct vm_area_struct *vma, c=
onst struct mm_walk_ops *ops,
> > > >               .vma            =3D vma,
> > > >               .private        =3D private,
> > > >       };
> > > > +     int err;
> > > >
> > > >       if (!walk.mm)
> > > >               return -EINVAL;
> > > > @@ -741,7 +747,9 @@ int walk_page_vma(struct vm_area_struct *vma, c=
onst struct mm_walk_ops *ops,
> > > >               return -EINVAL;
> > > >
> > > >       process_mm_walk_lock(walk.mm, ops->walk_lock);
> > > > -     process_vma_walk_lock(vma, ops->walk_lock);
> > > > +     err =3D process_vma_walk_lock(vma, ops->walk_lock);
> > > > +     if (err)
> > > > +             return err;
> > > >       return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
> > > >  }
> > > >
> > > > diff --git a/mm/vma.c b/mm/vma.c
> > > > index 9f2664f1d078..46bbad6e64a4 100644
> > > > --- a/mm/vma.c
> > > > +++ b/mm/vma.c
> > > > @@ -998,14 +998,18 @@ static __must_check struct vm_area_struct *vm=
a_merge_existing_range(
> > > >       if (anon_dup)
> > > >               unlink_anon_vmas(anon_dup);
> > > >
> > > > -     /*
> > > > -      * This means we have failed to clone anon_vma's correctly, b=
ut no
> > > > -      * actual changes to VMAs have occurred, so no harm no foul -=
 if the
> > > > -      * user doesn't want this reported and instead just wants to =
give up on
> > > > -      * the merge, allow it.
> > > > -      */
> > > > -     if (!vmg->give_up_on_oom)
> > > > -             vmg->state =3D VMA_MERGE_ERROR_NOMEM;
> > > > +     if (err =3D=3D -EINTR) {
> > > > +             vmg->state =3D VMA_MERGE_ERROR_INTR;
> > >
> > > Yeah this is incorrect. You seem adament in passing through -EINTR _n=
o
> > > matter what_ :)
> >
> > You got me figured out ;)
> >
> > >
> > > There are callers that don't care at all if the merge failed, whether=
 through
> > > oom or VMA write lock not being acquired.
> >
> > Ah, I see. I was a bit puzzled by this vmg->give_up_on_oom flag. I
> > think what you are saying is that errors from
> > vma_merge_existing_range() are ignored unless this flag is set and
> > even then the only possible error is ENOMEM.
> >
> > >
> > > There's really no benefit in exiting early here I don't think, the su=
bsequent
> > > split will call vma_start_write_killable() anyway.
> >
> > But are we always calling split after the merge?
>
> We wouldn't if start =3D=3D vma->vm_start and end =3D=3D vma->vm_end but =
that'd be a nop
> anyway :) [in vma_modify(), the only caller].

I see. Ok, then this is indeed an unnecessary complexity with no
benefit. I'll drop this part.

>
> >
> > >
> > > So I think this adds a lot of complexity and mess for nothing.
> > >
> > > So can we drop all this change to the merge logic please?
> >
> > Ok but is there a good reason for this unusual error handling logic in
> > vma_merge_existing_range()?
>
> It's specifically so we can indicate _why_ the merge didn't succeed, beca=
use the
> function returns NULL. Is checked in vma_modify().
>
> Better this way than an ERR_PTR().

I think ERR_PTR() would be a more usual pattern for such cases but I
guess either way works fine.
Thanks!

>
>
> >
> > >
> > > > +     } else {
> > > > +             /*
> > > > +              * This means we have failed to clone anon_vma's corr=
ectly,
> > > > +              * but no actual changes to VMAs have occurred, so no=
 harm no
> > > > +              * foul - if the user doesn't want this reported and =
instead
> > > > +              * just wants to give up on the merge, allow it.
> > > > +              */
> > > > +             if (!vmg->give_up_on_oom)
> > > > +                     vmg->state =3D VMA_MERGE_ERROR_NOMEM;
> > > > +     }
> > > >       return NULL;
> > > >  }
> > > >
> > > > @@ -1681,6 +1685,8 @@ static struct vm_area_struct *vma_modify(stru=
ct vma_merge_struct *vmg)
> > > >       merged =3D vma_merge_existing_range(vmg);
> > > >       if (merged)
> > > >               return merged;
> > > > +     if (vmg_intr(vmg))
> > > > +             return ERR_PTR(-EINTR);
> > > >       if (vmg_nomem(vmg))
> > > >               return ERR_PTR(-ENOMEM);
> > > >
> > > > diff --git a/mm/vma.h b/mm/vma.h
> > > > index eba388c61ef4..fe4560f81f4f 100644
> > > > --- a/mm/vma.h
> > > > +++ b/mm/vma.h
> > > > @@ -56,6 +56,7 @@ struct vma_munmap_struct {
> > > >  enum vma_merge_state {
> > > >       VMA_MERGE_START,
> > > >       VMA_MERGE_ERROR_NOMEM,
> > > > +     VMA_MERGE_ERROR_INTR,
> > > >       VMA_MERGE_NOMERGE,
> > > >       VMA_MERGE_SUCCESS,
> > > >  };
> > > > @@ -226,6 +227,11 @@ static inline bool vmg_nomem(struct vma_merge_=
struct *vmg)
> > > >       return vmg->state =3D=3D VMA_MERGE_ERROR_NOMEM;
> > > >  }
> > > >
> > > > +static inline bool vmg_intr(struct vma_merge_struct *vmg)
> > > > +{
> > > > +     return vmg->state =3D=3D VMA_MERGE_ERROR_INTR;
> > > > +}
> > > > +
> > > >  /* Assumes addr >=3D vma->vm_start. */
> > > >  static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
> > > >                                      unsigned long addr)
> > > > --
> > > > 2.53.0.414.gf7e9f6c205-goog
> > > >
> > >
>
> Cheers, Lorenzo

