Return-Path: <kvm+bounces-38387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3263CA38CCC
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 20:56:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1BCD618948C8
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 19:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A360E236437;
	Mon, 17 Feb 2025 19:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="siLqnq1J"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7808D372
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 19:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739822197; cv=none; b=fiW9YttSTrcXsmiONyh8tBIllPCLO731fQhnbOLFbCau+QV1imShURup3GJM96/W3agO+Qxgd5Z3tW+jppVmrZSvNPgD0zGoJWZBnkS+Y+gRbg5G314ie034H9jshhdWPH7iHcltgxORSIWLCyk2xZXrBv1fz+ig9Hqe2FM4kKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739822197; c=relaxed/simple;
	bh=FoJyokByN1QQsD6pvvzeEGQ5rJM7IpUoU4+rSCs2IUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FVXcKrMmAsFLZKBwKOeSq2qVkWV5+HmIaeenRYAmgrwWK6nFed+2JgxP1eb6mYsqUIYBA0cbYY1YKnmkrluTZb6JO1+0F/H2T5RH3By9qZQdLnvGV7/tQ9jDYcdubzHf+R3UKu0YzmQ/QxfLUXZBuwU8xywngXwoHQxxO60OKcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=siLqnq1J; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 17 Feb 2025 11:56:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739822192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i+XBE7NZR2a9fKSzODv1+rMaRM5C1oTCP1NP2bBfPfE=;
	b=siLqnq1J5sMtyiUSLCc9ivgs1BAPHtyxunFpbT9ID6K0wWJx3009w/Q6ltVHx9PSKd/rnl
	NtfAXYCH3voA+5fp60P9PKhHrak+gUMJG883+/NoPlS1HDJsf+z5pmDmx2cZCshmvXdePf
	mS1SpqWlvpDdtodp5n3hy7/7kGKLWZs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>,
	Patrick Bellasi <derkling@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: Re: Re: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <Z7OUZhyPHNtZvwGJ@Asmaa.>
References: <20250213142815.GBZ64Bf3zPIay9nGza@fat_crate.local>
 <20250213175057.3108031-1-derkling@google.com>
 <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
 <20250215125307.GBZ7COM-AkyaF8bNiC@fat_crate.local>
 <Z7LQX3j5Gfi8aps8@Asmaa.>
 <20250217160728.GFZ7NewJHpMaWdiX2M@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250217160728.GFZ7NewJHpMaWdiX2M@fat_crate.local>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 17, 2025 at 05:07:28PM +0100, Borislav Petkov wrote:
> On Sun, Feb 16, 2025 at 09:59:59PM -0800, Yosry Ahmed wrote:
> > If 1-2% is the cost for keeping the MSR enabled at all times, I wonder
> > if we should just do that for simplicitly, and have it its own
> > mitigation option (chosen by the cmdline).
> 
> Yes, that's what David and I think we should do initially.
> 
> Then we can chase some more involved scheme like setting the bit before the
> first VM runs and then clearing it when the last one exits. I *think* I've
> seen something like that in KVM but I need to stare in detail.
> 
> > - Upon return to userspace (similar to your previous proposal). In this
> >   case we run userspace with the MSR cleared, and only perform an IBPB
> >   in the exit to userspace pace.
> 
> You want to IBPB before clearing the MSR as otherwise host kernel will be
> running with the mistrained gunk from the guest.

I meant IBPB + MSR clear before going to userspace, or IBPB + MSR clear
before a context switch.

> 
> > Any thoughts? 
> 
> Yes, let's keep it simple and do anything more involved *only* if it is really
> necessary.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

