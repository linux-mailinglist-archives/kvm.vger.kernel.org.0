Return-Path: <kvm+bounces-70801-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iK/7Ouegi2l1XQAAu9opvQ
	(envelope-from <kvm+bounces-70801-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 22:19:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F66211F5BD
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 22:19:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 605C63019D46
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAF65338F45;
	Tue, 10 Feb 2026 21:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MxNn5Hls"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC61328B7B
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 21:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770758367; cv=pass; b=Nfsmr5MXDs8o2qcVLzTy3YAkaO7SNxxpkTRGXxgtkhBiPnZ6w7HOI/GqAxj3vz3yS5Svvd/anhjAbEWunEBQ1NFohpGJtmUBmwyP+jtlvXOwMQw5d9CZm04y/jAX9MDsIf5NsSodpsNT+Ei5ONRO6Y2+XJlluI2HjwhIhTrXzYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770758367; c=relaxed/simple;
	bh=+LaNhwPFeD1BT8BG86YL8wzmJ/KKkGGhFp/e5ms9N/A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f0GlH9PVHGWVPj5fM/FlPvXvbztoN7jNlddp31FoNyVry5OstWwMrPjuaHPmqQNBxPn0P7Lpf355pmnsH2P4TUGJz14Kq9d/GbLkHIirzwN5ffr7iO8VqlhyvmnIF+xtqh4FaJfMpxxrA5mOV0fIOujiNo2r2uw6Ikk/ekIZfSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MxNn5Hls; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65a38c42037so943a12.0
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 13:19:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770758364; cv=none;
        d=google.com; s=arc-20240605;
        b=RCW25rALyi5xmjv8MrfY84h4uxFaXtRVweImtSoiroVxIjKsl/2JoNRoXkl2PkMKwK
         zLJ791aWXDi4IYkRun56UcM4q6TVZTMlQS3r3QjzKJG38I1su7wU6hQOMGx00LfYJ/XU
         4sIKhxQ3Z4YzGIGxPx0HKqSPA5/+vh0WVG5wyQMdDoXeO9GYnD2/3sHq9gpQDT/zol0y
         Qs3MJa4YW27FtvrkRDpUGXYiXOv0Z4UP2p27VPHv4SNxbzcaeWDTndrkmWQkd2Hl7aIP
         +/KAGZiXIcX0AHrK9Ikq0bUXBa644DktTbVIwDZZf03bhOAN4IYw2mH2H2Q1pP15WWiu
         Zgpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7ueb2XLAZgSMqdZ7FzkgHkbOJxEx/nDgdsJxz5kcjsQ=;
        fh=1rlUv1a7I+zBYkzkuMPxA5lbdjvFqgkLrtk96zKZsF0=;
        b=LaQ5O1UYQNBOLaNFNXwfIK/PHBHTiyOIXKVMepBce+gyLvUOnWy2yugY0FlWjmrIEM
         oL7iP/+Ml/bLjtA9S46VzRym5IRdBXqlZ1aaksdsln0/uPA54rVq2dOaDnwitb0YN5Fd
         hpuyHwYiBhDntV5y1gv4NdWm2wQ16mrFYHmTj9Ur2orbNK54gTUVF6jSLn57Hzx8UaM6
         JrIKdpcv3S+kkU+zdWl/1TWIzXRCiC3T2qvAfcR/Ut23cPJumsQSYHct32IDVpXSeDiF
         8Zhf1B5qKZB12O4rmSUeJrQJeNQN5dS0IQhMlzhZ8qkMzKrczM544Py5yJP8KyKeR+jU
         FzWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770758364; x=1771363164; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ueb2XLAZgSMqdZ7FzkgHkbOJxEx/nDgdsJxz5kcjsQ=;
        b=MxNn5HlsHMhJFbhTT8HfzhqtAjgnQ0MqYNNrYG+lZpI6RwzbzeefsZq8eypKBF5y3a
         eA3kfew2ceKx+HmmrkyavBzLjHGcyk4VTVsfS+k0GEg5MRHEduvkiSoJj255UEDyKKlB
         oC+MlC6eP7CMDAJxRWo8sl7KdqQezG++8mr7FyYiEoTY0EpAjXVlLUPSiQW/9NbAGjmx
         Wn7Ll8vIYhnTkjsOy7V3gN+LkQfkXXcndIusR1T73zwyhAXrl05X/BVnwdZhH/y8s/Gd
         25KqjjNtma7v49zvc3Rcp5MnkTmdGkqfYHv3HmSu0rL+xY1Dl4MuFy26bs7gM6RRGGiK
         zN2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770758364; x=1771363164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7ueb2XLAZgSMqdZ7FzkgHkbOJxEx/nDgdsJxz5kcjsQ=;
        b=ZNDfz2PxdC2rn3uM9FRQqb7C/GAzFfh8z94/6Ak/W5roBJckus4k9cxYrr69brUZpn
         J3icbuJ+VkVxiBAiAESFo9DqmhXByT23ZlhM52MOgSVbxErX3aMHhvIwdXP5s4B9cLXx
         zlaOhDAD5BYaR5fy7GF60zLLM5dYJqtG5Ad0oMLQXXgkaouB+VKCMv9Lg4hdghK/lUpu
         iXmnDWRD2mKjRlOW5Cx5PZSMcODacTrF9vebmSEACJwPISO10+J4XTPuGpb7kDepUBae
         9Y3bX/bZr7ngNMrz3LUkopEN+XRlKgPNmkwUZ+cfDBeGvdsQjABOTHwOp5VHGnrgokuU
         wK7g==
X-Forwarded-Encrypted: i=1; AJvYcCUzwO6Vm2Nz2IcaPMRjaYsj7JO3BOheJFQ3NPQVw2wX1RHPz3+EdrdosM2t71ibqdIZNrA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPkqk7WIu32l8Dft0abixvelSQ5MU0YwI0mJJfLjv8mxokuRmI
	FDBtL41BGl5/fmGuxQyFOazdKt6jyb458OL7q4TqQ6dgQV1bau6rsn1dPQDgGyK+Iov0x1/XeO0
	ev8wHfDqX73/6csp05A9naBvyWOiUy8LsidMvEtRE
X-Gm-Gg: AZuq6aIuv7DpWi6kQMcqA0Ht+nQAFhlUnxsQgtNgjjgXtuvjLh8M+SR+GcQy+/Y42z7
	s/MIVl3DJbiX+0Grb6BLn7pbmZieZYiugiEdNlHdfAVDt954khJcCqKizhsmjEOeOiAcgFvTVaW
	AIl5FTNx7n8GawhgOyFYypC2XU5QrxFJE3EURt2HTWA4GhMUwAQT4ySCtVWQFfovYPvNFfZEDc6
	XhxQ6V54xqzXBrLjbjaFeKmzuEC/zkcjmhjLO+MD3fZCdpg8BRSeF55cHM8aOat+8ipychOw4fY
	ZBM7FvYvrnlriG14N2BEK1Hmg1l6EmAo/qb5
X-Received: by 2002:a05:6402:8cf:b0:659:7696:432c with SMTP id
 4fb4d7f45d1cf-65a390b5a13mr6380a12.16.1770758363456; Tue, 10 Feb 2026
 13:19:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260209220849.2126486-1-surenb@google.com>
In-Reply-To: <20260209220849.2126486-1-surenb@google.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 10 Feb 2026 22:18:47 +0100
X-Gm-Features: AZwV_Qj1nCcIQNkC6tpOVx93iwKZtT2dbqwR4XsX_m7M7cfMNKnVzbH_C365zC4
Message-ID: <CAG48ez2zFfCO7RKhHKaATFge7DWzaTfO+Yta0y4_HXGHZAtkqw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: replace vma_start_write() with vma_start_write_killable()
To: Suren Baghdasaryan <surenb@google.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70801-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[33];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jannh@google.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[linux-foundation.org,infradead.org,kernel.org,nvidia.com,intel.com,gmail.com,sk.com,gourry.net,linux.alibaba.com,oracle.com,redhat.com,arm.com,linux.dev,suse.cz,suse.com,suse.de,linux.ibm.com,ellerman.id.au,kvack.org,lists.ozlabs.org,vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 8F66211F5BD
X-Rspamd-Action: no action

On Mon, Feb 9, 2026 at 11:08=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
> Now that we have vma_start_write_killable() we can replace most of the
> vma_start_write() calls with it, improving reaction time to the kill
> signal.
[...]
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index dbd48502ac24..3de7ab4f4cee 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
[...]
> @@ -1808,7 +1817,11 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned =
long, start, unsigned long, le
>                         break;
>                 }
>
> -               vma_start_write(vma);
> +               if (vma_start_write_killable(vma)) {
> +                       err =3D -EINTR;

Doesn't this need mpol_put(new)? Or less complicated, move the
vma_start_write_killable() up to somewhere above the mpol_dup() call.

> +                       break;
> +               }
> +
>                 new->home_node =3D home_node;
>                 err =3D mbind_range(&vmi, vma, &prev, start, end, new);
>                 mpol_put(new);
[...]
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index a94c401ab2cf..dc9f7a7709c6 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -425,14 +425,13 @@ static inline void process_mm_walk_lock(struct mm_s=
truct *mm,
>                 mmap_assert_write_locked(mm);
>  }
>
> -static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> +static inline int process_vma_walk_lock(struct vm_area_struct *vma,
>                                          enum page_walk_lock walk_lock)
>  {
>  #ifdef CONFIG_PER_VMA_LOCK
>         switch (walk_lock) {
>         case PGWALK_WRLOCK:
> -               vma_start_write(vma);
> -               break;
> +               return vma_start_write_killable(vma);

There are two users of PGWALK_WRLOCK in arch/s390/mm/gmap.c code that
don't check pagewalk return values, have you checked that they are not
negatively affected by this new possible error return?

>         case PGWALK_WRLOCK_VERIFY:
>                 vma_assert_write_locked(vma);
>                 break;
[...]
> diff --git a/mm/vma.c b/mm/vma.c
> index be64f781a3aa..3cfb81b3b7cf 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -540,8 +540,12 @@ __split_vma(struct vma_iterator *vmi, struct vm_area=
_struct *vma,
>         if (new->vm_ops && new->vm_ops->open)
>                 new->vm_ops->open(new);
>
> -       vma_start_write(vma);
> -       vma_start_write(new);
> +       err =3D vma_start_write_killable(vma);
> +       if (err)
> +               goto out_fput;
> +       err =3D vma_start_write_killable(new);
> +       if (err)
> +               goto out_fput;

What about the new->vm_ops->open() call and the anon_vma_clone()
above? I don't think the error path properly undoes either. These
calls should probably be moved further up, so that the point of no
return in this function stays where it was.

>         init_vma_prep(&vp, vma);
>         vp.insert =3D new;
[...]
> @@ -1155,10 +1168,12 @@ int vma_expand(struct vma_merge_struct *vmg)
>         struct vm_area_struct *next =3D vmg->next;
>         bool remove_next =3D false;
>         vm_flags_t sticky_flags;
> -       int ret =3D 0;
> +       int ret;
>
>         mmap_assert_write_locked(vmg->mm);
> -       vma_start_write(target);
> +       ret =3D vma_start_write_killable(target);
> +       if (ret)
> +               return ret;
>
>         if (next && target !=3D next && vmg->end =3D=3D next->vm_end)
>                 remove_next =3D true;
> @@ -1186,17 +1201,19 @@ int vma_expand(struct vma_merge_struct *vmg)
>          * Note that, by convention, callers ignore OOM for this case, so
>          * we don't need to account for vmg->give_up_on_mm here.
>          */
> -       if (remove_next)
> +       if (remove_next) {
> +               ret =3D vma_start_write_killable(next);
> +               if (ret)
> +                       return ret;
>                 ret =3D dup_anon_vma(target, next, &anon_dup);
> +       }
>         if (!ret && vmg->copied_from)
>                 ret =3D dup_anon_vma(target, vmg->copied_from, &anon_dup)=
;
>         if (ret)
>                 return ret;

nit: the control flow here is kinda chaotic, with some "if (ret)
return ret;" mixed with "if (!ret && ...) ret =3D ...;".

>
> -       if (remove_next) {
> -               vma_start_write(next);
> +       if (remove_next)
>                 vmg->__remove_next =3D true;
> -       }
>         if (commit_merge(vmg))
>                 goto nomem;
>
[...]
> @@ -2211,9 +2240,8 @@ int mm_take_all_locks(struct mm_struct *mm)
>          * is reached.
>          */
>         for_each_vma(vmi, vma) {
> -               if (signal_pending(current))
> +               if (vma_start_write_killable(vma))
>                         goto out_unlock;
> -               vma_start_write(vma);

nit: might want to keep the signal_pending() so that this can sort of
be interrupted by non-fatal signals, which seems to be the intention

>         }
>
>         vma_iter_init(&vmi, mm, 0);
> @@ -2549,7 +2577,9 @@ static int __mmap_new_vma(struct mmap_state *map, s=
truct vm_area_struct **vmap)
>  #endif
>
>         /* Lock the VMA since it is modified after insertion into VMA tre=
e */
> -       vma_start_write(vma);
> +       error =3D vma_start_write_killable(vma);
> +       if (error)
> +               goto free_iter_vma;

This seems way past the point of no return, we've already called the
->mmap() handler which I think means removing the VMA again would
require a ->close() call. The VMA should be locked further up if we
want to do it killably.

>         vma_iter_store_new(vmi, vma);
>         map->mm->map_count++;
>         vma_link_file(vma, map->hold_file_rmap_lock);
>

