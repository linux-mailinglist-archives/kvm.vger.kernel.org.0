Return-Path: <kvm+bounces-57698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 056E0B590E0
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 10:37:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C63FD7A1246
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 08:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1FDC288502;
	Tue, 16 Sep 2025 08:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hx1tbInW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3548C1FBC92;
	Tue, 16 Sep 2025 08:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758011605; cv=none; b=NHKt+xvVS84/W0bDsZmRmAaDJwPhPzZkLgD40aengvEcfrBZtBJYhBY+b21in20OY/ZEhu1FJqGcs+E3sKvnYKalZNRs8LzQLQaTjqC2XAvOYMvqFjbtQ3GyB7ZC6ROXDVlqRbTpGv4yI3rEIzUkWnoSL7UE2Fs/Bu5YLy68HAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758011605; c=relaxed/simple;
	bh=RCGQ0E0Q3eA0X1OthWuvZGYF9H/6fxe+c9lWL75FuhQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fBvVg3qm21YQI/Ksd1XFEZubwF3Dml3JXRjusHnflbeQQm4g8jV3AAv3S66mcxv6PENhQP+gKdqEbHCGj2jUYj29XxqfeAByGo+Sl1JgvEetBhedv4ycmfcarnjHAJBo5JdDBuzwshJGgHjTNK6Nct1AYD6NJMnHdLmuKMPoKfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hx1tbInW; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758011604; x=1789547604;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RCGQ0E0Q3eA0X1OthWuvZGYF9H/6fxe+c9lWL75FuhQ=;
  b=Hx1tbInW2wBcxoVRW8lMOemCq9GD6IgJTmwzICNlqZn7O7GyJSoe5P/t
   kL3HtGOl9nXhA4+jwg2zPY1eYUySCWB9n1+MoOeC7Xyfp6CxsJH0MY7YT
   pvByVaHfqwuCivyhloJEi+yW4vlAvOCDA1tsUk6YOtStd1YY2uxT8HigD
   3eHHQQs8qgLJ9JoYKldDcLOprtcyw/HSb2NlIvs8qY/GXO03vd97olNfA
   bZKiqK8LQbWqK9hDVuWWHVNUOGbpU9X2fECKb3bYGMNtIefpd5SVKf4Fk
   6gD7HsbcYd/FNEd78pYNTfrp+fcIafuKsj9WiLKpazVVcVuhP01OG+V4F
   Q==;
X-CSE-ConnectionGUID: jJqyrZS3RXyRlkT48mnLSQ==
X-CSE-MsgGUID: e5NG4dUOSFKVx+6+0n136g==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="77725007"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="77725007"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 01:33:15 -0700
X-CSE-ConnectionGUID: mo2f/4+XQjiVwZxxpjR73w==
X-CSE-MsgGUID: dJzl36mpQtaR68a/Wq3OAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="174812236"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 01:33:12 -0700
Message-ID: <bdeb40c0-a17e-4a71-9be2-62ee3ef699a6@linux.intel.com>
Date: Tue, 16 Sep 2025 16:33:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 10/41] KVM: x86: Add fault checks for guest CR4.CET
 setting
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-11-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250912232319.429659-11-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> Check potential faults for CR4.CET setting per Intel SDM requirements.
> CET can be enabled if and only if CR0.WP == 1, i.e. setting CR4.CET ==
> 1 faults if CR0.WP == 0 and setting CR0.WP == 0 fails if CR4.CET == 1.
>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/x86.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a95ca2fbd3a9..5653ddfe124e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1176,6 +1176,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>   	    (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)))
>   		return 1;
>   
> +	if (!(cr0 & X86_CR0_WP) && kvm_is_cr4_bit_set(vcpu, X86_CR4_CET))
> +		return 1;
> +
>   	kvm_x86_call(set_cr0)(vcpu, cr0);
>   
>   	kvm_post_set_cr0(vcpu, old_cr0, cr0);
> @@ -1376,6 +1379,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>   			return 1;
>   	}
>   
> +	if ((cr4 & X86_CR4_CET) && !kvm_is_cr0_bit_set(vcpu, X86_CR0_WP))
> +		return 1;
> +
>   	kvm_x86_call(set_cr4)(vcpu, cr4);
>   
>   	kvm_post_set_cr4(vcpu, old_cr4, cr4);


