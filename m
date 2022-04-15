Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D96B502E08
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 18:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356001AbiDOQ6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 12:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356113AbiDOQ5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 12:57:51 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19414B1DB;
        Fri, 15 Apr 2022 09:55:22 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id b19so11236616wrh.11;
        Fri, 15 Apr 2022 09:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JYFNJJhlaSGJma0nGgKB6p525eWXOV2d9irP+0gTdD0=;
        b=T1mJ8Q3t/3JJeFPgrXCS8G7tI4soDH/vesw5MG7BGP2Z/Q44A2ixvjzR7o5Xgmcf+j
         YMCxHIzUQKe8Udo6dmHpCRUTo+oncvz3IonMRP8SV1Q+xCKCF1Ozm7WVrKDMaOHXr1+q
         ViTGeDW/5kQFc72oCkdwEx8ETm9hGMVjM7CV5Xcl9GLNTlVkcWQihA5pPiixXGz5brxq
         YBxYcxoNTqtSLMC54mdhN3srUqhFfNkceScG6IKzLGytx+qGi9qU8leyUAaZYRMTRbxp
         5aKRTjSPdwMhfr/QTjm7kp1q0VXBUScp1fJzGzlDSOl0f2Jcar5R77TF3apRuw3uy+Wo
         gD2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JYFNJJhlaSGJma0nGgKB6p525eWXOV2d9irP+0gTdD0=;
        b=jFDma/Xuc7Cn9NxrfOitDX/p4+XDM/WUJgXm9hKHQYs1QgFfJtp2qnJaPf5tKTk/AZ
         XCfhiS0+W9FTEwuBzKr+1Lo30Nrd2svUa8/t4xZEX9+3ufBFw0nVZrbJtFxoPtRIWBZj
         ky3TGdfuep9XqP/bqXPOEAAFAzShBS560A9fHH1BUUQfGHakm2K9noXlxuqpb9+QcXko
         M2eUQJGYdglE+YixTe8tZHZeFS2QEOkTM2G1W6zLFDOm+8VurMr7D4j+tpoWeLGfVrfN
         TEVLZ9vu6foUApTTFbW0vNX86y9k8jGE9qCm0jFiRqEthy1uXqOfccIhS41BVSvU7+2q
         FQzQ==
X-Gm-Message-State: AOAM5324tgQo3O/0a/s5eCcOWGD3eQgkKuIWhcQTkjzUTkFkWUDNGVo/
        QYgzoLsEbtZoqjk8W77EFAE=
X-Google-Smtp-Source: ABdhPJzKjuUUZfDVFz7zyHXx+1fL/j8q6qzmR+Gp3oYnsKOIv4gmpFhEbWc4v97vuDnvauyyFfdGYw==
X-Received: by 2002:a5d:5248:0:b0:207:a421:1a26 with SMTP id k8-20020a5d5248000000b00207a4211a26mr70411wrc.271.1650041720688;
        Fri, 15 Apr 2022 09:55:20 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id w5-20020a7bc105000000b0038eb9932dacsm5230980wmi.48.2022.04.15.09.55.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 09:55:20 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <53ddaaed-3d98-2153-3d28-c865ad695253@redhat.com>
Date:   Fri, 15 Apr 2022 18:55:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 019/104] KVM: TDX: Stub in tdx.h with structs,
 accessors, and VMCS helpers
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <a65fbef6b002d030e43452010457f922dd33d468.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <a65fbef6b002d030e43452010457f922dd33d468.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Stub in kvm_tdx, vcpu_tdx, and their various accessors.  TDX defines
> SEAMCALL APIs to access TDX control structures corresponding to the VMX
> VMCS.  Introduce helper accessors to hide its SEAMCALL ABI details.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.h | 101 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 101 insertions(+)

When rebasing against tip/x86/tdx,  the new .h file needs to include 
asm/tdx.h.

Paolo

> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 616fbf79b129..e4bb8831764e 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -3,14 +3,29 @@
>   #define __KVM_X86_TDX_H
>   
>   #ifdef CONFIG_INTEL_TDX_HOST
> +
> +#include "tdx_ops.h"
> +
>   int tdx_module_setup(void);
>   
> +struct tdx_td_page {
> +	unsigned long va;
> +	hpa_t pa;
> +	bool added;
> +};
> +
>   struct kvm_tdx {
>   	struct kvm kvm;
> +
> +	struct tdx_td_page tdr;
> +	struct tdx_td_page *tdcs;
>   };
>   
>   struct vcpu_tdx {
>   	struct kvm_vcpu	vcpu;
> +
> +	struct tdx_td_page tdvpr;
> +	struct tdx_td_page *tdvpx;
>   };
>   
>   static inline bool is_td(struct kvm *kvm)
> @@ -32,6 +47,92 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
>   {
>   	return container_of(vcpu, struct vcpu_tdx, vcpu);
>   }
> +
> +static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
> +{
> +	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && (field) & 0x1,
> +			 "Read/Write to TD VMCS *_HIGH fields not supported");
> +
> +	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);
> +
> +	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
> +			 (((field) & 0x6000) == 0x2000 ||
> +			  ((field) & 0x6000) == 0x6000),
> +			 "Invalid TD VMCS access for 64-bit field");
> +	BUILD_BUG_ON_MSG(bits != 32 && __builtin_constant_p(field) &&
> +			 ((field) & 0x6000) == 0x4000,
> +			 "Invalid TD VMCS access for 32-bit field");
> +	BUILD_BUG_ON_MSG(bits != 16 && __builtin_constant_p(field) &&
> +			 ((field) & 0x6000) == 0x0000,
> +			 "Invalid TD VMCS access for 16-bit field");
> +}
> +
> +static __always_inline void tdvps_state_non_arch_check(u64 field, u8 bits) {}
> +static __always_inline void tdvps_management_check(u64 field, u8 bits) {}
> +
> +#define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
> +static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
> +							u32 field)		\
> +{										\
> +	struct tdx_module_output out;						\
> +	u64 err;								\
> +										\
> +	tdvps_##lclass##_check(field, bits);					\
> +	err = tdh_vp_rd(tdx->tdvpr.pa, TDVPS_##uclass(field), &out);		\
> +	if (unlikely(err)) {							\
> +		pr_err("TDH_VP_RD["#uclass".0x%x] failed: 0x%llx\n",		\
> +		       field, err);						\
> +		return 0;							\
> +	}									\
> +	return (u##bits)out.r8;							\
> +}										\
> +static __always_inline void td_##lclass##_write##bits(struct vcpu_tdx *tdx,	\
> +						      u32 field, u##bits val)	\
> +{										\
> +	struct tdx_module_output out;						\
> +	u64 err;								\
> +										\
> +	tdvps_##lclass##_check(field, bits);					\
> +	err = tdh_vp_wr(tdx->tdvpr.pa, TDVPS_##uclass(field), val,		\
> +		      GENMASK_ULL(bits - 1, 0), &out);				\
> +	if (unlikely(err))							\
> +		pr_err("TDH_VP_WR["#uclass".0x%x] = 0x%llx failed: 0x%llx\n",	\
> +		       field, (u64)val, err);					\
> +}										\
> +static __always_inline void td_##lclass##_setbit##bits(struct vcpu_tdx *tdx,	\
> +						       u32 field, u64 bit)	\
> +{										\
> +	struct tdx_module_output out;						\
> +	u64 err;								\
> +										\
> +	tdvps_##lclass##_check(field, bits);					\
> +	err = tdh_vp_wr(tdx->tdvpr.pa, TDVPS_##uclass(field), bit, bit,		\
> +			&out);							\
> +	if (unlikely(err))							\
> +		pr_err("TDH_VP_WR["#uclass".0x%x] |= 0x%llx failed: 0x%llx\n",	\
> +		       field, bit, err);					\
> +}										\
> +static __always_inline void td_##lclass##_clearbit##bits(struct vcpu_tdx *tdx,	\
> +							 u32 field, u64 bit)	\
> +{										\
> +	struct tdx_module_output out;						\
> +	u64 err;								\
> +										\
> +	tdvps_##lclass##_check(field, bits);					\
> +	err = tdh_vp_wr(tdx->tdvpr.pa, TDVPS_##uclass(field), 0, bit,		\
> +			&out);							\
> +	if (unlikely(err))							\
> +		pr_err("TDH_VP_WR["#uclass".0x%x] &= ~0x%llx failed: 0x%llx\n",	\
> +		       field, bit,  err);					\
> +}
> +
> +TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
> +TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
> +TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
> +
> +TDX_BUILD_TDVPS_ACCESSORS(64, STATE_NON_ARCH, state_non_arch);
> +TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
> +
>   #else
>   static inline int tdx_module_setup(void) { return -ENODEV; };
>   

