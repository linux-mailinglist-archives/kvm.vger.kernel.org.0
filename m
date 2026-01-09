Return-Path: <kvm+bounces-67562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F865D0A917
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 15:13:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 17590309D9C7
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 14:09:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10C1035CBDD;
	Fri,  9 Jan 2026 14:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PasC6ArL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A72232A3C3;
	Fri,  9 Jan 2026 14:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767967747; cv=none; b=GO6kW+SVxNNyk+GqnYqYMLtc09x79CksEclBSXlXiN/PiPFnQXycysiaovGqPhrK2NlbidinoYoC5j9+yoT8x6r6vFX5EciRsRivW9eYq7nlr7skcniJrw2OF9W6JNZbUQWa2TpyBeaglsC/24IiNSow0MhSE55y0Dwv5IYdJ8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767967747; c=relaxed/simple;
	bh=b4wYY2R1JdGLlCq3kKGQld+574kqUBIfu6hg1mYSiBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XFnjoRxAuwKpmqoQ+w2m45SKs6pgXWfpTHi6/DikL9Z3aUHevto75HBOrqA/3+TKGrMIqCBZprlf4LTrwt+WZalahkhn/c9YPQaLfXhGNW78CoqH0li6Vjm/2Xj4Kf2YjDzJCYCvy7fJj6cWBqnoexLX7XAekriHdFOx8ZzrCGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PasC6ArL; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767967745; x=1799503745;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=b4wYY2R1JdGLlCq3kKGQld+574kqUBIfu6hg1mYSiBk=;
  b=PasC6ArLtw2pNDvz9GXasyAv3mcBN8+6UqB7hOrQcqWMHW51ftMVEIXr
   EN+HvR6lxVI8UdPaw3HktxeQtRcjjtC9PyBFdWkHPiP74PyTyjqzJSJOA
   smSYAUPKDA1Uo25sYIX31ePAwFYm3z1xmonSJ62Kdlq0qYUTSuxQ+Ow0k
   lWDI2mdh6lnKjO0/m1EPsbhsBu+AlAglL/FCU0I5bG6zs/1HolHMGMPWa
   EpBtoRq4+fJdA6Zo7HJk4Qs8k+MCUfJlOwgFTOazwnYlJT5wupypTQ2Jm
   yE+pl2NxA+eCc5rRFRyrHB0xzRyZ6mhUMxZZO7UnVvF6+aKsgItZ9SU/6
   g==;
X-CSE-ConnectionGUID: J78KUbdTS0exo8VpSn37qg==
X-CSE-MsgGUID: hG8UKUy+TVOj9iaMUyPofw==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="69397843"
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="69397843"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 06:09:05 -0800
X-CSE-ConnectionGUID: zUIYz8nPQZitrwQ/tr/n7A==
X-CSE-MsgGUID: bwl7xQKPRguNw/TBzR7N5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,214,1763452800"; 
   d="scan'208";a="240988683"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.240.173]) ([10.124.240.173])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 06:09:02 -0800
Message-ID: <288eaa68-7d4d-4c1b-ae70-419554d1d8f2@intel.com>
Date: Fri, 9 Jan 2026 22:08:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] KVM: nVMX: Disallow access to vmcs12 fields that
 aren't supported by "hardware"
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>,
 Yosry Ahmed <yosry.ahmed@linux.dev>
References: <20260109041523.1027323-1-seanjc@google.com>
 <20260109041523.1027323-4-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260109041523.1027323-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/2026 12:15 PM, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 61113ead3d7b..ac7a17560c8f 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -111,6 +111,9 @@ static void init_vmcs_shadow_fields(void)
>   			  field <= GUEST_TR_AR_BYTES,
>   			  "Update vmcs12_write_any() to drop reserved bits from AR_BYTES");
>   
> +		if (get_vmcs12_field_offset(field) < 0)
> +			continue;
> +

why shadow_read_only_fields[] doesn't need such guard?

IIUC, copy_vmcs12_to_shadow() will VMWRITE shadowed readonly field even 
if it doesn't exist on the hardware?


