Return-Path: <kvm+bounces-38229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C50A36A94
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:07:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94651173DD7
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D631C7006;
	Sat, 15 Feb 2025 00:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TqJEdj5v"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAFE144D21
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739581047; cv=none; b=j/LlndRnvnqSwsoK0MwnSu6qgIxIPH/nszEJcmCTK4MxVj7/2vDHEdC+pSFxJ4onmSHNq76Y/toMbSW83NM7lLEEkzKOL8zxAOEXJgeFicUtZamp8msuTKBPFKW33RU4sNAYK1fjVltJsfJTB9GUB89vaouXw8Xt2Tw1ETvVBg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739581047; c=relaxed/simple;
	bh=nnoQI6FWAHPVgbUaFSMH0teF0LgFuzIsBNVBOQo5EK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ks2ZN1qAqldmWtcjU1D4qTHkLz9u0OLAih9cTLzFA7IrgFnrLB1gBGgnhBJ8Jo5+sR3CyfoKW8MDYxpIr9byhZg0U/MQ2iZ+NTKaq9xGWdmr7Wm7trVWexXKIPf6CDZ26HJWO8PbQmnNvjuKN/HULyDI0FtT2HmIaDQhU0Pj2Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TqJEdj5v; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 15 Feb 2025 00:57:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739581032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ULLjJNjDq0utTi5CLFZt6GhLkdXDd/3gI8n8ZSY2n0o=;
	b=TqJEdj5vkvxy8qYPKvRPZtv99VxJOX1cUM3pnFDRPRWyFcGQocLF9gyQFMGX9czf2fIYIc
	qJJ9fFbFa8KRpt+FbzKn275zri2nG1appkc39bTekXSeVPeGThBT7JkporaoLdazIQjjgY
	PCnaDcVTxKPBs/el00NRMznSjXbY7qc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Borislav Petkov <bp@alien8.de>
Cc: Patrick Bellasi <derkling@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: Re: Re: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <Z6_mY3a_FH-Zw4MC@google.com>
References: <20250213142815.GBZ64Bf3zPIay9nGza@fat_crate.local>
 <20250213175057.3108031-1-derkling@google.com>
 <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250214201005.GBZ6-jHUff99tmkyBK@fat_crate.local>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 14, 2025 at 09:10:05PM +0100, Borislav Petkov wrote:
> On Thu, Feb 13, 2025 at 05:50:57PM +0000, Patrick Bellasi wrote:
> > The "should be set identically across all processors in the system" makes me
> > wondering if using the "KVM's user_return approach" proposed here is robust
> > enough. Could this not lead to the bit being possibly set only on some CPU
> > but not others?
> 
> That's fine, we should update that paper.
> 
> > If BpSpecReduce does not prevent training, but only the training from being
> > used, should not we keep it consistently set after a guest has run, or until an
> > IBPB is executed?
> 
> After talking with folks internally, you're probably right. We should slap an
> IBPB before clearing. Which means, I cannot use the MSR return slots anymore.
> I will have to resurrect some of the other solutions we had lined up...
> 
> Stay tuned.

Thanks for working on this!

Should this patch (and the two previously merged patches) be backported
to stable? I noticed they did not have CC:stable.

> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

