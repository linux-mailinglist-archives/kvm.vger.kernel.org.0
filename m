Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE72C617382
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 01:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiKCA5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 20:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKCA5p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 20:57:45 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B27160ED;
        Wed,  2 Nov 2022 17:57:44 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so369144pjl.3;
        Wed, 02 Nov 2022 17:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PT5TJtiFLVcBhEGCiUt+Q/ygadniH1MGveMuwPrnffg=;
        b=J3OYl1d4sC6FIMH2MusbIHhGhA92hoVKy4RWPDebrUJ8R+/KpO3RCafo7oJVZKD3WJ
         dfTFNKp4BO4rRgLvU4I4Sh4YdomKx5J6exiLf9AkKnYLEaQqvmfZcDX4B8TcyrRqQRbA
         2TBmon+Wv0CRqjDz81TrGslPdyqP6S5/L132a+1g3ZtQQJuBiBAaWZer63+1t7NPuT4l
         +wS3IkJU1Dxls24vCXuHMtrtCA9fxr+NThRP/dXNQIZVQXSvfhXHnyFD0MkFtY2t/ZEs
         v2EWaRv0W4VpNeIwuvJqWf6mCdTwteuKFmvytnvV8BANSi/NDu8VsNJHb38BDuxr9+hf
         6DcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PT5TJtiFLVcBhEGCiUt+Q/ygadniH1MGveMuwPrnffg=;
        b=YnNEtPAAdBNDuis6xNcJsAylVPaiDxm5ZZA9qfCqgfJroSUpMRGf9/7+ilahNSedZh
         wO2fn0MLrJk/aPItON/tNvEKcaH1hbIpDN4IS2NQXv9wovIemKOsNXSRemeXkgv7A3Zn
         TLt0vi4Oyq6I14qqzND8u/O00nIrlvrjoEk1OrVLFUIlRXTA1mpzqdbl3EP8QwqcDi90
         ZeizZFfX+jmbhS32IP1r46edm1o3FowXScwHtx0VsEarzp8eX2CRxQ93aR/lAknyo/WP
         MuSjCSZFvcFDGhabPw/iwUPFeZWcdoE5EivCnAfKCfTg/llk3D/M6hLxs3QsaDrrWbGG
         q1Nw==
X-Gm-Message-State: ACrzQf1x/s7jDA4PRsogr5CW1AndwLl8CfF4gROMgc3GGFPVSU9C96fk
        DS7VvazS6Al63ff9pxdUv3E=
X-Google-Smtp-Source: AMsMyM6h2qWOjTifvTpDULGNAYbAYiHoJBiaBuSE3bePjVu3sWkMEH0VZKlkWzqvbt5KcLkl6Q0dfQ==
X-Received: by 2002:a17:902:da8e:b0:186:9869:adfa with SMTP id j14-20020a170902da8e00b001869869adfamr28175360plx.57.1667437063851;
        Wed, 02 Nov 2022 17:57:43 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id a7-20020a62d407000000b0056bad6ff1b8sm8992574pfh.101.2022.11.02.17.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 17:57:43 -0700 (PDT)
Date:   Wed, 2 Nov 2022 17:57:42 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v10 014/108] KVM: TDX: Stub in tdx.h with structs,
 accessors, and VMCS helpers
Message-ID: <20221103005742.GB954260@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <75ac959fddbfd057d3ae8ad73e91708a2da60965.1667110240.git.isaku.yamahata@intel.com>
 <e1cb3dd0-796b-73d5-ddb8-38e807c061df@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e1cb3dd0-796b-73d5-ddb8-38e807c061df@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022 at 07:39:46PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> On 2022/10/30 14:22, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Stub in kvm_tdx, vcpu_tdx, and their various accessors.  TDX defines
> > SEAMCALL APIs to access TDX control structures corresponding to the VMX
> > VMCS.  Introduce helper accessors to hide its SEAMCALL ABI details.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/kvm/vmx/tdx.h | 118 ++++++++++++++++++++++++++++++++++++++++-
> >   1 file changed, 116 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> > index 473013265bd8..98999bf3f188 100644
> > --- a/arch/x86/kvm/vmx/tdx.h
> > +++ b/arch/x86/kvm/vmx/tdx.h
> > @@ -3,14 +3,27 @@
> >   #define __KVM_X86_TDX_H
> >   #ifdef CONFIG_INTEL_TDX_HOST
> > +
> > +#include "tdx_ops.h"
> > +
> > +struct tdx_td_page {
> > +	unsigned long va;
> > +	hpa_t pa;
> > +	bool added;
> > +};
> > +
> >   struct kvm_tdx {
> >   	struct kvm kvm;
> > -	/* TDX specific members follow. */
> > +
> > +	struct tdx_td_page tdr;
> > +	struct tdx_td_page *tdcs;
> >   };
> >   struct vcpu_tdx {
> >   	struct kvm_vcpu	vcpu;
> > -	/* TDX specific members follow. */
> > +
> > +	struct tdx_td_page tdvpr;
> > +	struct tdx_td_page *tdvpx;
> >   };
> >   static inline bool is_td(struct kvm *kvm)
> > @@ -32,6 +45,107 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
> >   {
> >   	return container_of(vcpu, struct vcpu_tdx, vcpu);
> >   }
> > +
> > +static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
> > +{
> > +#define VMCS_ENC_ACCESS_TYPE_MASK	0x1UL
> > +#define VMCS_ENC_ACCESS_TYPE_FULL	0x0UL
> > +#define VMCS_ENC_ACCESS_TYPE_HIGH	0x1UL
> > +#define VMCS_ENC_ACCESS_TYPE(field)	((field) & VMCS_ENC_ACCESS_TYPE_MASK)
> > +
> > +	/* TDX is 64bit only.  HIGH field isn't supported. */
> > +	BUILD_BUG_ON_MSG(__builtin_constant_p(field) &&
> > +			 VMCS_ENC_ACCESS_TYPE(field) == VMCS_ENC_ACCESS_TYPE_HIGH,
> > +			 "Read/Write to TD VMCS *_HIGH fields not supported");
> > +
> > +	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);
> > +
> > +#define VMCS_ENC_WIDTH_MASK	GENMASK(14, 13)
> > +#define VMCS_ENC_WIDTH_16BIT	(0UL << 13)
> > +#define VMCS_ENC_WIDTH_64BIT	(1UL << 13)
> > +#define VMCS_ENC_WIDTH_32BIT	(2UL << 13)
> > +#define VMCS_ENC_WIDTH_NATURAL	(3UL << 13)
> > +#define VMCS_ENC_WIDTH(field)	((field) & VMCS_ENC_WIDTH_MASK)
> > +
> > +	/* TDX is 64bit only.  i.e. natural width = 64bit. */
> > +	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
> > +			 (VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_64BIT ||
> > +			  VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_NATURAL),
> > +			 "Invalid TD VMCS access for 64-bit field");
> > +	BUILD_BUG_ON_MSG(bits != 32 && __builtin_constant_p(field) &&
> > +			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_32BIT,
> > +			 "Invalid TD VMCS access for 32-bit field");
> > +	BUILD_BUG_ON_MSG(bits != 16 && __builtin_constant_p(field) &&
> > +			 VMCS_ENC_WIDTH(field) == VMCS_ENC_WIDTH_16BIT,
> > +			 "Invalid TD VMCS access for 16-bit field");
> > +}
> > +
> > +static __always_inline void tdvps_state_non_arch_check(u64 field, u8 bits) {}
> > +static __always_inline void tdvps_management_check(u64 field, u8 bits) {}
> > +
> > +#define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)				\
> > +static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,	\
> > +							u32 field)		\
> > +{										\
> > +	struct tdx_module_output out;						\
> > +	u64 err;								\
> > +										\
> > +	tdvps_##lclass##_check(field, bits);					\
> > +	err = tdh_vp_rd(tdx->tdvpr.pa, TDVPS_##uclass(field), &out);		\
> > +	if (unlikely(err)) {							\
> > +		pr_err("TDH_VP_RD["#uclass".0x%x] failed: 0x%llx\n",		\
> > +		       field, err);						\
> > +		return 0;							\
> > +	}									\
> > +	return (u##bits)out.r8;							\
> > +}										\
> > +static __always_inline void td_##lclass##_write##bits(struct vcpu_tdx *tdx,	\
> > +						      u32 field, u##bits val)	\
> > +{										\
> > +	struct tdx_module_output out;						\
> > +	u64 err;								\
> > +										\
> > +	tdvps_##lclass##_check(field, bits);					\
> > +	err = tdh_vp_wr(tdx->tdvpr.pa, TDVPS_##uclass(field), val,		\
> > +		      GENMASK_ULL(bits - 1, 0), &out);				\
> > +	if (unlikely(err))							\
> > +		pr_err("TDH_VP_WR["#uclass".0x%x] = 0x%llx failed: 0x%llx\n",	\
> > +		       field, (u64)val, err);					\
> > +}										\
> > +static __always_inline void td_##lclass##_setbit##bits(struct vcpu_tdx *tdx,	\
> > +						       u32 field, u64 bit)	\
> > +{										\
> > +	struct tdx_module_output out;						\
> > +	u64 err;								\
> > +										\
> > +	tdvps_##lclass##_check(field, bits);					\
> > +	err = tdh_vp_wr(tdx->tdvpr.pa, TDVPS_##uclass(field), bit, bit,		\
> > +			&out);							\
> > +	if (unlikely(err))							\
> > +		pr_err("TDH_VP_WR["#uclass".0x%x] |= 0x%llx failed: 0x%llx\n",	\
> > +		       field, bit, err);					\
> > +}										\
> > +static __always_inline void td_##lclass##_clearbit##bits(struct vcpu_tdx *tdx,	\
> > +							 u32 field, u64 bit)	\
> > +{										\
> > +	struct tdx_module_output out;						\
> > +	u64 err;								\
> > +										\
> > +	tdvps_##lclass##_check(field, bits);					\
> > +	err = tdh_vp_wr(tdx->tdvpr.pa, TDVPS_##uclass(field), 0, bit,		\
> > +			&out);							\
> > +	if (unlikely(err))							\
> > +		pr_err("TDH_VP_WR["#uclass".0x%x] &= ~0x%llx failed: 0x%llx\n",	\
> > +		       field, bit,  err);					\
> > +}
> 
> For the set of accessors, although there will be kernel errer message when
> tdh_vp_{rd,wr} fails,
> the caller doesn't know these function calls succeed or not. Won't this
> cause any unexpected
> behavior?

Oh right.  Basically tdh_vp_{rd, wr} should fail as long as parameters are correct.
So I'll add KVM_BUG_ON().  TDX module takes shared lock on TDVPR, TDR and TDCS.
It should fails with TDX_OPERAND_BUSY on run time. (At least with TDX module 1.0)

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
