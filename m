Return-Path: <kvm+bounces-14911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BC368A795C
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 01:52:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88EB2B22EE8
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 23:52:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C508F13AA44;
	Tue, 16 Apr 2024 23:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bKmCmapd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431A28120A;
	Tue, 16 Apr 2024 23:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713311553; cv=none; b=eaOw4NP4a2XJRwfNzrMmZlnb9Afc/ZwI84gNWR1wje0JldF3lOYCOZkv0n2J/L/6o0Xje9zqfN4LHORid2+uaisUUDVkxEVBjczxtqPtBZy9x0EsfBXto/FCoxORaOZFRQz0j9G/zbCnqQBYWCcUagIDe7U4m6bR6Yi0OVWJJRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713311553; c=relaxed/simple;
	bh=6HzpwzhVBJTxkosmKw85+TVSVUAqQ0ZL5X8gG+DYsjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QFkpAET27ZKc9BUYzyZYVOboPKaZZTbNc24FaogSIJuDwT7GZqZTH4T0f79Wgwou8rmXhXr3aWMxHP+taAzgnCVdVTFUAkkzWgvP0pL1H3JdoydiZTZU/4Zea3X51KGekCRpPJNEYB/uupO+uXahvnGPHUooUlPkX52nteLzhxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bKmCmapd; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713311552; x=1744847552;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=6HzpwzhVBJTxkosmKw85+TVSVUAqQ0ZL5X8gG+DYsjk=;
  b=bKmCmapdjwLSiPiouIYlodBAyuTwtQ1Ot8hPK9REm8LaqwKoEw6QrWew
   at1RdGx/3SM6eCxnbbJQMeHc5hFALRDckNTj2fICVqTlR4gmFFmxPGjeG
   KhV58RxhQiwOBbNnOGFPBTyfEEcOO/DnclJgKP5uQrJQYZd4igE0+FTRA
   pzR3fSBr0eL7PdIwm/+VP1GAL5IFToYwIVvnSYwmlT3L3eYJCL179VFvt
   Xh8sV/o6zsigyZtv4dVZj6gTB730S03X50ylMLO+0tEHUuXrxsaq0Q7uF
   4aAN8JUDLfaKjm/XgYyWvuctBwVUGH20yhv9AmWr3rH9lBG41R3ayy8oY
   w==;
X-CSE-ConnectionGUID: m+jxZWecRRKxutRv1BvwdQ==
X-CSE-MsgGUID: p+YPSCVKRp2LWlNPyr5Xyw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="12569131"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="12569131"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 16:52:31 -0700
X-CSE-ConnectionGUID: YnWvpaNZRRukiRVAY3nJTQ==
X-CSE-MsgGUID: 2JKklJJDToClpfxfwgBwNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="26865215"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 16:52:30 -0700
Date: Tue, 16 Apr 2024 16:52:30 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"federico.parola@polito.it" <federico.parola@polito.it>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v2 03/10] KVM: x86/mmu: Extract __kvm_mmu_do_page_fault()
Message-ID: <20240416235230.GB3039520@ls.amr.corp.intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
 <ddf1d98420f562707b11e12c416cce8fdb986bb1.1712785629.git.isaku.yamahata@intel.com>
 <621c260399a05338ba6d034e275e19714ad3665c.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <621c260399a05338ba6d034e275e19714ad3665c.camel@intel.com>

On Tue, Apr 16, 2024 at 02:36:31PM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Wed, 2024-04-10 at 15:07 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Extract out __kvm_mmu_do_page_fault() from kvm_mmu_do_page_fault().  The
> > inner function is to initialize struct kvm_page_fault and to call the fault
> > handler, and the outer function handles updating stats and converting
> > return code.  KVM_MAP_MEMORY will call the KVM page fault handler.
> > 
> > This patch makes the emulation_type always set irrelevant to the return
>            a comma would help parse this better ^
> > code.
> 
> >   kvm_mmu_page_fault() is the only caller of kvm_mmu_do_page_fault(),
> 
> Not technically correct, there are other callers that pass NULL for
> emulation_type.
> 
> > and references the value only when PF_RET_EMULATE is returned.  Therefore,
> > this adjustment doesn't affect functionality.
> 
> Is there a problem with dropping the argument then?
> 
> > 
> > No functional change intended.
> 
> Can we not use the "intended"? It sounds like hedging for excuses.

Thanks for review.
As Chao pointed out, this patch is unnecessary.  I'll use
kvm_mmu_do_page_fault() directly with updating vcpu->stat.

https://lore.kernel.org/all/20240416234334.GA3039520@ls.amr.corp.intel.com/
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

