Return-Path: <kvm+bounces-68297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 064E5D2E700
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 10:03:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AEDBD3080085
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 09:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D38A83164D3;
	Fri, 16 Jan 2026 09:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O3IfQJ1s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A5019C556;
	Fri, 16 Jan 2026 09:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768554144; cv=none; b=FOr/LTHu6RFZVc8zrwfxlLv9nsPJK7uJ0W0FJ7F8hd+xRdYlt9khlqEQ/ZpA/Eiz0avenEPGEfF/bknao18g+j/2v8E3AniN0jSsPctPuTxVLIrSkGn8rvMnLr34eiPlyr4inO0Wy2zYxYBLkqIXvDqJ/XQw8D+lwujxxj+qjRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768554144; c=relaxed/simple;
	bh=T4KCla2UIxIngS6OdyRyEEVCFudv1/msUZ9AuFxAut0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cc9f7BbO4gE+ISlsJk5vWyemlSqGrzjgoAyJZrSPNT5pL2/iAnV20XGkeemCi9x7W+5M/OTiadWfzopwCE1d1QG2wH4MNwwwRMPXAU+FDwf72u+R8uD71q/YI5Vu14C5ifKgwGUXde1VeYlWsJurcAH29k7RXH53sITblS1sc9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O3IfQJ1s; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768554142; x=1800090142;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=T4KCla2UIxIngS6OdyRyEEVCFudv1/msUZ9AuFxAut0=;
  b=O3IfQJ1sVmjQ+2LRUdUbtHwhywsTvU03qZmktlbsULjy1hORINXPiAxX
   T+WthyeNSk3q/S6lCluUkS7ELiIFESnxYFyzOVy9FbtglB+s07xMzYFHz
   6HMNY0gPJcPBckBtEFmNg+izHi6uYp727BFyP7Wq984k9bDe85IQxuf1q
   gm0+E7zcvlgMU0Dok9MZFuTJnGC8TKGkVc3kHvzZjYtupFSh+YjeTSryo
   pyUBN6X9wuc1bbOVXSjoUSsM3n2+3VLjimDJmuxk3aq2x+Dx2qqLOMOj+
   4a2Gzd4jFr5/cjx4cBq8FLH3UtgFwFalmaOkoXSimkMEb2hPfK8AeC+mY
   w==;
X-CSE-ConnectionGUID: yj6XWhvuQmm+qIzFSi9GDg==
X-CSE-MsgGUID: gyKoRavJSROlnU7lEfzUJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69921865"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="69921865"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 01:02:21 -0800
X-CSE-ConnectionGUID: kI8kxjgNRQaUK+da4UruXQ==
X-CSE-MsgGUID: 5T3oFinoSAemnZZcwBfn1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="209332809"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 01:02:18 -0800
Message-ID: <9d93f313-b329-4e64-a4ed-88e44be16689@intel.com>
Date: Fri, 16 Jan 2026 17:02:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] KVM: nVMX: Remove explicit filtering of
 GUEST_INTR_STATUS from shadow VMCS fields
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>,
 Yosry Ahmed <yosry.ahmed@linux.dev>
References: <20260115173427.716021-1-seanjc@google.com>
 <20260115173427.716021-5-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260115173427.716021-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/2026 1:34 AM, Sean Christopherson wrote:
> Drop KVM's filtering of GUEST_INTR_STATUS when generating the shadow VMCS
> bitmap now that KVM drops GUEST_INTR_STATUS from the set of supported
> vmcs12 fields if the field isn't supported by hardware, and initialization
> of the shadow VMCS fields omits unsupported vmcs12 fields.
> 
> Note, there is technically a small functional change here, as the vmcs12
> filtering only requires support for Virtual Interrupt Delivery, whereas
> the shadow VMCS code being removed required "full" APICv support, i.e.
> required Virtual Interrupt Delivery *and* APIC Register Virtualizaton *and*
> Posted Interrupt support.
> 
> Opportunistically tweak the comment to more precisely explain why the
> PML and VMX preemption timer fields need to be explicitly checked.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

