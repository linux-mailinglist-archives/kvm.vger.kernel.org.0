Return-Path: <kvm+bounces-53874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A24D6B18F96
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 19:34:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BADD6179A34
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 17:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96AC024DD07;
	Sat,  2 Aug 2025 17:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="fGu2IbbO"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DDF2E36EA;
	Sat,  2 Aug 2025 17:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754156047; cv=none; b=jjDmaCy79WtaQDYmwylFAEwTebZZx7vpivGD40qTHRlK6oq2LLx2SdJ2ugXrmoH1Ra/ZygoiIzlUY2yOGbDe3xesS8P2tC8a+8NbLgvsXubv6PETzDDodtOfWW2UYk0sx04LYCevGjWxh8XorfgdvQobaC9wbpVO425fI3269EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754156047; c=relaxed/simple;
	bh=riIvVqDAcGY8QU+w6sjTBKD12HK5GR1jib3u5T3XB1Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fAdVzRz03ZD/ap9AvZW0r61/2Onny5P4XAKWeJh/daopB13ZNFoo+dn2FD3W77UH9hbJG9eYTKD2kSdeMA8Lajl5wryivmJdYsv1td3tw8Ob7A4gVATRGaQ6j9g0jZ+f81j6CFpDkCtj9hTvkLxPoUU0C1rVw8h33SeycA4auzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=fGu2IbbO; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 572HXbfG3686634
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Sat, 2 Aug 2025 10:33:38 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 572HXbfG3686634
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1754156020;
	bh=+R4wObZkaFNXG30xKTEX89eM7VdUzI2d5uFve1iFUQM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fGu2IbbOKXSqlb9vhNCVdqH1bavp3EIyJysRiWi4iVZPtFPWFqAmgdux/zSagijuZ
	 jYusFA0jjkeyUyQk6L9BUsWuuym7/zv/mVyWh2czGhcz5riCWLsRebxapV9tKpYaYo
	 50f4PkM2XQ3NwZlLnQZ7Mg5dgmlfpvtOZg0VNUqfqekNgTGjwV+pGhjR5/ChgmqQbA
	 P2+jsJZ0srO/UAyTlK+lU+l/9myWp9UP9Y3/JtX5fPIuF8NLyQ7j5WejtnyGetXw0W
	 6rVwXbtgkUgWxY0qHuvveToSx38IZVlaXlQmZjEv2BrQ7abtyINQXQmaFz0Sxokp+M
	 mVmZD58uil+0Q==
Message-ID: <aad3d385-5743-4f81-992a-22d1701c3611@zytor.com>
Date: Sat, 2 Aug 2025 10:33:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5A 20/23] KVM: nVMX: Add FRED VMCS fields to nested VMX
 context handling
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, chao.gao@intel.com, hch@infradead.org
References: <aIHXngnkcJIY0TUw@intel.com>
 <20250802171740.3677712-1-xin@zytor.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250802171740.3677712-1-xin@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> @@ -4531,6 +4593,27 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
>   	vmcs12->guest_tr_base = vmcs_readl(GUEST_TR_BASE);
>   	vmcs12->guest_gdtr_base = vmcs_readl(GUEST_GDTR_BASE);
>   	vmcs12->guest_idtr_base = vmcs_readl(GUEST_IDTR_BASE);
> +
> +	vmx->nested.pre_vmexit_fred_config = vmcs_read64(GUEST_IA32_FRED_CONFIG);
> +	vmx->nested.pre_vmexit_fred_rsp1 = vmcs_read64(GUEST_IA32_FRED_RSP1);
> +	vmx->nested.pre_vmexit_fred_rsp2 = vmcs_read64(GUEST_IA32_FRED_RSP2);
> +	vmx->nested.pre_vmexit_fred_rsp3 = vmcs_read64(GUEST_IA32_FRED_RSP3);
> +	vmx->nested.pre_vmexit_fred_stklvls = vmcs_read64(GUEST_IA32_FRED_STKLVLS);
> +	vmx->nested.pre_vmexit_fred_ssp1 = vmcs_read64(GUEST_IA32_FRED_SSP1);
> +	vmx->nested.pre_vmexit_fred_ssp2 = vmcs_read64(GUEST_IA32_FRED_SSP2);
> +	vmx->nested.pre_vmexit_fred_ssp3 = vmcs_read64(GUEST_IA32_FRED_SSP3);

This ...

> +
> +	if (nested_cpu_save_guest_fred_state(vmcs12)) {
> +		vmcs12->guest_ia32_fred_config = vmx->nested.pre_vmexit_fred_config;
> +		vmcs12->guest_ia32_fred_rsp1 = vmx->nested.pre_vmexit_fred_rsp1;
> +		vmcs12->guest_ia32_fred_rsp2 = vmx->nested.pre_vmexit_fred_rsp2;
> +		vmcs12->guest_ia32_fred_rsp3 = vmx->nested.pre_vmexit_fred_rsp3;
> +		vmcs12->guest_ia32_fred_stklvls = vmx->nested.pre_vmexit_fred_stklvls;
> +		vmcs12->guest_ia32_fred_ssp1 = vmx->nested.pre_vmexit_fred_ssp1;
> +		vmcs12->guest_ia32_fred_ssp2 = vmx->nested.pre_vmexit_fred_ssp2;
> +		vmcs12->guest_ia32_fred_ssp3 = vmx->nested.pre_vmexit_fred_ssp3;
> +	}
> +
>   	vmcs12->guest_pending_dbg_exceptions =
>   		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
>   
> @@ -4761,6 +4860,26 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>   	vmcs_write32(GUEST_IDTR_LIMIT, 0xFFFF);
>   	vmcs_write32(GUEST_GDTR_LIMIT, 0xFFFF);
>   
> +	if (nested_cpu_load_host_fred_state(vmcs12)) {
> +		vmcs_write64(GUEST_IA32_FRED_CONFIG, vmcs12->host_ia32_fred_config);
> +		vmcs_write64(GUEST_IA32_FRED_RSP1, vmcs12->host_ia32_fred_rsp1);
> +		vmcs_write64(GUEST_IA32_FRED_RSP2, vmcs12->host_ia32_fred_rsp2);
> +		vmcs_write64(GUEST_IA32_FRED_RSP3, vmcs12->host_ia32_fred_rsp3);
> +		vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmcs12->host_ia32_fred_stklvls);
> +		vmcs_write64(GUEST_IA32_FRED_SSP1, vmcs12->host_ia32_fred_ssp1);
> +		vmcs_write64(GUEST_IA32_FRED_SSP2, vmcs12->host_ia32_fred_ssp2);
> +		vmcs_write64(GUEST_IA32_FRED_SSP3, vmcs12->host_ia32_fred_ssp3);
> +	} else {
> +		vmcs_write64(GUEST_IA32_FRED_CONFIG, vmx->nested.pre_vmexit_fred_config);
> +		vmcs_write64(GUEST_IA32_FRED_RSP1, vmx->nested.pre_vmexit_fred_rsp1);
> +		vmcs_write64(GUEST_IA32_FRED_RSP2, vmx->nested.pre_vmexit_fred_rsp2);
> +		vmcs_write64(GUEST_IA32_FRED_RSP3, vmx->nested.pre_vmexit_fred_rsp3);
> +		vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmx->nested.pre_vmexit_fred_stklvls);
> +		vmcs_write64(GUEST_IA32_FRED_SSP1, vmx->nested.pre_vmexit_fred_ssp1);
> +		vmcs_write64(GUEST_IA32_FRED_SSP2, vmx->nested.pre_vmexit_fred_ssp2);
> +		vmcs_write64(GUEST_IA32_FRED_SSP3, vmx->nested.pre_vmexit_fred_ssp3);

And this are actually nops. IOW, if I don't add this snippet of code,
the CPU still retains the guest FRED MSRs, i.e., using guest FRED state 
from vmcs02 as that of vmcs01.

> +	}
> +
>   	/* If not VM_EXIT_CLEAR_BNDCFGS, the L2 value propagates to L1.  */
>   	if (vmcs12->vm_exit_controls & VM_EXIT_CLEAR_BNDCFGS)
>   		vmcs_write64(GUEST_BNDCFGS, 0);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 617cbec5c9b3..885e48fe33c4 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -181,6 +181,39 @@ struct nested_vmx {
>   	 */
>   	u64 pre_vmenter_debugctl;
>   	u64 pre_vmenter_bndcfgs;
> +	u64 pre_vmenter_fred_config;
> +	u64 pre_vmenter_fred_rsp1;
> +	u64 pre_vmenter_fred_rsp2;
> +	u64 pre_vmenter_fred_rsp3;
> +	u64 pre_vmenter_fred_stklvls;
> +	u64 pre_vmenter_fred_ssp1;
> +	u64 pre_vmenter_fred_ssp2;
> +	u64 pre_vmenter_fred_ssp3;
> +
> +	/*
> +	 * Used to snapshot MSRs that are conditionally saved on VM-Exit in
> +	 * order to propagate the guest's pre-VM-Exit value into vmcs12.
> +	 *
> +	 * FRED MSRs are *always* saved to vmcs02 since KVM always sets
> +	 * SECONDARY_VM_EXIT_SAVE_IA32_FRED.  However an L1 VMM, although
> +	 * unlikely, might choose not to set this bit, resulting in FRED MSRs
> +	 * not being saved to vmcs12.
> +	 *
> +	 * It's not a problem when SECONDARY_VM_EXIT_LOAD_IA32_FRED is set,
> +	 * as the CPU immediately loads the host FRED state from vmcs12 into
> +	 * the FRED MSRs.
> +	 *
> +	 * But an L1 VMM may clear SECONDARY_VM_EXIT_LOAD_IA32_FRED, causing
> +	 * the CPU to retain the pre VM-Exit FRED MSRs.
> +	 */

However I want to make this logic explicit. So we might end up with
adding the comment somewhere and removing all the pre_vmexit_fred_*
changes?

> +	u64 pre_vmexit_fred_config;
> +	u64 pre_vmexit_fred_rsp1;
> +	u64 pre_vmexit_fred_rsp2;
> +	u64 pre_vmexit_fred_rsp3;
> +	u64 pre_vmexit_fred_stklvls;
> +	u64 pre_vmexit_fred_ssp1;
> +	u64 pre_vmexit_fred_ssp2;
> +	u64 pre_vmexit_fred_ssp3;
>   
>   	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
>   	int l1_tpr_threshold;

Thanks!
     Xin

