Return-Path: <kvm+bounces-39094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1C78A435E5
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 08:02:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C42D1897906
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 07:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B359C25A2AB;
	Tue, 25 Feb 2025 07:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="esTIaEsc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDAA19F495;
	Tue, 25 Feb 2025 07:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740466928; cv=none; b=PDy3RtbKM4N+QDA/sS2/MAen2+E8aZHdb5zZ0cDhAguJsVdFW0XJgWAQeQGCNnD70+cFLp93tB4ZSMy/vN3VPTK0XLI9jANH5bkxLWAesJ0fg8eUJ6KJYYUV/LjjnUFpMOaFeLltj73pDlz6hOrLhBxJey08sGOyUKydagd17zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740466928; c=relaxed/simple;
	bh=YDHo7zYDPufYkhp0Cg7rVy8EeU6sr95Qg3slPgjgbZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sT2X33uS/g80g116hMWiFIXwOLNAKu0+24rLuzdCzonlJS/Q9rlh6pd/tyxBUz/gwFuAuaxHY4fCEYoNKFg6lpfGYkMrHxp1dor4MWepzdCej8SaAiqGHtNTtNRRBnRgiiTxzPzxi4eWX2B5/w58957xQnZ3TXgTb0t2eqybRuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=esTIaEsc; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740466926; x=1772002926;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YDHo7zYDPufYkhp0Cg7rVy8EeU6sr95Qg3slPgjgbZs=;
  b=esTIaEsct5yImYUcwdNv8MKeRJ+N4VPSiUVB7wPlt1o1afpj5YCkgF8m
   GdrGEgNxKcbB/WO2Ul1EVUCoaaIf0HOR7iuQz26UTv4tV8Gf2kWyoUHKG
   MsFmIQI6p2kQHYoxxzLO8BTl25i8kqMjpMEhNScaGAJpkii7iQ8TTQuW+
   2QdYLe1NiaVPujwHBwG5UW881xI/zTY4/qnCItwaAn03xweETFLVwwTLq
   Uv9Zk+PZ5wNR6H914GdUjAXhorhIpu1Ok2ilb6/dmcIWHuJ5Kl6cu0IU/
   CfTKmMSNp/8FLhVLT0LsqzlTLO3UrD65zYnmcU7PgYuuLGXzrug3vJE7V
   g==;
X-CSE-ConnectionGUID: TcMzh/7DSwO8SB3/1HHHPQ==
X-CSE-MsgGUID: VqjsPH1vQQannjYRPkJTMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11355"; a="58800459"
X-IronPort-AV: E=Sophos;i="6.13,313,1732608000"; 
   d="scan'208";a="58800459"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 23:02:05 -0800
X-CSE-ConnectionGUID: PLmv9oSlQgGcx5tVsMaXbQ==
X-CSE-MsgGUID: aLVqLw5LSxyiBlo+nJhKuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,313,1732608000"; 
   d="scan'208";a="116073207"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 23:02:01 -0800
Message-ID: <e2c4fa9f-a2af-494b-b4b0-71f11365e36c@intel.com>
Date: Tue, 25 Feb 2025 15:01:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 09/12] KVM: TDX: restore user ret MSRs
To: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com,
 seanjc@google.com
Cc: kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com,
 nik.borisov@suse.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-10-adrian.hunter@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250129095902.16391-10-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/29/2025 5:58 PM, Adrian Hunter wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Several user ret MSRs are clobbered on TD exit.  Restore those values on
> TD exit and before returning to ring 3.
> 
> Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
> Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> TD vcpu enter/exit v2:
>   - No changes
> 
> TD vcpu enter/exit v1:
>   - Rename tdx_user_return_update_cache() ->
>       tdx_user_return_msr_update_cache() (extrapolated from Binbin)
>   - Adjust to rename in previous patches (Binbin)
>   - Simplify comment (Tony)
>   - Move code change in tdx_hardware_setup() to __tdx_bringup().
> ---
>   arch/x86/kvm/vmx/tdx.c | 44 +++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 43 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index e4355553569a..a0f5cdfd290b 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -729,6 +729,28 @@ int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu)
>   	return 1;
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
> +static void tdx_user_return_msr_update_cache(void)
> +{
> +	int i;

I think it can be optimized to skip update cache if it the caches are 
updated already. No need to update the cache after every TD exit.

> +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
> +		kvm_user_return_msr_update_cache(tdx_uret_msrs[i].slot,
> +						 tdx_uret_msrs[i].defval);
> +}
> +
>   static bool tdx_guest_state_is_invalid(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> @@ -784,6 +806,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>   
>   	tdx_vcpu_enter_exit(vcpu);
>   
> +	tdx_user_return_msr_update_cache();
> +
>   	kvm_load_host_xsave_state(vcpu);
>   
>   	vcpu->arch.regs_avail &= ~TDX_REGS_UNSUPPORTED_SET;
> @@ -2245,7 +2269,25 @@ static bool __init kvm_can_support_tdx(void)
>   static int __init __tdx_bringup(void)
>   {
>   	const struct tdx_sys_info_td_conf *td_conf;
> -	int r;
> +	int r, i;
> +
> +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
> +		/*
> +		 * Check if MSRs (tdx_uret_msrs) can be saved/restored
> +		 * before returning to user space.
> +		 *
> +		 * this_cpu_ptr(user_return_msrs)->registered isn't checked
> +		 * because the registration is done at vcpu runtime by
> +		 * tdx_user_return_msr_update_cache().
> +		 */
> +		tdx_uret_msrs[i].slot = kvm_find_user_return_msr(tdx_uret_msrs[i].msr);
> +		if (tdx_uret_msrs[i].slot == -1) {
> +			/* If any MSR isn't supported, it is a KVM bug */
> +			pr_err("MSR %x isn't included by kvm_find_user_return_msr\n",
> +				tdx_uret_msrs[i].msr);
> +			return -EIO;
> +		}
> +	}
>   
>   	/*
>   	 * Enabling TDX requires enabling hardware virtualization first,


