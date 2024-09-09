Return-Path: <kvm+bounces-26108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E4579714F2
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 12:10:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6CB4B2311C
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 10:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EE431B3B2D;
	Mon,  9 Sep 2024 10:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lec/Ahsf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8011B3B2B;
	Mon,  9 Sep 2024 10:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725876620; cv=none; b=b8M4W0fM34wNRLVxfF9tctyq4aaQTb2jhEVcPO0Dv+ItXHZdDRRwQqf2uOk/s5ySKh6EJZHJxiBlEDJ3U9gPKi5eZUKRme5fTXoF7L55dNNaUF1kFdUZHetdr2FI1cLmOsIyE8A0HID/m2LVJ5LtJch8ARU/bjTdWcSdP2ao1Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725876620; c=relaxed/simple;
	bh=Q6/cLkEQq9XEo1Xu1WMQ40M9gJ5r2NMV6+rTtbQLAnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lhFrsBxCBQaITu7+40fDV/GKlNSwlW8JHZzKo3zOxX9aTPFw8Ovhkg7a7i2NbmAeo31Eoqmg88ZkV7UUAMuXhAKbtU8d8RkAN2PpaEeCHdP+VuEDGJ7pL2Wxx1Bc2TfzY/kz94Or8qDfJI9Ct9OIGGPLJJIvUMqmh7cgin9cd2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lec/Ahsf; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725876619; x=1757412619;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Q6/cLkEQq9XEo1Xu1WMQ40M9gJ5r2NMV6+rTtbQLAnk=;
  b=lec/Ahsf8AiM6JR7hTGFPNQdDl2+MCf4WVVLNwemkPa+ZsSfaCLLCLxy
   3XLKLpKHgR+BKw7f+BcWfXYKfQ99WLq+yMk0sQJ1n1p/icEDpKkdjs5Ab
   DCjVGnQx/1XlcJjOz0Py478XXQ8DbsRkOyVxj0+xolk4x+CNvph4CA8OQ
   z6Z4mFPNzSsa/u9Xo8Q0xQXlv3B+QuRntIeZiWHtWR3ET7qsjalcZmNFR
   FfMyb3PUpuQrAH2X1oLD0XirofnJ7wMyO1XqucWI5aLngaFChzmq/oSRA
   vfhUvTg2ZATYBTYLoeHmL1d3J9wsidWR1n+4l2C0tP7ANECkjLdEmFe0b
   A==;
X-CSE-ConnectionGUID: bI4XVfOZQxSsnVPIA5Mg8w==
X-CSE-MsgGUID: gwTxTXCrSQWRJcyJCNNGLg==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="13437148"
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="13437148"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 03:10:18 -0700
X-CSE-ConnectionGUID: xS0GuC5UTnuMKizuOOG52A==
X-CSE-MsgGUID: M16vue2hRl65Ueo4nDhEGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="66930014"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa006.jf.intel.com with ESMTP; 09 Sep 2024 03:10:13 -0700
Date: Mon, 9 Sep 2024 18:07:35 +0800
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
Message-ID: <Zt7I51r6dqkwkPAz@yilunxu-OptiPlex-7050>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-14-aik@amd.com>
 <ZtH55q0Ho1DLm5ka@yilunxu-OptiPlex-7050>
 <49226b61-e7d3-477f-980b-30567eb4d069@amd.com>
 <Ztaa3TpDLKrEY0Ys@yilunxu-OptiPlex-7050>
 <262bee4e-7e60-45e6-8920-ec6b8dd0a526@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <262bee4e-7e60-45e6-8920-ec6b8dd0a526@amd.com>

On Fri, Sep 06, 2024 at 01:31:48PM +1000, Alexey Kardashevskiy wrote:
> 
> 
> On 3/9/24 15:13, Xu Yilun wrote:
> > On Mon, Sep 02, 2024 at 12:22:56PM +1000, Alexey Kardashevskiy wrote:
> > > 
> > > 
> > > On 31/8/24 02:57, Xu Yilun wrote:
> > > > On Fri, Aug 23, 2024 at 11:21:27PM +1000, Alexey Kardashevskiy wrote:
> > > > > Currently private MMIO nested page faults are not expected so when such
> > > > > fault occurs, KVM tries moving the faulted page from private to shared
> > > > > which is not going to work as private MMIO is not backed by memfd.
> > > > > 
> > > > > Handle private MMIO as shared: skip page state change and memfd
> > > > 
> > > > This means host keeps the mapping for private MMIO, which is different
> > > > from private memory. Not sure if it is expected, and I want to get
> > > > some directions here.
> > > 
> > > There is no other translation table on AMD though, the same NPT. The
> > 
> > Sorry for not being clear, when I say "host mapping" I mean host
> > userspace mapping (host CR3 mapping). By using guest_memfd, there is no
> > host CR3 mapping for private memory. I'm wondering if we could keep host
> > CR3 mapping for private MMIO.
> > >> security is enforced by the RMP table. A device says "bar#x is
> private" so
> > > the host + firmware ensure the each corresponding RMP entry is "assigned" +
> > > "validated" and has a correct IDE stream ID and ASID, and the VM's kernel
> > > maps it with the Cbit set.
> > > 
> > > >   From HW perspective, private MMIO is not intended to be accessed by
> > > > host, but the consequence may varies. According to TDISP spec 11.2,
> > > > my understanding is private device (known as TDI) should reject the
> > > > TLP and transition to TDISP ERROR state. But no further error
> > > > reporting or logging is mandated. So the impact to the host system
> > > > is specific to each device. In my test environment, an AER
> > > > NonFatalErr is reported and nothing more, much better than host
> > > > accessing private memory.
> > > 
> > > afair I get an non-fatal RMP fault so the device does not even notice.
> > > 
> > > > On SW side, my concern is how to deal with mmu_notifier. In theory, if
> > > > we get pfn from hva we should follow the userspace mapping change. But
> > > > that makes no sense. Especially for TDX TEE-IO, private MMIO mapping
> > > > in SEPT cannot be changed or invalidated as long as TDI is running.
> > > 
> > > > Another concern may be specific for TDX TEE-IO. Allowing both userspace
> > > > mapping and SEPT mapping may be safe for private MMIO, but on
> > > > KVM_SET_USER_MEMORY_REGION2,  KVM cannot actually tell if a userspace
> > > > addr is really for private MMIO. I.e. user could provide shared memory
> > > > addr to KVM but declare it is for private MMIO. The shared memory then
> > > > could be mapped in SEPT and cause problem.
> > > 
> > > I am missing lots of context here. When you are starting a guest with a
> > > passed through device, until the TDISP machinery transitions the TDI into
> > > RUN, this TDI's MMIO is shared and mapped everywhere. And after
> > 
> > Yes, that's the situation nowadays. I think if we need to eliminate
> > host CR3 mapping for private MMIO, a simple way is we don't allow host
> > CR3 mapping at the first place, even for shared pass through. It is
> > doable cause:
> > 
> >   1. IIUC, host CR3 mapping for assigned MMIO is only used for pfn
> >      finding, i.e. host doesn't really (or shouldn't?) access them.
> 
> Well, the host userspace might also want to access MMIO via mmap'ed region
> if it is, say, DPDK.

Yes for DPDK. But I mean for virtualization cases, host doesn't access
assigned MMIO.

I'm not suggesting we remove the entire mmap functionality in VFIO, but
may have a user-optional no-mmap mode for private capable device.

> 
> >   2. The hint from guest_memfd shows KVM doesn't have to rely on host
> >      CR3 mapping to find pfn.
> 
> True.
> 
> > > transitioning to RUN you move mappings from EPT to SEPT?
> > 
> > Mostly correct, TDX move mapping from EPT to SEPT after LOCKED and
> > right before RUN.
> > 
> > > 
> > > > So personally I prefer no host mapping for private MMIO.
> > > 
> > > Nah, cannot skip this step on AMD. Thanks,
> > 
> > Not sure if we are on the same page.
> 
> With the above explanation, we are.
> 
> > I assume from HW perspective, host
> > CR3 mapping is not necessary for NPT/RMP build?
> 
> Yeah, the hw does not require that afaik. But the existing code continues
> working for AMD, and I am guessing it is still true for your case too,

It works for TDX with some minor changes similar as this patch does. But
still see some concerns on my side, E.g. mmu_notifier. Unlike SEV-SNP,
TDX firmware controls private MMIO accessing by building private S2 page
table. If I still follow the HVA based page fault routine, then I should
also follow the mmu_notifier, i.e. change private S2 mapping when HVA
mapping changes. But private MMIO accessing is part of the private dev
configuration and enforced (by firmware) not to be changed when TDI is
RUNning. My effort for this issue is that, don't use HVA based page
fault routine, switch to do like guest_memfd does.

I see SEV-SNP prebuilds RMP to control private MMIO accessing, S2 page
table modification is allowed at anytime. mmu_notifier only makes
private access dis-functional. I assume that could also be nice to
avoid.

> right? Unless the host userspace tries accessing the private MMIO and some
> horrible stuff happens? Thanks,

The common part for all vendors is, the private device will be
disturbed and enter TDISP ERROR state. I'm not sure if this is OK or can
also be nice to avoid.

Thanks,
Yilun

