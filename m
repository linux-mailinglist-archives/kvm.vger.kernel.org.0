Return-Path: <kvm+bounces-12965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFEED88F74A
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 06:34:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CEC91F2795A
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 05:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C220545962;
	Thu, 28 Mar 2024 05:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SuoXD+Wl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2EA29CFB;
	Thu, 28 Mar 2024 05:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711604076; cv=none; b=jyv2o5J7QLdKWWuTv66a0gsOrplZOFl2PGiSxerml8KuGVGaT3HExkxkaYXjDraMTJnZFgaOhOX0/R6DTRBp0aV/Mhef6DP6+Xpe/Gx5pdUCMysPsXaLGRdRMmGxsnJ/O5CZqdCDPYDT63fXH7bUqd6QopiCjXvGxpZKHPNxZWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711604076; c=relaxed/simple;
	bh=mD9mu8ljlH9TWKDCVXvuWCIuqCU25f2hMJJw0FVXMn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fWUgAl6uCBSxk2lfVHWs/lA3iRBKH4UuJzh/YG+VWtI6GvJt8Z53bUkEy1aFADlCx8Z6MOTDyMRLuDUQrhj3bVBs+mE/79DM6fDjS9WrgBK+hCo7YCN8Vwe090ZiAo3d1CaadRZ3wRPwITeskKREXKyW+DtdHkoai8FWgnW8kZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SuoXD+Wl; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711604075; x=1743140075;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mD9mu8ljlH9TWKDCVXvuWCIuqCU25f2hMJJw0FVXMn0=;
  b=SuoXD+Wlqu53QvAVOBdkay6Ld6oCb/D9+/MjzCFFPy66aNZd8goWfCR1
   KJhPnyFJwok+up1RMzKn3MglI8sbCqwwGI5c814RnmSZhMc8tyWeiNBmt
   Ai0U0bFvB9OaiJFrphT1aojG6PD2I8ek383pcxua2fcvG4JpnbYRrJieb
   njDlj7HfpJFKmrKNcOF5SNcnpL7rfKsoj1e0PVQ2DllBhnTtZBBa7/ZKC
   62rm5+X8IFrXBds8xgHcgFa0+WB//BUoDPfLJYgWXCDikUZfJQpE7ezQU
   QuG4j/N1ZBH9neaciq7ZHFLmaKhFyVnw4r04ID/QGO1UtrRoLb6PKJejM
   g==;
X-CSE-ConnectionGUID: O829oumkQDGS3vy26fujCg==
X-CSE-MsgGUID: ZahUq5iwTdWYm5jvYMnpaw==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="10532019"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="10532019"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 22:34:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16554966"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 22:34:33 -0700
Date: Wed, 27 Mar 2024 22:34:32 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"Yuan, Hang" <hang.yuan@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Message-ID: <20240328053432.GO2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <a0627c0f-5c2d-4403-807f-fc800b43fd3b@intel.com>
 <20240327225337.GF2444378@ls.amr.corp.intel.com>
 <4d925a79-d3cf-4555-9c00-209be445310d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4d925a79-d3cf-4555-9c00-209be445310d@intel.com>

On Thu, Mar 28, 2024 at 02:49:56PM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> 
> On 28/03/2024 11:53 am, Isaku Yamahata wrote:
> > On Tue, Mar 26, 2024 at 02:43:54PM +1300,
> > "Huang, Kai" <kai.huang@intel.com> wrote:
> > 
> > > ... continue the previous review ...
> > > 
> > > > +
> > > > +static void tdx_reclaim_control_page(unsigned long td_page_pa)
> > > > +{
> > > > +	WARN_ON_ONCE(!td_page_pa);
> > > 
> > >  From the name 'td_page_pa' we cannot tell whether it is a control page, but
> > > this function is only intended for control page AFAICT, so perhaps a more
> > > specific name.
> > > 
> > > > +
> > > > +	/*
> > > > +	 * TDCX are being reclaimed.  TDX module maps TDCX with HKID
> > > 
> > > "are" -> "is".
> > > 
> > > Are you sure it is TDCX, but not TDCS?
> > > 
> > > AFAICT TDCX is the control structure for 'vcpu', but here you are handling
> > > the control structure for the VM.
> > 
> > TDCS, TDVPR, and TDCX.  Will update the comment.
> 
> But TDCX, TDVPR are vcpu-scoped.  Do you want to mention them _here_?

So I'll make the patch that frees TDVPR, TDCX will change this comment.


> Otherwise you will have to explain them.
> 
> [...]
> 
> > > > +
> > > > +void tdx_mmu_release_hkid(struct kvm *kvm)
> > > > +{
> > > > +	bool packages_allocated, targets_allocated;
> > > > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > > > +	cpumask_var_t packages, targets;
> > > > +	u64 err;
> > > > +	int i;
> > > > +
> > > > +	if (!is_hkid_assigned(kvm_tdx))
> > > > +		return;
> > > > +
> > > > +	if (!is_td_created(kvm_tdx)) {
> > > > +		tdx_hkid_free(kvm_tdx);
> > > > +		return;
> > > > +	}
> > > 
> > > I lost tracking what does "td_created()" mean.
> > > 
> > > I guess it means: KeyID has been allocated to the TDX guest, but not yet
> > > programmed/configured.
> > > 
> > > Perhaps add a comment to remind the reviewer?
> > 
> > As Chao suggested, will introduce state machine for vm and vcpu.
> > 
> > https://lore.kernel.org/kvm/ZfvI8t7SlfIsxbmT@chao-email/
> 
> Could you elaborate what will the state machine look like?
> 
> I need to understand it.

Not yet. Chao only propose to introduce state machine. Right now it's just an
idea.


> > How about this?
> > 
> > /*
> >   * We need three SEAMCALLs, TDH.MNG.VPFLUSHDONE(), TDH.PHYMEM.CACHE.WB(), and
> >   * TDH.MNG.KEY.FREEID() to free the HKID.
> >   * Other threads can remove pages from TD.  When the HKID is assigned, we need
> >   * to use TDH.MEM.SEPT.REMOVE() or TDH.MEM.PAGE.REMOVE().
> >   * TDH.PHYMEM.PAGE.RECLAIM() is needed when the HKID is free.  Get lock to not
> >   * present transient state of HKID.
> >   */
> 
> Could you elaborate why it is still possible to have other thread removing
> pages from TD?
> 
> I am probably missing something, but the thing I don't understand is why
> this function is triggered by MMU release?  All the things done in this
> function don't seem to be related to MMU at all.

The KVM releases EPT pages on MMU notifier release.  kvm_mmu_zap_all() does. If
we follow that way, kvm_mmu_zap_all() zaps all the Secure-EPTs by
TDH.MEM.SEPT.REMOVE() or TDH.MEM.PAGE.REMOVE().  Because
TDH.MEM.{SEPT, PAGE}.REMOVE() is slow, we can free HKID before kvm_mmu_zap_all()
to use TDH.PHYMEM.PAGE.RECLAIM().


> IIUC, by reaching here, you must already have done VPFLUSHDONE, which should
> be called when you free vcpu?

Not necessarily.


> Freeing vcpus is done in
> kvm_arch_destroy_vm(), which is _after_ mmu_notifier->release(), in which
> this tdx_mmu_release_keyid() is called?

guest memfd complicates things.  The race is between guest memfd release and mmu
notifier release.  kvm_arch_destroy_vm() is called after closing all kvm fds
including guest memfd.

Here is the example.  Let's say, we have fds for vhost, guest_memfd, kvm vcpu,
and kvm vm.  The process is exiting.  Please notice vhost increments the
reference of the mmu to access guest (shared) memory.

exit_mmap():
  Usually mmu notifier release is fired. But not yet because of vhost.

exit_files()
  close vhost fd. vhost starts timer to issue mmput().

  close guest_memfd.  kvm_gmem_release() calls kvm_mmu_unmap_gfn_range().
    kvm_mmu_unmap_gfn_range() eventually this calls TDH.MEM.SEPT.REMOVE()
    and TDH.MEM.PAGE.REMOVE().  This takes time because it processes whole
    guest memory. Call kvm_put_kvm() at last.

  During unmapping on behalf of guest memfd, the timer of vhost fires to call
  mmput().  It triggers mmu notifier release.

  Close kvm vcpus/vm. they call kvm_put_kvm().  The last one calls
  kvm_destroy_vm().  

It's ideal to free HKID first for efficiency. But KVM doesn't have control on
the order of fds.


> But here we are depending vcpus to be freed before tdx_mmu_release_hkid()?

Not necessarily.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

