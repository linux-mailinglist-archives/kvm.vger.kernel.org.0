Return-Path: <kvm+bounces-13828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A467F89AEBA
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 07:59:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9A561C223DB
	for <lists+kvm@lfdr.de>; Sun,  7 Apr 2024 05:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 415326AB9;
	Sun,  7 Apr 2024 05:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZGQKuc1+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FC917F0;
	Sun,  7 Apr 2024 05:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712469550; cv=none; b=szgMOXWK6hJy882NhgbakJ5bpevd9iDM4LnqK0HrB3sC+MF703mVb2PFQKV3mCNC7i8hOC3SQzGrc7opSmNKzB+pbAcZ4WTQQO2DmSrdNHAzQzmybPJCFetSmxCaHNLxyLa4Mj91i937u0CwxDxI2Qjdti+sr0w1qrPCgAi8mDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712469550; c=relaxed/simple;
	bh=HLxVepxz8FS+gJU2KFps0ZLBwLnPq2bnUXhfxZMr63g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=do+xJNvz84yQd4j/Ikr2/Dtft+MlmhMpxlORaTDRq9jE+Zqgm473W7TU9vzh2DKli3OMDrBBWny4OrYMEwISYsJ3aeVSjtJm3jSa7sK9FOY3d8iUck33Lhxu75H0FpX9RoW+oe+JcAcFmEgQ2PI0raSdk5FZfgbxkNTXCHk6vr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZGQKuc1+; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712469549; x=1744005549;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HLxVepxz8FS+gJU2KFps0ZLBwLnPq2bnUXhfxZMr63g=;
  b=ZGQKuc1+lu5E/XJrh8Pl+3pdJ9EEkTExwpl8Ps+t97qv66kw1WDAnUO2
   23Wr8ciRQsx4r9IH5g8myLNTmFRyOwULPmo5ltZY9jWOjlbCP/ufpC5TJ
   Fub4EXsyH+MGNsZRDxqNO1QFGWUgAJlyGlDYaOhx7SeobvgA6HtC2ilCN
   uamRvVmgDYack4sot+OYaudU07XFfmCHC0EnzMzEGILfibwRj5eRAtI/h
   YFD6LW/G3uqOT+vMKfOUHdGW4vZzR4eZXuye/2UR5ztZF24PUf80B9XZx
   H+ooLbiLnHCQQWd59hldDvZWXirW14dkM9YF3hAXtzCl9ejTzCXEE1WKH
   Q==;
X-CSE-ConnectionGUID: HZUiDvReSFOjMaEG2maC1g==
X-CSE-MsgGUID: +518VaMlQH6Juya0b3eSNA==
X-IronPort-AV: E=McAfee;i="6600,9927,11036"; a="18486284"
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="18486284"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2024 22:59:08 -0700
X-CSE-ConnectionGUID: XwpPcbBXTwORQsCI3W0SjQ==
X-CSE-MsgGUID: EHTxwHZoTJOBICWGCucCxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,184,1708416000"; 
   d="scan'208";a="19478304"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.236.140]) ([10.124.236.140])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2024 22:59:05 -0700
Message-ID: <c0a1de41-79fc-49f2-87a2-0ac2918ca84f@linux.intel.com>
Date: Sun, 7 Apr 2024 13:59:03 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 082/130] KVM: TDX: restore user ret MSRs
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <8ba41a08c98034fd4f3886791d1d068b0d390f86.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <8ba41a08c98034fd4f3886791d1d068b0d390f86.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Several user ret MSRs are clobbered on TD exit.  Restore those values on
> TD exit

Here "Restore" is not accurate, since the previous patch just updates 
the cached value on TD exit.

> and before returning to ring 3.  Because TSX_CTRL requires special
> treat, this patch doesn't address it.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 43 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 43 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 199226c6cf55..7e2b1e554246 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -535,6 +535,28 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	 */
>   }
>   
> +struct tdx_uret_msr {
> +	u32 msr;
> +	unsigned int slot;
> +	u64 defval;
> +};
> +
> +static struct tdx_uret_msr tdx_uret_msrs[] = {
> +	{.msr = MSR_SYSCALL_MASK, .defval = 0x20200 },
> +	{.msr = MSR_STAR,},
> +	{.msr = MSR_LSTAR,},
> +	{.msr = MSR_TSC_AUX,},
> +};
> +
> +static void tdx_user_return_update_cache(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
> +		kvm_user_return_update_cache(tdx_uret_msrs[i].slot,
> +					     tdx_uret_msrs[i].defval);
> +}
> +
>   static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> @@ -627,6 +649,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
>   
>   	tdx_vcpu_enter_exit(tdx);
>   
> +	tdx_user_return_update_cache();
>   	tdx_restore_host_xsave_state(vcpu);
>   	tdx->host_state_need_restore = true;
>   
> @@ -1972,6 +1995,26 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>   		return -EINVAL;
>   	}
>   
> +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
> +		/*
> +		 * Here it checks if MSRs (tdx_uret_msrs) can be saved/restored
> +		 * before returning to user space.
> +		 *
> +		 * this_cpu_ptr(user_return_msrs)->registered isn't checked
> +		 * because the registration is done at vcpu runtime by
> +		 * kvm_set_user_return_msr().
Should be tdx_user_return_update_cache(), if it's the final API name.

> +		 * Here is setting up cpu feature before running vcpu,
> +		 * registered is already false.
                                   ^
                            remove "already"?

> +		 */
> +		tdx_uret_msrs[i].slot = kvm_find_user_return_msr(tdx_uret_msrs[i].msr);
> +		if (tdx_uret_msrs[i].slot == -1) {
> +			/* If any MSR isn't supported, it is a KVM bug */
> +			pr_err("MSR %x isn't included by kvm_find_user_return_msr\n",
> +				tdx_uret_msrs[i].msr);
> +			return -EIO;
> +		}
> +	}
> +
>   	max_pkgs = topology_max_packages();
>   	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
>   				   GFP_KERNEL);


