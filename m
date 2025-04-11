Return-Path: <kvm+bounces-43123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B824A8507B
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 02:19:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E37416BE81
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 00:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0858B79FE;
	Fri, 11 Apr 2025 00:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XrIRee/Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66ABE548EE;
	Fri, 11 Apr 2025 00:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744330783; cv=none; b=pbEVJ1hg4iHgtX8uxzae9bA2a33ndDiGxayFByLxVUYWwq6Y2v8mFNiaeoTO0q5Ke2yPMmuM82MHpSoVgYyCE2bPUH9kCCIBH8WaUi4F3wVHLVW6Dgx0YDSyf1521pw3P4lyJ5rgM0+9IXfbd3Dt21dsKpUDe8lYbXVU2O+K5IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744330783; c=relaxed/simple;
	bh=OdJs82fDmb8SkTyEHEmR9Tf6QIzr/ltN2JgusORYOIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ROT6mQFBspvlvof9sQ6E/U5fdKifxK8KUtJNv3bIpaSYejOOTFOLbi1swMLCtsWBK13mzPZ3ZEkh5tu7eiFS6QqI/Op5KpAY5/hQF7JlKekc6qxr9gR/oanVmyYRQcRHiKEJgO28pQgOVx5vbjS48pmpsvUWBOpaobAv1lyPbiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XrIRee/Z; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744330781; x=1775866781;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OdJs82fDmb8SkTyEHEmR9Tf6QIzr/ltN2JgusORYOIM=;
  b=XrIRee/Z1ie4hMuKET5qjRsf0EKhR5rGaZIXIFcEqgg8hctw0rxVPiq5
   CkqJfyiaCu1Ts6GFQXWxBTMuqTyi42ce9SKIKBQmaiFXsq5nUK1qJzcXH
   hcAkp1M0z84onIYf86S1SdvtRNCM1T7V33iQUDN9NO4igREBe+s8GjWmY
   8yUO6MVpEZPvRmLYHAXb3ZIT4cO0Ww/hNe84ampmF1w/I5co+meTuxQF5
   p9vIVVIX9q16nN6K9jOG0BJYzk1lvZjxpWu/WlxVl3788b8nC8/BWzd/u
   cXFyfiDdUZIi0Nd9ZFCLWjLMc7kW2e4doaQFwOmAH8uGebXgor3nX9/H8
   w==;
X-CSE-ConnectionGUID: NMS7AsSXShmU7leYLFra5Q==
X-CSE-MsgGUID: 0r319r4DTOeXvsI2kCegAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="56852552"
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="56852552"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 17:19:41 -0700
X-CSE-ConnectionGUID: DTLwJR0JTyqC9vLbm1igLg==
X-CSE-MsgGUID: kRlWOvehRwehm9UwwDr2bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="160021943"
Received: from dstill-mobl.amr.corp.intel.com (HELO desk) ([10.125.145.218])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 17:18:59 -0700
Date: Thu, 10 Apr 2025 17:17:02 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH] x86/bugs/mmio: Rename mmio_stale_data_clear to
 cpu_buf_vm_clear
Message-ID: <20250411001702.p5g2gjtundwjtbwy@desk>
References: <20250410-mmio-rename-v1-1-fd4b2e7fc04e@linux.intel.com>
 <Z_gsgHzgGWqnNwKv@google.com>
 <20250410221345.ewyagu7coscpr3l7@desk>
 <Z_hV3pbpM2Y2qq6k@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_hV3pbpM2Y2qq6k@google.com>

On Thu, Apr 10, 2025 at 04:35:58PM -0700, Sean Christopherson wrote:
> > > I like the idea of tying the static key back to X86_FEATURE_CLEAR_CPU_BUF, but
> > > when looking at just the usage in KVM, "cpu_buf_vm_clear" doesn't provide any
> > > hints as to when/why KVM needs to clear buffers.
> > 
> > Thats fair, can we cover that with a comment like below:
> > 
> > ---
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index c79720aad3df..cddad4a6eb46 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7358,6 +7358,10 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> >  	 * mitigation for MDS is done late in VMentry and is still
> >  	 * executed in spite of L1D Flush. This is because an extra VERW
> >  	 * should not matter much after the big hammer L1D Flush.
> > +	 *
> > +	 * cpu_buf_vm_clear is used when system is not vulnerable to MDS/TAA,
> > +	 * but is affected by MMIO Stale Data that only needs mitigation
> > +	 * against a rogue guest.
> 
> Would this be accurate?

I believe this is accurate as things stand today. But, when Attack Vector
Control series leverages cpu_buf_vm_clear, the comment also needs to be
updated.

