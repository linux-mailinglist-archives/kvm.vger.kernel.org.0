Return-Path: <kvm+bounces-48654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0B6EAD004A
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 12:20:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4057117234C
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 10:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 344392874F1;
	Fri,  6 Jun 2025 10:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O2TBQgm+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4743234;
	Fri,  6 Jun 2025 10:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749205248; cv=none; b=VRb7yRkASCC2Xws7ep6rAdaRaDpM8CkZWNZkytGAoOvKNug4aaN652170IUudt6ASnQ8eG8BsY9fgn3lhAsOLjqfK5aq6hySjuZkTv3LUA5KE5if6bQ3KWRhTrgjBaR5AFHjrroJG2FCVXfBM4g3pGHAPJpgwqewqLS+GznQU9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749205248; c=relaxed/simple;
	bh=epgRitmYmh+pCl0kPJqy/dP9YSMXKOFMFlSBPo7GER4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LbyNekxqDFr7TVaMzK7IpAePgfK4olv5+Sai4fFlT+ax3+riwXYyTS7waDpit1GHUyPS9sB3jSypcnC4EZ1bFc7APy2LpE3rev/OScebsA/4wmydGZKnMxGeGCqsQZNKt5tOR1GZ2/gg+jy5ICivPu+eiIxoyCruzugceYEGRtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O2TBQgm+; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749205245; x=1780741245;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=epgRitmYmh+pCl0kPJqy/dP9YSMXKOFMFlSBPo7GER4=;
  b=O2TBQgm++oSOCd3h0ujKvAv3X3W9WGXwrkDhNSplE3bSoMHgaO3Kpptu
   YhNFodgbszjxVuEZf8PO6GKXO/3TyTICyI8VAdo+q7Ve8ksE/5uQOwD9B
   xC047ImBkGQT/QRYFBUg+CaJS3UTCFVdmvtvGyTcR3rgkQPvQ1mhdkRcR
   HPmxSOLSRgwRABUJ7ui3mqiRzeUPhxin42uznFlyzj537iJJDX4CxykhA
   7ZA2k3WFNo8H9+Fzdm7ILE3sn1YcM4hp1s65C2XJfxeubyhDq5YpAfKbp
   j5EHZccL04GwpWJWVCgMM1FsyIAmVHcGLT41RhV26LRuLYllW1NRldn7Q
   g==;
X-CSE-ConnectionGUID: cZvd/jjjQW+nzCaRVOY8zg==
X-CSE-MsgGUID: mVNE2ym8RNewz0vJ6MpeKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11455"; a="61977245"
X-IronPort-AV: E=Sophos;i="6.16,214,1744095600"; 
   d="scan'208";a="61977245"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2025 03:20:44 -0700
X-CSE-ConnectionGUID: +svysx1JSoyiYWiXgHUdlQ==
X-CSE-MsgGUID: xJW5mPRoTdOZzOxwMKJj3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,214,1744095600"; 
   d="scan'208";a="146140174"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa008.fm.intel.com with ESMTP; 06 Jun 2025 03:20:42 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 2415E1FE; Fri, 06 Jun 2025 13:20:40 +0300 (EEST)
Date: Fri, 6 Jun 2025 13:20:40 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"seanjc@google.com" <seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Subject: Re: [RFC, PATCH 08/12] KVM: x86/tdp_mmu: Add phys_prepare() and
 phys_cleanup() to kvm_x86_ops
Message-ID: <ukcotpjhkzs7mxrzp7u47skkljlxj26726wlefnq7gau6w6a7t@rzlqtq24jytf>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-9-kirill.shutemov@linux.intel.com>
 <aBn4pfn4aMXcFHd7@yzhao56-desk.sh.intel.com>
 <t2im27kgcfsl2qltxbf3cear35szyoafczgvmmwootxthnbcdp@dasmg4bdfd6i>
 <aB1ZplDCPkDCkhQr@yzhao56-desk.sh.intel.com>
 <2bi4cz2ulrki62odprol253mhxkvjdu3xtq4p6dbndowsufnmu@7kzlzywmi22s>
 <8668efe87d6e538b5a49a3c7508ade612a6d766b.camel@intel.com>
 <mgu7at7d3qy4h55bchxfmxj6yzqyi7gh4ieds4ecdvlv243frl@bzou376shiak>
 <wwftow6boiueqbzrbfpedxs3e3ioelx3aqmsblzal6kxqdt3d5@dljyaozrfiry>
 <46e0a089ea78613be5f0287eeca449231731f824.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46e0a089ea78613be5f0287eeca449231731f824.camel@intel.com>

On Thu, Jun 05, 2025 at 10:21:46PM +0000, Huang, Kai wrote:
> On Thu, 2025-06-05 at 16:01 +0300, kirill.shutemov@linux.intel.com wrote:
> > On Fri, May 23, 2025 at 03:00:56PM +0300, kirill.shutemov@linux.intel.com wrote:
> > > On Wed, May 14, 2025 at 12:00:17AM +0000, Huang, Kai wrote:
> > > > On Mon, 2025-05-12 at 12:55 +0300, Kirill A. Shutemov wrote:
> > > > > On Fri, May 09, 2025 at 09:25:58AM +0800, Yan Zhao wrote:
> > > > > > On Thu, May 08, 2025 at 04:23:56PM +0300, Kirill A. Shutemov wrote:
> > > > > > > On Tue, May 06, 2025 at 07:55:17PM +0800, Yan Zhao wrote:
> > > > > > > > On Fri, May 02, 2025 at 04:08:24PM +0300, Kirill A. Shutemov wrote:
> > > > > > > > > The functions kvm_x86_ops::link_external_spt() and
> > > > > > > > > kvm_x86_ops::set_external_spte() are used to assign new memory to a VM.
> > > > > > > > > When using TDX with Dynamic PAMT enabled, the assigned memory must be
> > > > > > > > > covered by PAMT.
> > > > > > > > > 
> > > > > > > > > The new function kvm_x86_ops::phys_prepare() is called before
> > > > > > > > > link_external_spt() and set_external_spte() to ensure that the memory is
> > > > > > > > > ready to be assigned to the virtual machine. In the case of TDX, it
> > > > > > > > > makes sure that the memory is covered by PAMT.
> > > > > > > > > 
> > > > > > > > > kvm_x86_ops::phys_prepare() is called in a context where struct kvm_vcpu
> > > > > > > > > is available, allowing the implementation to allocate memory from a
> > > > > > > > > per-VCPU pool.
> > > > > > > > > 
> > > > > > > > Why not invoke phys_prepare() and phys_cleanup() in set_external_spte_present()?
> > > > > > > > Or in tdx_sept_set_private_spte()/tdx_sept_link_private_spt()?
> > > > > > > 
> > > > > > > Because the memory pool we allocated from is per-vcpu and we lost access
> > > > > > > to vcpu by then. And not all callers provide vcpu.
> > > > > > Maybe we can get vcpu via kvm_get_running_vcpu(), as in [1].
> > > > > > Then for callers not providing vcpu (where vcpu is NULL), we can use per-KVM
> > > > > > cache? 
> > > > > 
> > > > > Hm. I was not aware of kvm_get_running_vcpu(). Will play with it, thanks.
> > > > 
> > > > I am not sure why per-vcpu cache matters.
> > > > 
> > > > For non-leaf SEPT pages, AFAICT the "vcpu->arch.mmu_external_spt_cache" is just
> > > > an empty cache, and eventually __get_free_page() is used to allocate in:
> > > >                                                                                             
> > > >   sp->external_spt = 
> > > > 	kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_external_spt_cache);
> > > > 
> > > > So why not we actually create a kmem_cache for it with an actual 'ctor', and we
> > > > can call tdx_alloc_page() in that.  This makes sure when the "external_spt" is
> > > > allocated, the underneath PAMT entry is there.
> > > 
> > > I looked closer to this and while it is good idea, but ctor in kmem_cache
> > > cannot fail which makes this approach not viable.
> > > 
> > > I guess we can a constructor directly into struct kvm_mmu_memory_cache.
> > > Let me play with this.
> > 
> > I failed to make it work.
> > 
> > We need to have destructor paired with the constructor that would do
> > PAMT-aware freeing. And redirect all free paths to it. It requires
> > substantial rework. I don't think it worth the effort.
> > 
> > Will do manual PAMT management for SPT in TDX code.
> 
> Thanks for the effort.
> 
> Maybe something below?

With help of kvm_get_running_vcpu(), I localized these manipulations to
the internals of TDX code. No need to leak this to TDP.

phys_prepare/cleanup() is gone now.

https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git/commit/?h=tdx/dpamt-huge&id=72394699b5454aac6c027accab6d94a52d88819b

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

