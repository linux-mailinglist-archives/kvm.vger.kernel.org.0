Return-Path: <kvm+bounces-19385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D83BA904893
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 03:53:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 71CF1B21CCC
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AEBF63B9;
	Wed, 12 Jun 2024 01:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VJnecQqi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823424691;
	Wed, 12 Jun 2024 01:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718157196; cv=none; b=gVllhMBaeDCOVSGf2j+UnpYKj0lTssbzo336v3b7dpx5tTKluMwkxXL5uXSBsQrPj1UlWZz+LPkcuHez1Ey07HU512am3ZeOhKQDZ3zhTYSQbuCggs9Fr2Gh+4ARDZqO1y1VJWnVDYTn386gdqCJRFt0KSarwzLAMRBpoJFyqc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718157196; c=relaxed/simple;
	bh=Yx1IziiU5dxC7IXNVT/wQHpMEAgt8M93+S6VPeJuhk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JAnH2a3W0Yy/zDajo2HpfwUXvT6SW6okX0rHDI2RYGD84Q/3rqRMslCiLOIOzgtx5SRoNKHxMbzWwOxQxTWqaN+dPdswzK43+OLkENgOP2P7g8OtBXiJGRYcdJK8O8Ij2JJD4YtblP9KK4qR5Jn2aWKeN8FDHTTwR24YCDa6Eas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VJnecQqi; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718157195; x=1749693195;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yx1IziiU5dxC7IXNVT/wQHpMEAgt8M93+S6VPeJuhk8=;
  b=VJnecQqi9augSO0H/c/gEkYI6eP9X/qO0GS+KvN/hnvuT5TIcaXVY0Rp
   k1HbR/+1flM+lAHbIqYOclFLPbpxtSsYLrNGkk3JstSAQiI9je0z4Trey
   lBV78Vnsd2Oel6sr1YycFWuSHbm+2QNeCRBtPyTU/ps67Zaw79tuQX4Zh
   7XD4cFoWBGwr9bIVrSlsYb5ijVoH1pzKGUA7Y9kSPoICee5MBgRoGbGuk
   ogPVc9EADIUdBkiAsqTme3GqgT3IElVa6pd+CY12ZVcsth53VPx/LPGXZ
   yIz3aHztEXNu2Y9otKD30WngV0YW+cYqbESgo4TV/rOsSTdXRr4yt65Pt
   A==;
X-CSE-ConnectionGUID: 8GtT7gQHSLixSJD3tEZjBA==
X-CSE-MsgGUID: XyDsxDOoSpmevj8T5Ac0mQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="14863202"
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="14863202"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 18:53:14 -0700
X-CSE-ConnectionGUID: pVKKMUREQtiB0mlS1ntLug==
X-CSE-MsgGUID: liCBm6DGSJSp7/JNeTyHSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="77091467"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.227.51]) ([10.124.227.51])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 18:53:10 -0700
Message-ID: <86a92ee5-af63-42dd-abed-0cd10ac937cd@intel.com>
Date: Wed, 12 Jun 2024 09:53:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 08/10] KVM VMX: Move MSR_IA32_VMX_MISC bit defines to
 asm/vmx.h
To: Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, Jim Mattson <jmattson@google.com>,
 Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>,
 Zhao Liu <zhao1.liu@intel.com>
References: <20240605231918.2915961-1-seanjc@google.com>
 <20240605231918.2915961-9-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240605231918.2915961-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/2024 7:19 AM, Sean Christopherson wrote:
> Move the handful of MSR_IA32_VMX_MISC bit defines that are currently in
> msr-indx.h to vmx.h so that all of the VMX_MISC defines and wrappers can
> be found in a single location.
> 
> Opportunistically use BIT_ULL() instead of open coding hex values, add
> defines for feature bits that are architecturally defined, and move the
> defines down in the file so that they are colocated with the helpers for
> getting fields from VMX_MISC.
> 
> No functional change intended.
> 
> Cc: Shan Kang <shan.kang@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> [sean: split to separate patch, write changelog]
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Signed-off-by: Sean Christopherson <seanjc@google.com>



