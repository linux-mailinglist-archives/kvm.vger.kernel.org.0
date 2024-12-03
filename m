Return-Path: <kvm+bounces-32893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 212E69E1464
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 08:37:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A53B5B27A4C
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 07:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0234193094;
	Tue,  3 Dec 2024 07:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bv+ulaLm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B942500BD;
	Tue,  3 Dec 2024 07:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733211466; cv=none; b=fiTr2MSR/yl8whwHNihnBJQq2TPCIWiCzSYdERMXAPy825AfjH/uB/HhmgzGELuHy307T1oVl+BPoZfbUb3UKDdcosmvlYe+65b59ODpECfqKhB5Y/zH9pnSyPlakvVbOZC/pWN96ocwb3p11zoHNi3M95TaVh8V0dZ0ShxTalw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733211466; c=relaxed/simple;
	bh=oEcZv+Fxg0L5mCrbuWuCxoir+ciXGrrmb8LIMrmPQ0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VyQSTyRPONry3LHK5CFxWO79KT5OQq8WenWLzXDAm6pPnkmCRu7uqGme59bzZmZHlrPCojMw7ttla8GWwUlE17suGtlLHUBGXRT9F+ne5OrGMDwwCu83n/rvZI7IIiLBTS0GIumKjue2HQrq5zRWXDz+qsxmMhj5SwcCW1W4aXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bv+ulaLm; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733211466; x=1764747466;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oEcZv+Fxg0L5mCrbuWuCxoir+ciXGrrmb8LIMrmPQ0g=;
  b=bv+ulaLm5covtyG2HOXiR4sVEhU5I9kpIr8+afJ0zBvIqhXyocVq3MZY
   Eyqbit1pDCgUdqoRtMWJxyD+bYMpbes8dpwoXpY5I6xtrIdKTmV+Ibi6W
   TKUInzW/40gEr11JN7JO6Iaie3iwgWSv6A42XkaleJLFkncZRU6UuJ4u7
   IgEjtcbwUkoQKvDOkHAAD6DmNjoDG8Ei0MiImSX6+aAm5SPLUQMPSp/cc
   enc4fXFARFPwUBjDlEUveMNXs2JiT6h1tQvIHAP1INJ+Nr7B9mqSTuzvK
   xBX47aOINtnEZLY2OkyBGhcKi5583vhk3ZbzJSCrMcGs2IfBVH6W1Oq0L
   g==;
X-CSE-ConnectionGUID: 61EqiPK2QEO+kX28zSNLEw==
X-CSE-MsgGUID: nwlBAIwMTB6T0jDAdPXVDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11274"; a="43895008"
X-IronPort-AV: E=Sophos;i="6.12,204,1728975600"; 
   d="scan'208";a="43895008"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 23:37:45 -0800
X-CSE-ConnectionGUID: 6oEOhz5CRN6FVM5RO90gQQ==
X-CSE-MsgGUID: tfMXOFsSSeSfJH3omsvM8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,204,1728975600"; 
   d="scan'208";a="116608073"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2024 23:37:43 -0800
Message-ID: <c63cc81a-ce58-4f01-b699-514848ef81e8@linux.intel.com>
Date: Tue, 3 Dec 2024 15:37:40 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/6] KVM: x86: Bump hypercall stat prior to fully
 completing hypercall
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-5-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20241128004344.4072099-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 11/28/2024 8:43 AM, Sean Christopherson wrote:
> Increment the "hypercalls" stat for KVM hypercalls as soon as KVM knows
> it will skip the guest instruction, i.e. once KVM is committed to emulating
> the hypercall.  Waiting until completion adds no known value, and creates a
> discrepancy where the stat will be bumped if KVM exits to userspace as a
> result of trying to skip the instruction, but not if the hypercall itself
> exits.
>
> Handling the stat in common code will also avoid the need for another
> helper to dedup code when TDX comes along (TDX needs a separate completion
> path due to GPR usage differences).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/x86.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 13fe5d6eb8f3..11434752b467 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9979,7 +9979,6 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>   	if (!is_64_bit_hypercall(vcpu))
>   		ret = (u32)ret;
>   	kvm_rax_write(vcpu, ret);
> -	++vcpu->stat.hypercalls;
>   	return kvm_skip_emulated_instruction(vcpu);
>   }
>   
> @@ -9990,6 +9989,8 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>   {
>   	unsigned long ret;
>   
> +	++vcpu->stat.hypercalls;
> +
>   	trace_kvm_hypercall(nr, a0, a1, a2, a3);
>   
>   	if (!op_64_bit) {
> @@ -10070,7 +10071,6 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>   	}
>   
>   out:
> -	++vcpu->stat.hypercalls;
>   	return ret;
>   }
>   EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);


