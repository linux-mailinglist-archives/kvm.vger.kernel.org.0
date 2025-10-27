Return-Path: <kvm+bounces-61223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BC40C117B8
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 22:10:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1ED2D4E15AC
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 21:09:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD6232861E;
	Mon, 27 Oct 2025 21:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D/R5h7Gq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459AD28935A;
	Mon, 27 Oct 2025 21:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761599388; cv=none; b=M7ol5HPISRRcq62FKEuJOU+P/8RE2T4OcraZNnTKM8tf0aA5/fLKitgfiXSPuKRdEeU5OURybn6dP5Dqh75RpvPakSUZcpXiDrj8TYKcAQoC2jfPUqbQzIxSvLBw7/edMeZdC9b+xjAaqCONI0LUAHZz1RpmAzM24jVEdgEZaok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761599388; c=relaxed/simple;
	bh=jiJc43oKsUwQXXTUSjasJzpDSd7ISfaLkcwQgh9XI2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kk8xmKRkqrL2zHXizfhN714NbZZjxTlJypoAWagLU8B+BfeVVFPdw4FfsdmMFtyGt1L7DAEBQW3w5HcQGLDK4hA0geVsvUIp77Y/VW+V/GNlg1JPcCYo/z5dlZY++EKZKIpIIXBHgPtfeA7G3fobJ2U+63016CJU39mj1TjuBc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D/R5h7Gq; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761599386; x=1793135386;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jiJc43oKsUwQXXTUSjasJzpDSd7ISfaLkcwQgh9XI2o=;
  b=D/R5h7Gqgu2NWtJbdZH2pJ/EhyrTz0SYcBIqG5Y7MKvWGZg9QDLVy8DZ
   hmoE5+/C94wCQexNaDspa0jjTo99+cXIxShfEjXIGbfKk5j3DSw1B1lbX
   FZufJlcnbdApOk06LEo4U/sRopyPe4Dxzw3KBtT/Eldb2r6RfLzXDY8xB
   +KQGrt0NeKogD0jRkvUhSez7vj/ISi8SpAIUXTPJAV9TbykZ4SP4w2SI/
   7mvWK9VroQh/N1iTnzxJ7mhj5ps8hTIHX9nIUzhZ+M6aJdMrmMelTB24d
   /Wa+MzkQJa8dk+/OpwWpVPTqPjMLXEvckYR64E9msWC0V1h1sPAFbuIvr
   Q==;
X-CSE-ConnectionGUID: qJY4cX67QAulo7zNe7mbCQ==
X-CSE-MsgGUID: HJw1p+5ZRwmQLM26R6IUGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="67555734"
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="67555734"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 14:09:45 -0700
X-CSE-ConnectionGUID: BUa17DKbSuumsIqrZc9wkQ==
X-CSE-MsgGUID: w2lESQ+hTLq/TaN9RzO4vA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="185914189"
Received: from jjgreens-desk15.amr.corp.intel.com (HELO desk) ([10.124.222.186])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 14:09:45 -0700
Date: Mon, 27 Oct 2025 14:09:39 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Brendan Jackman <jackmanb@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/4] KVM: VMX: Flush CPU buffers as needed if L1D
 cache flush is skipped
Message-ID: <20251027210939.53e4ippuz7c6qo4b@desk>
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

On Tue, Oct 21, 2025 at 04:30:12PM -0700, Pawan Gupta wrote:
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
> > > 
> > > Anyway, if this is an issue, it's orthogonal to this patch.
> > 
> > Pawan, any idea?
> 
> I want to say yes, but let me first confirm this internally and get back to
> you.

The software sequence for L1D flush was not validated to mitigate MMIO
Stale Data. To be on safer side, it is better to not rely on the sequence.

OTOH, if a user has not updated the microcode to mitigate L1TF, the system
will not have the microcode to mitigate MMIO Stale Data either, because the
microcode for MMIO Stale Data was released after L1TF. Also I am not aware
of any CPUs that are vulnerable to L1TF and vulnerable to MMIO Stale Data
only(not MDS).

So in practice, decoupling L1D flush and MMIO Stale Data won't have any
practical impact on functionality, and makes MMIO Stale Data mitigation
consistent with MDS mitigation. I hope that makes things clear.

