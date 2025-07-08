Return-Path: <kvm+bounces-51741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B24DAFC3D5
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 09:17:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 354D5189FC79
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 07:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14DE229617D;
	Tue,  8 Jul 2025 07:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QCLjcjQP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECF61386B4
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 07:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751959026; cv=none; b=S/G5EIlNd/byvQfDP5b2s3lU2W32TrY/K2hGhV6PjiW4VggoRHgyr5FQOK97QhrXChQlGl9e9Z+PEIBnVrCZJtnZcBZOsijX6AHbM/dYzAg/7zDM5vK8j0PKvxPwmVkpzglYyOJ/Ea6Wi13H4aVuLPhhMhWy3g5ZK8y/ZgP/8sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751959026; c=relaxed/simple;
	bh=iTuacHb5oSnJ7VSx7pk7QtG2xA0c2fNHQgkfsycKdNk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m6vNfgqYyCEEymgsjBQFswFhNHTljCDDjKiMCeNZIHNd/Z6Oh4lsJs9nNkqlJFiuuDXC9xLg23KayW8sx0xJH2UyPScoAjoAKCavJQ7V7fANta1pw3SVlvATxh6tFxbJpw3unmyU2HMz9ZlpefNr5VBV5pG0nAPVtwSnk0iUfx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QCLjcjQP; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751959023; x=1783495023;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iTuacHb5oSnJ7VSx7pk7QtG2xA0c2fNHQgkfsycKdNk=;
  b=QCLjcjQPUbw7+Cg/Ob8Prwc7vWtbUaW+vicktNNJEjIL9bKimwlketPV
   CIXXTalX0iPav4rYxPmPKrG9zMeuh9xU9a4JClgskDr5eIPPgMpOiuFGx
   gDFKcuF6y4JhpKQ+oNP5Wa10+u4cYiLE1FxRbZ020sK3OgAnlLtstrFvK
   s/zfiCbsydUmNHzrT6Y74pi1z68eiawwwdMgN8ADBSVEDwlzXWr6iDYB0
   VKF8Keehp/M238kgwU1Hk3H+j8ALh7mxoXlcjrMtbVsG1dCE0NDFheR9u
   WckL7Vuu+78o5qe0+dJypMxWeLATh89JylLT5PQ5TN/8zdHSbu5bQK2gg
   A==;
X-CSE-ConnectionGUID: qy0pFH1XTPWfmINNlU1V1w==
X-CSE-MsgGUID: WSKTGDv0QT6GeZkpCvHPHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54073086"
X-IronPort-AV: E=Sophos;i="6.16,296,1744095600"; 
   d="scan'208";a="54073086"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 00:16:55 -0700
X-CSE-ConnectionGUID: 8QuCIgNTRYqss+XejEVw9Q==
X-CSE-MsgGUID: qxM6hqD6R/qTgCjHr3uUKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,296,1744095600"; 
   d="scan'208";a="154836136"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 00:16:52 -0700
Message-ID: <cf03633c-63ba-40b7-abd1-8cbeb4daadd9@intel.com>
Date: Tue, 8 Jul 2025 15:16:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
To: "Huang, Kai" <kai.huang@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
Cc: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "vaishali.thakkar@suse.com" <vaishali.thakkar@suse.com>,
 "santosh.shukla@amd.com" <santosh.shukla@amd.com>,
 "bp@alien8.de" <bp@alien8.de>
References: <20250707101029.927906-1-nikunj@amd.com>
 <20250707101029.927906-3-nikunj@amd.com>
 <26a5d7dcc54ec434615e0cfb340ad93a429b3f90.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <26a5d7dcc54ec434615e0cfb340ad93a429b3f90.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/8/2025 10:21 AM, Huang, Kai wrote:
> On Mon, 2025-07-07 at 15:40 +0530, Nikunj A Dadhania wrote:
>> Add support for Secure TSC, allowing userspace to configure the Secure TSC
>> feature for SNP guests. Use the SNP specification's desired TSC frequency
>> parameter during the SNP_LAUNCH_START command to set the mean TSC
>> frequency in KHz for Secure TSC enabled guests.
>>
>> Always use kvm->arch.arch.default_tsc_khz as the TSC frequency that is
>> passed to SNP guests in the SNP_LAUNCH_START command.  The default value
>> is the host TSC frequency.  The userspace can optionally change the TSC
>> frequency via the KVM_SET_TSC_KHZ ioctl before calling the
>> SNP_LAUNCH_START ioctl.
>>
>> Introduce the read-only MSR GUEST_TSC_FREQ (0xc0010134) that returns
>> guest's effective frequency in MHZ when Secure TSC is enabled for SNP
>> guests. Disable interception of this MSR when Secure TSC is enabled. Note
>> that GUEST_TSC_FREQ MSR is accessible only to the guest and not from the
>> hypervisor context.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> This SoB isn't needed.
> 
>> Co-developed-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
>> Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
>> Co-developed-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>
> 
> [...]
> 
>> @@ -2146,6 +2158,14 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   
>>   	start.gctx_paddr = __psp_pa(sev->snp_context);
>>   	start.policy = params.policy;
>> +
>> +	if (snp_secure_tsc_enabled(kvm)) {
>> +		if (!kvm->arch.default_tsc_khz)
>> +			return -EINVAL;
> 
> Here snp_context_create() has been called successfully therefore IIUC you
> need to use
> 
> 		goto e_free_context;
> 
> instead.
> 
> Btw, IIUC it shouldn't be possible for the kvm->arch.default_tsc_khz to be
> 0.  Perhaps we can just remove the check.
> 
> Even some bug results in the default_tsc_khz being 0, will the
> SNP_LAUNCH_START command catch this and return error?
> 
>> +
>> +		start.desired_tsc_khz = kvm->arch.default_tsc_khz;
>> +	}
>> +
>>   	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
>>   	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
>>   	if (rc) {
>> @@ -2386,7 +2406,9 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   			return ret;
>>   		}
>>   
>> -		svm->vcpu.arch.guest_state_protected = true;
>> +		vcpu->arch.guest_state_protected = true;
>> +		vcpu->arch.guest_tsc_protected = snp_secure_tsc_enabled(kvm);
>> +
> 
> + Xiaoyao.
> 
> The KVM_SET_TSC_KHZ can also be a vCPU ioctl (in fact, the support of VM
> ioctl of it was added later).  I am wondering whether we should reject
> this vCPU ioctl for TSC protected guests, like:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2806f7104295..699ca5e74bba 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6186,6 +6186,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>                  u32 user_tsc_khz;
>   
>                  r = -EINVAL;
> +
> +               if (vcpu->arch.guest_tsc_protected)
> +                       goto out;
> +
>                  user_tsc_khz = (u32)arg;
>   
>                  if (kvm_caps.has_tsc_control &&

It seems to need to be opt-in since it changes the ABI somehow. E.g., it 
at least works before when the VMM calls KVM_SET_TSC_KHZ at vcpu with 
the same value passed to KVM_SET_TSC_KHZ at vm. But with the above 
change, it would fail.

Well, in reality, it's OK for QEMU since QEMU explicitly doesn't call 
KVM_SET_TSC_KHZ at vcpu for TDX VMs. But I'm not sure about the impact 
on other VMMs. Considering KVM TDX support just gets in from v6.16-rc1, 
maybe it doesn't have real impact for other VMMs as well?


