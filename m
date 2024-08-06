Return-Path: <kvm+bounces-23435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3A7C949894
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 21:44:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 973ED282250
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED59A149DE2;
	Tue,  6 Aug 2024 19:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kle2A+7y"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E13818D62B
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 19:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722973465; cv=none; b=FJTZVa70QkxTPS2g+I8/TkZSMeBJBzGAyElq4aL/HuEZhPKUPiopQ6u+7OVDGAvZnsTLOfwRgIWGN/+8ziInyA10R/868N57Qly4VvWkI3MjO1Qor/VtWniWWvxRUl90bsI95JUSeas/eKW9CReBRAzAm0czeaGJ8kMmr/Vb734=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722973465; c=relaxed/simple;
	bh=cyMedLSJfxUkCwsL02mSmG0aQfm8fZ9wo2yQrUIA5bk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gbj0jUPrj3Zr9+WNsjS/COv8vTAdnnb8eSUN7/WyWlbP7vfjhpnd0eQ8a7PigWjOlo6OMuu87CkNK6wbUaOocySTITbHHNRv8anFJjlzewGoxwtd7PIAXdx5MvylWKiOXrhw0Q21L+oj4PlF9HTxQ6+zGkIfj05lTaWA6mQJQqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kle2A+7y; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 6 Aug 2024 12:44:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722973461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CREP39dgkLfFNI+MwsBX/oRpiJp7kpvX39kdsm0JcTI=;
	b=Kle2A+7ymD8xuvpkIIWqq87fOD3X2C6dgit+BEGd6eBFqnxTt/zVAGJGs8pEokEAiaevx/
	hQYJn/ff7s+gJVXormnS7JPi8wCws8TA+rOT5p00dPhaiDKHqgTKPnca2zSggmYNqmIS64
	mHaBUwOOqilm8etZPBkiCu2lJzVE9zg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Anish Moorthy <amoorthy@google.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	jthoughton@google.com, rananta@google.com
Subject: Re: [PATCH 2/3] KVM: arm64: Declare support for
 KVM_CAP_MEMORY_FAULT_INFO
Message-ID: <ZrJ9DhNol2pUWp2M@linux.dev>
References: <20240802224031.154064-1-amoorthy@google.com>
 <20240802224031.154064-3-amoorthy@google.com>
 <ZrFXcHnhXUcjof1U@linux.dev>
 <CAF7b7mouOmmDsU23r74s-z6JmLWvr2debGRjFgPdXotew_nAfA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF7b7mouOmmDsU23r74s-z6JmLWvr2debGRjFgPdXotew_nAfA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 06, 2024 at 11:14:15AM -0700, Anish Moorthy wrote:
> On Mon, Aug 5, 2024 at 3:51 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > The wording of the cap documentation isn't as relaxed as I'd
> > anticipated. Perhaps:
> >
> >   The presence of this capability indicates that KVM_RUN *may* fill
> >   kvm_run.memory_fault if ...
> >
> > IOW, userspace is not guaranteed that the structure is filled for every
> > 'memory fault'.
> 
> Agreed, I can add a patch to update the docs
> 
> While we're at it, what do we think of removing this disclaimer?
> 
> >Note: Userspaces which attempt to resolve memory faults so that they can retry
> > KVM_RUN are encouraged to guard against repeatedly receiving the same
> > error/annotated fault.
> 
> I originally added this bit due to my concerns with the idea of
> filling kvm_run.memory_fault even for EFAULTs that weren't guaranteed
> to be returned by KVM_RUN [1].

This sort of language generally isn't necessary in UAPI descriptions. We
cannot exhaustively describe the ways userspace might misuse an
interface.

> However if I'm interpreting Sean's
> response to [2] correctly, I think we're now committed to only
> KVM_EXIT_MEMORY_FAULTing for EFAULTs/EHWPOISONs which return from
> KVM_RUN. At the very least, that seems to be true of current usages.

Yeah, I'd have a similar expectation. No point in a half-attempt at
getting out to userspace and subsequently stomping the context.

-- 
Thanks,
Oliver

