Return-Path: <kvm+bounces-52019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05CA7AFFCB5
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 10:45:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 433D61C243E2
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 08:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B5128C86D;
	Thu, 10 Jul 2025 08:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i9tcv87J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5651212B28;
	Thu, 10 Jul 2025 08:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752137135; cv=none; b=QEZiTu/ioE4p/OrIKMRBG7VmG+k33Re3+gWjiUy9jCmuudDC0IjN8kfJLGX34scCEmdmZVnuoIyFqZhTjht+Yq+Mp7IuJJDBSjrv1jJlAUa7n3fxB18V5lsMweMYa6C5oBk/qOYnTGgwt6tFjetNlL7BBk76AYIYHgQ4Agmtzvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752137135; c=relaxed/simple;
	bh=uzTHlkiMqVttpURo60tiyRON8rgNyiEWMXPl9W1Ix6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nFBoS638w/kHKGbWaux8srrPO2MOKtq5yLDAFkA1vI/aHmFFxRRnVWo4MoO0uBEdHOMtrPREq9qyE0HkPWaBjLBMdSMVqmgPcyxAiX0czlM5UIsjfxDo2PqdBd5aHUMl0L6ddTbyAIifVyhKKzacRzOJUfFV0pWBweE1ot3CY7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i9tcv87J; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752137134; x=1783673134;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=uzTHlkiMqVttpURo60tiyRON8rgNyiEWMXPl9W1Ix6w=;
  b=i9tcv87JBNxlWHpvZuVJP/veY5wCSMj5ghsTNmgX3wfAPcHAKRR+8Lc4
   kGwvxbZIBeTyV8YdjSJVMKKMHiCiKtvZDbwBJ3CDhxg6HJvQSRcUmfNkA
   JP4Voe5LVsrCXxdyVPuYJQzenqR4HgGPzDdWVT8Yi155hhXqKW5OUuZxt
   hijy5T1muTazgMm0uo4GkNjY7qJjnM9mDIOIY5NybXIHDgFDbgppujX4n
   +hX10VIeiApEwMeSFBFWDVO+YmmZWPB0+y5qkJOWYF4AjyTxh/6t6qlqu
   pCw6JaIvRjxwh3t+gvRR9/+vmPTCI33sMwk4hXVPoqajHo4ztE/EzFqq+
   g==;
X-CSE-ConnectionGUID: 9aLoP/4WSySSfGmSrcpKNw==
X-CSE-MsgGUID: MWu0MsAnRv63tq+L7iQtVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="71857203"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="71857203"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 01:45:32 -0700
X-CSE-ConnectionGUID: jKzJ0e0ZTDuIMxVti1Bh6w==
X-CSE-MsgGUID: 60fiJbQISPC03apMVho8eA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="156123394"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa006.fm.intel.com with ESMTP; 10 Jul 2025 01:45:27 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id E00651B7; Thu, 10 Jul 2025 11:45:26 +0300 (EEST)
Date: Thu, 10 Jul 2025 11:45:26 +0300
From: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"Huang, Kai" <kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 08/12] KVM: TDX: Handle PAMT allocation in fault path
Message-ID: <ypsnjhvy2odzedxtujzaumvz4mxe3dcci7biepsjrate7pzw7d@6h7qwy3xcqld>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-9-kirill.shutemov@linux.intel.com>
 <5c0b2e7acbfe59e8919cadfec1ab2503eec1a022.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5c0b2e7acbfe59e8919cadfec1ab2503eec1a022.camel@intel.com>

On Thu, Jul 10, 2025 at 01:33:41AM +0000, Edgecombe, Rick P wrote:
> On Mon, 2025-06-09 at 22:13 +0300, Kirill A. Shutemov wrote:
> >  int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> >  			      enum pg_level level, kvm_pfn_t pfn)
> >  {
> > +	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> 
> This is unfortunate. In practice, all of the callers will be in a vCPU context,
> but __tdp_mmu_set_spte_atomic() can be called for zap's which is why there is no
> vCPU.

IIUC, __tdp_mmu_set_spte_atomic() to zap, only for shared case which is
!is_mirror_sptep() and will not get us here. !shared case get to
tdx_sept_remove_private_spte().

> We don't want to split the tdp mmu calling code to introduce a variant that has
> a vCPU. 
> 
> What about a big comment? Or checking for NULL and returning -EINVAL like
> PG_LEVEL_4K below? I guess in this case a NULL pointer will be plenty loud. So
> probably a comment is enough.

Yes, comment is helpful here

> Hmm, the only reason we need the vCPU here is to get at the the per-vCPU pamt
> page cache. This is also the reason for the strange callback scheme I was
> complaining about in the other patch. It kind of seems like there are two
> friction points in this series:
> 1. How to allocate dpamt pages
> 2. How to serialize the global DPAMT resource inside a read lock
> 
> I'd like to try to figure out a better solution for (1). (2) seems good. But I'm
> still processing.

I tried few different approached to address the problem. See phys_prepare
and phys_cleanup in v1.

> 
> >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> >  	struct page *page = pfn_to_page(pfn);
> > +	int ret;
> > +
> > +	ret = tdx_pamt_get(page, level, tdx_alloc_pamt_page_atomic, vcpu);
> > +	if (ret)
> > +		return ret;
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

