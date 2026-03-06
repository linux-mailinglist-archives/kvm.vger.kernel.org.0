Return-Path: <kvm+bounces-73027-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CPpVAq+4qmlpVwEAu9opvQ
	(envelope-from <kvm+bounces-73027-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 12:21:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A15AC21F965
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 12:21:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 32483309C29D
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 11:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D2912E1E9;
	Fri,  6 Mar 2026 11:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIoEzS/D"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E2F322C88;
	Fri,  6 Mar 2026 11:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772795950; cv=none; b=fGHGSEuVtly4j5bbV0QZhXicAP90p+J6860ro3uOYtZ38Np8Wvdau9olbFqDkQEJS5H9se5LeyOSlQtUtFkFjlJ16oGj23ALFsaliGcGFd0bxd3pbepCr2VfOH+ZoHm9WM5giKyL6jc7fJS7HTPaYcB2Kqho7Tr1qtiRYFpUo0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772795950; c=relaxed/simple;
	bh=Mao5sDzSUZ+f9uQRGE4C9WfuIvF/XWcry+r5NOvZOYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TSyJRK8VRHRQkgV4FmyByurxe1PkX/E12TP7o3qUvOA19H2hR2giEL9ah9Mn7XLK9JWzTqyAFNqKBPNP2zLLQ8GZJ1FZ/E4gr2rUtvjfXblf2LM3BsJF9kYkRfxl6FqHUnsf0Je/IjHZp8bcZXmqMZcIhbnjibXuAhJPK2D8Kuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SIoEzS/D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD33C4CEF7;
	Fri,  6 Mar 2026 11:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772795950;
	bh=Mao5sDzSUZ+f9uQRGE4C9WfuIvF/XWcry+r5NOvZOYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SIoEzS/DxNjqL5S12WR+Z4yk2+4eKi12ei99kZadEHX7MESoV5Wv16WGPtc0njmef
	 y90QEYTXb5wJZglbt0twBS0mvmRICjSm+Pf4pNVSyOyHKbWu/l+0AES9uhiEQcOvDj
	 kh9D9puozrjzimBHTc3sbXUJPclGB4LyqpXKH2lNjcq9sZ/0S+5RJbLGfNQij8sk07
	 mEgagnudwYDACrGUEXJGJRHldgqqHPbw2M4hPETiptO3fvQnUBFuVUWhwsn15OIe8O
	 Nd8cqwkuH0f6HODDVKq1OY5MrRDFUqGhe3otSE6QZyqmDQt7e1ZTflx4ufrWF8MyJf
	 iV3kpykXdQjkw==
Date: Fri, 6 Mar 2026 11:19:02 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 0/4] mm: move vma_(kernel|mmu)_pagesize() out of
 hugetlb.c
Message-ID: <371cf0f7-4b30-4d8c-99e7-ae0543f8be23@lucifer.local>
References: <20260306101600.57355-1-david@kernel.org>
 <4rzf46kw6hq3b5ivv7cvgyza4yfrvk2shrncytobabxef644nm@wzu2bw63co37>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4rzf46kw6hq3b5ivv7cvgyza4yfrvk2shrncytobabxef644nm@wzu2bw63co37>
X-Rspamd-Queue-Id: A15AC21F965
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73027-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,kvack.org,lists.ozlabs.org,linux-foundation.org,linux.ibm.com,gmail.com,ellerman.id.au,linux.dev,suse.de,oracle.com,google.com,suse.com,redhat.com,intel.com];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ljs@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026 at 11:13:41AM +0000, Pedro Falcato wrote:
> On Fri, Mar 06, 2026 at 11:15:56AM +0100, David Hildenbrand (Arm) wrote:
> > Looking into vma_(kernel|mmu)_pagesize(), I realized that there is one
> > scenario where DAX would not do the right thing when the kernel is
> > not compiled with hugetlb support.
> >
> > Without hugetlb support, vma_(kernel|mmu)_pagesize() will always return
> > PAGE_SIZE instead of using the ->pagesize() result provided by dax-device
> > code.
> >
> > Fix that by moving vma_kernel_pagesize() to core MM code, where it belongs.
> > I don't think this is stable material, but am not 100% sure.
> >
> > Also, move vma_mmu_pagesize() while at it. Remove the unnecessary hugetlb.h
> > inclusion from KVM code.
> >
> > Cross-compiled heavily.
> >
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> > Cc: Nicholas Piggin <npiggin@gmail.com>
> > Cc: Michael Ellerman <mpe@ellerman.id.au>
> > Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
> > Cc: Muchun Song <muchun.song@linux.dev>
> > Cc: Oscar Salvador <osalvador@suse.de>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Pedro Falcato <pfalcato@suse.de>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
>
> Although we all love less mail, FYI it seems like this didn't work properly
> for the patches (no CC's on there).
>
> Did you try git-email --cc-cover?

Yeah I noticed this also :>) Assumed it was a new way of doing things somehow?
:P

>
> --
> Pedro

Cheers, Lorenzo

