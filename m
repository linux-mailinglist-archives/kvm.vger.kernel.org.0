Return-Path: <kvm+bounces-57961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8D5AB82A27
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 04:19:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 775C61B27DD9
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 02:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D82CB23B62C;
	Thu, 18 Sep 2025 02:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UKTZDKit"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660C5239E61;
	Thu, 18 Sep 2025 02:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758161945; cv=none; b=Dylokw09RYD8/WCftvnPurfk49ft85dUQXNIs6x3GzIURsLfSvcWGmzx9OD0wYCn+DKDpSRhviQvqweatnh9gem0XSgzNtrVgfxc+oyHrUgR9JXY2Ri4JzslgjfYI88NxZYZ6T+ClkyhABYnZagdex2YviHLiLi5HP1eXPDoZaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758161945; c=relaxed/simple;
	bh=r1wkqHVLUHoLO9U5TMOClU5sna6Gh+lyKvPi9baXPvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I8ni24uPobQyvwuXfWYrxlBI9r7RZFvFzBdg/BjExUPB0y4yvq0765WZ4EwNC3ec4/S2wqGB5Ks+JjLFslanwja5IMuXeSaQEk/I6YBPINC6Qw/H9tUzbnEvv/AQr+Ed0KnQUoK7zKcGvMc/fBqFPpYX83P9otARtIoQRMK+4AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UKTZDKit; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758161943; x=1789697943;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r1wkqHVLUHoLO9U5TMOClU5sna6Gh+lyKvPi9baXPvg=;
  b=UKTZDKitWuG91aSX3b33WxoCpBWir+pt6Zy7Vuo7QjxxHP7z5ui8Tsxn
   8Uddd1h5ssC7O9//rGDqJ28+KrdsxYhQZIY6PxUxgqVA522b0fN3Exxr/
   iTdN/9ejt0YoCweQXMRTrq4Z6YJUMT/bY6+UgEEJlgga8onORv9dp7EdQ
   lirAC+XX7h/77GbbL/0GbG5HxMRVWgpMKwbs/g9cA+rLvQz6G9k+dHqER
   g1svUq4c7xXnBZHwdstT5mDjiD6b4rmRw0z9E5ksBoeD1nPz4kaabmiYa
   BRn8kg06k2NKncIKfkSDzTZVxLB0pcFdkxXmDRWEsJRpW9+uRFJ0f/8Aa
   w==;
X-CSE-ConnectionGUID: 0D/Xe31CTaaAVAsaOovtJA==
X-CSE-MsgGUID: qCIKQYsMSV+3+G62blZ45A==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="71163179"
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="71163179"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 19:19:03 -0700
X-CSE-ConnectionGUID: w3+wklgBRg2mH8TTa+6i+A==
X-CSE-MsgGUID: H/hRwk/zQ/yWEg0NDemQ5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="199113616"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 19:19:00 -0700
Message-ID: <c140cdd4-b2cf-45d3-bb6a-b51954b78568@linux.intel.com>
Date: Thu, 18 Sep 2025 10:18:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 19/41] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-20-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250912232319.429659-20-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/13/2025 7:22 AM, Sean Christopherson wrote:
[...]
>   
> +static inline bool cpu_has_vmx_basic_no_hw_errcode(void)
> +{
> +	return	vmcs_config.basic & VMX_BASIC_NO_HW_ERROR_CODE_CC;
> +}
> +

I think "_cc" should be appended to the function name, although it would make
the function name longer. Without "_cc", the meaning is different and confusing.



