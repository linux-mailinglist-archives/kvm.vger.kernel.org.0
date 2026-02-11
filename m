Return-Path: <kvm+bounces-70891-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kHykJorajGlIuAAAu9opvQ
	(envelope-from <kvm+bounces-70891-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 20:37:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A0B4127338
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 20:37:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2E63C3016911
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 19:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A15913542D8;
	Wed, 11 Feb 2026 19:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ihwN/HIR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="J+MuA8SH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB2F352F92
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 19:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770838652; cv=none; b=TPzdaUxs1bUC06D6VQ64TIdroVTJxmD+Bm9ffD+tVcrLF+5lixB6OEaCwMYQnr2ryyTTP67K05N3830IQnXeW1nmcVWwFZ5P3hEbK6srdVk3/wSS9xrCm0G161WhV6op+QaH3FmfqyfweXx0gzoQ42rt6E6ErcKZphu1Xcyt7zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770838652; c=relaxed/simple;
	bh=9E8xym4kPqUtQ4zv5yeII+4X0aDlSLDVsQXEk9VD660=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u2fHkNE1hNiRyXT1cAi5mlKh9uBVKY4ovGKtptz+IeZ+grI4AnoXhaQoJssfveyRI9fw1YJHg9X8iCL4KPkfGE6rm/CkP1vffApJDFbiJAMF7ra+TPivb1FA2L87feGryDxMa2QJeA2d5fP9XvhlEi1TxAKCrTB4XgxmsmdYUso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ihwN/HIR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=J+MuA8SH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770838650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3HnSln6BmAeJW+dBA3yyxX0sDcUZ80hLGHPfC7uKPVU=;
	b=ihwN/HIRHg+g6mpBpmGJ8eY6bzSpWKrv+syfIgYaD/dsg/zzxCkpNZwLaFRTszNuyXFCUF
	xz0CF3gR+EmOukogDW4fSjaO+sWWWEvg0LUdwfyKvwx/oIV6CnMO/q6pWBG3l9lIWVl8Qq
	Ed7b+o8Bm9G+HW3QhZSeSgLzjXIg8as=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-H-I3N9KAOpmlU6_wbmUbFQ-1; Wed, 11 Feb 2026 14:37:29 -0500
X-MC-Unique: H-I3N9KAOpmlU6_wbmUbFQ-1
X-Mimecast-MFC-AGG-ID: H-I3N9KAOpmlU6_wbmUbFQ_1770838649
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-50336ebabe0so52096571cf.1
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 11:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770838649; x=1771443449; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3HnSln6BmAeJW+dBA3yyxX0sDcUZ80hLGHPfC7uKPVU=;
        b=J+MuA8SHYGyELefHY2x7cOLzx67VNAKone7JYxXA7217PwFt94YzzuSs16VE6897Jn
         qpUAhSRKrS5xZRCdkp7VR/uOxMFW1zGoMz1lkyYkWJxz9Uod17sJD4di5Mnkipokpf1W
         8hKU4yxDQLF4SWACdXLnWFua5UoQkgrYn3PWpCGRes6AXA56PQhGLv3RwGgDax298ULt
         7Uo+yEllsuuBsD+nkoeEktYUIjaxeUOdo6VeTcZY5kQls3NbBisNf4190cX+B+/LDwbZ
         UP8oO6rJ/TCQyCw1DTtGW+2Pp4TUwDm9z2YnNaJzt1cXcChd9Y+uziYwN0SIYkaM1OMO
         hXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770838649; x=1771443449;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3HnSln6BmAeJW+dBA3yyxX0sDcUZ80hLGHPfC7uKPVU=;
        b=pOSp9LWeF4SUAkqE8CC18yJ1HouU8SrfrpyxgPerewehZ/Qm+x5jX6AYHFwsRyJpbj
         2V1zJK4Cb03GFqJPwGvNuMp+ybAOe+yMO3rChKl36CzCXDosHj99AeTIdd4ZeMCpHBgL
         mO8GwdNQbSa7g4gXQktWQWD9h5+2Kk8TOL2w3zgm4eTjRld49JoY3MYpjvCzgtHPhCgX
         h0WXokkzTfobVNFUYBqIhQEzNEBsclmhP4u1rasdVicLE2842QFWTWhOkWjvlUUEAg4Q
         wfwrvoF0tbOgDqADHdIhDx73xyP+tYLi/+jOzgMpqtr+9oHpTugvZgQPjNkweJgyCqvI
         9BYA==
X-Forwarded-Encrypted: i=1; AJvYcCXBKSyPj8rCeaIiBdjOE/bhpeutzpD0wm+yZawxrW6+xOYCUnDIfVAlOmKSPYVbtrbjc5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUBsQnc4fIgvMjuRcpwtnT/UZnK5zkyLGHN10NuMlQbDr6BaIF
	VUTj+eOHPw1CY2iXfuXw9aE0Uofou/n0Z3iFbqHbHaGbih1VWL3H0JOUELJ2FkLnsu9YswvbCOJ
	FD+k9FChY2r6IIOD9W0TpVEROWYDQ9yYbczFoA0XszfkATk9wSuLMQQ==
X-Gm-Gg: AZuq6aLBn9dpo4Ue7VguUQ2JRgfvlbnD3xgN0HSxDxITx4LXmsz+szG/t4Hw8JxBopR
	WYnzZXdQvbzqvw3W6jcQjWtZzysy+wO+ieo27iYHvcoOD3pPdSDi87QAiIyT8JalyExlYbo0qmZ
	2KnlbURuTyvLrj4zxHkMt0ut7U66f1RSEN3k2yvlzwvu7Kt+E4/DTNadcn247/2tSPV6gQRhGWe
	9savxwGS0GDiTP5tEWY/n5cmcdNqJVJu5IQqRwVNk55SMwUKS5qCQNeAKVlJS53becwMWITFKac
	NWq7sPI3yFkyqwRjWU6q4+mo2qwIPlgzXNn9KoQqQ8HTUwR0AEx4rqTdZ38NHKO81N4vMiMWJkU
	5O6ibOTDH6cKrVF6PvltIY8CIZGv/qgUKH84ivw3+jbbiW2yb0JF0ZW2xK7ldK2WkjW+ndGvaUh
	PRhWHOFA==
X-Received: by 2002:a05:620a:bcd:b0:8c7:110e:9cd5 with SMTP id af79cd13be357-8cb33d8c6fdmr4443185a.45.1770838649003;
        Wed, 11 Feb 2026 11:37:29 -0800 (PST)
X-Received: by 2002:a05:620a:bcd:b0:8c7:110e:9cd5 with SMTP id af79cd13be357-8cb33d8c6fdmr4438985a.45.1770838648496;
        Wed, 11 Feb 2026 11:37:28 -0800 (PST)
Received: from x1.local (bras-vprn-aurron9134w-lp130-03-174-91-117-149.dsl.bell.ca. [174.91.117.149])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cd8aff6sm21074646d6.27.2026.02.11.11.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 11:37:28 -0800 (PST)
Date: Wed, 11 Feb 2026 14:37:26 -0500
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
Subject: Re: [PATCH RFC 09/17] userfaultfd: introduce
 vm_uffd_ops->alloc_folio()
Message-ID: <aYzadvQRCw3iOVsc@x1.local>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-10-rppt@kernel.org>
 <aYEhgA1dY0biVYb8@x1.local>
 <aYhj_H2X141wU3oF@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aYhj_H2X141wU3oF@kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70891-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterx@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,x1.local:mid]
X-Rspamd-Queue-Id: 1A0B4127338
X-Rspamd-Action: no action

On Sun, Feb 08, 2026 at 12:22:52PM +0200, Mike Rapoport wrote:
> On Mon, Feb 02, 2026 at 05:13:20PM -0500, Peter Xu wrote:
> > On Tue, Jan 27, 2026 at 09:29:28PM +0200, Mike Rapoport wrote:
> > 
> > [...]
> > 
> > > -static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
> > > -					 struct vm_area_struct *dst_vma,
> > > -					 unsigned long dst_addr)
> > > +static int mfill_atomic_pte_copy(struct mfill_state *state)
> > >  {
> > > -	struct folio *folio;
> > > -	int ret = -ENOMEM;
> > > -
> > > -	folio = vma_alloc_zeroed_movable_folio(dst_vma, dst_addr);
> > > -	if (!folio)
> > > -		return ret;
> > > -
> > > -	if (mem_cgroup_charge(folio, dst_vma->vm_mm, GFP_KERNEL))
> > > -		goto out_put;
> > > +	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
> > >  
> > > -	/*
> > > -	 * The memory barrier inside __folio_mark_uptodate makes sure that
> > > -	 * zeroing out the folio become visible before mapping the page
> > > -	 * using set_pte_at(). See do_anonymous_page().
> > > -	 */
> > > -	__folio_mark_uptodate(folio);
> > > +	return __mfill_atomic_pte(state, ops);
> > > +}
> > >  
> > > -	ret = mfill_atomic_install_pte(dst_pmd, dst_vma, dst_addr,
> > > -				       &folio->page, true, 0);
> > > -	if (ret)
> > > -		goto out_put;
> > > +static int mfill_atomic_pte_zeroed_folio(struct mfill_state *state)
> > > +{
> > > +	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
> > >  
> > > -	return 0;
> > > -out_put:
> > > -	folio_put(folio);
> > > -	return ret;
> > > +	return __mfill_atomic_pte(state, ops);
> > >  }
> > >  
> > >  static int mfill_atomic_pte_zeropage(struct mfill_state *state)
> > > @@ -542,7 +546,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
> > >  	int ret;
> > >  
> > >  	if (mm_forbids_zeropage(dst_vma->vm_mm))
> > > -		return mfill_atomic_pte_zeroed_folio(dst_pmd, dst_vma, dst_addr);
> > > +		return mfill_atomic_pte_zeroed_folio(state);
> > 
> > After this patch, mfill_atomic_pte_zeroed_folio() should be 100% the same
> > impl with mfill_atomic_pte_copy(), so IIUC we can drop it.
> 
> It will be slightly different after the next patch to emphasize that
> copying into MAP_PRIVATE actually creates anonymous memory.

True.  It might be helpful to leave a line in the commit message so it's
intentional to temporarily have two functions do the same thing, but I'm OK
either way.

Thanks,

-- 
Peter Xu


