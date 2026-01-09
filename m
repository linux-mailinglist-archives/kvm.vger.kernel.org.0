Return-Path: <kvm+bounces-67497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AF55D06DDA
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 03:36:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8D7A8301EC42
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 02:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD8CC3164B0;
	Fri,  9 Jan 2026 02:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WochmuDf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F12311956;
	Fri,  9 Jan 2026 02:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767926146; cv=none; b=XcdFbO+fyO58JBelsj2WPhcyhw82eolVhA63tZyyT2dlnySEmUJEONcp/G7EW/jI+LHBdoo6S4pU3/4udDEk1ufoabmALlpl4x9e5dUDI6juQbIyvXMqr6eIVP5bqCioL7lW1oBIp+f9ddmIIUfP7WRP/e2UY0C5xtSEPHYLytc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767926146; c=relaxed/simple;
	bh=HRw0laBu/MM4PZ6zlj8FQySlhAoLIYl/PjG53TaFc6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nbQl7fmgap9K0/VHnJObBvSDRNQs4Y31VR51ou91o3Fv8tWoltFpKrjhHUuMhW1kCl+G1FsMkPxDuTiqiDorfEp7w+Ps3YLvMIfWLU8L7NKI2YqgdP1sdGj1+qhDa+nnciwLvGSCBn10NnzvzOd/az6Px6OO6EvpPnGnOI3tlaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WochmuDf; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767926143; x=1799462143;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=HRw0laBu/MM4PZ6zlj8FQySlhAoLIYl/PjG53TaFc6c=;
  b=WochmuDfoXiiR37j6yhIDTsZSvgt0pnOHLKAUik43yG7Fv4l44VnMiCc
   KTSYwM46AZl/CbL7hpPSZGdgJCsr1Vr0+QC/lABg5vKRQ81Cdk6x4aeIG
   xX2GdB4z504FBLO/8NqfAwth3c6ZkGs9uzbuq9pVpW5X0Pd5w3CXyWTh3
   1yyzVqP1mZitYkOoL41TGX6nhuiLvP+00jexyiKGiawX+HvAySf/FGNDD
   JHyNBoMpIlRhPZj10F7j8SIqzCMwsc8Smo8edbFEjio6EVtuKrbzaInb1
   rmoRbghFrUsz+wVEEuoNzty2A2sUFJKinn5QiWxmbH25WAGLZk5Jp+bNx
   Q==;
X-CSE-ConnectionGUID: O5aG8upiRI+I4kzdCsfFnA==
X-CSE-MsgGUID: opTRvUGUQoesFn0u6Gn6xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="69213314"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="69213314"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 18:35:43 -0800
X-CSE-ConnectionGUID: nP7rR3yjSrqhK3nRXPiNDg==
X-CSE-MsgGUID: FXlZI4HIQcqaVC54bHhjzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="234538078"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa001.fm.intel.com with ESMTP; 08 Jan 2026 18:35:39 -0800
Date: Fri, 9 Jan 2026 10:18:24 +0800
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
Message-ID: <aWBlcCUvybAYWed8@yilunxu-OptiPlex-7050>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-5-rick.p.edgecombe@intel.com>
 <aUut+PYnX3jrSO0i@yilunxu-OptiPlex-7050>
 <0734a6cc7da3d210f403fdf3e0461ffba6b0aea0.camel@intel.com>
 <aVyJG+vh9r/ZMmOG@yilunxu-OptiPlex-7050>
 <94b619208022ee29812d871eeacab4f979e51d85.camel@intel.com>
 <aV32uDSqEDOgYp6L@yilunxu-OptiPlex-7050>
 <44fb20f8cfaa732eb34c3f5d3a3ff0c22c713939.camel@intel.com>
 <aV+o1VOTxt8hU4ou@yilunxu-OptiPlex-7050>
 <b4af0f9795d69fdc1f6599032335a2103c2fe29a.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4af0f9795d69fdc1f6599032335a2103c2fe29a.camel@intel.com>

On Thu, Jan 08, 2026 at 04:52:10PM +0000, Edgecombe, Rick P wrote:
> On Thu, 2026-01-08 at 20:53 +0800, Xu Yilun wrote:
> > I actually don't understand why a RDALL seamcall could eliminate
> > the check "if (some_optional_feature_exists) read_it;". IIUC, The
> > check
> > exists because kernel doesn't trust TDX Module so kernel wants to
> > verify
> > the correctness/consistency of the data, otherwise we could accept
> > whatever TDX Module tells us, do the below for each field:
> > 
> >   static int read_sys_metadata_field(u64 field_id, u64 *data)
> >   {
> > 	...
> > 	ret = seamcall(TDH_SYS_RD, &args);
> > 	if (ret == TDX_SUCCESS) {
> > 		*data = args.r8;
> > 		return 0;
> > 	}
> > 
> > 	/* The field doesn't exist */
> > 	if (ret == TDX_METADATA_FIELD_ID_INCORRECT) {
> > 		*data = 0;
> > 		return 0;
> > 	}
> > 
> > 	...
> > 
> > 	/* Real reading error */
> > 	return -EFAULT;
> >   }
> > 
> > The trustness doesn't change no matter how kernel retrieves these
> > data,
> > by a series of RD or a RDALL.
> 
> Having it be field specific behavior (like the diff I posted) means we
> don't need to worry about TDX module bugs where some field read fails
> and we don't catch it.

We still need this specific behavior when we bulk read. Can you accept
a successfully returned blob with TDX_FEATURES0_DYNAMIC_PAMT set but
pamt_page_bitmap_entry_bits field missing? I assume no, so we still
need:

	if (blob->tdx_feature0 & TDX_FEATURES0_DYNAMIC_PAMT)
		check blob->pamt_page_bitmap_entry_bits validity;

BTW: ret == TDX_METADATA_FIELD_ID_INCORRECT is not something bad, TDX
Module is effectively telling us the field doesn't exist.

> 
> By RDALL, I mean a simpler way to bulk read the metadata. So for future

I understand. But as I mentioned that has nothing to do with the
optional feature checking.

> looking changes, let's think about what we need and not try to find yet
> more clever ways to code around the current interface. The amount of

I don't think so, cause I don't see much benifit bulk reading could
bring to us. Bulk reading basically retrieves an _unverified_ blob from
TDX Module. I believe it could also been achieved by a simple iteration
of existing single reads. The major work, data verification, is still
there.

On the other hand, the cost of a newly designed firmware interface for
an already online functionality is not low, especially when you want
backward compatibility to old TDX Module. The worst case is we keep both
sets of the code...

> code and discussion on TDX metadata reading is just too high. Please go
> back and look at the earlier threads if you haven't yet.

I've read most of the threads before my first posting on this topic.
Most of the discussion/effort focus on the effective data verification.
But I haven't found any decisive evidence that bulk reading could
contribute on it.

