Return-Path: <kvm+bounces-37943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BDD96A31BEA
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 03:22:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F2CE188A3F0
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 02:22:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 623B81BD9E3;
	Wed, 12 Feb 2025 02:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bpQu2C9+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E5F8F77;
	Wed, 12 Feb 2025 02:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739326928; cv=none; b=NGt9smh8t/jpjqLYXkJgPJimwsf9rzylznWsVQ9FP5wHQti3+M5TNfA8POAvPxRbPf/PFZBdvWsFiaKNOMXwiNkzxw4ByaT2vVIlZnaQ1TOAiETx0dPO6j69O+i2d1fPgyC7WwLDv1MOhDuOb/Ly54sAAcMxza7R96/09EVmo0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739326928; c=relaxed/simple;
	bh=PNtMqBcAsc1rDrfqAyOraDXzsZcTf5BbU8fLA+q2i7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iT2D/uOGs0zXAs4ni56n/kpggfCYZxNdGoqsxMy0DjsH18tzFTIbrucUwTOUK4O94QVNiAxIKo18/T1WVOagk6ChHKcjAcpc5UlxUoZwPhZt7ffOodGZJG1ZWPPVKn7Dd9YdCXEOM+lduBwKghTSGNfsfE5TWO7gMBs+802Be1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bpQu2C9+; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739326927; x=1770862927;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PNtMqBcAsc1rDrfqAyOraDXzsZcTf5BbU8fLA+q2i7I=;
  b=bpQu2C9+DCjm9gCG8VGUkL3LzJASwPjF77xCDlhAnrcl8dLYcptYVmg6
   c2W9N0wwMYapS5R3WbqV426fFFSx2V46BcNf0Vf7gSDXk8VFULXuMH26z
   sFD18y3jlV5IhwyOAzQzqOap+hhUAc3bx/tsx0XbLeiqcybONBron4ZVK
   EQkCUMKCJpiZhI/lYygnc+kkCpIPq+D1nVcasonoSWhAwNnn/Xo+l/W9/
   nAIOTt6I7NiugHE7kJVBJXl/PbEqQtRm9zlrUOnm+qRKGkGxkhsehXFxs
   Ar8sj969KpUvBAl3hZivPjsHRDvcw+VbHinyS38O0XpdIcTP5Zu13bax7
   g==;
X-CSE-ConnectionGUID: Pb7ZV8plQD2Kyj0P5mi6Zw==
X-CSE-MsgGUID: JsRFjdw+RMuheJ5nKzzkUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="51398364"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="51398364"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 18:22:06 -0800
X-CSE-ConnectionGUID: 8DVA/s8dSbKfdbiRiKO8ZQ==
X-CSE-MsgGUID: QtzzeT3pQBeAccp+Z1BFtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="149866516"
Received: from unknown (HELO [10.238.0.51]) ([10.238.0.51])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 18:21:16 -0800
Message-ID: <a771f116-d70e-4f52-ada3-8422e1f45acf@linux.intel.com>
Date: Wed, 12 Feb 2025 10:21:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/8] KVM: TDX: Add a place holder for handler of TDX
 hypercalls (TDG.VP.VMCALL)
To: Sean Christopherson <seanjc@google.com>, Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com,
 xiaoyao.li@intel.com, tony.lindgren@intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, linux-kernel@vger.kernel.org
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-4-binbin.wu@linux.intel.com>
 <Z6sNVHulm4Lovz2T@intel.com> <Z6vhTGHKIC_hK5z4@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z6vhTGHKIC_hK5z4@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/12/2025 7:46 AM, Sean Christopherson wrote:
> On Tue, Feb 11, 2025, Chao Gao wrote:
>>> @@ -810,6 +829,7 @@ static bool tdx_guest_state_is_invalid(struct kvm_vcpu *vcpu)
>>> static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
>>> {
>>> 	struct vcpu_tdx *tdx = to_tdx(vcpu);
>>> +	u32 exit_reason;
>>>
>>> 	switch (tdx->vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) {
>>> 	case TDX_SUCCESS:
>>> @@ -822,7 +842,21 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
>>> 		return -1u;
>>> 	}
>>>
>>> -	return tdx->vp_enter_ret;
>>> +	exit_reason = tdx->vp_enter_ret;
>>> +
>>> +	switch (exit_reason) {
>>> +	case EXIT_REASON_TDCALL:
>>> +		if (tdvmcall_exit_type(vcpu))
>>> +			return EXIT_REASON_VMCALL;
>>> +
>>> +		if (tdvmcall_leaf(vcpu) < 0x10000)
>> Can you add a comment for the hard-coded 0x10000?
> Or better yet, a #define of some kind (with a comment ;-) ).

As Chao pointed out, we should convert the leaves defined in the GHCI spec
and supported in KVM only.  Specific leaf numbers will be used instead of
comparing to 0x10000.

I plan to change it to:

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2b24f50ad0ee..af8276402212 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -920,11 +920,17 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
                 if (tdvmcall_exit_type(vcpu))
                         return EXIT_REASON_VMCALL;

-               if (tdvmcall_leaf(vcpu) < 0x10000) {
-                       if (tdvmcall_leaf(vcpu) == EXIT_REASON_EPT_VIOLATION)
+               switch(tdvmcall_leaf(vcpu)) {
+                       case EXIT_REASON_EPT_VIOLATION:
                                 return EXIT_REASON_EPT_MISCONFIG;
-
-                       return tdvmcall_leaf(vcpu);
+                       case EXIT_REASON_CPUID:
+                       case EXIT_REASON_HLT:
+                       case EXIT_REASON_IO_INSTRUCTION:
+                       case EXIT_REASON_MSR_READ:
+                       case EXIT_REASON_MSR_WRITE:
+                               return tdvmcall_leaf(vcpu);
+                       default:
+                               break;
                 }
                 break;
         case EXIT_REASON_EPT_MISCONFIG:





