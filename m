Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1D83CFADB
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 15:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238603AbhGTM7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 08:59:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40616 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237225AbhGTM5m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Jul 2021 08:57:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626788296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vU/6bjwZL5Bd6mANqCXpmHsjLsH8+dFlpfCQrauhKS0=;
        b=AcuoE5vI4XT6VOw1F7tuxgaJq3oPif4DO4XrC6NUz8PBWESf/gqGW4OVTT8a09CxwSDZ6D
        G8JK7tzU+GWCJPPIY17f+F0etm+y6PPZVmKb5ANObOHCB1b4VYeOtjaApKdbgL8bb4exI7
        uP34M6nH74Q7NsuPX9kxOExdvpAr0yc=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-H63QHwxpNT-RT3Xg3yrZBg-1; Tue, 20 Jul 2021 09:38:15 -0400
X-MC-Unique: H63QHwxpNT-RT3Xg3yrZBg-1
Received: by mail-il1-f198.google.com with SMTP id e16-20020a056e0204b0b029020c886c9370so13090832ils.10
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 06:38:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vU/6bjwZL5Bd6mANqCXpmHsjLsH8+dFlpfCQrauhKS0=;
        b=Bes/a6h/HnDeFAd7Cim7XhN+LeF00AQ9h+RPLV/kxpqHOKdhUvXNlMnFzTI/nRBUJQ
         3DrTpxunpt6sv1tXK10hCStWQ6mk2sOml77HHAniBzB+RBkF4jZcpdwv+DYnwRcsBH0N
         ejnZHxu4HY/Pcve8N0gUHSWzAyYUg+jJn9tGyxiE58pKeriLOit2DO5wfVMWUM/Asp5T
         PHtKT2aBwoMI2MnHl2qPGW6Yp3KhXZkGlZ6rjHhPqMmjrm/Mdx4/vom4M67yBkxaJoXv
         lqLBXjPnlOiRle2Hlj3NGrCihpdbATfi1jQGhLaLAHStZjDA/L06iRIjabaKhVfl0Yy6
         oNrg==
X-Gm-Message-State: AOAM533ZHjJnJHGHAAk94vTGjIBs8kgx4UPR6DPyiEzuOx5Zt8trJhp/
        +YNDXKidx9P5lcw/XZ7agGFhOd1Y8BwQA6Aen6ECozdMSKpbFgn5+aoiP/58cVsNAiEmoCBoB/w
        jf2fjun+vz0AC
X-Received: by 2002:a05:6e02:2162:: with SMTP id s2mr20749929ilv.99.1626788294459;
        Tue, 20 Jul 2021 06:38:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2c+KuF4Es06cQJtPkV9Pm8wrKxtYAjfiHMsDibZFB3bZtEeXiPfi39fOPzymmy4PgDZFt1Q==
X-Received: by 2002:a05:6e02:2162:: with SMTP id s2mr20749917ilv.99.1626788294272;
        Tue, 20 Jul 2021 06:38:14 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id e9sm11345255ils.61.2021.07.20.06.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 06:38:13 -0700 (PDT)
Date:   Tue, 20 Jul 2021 15:38:10 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v3 05/15] KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
Message-ID: <20210720133810.7q4k2yde57okgvmm@gator>
References: <20210719160346.609914-1-tabba@google.com>
 <20210719160346.609914-6-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719160346.609914-6-tabba@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 19, 2021 at 05:03:36PM +0100, Fuad Tabba wrote:
> Refactor sys_regs.h and sys_regs.c to make it easier to reuse
> common code. It will be used in nVHE in a later patch.
> 
> Note that the refactored code uses __inline_bsearch for find_reg
> instead of bsearch to avoid copying the bsearch code for nVHE.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/sysreg.h |  3 +++
>  arch/arm64/kvm/sys_regs.c       | 30 +-----------------------------
>  arch/arm64/kvm/sys_regs.h       | 31 +++++++++++++++++++++++++++++++
>  3 files changed, 35 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 7b9c3acba684..326f49e7bd42 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -1153,6 +1153,9 @@
>  #define ICH_VTR_A3V_SHIFT	21
>  #define ICH_VTR_A3V_MASK	(1 << ICH_VTR_A3V_SHIFT)
>  
> +/* Extract the feature specified from the feature id register. */
> +#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))

I think the comment would be better as

 Create a mask for the feature bits of the specified feature.

And, I think a more specific name than FEATURE would be better. Maybe
FEATURE_MASK or even ARM64_FEATURE_MASK ?

> +
>  #ifdef __ASSEMBLY__
>  
>  	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 80a6e41cadad..1a939c464858 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -44,10 +44,6 @@
>   * 64bit interface.
>   */
>  
> -#define reg_to_encoding(x)						\
> -	sys_reg((u32)(x)->Op0, (u32)(x)->Op1,				\
> -		(u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
> -
>  static bool read_from_write_only(struct kvm_vcpu *vcpu,
>  				 struct sys_reg_params *params,
>  				 const struct sys_reg_desc *r)
> @@ -1026,8 +1022,6 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
> -
>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
>  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  		struct sys_reg_desc const *r, bool raz)
> @@ -2106,23 +2100,6 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
>  	return 0;
>  }
>  
> -static int match_sys_reg(const void *key, const void *elt)
> -{
> -	const unsigned long pval = (unsigned long)key;
> -	const struct sys_reg_desc *r = elt;
> -
> -	return pval - reg_to_encoding(r);
> -}
> -
> -static const struct sys_reg_desc *find_reg(const struct sys_reg_params *params,
> -					 const struct sys_reg_desc table[],
> -					 unsigned int num)
> -{
> -	unsigned long pval = reg_to_encoding(params);
> -
> -	return bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
> -}
> -
>  int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu)
>  {
>  	kvm_inject_undefined(vcpu);
> @@ -2365,13 +2342,8 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
>  
>  	trace_kvm_handle_sys_reg(esr);
>  
> -	params.Op0 = (esr >> 20) & 3;
> -	params.Op1 = (esr >> 14) & 0x7;
> -	params.CRn = (esr >> 10) & 0xf;
> -	params.CRm = (esr >> 1) & 0xf;
> -	params.Op2 = (esr >> 17) & 0x7;
> +	params = esr_sys64_to_params(esr);
>  	params.regval = vcpu_get_reg(vcpu, Rt);
> -	params.is_write = !(esr & 1);
>  
>  	ret = emulate_sys_reg(vcpu, &params);
>  
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index 9d0621417c2a..cc0cc95a0280 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -11,6 +11,12 @@
>  #ifndef __ARM64_KVM_SYS_REGS_LOCAL_H__
>  #define __ARM64_KVM_SYS_REGS_LOCAL_H__
>  
> +#include <linux/bsearch.h>
> +
> +#define reg_to_encoding(x)						\
> +	sys_reg((u32)(x)->Op0, (u32)(x)->Op1,				\
> +		(u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
> +
>  struct sys_reg_params {
>  	u8	Op0;
>  	u8	Op1;
> @@ -21,6 +27,14 @@ struct sys_reg_params {
>  	bool	is_write;
>  };
>  
> +#define esr_sys64_to_params(esr)                                               \
> +	((struct sys_reg_params){ .Op0 = ((esr) >> 20) & 3,                    \
> +				  .Op1 = ((esr) >> 14) & 0x7,                  \
> +				  .CRn = ((esr) >> 10) & 0xf,                  \
> +				  .CRm = ((esr) >> 1) & 0xf,                   \
> +				  .Op2 = ((esr) >> 17) & 0x7,                  \
> +				  .is_write = !((esr) & 1) })
> +
>  struct sys_reg_desc {
>  	/* Sysreg string for debug */
>  	const char *name;
> @@ -152,6 +166,23 @@ static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
>  	return i1->Op2 - i2->Op2;
>  }
>  
> +static inline int match_sys_reg(const void *key, const void *elt)
> +{
> +	const unsigned long pval = (unsigned long)key;
> +	const struct sys_reg_desc *r = elt;
> +
> +	return pval - reg_to_encoding(r);
> +}
> +
> +static inline const struct sys_reg_desc *
> +find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
> +	 unsigned int num)
> +{
> +	unsigned long pval = reg_to_encoding(params);
> +
> +	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
> +}
> +
>  const struct sys_reg_desc *find_reg_by_id(u64 id,
>  					  struct sys_reg_params *params,
>  					  const struct sys_reg_desc table[],
> -- 
> 2.32.0.402.g57bb445576-goog
>

Otherwise

Reviewed-by: Andrew Jones <drjones@redhat.com>

