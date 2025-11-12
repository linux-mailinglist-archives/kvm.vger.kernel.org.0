Return-Path: <kvm+bounces-62913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A5EF1C53D49
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:03:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A0621343AD6
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 18:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D74363491CD;
	Wed, 12 Nov 2025 18:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lv7QB2Dt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1247082A;
	Wed, 12 Nov 2025 18:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762970558; cv=none; b=up7OeaXhlC98VUXd3Cql+yjEB0o7F5LB9CZhfId8lgZIZkW8arWp0KGfwwXFuIMo0vADX2Q4neihMCvVIYzx//tG+DM7DCGGg44epjZpdkZZok5rBdx2mQZUaU7F00XsIVFthpSf42Aok6UJI3VyUwmxSp9KVgMfxkGln2UBFzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762970558; c=relaxed/simple;
	bh=KnTdiQGGGnjSRqzwMrenCwldrxhYma7VEYYG7jLAEcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XLU+TLyIkvwjpHeJWvkTJoWZxKrtSbhaJIB6N6cfnugdyQbwn2+bmYLodMnB2Cqc0dMm1ckIhpIgw4KyKZFbSAcx7FF9Herrrh33DMFhzqTcBYUSFQ/orWDyOdAlInrido7l4/79hFrU9/NupYPsydMrFt1kpnvZvPtrT0pr7I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lv7QB2Dt; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762970556; x=1794506556;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KnTdiQGGGnjSRqzwMrenCwldrxhYma7VEYYG7jLAEcc=;
  b=lv7QB2DtE8i7jgWRyx3ygRq/qCpLLsC1wNdE48XPdeDrIva2PFlnKgGf
   H3DlYAfDOnLBtSrtJesKNyknhnj5jCI4heHY9KLCrXQAOXUv7oW+xq6ch
   KTCDxLkbZLcN/Nds2QdUckZcGa/dS1Upq7f7NO5msgUqJrGrCaxv+pOn5
   f987m0cFkO4BAlKrJIoOUHDt3nk0vQmLvhbq412ffZoor8q54JrHXiOxp
   lyPCXTxyOzcOR6gg4h1b4xPEBW9ELjlMXUn0l1WKmE30UQkVXPPQxO7Ds
   YpbtEQUrHvWv0EgLPoqb02VPx/cxzkNCScx1Ypcfyncdz0+05SAyMUDQi
   g==;
X-CSE-ConnectionGUID: KpfbwXolTsSr+WcvZr/Kag==
X-CSE-MsgGUID: FmiGtiFRSkCeZ4ssHbBRHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="75653525"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="75653525"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 10:02:35 -0800
X-CSE-ConnectionGUID: 3NNGcx4pSYS0LAJdbYXlFg==
X-CSE-MsgGUID: z6HT8Ee4TDuHE+ieaUhB2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="189057472"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 10:02:35 -0800
Date: Wed, 12 Nov 2025 10:02:29 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 1/8] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
Message-ID: <20251112180229.qmncwarn2w7edt3i@desk>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-2-seanjc@google.com>
 <20251107185941.GSaQ5BnYzN_X9J3Qa0@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107185941.GSaQ5BnYzN_X9J3Qa0@fat_crate.local>

On Fri, Nov 07, 2025 at 07:59:41PM +0100, Borislav Petkov wrote:
> On Thu, Oct 30, 2025 at 05:30:33PM -0700, Sean Christopherson wrote:
> > From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > 
> > TSA mitigation:
> > 
> >   d8010d4ba43e ("x86/bugs: Add a Transient Scheduler Attacks mitigation")
> > 
> > introduced VM_CLEAR_CPU_BUFFERS for guests on AMD CPUs. Currently on Intel
> > CLEAR_CPU_BUFFERS is being used for guests which has a much broader scope
> > (kernel->user also).
> > 
> > Make mitigations on Intel consistent with TSA. This would help handling the
> 
> "consistent" as in "use the VM-specific buffer clearing variant in VMX too"?

That's correct.

> In any case:
> 
> Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

Thanks.

