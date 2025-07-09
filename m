Return-Path: <kvm+bounces-51878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A0801AFE00E
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 08:40:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36E96581E44
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 06:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4360E26C393;
	Wed,  9 Jul 2025 06:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vx18ye8N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CE926B08F;
	Wed,  9 Jul 2025 06:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752043231; cv=none; b=koTUC+PtMhTRe8192GaNkrsCIFii+ocFmIFHvYXtlb2UcNpzba+csx3BWz5kMUUMixiTqdqlRdEGU7V6cApHATsTNTr96WOQ35JVtqf9AZbm5Q27xN+eAHTVZFvJEPYAJMH4Bzzvltkj9eCaiWiRGiKxEijBmtDmk0rliVS+hWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752043231; c=relaxed/simple;
	bh=lp3MTCRcAlyCFrEQHENqUGir7Oq9oKMHerutxUIbuZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cuTQYvV9ODf/6jphbVJZ/32srICtc9ZMUAE++htSldHkMqe8PU2+dszUi/pcSklIXY/OBiR4kFyql7uX6asufPOIWs0hyRdQMfj1O76th1IYczjy0j7wQRnNmPvfZ/165YIsUJdHK2NRImUxTirRfhCX4GIkRfXKfD4KdRggeSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vx18ye8N; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752043229; x=1783579229;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lp3MTCRcAlyCFrEQHENqUGir7Oq9oKMHerutxUIbuZc=;
  b=Vx18ye8Nlwp5pX5FtlYKr5HtBMQwmax1w5tNq4Gw2joj03jfOcIkQOfw
   pL+vaRcR+0S/hWxkwLb96rcxU9nSUyPXLumcJNAMw7eZ73ZrhjtxPHS/p
   5I7XdJ6+DUpaKc7IyHDtgslo2WvqMyg3F84WXl41yJ0+HCqIzRhRPiLLh
   pfeMsDcZKTtjerImcbbsLfGZvJj6ED2nAvvZ8qt6ijNxhpw4lw5Vqe96U
   SpvrGlj9B06LvaCP6rVuWdNw23xyqWOHDj7RtSKp3kHtjawbbn/wu1YSm
   zsY2oi48JD2xNRo+YQe0vbZmNscOtNNoi29wrlw6Ks4y64OJrdOJPei+K
   w==;
X-CSE-ConnectionGUID: JZlmXNSLQJq2RmFbscassg==
X-CSE-MsgGUID: IGqMkvZ0Tvq90dwLlfM9JA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="41914937"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="41914937"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 23:40:29 -0700
X-CSE-ConnectionGUID: znBhl4BYQLiifDZsgaRc3g==
X-CSE-MsgGUID: G7RFrLNxTqKwvMoSvng+ZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="159962821"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 23:40:26 -0700
Message-ID: <dbfee32a-694d-4f0e-bab4-221277c8215c@intel.com>
Date: Wed, 9 Jul 2025 14:40:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86: Reject KVM_SET_TSC_KHZ vCPU ioctl for TSC
 protected guest
To: Kai Huang <kai.huang@intel.com>, seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, thomas.lendacky@amd.com, nikunj@amd.com,
 bp@alien8.de, isaku.yamahata@intel.com, rick.p.edgecombe@intel.com,
 linux-kernel@vger.kernel.org
References: <cover.1752038725.git.kai.huang@intel.com>
 <8aebb276ab413f2e4a6512286bd8b6def3596dfe.1752038725.git.kai.huang@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <8aebb276ab413f2e4a6512286bd8b6def3596dfe.1752038725.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/2025 1:37 PM, Kai Huang wrote:
> Reject KVM_SET_TSC_KHZ vCPU ioctl if guest's TSC is protected and not
> changeable by KVM.
> 
> For such TSC protected guests, e.g. TDX guests, typically the TSC is
> configured once at VM level before any vCPU are created and remains
> unchanged during VM's lifetime.  KVM provides the KVM_SET_TSC_KHZ VM
> scope ioctl to allow the userspace VMM to configure the TSC of such VM.
> After that the userspace VMM is not supposed to call the KVM_SET_TSC_KHZ
> vCPU scope ioctl anymore when creating the vCPU.
> 
> The de facto userspace VMM Qemu does this for TDX guests.  The upcoming
> SEV-SNP guests with Secure TSC should follow.
> 
> Note this could be a break of ABI.  But for now only TDX guests are TSC
> protected and only Qemu supports TDX, thus in practice this should not
> break any existing userspace.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/x86.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2806f7104295..699ca5e74bba 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6186,6 +6186,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   		u32 user_tsc_khz;
>   
>   		r = -EINVAL;

I wondered if -EPERM is more appropriate. But I search the KVM files and 
find the KVM convention is to return -EINVAL.

> +		if (vcpu->arch.guest_tsc_protected)
> +			goto out;
> +
>   		user_tsc_khz = (u32)arg;
>   
>   		if (kvm_caps.has_tsc_control &&


