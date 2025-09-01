Return-Path: <kvm+bounces-56414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB45CB3DA0B
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 08:34:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A44C189B081
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 06:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 073FE258EFC;
	Mon,  1 Sep 2025 06:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="npF0Ucxq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8AE257834;
	Mon,  1 Sep 2025 06:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756708462; cv=none; b=Mm9egXspiPjoYXBsDxKL9sF/NfQT65CFmTtzZiS77LT15LPuVV0RfHEnoB01GO0CG+wnbEQv8Gg/zo2sbdwA2v29NVRIDijqYxDqLbazvTP5fnt9akPTyb0pyq09mNS3n8BnIZQ3UQRRr9HtZupRHtaVKy/tPUigYTc5kCB/hL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756708462; c=relaxed/simple;
	bh=U1/NLt8XFpsX+4uy0crhR7LLjUv4p9RyeZJ/Yj4T/Ns=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kPVL9CO3Cxj8BadUJITKqJUhVK+94EWy9u08A0u6zI13Zvna+ulMDGdTC9d8QD21WlQ8pbDAQSMzWTqfpTN9edTOYqgr+5DN+j5jvQXWYFGSlKg81gYSwHMir4nZJURhUCKeNKK7BJgWv6i1fQPPVOuIaC9B6qe/BKKJK8qpTLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=npF0Ucxq; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756708460; x=1788244460;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=U1/NLt8XFpsX+4uy0crhR7LLjUv4p9RyeZJ/Yj4T/Ns=;
  b=npF0UcxqSqddBk7eCtH/zjcxUXiMROhOWMfRSqh5IVrFszBEH9oZAqXT
   r90G4Z1VmpWNeM2ARzcFjiWjOIAbRKsYEbEo6LAtGpNqPuB46Ee8ZJ0cR
   kXS6hdqawfbC61yr0J27qslQtyhucEwrA8+29cDE4pcLUDgMuFjjZiC7v
   15wklw7/hFr8+pBmBaHoqpWe0pQfET+S37APeZrMfafcwdBo5FxcXjtdV
   d9j1+16vlpOUKMlZ/bPx2DmmFFhOWso96IWIvd6DUN81a7dwy4EyqJlXl
   jDxCIXJCCk6ym7W9c4vNpELw2KdJPFWZj76AmpMH9+bUhMKEtLcaKvoli
   g==;
X-CSE-ConnectionGUID: /P6Icm19TpGsF4gAltVXvw==
X-CSE-MsgGUID: f7J1nWnxTK+HLav1kA/JJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11539"; a="76350803"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="76350803"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 23:34:20 -0700
X-CSE-ConnectionGUID: x6onsKMLQL+wBeTG/MIsQg==
X-CSE-MsgGUID: yuwngjInRjSVlDEzspSd+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="170778024"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 23:34:17 -0700
Message-ID: <849dd787-8821-41f1-8eef-26ede3032d90@linux.intel.com>
Date: Mon, 1 Sep 2025 14:34:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] KVM: x86: Add support for RDMSR/WRMSRNS w/
 immediate on Intel
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
 Xin Li <xin@zytor.com>
References: <20250805202224.1475590-1-seanjc@google.com>
 <20250805202224.1475590-5-seanjc@google.com>
 <424e2aaa-04df-4c7e-a7f9-c95f554bd847@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <424e2aaa-04df-4c7e-a7f9-c95f554bd847@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/1/2025 12:13 PM, Xiaoyao Li wrote:
> On 8/6/2025 4:22 AM, Sean Christopherson wrote:
>> +static int handle_rdmsr_imm(struct kvm_vcpu *vcpu)
>> +{
>> +    return kvm_emulate_rdmsr_imm(vcpu, vmx_get_exit_qual(vcpu),
>> +                     vmx_get_msr_imm_reg(vcpu));
>> +}
>> +
>> +static int handle_wrmsr_imm(struct kvm_vcpu *vcpu)
>> +{
>> +    return kvm_emulate_wrmsr_imm(vcpu, vmx_get_exit_qual(vcpu),
>> +                     vmx_get_msr_imm_reg(vcpu));
>> +}
>
> We need to inject #UD for !guest_cpu_has(X86_FEATURE_MSR_IMM)
>

Indeed.

There is a virtualization hole of this feature for the accesses to the MSRs not
intercepted. IIUIC, there is no other control in VMX for this feature. If the
feature is supported in hardware, the guest will succeed when it accesses to the
MSRs not intercepted even when the feature is not exposed to the guest, but the
guest will get #UD when access to the MSRs intercepted if KVM injects #UD.

But I guess this is the guest's fault by not following the CPUID, KVM should
still follow the spec?

