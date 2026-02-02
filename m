Return-Path: <kvm+bounces-69910-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MMwWLiAWgWlsEAMAu9opvQ
	(envelope-from <kvm+bounces-69910-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 22:24:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 182D6D1A46
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 22:24:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 37C3D304FC10
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 21:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F68930EF80;
	Mon,  2 Feb 2026 21:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MIDUg233";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fJ90rynq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199961E7C18
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 21:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770067406; cv=none; b=dspgfCgViCu2z8kESC3WV/0r429Xkm3Ehz7EkKfTNTKCNrKZ7DvYEbkAtzzbdKVSp2fAyMBw1UCTT3uM4WxhoNDHtAaRGXYsA/GAQq4Rudiu412DpsaWWYiH4LHyczyRTwUhGu7rpPQMIWCpV/9KZntfJVM4DoMiO530/oqEOXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770067406; c=relaxed/simple;
	bh=lOs0xccYEQWyLRuzUgVsgIemarRJDZYE7WIRrqIMQgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Se0RpfIfb5sYpmOS/Hwvx5uBys/2Ptc4XjRVICNHAoVR7AV2Z548DEvqFKtlCYpC52dATmDYBar77ez3b44u5JGTEGIiVXEKBkSK2oqZQzHoO28SELbf0+P8gr/MteesCLJqSSBfpI+Hwpm3KVQfZ15TcB1Jwurl1GnPTUITs3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MIDUg233; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fJ90rynq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770067403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TAkCddEGgJt8HRpnmblWaVWehXrqOQRfOa3v8YeWJbE=;
	b=MIDUg233Jox8hSC9XwCr43H3D2mUCg0bTp3qhs4HVu/EzGtdG7+SwrqLZ6Uzphz8I7rRmD
	9Yd018UsP+et6wmQrkxg6Lqb5UZgWjzO+v2Ljtsop/5XwIrZubiab4dsAhZJFlr3iwlu5A
	qTmlC4o2InHfwaD0X4t24pPJRStGJUE=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-1PRMN2vbNACrOde-xG7tdg-1; Mon, 02 Feb 2026 16:23:22 -0500
X-MC-Unique: 1PRMN2vbNACrOde-xG7tdg-1
X-Mimecast-MFC-AGG-ID: 1PRMN2vbNACrOde-xG7tdg_1770067401
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-502a4aca949so248979511cf.2
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 13:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770067401; x=1770672201; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TAkCddEGgJt8HRpnmblWaVWehXrqOQRfOa3v8YeWJbE=;
        b=fJ90rynqHQiBCr/Yh8cLBRvzGpRh+KTbVV1vyb7C7INvlMoxcWrSBidpvjvmN/zd2z
         5YKCfrOTOqevJqrluFImTPKZ4YvsJNHK8bvnH0qsEPcCavmtj8C5lyrWB1ILw36QkO2S
         7uJhDUmGTVFKgqmVVmw+yH/lG8xIKr897vI74BMHWRWWh6Y1BJIizil4dH7P5VlOc0yz
         TI4SyfjTKuV5UrG2pdOC6UUPZohdr4+jHlPRagGPvjZAsd39Ww0KAXTSNb2rMcJqRnSl
         Fu278Ev+EknjdiGOr4zPd/fT1AmTXdX/OD8/SinfA6ZZ1OkNoVq7mcGy69adEKteXWc5
         g02A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770067401; x=1770672201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TAkCddEGgJt8HRpnmblWaVWehXrqOQRfOa3v8YeWJbE=;
        b=ENhTfFxI4L97yv6dnsFMtWygmR4zIzfSyrxGdAA8WeowH1iXO0A8FOltDcQ9H0Nfsu
         DJ7KSxz02YMfmzQKaHJZgJBTRi5gujSbhgDPUwp8IWT8MJZoJKujMcjI4LR/+AUQNMhj
         dDpjBVCYjttgZF9Cz0og/QZCWqYac6RXeR7wqWpZdX+KI71qFzHDA/zKPUfpQZ9cnjmt
         /JTLdALphWJu0xX7L3unTTfFs/skvbQgXzgLUrx2lf8iAl6Mlzo5eYH1WlKKBCURDqeY
         Ob04z7pljL3coW446WPIas8bXw5mfkHbsH3wO1A5UeffKdRLzXi+0kCGupkm18rzrEgV
         vvCw==
X-Forwarded-Encrypted: i=1; AJvYcCVuEbqdvUdnCAgXYs+cBzNrfG8AY1LfohJnfMlWAF+gSVNAQLJT4tFPtmDnaVamHSaFJSo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIY1meTwvd04tq4dPOZ8tozjWNF5x/iuLO0Gn47YdyI8tHc19g
	ddxnLbAoJVKInOeb/9W+QT7f5J9Jr//15BC2oTS0+OL9BlrBo4HnKoNSwmNj4O/HbqXVrzXR5qI
	GVg4E1vl+nInMGjd5WY1JMe4wWYZ9wfXBzANiFIVvp9xpmy2sRKi9qA==
X-Gm-Gg: AZuq6aKRMihQ7KvVLFQd76/5mMhtcyAYdDU1/gGMBHiTQR4TxynSO2NG1y40em2Juo5
	Jf7px5iA436M6kHN9b8hFE3ypSBr9ArmGOj8phh25AdYMYlnxyfG1BFd6BY6t26vWgwrhZqemAH
	vHJ8tv9vusT1drXljZ5xO72HqcJUBm5e3ku14ozwXTB0vkUvejzSdz/gGt/RjuwzTIJ4Qfc9b36
	iPFdA3oNqoUVVThigtAYfTvkOnl8inZrHEXuf3sWAeJGYA5UzJSVE22IIysaazEadTwURcWQ/de
	B5p47ZhYNaky0/o7SFUtoEUNSMODHWBHy1QTl562ASKwAio9qhZFLP1xGfr0BWURevaq4ZtxKVQ
	s9bI=
X-Received: by 2002:ac8:7e8f:0:b0:501:49f9:7488 with SMTP id d75a77b69052e-505d228ac65mr175015011cf.49.1770067400559;
        Mon, 02 Feb 2026 13:23:20 -0800 (PST)
X-Received: by 2002:ac8:7e8f:0:b0:501:49f9:7488 with SMTP id d75a77b69052e-505d228ac65mr175014571cf.49.1770067399931;
        Mon, 02 Feb 2026 13:23:19 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711d2847asm1309038885a.34.2026.02.02.13.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 13:23:19 -0800 (PST)
Date: Mon, 2 Feb 2026 16:23:16 -0500
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 05/17] userfaultfd: retry copying with locks dropped
 in mfill_atomic_pte_copy()
Message-ID: <aYEVxD_vY-qimMNL@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-6-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260127192936.1250096-6-rppt@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69910-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,x1.local:mid]
X-Rspamd-Queue-Id: 182D6D1A46
X-Rspamd-Action: no action

Hi, Mike,

On Tue, Jan 27, 2026 at 09:29:24PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Implementation of UFFDIO_COPY for anonymous memory might fail to copy
> data data from userspace buffer when the destination VMA is locked
> (either with mm_lock or with per-VMA lock).
> 
> In that case, mfill_atomic() releases the locks, retries copying the
> data with locks dropped and then re-locks the destination VMA and
> re-establishes PMD.
> 
> Since this retry-reget dance is only relevant for UFFDIO_COPY and it
> never happens for other UFFDIO_ operations, make it a part of
> mfill_atomic_pte_copy() that actually implements UFFDIO_COPY for
> anonymous memory.
> 
> shmem implementation will be updated later and the loop in
> mfill_atomic() will be adjusted afterwards.

Thanks for the refactoring.  Looks good to me in general, only some
nitpicks inline.

> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/userfaultfd.c | 70 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 46 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 45d8f04aaf4f..01a2b898fa40 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -404,35 +404,57 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
>  	return ret;
>  }
>  
> +static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
> +{
> +	unsigned long src_addr = state->src_addr;
> +	void *kaddr;
> +	int err;
> +
> +	/* retry copying with mm_lock dropped */
> +	mfill_put_vma(state);
> +
> +	kaddr = kmap_local_folio(folio, 0);
> +	err = copy_from_user(kaddr, (const void __user *) src_addr, PAGE_SIZE);
> +	kunmap_local(kaddr);
> +	if (unlikely(err))
> +		return -EFAULT;
> +
> +	flush_dcache_folio(folio);
> +
> +	/* reget VMA and PMD, they could change underneath us */
> +	err = mfill_get_vma(state);
> +	if (err)
> +		return err;
> +
> +	err = mfill_get_pmd(state);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
>  static int mfill_atomic_pte_copy(struct mfill_state *state)
>  {
> -	struct vm_area_struct *dst_vma = state->vma;
>  	unsigned long dst_addr = state->dst_addr;
>  	unsigned long src_addr = state->src_addr;
>  	uffd_flags_t flags = state->flags;
> -	pmd_t *dst_pmd = state->pmd;
>  	struct folio *folio;
>  	int ret;
>  
> -	if (!state->folio) {
> -		ret = -ENOMEM;
> -		folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, dst_vma,
> -					dst_addr);
> -		if (!folio)
> -			goto out;
> +	folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, state->vma, dst_addr);
> +	if (!folio)
> +		return -ENOMEM;
>  
> -		ret = mfill_copy_folio_locked(folio, src_addr);
> +	ret = -ENOMEM;
> +	if (mem_cgroup_charge(folio, state->vma->vm_mm, GFP_KERNEL))
> +		goto out_release;
>  
> +	ret = mfill_copy_folio_locked(folio, src_addr);
> +	if (unlikely(ret)) {
>  		/* fallback to copy_from_user outside mmap_lock */
> -		if (unlikely(ret)) {
> -			ret = -ENOENT;
> -			state->folio = folio;
> -			/* don't free the page */
> -			goto out;
> -		}
> -	} else {
> -		folio = state->folio;
> -		state->folio = NULL;
> +		ret = mfill_copy_folio_retry(state, folio);

Yes, I agree this should work and should avoid the previous ENOENT
processing that might be hard to follow.  It'll move the complexity into
mfill_state though (e.g., now it's unknown on the vma lock state after this
function returns..), but I guess it's fine.

> +		if (ret)
> +			goto out_release;
>  	}
>  
>  	/*
> @@ -442,17 +464,16 @@ static int mfill_atomic_pte_copy(struct mfill_state *state)
>  	 */
>  	__folio_mark_uptodate(folio);

Since success path should make sure vma lock held when reaching here, but
now with mfill_copy_folio_retry()'s presence it's not as clear as before,
maybe we add an assertion for that here before installing ptes?  No strong
feelings.

>  
> -	ret = -ENOMEM;
> -	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
> -		goto out_release;
> -
> -	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> +	ret = mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
>  				       &folio->page, true, flags);
>  	if (ret)
>  		goto out_release;
>  out:
>  	return ret;
>  out_release:
> +	/* Don't return -ENOENT so that our caller won't retry */
> +	if (ret == -ENOENT)
> +		ret = -EFAULT;

I recall the code removed is the only path that can return ENOENT?  Then
maybe this line isn't needed?

>  	folio_put(folio);
>  	goto out;
>  }
> @@ -907,7 +928,8 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  			break;
>  	}
>  
> -	mfill_put_vma(&state);
> +	if (state.vma)

I wonder if we should move this check into mfill_put_vma() directly, it
might be overlooked if we'll put_vma in other paths otherwise.

> +		mfill_put_vma(&state);
>  out:
>  	if (state.folio)
>  		folio_put(state.folio);
> -- 
> 2.51.0
> 

-- 
Peter Xu


