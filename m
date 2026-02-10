Return-Path: <kvm+bounces-70811-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oPgDOyvCi2l6aQAAu9opvQ
	(envelope-from <kvm+bounces-70811-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 00:41:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 24D0D120236
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 00:41:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 272043013D6B
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 23:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A738339861;
	Tue, 10 Feb 2026 23:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yiw1bWPU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C7130E828
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 23:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770766879; cv=pass; b=Lrv3NdHRg0TWVuYXHFDQAfVs5eCQ/yu25jAaePeiuLdtGYRl/8etCg9zHjPZ26qBeo2qbx46gO1GZR0gZLl90fTmxEy7TNbg/bji7851Icl8El7DD+V9sE8cONfTHPY8lV72G03/s/iZrxlQDTDkbIbAG9tNmPmGSP0QQ+JzazA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770766879; c=relaxed/simple;
	bh=i6PRnVjvJhf6+SE5bnpu5i25YBlLqSX+XdEpSB/Q8KY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ues2+YSvjsLP0VVDAD6cBe1n91jV7BQ+plTqxb6wEg/I/hI3pnOQ2FO6VYltZjrjylclUu5sjcoX27F5J2kPQ4z4iWisqm6Z22RetVkPMMYQrXD/6maIoU7QB71NxEvDIGW1N8GD2W1eL9G+jYEoKF34T6r+K0Aw15/8SXjKMRM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yiw1bWPU; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5033b64256dso103671cf.0
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 15:41:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770766877; cv=none;
        d=google.com; s=arc-20240605;
        b=F+n0ZQYa5pxcDewa41FFRgEg152AXAgDuLmbKEEo/Fdj1sAhUruE5/bEHzGMF+HLTI
         w7qJ1XjEyDMTBJC238qHqLeCCwpvCUQj+IW0NsYr7J0A3D+MCAMyVHbZUyrqpaay7g30
         FGsrNH66CB5PkmHWOCfBhn3oimXB4MtmvbKi5HJBOMdFAmGKz7xFtkAx020faZW+mt12
         7NLdtRPpPgtHBn9HZoVaxsnC7igc2M9eU0RXykcJ1VBaO8UlKkxm9G5bEPs2/XH1kTlv
         NquU0mdc0Lw9duy+8ZonVWnJ7n0qMiz/703410tl7Mpy3WU2qH42IwhA4Gh+b+xl9pT1
         20DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=udnAXYhV8NVH9LmStk7ouTFsolaMp28MpPWhOY0c84I=;
        fh=3xpWKmb9O3HzZBlpN9u6BWSmiHPxyeREpnQT4d+M420=;
        b=D3EoS0//BZ8A2XTTvqjGaVT8oV4TMVj/jrC/lQK71qFN8N1B4TOa/dOmboYaAuTTHu
         +IX/70lgvLZeiBosjBy/CXI1ULMhoSxJyoU7oOfihvLyMu9MzqH/+knl6hdhvYG8grlo
         jmX7WZHtTUcBQeQNTLVJP3jT5cWVMDI1PppbhrzeeD3zNNA1xCOwrG08+PxS8X03eEfN
         Nsn0Ho1jOCXR8qgTgbwrT8S2QwwCBWi8clj/DecbZIMQOsyI2x3XXCElV7AogK1CO+hL
         OpAe7BuBHrEwb7p5FV0lacOu3s8/9SJtqqsp0EFDQIgF3cwtki04h1KQdj0wG/ByUhKT
         Sq9w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770766877; x=1771371677; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=udnAXYhV8NVH9LmStk7ouTFsolaMp28MpPWhOY0c84I=;
        b=yiw1bWPU+msQNzpqEkhBAYp5jBr01kwpYmxvbcsY0yrg8HfLGbAdPjAoyl5aeo+4TV
         APtvomyAofqe5X+j729UDaTz6WaGnNIRw8v9FOspS3iGCsFvqh1MnIaRs4kXrhPoJb14
         Jqdn0z1UE6hQDgZU1TmdDFeicYg9PEOpTw439UgRdK78Mvzietk4QnhEZJE53yoZkaHm
         TBx83FW6t+gl0lvyc50Lpk6f4lXKltGtdRaDhk8+lpYmAgtwoloAKh6fOHqGenboL6eV
         xHvgku+t0VaAuJkXM47VkmDFTeN5z/lFGPGH4grt0/vCH5RRGFavfzRtajn60s//l6t4
         cIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770766877; x=1771371677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=udnAXYhV8NVH9LmStk7ouTFsolaMp28MpPWhOY0c84I=;
        b=KzpzINEmktG1/OJvNRVASZqUD2zkWZvd/iQdnqKxA5JgFx8ChWj2OFfILtj7xIxOrE
         V/I+tB+9o4zOnl0Hhkjsn1Hmok20H1N6nFZuL2Y0pdMxc2+/z3Zl3GmnfH+ZNNDl/rvB
         3iU4av78b6s5jQspuhrEGpy55teDrl1MAFahg52RFJWGhp8aIht58n1iXuYsUQMh39zv
         ljrPXqT34rBWKVMrAGxLjkYMToE/x6J1PYhB20abTGYcSWhBgzIsVvmHtUXYa03KI/0z
         i5X5ghziNpikEUsVY8WLbGKevL4APfQiqJIAJNYql8kvQMpoqCn75yCW+gCNNZVKRkvu
         VRyw==
X-Forwarded-Encrypted: i=1; AJvYcCUFe60w/5QQDhaWzAY1VU0McDR5gEwT6eZkaoq73NUv7tJC08Sddd7yVOI/dfj05aIuOuU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw40tQEqFeGzVhMMwQEuvZvR/d8ylYHIgTpZCbUwgw+fDgN7M1u
	MR6BBSRaHL7RqPS8OcaO58voR2JlSBS4cWWJkO6jKcjCUOZonyXjrtppuJBT9RINFm+jqoZYtqG
	u3KDWP3J7ZWbCNxezn4JfEb4nkKflJWvKfqc0ub9G
X-Gm-Gg: AZuq6aIMUZIvk5hw5JZJDl/AhsijSC/QafH/URYcSukDQMonQvpkPl2D3RU45snV1n6
	q8RmBWOdHXHyuQ0EFSpfjOxfm+jj3GBdWyVUst6G3pMyJHFRKLEk44/Xxnhr/HuTxYXDsCVBhwo
	C4jIPERox9PbCvDqjGthvMWBp5qiwy3SW6WNdqjTw5ArAR2/xtclAd2wqniuDwk4W+jCwzlmmuu
	3xJagqpehUhvolqte4ON/H3kF8LT5A6kSWa5bpb1bWvUHIEDqSAkmem7iZiwnYBPdGf5n74Sofc
	dY2jxg==
X-Received: by 2002:a05:622a:138c:b0:503:4bc:c925 with SMTP id
 d75a77b69052e-50682758209mr2319781cf.13.1770766876608; Tue, 10 Feb 2026
 15:41:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260209220849.2126486-1-surenb@google.com> <CAG48ez2zFfCO7RKhHKaATFge7DWzaTfO+Yta0y4_HXGHZAtkqw@mail.gmail.com>
In-Reply-To: <CAG48ez2zFfCO7RKhHKaATFge7DWzaTfO+Yta0y4_HXGHZAtkqw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 10 Feb 2026 15:41:05 -0800
X-Gm-Features: AZwV_QjArW2JodMN7wRauZ3Ugy-7cBqUa9oRhicJr9JxwV2UIkPUp8XXpXf8gmc
Message-ID: <CAJuCfpGKoy2Aj9f-gfKDmsa5wWvv9=b3mS6hRgaADQGrd8dYEQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: replace vma_start_write() with vma_start_write_killable()
To: Jann Horn <jannh@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, mhocko@suse.com, 
	pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, 
	mpe@ellerman.id.au, chleroy@kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70811-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[33];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[surenb@google.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[linux-foundation.org,infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,oracle.com,redhat.com,arm.com,linux.dev,suse.cz,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 24D0D120236
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 1:19=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
>
> On Mon, Feb 9, 2026 at 11:08=E2=80=AFPM Suren Baghdasaryan <surenb@google=
.com> wrote:
> > Now that we have vma_start_write_killable() we can replace most of the
> > vma_start_write() calls with it, improving reaction time to the kill
> > signal.
> [...]
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index dbd48502ac24..3de7ab4f4cee 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> [...]
> > @@ -1808,7 +1817,11 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigne=
d long, start, unsigned long, le
> >                         break;
> >                 }
> >
> > -               vma_start_write(vma);
> > +               if (vma_start_write_killable(vma)) {
> > +                       err =3D -EINTR;
>
> Doesn't this need mpol_put(new)? Or less complicated, move the
> vma_start_write_killable() up to somewhere above the mpol_dup() call.

Thanks for the review, Jann!

Yes you are right. I'll move it before mpol_dup().

>
> > +                       break;
> > +               }
> > +
> >                 new->home_node =3D home_node;
> >                 err =3D mbind_range(&vmi, vma, &prev, start, end, new);
> >                 mpol_put(new);
> [...]
> > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > index a94c401ab2cf..dc9f7a7709c6 100644
> > --- a/mm/pagewalk.c
> > +++ b/mm/pagewalk.c
> > @@ -425,14 +425,13 @@ static inline void process_mm_walk_lock(struct mm=
_struct *mm,
> >                 mmap_assert_write_locked(mm);
> >  }
> >
> > -static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> > +static inline int process_vma_walk_lock(struct vm_area_struct *vma,
> >                                          enum page_walk_lock walk_lock)
> >  {
> >  #ifdef CONFIG_PER_VMA_LOCK
> >         switch (walk_lock) {
> >         case PGWALK_WRLOCK:
> > -               vma_start_write(vma);
> > -               break;
> > +               return vma_start_write_killable(vma);
>
> There are two users of PGWALK_WRLOCK in arch/s390/mm/gmap.c code that
> don't check pagewalk return values, have you checked that they are not
> negatively affected by this new possible error return?

Uh, even the ones which check for the error like queue_pages_range()
don't seem to handle it well. I'll split this part into a separate
patch as I think it will be sizable and will go over all users to
ensure they handle the new error.

>
> >         case PGWALK_WRLOCK_VERIFY:
> >                 vma_assert_write_locked(vma);
> >                 break;
> [...]
> > diff --git a/mm/vma.c b/mm/vma.c
> > index be64f781a3aa..3cfb81b3b7cf 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -540,8 +540,12 @@ __split_vma(struct vma_iterator *vmi, struct vm_ar=
ea_struct *vma,
> >         if (new->vm_ops && new->vm_ops->open)
> >                 new->vm_ops->open(new);
> >
> > -       vma_start_write(vma);
> > -       vma_start_write(new);
> > +       err =3D vma_start_write_killable(vma);
> > +       if (err)
> > +               goto out_fput;
> > +       err =3D vma_start_write_killable(new);
> > +       if (err)
> > +               goto out_fput;
>
> What about the new->vm_ops->open() call and the anon_vma_clone()
> above? I don't think the error path properly undoes either. These
> calls should probably be moved further up, so that the point of no
> return in this function stays where it was.

Ack.

>
> >         init_vma_prep(&vp, vma);
> >         vp.insert =3D new;
> [...]
> > @@ -1155,10 +1168,12 @@ int vma_expand(struct vma_merge_struct *vmg)
> >         struct vm_area_struct *next =3D vmg->next;
> >         bool remove_next =3D false;
> >         vm_flags_t sticky_flags;
> > -       int ret =3D 0;
> > +       int ret;
> >
> >         mmap_assert_write_locked(vmg->mm);
> > -       vma_start_write(target);
> > +       ret =3D vma_start_write_killable(target);
> > +       if (ret)
> > +               return ret;
> >
> >         if (next && target !=3D next && vmg->end =3D=3D next->vm_end)
> >                 remove_next =3D true;
> > @@ -1186,17 +1201,19 @@ int vma_expand(struct vma_merge_struct *vmg)
> >          * Note that, by convention, callers ignore OOM for this case, =
so
> >          * we don't need to account for vmg->give_up_on_mm here.
> >          */
> > -       if (remove_next)
> > +       if (remove_next) {
> > +               ret =3D vma_start_write_killable(next);
> > +               if (ret)
> > +                       return ret;
> >                 ret =3D dup_anon_vma(target, next, &anon_dup);
> > +       }
> >         if (!ret && vmg->copied_from)
> >                 ret =3D dup_anon_vma(target, vmg->copied_from, &anon_du=
p);
> >         if (ret)
> >                 return ret;
>
> nit: the control flow here is kinda chaotic, with some "if (ret)
> return ret;" mixed with "if (!ret && ...) ret =3D ...;".

I'll see what I can do about it but probably as a separate patch.

>
> >
> > -       if (remove_next) {
> > -               vma_start_write(next);
> > +       if (remove_next)
> >                 vmg->__remove_next =3D true;
> > -       }
> >         if (commit_merge(vmg))
> >                 goto nomem;
> >
> [...]
> > @@ -2211,9 +2240,8 @@ int mm_take_all_locks(struct mm_struct *mm)
> >          * is reached.
> >          */
> >         for_each_vma(vmi, vma) {
> > -               if (signal_pending(current))
> > +               if (vma_start_write_killable(vma))
> >                         goto out_unlock;
> > -               vma_start_write(vma);
>
> nit: might want to keep the signal_pending() so that this can sort of
> be interrupted by non-fatal signals, which seems to be the intention

Yes, I will bring back that check.

>
> >         }
> >
> >         vma_iter_init(&vmi, mm, 0);
> > @@ -2549,7 +2577,9 @@ static int __mmap_new_vma(struct mmap_state *map,=
 struct vm_area_struct **vmap)
> >  #endif
> >
> >         /* Lock the VMA since it is modified after insertion into VMA t=
ree */
> > -       vma_start_write(vma);
> > +       error =3D vma_start_write_killable(vma);
> > +       if (error)
> > +               goto free_iter_vma;
>
> This seems way past the point of no return, we've already called the
> ->mmap() handler which I think means removing the VMA again would
> require a ->close() call. The VMA should be locked further up if we
> want to do it killably.

Yeah, I realized this big issue after posting the patch. Moving it up
seems possible, so I'll try that.

Thanks,
Suren.

>
> >         vma_iter_store_new(vmi, vma);
> >         map->mm->map_count++;
> >         vma_link_file(vma, map->hold_file_rmap_lock);
> >

