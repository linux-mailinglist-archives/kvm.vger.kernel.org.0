Return-Path: <kvm+bounces-4446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BFB08129C1
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 08:52:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFBEA28227A
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 07:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3ED514AAC;
	Thu, 14 Dec 2023 07:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="VHpq9mfZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C143EA7
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 23:52:39 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-336437ae847so874003f8f.2
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 23:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1702540358; x=1703145158; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kKmbX2YPpXuRY6IHo6cBzkg+NMrJJvxaEEC8NjKnxGY=;
        b=VHpq9mfZE1XYZzd6nMuutgRxkVQCDOjfnRS8Qzh0Qg4TY8VxWWoVDC512DViv5Bou/
         5HKtEfAcLLqMLqWL6PvsU0uO3y5rGc7M+2+3YLlSAS1U19Hh3livL5cY7J/W5WL0XcRo
         yH03VvPRltYaLlt9K77DMSZ6Ilkg0zS4rI6YsSDX7cQBC2mGkJq+SjGGX4LcwRtO72TK
         eIz9HfIM6uO4sErEee0gvmsrP3/7uuknBz1Y2UWtkvy5JGjQ7Z6ty57FYe7yAjcPxkD7
         nAgyiBHm2avZlpsDhqHc925u70+dQJ6ASppqtVvfN9QH6jVaCsTYqFyUUnJ8Hx+KOM3A
         CgUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702540358; x=1703145158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kKmbX2YPpXuRY6IHo6cBzkg+NMrJJvxaEEC8NjKnxGY=;
        b=lTLyA5kqxWXo0K2b6AHgjsBS2PzcDN9PZ0xr4wRZvw+cbCDucWJpujJ4G7ht/21Ny+
         Q9DsnGit6mHNdyqYCvpp7AEtfKDCYKd3DdZoUH0BBbLVSg7qpWlPF6tgzRvs1JYLwrdF
         /r1uZpwuE0c2bv1SGRSOy38cDOw2owcwOZtfeljyUY4oFMnchsOrz/bVskeLILOFXKCC
         M+LoSwIFwW29QG1trlGs6VK5W7vkZJvhE+wpz5d6+4LsnOReJ1Ber5/hI2ipWI6pnvoh
         GZiKvxbwdViBQhkqCmLibbzfHTobaDwp5x9CKD6u+UX+OXC+iuKrE1JxpCU2biwevhMn
         Xf7g==
X-Gm-Message-State: AOJu0Yw2hfY47lJ8A2a3Fu1xPuPHp8beX4J+gM2FYmoMdgQx/dKBMdGO
	3PgIreIHqyjHqkTO4i6QaxGKQQ==
X-Google-Smtp-Source: AGHT+IEcg4w5zPjg1p98QCYf6W1xFs9iv4IikObE4ZRhGgbZ28NqkIVLjUjAV+O24f828odOwuc64g==
X-Received: by 2002:a05:6000:4c6:b0:333:1c97:48c4 with SMTP id h6-20020a05600004c600b003331c9748c4mr4411047wri.7.1702540357383;
        Wed, 13 Dec 2023 23:52:37 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id x14-20020adfdd8e000000b0033630da3528sm5702110wrl.25.2023.12.13.23.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 23:52:36 -0800 (PST)
Date: Thu, 14 Dec 2023 08:52:35 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Cc: kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, anup@brainfault.org, atishp@atishpatra.org, palmer@dabbelt.com
Subject: Re: [PATCH v3 3/3] RISC-V: KVM: add vector CSRs in KVM_GET_REG_LIST
Message-ID: <20231214-315a8cd86b5eeb5a1a4ebd88@orel>
References: <20231205174509.2238870-1-dbarboza@ventanamicro.com>
 <20231205174509.2238870-4-dbarboza@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205174509.2238870-4-dbarboza@ventanamicro.com>

On Tue, Dec 05, 2023 at 02:45:09PM -0300, Daniel Henrique Barboza wrote:
> Add all vector CSRs (vstart, vl, vtype, vcsr, vlenb) in get-reg-list.

We should add another patch for the test for these
(tools/testing/selftests/kvm/riscv/get-reg-list.c)

Thanks,
drew

> 
> Signed-off-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
> ---
>  arch/riscv/kvm/vcpu_onereg.c | 55 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index f8c9fa0c03c5..2eb4980295ae 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -986,6 +986,55 @@ static int copy_sbi_ext_reg_indices(u64 __user *uindices)
>  	return num_sbi_ext_regs();
>  }
>  
> +static inline unsigned long num_vector_regs(const struct kvm_vcpu *vcpu)
> +{
> +	if (!riscv_isa_extension_available(vcpu->arch.isa, v))
> +		return 0;
> +
> +	/* vstart, vl, vtype, vcsr, vlenb and 32 vector regs */
> +	return 37;
> +}
> +
> +static int copy_vector_reg_indices(const struct kvm_vcpu *vcpu,
> +				u64 __user *uindices)
> +{
> +	const struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
> +	int n = num_vector_regs(vcpu);
> +	u64 reg, size;
> +	int i;
> +
> +	if (n == 0)
> +		return 0;
> +
> +	/* copy vstart, vl, vtype, vcsr and vlenb */
> +	size = IS_ENABLED(CONFIG_32BIT) ? KVM_REG_SIZE_U32 : KVM_REG_SIZE_U64;
> +	for (i = 0; i < 5; i++) {
> +		reg = KVM_REG_RISCV | size | KVM_REG_RISCV_VECTOR | i;
> +
> +		if (uindices) {
> +			if (put_user(reg, uindices))
> +				return -EFAULT;
> +			uindices++;
> +		}
> +	}
> +
> +	/* vector_regs have a variable 'vlenb' size */
> +	size = __builtin_ctzl(cntx->vector.vlenb);
> +	size <<= KVM_REG_SIZE_SHIFT;
> +	for (i = 0; i < 32; i++) {
> +		reg = KVM_REG_RISCV | KVM_REG_RISCV_VECTOR | size |
> +			KVM_REG_RISCV_VECTOR_REG(i);
> +
> +		if (uindices) {
> +			if (put_user(reg, uindices))
> +				return -EFAULT;
> +			uindices++;
> +		}
> +	}
> +
> +	return n;
> +}
> +
>  /*
>   * kvm_riscv_vcpu_num_regs - how many registers do we present via KVM_GET/SET_ONE_REG
>   *
> @@ -1001,6 +1050,7 @@ unsigned long kvm_riscv_vcpu_num_regs(struct kvm_vcpu *vcpu)
>  	res += num_timer_regs();
>  	res += num_fp_f_regs(vcpu);
>  	res += num_fp_d_regs(vcpu);
> +	res += num_vector_regs(vcpu);
>  	res += num_isa_ext_regs(vcpu);
>  	res += num_sbi_ext_regs();
>  
> @@ -1045,6 +1095,11 @@ int kvm_riscv_vcpu_copy_reg_indices(struct kvm_vcpu *vcpu,
>  		return ret;
>  	uindices += ret;
>  
> +	ret = copy_vector_reg_indices(vcpu, uindices);
> +	if (ret < 0)
> +		return ret;
> +	uindices += ret;
> +
>  	ret = copy_isa_ext_reg_indices(vcpu, uindices);
>  	if (ret < 0)
>  		return ret;
> -- 
> 2.41.0
> 

