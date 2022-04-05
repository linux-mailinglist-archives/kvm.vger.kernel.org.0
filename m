Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57C64F4982
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392188AbiDEWSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452283AbiDEPyn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 11:54:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EEE475F24B
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 07:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649170294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iHMO/KPwrjTmMr+NI6kyjYu5g3RKbLBgrzbCvg8NQZc=;
        b=CPttbmCtVTdXX2Y/EqUUC6Bo3aYgGAN2si5+B8qPxKycjmtn3AXbCY0gAvdVxEsKf0tMZ1
        6EeDNb64XWAYWOOMKQl+8lg86O6jQcSVeZMtyegOheG6+oEqRB1qqezeNQt909hjrKp2p7
        gp+/nrVxw8IHDhubAoO/AUvZtRpmddc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-279-dSVACryjMG27UMB3MRK_5g-1; Tue, 05 Apr 2022 10:51:32 -0400
X-MC-Unique: dSVACryjMG27UMB3MRK_5g-1
Received: by mail-wr1-f72.google.com with SMTP id s13-20020adfa28d000000b00205e049cff2so2547520wra.17
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 07:51:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iHMO/KPwrjTmMr+NI6kyjYu5g3RKbLBgrzbCvg8NQZc=;
        b=t/sJ5K6KHr1YFIo0UvksBaVc5Ds9kFhZ96TdjB5WABAkUhHXq3XhEVyhKnz47EV0+j
         ZwG2Ru76AWbfcdu9kHUzF+x/Q4wjAn2joEyjrnmkX2Wu0wRctqcpPOLUK012OVLI5lIg
         BesFrNJ0x+UlEq/RkqRuu5tnRDr24ZD2jPBOCM9cu+NfsFyGOYH02ispdqhF7Or3VZLI
         CVrRXvrxqLy4WcV6eXWyS5NkRSqr+zX2O6gJUWjJ724VAP6eDzDJv3oKMSazRDBoCCjO
         ICZw2bUQJT2cvZEcZytH5Vvr5Rx834UHIhnxkhH52dfeMukwcmMMcRxN4F7T8azq16kj
         YIAA==
X-Gm-Message-State: AOAM531pKRBve3Fxac5Fp2Yuwj5WRnbEmEmlbO8AOcDRvPKe3cdkSu/z
        knqdGrPYjLbGK+37ser3N8l2rWvKhlBbV45uVKYTWGsBZ+WORINKxXUcE3SrSqo7gXj4JXdD6gd
        7GBnqRuiqwgGg
X-Received: by 2002:adf:f451:0:b0:206:15b6:5f32 with SMTP id f17-20020adff451000000b0020615b65f32mr2992583wrp.352.1649170291422;
        Tue, 05 Apr 2022 07:51:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9sxywmqtHj5/gbulH+XfkgmnFEqzsq4WjvFKZn40uGvli67swtCFShCNRGi72vruDvrrXOw==
X-Received: by 2002:adf:f451:0:b0:206:15b6:5f32 with SMTP id f17-20020adff451000000b0020615b65f32mr2992557wrp.352.1649170291185;
        Tue, 05 Apr 2022 07:51:31 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id w12-20020adf8bcc000000b002060e3da33fsm7180380wra.66.2022.04.05.07.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:51:30 -0700 (PDT)
Message-ID: <d02d9e4c-ebcc-ba6b-f788-7952e437ed69@redhat.com>
Date:   Tue, 5 Apr 2022 16:51:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 043/104] KVM: TDX: Add load_mmu_pgd method for TDX
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <cb0b1e9a097ef229a09d2763448362c916633566.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <cb0b1e9a097ef229a09d2763448362c916633566.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> For virtual IO, the guest TD shares guest pages with VMM without
> encryption.  Shared EPT is used to map guest pages in unprotected way.
> 
> Add the VMCS field encoding for the shared EPTP, which will be used by
> TDX to have separate EPT walks for private GPAs (existing EPTP) versus
> shared GPAs (new shared EPTP).
> 
> Set shared EPT pointer value for the TDX guest to initialize TDX MMU.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/vmx.h |  1 +
>   arch/x86/kvm/vmx/main.c    | 11 ++++++++++-
>   arch/x86/kvm/vmx/tdx.c     |  5 +++++
>   arch/x86/kvm/vmx/x86_ops.h |  4 ++++
>   4 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 88d9b8cc7dde..a2402d1bde04 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -221,6 +221,7 @@ enum vmcs_field {
>   	ENCLS_EXITING_BITMAP_HIGH	= 0x0000202F,
>   	TSC_MULTIPLIER                  = 0x00002032,
>   	TSC_MULTIPLIER_HIGH             = 0x00002033,
> +	SHARED_EPT_POINTER		= 0x0000203C,
>   	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
>   	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
>   	VMCS_LINK_POINTER               = 0x00002800,
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index b242a9dc9e29..6969e3557bd4 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -89,6 +89,15 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	return vmx_vcpu_reset(vcpu, init_event);
>   }
>   
> +static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> +			int pgd_level)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
> +
> +	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
> +}
> +
>   static int vt_mem_enc_op(struct kvm *kvm, void __user *argp)
>   {
>   	if (!is_td(kvm))
> @@ -205,7 +214,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.write_tsc_offset = vmx_write_tsc_offset,
>   	.write_tsc_multiplier = vmx_write_tsc_multiplier,
>   
> -	.load_mmu_pgd = vmx_load_mmu_pgd,
> +	.load_mmu_pgd = vt_load_mmu_pgd,
>   
>   	.check_intercept = vmx_check_intercept,
>   	.handle_exit_irqoff = vmx_handle_exit_irqoff,
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index c3434b33c452..51098e10b6a0 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -496,6 +496,11 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	vcpu->kvm->vm_bugged = true;
>   }
>   
> +void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
> +{
> +	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
> +}
> +
>   static int tdx_capabilities(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>   {
>   	struct kvm_tdx_capabilities __user *user_caps;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 81f246493ec7..ad9b1c883761 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -143,6 +143,8 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
>   
>   int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
> +
> +void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
>   #else
>   static inline void tdx_pre_kvm_init(
>   	unsigned int *vcpu_size, unsigned int *vcpu_align, unsigned int *vm_size) {}
> @@ -160,6 +162,8 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
>   
>   static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
> +
> +static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
>   #endif
>   
>   #endif /* __KVM_X86_VMX_X86_OPS_H */

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

