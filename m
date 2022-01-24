Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872AD498173
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 14:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbiAXNwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 08:52:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21787 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234795AbiAXNwp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Jan 2022 08:52:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643032364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tiaow26F+F5ual2KbXEabh3xwK+NZHCtAM5fGyqg6I8=;
        b=Zrq786a+CI4dQS9PN76LJXS7eJB2Z/wD3gQLC1V9wv9+Ke/hOUsVBZYTwNYIr+GFNQLtFB
        A9IDmbu6qeaMkb1KtYfrzx3nqxORGSRkLbePUAp+9vw99Y/kWxhW++JryKnzdqTDw7Xlps
        WTMeAtG7evCpgULXJD2fZWdHbQjtEX0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-G6evFM0GOjGaDLNGFepXXQ-1; Mon, 24 Jan 2022 08:52:43 -0500
X-MC-Unique: G6evFM0GOjGaDLNGFepXXQ-1
Received: by mail-ej1-f69.google.com with SMTP id p8-20020a1709060e8800b006b39ade8c12so2096915ejf.10
        for <kvm@vger.kernel.org>; Mon, 24 Jan 2022 05:52:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Tiaow26F+F5ual2KbXEabh3xwK+NZHCtAM5fGyqg6I8=;
        b=TaUw8xiIwPHpPre+OEyupNx4oBpatiC/QqoKJLFdLea73MV74YiDO7IygZyMZwZi9M
         TouLTlHIR6oRlkkPIMNI1MadlAPmDUsjKtkSZAc9Yu5tMEl8eHlqKnhBSIz7cktrViCj
         bXpDdLH+fZMMGMPT0uJ1lwUxls8FOZCdgRD9j5VyBdPocxGNuxdq2NJQW1HjU2Oc3kzV
         1zZoSpsmKtbGlv7OYSGqrdp9hWTkf959znGRLEOVB5QuY6yi8vZWGZcCiZrI/v4zHaz9
         jWkYtvgJMxbX4KuPNz0Xu+su4VXPC1+8u0/1P/ZqWMoa2CXmnQ0jnl7UYeruRDo7slbJ
         iUIw==
X-Gm-Message-State: AOAM532+lonKMTiSMeupsWVJMazrwO9+37bBvotSBzx4RHP2xVshOGiJ
        XYhvT+/OKrdXCCTtU0DiZigQGzRf6zMEHoI7FU0S0hkdfENqrR5S41mYQwIS26WXx4uxugG7/7M
        +H6pxDgvJQPKt
X-Received: by 2002:a17:907:86a7:: with SMTP id qa39mr4287773ejc.548.1643032361287;
        Mon, 24 Jan 2022 05:52:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyAKoeAZKm9pcZ1Nm/za1q0/l7p2Z/+gJiD7bun/Cf5RfB64by8iQLjFuyTxt1ppKEcH8+LYg==
X-Received: by 2002:a17:907:86a7:: with SMTP id qa39mr4287757ejc.548.1643032360998;
        Mon, 24 Jan 2022 05:52:40 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id a23sm6642796eda.94.2022.01.24.05.52.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 05:52:40 -0800 (PST)
Message-ID: <059e27fa-71a9-2991-2bfd-6df9d0e285b2@redhat.com>
Date:   Mon, 24 Jan 2022 14:52:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: VMX: Zero host's SYSENTER_ESP iff SYSENTER is NOT
 used
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>
References: <20220122015211.1468758-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220122015211.1468758-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/22/22 02:52, Sean Christopherson wrote:
> Zero vmcs.HOST_IA32_SYSENTER_ESP when initializing *constant* host state
> if and only if SYSENTER cannot be used, i.e. the kernel is a 64-bit
> kernel and is not emulating 32-bit syscalls.  As the name suggests,
> vmx_set_constant_host_state() is intended for state that is *constant*.
> When SYSENTER is used, SYSENTER_ESP isn't constant because stacks are
> per-CPU, and the VMCS must be updated whenever the vCPU is migrated to a
> new CPU.  The logic in vmx_vcpu_load_vmcs() doesn't differentiate between
> "never loaded" and "loaded on a different CPU", i.e. setting SYSENTER_ESP
> on VMCS load also handles setting correct host state when the VMCS is
> first loaded.
> 
> Because a VMCS must be loaded before it is initialized during vCPU RESET,
> zeroing the field in vmx_set_constant_host_state() obliterates the value
> that was written when the VMCS was loaded.  If the vCPU is run before it
> is migrated, the subsequent VM-Exit will zero out MSR_IA32_SYSENTER_ESP,
> leading to a #DF on the next 32-bit syscall.
> 
>    double fault: 0000 [#1] SMP
>    CPU: 0 PID: 990 Comm: stable Not tainted 5.16.0+ #97
>    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>    EIP: entry_SYSENTER_32+0x0/0xe7
>    Code: <9c> 50 eb 17 0f 20 d8 a9 00 10 00 00 74 0d 25 ff ef ff ff 0f 22 d8
>    EAX: 000000a2 EBX: a8d1300c ECX: a8d13014 EDX: 00000000
>    ESI: a8f87000 EDI: a8d13014 EBP: a8d12fc0 ESP: 00000000
>    DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00210093
>    CR0: 80050033 CR2: fffffffc CR3: 02c3b000 CR4: 00152e90
> 
> Fixes: 6ab8a4053f71 ("KVM: VMX: Avoid to rdmsrl(MSR_IA32_SYSENTER_ESP)")
> Cc: Lai Jiangshan <laijs@linux.alibaba.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a02a28ce7cc3..ce2aae12fcc5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4094,10 +4094,13 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
>   	vmcs_write32(HOST_IA32_SYSENTER_CS, low32);
>   
>   	/*
> -	 * If 32-bit syscall is enabled, vmx_vcpu_load_vcms rewrites
> -	 * HOST_IA32_SYSENTER_ESP.
> +	 * SYSENTER is used only for (emulating) 32-bit kernels, zero out
> +	 * SYSENTER.ESP if it is NOT used.  When SYSENTER is used, the per-CPU
> +	 * stack is set when the VMCS is loaded (and may already be set!).

Slightly clearer:

	/*
	 * SYSENTER is used for 32-bit system calls on either 32-bit or
	 * 64-bit kernels.  It is always zero if neither is allowed, otherwise
	 * vmx_vcpu_load_vmcs loads it with the per-CPU entry stack (and may
	 * have already done so!).
	 */

>   	 */
> -	vmcs_writel(HOST_IA32_SYSENTER_ESP, 0);
> +	if (!IS_ENABLED(CONFIG_IA32_EMULATION) && !IS_ENABLED(CONFIG_X86_32))
> +		vmcs_writel(HOST_IA32_SYSENTER_ESP, 0);
> +
>   	rdmsrl(MSR_IA32_SYSENTER_EIP, tmpl);
>   	vmcs_writel(HOST_IA32_SYSENTER_EIP, tmpl);   /* 22.2.3 */
>   
> 
> base-commit: e2e83a73d7ce66f62c7830a85619542ef59c90e4

Queued, thanks.

Paolo

