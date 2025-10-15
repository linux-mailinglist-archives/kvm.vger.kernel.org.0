Return-Path: <kvm+bounces-60056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50828BDC48C
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 05:11:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D133119213BA
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 03:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60FA1288517;
	Wed, 15 Oct 2025 03:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PKDfL/1H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB77263F22;
	Wed, 15 Oct 2025 03:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760497872; cv=none; b=l/MWIFm7uUYlRYZJjddV1UaRWeGIZnf3Ov3B/IR9f9P0uhvxAGpW2G8Gx0yoyPc8KTIbEDpxlEDxNd3tG2CmQJbNhSr6hy4NUzjF/BB4XnrRjag5S6CTMixGv3xujCyDGyRRLZghNEDJIjP0ycT88jhpUmQlfBTmua8FLeQRrNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760497872; c=relaxed/simple;
	bh=CVnXUugvg5jaipAD7BQWAK3H8oBpH1JfR2aS8zFhAHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RIaOpKGwOSXCl2bVEQOXEsZDIBKlZ7tExiWNBqN1JZDApVToAHwj4Nu1k/mTsKIRaBgmT/lsyC6a0UNr4nKRwWvoHQqTur6bt5oeka70nYyalVAuOXwI7xyAtDJ88XcssmthTJn/brwXJ6KB+0mXXVI7chrOIyaDmy/KlDRJ5ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PKDfL/1H; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760497870; x=1792033870;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CVnXUugvg5jaipAD7BQWAK3H8oBpH1JfR2aS8zFhAHY=;
  b=PKDfL/1Hq5bJDv02M2I5kmJMmwWLWAp7i01JHYO8ep2neP8IK4Ni0xG3
   3735kLXGXHMPnbkpKR46sJLf2bc5OJAmLbw43duF/PEE5W5qPiuPYzUm+
   wnj0brx1AOOsvlmt1zRm02beSf5aiSLfalbDq5wWPAiVaYAbHt8n8gtku
   P1dCGIabAE4AvZazXJ2YDx7croXcbuXX71Y4PDo6db8/2m82WOYdGs08l
   ENTPREglEbGXeYhQhIRm+WuCkLToUqXniclH8MWhzYoRLCfBSEH0QexNJ
   LvIhVwvEueaxRqRMJaaV64k9UfFiu+8i01cmkHX53WUHtcK4OcPvXA/2q
   w==;
X-CSE-ConnectionGUID: JZjssZa2SCal6V20ve8Ncg==
X-CSE-MsgGUID: dpY/AOy1SPqefJfJZebSVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62576832"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62576832"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 20:11:08 -0700
X-CSE-ConnectionGUID: bQqPWpHQRAu26j9sjccLQg==
X-CSE-MsgGUID: gpN+oGL6RdC/JoYrhdrnXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="186300131"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 20:11:06 -0700
Message-ID: <d9328f94-a6a9-4d98-8ea7-9b9e22bc1db6@intel.com>
Date: Wed, 15 Oct 2025 11:11:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: VMX: Inject #UD if guest tries to execute SEAMCALL
 or TDCALL
To: Chao Gao <chao.gao@intel.com>, Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kai Huang <kai.huang@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
References: <20251014231042.1399849-1-seanjc@google.com>
 <aO71TX//mL3QOV3T@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aO71TX//mL3QOV3T@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/2025 9:13 AM, Chao Gao wrote:
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -6728,6 +6728,14 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
>> 	case EXIT_REASON_NOTIFY:
>> 		/* Notify VM exit is not exposed to L1 */
>> 		return false;
>> +	case EXIT_REASON_SEAMCALL:
>> +	case EXIT_REASON_TDCALL:
>> +		/*
>> +		 * SEAMCALL and TDCALL unconditionally VM-Exit, but aren't
>> +		 * virtualized by KVM for L1 hypervisors, i.e. L1 should
>> +		 * never want or expect such an exit.
>> +		 */
>> +		return true;
>> 	default:
>> 		return true;
>> 	}
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 097304bf1e1d..7326c68f9909 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -2127,6 +2127,9 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>> 		return tdx_emulate_mmio(vcpu);
>> 	case EXIT_REASON_EPT_VIOLATION:
>> 		return tdx_handle_ept_violation(vcpu);
>> +	case EXIT_REASON_SEAMCALL:
>> +		kvm_queue_exception(vcpu, UD_VECTOR);
> 
> Emm, the host cannot inject exceptions to TDX guests. Right?

Right.

I also tested in TD guest. Actually, the TDX module injects #UD to TD 
guest on SEAMCALL exit.

The behavior is documented in 11.7.1 "Unconditionally Blocked 
Instructions" of TDX module base spec:

   Instructions that causes a #UD Unconditionally

   - SEAMCALL, SEAMRET



