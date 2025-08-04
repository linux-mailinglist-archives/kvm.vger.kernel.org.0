Return-Path: <kvm+bounces-53882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 790AEB19B4B
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 08:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 752811770F7
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 06:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC63D22F74D;
	Mon,  4 Aug 2025 06:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="rFfZBdH1"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D750218ACA;
	Mon,  4 Aug 2025 06:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754287477; cv=none; b=HEV20WTm6GBvANfwqqsgFIZd4prlOgTpcnnm0h4qXhxgVsOqaWaZX7F2VIyhI/v3z+uD+6A4THO6sHry4rKYUDqvUlkF2aGfNMvHIG0ZPhjJmukHKvk6jo++yoIvM0U1lePUxmTao/VLJ8f5zKwuryGRwZoSj6ZtISFkuHu/fwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754287477; c=relaxed/simple;
	bh=6Vrhh4CTXewypPsMkw99R7S67HxgozZhczdmjvE6+sA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=WbxCzmyPfjaxCIwxdfuT9opZF/d8KqdZ7sfv4Axuu58Yr9FUuALKSs8Ulfq1u2QXvDWlzCn2BH8xlKMSFLYnJe8zYA50jRL1krjN6Mj9jTacP6HRARDVQm3WLnwl53sF0XmePgYnLgcG+YwCT2DmxTXgtodIPnmV/GXFw4+nag4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=rFfZBdH1; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57463Gf1685727
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Sun, 3 Aug 2025 23:03:17 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57463Gf1685727
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1754287400;
	bh=1UvSEgLS9kHk3uMzku7DKxRmuJ3xE+/qZAFiYECcR3c=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=rFfZBdH1011mTnLueI/EDslLu0GpRaP2Tf/VuxRLEa/LR3j2uQkmtB94yYKQiTIe3
	 lLnxhbqiK01Pzki3pIoKzKhddPoP8rMnSsX3nfnbuL57st5BBapBV6Lr3hJbBCZ/Ft
	 vkM9vm6+wMGu3f0/nN8yzKlN2iNieRT6iLObqQD4dR5Vg+xyWLxrTdWp6rvBe1Jrq4
	 zNmEoaGQx3rEYto24d4FxywDIU9lcSW1W1UCRyLIsjAksWRAJPcvlUtIIsuAyPBVL/
	 jUz75YkoTxJ9TlmeHXMeJzeDsmK+pFTlVvU9OAZi5eVpCwLKkooioOMmu3HAZnd6/A
	 AvadKtJCljKgQ==
Message-ID: <5ca5d98e-6a3c-48fc-8aa2-7db0980543e6@zytor.com>
Date: Sun, 3 Aug 2025 23:03:16 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5A 20/23] KVM: nVMX: Add FRED VMCS fields to nested VMX
 context handling
From: Xin Li <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, chao.gao@intel.com, hch@infradead.org
References: <aIHXngnkcJIY0TUw@intel.com>
 <20250802171740.3677712-1-xin@zytor.com>
 <aad3d385-5743-4f81-992a-22d1701c3611@zytor.com>
Content-Language: en-US
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aad3d385-5743-4f81-992a-22d1701c3611@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/2/2025 10:33 AM, Xin Li wrote:
>> @@ -4531,6 +4593,27 @@ static void sync_vmcs02_to_vmcs12_rare(struct 
>> kvm_vcpu *vcpu,
>>       vmcs12->guest_tr_base = vmcs_readl(GUEST_TR_BASE);
>>       vmcs12->guest_gdtr_base = vmcs_readl(GUEST_GDTR_BASE);
>>       vmcs12->guest_idtr_base = vmcs_readl(GUEST_IDTR_BASE);
>> +
>> +    vmx->nested.pre_vmexit_fred_config = 
>> vmcs_read64(GUEST_IA32_FRED_CONFIG);
>> +    vmx->nested.pre_vmexit_fred_rsp1 = 
>> vmcs_read64(GUEST_IA32_FRED_RSP1);
>> +    vmx->nested.pre_vmexit_fred_rsp2 = 
>> vmcs_read64(GUEST_IA32_FRED_RSP2);
>> +    vmx->nested.pre_vmexit_fred_rsp3 = 
>> vmcs_read64(GUEST_IA32_FRED_RSP3);
>> +    vmx->nested.pre_vmexit_fred_stklvls = 
>> vmcs_read64(GUEST_IA32_FRED_STKLVLS);
>> +    vmx->nested.pre_vmexit_fred_ssp1 = 
>> vmcs_read64(GUEST_IA32_FRED_SSP1);
>> +    vmx->nested.pre_vmexit_fred_ssp2 = 
>> vmcs_read64(GUEST_IA32_FRED_SSP2);
>> +    vmx->nested.pre_vmexit_fred_ssp3 = 
>> vmcs_read64(GUEST_IA32_FRED_SSP3);
> 
> This ...
> 
>> +
>> +    if (nested_cpu_save_guest_fred_state(vmcs12)) {
>> +        vmcs12->guest_ia32_fred_config = vmx- 
>> >nested.pre_vmexit_fred_config;
>> +        vmcs12->guest_ia32_fred_rsp1 = vmx->nested.pre_vmexit_fred_rsp1;
>> +        vmcs12->guest_ia32_fred_rsp2 = vmx->nested.pre_vmexit_fred_rsp2;
>> +        vmcs12->guest_ia32_fred_rsp3 = vmx->nested.pre_vmexit_fred_rsp3;
>> +        vmcs12->guest_ia32_fred_stklvls = vmx- 
>> >nested.pre_vmexit_fred_stklvls;
>> +        vmcs12->guest_ia32_fred_ssp1 = vmx->nested.pre_vmexit_fred_ssp1;
>> +        vmcs12->guest_ia32_fred_ssp2 = vmx->nested.pre_vmexit_fred_ssp2;
>> +        vmcs12->guest_ia32_fred_ssp3 = vmx->nested.pre_vmexit_fred_ssp3;
>> +    }
>> +
>>       vmcs12->guest_pending_dbg_exceptions =
>>           vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
>> @@ -4761,6 +4860,26 @@ static void load_vmcs12_host_state(struct 
>> kvm_vcpu *vcpu,
>>       vmcs_write32(GUEST_IDTR_LIMIT, 0xFFFF);
>>       vmcs_write32(GUEST_GDTR_LIMIT, 0xFFFF);
>> +    if (nested_cpu_load_host_fred_state(vmcs12)) {
>> +        vmcs_write64(GUEST_IA32_FRED_CONFIG, vmcs12- 
>> >host_ia32_fred_config);
>> +        vmcs_write64(GUEST_IA32_FRED_RSP1, vmcs12->host_ia32_fred_rsp1);
>> +        vmcs_write64(GUEST_IA32_FRED_RSP2, vmcs12->host_ia32_fred_rsp2);
>> +        vmcs_write64(GUEST_IA32_FRED_RSP3, vmcs12->host_ia32_fred_rsp3);
>> +        vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmcs12- 
>> >host_ia32_fred_stklvls);
>> +        vmcs_write64(GUEST_IA32_FRED_SSP1, vmcs12->host_ia32_fred_ssp1);
>> +        vmcs_write64(GUEST_IA32_FRED_SSP2, vmcs12->host_ia32_fred_ssp2);
>> +        vmcs_write64(GUEST_IA32_FRED_SSP3, vmcs12->host_ia32_fred_ssp3);
>> +    } else {
>> +        vmcs_write64(GUEST_IA32_FRED_CONFIG, vmx- 
>> >nested.pre_vmexit_fred_config);
>> +        vmcs_write64(GUEST_IA32_FRED_RSP1, vmx- 
>> >nested.pre_vmexit_fred_rsp1);
>> +        vmcs_write64(GUEST_IA32_FRED_RSP2, vmx- 
>> >nested.pre_vmexit_fred_rsp2);
>> +        vmcs_write64(GUEST_IA32_FRED_RSP3, vmx- 
>> >nested.pre_vmexit_fred_rsp3);
>> +        vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmx- 
>> >nested.pre_vmexit_fred_stklvls);
>> +        vmcs_write64(GUEST_IA32_FRED_SSP1, vmx- 
>> >nested.pre_vmexit_fred_ssp1);
>> +        vmcs_write64(GUEST_IA32_FRED_SSP2, vmx- 
>> >nested.pre_vmexit_fred_ssp2);
>> +        vmcs_write64(GUEST_IA32_FRED_SSP3, vmx- 
>> >nested.pre_vmexit_fred_ssp3);
> 
> And this are actually nops. IOW, if I don't add this snippet of code,
> the CPU still retains the guest FRED MSRs, i.e., using guest FRED state 
> from vmcs02 as that of vmcs01.

I confused myself.  They are NOT nops, because __nested_vmx_vmexit()
switches from vmcs02 to vmcs01.  The code should be (as the patch does):

__nested_vmx_vmexit()
{
	...

	/*
	 * Save guest FRED state of vmcs02 to nested.pre_vmexit_fred
	 * no matter if SECONDARY_VM_EXIT_SAVE_IA32_FRED is set.
	 */
	sync_vmcs02_to_vmcs12();

	...
	vmx_switch_vmcs();
	...

	/*
	 * Load nested.pre_vmexit_fred to guest FRED state of vmcs01
	 * if SECONDARY_VM_EXIT_LOAD_IA32_FRED is NOT set.
	 */
	load_vmcs12_host_state();

	...
   }


As not setting any of the two FRED VM-Exit controls are rare cases, we
need to add KVM tests with L1 that:
1) doesn't set SECONDARY_VM_EXIT_SAVE_IA32_FRED in VM-Exit controls.
2) doesn't set SECONDARY_VM_EXIT_LOAD_IA32_FRED in VM-Exit controls.
3) doesn't set both of the FRED VM-Exit controls.

Looks we need a framework for all VM-Exit controls which control whether
to save/load specific MSRs related to CPU features during VM-Exit?

