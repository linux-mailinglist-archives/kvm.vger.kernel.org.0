Return-Path: <kvm+bounces-67199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 59FC7CFC2B4
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 07:18:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 971AB303E6AF
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 06:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFDBA26E6F4;
	Wed,  7 Jan 2026 06:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Plm+LIDn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C053C2F;
	Wed,  7 Jan 2026 06:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767766724; cv=none; b=LPwVhAKKjsb63sTb/H8SnvqJ0Hq5M55d9lgcU/Fz5cXVJ5oL61ejm/u1WEpFXunl72oDUp+MrXEPLJKmSxv3DdlgkR+6L77lpIpMqFKUnIP7eGlnshh0XF1LvMRlPpCrRhXoQqpr1l2UH3WoG67h4J3UoQq7qS1QK1zZh/qoIXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767766724; c=relaxed/simple;
	bh=6xluZTMhHsW030FmsjE/5HGpj9lgqh0b2neQHXV2Hn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EOkvzH9qoqTAHUhoapUa1wl7HiDLAAzlB64WroZZEk6RStEuFB1YLtgXdxIBRZ/SqTgeS3HpfkjCuesQLYjIk/DGn7NoQyHpJ/ca7BeFjscAZSP3N9ggUeP3aoOy3t+DJcNo/4nt7lA2nFgBFFBfq/WridWUMOggxHrfsoJQtbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Plm+LIDn; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767766724; x=1799302724;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=6xluZTMhHsW030FmsjE/5HGpj9lgqh0b2neQHXV2Hn0=;
  b=Plm+LIDnDYG9CcxiKLpkGgpVamSgWN02SjPBe1X5TCypERy3SkBSCQFW
   7Em/H5+Ae55pMlZ3d+GNt0BU9bwY+RolP45Gaqtb718wrXrg34M1l4LuO
   1KYNwWsDMmy7gmUqD9EffSj3GAeNUHtf3/bMkD6EvP2zc2uPSVOzpMPVd
   6+mamn3rmeTaMnOb1tLVKpkzEer0+0kTeEISt8pXnI0Tyyn+nU8cHbJoO
   C0vGkkguwEOeH04S43GPJRM3hkHnL2sU3A01NftgIHmRqNEduT11ok6aP
   OFmtIi8aTqZvgxTZG2Hoh6qt4yh/+Gwxm27QdEeLpaDaGeV1qGKm3BSTt
   A==;
X-CSE-ConnectionGUID: plkQpGhdR3Od0cpJREypcQ==
X-CSE-MsgGUID: DmgELyemTmOAZKMeEI2iAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="72764051"
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="72764051"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 22:18:44 -0800
X-CSE-ConnectionGUID: R/5jzqb1RfmfBg69th97BQ==
X-CSE-MsgGUID: UerDr9qSS6+7bkIx/YMMug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="201973282"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa006.jf.intel.com with ESMTP; 06 Jan 2026 22:18:38 -0800
Date: Wed, 7 Jan 2026 14:01:28 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Message-ID: <aV32uDSqEDOgYp6L@yilunxu-OptiPlex-7050>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-5-rick.p.edgecombe@intel.com>
 <aUut+PYnX3jrSO0i@yilunxu-OptiPlex-7050>
 <0734a6cc7da3d210f403fdf3e0461ffba6b0aea0.camel@intel.com>
 <aVyJG+vh9r/ZMmOG@yilunxu-OptiPlex-7050>
 <94b619208022ee29812d871eeacab4f979e51d85.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94b619208022ee29812d871eeacab4f979e51d85.camel@intel.com>

On Tue, Jan 06, 2026 at 05:00:48PM +0000, Edgecombe, Rick P wrote:
> On Tue, 2026-01-06 at 12:01 +0800, Xu Yilun wrote:
> > Yes the extra indentation is unconventional, but everything here is,
> > and we know we will eventually change them all. So I more prefer
> > simple changes based on:
> > 
> >   if (!ret && !(ret = read_sys_metadata_field(0xABCDEF, &val)))
> > 
> > rather than neat but more LOC (when both are easy to read).
> 
> This whole code style was optimized to be verifiable, not for LOC. Kai
> originally had several macro based solution that had a bunch of code
> reuse before this style got settled on as part of the code gen. It

Yeah, I know the code style in this block is the result of several
rounds discussion, refined but not intend for human read. So I suggest
we only keep the existing steorotypes:

  if (!ret && !(ret = read_sys_metadata_field(0xABCDEF, &val)))
	sysinfo_xxx->xxxxx = val;
and

  ret = ret ?: get_tdx_sys_info_xxx(&sysinfo->xxx);

isolate them, don't create other varients/hybrids of them such as:

  if (!ret && !(ret = get_tdx_sys_info_dpamt_bits(sysinfo_tdmr, &val)))

when we need other logics, to avoid extensive review effort.


That's why I'm more fond of my version, it embraces the steorotype with
a nature "if" for extra logic:

  if (tdx_support_dynamic_pamt(&tdx_sysinfo))
	if (!ret && !(ret = read_sys_metadata_field(0x9100000100000013, &val)))
		sysinfo_tdmr->pamt_page_bitmap_entry_bits = val;

But anyway, if anyone is really uncomfortable with the indentation,
ignore my version.

[...]

> > Anyway, this is trivial concern. I have more optional fields to add
> > and will follow the final decision.
> 
> This is the kind of thing that shouldn't need a clever solution. There
> *should* be a way to more simply copy structured data from the TDX
> module.
> 
> I do think this is a good area for cleanup, but let's not overhaul it
> just to get a small incremental benefit. If we need a new interface in

Agree. I definitely don't want a new TDX module interface for now.

> the TDX module, let's explore it and actually get to something simple.

