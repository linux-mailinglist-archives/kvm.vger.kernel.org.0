Return-Path: <kvm+bounces-59209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D5E5BAE398
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:38:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06B101942C6D
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C6F523CEF9;
	Tue, 30 Sep 2025 17:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MEskeLdS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24D12116E0;
	Tue, 30 Sep 2025 17:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759253914; cv=none; b=MtnCamCPFt3N0/w1Gcx9I9A8pr4LRKyBKe2RkBSgBW/a5r+SVglAxpwR/B4YRqTlM+VLhHAM91HJ28OZNvmh7Ynqf3q0BEm+vrDN295EkL7OPm4WnlGaYT4SSJ+aodOsLzZfJFzgatym+iDAl2oAhHrOSTg7Wx7QMfFEidG00dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759253914; c=relaxed/simple;
	bh=PZ+6MLo+7bvlEyUM8ZBXm2SbK4AOmM3uGttbrdaBPoE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mFDQzC5xjcmGIpwQP1W6CAb8jnMx909ULeB3cJpzMU/2TAxjTBA0TT74+zFGI994B1+RaZMjXHxpHUaTqTxtdez9JQrQh1ys/vFWFrAX8TxplhZPfI1I0rJzhMVxQ7FNJIUBoIgpZyLcdiXtL1BQva7YXKusQjVbyX4CIucDnCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MEskeLdS; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759253913; x=1790789913;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PZ+6MLo+7bvlEyUM8ZBXm2SbK4AOmM3uGttbrdaBPoE=;
  b=MEskeLdS5N/v6s95QNuoe4vcsg5UbvioHnSdB6MlN1WMcNsvB+ZEvrGq
   dXj3/EulvyteRI6nP1U7JVVyIs6tI2VPeOgRlikOTyKz042b641ShUkXI
   8LaAOj2fTrirqSq5XBD270tHmfG714l42ruYtPervIQPRII0ponsnFFC1
   bBShGKZc0J3/XUXV0f5bFvrjnjvnOzJEDIdJ0sEEo/B6+ZqXCQVAQJsNP
   lK8fNiB2HLi6AfFA6JEYhaYF47vtMFAVdj+j9H31jK7vWNf7X3jld8jyA
   TpkcQc/NxVE4Ya54py/ONtyMXdKQa0DUUNnGDecYgPM8CoWF3WXUdqc9Z
   w==;
X-CSE-ConnectionGUID: keO6qEx6TMSfipstzcizGg==
X-CSE-MsgGUID: PsHy5Xn6RYy23+oMWMDe6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="61559961"
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="61559961"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 10:38:32 -0700
X-CSE-ConnectionGUID: 88EHz+d9S7esJ+lxU1lzRA==
X-CSE-MsgGUID: yvX89GVYTRqaeDkNUDZLHA==
X-ExtLoop1: 1
Received: from ray2.jf.intel.com (HELO [10.24.81.144]) ([10.24.81.144])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 10:38:31 -0700
Message-ID: <9be8a4d6-41d6-4e44-af98-bd2d6eae6f71@intel.com>
Date: Tue, 30 Sep 2025 10:38:30 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
To: Xiaoyao Li <xiaoyao.li@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, kas@kernel.org, bp@alien8.de,
 chao.gao@intel.com, dave.hansen@linux.intel.com, isaku.yamahata@intel.com,
 kai.huang@intel.com, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, x86@kernel.org, yan.y.zhao@intel.com,
 vannapurve@google.com
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-8-rick.p.edgecombe@intel.com>
 <1f25ef49-fb7f-449c-be1d-71c19465219f@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <1f25ef49-fb7f-449c-be1d-71c19465219f@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/30/25 07:03, Xiaoyao Li wrote:
> My understanding/expectation is that, when refcount is not zero it needs
> to increment the refcount instead of simply return. And ...

That's a good point.

This doesn't properly handle the case where the PAMT exists and the
refcount is already incremented.

We need something like this with a fast path for a non-zero refcount
that doesn't take the lock:

	// When the refcount is nonzero, the PAMT is allocated already.
	// Bump it up and return.
	if (atomic_inc_not_zero(pamt_refcount))
		return;

	// No PAMT is present. Take the lock to ensure there is no race
	// to allocate it and proceed to allocate one.

	... existing code here

Without this, all of the atomic manipulation is within the lock and the
atomic_t could just be a plain int.

