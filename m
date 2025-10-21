Return-Path: <kvm+bounces-60755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B5CBBF93C2
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:30:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A7E824F2E3B
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 23:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1CE6292938;
	Tue, 21 Oct 2025 23:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IQHUBIS1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFD51E25E3;
	Tue, 21 Oct 2025 23:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761089422; cv=none; b=N9z3VUssbtQiWQgMjUB5gbEpLFvSydhcBPm/aGF5k0naXHBdm/q0ul2hgH9HHt9QGZ/B3QS5djyAlgv4ZZCuQU1U7kOEQ5GJggwbVzkE1APFTjILrOsfgUKEateU4K+d/As5OdyL11FKZZ3htrM9MwIS3ktR85f2DKrYzRXXi0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761089422; c=relaxed/simple;
	bh=Ges1mU1LiDL2G3TzhjZapfKumsce9lwknHzzRtcnuEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RIQBU2Qr3yMnj+Apqv0ccjWPCjeP8pgGrkCpVBOTuY0tOMWxApIbDFbMBdvERD7D91j9e3Wlg154QgiBPEUTb0dlqQ4Wbz/bVNRCxyDaCsI8/8AhvWmmwMER01x11CVIG2LurLxah7rDFjQ764SvOZLHwPKzXsS22JIItrYbaTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IQHUBIS1; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761089420; x=1792625420;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ges1mU1LiDL2G3TzhjZapfKumsce9lwknHzzRtcnuEc=;
  b=IQHUBIS114+vWfa/pelNWqY+G4O+MN+7lfjXQN0Zkehle/3VuHVM8sXc
   VYx/nukSaTa9H2I6rpkhemPp9SGwgIs5PTbh+UdKrtHQxWJSy9tkmfmKw
   iNh0Jpijj9/WwUmCFia76UVEKbcqK+gNisz/7+l4c5OlLL/6W6j/hlmQj
   +T7RTSZSME1S4jxXHpii9yxgaW5OrE/BCqz4Tt71a4YeU+QGXjlKr0Cn+
   6Oqe0yLVc/pxspK5EczQnMrOElaSYnAy44Z0csTuUr5iDtgRSHgBoSjF2
   Z8I2Qb8pQrS3B1YNQhO1knfQEMRLaQ5mfn1Yj0qCTRyp+pg3lGW7GvgYE
   g==;
X-CSE-ConnectionGUID: 49YPflYDQ0KTn3jQgL9dhA==
X-CSE-MsgGUID: OttRLu5KSmemXC3ffkgUbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74665846"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="74665846"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 16:30:19 -0700
X-CSE-ConnectionGUID: Yh+yWB8kRKeDktFvDs9Trw==
X-CSE-MsgGUID: 4QhKeOIiS+eBWQWoYnqoYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="188121104"
Received: from bkammerd-mobl.amr.corp.intel.com (HELO desk) ([10.124.220.246])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 16:30:18 -0700
Date: Tue, 21 Oct 2025 16:30:12 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Brendan Jackman <jackmanb@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] KVM: VMX: Flush CPU buffers as needed if L1D
 cache flush is skipped
Message-ID: <20251021233012.2k5scwldd3jzt2vb@desk>
References: <20251016200417.97003-1-seanjc@google.com>
 <20251016200417.97003-2-seanjc@google.com>
 <DDO1FFOJKSTK.3LSOUFU5RM6PD@google.com>
 <aPe5XpjqItip9KbP@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPe5XpjqItip9KbP@google.com>

On Tue, Oct 21, 2025 at 09:48:30AM -0700, Sean Christopherson wrote:
> On Tue, Oct 21, 2025, Brendan Jackman wrote:
> > On Thu Oct 16, 2025 at 8:04 PM UTC, Sean Christopherson wrote:
> > > If the L1D flush for L1TF is conditionally enabled, flush CPU buffers to
> > > mitigate MMIO Stale Data as needed if KVM skips the L1D flush, e.g.
> > > because none of the "heavy" paths that trigger an L1D flush were tripped
> > > since the last VM-Enter.
> > 
> > Presumably the assumption here was that the L1TF conditionality is good
> > enough for the MMIO stale data vuln too? I'm not qualified to assess if
> > that assumption is true, but also even if it's a good one it's
> > definitely not obvious to users that the mitigation you pick for L1TF
> > has this side-effect. So I think I'm on board with calling this a bug.
> 
> Yeah, that's where I'm at as well.
> 
> > If anyone turns out to be depending on the current behaviour for
> > performance I think they should probably add it back as a separate flag.
> 
> ...
> 
> > > @@ -6722,6 +6722,7 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
> > >  		:: [flush_pages] "r" (vmx_l1d_flush_pages),
> > >  		    [size] "r" (size)
> > >  		: "eax", "ebx", "ecx", "edx");
> > > +	return true;
> > 
> > The comment in the caller says the L1D flush "includes CPU buffer clear
> > to mitigate MDS" - do we actually know that this software sequence
> > mitigates the MMIO stale data vuln like the verw does? (Do we even know if
> > it mitigates MDS?)
> > 
> > Anyway, if this is an issue, it's orthogonal to this patch.
> 
> Pawan, any idea?

I want to say yes, but let me first confirm this internally and get back to
you.

