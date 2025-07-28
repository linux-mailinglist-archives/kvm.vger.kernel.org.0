Return-Path: <kvm+bounces-53585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8996CB14481
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 00:54:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F59A7A239B
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 22:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD07A233735;
	Mon, 28 Jul 2025 22:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="chefU6wp"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CDC2E3708;
	Mon, 28 Jul 2025 22:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753743229; cv=none; b=Pq6t5gINkdIAV3dLbavu+xNdx38r1P9DOn0jcngisF0sStWFrIpQeZm0+B9gqt+ufdr2AmpvBpvMkNGiezQEL68gxG72Vzgi1VUD3LB05/fwbJsj7Cmsp/K8iqzeEPW0dnwFARgwn5+z8rQA/YhvdSF/Vlh4qYOKY4J43+m69hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753743229; c=relaxed/simple;
	bh=eX1UGc2px7NNJRV+K844aeoOGavd5NMfTfT1ElqBmSI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OaJOjz8HZo1CaSdC4waXtA42UQWormf06FI2T56zaFeMlJynuBD9+G/kplQiMPQyiydD9rIsSpuAUsYUoDqFdwrBp76ZTrkzqmEro1WMAeIWNsUE+0M+JD+DOudZ95WRdF3jfEKxBcgNAKwMpWJl7H4U7yNwGUEKsrNnwWBvRoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=chefU6wp; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56SMrFo4504906
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 28 Jul 2025 15:53:15 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56SMrFo4504906
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753743197;
	bh=DLZscN1JLmc9m0yOJsmL9MRhp++5xLyFwWfLkGSOTlw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=chefU6wpD5w13i9V1zz18YEIIAtX6p7IB3eC+ekRoslZQN2ONwhdAeEvYPbRi3P4L
	 YKHM3gWik675D606SqIjnx0U/u5NXIXJUrapLJ4Ka+VVILsOOdLf5UoskqbzTw8uBu
	 qw4s1lpTLLP/+YV4e30BXr58XCXy4+iOYmUChSN19+l+PBEVpdWzt9BfyDWlw20ZPI
	 VbrM7eC6D2FT+IrpThfvmx42IOZkVl5JNcr2JtPXvOcFwWgj6XxeNON8bjHxYzqtmf
	 nkDgU+ZOqu6Vsg9fewPRsBWaKxgyoB6+0MulZwA0B4ljyKceopBqVZb41aqq1KeHqy
	 y9qBqQRpaZxsg==
Message-ID: <b63275a2-8d7e-4e45-ae4b-f69e90644fe5@zytor.com>
Date: Mon, 28 Jul 2025 15:53:14 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 12/23] KVM: VMX: Introduce CET VMCS fields and control
 bits
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        pbonzini@redhat.com, dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com, mlevitsk@redhat.com, john.allen@amd.com,
        weijiang.yang@intel.com, minipli@grsecurity.net,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>,
        Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
 <20250704085027.182163-13-chao.gao@intel.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250704085027.182163-13-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/4/2025 1:49 AM, Chao Gao wrote:
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index cca7d6641287..ce10a7e2d3d9 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -106,6 +106,7 @@
>   #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
>   #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
>   #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
> +#define VM_EXIT_LOAD_CET_STATE                  0x10000000
>   
>   #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
>   
> @@ -119,6 +120,7 @@
>   #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
>   #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
>   #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
> +#define VM_ENTRY_LOAD_CET_STATE                 0x00100000
>   
>   #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
>   
> @@ -369,6 +371,9 @@ enum vmcs_field {
>   	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
>   	GUEST_SYSENTER_ESP              = 0x00006824,
>   	GUEST_SYSENTER_EIP              = 0x00006826,
> +	GUEST_S_CET                     = 0x00006828,
> +	GUEST_SSP                       = 0x0000682a,
> +	GUEST_INTR_SSP_TABLE            = 0x0000682c,
>   	HOST_CR0                        = 0x00006c00,
>   	HOST_CR3                        = 0x00006c02,
>   	HOST_CR4                        = 0x00006c04,
> @@ -381,6 +386,9 @@ enum vmcs_field {
>   	HOST_IA32_SYSENTER_EIP          = 0x00006c12,
>   	HOST_RSP                        = 0x00006c14,
>   	HOST_RIP                        = 0x00006c16,
> +	HOST_S_CET                      = 0x00006c18,
> +	HOST_SSP                        = 0x00006c1a,
> +	HOST_INTR_SSP_TABLE             = 0x00006c1c
>   };
>   
>   /*

A comment not on this patch itself.

Both spaces and tabs are currently used to align columns in 
arch/x86/include/asm/vmx.h.  Can we standardize on one, either spaces or 
tabs?

Thanks!
     Xin

