Return-Path: <kvm+bounces-50143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EE7DAE2135
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 19:44:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7D231BC88E7
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:45:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 855842E9ED9;
	Fri, 20 Jun 2025 17:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PuDiLQCu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E16D1FDA94;
	Fri, 20 Jun 2025 17:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750441475; cv=none; b=neO/sa6m36kw+Ribt9GU2nhuni4Cks7zatTyu5HZvDLvGKX5HSsxc08np8/uK/AYvJb5Xr7knKgdtz6jS36vqaEyjJW9DFL3D+uL9QW2X8ZYYfQqLAOdY+xRyhw8spSGjkmhFGJO/tZgArUrV8zzevVKmB+at4D9X5FnwOVAdus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750441475; c=relaxed/simple;
	bh=WHqfpS5wfl3SUZ6bTzlfzUKRE/FxJ6tiQge4OQx1+kc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PcajBFuokqCKOoEANb4m6YiszqN9MJHcevRgUeKggDmCMKTynzwMPjhFOgV4h9bfunu8ohEF6wo9npbW/hZ/plH0SIoatffmS8dmnq/E5TYXDTyOKYQimnm6MwGyTzYl7C3Da6orULHCrRmd1t9yks4yc7otas3AY+2r3f22tDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PuDiLQCu; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750441474; x=1781977474;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WHqfpS5wfl3SUZ6bTzlfzUKRE/FxJ6tiQge4OQx1+kc=;
  b=PuDiLQCu6wpHejuOUiWa2IkPYtzM7Inm4mCXP52xWY9cgwgSDk9duXmF
   iCjJkQet15NBDoPpF+JP72tLroRF/MScwgQOsNMsg3GbKG13+BuUl0fD5
   j3XYSVcD5U1+f2Gi39V+/Y1VQuz9t/0gKjaLbJbgWp7no6mmTYEg86a3n
   b/bIyfjyGkVzvxcs8pBMzbvWyr8iq1CqUhQaNgUNsJcxoB9DLgs280mVz
   egiJdU+CLZsz1dvOlYjJZnn9w7RxsazHTRp3G+mfGJ3QJkJhBMyJKq2/E
   M4rSprJvR1YhNLU2wi5LFnheI0vT83K10L1f7FBF5fLwcyKkwiz7nNBhd
   A==;
X-CSE-ConnectionGUID: rVzg6NuFQb6TCqi55hBnjg==
X-CSE-MsgGUID: BA87ns6vT6etODHUbA8pcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="55346808"
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="55346808"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 10:44:33 -0700
X-CSE-ConnectionGUID: nJXYgtEbRdienSYO9ebeRw==
X-CSE-MsgGUID: 5QiXIHYSQQS37khADhTqQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="188193391"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa001.jf.intel.com with ESMTP; 20 Jun 2025 10:44:26 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 771D2109; Fri, 20 Jun 2025 20:44:25 +0300 (EEST)
Date: Fri, 20 Jun 2025 20:44:25 +0300
From: Kirill Shutemov <kirill.shutemov@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, Fan Du <fan.du@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kai Huang <kai.huang@intel.com>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, 
	Dave Hansen <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	Zhiquan1 Li <zhiquan1.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	Chao P Peng <chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Ira Weiny <ira.weiny@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, "tabba@google.com" <tabba@google.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, Jun Miao <jun.miao@intel.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <4m25vi2w2r4zfmck4giiqryy64etpfvozyqifv4f3i636i7i2o@erv7a6wrtvyy>
References: <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com>
 <cbee132077fd59f181d1fc19670b72a51f2d9fa1.camel@intel.com>
 <aEyj_5WoC-01SPsV@google.com>
 <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
 <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
 <803d857f730e205f0611ec97da449a9cf98e4ffb.camel@intel.com>
 <t6z42jxmbskbtiruoz2hj67d7dwffu6sgpsfcvkwl6mpysgx2b@5ssfh35xckyr>
 <aFWNLZQ7pqQahdEh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFWNLZQ7pqQahdEh@google.com>

On Fri, Jun 20, 2025 at 09:32:45AM -0700, Sean Christopherson wrote:
> On Wed, Jun 18, 2025, Kirill Shutemov wrote:
> > On Wed, Jun 18, 2025 at 04:22:59AM +0300, Edgecombe, Rick P wrote:
> > > On Tue, 2025-06-17 at 08:52 +0800, Yan Zhao wrote:
> > > > > hopefully is just handling accepting a whole range that is not 2MB aligned.
> > > > > But
> > > > > I think we need to verify this more.
> > > > Ok.
> > > 
> > > In Linux guest if a memory region is not 2MB aligned the guest will accept the
> 
> What is a "memory region" in this context?  An e820 region?  Something else?

EFI memory map entry.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

