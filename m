Return-Path: <kvm+bounces-43878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE8D8A9822B
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 10:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B701618963AD
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 08:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7E42276027;
	Wed, 23 Apr 2025 07:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="aE3LBD+s"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C884276024;
	Wed, 23 Apr 2025 07:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745395005; cv=none; b=PUE6goAafDs4OqSLroAX9/q+Eaqoxvc/HVO1q0QvwWGcPYfTpHPeq0vALR6Y61kX/6RYdCEH1hkRIuItfW2/8MmEJERIwoHywPxjyKHKlEAGQ6V4Uji3txLDzQec5gw9xhOys0AyFeStHW1Bfkm70JdypOAcN8c6UKVnwO90Hs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745395005; c=relaxed/simple;
	bh=3ROjFLRtDQpKqU5sUZYxIcu+y5AbhHrnpWcsJ/Zgjas=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jGm6Qc66pNb5Tvy4qVvw/HS8LbEXv8JYv7bWbYpinPZEuiC0xAd5qbkhkCLlGauhh9Er8cxi0z4jx1kMAMrakVDopsogfm7XnL/sflyTnzWYkHW7bpZ4kHe30JpNAjfMqnra8crtAv0DD9K6djUU59jcKWDXTdpWyQFuxokxIP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=aE3LBD+s; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53N7uBoV3119852
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 23 Apr 2025 00:56:12 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53N7uBoV3119852
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745394975;
	bh=LV4/6zX3QPMww5e/UsTXLMcNjFZYEA1V4I6Dl3psGlk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aE3LBD+sbGzJoCaP0U4TSgem2sj9X5F2EUjTr9I41Yn00qAtH+J43Qh1li+dchB7q
	 +1Gj8OUZdCMIx6ynsU/QF45WHYqmrbHvAlr+QYSM+zEio3U+MvSQf4AXJtQZyF/3li
	 ExwCskjw2SfD+458eyhstGvCJSlwO9val7w3JhzR2n0qqPM9Luc8RomhbFnXjsrTYJ
	 J8urbqSA1MNRKs+D3yko6hS6jjvd//z1nBk63OOw0B34E94M2nqGeMOIbdXUMiHbUo
	 jyfr7leDcp8LIG3Lr0t1IeA8uRBK2qVubqVoGiv5YeQINNCwu29B7dJxXvRgOLG9Q7
	 wZbbF8Pn/L0nw==
Message-ID: <a803c925-b682-490f-8cd9-ca8d4cc599aa@zytor.com>
Date: Wed, 23 Apr 2025 00:56:10 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] KVM: x86: Add support for legacy VMware backdoors
 in nested setups
To: Zack Rusin <zack.rusin@broadcom.com>, linux-kernel@vger.kernel.org
Cc: Doug Covelli <doug.covelli@broadcom.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20250422161304.579394-1-zack.rusin@broadcom.com>
 <20250422161304.579394-5-zack.rusin@broadcom.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <20250422161304.579394-5-zack.rusin@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/22/2025 9:12 AM, Zack Rusin wrote:
> Allow handling VMware backdoors by the L0 monitor. This is required on
> setups running Windows VBS, where the L1 will be running Hyper-V which
> can't handle VMware backdoors. Thus on Windows VBS legacy VMware backdoor
> calls issued by the userspace will end up in Hyper-V (L1) and endup
> throwing an error.
> Add a KVM cap that, in nested setups, allows the legacy VMware backdoor
> to be handled by the L0 monitor. Thanks to this we can make sure that
> VMware backdoor is always handled by the correct monitor.
> 
> Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
> Cc: Doug Covelli <doug.covelli@broadcom.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: x86@kernel.org
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Zack Rusin <zack.rusin@broadcom.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   Documentation/virt/kvm/api.rst  | 14 +++++++++++
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/Kconfig            |  1 +
>   arch/x86/kvm/kvm_vmware.h       | 42 +++++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/nested.c       |  6 +++++
>   arch/x86/kvm/svm/svm.c          |  3 ++-
>   arch/x86/kvm/vmx/nested.c       |  6 +++++
>   arch/x86/kvm/x86.c              |  8 +++++++
>   include/uapi/linux/kvm.h        |  1 +
>   9 files changed, 81 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 6d3d2a509848..55bd464ebf95 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8322,6 +8322,20 @@ userspace handling of hypercalls is discouraged. To implement
>   such functionality, use KVM_EXIT_IO (x86) or KVM_EXIT_MMIO
>   (all except s390).
>   
> +7.39 KVM_CAP_X86_VMWARE_NESTED_BACKDOOR_L0
> +------------------------------------------
> +
> +:Architectures: x86
> +:Parameters: args[0] whether the feature should be enabled or not
> +:Returns: 0 on success.
> +
> +Capability allows VMware backdoors to be handled by L0 when running
> +on nested configurations. This is required when, for example
> +running Windows guest with Hyper-V VBS enabled - in that configuration
> +the VMware backdoor calls issued by VMware tools would endup in Hyper-V
> +(L1) which doesn't handle VMware backdoor. Enable this option to have
> +VMware backdoor sent to L0 monitor.
> +
>   8. Other capabilities.
>   ======================
>   

You're not basing the patch set on v6.15-rcX?

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 300cef9a37e2..5dc57bc57851 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4653,6 +4653,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   #ifdef CONFIG_KVM_VMWARE
>   	case KVM_CAP_X86_VMWARE_BACKDOOR:
>   	case KVM_CAP_X86_VMWARE_HYPERCALL:
> +	case KVM_CAP_X86_VMWARE_NESTED_BACKDOOR_L0:
>   #endif
>   		r = 1;
>   		break;
> @@ -6754,6 +6755,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		kvm->arch.vmware.hypercall_enabled = cap->args[0];
>   		r = 0;
>   		break;
> +	case KVM_CAP_X86_VMWARE_NESTED_BACKDOOR_L0:
> +		r = -EINVAL;
> +		if (cap->args[0] & ~1)

Replace ~1 with a macro for better readability please.

