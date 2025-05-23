Return-Path: <kvm+bounces-47524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61A87AC1D31
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 08:40:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2EA297A76D3
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 06:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E7DB21B8FE;
	Fri, 23 May 2025 06:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FRt/aoRv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921032DCBE6;
	Fri, 23 May 2025 06:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747982419; cv=none; b=U7DvGQp1QvUPARQIhC7uyNSgNxG84TDY1upHjm6I+kYC7H5mIRpf5kkv/a2wKvjUZDKWnhHPQiX1JXslXS8kZ+8rF6SIv+vf4SJGSeL4eo5MUG0zGkSlOHmfdRhnXnXYpuGLLDKzQ1ThzFTDEqqRae4fh9o+G15ZZP6+efBEu6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747982419; c=relaxed/simple;
	bh=jTwejpJKZaH3Hum68oEpO9btsMOinLAjZLu3y5ghPKM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=kR7+CcHAmQBohX2uwMr4L8il08D1n/xoth3wJfzXcuULYPN5G3rn0qDRW2PFydfhnDj3VmtbmHHRp9+LQWn9r17EjVAZcHrmNI0VPJjJhcOycHiG8RoTOAFGPg2vEnHeaAuiXZvZvPg6ncN2PAp+DTthcGng7fCvxCtsVkxOWWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FRt/aoRv; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747982418; x=1779518418;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=jTwejpJKZaH3Hum68oEpO9btsMOinLAjZLu3y5ghPKM=;
  b=FRt/aoRvyFhodFscxRKlbdlRjnIH09UT/VJ4/qln7X0ZTRrBOX9S6AJ9
   NYNEGi1MmAW0xFpkc786Lm341kJGQntVewCmeulegxPLOqUQ1/SKSmKXy
   nVRy/ZgJ9DXi2aJ3CAfjQsYjtzUuPS94pBV5WsnycerAgGsbSGGQhNoA1
   j2rnDbeunNutj6CE7r7hd+dsRFzsEDH3rBUTw2QHzU4txxm/wsYFZraF8
   Y9m23e/kIe3GKtd3rnnJTE/ZPqHFcjdENUWpqobgXVIms+Z00Z4FAgqNq
   /lUhMYeGG3TlTgtmn7d15YG0esvmtNRoboW5kTxA7xQl/3ywmHmyzvrnU
   w==;
X-CSE-ConnectionGUID: 9wrIaaV8QCCygXlpAtmppg==
X-CSE-MsgGUID: SAoJGmwCQoe+7RDFIOpZ/g==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="49284560"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="49284560"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 23:40:17 -0700
X-CSE-ConnectionGUID: Vs+qNhPmSjuMwTmhWfExRA==
X-CSE-MsgGUID: rqt3veLgTXO/Q0NFFNfRdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="146231177"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 23:40:15 -0700
Message-ID: <cb5bb014-9acc-4ba3-859c-c9fb50c3b4b2@intel.com>
Date: Fri, 23 May 2025 14:40:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] KVM: TDX: Move TDX hardware setup from main.c to
 tdx.c
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Vipin Sharma <vipinsh@google.com>, James Houghton <jthoughton@google.com>
References: <20250523001138.3182794-1-seanjc@google.com>
 <20250523001138.3182794-2-seanjc@google.com>
 <824cec81-768b-4216-968c-d36c59dac71d@intel.com>
Content-Language: en-US
In-Reply-To: <824cec81-768b-4216-968c-d36c59dac71d@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/23/2025 10:27 AM, Xiaoyao Li wrote:
> On 5/23/2025 8:11 AM, Sean Christopherson wrote:
>> Move TDX hardware setup to tdx.c, as the code is obviously TDX specific,
>> co-locating the setup with tdx_bringup() makes it easier to see and
>> document the success_disable_tdx "error" path, and configuring the TDX
>> specific hooks in tdx.c reduces the number of globally visible TDX 
>> symbols.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> ...
> 
>> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
>> index 51f98443e8a2..ca39a9391db1 100644
>> --- a/arch/x86/kvm/vmx/tdx.h
>> +++ b/arch/x86/kvm/vmx/tdx.h
>> @@ -8,6 +8,7 @@
>>   #ifdef CONFIG_KVM_INTEL_TDX
>>   #include "common.h"
>> +void tdx_hardware_setup(void);
> 
> we need define stub function for the case of !CONFIG_KVM_INTEL_TDX

sorry that I missed the discussion on v3[*].
Based on kvm-x86/next, no issue.

[*] https://lore.kernel.org/all/aC0MIUOTQbb9-a7k@google.com/

> with it fixed,
> 
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> 


