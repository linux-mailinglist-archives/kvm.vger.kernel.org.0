Return-Path: <kvm+bounces-13501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AD76897B62
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 00:00:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18463287EF9
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 22:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 439A8156965;
	Wed,  3 Apr 2024 22:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k7smNkFR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321152C683;
	Wed,  3 Apr 2024 22:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712181627; cv=none; b=gKCqr7+cMvYzvfMRjx5hBQvmtgjpqnKs76PiG0KE2PqKSHftuzyAR1yKshorRItTGJyCOxVGKtlWZ5rQmPWHw3W7bhl/nwm7IoSKSendLWVfRAWloofGns2bp4deFpdkQsXkXltzWLXZR1rT3rkbDIcT6CMfrga4L5Hp1ZFZ6ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712181627; c=relaxed/simple;
	bh=pe5Iu1sJLHjRTIi+uy7Qm6CLV3XbBf2X8M1qkum1Lf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQOQCRcA0njz4GA12hFT+/uQ9HdZj46RSqlhyeQb8f2uNYnp2p/fhCrg310Rm/TFCKxOs97clUf2qqdQt75fpu4NHP0Fox+o1okd4bviPZjaPiZYYv8lW8mzkFHI8NucRKuSwPCqh6QYt7LHMQv7tiBcSGvqNnVWOm3DJe88bxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k7smNkFR; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712181626; x=1743717626;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pe5Iu1sJLHjRTIi+uy7Qm6CLV3XbBf2X8M1qkum1Lf8=;
  b=k7smNkFRCPSG/yJbkx6u2ly96OUjtsf+rlWM2YbQEAraCeMEHL1YBZJg
   Dyd9ZlKTVmbh0GOKYMWbaps9SIL2vUBMBqgGG2d2buPuPjM3Rv975g9BP
   EmvlIgqW4MPtLYliUbe/jkTPhrLF7ATuWxw34XATuNF/LRKRnaWtOeK5o
   jFGTnpvn7t4GEAEPle1mPfI79Icnkt/QsLNAjUpm58nUgKhmp9a5SuZ8+
   23nuRG2XFTSFEjPHH+xQ+QnoIxqZjpcB+qCqz3Vr6f5V+XZMG8w7ndOdU
   iNN56tCNMuvtg7eNWtG/C49lqzk/vPC7w3LYU6lmETbHWyHfHyyiCVeXs
   g==;
X-CSE-ConnectionGUID: abzajC8WQr+FTIAVS9U1LQ==
X-CSE-MsgGUID: pHH8hDdCTI+Hi2Ea30v3sw==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="7363348"
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="7363348"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 15:00:25 -0700
X-CSE-ConnectionGUID: sypYwUpeQ7+S20xofyUb/A==
X-CSE-MsgGUID: F+hlOZuiTpuvXGw3hlTk5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="18434572"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 15:00:25 -0700
Date: Wed, 3 Apr 2024 15:00:23 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
	isaku.yamahata@gmail.com, linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Federico Parola <federico.parola@polito.it>,
	isaku.yamahata@linux.intel.com
Subject: Re: [RFC PATCH 0/8] KVM: Prepopulate guest memory API
Message-ID: <20240403220023.GL2444378@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <ZekQFdPlU7RDVt-B@google.com>
 <20240307020954.GG368614@ls.amr.corp.intel.com>
 <20240319163309.GG1645738@ls.amr.corp.intel.com>
 <Zg2gPaXWjYxr8woR@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zg2gPaXWjYxr8woR@google.com>

On Wed, Apr 03, 2024 at 11:30:21AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Tue, Mar 19, 2024, Isaku Yamahata wrote:
> > On Wed, Mar 06, 2024 at 06:09:54PM -0800,
> > Isaku Yamahata <isaku.yamahata@linux.intel.com> wrote:
> > 
> > > On Wed, Mar 06, 2024 at 04:53:41PM -0800,
> > > David Matlack <dmatlack@google.com> wrote:
> > > 
> > > > On 2024-03-01 09:28 AM, isaku.yamahata@intel.com wrote:
> > > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > > 
> > > > > Implementation:
> > > > > - x86 KVM MMU
> > > > >   In x86 KVM MMU, I chose to use kvm_mmu_do_page_fault().  It's not confined to
> > > > >   KVM TDP MMU.  We can restrict it to KVM TDP MMU and introduce an optimized
> > > > >   version.
> > > > 
> > > > Restricting to TDP MMU seems like a good idea. But I'm not quite sure
> > > > how to reliably do that from a vCPU context. Checking for TDP being
> > > > enabled is easy, but what if the vCPU is in guest-mode?
> > > 
> > > As you pointed out in other mail, legacy KVM MMU support or guest-mode will be
> > > troublesome.
> 
> Why is shadow paging troublesome?  I don't see any obvious issues with effectively
> prefetching into a shadow MMU with read fault semantics.  It might be pointless
> and wasteful, as the guest PTEs need to be in place, but that's userspace's problem.

The populating address for shadow paging is GVA, not GPA.  I'm not sure if
that's what the user space wants.  If it's user-space problem, I'm fine.


> Testing is the biggest gap I see, as using the ioctl() for shadow paging will
> essentially require a live guest, but that doesn't seem like it'd be too hard to
> validate.  And unless we lock down the ioctl() to only be allowed on vCPUs that
> have never done KVM_RUN, we need that test coverage anyways.

So far I tried only TDP MMU case.  I can try other MMU type.


> And I don't think it makes sense to try and lock down the ioctl(), because for
> the enforcement to have any meaning, KVM would need to reject the ioctl() if *any*
> vCPU has run, and adding that code would likely add more complexity than it solves.
> 
> > > The use case I supposed is pre-population before guest runs, the guest-mode
> > > wouldn't matter. I didn't add explicit check for it, though.
> 
> KVM shouldn't have an explicit is_guest_mode() check, the support should be a
> property of the underlying MMU, and KVM can use the TDP MMU for L2 (if L1 is
> using legacy shadow paging, not TDP).

I see.  So the type of the populating address can vary depending on vcpu mode.
It's user-space problem which address (GVA, L1 GPA, L2 GPA) is used.


> > > Any use case while vcpus running?
> > > 
> > > 
> > > > Perhaps we can just return an error out to userspace if the vCPU is in
> > > > guest-mode or TDP is disabled, and make it userspace's problem to do
> > > > memory mapping before loading any vCPU state.
> > > 
> > > If the use case for default VM or sw-proteced VM is to avoid excessive kvm page
> > > fault at guest boot, error on guest-mode or disabled TDP wouldn't matter.
> > 
> > Any input?  If no further input, I assume the primary use case is pre-population
> > before guest running.
> 
> Pre-populating is the primary use case, but that could happen if L2 is active,
> e.g. after live migration.
> 
> I'm not necessarily opposed to initially adding support only for the TDP MMU, but
> if the delta to also support the shadow MMU is relatively small, my preference
> would be to add the support right away.  E.g. to give us confidence that the uAPI
> can work for multiple MMUs, and so that we don't have to write documentation for
> x86 to explain exactly when it's legal to use the ioctl().

If we call kvm_mmu.page_fault() without caring of what address will be
populated, I don't see the big difference.  
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

