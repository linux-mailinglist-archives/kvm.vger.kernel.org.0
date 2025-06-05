Return-Path: <kvm+bounces-48519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76D3FACEFD6
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:02:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A6653A6E34
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 13:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D008F218E91;
	Thu,  5 Jun 2025 13:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bLF8Vj9d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A71521B908;
	Thu,  5 Jun 2025 13:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749128504; cv=none; b=fjyvxzP18GHhGlHtcX1JQ1U5Gh1hXVJi/DwmMJ2VPCY+7f6LvW5bdyYsSkmEtcKwg+5dGa3s22AfO7CXoxF69V23rZhxb/ijumuvbdONZJiCeMEGyIKoGAiW++SFAJTMpctZEJ/yInAM5AH+EqdX37OnU3WlHzs5EW7TUcnfx90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749128504; c=relaxed/simple;
	bh=xnRs7Vv5sYSYQIaen35RN6BXN4ovD8MaQTkoIpnbOhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d6JBAYCqmXciWoepHBtHzvUC7L5lZrj+c6ZmNmkcplpqo1NPlFVJdzySFjCFhQ3cIxfMfG8wFlvslws+cFo/ZGSqotVppK3pmmD5zlQclK+y+RkxQWRQhexu9wVtgNWvqUqlJ2UWVJjKv3mglHHJuk1z70eEKiwg5Rjly9FUNUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bLF8Vj9d; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749128503; x=1780664503;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=xnRs7Vv5sYSYQIaen35RN6BXN4ovD8MaQTkoIpnbOhY=;
  b=bLF8Vj9dvWJY8C6WYChgM/BXqDUjDOeYGGUjeVJN1IVfmoovXohOCJeD
   3q1hQWe6Q51wNP++BcaDAxC1y+KNEbGucwp2DYMTw8cIDo8/tI/xkhpA5
   bvCOlh7TvzqyWV8vMOlod8miKwERmTxYblGJaQQmAyZVdvKm90FA3iTZ6
   Ntr8JR19Al3v5GqeL7AosPW8/0x/AwImaf4Lhb2N3q/c6i3hV92nITxhU
   cH7obU1bu2llszjSio0YDmrpTOCFa7xPIC+sn2VNKDleCcvixoeBaYSn3
   7OpH1FBV6BWQovUeEBACzk83f3H3J3uy4Clokby1bhim1XiVdnHkky9E5
   w==;
X-CSE-ConnectionGUID: xMQp0UOGSP+Ojw7DnPAdow==
X-CSE-MsgGUID: XdCU1Ox4RZmFHwSQ5pnPnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11455"; a="54908124"
X-IronPort-AV: E=Sophos;i="6.16,212,1744095600"; 
   d="scan'208";a="54908124"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 06:01:42 -0700
X-CSE-ConnectionGUID: epT2e4FhR5a38kKrIQTB8A==
X-CSE-MsgGUID: N5AXAFrmTge9OtS8hYr9eA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,212,1744095600"; 
   d="scan'208";a="146011525"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa010.fm.intel.com with ESMTP; 05 Jun 2025 06:01:39 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 591F22A1; Thu, 05 Jun 2025 16:01:37 +0300 (EEST)
Date: Thu, 5 Jun 2025 16:01:37 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Subject: Re: [RFC, PATCH 08/12] KVM: x86/tdp_mmu: Add phys_prepare() and
 phys_cleanup() to kvm_x86_ops
Message-ID: <wwftow6boiueqbzrbfpedxs3e3ioelx3aqmsblzal6kxqdt3d5@dljyaozrfiry>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-9-kirill.shutemov@linux.intel.com>
 <aBn4pfn4aMXcFHd7@yzhao56-desk.sh.intel.com>
 <t2im27kgcfsl2qltxbf3cear35szyoafczgvmmwootxthnbcdp@dasmg4bdfd6i>
 <aB1ZplDCPkDCkhQr@yzhao56-desk.sh.intel.com>
 <2bi4cz2ulrki62odprol253mhxkvjdu3xtq4p6dbndowsufnmu@7kzlzywmi22s>
 <8668efe87d6e538b5a49a3c7508ade612a6d766b.camel@intel.com>
 <mgu7at7d3qy4h55bchxfmxj6yzqyi7gh4ieds4ecdvlv243frl@bzou376shiak>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <mgu7at7d3qy4h55bchxfmxj6yzqyi7gh4ieds4ecdvlv243frl@bzou376shiak>

On Fri, May 23, 2025 at 03:00:56PM +0300, kirill.shutemov@linux.intel.com wrote:
> On Wed, May 14, 2025 at 12:00:17AM +0000, Huang, Kai wrote:
> > On Mon, 2025-05-12 at 12:55 +0300, Kirill A. Shutemov wrote:
> > > On Fri, May 09, 2025 at 09:25:58AM +0800, Yan Zhao wrote:
> > > > On Thu, May 08, 2025 at 04:23:56PM +0300, Kirill A. Shutemov wrote:
> > > > > On Tue, May 06, 2025 at 07:55:17PM +0800, Yan Zhao wrote:
> > > > > > On Fri, May 02, 2025 at 04:08:24PM +0300, Kirill A. Shutemov wrote:
> > > > > > > The functions kvm_x86_ops::link_external_spt() and
> > > > > > > kvm_x86_ops::set_external_spte() are used to assign new memory to a VM.
> > > > > > > When using TDX with Dynamic PAMT enabled, the assigned memory must be
> > > > > > > covered by PAMT.
> > > > > > > 
> > > > > > > The new function kvm_x86_ops::phys_prepare() is called before
> > > > > > > link_external_spt() and set_external_spte() to ensure that the memory is
> > > > > > > ready to be assigned to the virtual machine. In the case of TDX, it
> > > > > > > makes sure that the memory is covered by PAMT.
> > > > > > > 
> > > > > > > kvm_x86_ops::phys_prepare() is called in a context where struct kvm_vcpu
> > > > > > > is available, allowing the implementation to allocate memory from a
> > > > > > > per-VCPU pool.
> > > > > > > 
> > > > > > Why not invoke phys_prepare() and phys_cleanup() in set_external_spte_present()?
> > > > > > Or in tdx_sept_set_private_spte()/tdx_sept_link_private_spt()?
> > > > > 
> > > > > Because the memory pool we allocated from is per-vcpu and we lost access
> > > > > to vcpu by then. And not all callers provide vcpu.
> > > > Maybe we can get vcpu via kvm_get_running_vcpu(), as in [1].
> > > > Then for callers not providing vcpu (where vcpu is NULL), we can use per-KVM
> > > > cache? 
> > > 
> > > Hm. I was not aware of kvm_get_running_vcpu(). Will play with it, thanks.
> > 
> > I am not sure why per-vcpu cache matters.
> > 
> > For non-leaf SEPT pages, AFAICT the "vcpu->arch.mmu_external_spt_cache" is just
> > an empty cache, and eventually __get_free_page() is used to allocate in:
> >                                                                                             
> >   sp->external_spt = 
> > 	kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_external_spt_cache);
> > 
> > So why not we actually create a kmem_cache for it with an actual 'ctor', and we
> > can call tdx_alloc_page() in that.  This makes sure when the "external_spt" is
> > allocated, the underneath PAMT entry is there.
> 
> I looked closer to this and while it is good idea, but ctor in kmem_cache
> cannot fail which makes this approach not viable.
> 
> I guess we can a constructor directly into struct kvm_mmu_memory_cache.
> Let me play with this.

I failed to make it work.

We need to have destructor paired with the constructor that would do
PAMT-aware freeing. And redirect all free paths to it. It requires
substantial rework. I don't think it worth the effort.

Will do manual PAMT management for SPT in TDX code.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

