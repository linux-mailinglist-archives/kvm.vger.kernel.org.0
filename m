Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E9D6CFEE2
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 10:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjC3Ipt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 04:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjC3Ipk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 04:45:40 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BE27D91
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 01:45:16 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id x3so73459398edb.10
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 01:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680165914;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vlpuagoHdNHyoDKKcfJ1S9LVllL6EOMCzIQgoSyOcDw=;
        b=Tx7bJzrQxgZuGXRYSDpUU6tW0DHmt2iTn6ML51phHbdXfKxP8AaIs4F6Wu0CMU2E8k
         TAyetfg9DZEHcSJF6/mUGYM4lpnqW9Z6jKPTkWhlX+u2FNpgbVSzV1c5UwASf+i/ucID
         qpQd1ptvMyraYyazc1t299COIfXj86PJWnqWTiApvUTNAivQL9jSLNAbcn4+YwCYaSeD
         cPls0ICIaZVH7QNEN3UHPJDrPSkJ++IMf6xeCyroBPSfDQOpCFs+DfwX2EHT2qJhadNH
         N1PrrLkl88YEEu7OCgbPZSXxK/lHmt2qyol14Smh0MFP9mxNWPtW48jJoEasrsNXYXTV
         /21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680165914;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vlpuagoHdNHyoDKKcfJ1S9LVllL6EOMCzIQgoSyOcDw=;
        b=QnGOhaYEHzM/d0T++ubFyTQmBXYzYiCriZeqEzDR2bSd/0kj96DgIG2wsr4T6OmWlH
         rKBo0hUvR17i/apJOA7jm7WSOAFmQgc9AGZXCnMSndQSijXhEEbIgC+oB9isIFhWi/h3
         WWvCYtgcLM3OCrV/gJvYyKNTbwxr3ZIKctDzCBvs6F9IWMD/hL2AjqObaXaonPfI6WOT
         aczf0kVSrqXEY9LSA2TB4zJ9yRDcM7G6jbj+U8ZZYugSFw5NLeaB2NByNkf76MBv95s3
         /H8s6Xxzq/YtG0NA4aUUVBzbCWxOjxVD4NknyOmR9oPJIBeQV/Rumsp8J5Q7Zxj2fGGq
         JG4g==
X-Gm-Message-State: AAQBX9d+OBIUPK+bRTK119cOTNCjlWr2ytVmF6Tb8OpdT2nkEFKBmkjj
        Ar6ZRkm0NKhcE3guQ3I8mt29umj1qKQULI0zmkg=
X-Google-Smtp-Source: AKy350bMXqRfsSuPyYXNvM8oNnrCj7oeuGoy0aRHd5nvAQf2BmF+qkwqfSM4zYWn2ggMUBDiceiR2Q==
X-Received: by 2002:a17:907:6d0b:b0:930:9cec:2fb9 with SMTP id sa11-20020a1709076d0b00b009309cec2fb9mr25165267ejc.77.1680165913889;
        Thu, 30 Mar 2023 01:45:13 -0700 (PDT)
Received: from ?IPV6:2003:f6:af13:8b00:c684:f698:a009:dbf2? (p200300f6af138b00c684f698a009dbf2.dip0.t-ipconnect.de. [2003:f6:af13:8b00:c684:f698:a009:dbf2])
        by smtp.gmail.com with ESMTPSA id qh7-20020a170906eca700b0092bea699124sm17411276ejb.106.2023.03.30.01.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 01:45:13 -0700 (PDT)
Message-ID: <677169b4-051f-fcae-756b-9a3e1bb9f8fe@grsecurity.net>
Date:   Thu, 30 Mar 2023 10:45:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v4 6/6] KVM: VMX: Make CR0.WP a guest owned bit
Content-Language: en-US, de-DE
To:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <20230322013731.102955-7-minipli@grsecurity.net>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <20230322013731.102955-7-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22.03.23 02:37, Mathias Krause wrote:
> Guests like grsecurity that make heavy use of CR0.WP to implement kernel
> level W^X will suffer from the implied VMEXITs.
> 
> With EPT there is no need to intercept a guest change of CR0.WP, so
> simply make it a guest owned bit if we can do so.
> 
> This implies that a read of a guest's CR0.WP bit might need a VMREAD.
> However, the only potentially affected user seems to be kvm_init_mmu()
> which is a heavy operation to begin with. But also most callers already
> cache the full value of CR0 anyway, so no additional VMREAD is needed.
> The only exception is nested_vmx_load_cr3().
> 
> This change is VMX-specific, as SVM has no such fine grained control
> register intercept control.

Just a heads up! We did more tests, especially with the backports we did
internally already, and ran into a bug when running a nested guest on an
ESXi host.

Setup is like: ESXi (L0) -> Linux (L1) -> Linux (L2)

The Linux system, especially the kernel, is the same for L1 and L2. It's
a grsecurity kernel, so makes use of toggling CR0.WP at runtime.

The bug we see is that when L2 disables CR0.WP and tries to write to an
r/o memory region (implicitly to the r/o GDT via LTR in our use case),
this triggers a fault (EPT violation?) that gets ignored by L1, as,
apparently, everything is fine from its point of view.

I suspect the L0 VMM to be at fault here, as the VMCS structures look
good, IMO. Here is a dump of vmx->loaded_vmcs in handle_triple_fault():

[…] VMX: TRIPLE FAULT!
[…] VMCS ffff8883a9f18000, last attempted VM-entry on CPU 8
[…] *** Guest State ***
[…] CR0: actual=0x0000000080040033, shadow=0x0000000080050033,
gh_mask=fffffffffffefff7

CR0 in the L2 VM has CR0.WP disabled. However, it is set in the shadow
CR0 but masked out via CR0_MASK, so should be read as the guest's value,
according to the SDM.

I also tried masking the shadow CR0 value in vmx_set_cr0(), but that
makes no difference.

[…] CR4: actual=0x00000000003220f0, shadow=0x00000000003208b0,
gh_mask=fffffffffffff871
[…] CR3 = 0x0000000002684000
[…] PDPTR0 = 0x0000000007d39001  PDPTR1 = 0x00000000033b5001
[…] PDPTR2 = 0x000000000238c001  PDPTR3 = 0x0000000001c54001
[…] RSP = 0xfffffe8040087f50  RIP = 0xffffffff8105d435
[…] RFLAGS=0x00010006         DR7 = 0x0000000000000400
[…] Sysenter RSP=0000000000000000 CS:RIP=0000:0000000000000000
[…] CS:   sel=0x0010, attr=0x0a09b, limit=0xffffffff,
base=0x0000000000000000
[…] DS:   sel=0x0000, attr=0x1c001, limit=0xffffffff,
base=0x0000000000000000
[…] SS:   sel=0x0000, attr=0x1c001, limit=0xffffffff,
base=0x0000000000000000
[…] ES:   sel=0x0000, attr=0x1c001, limit=0xffffffff,
base=0x0000000000000000
[…] FS:   sel=0x0000, attr=0x1c001, limit=0xffffffff,
base=0x0000000000000000
[…] GS:   sel=0x0000, attr=0x1c001, limit=0xffffffff,
base=0xffff888232e00000
[…] GDTR:                           limit=0x00000097,
base=0xfffffe0000201000
[…] LDTR: sel=0x0000, attr=0x00082, limit=0x0000ffff,
base=0x0000000000000000
[…] IDTR:                           limit=0x000001ff,
base=0xffffffff84004000
[…] TR:   sel=0x0000, attr=0x0008b, limit=0x0000ffff,
base=0x0000000000000000
[…] EFER= 0x0000000000000d01 (effective)
[…] PAT = 0x0007040600070406
[…] DebugCtl = 0x0000000000000000  DebugExceptions = 0x0000000000000000
[…] Interruptibility = 00000000  ActivityState = 00000000
[…] *** Host State ***
[…] RIP = 0xffffffff86d28db6  RSP = 0xfffffe8040927d50
[…] CS=0010 SS=0018 DS=0000 ES=0000 FS=0000 GS=0000 TR=0040
[…] FSBase=0000639563fce700 GSBase=ffff88881a800000 TRBase=fffffe0001003000
[…] GDTBase=fffffe0001001000 IDTBase=fffffe0000000000
[…] CR0=0000000080050033 CR3=00000000026a0004 CR4=00000000007626f0

The "host" (which is our L1 VMM, I guess) has CR0.WP enabled and that is
what I think confuses ESXi to enforce the read-only property to the L2
guest as well -- for unknown reasons so far.

[…] Sysenter RSP=fffffe0001003000 CS:RIP=0010:ffffffff810031a0
[…] PAT = 0x0407050600070106
[…] *** Control State ***
[…] PinBased=0000003f CPUBased=b5a06dfa SecondaryExec=001034ee
[…] EntryControls=000053ff ExitControls=000befff
[…] ExceptionBitmap=00060042 PFECmask=00000000 PFECmatch=00000000
[…] VMEntry: intr_info=00000000 errcode=00000003 ilen=00000000
[…] VMExit: intr_info=00000000 errcode=00000000 ilen=00000000
[…]         reason=00000002 qualification=0000000000000000
[…] IDTVectoring: info=00000000 errcode=00000000
[…] TSC Offset = 0xffffad7a1057f4cc
[…] TPR Threshold = 0x00
[…] virt-APIC addr = 0x000000015716b000
[…] EPT pointer = 0x0000000583c1e05e
[…] PLE Gap=00000080 Window=00001000
[…] Virtual processor ID = 0x0002

I tried to reproduce the bug with different KVM based L0 VMMs (with and
without this series; vanilla and grsecurity kernels) but no luck. That's
why I'm suspecting a ESXi bug.

I'm leaning to make CR0.WP guest owned only iff we're running on bare
metal or the VMM is KVM to not play whack-a-mole for all the VMMs that
might have similar bugs. (Will try to test a few others here as well.)
However, that would prevent them from getting the performance gain, so
I'd rather have this fixed / worked around in KVM instead.

Any ideas how to investigate this further?

Thanks,
Mathias

PS: ...should have left the chicken bit of v3 to be able to disable the
feature by a module parameter ;)

> 
> Suggested-and-co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  arch/x86/kvm/kvm_cache_regs.h |  2 +-
>  arch/x86/kvm/vmx/nested.c     |  4 ++--
>  arch/x86/kvm/vmx/vmx.c        |  2 +-
>  arch/x86/kvm/vmx/vmx.h        | 18 ++++++++++++++++++
>  4 files changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 4c91f626c058..e50d353b5c1c 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -4,7 +4,7 @@
>  
>  #include <linux/kvm_host.h>
>  
> -#define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
> +#define KVM_POSSIBLE_CR0_GUEST_BITS	(X86_CR0_TS | X86_CR0_WP)
>  #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
>  	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
>  	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f63b28f46a71..61d940fc91ba 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4481,7 +4481,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
>  	 * CR0_GUEST_HOST_MASK is already set in the original vmcs01
>  	 * (KVM doesn't change it);
>  	 */
> -	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
> +	vcpu->arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
>  	vmx_set_cr0(vcpu, vmcs12->host_cr0);
>  
>  	/* Same as above - no reason to call set_cr4_guest_host_mask().  */
> @@ -4632,7 +4632,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
>  	 */
>  	vmx_set_efer(vcpu, nested_vmx_get_vmcs01_guest_efer(vmx));
>  
> -	vcpu->arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
> +	vcpu->arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
>  	vmx_set_cr0(vcpu, vmcs_readl(CR0_READ_SHADOW));
>  
>  	vcpu->arch.cr4_guest_owned_bits = ~vmcs_readl(CR4_GUEST_HOST_MASK);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 8fc1a0c7856f..e501f6864a72 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4790,7 +4790,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>  	/* 22.2.1, 20.8.1 */
>  	vm_entry_controls_set(vmx, vmx_vmentry_ctrl());
>  
> -	vmx->vcpu.arch.cr0_guest_owned_bits = KVM_POSSIBLE_CR0_GUEST_BITS;
> +	vmx->vcpu.arch.cr0_guest_owned_bits = vmx_l1_guest_owned_cr0_bits();
>  	vmcs_writel(CR0_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr0_guest_owned_bits);
>  
>  	set_cr4_guest_host_mask(vmx);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 2acdc54bc34b..423e9d3c9c40 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -640,6 +640,24 @@ BUILD_CONTROLS_SHADOW(tertiary_exec, TERTIARY_VM_EXEC_CONTROL, 64)
>  				(1 << VCPU_EXREG_EXIT_INFO_1) | \
>  				(1 << VCPU_EXREG_EXIT_INFO_2))
>  
> +static inline unsigned long vmx_l1_guest_owned_cr0_bits(void)
> +{
> +	unsigned long bits = KVM_POSSIBLE_CR0_GUEST_BITS;
> +
> +	/*
> +	 * CR0.WP needs to be intercepted when KVM is shadowing legacy paging
> +	 * in order to construct shadow PTEs with the correct protections.
> +	 * Note!  CR0.WP technically can be passed through to the guest if
> +	 * paging is disabled, but checking CR0.PG would generate a cyclical
> +	 * dependency of sorts due to forcing the caller to ensure CR0 holds
> +	 * the correct value prior to determining which CR0 bits can be owned
> +	 * by L1.  Keep it simple and limit the optimization to EPT.
> +	 */
> +	if (!enable_ept)
> +		bits &= ~X86_CR0_WP;
> +	return bits;
> +}
> +
>  static __always_inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
>  {
>  	return container_of(kvm, struct kvm_vmx, kvm);
