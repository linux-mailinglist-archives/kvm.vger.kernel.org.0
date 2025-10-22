Return-Path: <kvm+bounces-60789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C03F4BF9994
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 03:20:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84A283A3DC9
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F40BF1F419B;
	Wed, 22 Oct 2025 01:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j8Vp9rkE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB92156C6A;
	Wed, 22 Oct 2025 01:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761096032; cv=none; b=otAFj52dRa/Oe1Ijl8fgXC7+i67yt5GeCRZ2m2pW5AiEpl7uFTf10y95eS4aR11q90d+jf8wQDU1CdUvbsW3dixOOT0nXCxmMj6M+bcRjGvEzf4UfkY8t1NMcMYcUKZNOdv9ryaTvBvpOKb3qwZk1BoNu4PsDfOrq6hwSpDvNRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761096032; c=relaxed/simple;
	bh=O/anaR0rB1OOdNnxTPw5HCQ1H8TRUW4biuj+/8DA2co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EDzkGb3jst2/1X/J8HbT0S3sb2XIB5aokOO6QeamTKQqn5LLzZtk7e86L9xCGK+rYfy3EUiTsck0oOGOG1TXcz45H2Fm3rVQsBLMWC328JAhCMdr+vLm2TuZmwhlN7aqJpahPTLEGxks6HHmMDe1JBP1FxneOjdFdaH9SssOXUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j8Vp9rkE; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761096030; x=1792632030;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=O/anaR0rB1OOdNnxTPw5HCQ1H8TRUW4biuj+/8DA2co=;
  b=j8Vp9rkEbXMWDcuFaiMrxNrjz+csQiurEW7uGizAG/8VmT2/6OchDHsI
   qp0MQCx6O9GoSA9Qzko4xpnapYrng8neahzUQUAIByYeoKcKnNVnNVGxu
   AYQkhB7d6JXzC1q4PVNyWvgcg4kpxUTwP/S4orCc4F4/QMAJWZkyXTF0w
   NziuAVu0ha36g5jlUtbvXdEhP15ORV1O1ui8kQvh1nxPJSd9vYZGTuemA
   RuFPJP4/XqHPegIXfbH3DHsVrBXNUkcS5a6rkikbeYxNMhtCEsqZb0O+/
   V1d4b2WZ0gYGZYWTER6GFcaVpjDnEkhWyAq9Sjann4inNvudrs8YeElGH
   w==;
X-CSE-ConnectionGUID: igHj0jGGRHy1/1pxSQZYLA==
X-CSE-MsgGUID: 8Ulv+bZSRe+68DxQwQ2pXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63138461"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63138461"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 18:20:29 -0700
X-CSE-ConnectionGUID: h5H2UXETT9Wc2xxzZ6VnUQ==
X-CSE-MsgGUID: 2CVUKO3OTDyQpJda/DoNHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="183308378"
Received: from bkammerd-mobl.amr.corp.intel.com (HELO desk) ([10.124.220.246])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 18:20:28 -0700
Date: Tue, 21 Oct 2025 18:20:21 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Brendan Jackman <jackmanb@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] KVM: VMX: Flush CPU buffers as needed if L1D
 cache flush is skipped
Message-ID: <20251022012021.sbymuvzzvx4qeztf@desk>
References: <20251016200417.97003-1-seanjc@google.com>
 <20251016200417.97003-2-seanjc@google.com>
 <DDO1FFOJKSTK.3LSOUFU5RM6PD@google.com>
 <aPe5XpjqItip9KbP@google.com>
 <20251021233012.2k5scwldd3jzt2vb@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021233012.2k5scwldd3jzt2vb@desk>

On Tue, Oct 21, 2025 at 04:30:19PM -0700, Pawan Gupta wrote:
> On Tue, Oct 21, 2025 at 09:48:30AM -0700, Sean Christopherson wrote:
> > On Tue, Oct 21, 2025, Brendan Jackman wrote:
> > > On Thu Oct 16, 2025 at 8:04 PM UTC, Sean Christopherson wrote:
> > > > If the L1D flush for L1TF is conditionally enabled, flush CPU buffers to
> > > > mitigate MMIO Stale Data as needed if KVM skips the L1D flush, e.g.
> > > > because none of the "heavy" paths that trigger an L1D flush were tripped
> > > > since the last VM-Enter.
> > > 
> > > Presumably the assumption here was that the L1TF conditionality is good
> > > enough for the MMIO stale data vuln too? I'm not qualified to assess if
> > > that assumption is true, but also even if it's a good one it's
> > > definitely not obvious to users that the mitigation you pick for L1TF
> > > has this side-effect. So I think I'm on board with calling this a bug.
> > 
> > Yeah, that's where I'm at as well.
> > 
> > > If anyone turns out to be depending on the current behaviour for
> > > performance I think they should probably add it back as a separate flag.
> > 
> > ...
> > 
> > > > @@ -6722,6 +6722,7 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
> > > >  		:: [flush_pages] "r" (vmx_l1d_flush_pages),
> > > >  		    [size] "r" (size)
> > > >  		: "eax", "ebx", "ecx", "edx");
> > > > +	return true;
> > > 
> > > The comment in the caller says the L1D flush "includes CPU buffer clear
> > > to mitigate MDS" - do we actually know that this software sequence
> > > mitigates the MMIO stale data vuln like the verw does? (Do we even know if
> > > it mitigates MDS?)

Thinking more on this, the software sequence is only invoked when the
system doesn't have the L1D flushing feature added by a microcode update.
In such a case system is not expected to have a flushing VERW either, which
was introduced after L1TF. Also, the admin needs to have a very good reason
for not updating the microcode for 5+ years :-)

Anyways, I have asked for a confirmation if the sequence works for MMIO
stale data also. I will update once I get a response.

> > > Anyway, if this is an issue, it's orthogonal to this patch.
> > 
> > Pawan, any idea?
> 
> I want to say yes, but let me first confirm this internally and get back to
> you.

