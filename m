Return-Path: <kvm+bounces-58115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 243F3B881DF
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 09:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6599521630
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 07:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41E362C2AA2;
	Fri, 19 Sep 2025 07:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K0qrPxvp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3392C027D;
	Fri, 19 Sep 2025 07:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758265827; cv=none; b=sz4GsuTV2RPMYfBui4lBEUxfZnrafCCeKCeqdXvNSyyS9Tnc01DfZeNbqJS4Zd3gVKFOepPpyDhGBWzsVrfu1MPVuOIXBBzL4zXmaA0xy3OUD3HQTpxXSg92KqdRS3f7xQTodAVmVPD9HAqSdfjGcQgVdq8m3zKPtlctc/nf54o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758265827; c=relaxed/simple;
	bh=ThcO1lINrLScH7kr8tkTr/SH0ijHvJYBoTCugGCyM3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qZrhixDzsRjlzexELuC9H9I1YSqwcqiV1KppRmsQPskCFBbnJM8uLebSg8BU6loOxyImOAbBE+GZHt9gN+jB+xvD1yr3aLQ/WgEv79K1olK/fTvkfOMgVE0JsPbwMmo8hxIQAf6DiB05gCY0aRwQayB/va8iCgB1p2L+3dGl1oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K0qrPxvp; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758265826; x=1789801826;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ThcO1lINrLScH7kr8tkTr/SH0ijHvJYBoTCugGCyM3w=;
  b=K0qrPxvppaqy0OMtQ13VyDGIFgokGS64wOrsBz3io2SLNOJCObHOD3Xj
   Yq4oOCUv+8lCfHG3HaZjW7XrlYNYpEy0Gt0bjXn0E8Afnkorjka1JZ5kQ
   h0gmwLLbE+KooUEi3RO5ljCF2XNumwg/rFy+qcg4qp9Rehv7Pa0ungUmu
   IWY01Jw67JXNBUUBAvZqtoJqJ4tqQUIUVTgFyMk9NQlsoHV/dndeNvgpy
   kF7lL7tfAzt0Em83fJNvOdUum4ZJyPJ3NKWb4WhPY+DY9uTz3Aqc42tO3
   V0FxLHU7wIwxOaJvQQGP0+Linh3NKBg/FwJTAPrQ8px39MurNI0ABSWgD
   w==;
X-CSE-ConnectionGUID: 3CRA3nU7SeG5z3Iu9EbZHg==
X-CSE-MsgGUID: jyMIYaMUTzGtcCf1x5FvvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="60304767"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="60304767"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 00:10:25 -0700
X-CSE-ConnectionGUID: Z0XgyptRQreeVb00liWphg==
X-CSE-MsgGUID: 1NSDKUGLQXqepYAULQYb/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="175584870"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 00:10:22 -0700
Message-ID: <9cedb525-a4a7-4a84-b07f-c6d9b793d9db@intel.com>
Date: Fri, 19 Sep 2025 15:10:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 19/41] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: Sean Christopherson <seanjc@google.com>,
 Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-20-seanjc@google.com>
 <c140cdd4-b2cf-45d3-bb6a-b51954b78568@linux.intel.com>
 <aMxKA8toSFQ6hCTc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aMxKA8toSFQ6hCTc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/19/2025 2:05 AM, Sean Christopherson wrote:
> On Thu, Sep 18, 2025, Binbin Wu wrote:
>> On 9/13/2025 7:22 AM, Sean Christopherson wrote:
>> [...]
>>> +static inline bool cpu_has_vmx_basic_no_hw_errcode(void)
>>> +{
>>> +	return	vmcs_config.basic & VMX_BASIC_NO_HW_ERROR_CODE_CC;
>>> +}
>>> +
>>
>> I think "_cc" should be appended to the function name, although it would make
>> the function name longer. Without "_cc", the meaning is different and confusing.
> 
> +1, got it fixed up.

May I ask what the 'CC' means?

