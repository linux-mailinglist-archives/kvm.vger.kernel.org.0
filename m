Return-Path: <kvm+bounces-57966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F250FB82E7A
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 06:48:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C07B27B96B9
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 04:46:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82979274641;
	Thu, 18 Sep 2025 04:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Nz0QNNv0"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1456C218580;
	Thu, 18 Sep 2025 04:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758170905; cv=none; b=LPd4dZfGnsIs/9/Dgm8WPV/Xvei0DVWR+BhW2u2EGr3elSBCqJcaNDi2gyFdY63a12G0skq4SsYf8Zft8Tv/x8BQgjn25/PJL7I9OVxhFgAXYfyNOqfvVsMRtvllSKVAFR136cdtociOI0wcTMImHszoUM7fOSBZ8zeKnaPN4Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758170905; c=relaxed/simple;
	bh=xq6OiKNLmRCLUT4vTOb6Su3dAbQ48KsaBopGwGVmFJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JFrGl3PG49G66wJRhQFG8pk9PVeV8K4BjBCOWPDiz82gakjfTOedgPeBMK7mc0PwIf2zh+7szGw/czgr4yZOQkFJ331GAV4Rr95ptWrDzktFO6Gb31/AvGV9xJ+P4vnVNrYiF/AWSIQVbJrPUuPxM+NftRsVu0lfztl9jonXaN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Nz0QNNv0; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 58I4mAYF2739873
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 17 Sep 2025 21:48:11 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 58I4mAYF2739873
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1758170892;
	bh=3up4cdCYVxqDr3VCq8VOUm1xI+NciS4w2htNoZBF9T0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Nz0QNNv0fLGDzhFNnbuJNJKMV0s3O1imIgUVEdWKz+mS698UAvHUiZDp6Y5e9zIPT
	 LlD70Xxvyda1K+zmL/sVvdEiZ+MnuSAcU67TctEOtT0yIqMVKNroMEXzUFYZ3y4WGH
	 uPHQM+NRYNuSw3YXXvZ3P2s4aDxvlZUn/H6k7b8hIXXbRFgvwiFY3Zg08othsTJcR3
	 tSh5f0kJFjepSK2fEtIJS3sAe3bAmlKOkAxGKxRqJj5rJ9a065UzN4s2p3XVPAC0hf
	 XMJxF2C+uF++5ECgCPEDZ6gkEKMCN6JI35PlQQ+QrpQCChdgUjqIq4T0i30JTc+iNe
	 4/csEDhLWV2ww==
Message-ID: <26947f1a-2162-4083-b39f-c360d6046877@zytor.com>
Date: Wed, 17 Sep 2025 21:48:10 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 21/41] KVM: nVMX: Prepare for enabling CET support for
 nested guest
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Mathias Krause <minipli@grsecurity.net>,
        John Allen <john.allen@amd.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-22-seanjc@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250912232319.429659-22-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/2025 4:22 PM, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
> index 56fd150a6f24..4ad6b16525b9 100644
> --- a/arch/x86/kvm/vmx/vmcs12.h
> +++ b/arch/x86/kvm/vmx/vmcs12.h
> @@ -117,7 +117,13 @@ struct __packed vmcs12 {
>   	natural_width host_ia32_sysenter_eip;
>   	natural_width host_rsp;
>   	natural_width host_rip;
> -	natural_width paddingl[8]; /* room for future expansion */
> +	natural_width host_s_cet;
> +	natural_width host_ssp;
> +	natural_width host_ssp_tbl;
> +	natural_width guest_s_cet;
> +	natural_width guest_ssp;
> +	natural_width guest_ssp_tbl;
> +	natural_width paddingl[2]; /* room for future expansion */
>   	u32 pin_based_vm_exec_control;
>   	u32 cpu_based_vm_exec_control;
>   	u32 exception_bitmap;
> @@ -294,6 +300,12 @@ static inline void vmx_check_vmcs12_offsets(void)
>   	CHECK_OFFSET(host_ia32_sysenter_eip, 656);
>   	CHECK_OFFSET(host_rsp, 664);
>   	CHECK_OFFSET(host_rip, 672);
> +	CHECK_OFFSET(host_s_cet, 680);
> +	CHECK_OFFSET(host_ssp, 688);
> +	CHECK_OFFSET(host_ssp_tbl, 696);
> +	CHECK_OFFSET(guest_s_cet, 704);
> +	CHECK_OFFSET(guest_ssp, 712);
> +	CHECK_OFFSET(guest_ssp_tbl, 720);
>   	CHECK_OFFSET(pin_based_vm_exec_control, 744);
>   	CHECK_OFFSET(cpu_based_vm_exec_control, 748);
>   	CHECK_OFFSET(exception_bitmap, 752);


This patch modifies struct vms12 without updating the corresponding vmcs12
definition in Documentation/virt/kvm/x86/nested-vmx.rst.  However,
duplicating the definition within the same source tree seems unnecessary
and prone to inconsistencies.  E.g., the following fields are missing in
Documentation/virt/kvm/x86/nested-vmx.rst:

	...
	u64 posted_intr_desc_addr;
	...
	u64 eoi_exit_bitmap0;
	u64 eoi_exit_bitmap1;
	u64 eoi_exit_bitmap2;
	u64 eoi_exit_bitmap3;
	u64 xss_exit_bitmap;
	...

What's more, the 64-bit padding fields are completely messed up; we have
used 9 u64 after host_ia32_efer:

         u64 host_ia32_perf_global_ctrl;
         u64 vmread_bitmap;
         u64 vmwrite_bitmap;
         u64 vm_function_control;
         u64 eptp_list_address;
         u64 pml_address;
         u64 encls_exiting_bitmap;
         u64 tsc_multiplier;
         u64 padding64[1]; /* room for future expansion */


But it's 8 u64 after host_ia32_efer in the documentation:

	u64 padding64[8]; /* room for future expansion */


We probably should remove it from Documentation/virt/kvm/x86/nested-vmx.rst
and instead add a reference to arch/x86/kvm/vmx/vmcs12.h.

