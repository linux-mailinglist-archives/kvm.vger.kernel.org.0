Return-Path: <kvm+bounces-64341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DC198C8005B
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B2D6A342EDF
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 10:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3CE62FB614;
	Mon, 24 Nov 2025 10:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hdjmaa+O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA082FABE7;
	Mon, 24 Nov 2025 10:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763981810; cv=none; b=lEkUce4htpUTpwDUIS72aOxpTMFneugeIvRQRH607z+feCt5MJWCmW79AfemRQ0izlH62DKDrZULIeIu9cuKaxREZCidEPeizyAv+Gk2eqsV2Txu8wxNXV3Nqg/Ocmcwnexili2PU6iPityHqLrJfBffw7r1GBX7qPbLrwoRauQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763981810; c=relaxed/simple;
	bh=ozqoEWoU3Kf1FbVG4nlV6Tj44DWQiviD0axSH3wKX2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RtGUhfNnxoPl80L64bqWM13qBiG1dYdNtaY/iERlNkruwW3c7NkV9WIL+DvhNycran/BkHSih8QHOAkA7U7jB8u8NrjVi0NoHApYO3AjuutAB4AxFl/Z0o1yr9pnf5jDX5g+nDcIEGCWYwQWrjBaEBjq5O3IrfNW5O12mNuhcb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hdjmaa+O; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763981809; x=1795517809;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ozqoEWoU3Kf1FbVG4nlV6Tj44DWQiviD0axSH3wKX2M=;
  b=hdjmaa+Onqkmcfe9TunHuFp+1FS3VHxkrHzreb20WBMv1pabeUzZ/7dG
   O+whXVMRvCkFfAHphZfvDM2oT+fLWxciaNxf7AnQk6mgbq3VUSUDbUM30
   gHOyq43/xNDmdL+OPA36CUfQcgOFSJmYk5SMhUJfGNv2I6Lz2bokBguEY
   6vLahd/LjESSvAhWU55u8T93VoG2+vQ21DB/PtMT/AI1YkID6O5iMaKDW
   M/QPq/wQ8rlx4eLNe1ZHd7j9lEGkorUwaG6VPNoLRP/ti8kNOAnTpfLty
   vV5+6vVrOkHLBcTkjzbVcKF6WgC44GTyWPTGdrsDoDIfCI+Zw1cWddJKG
   A==;
X-CSE-ConnectionGUID: Y2sY3+a8RsGCzpkyDsTxGQ==
X-CSE-MsgGUID: V/U8A8KTSmCZoIJUn8bE1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11622"; a="69595622"
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="69595622"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 02:56:48 -0800
X-CSE-ConnectionGUID: d5ttrlYNSTKYFXDY26Ke+Q==
X-CSE-MsgGUID: VbFlN+PqSTexeWyOMinz1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="192540319"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa008.fm.intel.com with ESMTP; 24 Nov 2025 02:56:45 -0800
Date: Mon, 24 Nov 2025 18:41:42 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org
Cc: linux-coco@lists.linux.dev, linux-pci@vger.kernel.org,
	chao.gao@intel.com, dave.jiang@intel.com, baolu.lu@linux.intel.com,
	yilun.xu@intel.com, zhenzhong.duan@intel.com, kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com, dave.hansen@linux.intel.com,
	dan.j.williams@intel.com, kas@kernel.org, x86@kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH v1 08/26] x86/virt/tdx: Add tdx_enable_ext() to enable of
 TDX Module Extensions
Message-ID: <aSQ2Zl5G+j/2D/KC@yilunxu-OptiPlex-7050>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <20251117022311.2443900-9-yilun.xu@linux.intel.com>
 <cfcfb160-fcd2-4a75-9639-5f7f0894d14b@intel.com>
 <aRyphEW2jpB/3Ht2@yilunxu-OptiPlex-7050>
 <62bec236-4716-4326-8342-1863ad8a3f24@intel.com>
 <aR6ws2yzwQumApb9@yilunxu-OptiPlex-7050>
 <13e894a8-474f-465a-a13a-5d892efbfadb@intel.com>
 <aSBg+5rS1Y498gHx@yilunxu-OptiPlex-7050>
 <ca331aa3-6304-4e07-9ed9-94dc69726382@intel.com>
 <167d9540-2d9a-4367-bc68-b96494bc4044@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167d9540-2d9a-4367-bc68-b96494bc4044@intel.com>

On Fri, Nov 21, 2025 at 07:38:03AM -0800, Dave Hansen wrote:
> On 11/21/25 07:15, Dave Hansen wrote:
> > On 11/21/25 04:54, Xu Yilun wrote:
> > ...
> >> For now, TDX Module Extensions consume quite large amount of memory
> >> (12800 pages), print this readout value on TDX Module Extentions
> >> initialization.
> > Overall, the description is looking better, thanks!
> > 
> > A few more nits, though. Please don't talk about things in terms of
> > number of pages. Just give the usage in megabytes.
> 
> Oh, and please at least have a discussion with the memory management
> folks about consuming this amount of memory forever. I think it's quite
> possible they will prefer it be allocated in a way other than thousands
> of plain old allocations.
> 
> For example, imagine memory was fragmented and those 12800 pages came
> from 12,800 different 2M regions. Well, now you've got ~50GB of memory
> that is _permanently_ fragmented and will never be able to satisfy a 2M
> allocation.
> 
> You might get an answer that it's better to do a small number of
> max-size buddy allocations than a large number of PAGE_SIZE allocations.

Loop in mm folks.

Hi mm folks, for Intel TDX (Trust Domain Extensions) feature, there is
a requirement to donate quite a number of pages (12800 x 4K = 50MB for
now) to TDX firmware (known as TDX Module) for its initialization. These
pages will never be revoked cause the TDX Module initialization is a one
way path.

The TDX Module doesn't require these pages be physically contiguous, and
the patches [1][2] in this series [3] does PAGE_SIZE allocation. But as
mentioned by Dave, the donation may _permanently_ fragment regions, stop
them from 2M huge page allocation. In worst case, 12800 x 2MB = 25GB
memory region.

So is order based buddy allocation a better choice? I believe so.  And if
that fails, should we fall back to PAGE_SIZE allocation? Or PAGE_SIZE
allocation should be a hard no in this _permanent_ donation case?

[1]: https://lore.kernel.org/linux-coco/20251117022311.2443900-7-yilun.xu@linux.intel.com/
[2]: https://lore.kernel.org/linux-coco/20251117022311.2443900-9-yilun.xu@linux.intel.com/
[3]: https://lore.kernel.org/linux-coco/20251117022311.2443900-1-yilun.xu@linux.intel.com/

Thanks,
Yilun

