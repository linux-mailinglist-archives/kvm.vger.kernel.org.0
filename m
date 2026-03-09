Return-Path: <kvm+bounces-73296-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GEOGAIXPrmnEIwIAu9opvQ
	(envelope-from <kvm+bounces-73296-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 14:47:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 503BF239F88
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 14:47:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0657C3189BEE
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 13:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C49B3BD623;
	Mon,  9 Mar 2026 13:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQnV0/0I"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BFC38BF87;
	Mon,  9 Mar 2026 13:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773063762; cv=none; b=k4BaVsYWazc16foau64h1c/pLlzUvj3gT+XQkpq0mJquUb//pXL5zjCCvaVoG1IlvBllx7XAN652VfRrhpv738sO2IjQVAHIGyhwXi+m5AvO+8PKyzLehLv+wfOZmoe9FSeFwdY7DfAuWZG0Q5RpoBVq4Hsyp4rav2kMrwB3RHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773063762; c=relaxed/simple;
	bh=QdLqgkrqeAfJ6Qj1NcjlAT2Fn0qLa5PiGFwuIm6W/I8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tMVwWQPRXr5zi1EVBcfRP4VfoxVP3VnjscYsUtRItF2by+lcspW5jaPGB9vbWy0f7htpXIRKey86Qb+Ke3EbiDBamHqp0vssAJZikMEPFeJXkhEDW7Vuca1No7nSqNiAj9TESOetUFpxg/kbuItNNvfiDd5nf3VlcJZVGTFeCqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQnV0/0I; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF653C2BCB0;
	Mon,  9 Mar 2026 13:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773063762;
	bh=QdLqgkrqeAfJ6Qj1NcjlAT2Fn0qLa5PiGFwuIm6W/I8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dQnV0/0Ib5o0KbD2/Ib4XNlPdDfuU95v07ZdnPKKg/jFgYKnhJQhqIjmKDE6jqoHa
	 UbnrtJYOdfufndzBfXb1qT70GS2hllMwKgjigWNx4X/AmvD8OC015KFUUmWfM896jr
	 wXD1IkVH+s3e1kL5CIa837syBspn675hbIjHowdCIOfapdJc/If84l+T88BRb5Q1/C
	 fHHYCOP92nycWnMvBnifB/KK9hIBMPUEWC6c1NlMCuWDVPTlHFviQ7LzRunEaSUMkn
	 iJr6MSJLjAjFWmO3A7thdciHjEBjfED6vCHJ9FMv7WUeep4AHm6VcjAK/bvyCVE536
	 8QEJ6P5eRDAHw==
Date: Mon, 9 Mar 2026 13:42:35 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 0/4] mm: move vma_(kernel|mmu)_pagesize() out of
 hugetlb.c
Message-ID: <9172a09f-f014-4a76-b813-8f0c79fbe2f4@lucifer.local>
References: <20260306101600.57355-1-david@kernel.org>
 <4rzf46kw6hq3b5ivv7cvgyza4yfrvk2shrncytobabxef644nm@wzu2bw63co37>
 <371cf0f7-4b30-4d8c-99e7-ae0543f8be23@lucifer.local>
 <5eae6c52-c3f9-407e-8fb8-01a950b282bf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eae6c52-c3f9-407e-8fb8-01a950b282bf@kernel.org>
X-Rspamd-Queue-Id: 503BF239F88
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73296-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[suse.de,vger.kernel.org,kvack.org,lists.ozlabs.org,linux-foundation.org,linux.ibm.com,gmail.com,ellerman.id.au,kernel.org,linux.dev,oracle.com,google.com,suse.com,redhat.com,intel.com];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.966];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ljs@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026 at 02:12:50PM +0100, David Hildenbrand (Arm) wrote:
> On 3/6/26 12:19, Lorenzo Stoakes (Oracle) wrote:
> > On Fri, Mar 06, 2026 at 11:13:41AM +0000, Pedro Falcato wrote:
> >> On Fri, Mar 06, 2026 at 11:15:56AM +0100, David Hildenbrand (Arm) wrote:
> >>> Looking into vma_(kernel|mmu)_pagesize(), I realized that there is one
> >>> scenario where DAX would not do the right thing when the kernel is
> >>> not compiled with hugetlb support.
> >>>
> >>> Without hugetlb support, vma_(kernel|mmu)_pagesize() will always return
> >>> PAGE_SIZE instead of using the ->pagesize() result provided by dax-device
> >>> code.
> >>>
> >>> Fix that by moving vma_kernel_pagesize() to core MM code, where it belongs.
> >>> I don't think this is stable material, but am not 100% sure.
> >>>
> >>> Also, move vma_mmu_pagesize() while at it. Remove the unnecessary hugetlb.h
> >>> inclusion from KVM code.
> >>>
> >>> Cross-compiled heavily.
> >>>
> >>> Cc: Andrew Morton <akpm@linux-foundation.org>
> >>> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> >>> Cc: Nicholas Piggin <npiggin@gmail.com>
> >>> Cc: Michael Ellerman <mpe@ellerman.id.au>
> >>> Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
> >>> Cc: Muchun Song <muchun.song@linux.dev>
> >>> Cc: Oscar Salvador <osalvador@suse.de>
> >>> Cc: Lorenzo Stoakes <ljs@kernel.org>
> >>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> >>> Cc: Vlastimil Babka <vbabka@kernel.org>
> >>> Cc: Mike Rapoport <rppt@kernel.org>
> >>> Cc: Suren Baghdasaryan <surenb@google.com>
> >>> Cc: Michal Hocko <mhocko@suse.com>
> >>> Cc: Jann Horn <jannh@google.com>
> >>> Cc: Pedro Falcato <pfalcato@suse.de>
> >>> Cc: Paolo Bonzini <pbonzini@redhat.com>
> >>> Cc: Dan Williams <dan.j.williams@intel.com>
> >>
> >> Although we all love less mail, FYI it seems like this didn't work properly
> >> for the patches (no CC's on there).
> >>
> >> Did you try git-email --cc-cover?
> >
> > Yeah I noticed this also :>) Assumed it was a new way of doing things somehow?
> > :P
>
> "--cc-cover" is apparently not the git default on my new machine.
>
> "See, I CCed you, I totally did not try to sneak something in. Oh, I
> messed up my tooling, stupid me ...". :)

;)

Wasn't aware of that option actually, handy!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

