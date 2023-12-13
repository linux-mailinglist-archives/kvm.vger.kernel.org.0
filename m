Return-Path: <kvm+bounces-4353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A80F3811568
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 16:00:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 411AEB21136
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 14:59:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59E612F848;
	Wed, 13 Dec 2023 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="OtVrnzEi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D5BE8
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 06:59:48 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-33638e7f71aso497402f8f.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 06:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1702479586; x=1703084386; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8DBUvhPtbZDawFoEzfTVNDryKtEimlM9O26B02EurUc=;
        b=OtVrnzEi+1+FqmHQ6hXGbGKSlqhU94O5bqiLpzByfRxUL/IqKXmYjC+Fz36sQ+/Iw9
         b1lrOA4lMNLdV+dVq5q/InU+q1FassFNWGKqyw6Y66spj8Kq34lbyoXMuUqQRp8SejgL
         zq5Hxk2xYrQwB+D/O37MAeLo5Whq+mAHBHpzXZv4Ln89h6IBor1ZIJG/97Ib+yuXE4di
         Up5+tOyjs/hRNhq62RNFDQZzVvzD6D/xMbex7/IIsRFWF1evjyZJpsWFdAmNnn+DGKCr
         f6UyVrdpec//nO+AfbMi2VYxwHq9k7CtHQwIyaJo6oXS0zncVP4S1RWsLqtO4x4SdxpP
         mR0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702479586; x=1703084386;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8DBUvhPtbZDawFoEzfTVNDryKtEimlM9O26B02EurUc=;
        b=GzzLrFFosPn8pRQMK5AlibCScs4unrDEXTnpTHwM99QgI6tr1C76RdsDTsPhb6y7G9
         cAzFNhUUESpN2O+PxAkAcFtvioMaTggBB9kCZfV3ZEOGVc2lMc4ui2fDfIerRhJyJnLA
         fKGAMRxYxhXRHF07ZkTcx1s9b2LowCB2jOOCYvilxCVgIMYZRSRgx5Jk2AUXLhkvlBfT
         D9OCLPHaGvCl0bQxykX3YN4+ZLNjGF2gchQz8iF2F1OFDjGfdka+Y4I1IkI0+Y6Ft5I1
         qgpjRvbwOHAW8WpXXJReK5CqQ0W9XyEVz7j1XAmpA0fCD5d5u2y+/ekXGIZHGlLdGLMl
         Oh+Q==
X-Gm-Message-State: AOJu0YzzZ3ot/XguR2lMRBZkGm14KBPunp6fGI5byqzDTvQTIXBMniJs
	R8M6vp2V5i5SpYmu4WlpNeSMMQ==
X-Google-Smtp-Source: AGHT+IGLUXcjN5NhvYEVkfAJzzQF0Pn/hNoBqUffZURU7B7poOc4GgowWX8hQYY9gAB9PB13DPz48g==
X-Received: by 2002:a5d:4529:0:b0:336:42b2:5988 with SMTP id j9-20020a5d4529000000b0033642b25988mr327330wra.27.1702479586515;
        Wed, 13 Dec 2023 06:59:46 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id d12-20020adfa40c000000b003333fa3d043sm13651788wra.12.2023.12.13.06.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 06:59:46 -0800 (PST)
Date: Wed, 13 Dec 2023 15:59:45 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	greentime.hu@sifive.com, vincent.chen@sifive.com, tjytimi@163.com, alex@ghiti.fr, 
	conor.dooley@microchip.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Anup Patel <apatel@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Haibo Xu <haibo1.xu@intel.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] KVM: riscv: selftests: Add Svadu Extension to
 get-reg-list testt
Message-ID: <20231213-3b68f487a41af1e3f3c96cf2@orel>
References: <20231102120129.11261-1-yongxuan.wang@sifive.com>
 <20231102120129.11261-5-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231102120129.11261-5-yongxuan.wang@sifive.com>

On Thu, Nov 02, 2023 at 12:01:25PM +0000, Yong-Xuan Wang wrote:
> Update the get-reg-list test to test the Svadu Extension is available
> for guest OS.
> 
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
>  .../testing/selftests/kvm/riscv/get-reg-list.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/riscv/get-reg-list.c b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> index 9f99ea42f45f..972538d76f48 100644
> --- a/tools/testing/selftests/kvm/riscv/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/riscv/get-reg-list.c
> @@ -49,6 +49,7 @@ bool filter_reg(__u64 reg)
>  	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZICSR:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZIFENCEI:
>  	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_ZIHPM:
> +	case KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_SVADU:
>  		return true;
>  	/* AIA registers are always available when Ssaia can't be disabled */
>  	case KVM_REG_RISCV_CSR | KVM_REG_RISCV_CSR_AIA | KVM_REG_RISCV_CSR_AIA_REG(siselect):
> @@ -340,6 +341,7 @@ static const char *isa_ext_id_to_str(__u64 id)
>  		"KVM_RISCV_ISA_EXT_ZICSR",
>  		"KVM_RISCV_ISA_EXT_ZIFENCEI",
>  		"KVM_RISCV_ISA_EXT_ZIHPM",
> +		"KVM_RISCV_ISA_EXT_SVADU",
>  	};
>  
>  	if (reg_off >= ARRAY_SIZE(kvm_isa_ext_reg_name)) {
> @@ -700,6 +702,10 @@ static __u64 fp_d_regs[] = {
>  	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_D,
>  };
>  
> +static __u64 svadu_regs[] = {
> +	KVM_REG_RISCV | KVM_REG_SIZE_ULONG | KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_SVADU,
> +};
> +
>  #define BASE_SUBLIST \
>  	{"base", .regs = base_regs, .regs_n = ARRAY_SIZE(base_regs), \
>  	 .skips_set = base_skips_set, .skips_set_n = ARRAY_SIZE(base_skips_set),}
> @@ -739,6 +745,9 @@ static __u64 fp_d_regs[] = {
>  #define FP_D_REGS_SUBLIST \
>  	{"fp_d", .feature = KVM_RISCV_ISA_EXT_D, .regs = fp_d_regs, \
>  		.regs_n = ARRAY_SIZE(fp_d_regs),}
> +#define SVADU_REGS_SUBLIST \
> +	{"svadu", .feature = KVM_RISCV_ISA_EXT_SVADU, .regs = svadu_regs, \
> +		.regs_n = ARRAY_SIZE(svadu_regs),}
>  
>  static struct vcpu_reg_list h_config = {
>  	.sublists = {
> @@ -876,6 +885,14 @@ static struct vcpu_reg_list fp_d_config = {
>  	},
>  };
>  
> +static struct vcpu_reg_list svadu_config = {
> +	.sublists = {
> +	BASE_SUBLIST,
> +	SVADU_REGS_SUBLIST,
> +	{0},
> +	},
> +};
> +
>  struct vcpu_reg_list *vcpu_configs[] = {
>  	&h_config,
>  	&zicbom_config,
> @@ -894,5 +911,6 @@ struct vcpu_reg_list *vcpu_configs[] = {
>  	&aia_config,
>  	&fp_f_config,
>  	&fp_d_config,
> +	&svadu_config,
>  };
>  int vcpu_configs_n = ARRAY_SIZE(vcpu_configs);
> -- 
> 2.17.1
>

We should rebase this on [1] since it changes sublist management.

[1] https://lore.kernel.org/all/20231128145357.413321-2-apatel@ventanamicro.com/

Thanks,
drew

