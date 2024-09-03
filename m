Return-Path: <kvm+bounces-25701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E2EE4969327
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 07:15:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71C5F1F223CA
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 05:15:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1CF1CE711;
	Tue,  3 Sep 2024 05:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NzAd7adt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF43E1A302B;
	Tue,  3 Sep 2024 05:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725340539; cv=none; b=gc7frc0P5Vvuh66FnqF9xTfzwfzL/5rfi2QQ39Bxd33rf6O6eOnmKSwUSXLRWMtx4juutAblQnj7R28tSHyzeCDoVRHb7GEDcZw506x3vNOSTAOQTXcCdlKa9TTDBOri0ygBHil2vcgoaJp7zo3H7xYZL+fxUJ10jJttLhtDumE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725340539; c=relaxed/simple;
	bh=5pGzzaXFHuizYR7w0upkczQmmZoRE5GU/jg2UXe6CBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pwbnaj5/TIPm+A4y90UMECylViwyA2HC/M5BDNP9QmUiNylO+5ymM7hrxUR1dSYfv6y7TXET+yYs7+OOTsb4Uqceo/Fzhjo2+iyx5ZOVWNWYHRvW/G7bQS5qmdd1nVJI6fnNrP1y9KaI3yvS716BoR8qS1TzArW5h+X9dT1ncXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NzAd7adt; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725340538; x=1756876538;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5pGzzaXFHuizYR7w0upkczQmmZoRE5GU/jg2UXe6CBM=;
  b=NzAd7adtDGezX5ODj+t+Bxql5GwxMLLfLTkB6E9CduqQ874r46NuYryJ
   1LawrlLj8l619q/hGWi8+7gkhIw9er0TtODWQyCZWT2vkobp104QFnMas
   6WFZ/1jS4+2TzbiMkiWhaWRACX0kA9o69+ZQp34VrLNtJF6NVq32KVkSP
   AN1DKzZOl0GoyZE5mZD0VbFUtzh8wCApKv5JUnDyHgzaKkqaq1/AM8ORr
   c5qw/qsqlNYKoSmfeMambOwRS+heqC/Az+p0nMn8T1nfdg/8HDlsY2Of5
   d0LhJYPuu8yjBmcGpVkJAxqxXP5c1lSAD/yV+j4uganG4w/T98UtpioAP
   A==;
X-CSE-ConnectionGUID: WDU/+8V6TamZ7Y/+yNWfOg==
X-CSE-MsgGUID: qAPqTEcPQISBKTRVo2gkqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="24073149"
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="24073149"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 22:15:37 -0700
X-CSE-ConnectionGUID: r0q2XG+lQgCbT/VErKTA3Q==
X-CSE-MsgGUID: XMz0dyqBR5akKaAgCllmgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="65286268"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa007.jf.intel.com with ESMTP; 02 Sep 2024 22:15:32 -0700
Date: Tue, 3 Sep 2024 13:13:01 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	pratikrajesh.sampat@amd.com, michael.day@amd.com,
	david.kaplan@amd.com, dhaval.giani@amd.com,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 13/21] KVM: X86: Handle private MMIO as shared
Message-ID: <Ztaa3TpDLKrEY0Ys@yilunxu-OptiPlex-7050>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-14-aik@amd.com>
 <ZtH55q0Ho1DLm5ka@yilunxu-OptiPlex-7050>
 <49226b61-e7d3-477f-980b-30567eb4d069@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49226b61-e7d3-477f-980b-30567eb4d069@amd.com>

On Mon, Sep 02, 2024 at 12:22:56PM +1000, Alexey Kardashevskiy wrote:
> 
> 
> On 31/8/24 02:57, Xu Yilun wrote:
> > On Fri, Aug 23, 2024 at 11:21:27PM +1000, Alexey Kardashevskiy wrote:
> > > Currently private MMIO nested page faults are not expected so when such
> > > fault occurs, KVM tries moving the faulted page from private to shared
> > > which is not going to work as private MMIO is not backed by memfd.
> > > 
> > > Handle private MMIO as shared: skip page state change and memfd
> > 
> > This means host keeps the mapping for private MMIO, which is different
> > from private memory. Not sure if it is expected, and I want to get
> > some directions here.
> 
> There is no other translation table on AMD though, the same NPT. The

Sorry for not being clear, when I say "host mapping" I mean host
userspace mapping (host CR3 mapping). By using guest_memfd, there is no
host CR3 mapping for private memory. I'm wondering if we could keep host
CR3 mapping for private MMIO.

> security is enforced by the RMP table. A device says "bar#x is private" so
> the host + firmware ensure the each corresponding RMP entry is "assigned" +
> "validated" and has a correct IDE stream ID and ASID, and the VM's kernel
> maps it with the Cbit set.
> 
> >  From HW perspective, private MMIO is not intended to be accessed by
> > host, but the consequence may varies. According to TDISP spec 11.2,
> > my understanding is private device (known as TDI) should reject the
> > TLP and transition to TDISP ERROR state. But no further error
> > reporting or logging is mandated. So the impact to the host system
> > is specific to each device. In my test environment, an AER
> > NonFatalErr is reported and nothing more, much better than host
> > accessing private memory.
> 
> afair I get an non-fatal RMP fault so the device does not even notice.
> 
> > On SW side, my concern is how to deal with mmu_notifier. In theory, if
> > we get pfn from hva we should follow the userspace mapping change. But
> > that makes no sense. Especially for TDX TEE-IO, private MMIO mapping
> > in SEPT cannot be changed or invalidated as long as TDI is running.
> 
> > Another concern may be specific for TDX TEE-IO. Allowing both userspace
> > mapping and SEPT mapping may be safe for private MMIO, but on
> > KVM_SET_USER_MEMORY_REGION2,  KVM cannot actually tell if a userspace
> > addr is really for private MMIO. I.e. user could provide shared memory
> > addr to KVM but declare it is for private MMIO. The shared memory then
> > could be mapped in SEPT and cause problem.
> 
> I am missing lots of context here. When you are starting a guest with a
> passed through device, until the TDISP machinery transitions the TDI into
> RUN, this TDI's MMIO is shared and mapped everywhere. And after

Yes, that's the situation nowadays. I think if we need to eliminate
host CR3 mapping for private MMIO, a simple way is we don't allow host
CR3 mapping at the first place, even for shared pass through. It is
doable cause:

 1. IIUC, host CR3 mapping for assigned MMIO is only used for pfn
    finding, i.e. host doesn't really (or shouldn't?) access them.
 2. The hint from guest_memfd shows KVM doesn't have to rely on host
    CR3 mapping to find pfn.

> transitioning to RUN you move mappings from EPT to SEPT?

Mostly correct, TDX move mapping from EPT to SEPT after LOCKED and
right before RUN.

> 
> > So personally I prefer no host mapping for private MMIO.
> 
> Nah, cannot skip this step on AMD. Thanks,

Not sure if we are on the same page. I assume from HW perspective, host
CR3 mapping is not necessary for NPT/RMP build?

Thanks,
Yilun

> 
> 
> > 
> > Thanks,
> > Yilun
> > 
> > > page state tracking.
> > > 
> > > The MMIO KVM memory slot is still marked as shared as the guest can
> > > access it as private or shared so marking the MMIO slot as private
> > > is not going to help.
> > > 
> > > Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> > > ---
> > >   arch/x86/kvm/mmu/mmu.c | 6 +++++-
> > >   1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 928cf84778b0..e74f5c3d0821 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -4366,7 +4366,11 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> > >   {
> > >   	bool async;
> > > -	if (fault->is_private)
> > > +	if (fault->slot && fault->is_private && !kvm_slot_can_be_private(fault->slot) &&
> > > +	    (vcpu->kvm->arch.vm_type == KVM_X86_SNP_VM))
> > > +		pr_warn("%s: private SEV TIO MMIO fault for fault->gfn=%llx\n",
> > > +			__func__, fault->gfn);
> > > +	else if (fault->is_private)
> > >   		return kvm_faultin_pfn_private(vcpu, fault);
> > >   	async = false;
> > > -- 
> > > 2.45.2
> > > 
> > > 
> 
> -- 
> Alexey
> 

