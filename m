Return-Path: <kvm+bounces-58350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57EA4B8ED4A
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 04:58:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 176E17A169A
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 02:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4DC72ECD3E;
	Mon, 22 Sep 2025 02:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QKHsRTfq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94251548C;
	Mon, 22 Sep 2025 02:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758509923; cv=none; b=TDOpfMB3vrVWwoKbbILXJ0tDVZ8btVxP7NQexEnM3nuzVe4cJFn6qHrB1RRvBAAA5jLUDEUg9gOYsxQYb825A33q/G8d9s3+fin4oaHDW2kH8o+M2AYy3oGUnelaUy5C+Vv0jaEzNDisVRPfpgWs04k+yCjqgiULXSL2POqbkS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758509923; c=relaxed/simple;
	bh=+47S7t7vCFZDogZs89r48oLUWxTxfBvHe0wBfOmN618=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e/EF3VK9kEirAaxmZHCi65ZGUVu0ehiOZzJo7uJQzvq1qdrBqGzfP42iM5RGcaenFrl3A+VdMumx/ZQjMi7m1L4aKyHbsz4pnSAs6E9ZP2w+w07T5+EuawhE2hC8DU2aY2rCBExWb9vI3imLI+S7hFzpWr3PVqyIcsqMMkymkJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QKHsRTfq; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758509920; x=1790045920;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+47S7t7vCFZDogZs89r48oLUWxTxfBvHe0wBfOmN618=;
  b=QKHsRTfq8gK3nysStoPhMMx8b7gSxISb6Ex3WUafwBCt/ulOKqyvcAaw
   lAK0AGSx7QfFdD1e2cu+Zx46F8jWn4v7tM0lCPbSHkN6iGRyAOgAefoTx
   3815YADM6p8u/Ecg6dcuhTygzWQvyo7C3xSIMnA34BjeQfs2XssKQVWks
   /DcQ175WI+n2lzT9gc5pKFrtaHyPIuRzG1bJZHEotbTgXmQp1tqKp+a29
   kcO0p+4iWzN48ZuoNN1EEl3xSLVjT8Zdi2vkaoavDw9aj/BoYzpdn51ji
   2i9Wfko39mEPWfhq4FvX/nDOka4P0GvEf7rtR130HUm8HCsYew7gLK3MX
   g==;
X-CSE-ConnectionGUID: Ytu+7D5MQwmVVQlwmbJ2FA==
X-CSE-MsgGUID: 3DrZzVqATZSGYGrpbyo6MQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="71870976"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="71870976"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 19:58:40 -0700
X-CSE-ConnectionGUID: TuUz52MUSSu6sbu+eS75SQ==
X-CSE-MsgGUID: FWXVW5B5TTmiETyp5r3Tqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="175638444"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 19:58:38 -0700
Message-ID: <2dc79575-b256-4665-9e1a-8cdbda84ba3b@linux.intel.com>
Date: Mon, 22 Sep 2025 10:58:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 13/51] KVM: x86: Enable guest SSP read/write interface
 with new uAPIs
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-14-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-14-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> Add a KVM-defined ONE_REG register, KVM_REG_GUEST_SSP, to let userspace
> save and restore the guest's Shadow Stack Pointer (SSP).  On both Intel
> and AMD, SSP is a hardware register that can only be accessed by software
> via dedicated ISA (e.g. RDSSP) or via VMCS/VMCB fields (used by hardware
> to context switch SSP at entry/exit).  As a result, SSP doesn't fit in
> any of KVM's existing interfaces for saving/restoring state.
>
> Internally, treat SSP as a fake/synthetic MSR, as the semantics of writes
> to SSP follow that of several other Shadow Stack MSRs, e.g. the PLx_SSP
> MSRs.  Use a translation layer to hide the KVM-internal MSR index so that
> the arbitrary index doesn't become ABI, e.g. so that KVM can rework its
> implementation as needed, so long as the ONE_REG ABI is maintained.
>
> Explicitly reject accesses to SSP if the vCPU doesn't have Shadow Stack
> support to avoid running afoul of ignore_msrs, which unfortunately applies
> to host-initiated accesses (which is a discussion for another day).  I.e.
> ensure consistent behavior for KVM-defined registers irrespective of
> ignore_msrs.
>
> Link: https://lore.kernel.org/all/aca9d389-f11e-4811-90cf-d98e345a5cc2@intel.com
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


