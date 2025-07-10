Return-Path: <kvm+bounces-52017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B86E7AFFB52
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 09:49:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43ABE1C43687
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 07:50:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C2F328B4FA;
	Thu, 10 Jul 2025 07:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QAEWGaGd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66711F1313;
	Thu, 10 Jul 2025 07:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752133778; cv=none; b=VVhlCFA6ODP2UNVAX92P4IavT6kMQfR6QXPTwm4mgFXjy6M67JmSjwkOJEu09sYc3WTmObmFBiSdbT/tQZOWWwnsx0WqV0ATSO3Ea05LA9ag3y+nZA2O29OyUA4pyFisZ7TeQW0pzq9NS52LXVxivkCKl+yKultmvHMsWKs3TQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752133778; c=relaxed/simple;
	bh=s1gPWPDHMHee3mZrHp5MkTm92bihm3mxBUZdy5mNbCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pVQe8KKhht7C08ZETSn22aN0N7/t1+k+xY3kH6F4pm9zruMa8k+ykvtzjyY4AgMNjSpGuQdmZK00rYfcBNmRfcAIQBgKcMkrBMdG9Y8boHzhyi2Ew1dxlAl5yYReiQfH3hXBfa4OEtt8IJxTRIWHnbADwj/sXbqRRiOMbv1zCE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QAEWGaGd; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752133776; x=1783669776;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=s1gPWPDHMHee3mZrHp5MkTm92bihm3mxBUZdy5mNbCw=;
  b=QAEWGaGdLoj5SkO4UGwFMQuNyJzTLFzpy8JN6OvVbzT5q0NCY86UhFAU
   XglmrMxtnQVa7/cT9SBWYtDllRGJhrjLeemu+8Vaj0gKprGxd9azpdpbf
   z+GojMhSx0iN5+WI4GT4+IiKPSu9HMdk/mw011BcwhBN1Kcw95Zp0Kah/
   iOco6y/tBMApR1tmndE5YKdITu/2t7P7UtxZ3SbU6BI+LTL97HWb2yUk4
   hG7YI4ZP2nKb+Pk+JZzuvWcpAnUHgcl3x+80+3Xm9dNn6DszDtTNwINYC
   wnwOIWYlBZhmUDUQ3w8i/MkZceiJli/G8KjqQqDLlx/fMJfaoQSb7sfc+
   A==;
X-CSE-ConnectionGUID: A2OyIgQrS3KbHuh5VXGxKg==
X-CSE-MsgGUID: SWD6fMk/QACCm9OtJYMe4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="54535502"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="54535502"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 00:49:36 -0700
X-CSE-ConnectionGUID: RS8IeWZ7S56KymhinSUNaQ==
X-CSE-MsgGUID: ByqQhlgmR8qd9qcAJCFDsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="186973491"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa001.fm.intel.com with ESMTP; 10 Jul 2025 00:49:32 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 15DDA1B7; Thu, 10 Jul 2025 10:49:31 +0300 (EEST)
Date: Thu, 10 Jul 2025 10:49:30 +0300
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
Subject: Re: [PATCHv2 07/12] KVM: TDX: Preallocate PAMT pages to be used in
 page fault path
Message-ID: <prt55pslqia6m62m74lseca5xw4kcrxv7gthfnulnbousgxbg3@6zxi46s5rz5p>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-8-kirill.shutemov@linux.intel.com>
 <f58bca0331f3ba0bcd55d68f86c2563e6aa70747.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f58bca0331f3ba0bcd55d68f86c2563e6aa70747.camel@intel.com>

On Thu, Jul 10, 2025 at 01:34:19AM +0000, Edgecombe, Rick P wrote:
> On Mon, 2025-06-09 at 22:13 +0300, Kirill A. Shutemov wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index cbc84c6abc2e..d99bb27b5b01 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -616,6 +616,12 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
> >  		if (r)
> >  			return r;
> >  	}
> > +
> > +	r = kvm_mmu_topup_memory_cache(&vcpu->arch.pamt_page_cache,
> > +				       tdx_nr_pamt_pages() * PT64_ROOT_MAX_LEVEL);
> > +	if (r)
> > +		return r;
> > +
> 
> Shouldn't this be only for TD vCPUs?

Ah. Good point. I didn't consider legacy VMs on TDX-enabled host.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

