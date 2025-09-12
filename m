Return-Path: <kvm+bounces-57362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 439EEB540D6
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 05:24:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73FD016D170
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 03:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09EBE23236D;
	Fri, 12 Sep 2025 03:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k/IJ8lVj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CE51A9FA7;
	Fri, 12 Sep 2025 03:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757647483; cv=none; b=OLNV5OdBiqa6ESCb05PJc5UCDUNN6o25xM8nFhP0IMmXj4One/OHLMnR7CE520LzwLAnaYskkEiSbF64UXLb8QqQiMu2D16EwGcsCrnfd32RG428Mm7JvqKgo5f2JPRrbQ8rLGTWy+taVajO9ELvzCDegYLbEg3dMG+7Dr6kG2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757647483; c=relaxed/simple;
	bh=5UJ2uBmLOSZKYcKsuvP5CudRgULBxTsTai1D2ZlaWh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XAhG3a7N52pfoY/+pqf05fM4OwntQBWU8TO00xLT8gWmS0F2jtgv9tEoPY/RBqollECLCnMoEKFYOGmbnacB1umM9GEMMElrRxRjEKZS8IxGNCXH9+B5bcVJ94d4+n77jZmY8l+2vBaRmMHi4ssrWI2Di5dgjod1WYJCVeWy2LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k/IJ8lVj; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757647481; x=1789183481;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5UJ2uBmLOSZKYcKsuvP5CudRgULBxTsTai1D2ZlaWh0=;
  b=k/IJ8lVjZWBkpaqAfrvr2i14vvQvf85zrOul/Y5P9uCPu1eAgoyBiHIA
   PCvVhOGtoUdtDFRI2sJubl67ucRlTmWqB1JQ8g329b7cWM7XKUZf/s0oZ
   6gNzUqpCW6Hbfd5XX6U30TU3KqpG1zrKV99onE0Gyd5A1vWhBdxw82p2K
   BRJif94FzrcAoTMS8WtWlA2FGMgMwIUUihWm6+PfYDS4OQ/h0PxfqF9Pl
   YpUXMP0F2GI2Gf0aGEj/BmT7jkugLjPhthd3B6X0WXuaqF050mhiW0sxF
   2YDNCuQ6qVCKgGa7KzVqmtWkdSK3FDnP7T1hLS9zMnhYF01Bwkz7z4WZz
   w==;
X-CSE-ConnectionGUID: imdJioTTTlSdcx46uoYhuA==
X-CSE-MsgGUID: GmQ/VaO3T3uUnKTIrMVilA==
X-IronPort-AV: E=McAfee;i="6800,10657,11550"; a="59220372"
X-IronPort-AV: E=Sophos;i="6.18,258,1751266800"; 
   d="scan'208";a="59220372"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 20:24:40 -0700
X-CSE-ConnectionGUID: LJS09/p/Sfy+V0Chk02U4g==
X-CSE-MsgGUID: FhP4Wa0iRNC2oNH0aSHCQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,258,1751266800"; 
   d="scan'208";a="178194038"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 20:24:36 -0700
Message-ID: <ef18afaf-9372-4c93-a370-a079cbb89deb@intel.com>
Date: Fri, 12 Sep 2025 11:24:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] TDX: Clean up the definitions of TDX TD ATTRIBUTES
To: "Kirill A. Shutemov" <kas@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-coco@lists.linux.dev, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Kai Huang
 <kai.huang@intel.com>, binbin.wu@linux.intel.com, yan.y.zhao@intel.com,
 reinette.chatre@intel.com, adrian.hunter@intel.com, tony.lindgren@intel.com
References: <20250715091312.563773-1-xiaoyao.li@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250715091312.563773-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear tip/tdx maintainers,

Kindly ping on this series.

It got Acked-by from KVM maintainer and Reviewed-by from other folks. 
There is one comment from Binbin on tdx_attributes[]. What's your 
preference on it? Would you consider applying this series and leave that 
comment to a separate patch or expect a next version of this series with 
that comment addressed?

On 7/15/2025 5:13 PM, Xiaoyao Li wrote:
> The main purpose of this series was to remove redundant macros between
> core TDX and KVM, along with a typo fix. They were implemented as patch1
> and patch2.
>
> During the review of v1 and v2, there was encouragement to refine the
> names of the macros related to TD attributes to clarify their scope.
> Thus patch3 and patch 4 are added. 
> Discussion details can be found in previrous versions.
> 
> 
> Changes in v3:
>   - use the changelog provided by Rick for patch 1;
>   - collect Reviewed-by on patch 4;
>   - Add patch 3;
> 
> v2: https://lore.kernel.org/all/20250711132620.262334-1-xiaoyao.li@intel.com/
> Changes in v2:
>   - collect Reviewed-by;
>   - Explains the impact of the change in patch 1 changelog;
>   - Add patch 3.
> 
> v1: https://lore.kernel.org/all/20250708080314.43081-1-xiaoyao.li@intel.com/
> 
> Xiaoyao Li (4):
>    x86/tdx: Fix the typo in TDX_ATTR_MIGRTABLE
>    KVM: TDX: Remove redundant definitions of TDX_TD_ATTR_*
>    x86/tdx: Rename TDX_ATTR_* to TDX_TD_ATTR_*
>    KVM: TDX: Rename KVM_SUPPORTED_TD_ATTRS to KVM_SUPPORTED_TDX_TD_ATTRS
> 
>   arch/x86/coco/tdx/debug.c         | 26 ++++++++--------
>   arch/x86/coco/tdx/tdx.c           |  8 ++---
>   arch/x86/include/asm/shared/tdx.h | 50 +++++++++++++++----------------
>   arch/x86/kvm/vmx/tdx.c            |  4 +--
>   arch/x86/kvm/vmx/tdx_arch.h       |  6 ----
>   5 files changed, 44 insertions(+), 50 deletions(-)
> 


