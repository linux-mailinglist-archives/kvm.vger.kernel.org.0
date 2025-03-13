Return-Path: <kvm+bounces-40937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CDE64A5F81B
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 15:28:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 001423B7658
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 14:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC258268691;
	Thu, 13 Mar 2025 14:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="P7yi17oi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9513268681
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 14:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741876042; cv=none; b=OG1pvEPSpj2qCK+1Qs0VcN8QQtq3GEYL6yioG1adcfve29H5FjK7hKGQCAZbW0SJf6oA6I5n9NB+n6GS3TkHg6RXnzk1/0jbR3mpQNqJvZisQrGX6hByF7tl7bqwavS7+ht2eRTc3Rxysu+wmqDnScLBoW4NOJT1I2OkVMkyoIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741876042; c=relaxed/simple;
	bh=oKvFJqfjCg0oe1WKlBfVLElWET9EO+f7JfuuJyGbUVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DV+kBDN/2hn4Wk4cBJkh4vVA4rwaWVb8qtpLGYWNnLgd4k0ansFI3uEd0ahWG/Ov8RgsTDcecdDHojub+VqtZZWKgE3LMqnu4BVmvNvi6J2QnXOX3qTcNOFRL8DhZ8CaIGMzk0+vCRTeVjiir/hWsa1tO5GMIg9QfGPaFi45m+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=P7yi17oi; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3913fdd0120so602470f8f.0
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 07:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1741876039; x=1742480839; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XLr2/Str8PUdULF1c2O3jE557wb7uOe7x8v7FUGx02s=;
        b=P7yi17oiP/kFyc7tFrJt1WkF3+jMRiMD0Icna6K78dT50QHQRWFdSHF6nvm8TDfg/h
         B2EtVmFVn9nXYvF58uA8KB1VM/QQC1FKN1B2U8BAnAeI/RVdSxN8UF2V9sEnWLhAiBXj
         /geP+giTm8aI3ss2BGq/LSi08PAt8qqwGDRUFmItaYbnbqj8azD63AXnGPcA+YCEhHEj
         161TDSSeOyu1ZHQD7uJcBNiOLnVwNVWPKNLixvjn9pUjBYIVanWtOIwnrd1TynV37EHW
         5ZFvrkUl2lWzpeMGzM+7SGSFZvUb2RNJQDvWeSkv87GO7qR65n8lXrdfyY1/OYFluqDQ
         uPLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741876039; x=1742480839;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XLr2/Str8PUdULF1c2O3jE557wb7uOe7x8v7FUGx02s=;
        b=HMjQ9qM5zA3HgpYbgtS5y8lJ9Lk/0ww+lPCNT19V+FqUdl8GAQHtKDDXgxmEsjUEFx
         ftliQWleJsSur5PpygSDU4RzTeI7Q23/Oo2KHpn4XmZBAYtjJsw567m7mQ/SSqxbTQhs
         jv4SReNN4qx4AL5Od2o0hXk6pqmdbPdQsd+r2R2x6CmgV/jkZtKerQCpd7sbOV6Vcocv
         gOWqoyBS5ymNgzhPOx4j7xonQWzYvCwpYxVCHS3kOOPpM+P43VdkEykrE5lRAcZAuK7v
         pDoAtrj/PlZTuFkeg04c/qdyEUe1BmFEaRaCTQn8DGKaJAqa0kUCFiWUP10ZKyNEWidR
         hQlQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpIDdxa3AWf+jlj6KVkNHKTlPy0BP8+N6sXrniGUYUjvUqOtA77PND6tqSfGj8gjf5L4U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyfa5CnYEgeTKkFy6HA9rIgeAq0CgS0xAq1Z4myEnNKkzY5K6aB
	E4+5dOCs8sPvKbXIecGi8NJm0bBffQlxak200j12hPdWDMccFdfXL/OeViChcNY=
X-Gm-Gg: ASbGncsO0DlGQ9Nqh1Lpl4OrUVgwB0nlI3Df/+t5inYjPOeMQCW1k0RE9/ePXgUtLXT
	9OaqwNo2aIN6BOvMvehgT3LBErcn40PMWqnU9bgxAMWE30ubgPVgY58Yu6FEzxKExqC52hr9DD3
	9oArUKddqfIEbC7XigaQK2OdX9zTfHYTxuQIs35NlfVsQvasnvfP3++OifnMbAKJreiUmr8oGwX
	3npDnMhpoo9beUTH2yiChM85+y4KbpMEBekeY6ZDpHLPvPfMTWC62jnEp7qS3hXmKCDSa3QEAca
	cnuGyrCVXvZRVk8SUreIOIqs4ajH4qfY4rD0TWVNAPM=
X-Google-Smtp-Source: AGHT+IGx3Sab5SDKogjK4G9G6vPewBpr2VjhUbGJwcX+nwTAiQQruD0qs0HuNiII4DaXFL2TeXeVoQ==
X-Received: by 2002:a5d:64cb:0:b0:391:40b8:e890 with SMTP id ffacd0b85a97d-39140b8e9f4mr17833900f8f.22.1741876038933;
        Thu, 13 Mar 2025 07:27:18 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::59a5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c8975b34sm2303314f8f.55.2025.03.13.07.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 07:27:18 -0700 (PDT)
Date: Thu, 13 Mar 2025 15:27:17 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	Samuel Holland <samuel.holland@sifive.com>
Subject: Re: [PATCH v3 14/17] RISC-V: KVM: add SBI extension init()/deinit()
 functions
Message-ID: <20250313-f08cee46c912f729d1829d37@orel>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
 <20250310151229.2365992-15-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250310151229.2365992-15-cleger@rivosinc.com>

On Mon, Mar 10, 2025 at 04:12:21PM +0100, Clément Léger wrote:
> The FWFT SBI extension will need to dynamically allocate memory and do
> init time specific initialization. Add an init/deinit callbacks that
> allows to do so.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  9 +++++++++
>  arch/riscv/kvm/vcpu.c                 |  2 ++
>  arch/riscv/kvm/vcpu_sbi.c             | 29 +++++++++++++++++++++++++++
>  3 files changed, 40 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 4ed6203cdd30..bcb90757b149 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -49,6 +49,14 @@ struct kvm_vcpu_sbi_extension {
>  
>  	/* Extension specific probe function */
>  	unsigned long (*probe)(struct kvm_vcpu *vcpu);
> +
> +	/*
> +	 * Init/deinit function called once during VCPU init/destroy. These
> +	 * might be use if the SBI extensions need to allocate or do specific
> +	 * init time only configuration.
> +	 */
> +	int (*init)(struct kvm_vcpu *vcpu);
> +	void (*deinit)(struct kvm_vcpu *vcpu);
>  };
>  
>  void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu, struct kvm_run *run);
> @@ -69,6 +77,7 @@ const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
>  bool riscv_vcpu_supports_sbi_ext(struct kvm_vcpu *vcpu, int idx);
>  int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
> +void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu);
>  
>  int kvm_riscv_vcpu_get_reg_sbi_sta(struct kvm_vcpu *vcpu, unsigned long reg_num,
>  				   unsigned long *reg_val);
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 60d684c76c58..877bcc85c067 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -185,6 +185,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
> +	kvm_riscv_vcpu_sbi_deinit(vcpu);
> +
>  	/* Cleanup VCPU AIA context */
>  	kvm_riscv_vcpu_aia_deinit(vcpu);
>  
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index d1c83a77735e..858ddefd7e7f 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -505,8 +505,37 @@ void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
>  			continue;
>  		}
>  
> +		if (!ext->default_disabled && ext->init &&
> +		    ext->init(vcpu) != 0) {
> +			scontext->ext_status[idx] = KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE;
> +			continue;
> +		}

I think this new block should be below the assignment below (and it can
drop the continue) and it shouldn't check default_disabled (as I've done
below). IOW, we should always run ext->init when there is one to run here.
Otherwise, I how will it get run later?

> +
>  		scontext->ext_status[idx] = ext->default_disabled ?
>  					KVM_RISCV_SBI_EXT_STATUS_DISABLED :
>  					KVM_RISCV_SBI_EXT_STATUS_ENABLED;

                if (ext->init && ext->init(vcpu))
                    scontext->ext_status[idx] = KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE;

>  	}
>  }
> +
> +void kvm_riscv_vcpu_sbi_deinit(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
> +	const struct kvm_riscv_sbi_extension_entry *entry;
> +	const struct kvm_vcpu_sbi_extension *ext;
> +	int idx, i;
> +
> +	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
> +		entry = &sbi_ext[i];
> +		ext = entry->ext_ptr;
> +		idx = entry->ext_idx;
> +
> +		if (idx < 0 || idx >= ARRAY_SIZE(scontext->ext_status))
> +			continue;
> +
> +		if (scontext->ext_status[idx] == KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE ||
> +		    !ext->deinit)
> +			continue;
> +
> +		ext->deinit(vcpu);
> +	}
> +}
> -- 
> 2.47.2
>

Thanks,
drew

