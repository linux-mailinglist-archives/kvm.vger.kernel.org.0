Return-Path: <kvm+bounces-13529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13ABE89857C
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 12:56:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2E4D283935
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 10:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3159C823CA;
	Thu,  4 Apr 2024 10:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ls25L0vf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046007FBB1
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 10:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712228202; cv=none; b=dRfuDA169cIq2UOoS+XLvnmjl8CmGIaZ0C1bgnW4UcrM2kRagelA66/mnJrrmaF/ndcGTVvQkwA3tQ2NPDLJkyyV2IWcPXnnxWyHydrXXo3+VndfwKywom1MsQXzuF13BIQOgvPGYBlyAbwFvL4bG0dk35RL91r0i9JPuIRt0/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712228202; c=relaxed/simple;
	bh=ILJL7HVZXiFmQJJigk5doa9mj2osaYbOmdnt4D25RYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kB2qPfOd7dVr1VE8F04FgIWMeIYrr6CsxrsQ/CQlhL/+WgXJQhvXKj0/TDGSF5yocq4DrgQTFdbTw1nQv45xnWJ5vL9dtoZrkIR0SZa0X/K7BeKPFxg9tAZKAljiD5dF7LrkujlCW9K7wGPaatKrqSk/J95nySwL60LqKoyGbP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ls25L0vf; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-343c7fae6e4so215841f8f.1
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 03:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1712228198; x=1712832998; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EFHFiM3SNW59iwbZR58YbB15YVKnaSxrhFOdislttik=;
        b=ls25L0vf8AIRxamXmlvbryDGvwgL6FELj8Kc/p9WXITVooxCUcq3h6CSkdjN13lBXI
         RsEHJkOqC7ueTL37LjjW7vf6VuIgcPZbxodGleL8KM83g/OVLGkTmrM+7wWidbF65W1X
         aOd/rQwYOXsTkjwn0k7fB1l5iidi3SpHGwTjuBmuMpXexC3MJEzgCtxJtJIzlHUqQA8X
         hfGDEQKJDSlAY1rl6X0Wlx9FNEuYvCnHB9H3CtgZ6Yb4Ze79ZWynrhpV8ZB2s0epx3Fb
         0OLauckwBZZQ23IGiCUtzY6mN2mZ6QyeYtqEYs0c5EvFkCMb1cep6+q6Ofu3gpTCpnFd
         Vw7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712228198; x=1712832998;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EFHFiM3SNW59iwbZR58YbB15YVKnaSxrhFOdislttik=;
        b=Yn0yCwZ1S1NE/kVowRWCjpXWHtgWv8Q7IBSx40tjApSAOvWHQWCjIZUEnlSdA+ep5p
         /0gymabx7ZIZVSi5QHe1lnqkZuGwwUYpIXle/6+hEbEOdX+ZmNBnZBZsAaqJWfNYiooJ
         nRS5lLk647+z1py/Ggd04r+Db9lxRVONYeImZe1XyxrRowAcN27PeGcQQqYJ+n/8mXZy
         3uODMTB5cPePLrGoa/gzqDwPtt7wan0xuF+CtWufd9VzEgk4BGIzy6c6JcYNdaEowyxA
         4jDUr4PWofYo+TxEQSk3WeZ6BQ1K+kIH+bme0V186dopZwfbmS+l7Mv6W7wdNlBlD0xY
         vd1A==
X-Forwarded-Encrypted: i=1; AJvYcCUQgCnpDowuU9yRBaU/lPduVQ/yMurypyYLg1Ib4/zE9sSqJmGtsN/XNqYZgOgDc5+THLMaXyhqqcBhcILUmHKZKK2O
X-Gm-Message-State: AOJu0YzSWS953W3B+swLyo3z+iQJnIZSJH5ynzCFctV3hPrpGEbUjx88
	S7yIWl+J/Y+lqPVSTMKj0vWPeayLo9DBAk4ibNxGI6W+qROu+iJhpkmgFhq71Vo=
X-Google-Smtp-Source: AGHT+IENSyz17ALt9X+5ZUYzaEpWJFzo0+v4zqkPSZygVwnsdSsHijcp2D+46t60iJ6/39PaQMtB1w==
X-Received: by 2002:a05:6000:1805:b0:343:7158:aace with SMTP id m5-20020a056000180500b003437158aacemr1379890wrh.17.1712228198219;
        Thu, 04 Apr 2024 03:56:38 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id f10-20020a0560001b0a00b00341dbb4a3a7sm19705617wrz.86.2024.04.04.03.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Apr 2024 03:56:37 -0700 (PDT)
Date: Thu, 4 Apr 2024 12:56:36 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, 
	=?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, Conor Dooley <conor.dooley@microchip.com>, 
	Anup Patel <anup@brainfault.org>, Ajay Kaher <akaher@vmware.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Alexey Makhalov <amakhalov@vmware.com>, 
	Juergen Gross <jgross@suse.com>, kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, virtualization@lists.linux.dev, 
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>, Will Deacon <will@kernel.org>, x86@kernel.org
Subject: Re: [PATCH v5 01/22] RISC-V: Fix the typo in Scountovf CSR name
Message-ID: <20240404-9c750d13d89168feb5ff34de@orel>
References: <20240403080452.1007601-1-atishp@rivosinc.com>
 <20240403080452.1007601-2-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240403080452.1007601-2-atishp@rivosinc.com>

On Wed, Apr 03, 2024 at 01:04:30AM -0700, Atish Patra wrote:
> The counter overflow CSR name is "scountovf" not "sscountovf".
> 
> Fix the csr name.
> 
> Fixes: 4905ec2fb7e6 ("RISC-V: Add sscofpmf extension support")
> Reviewed-by: Clément Léger <cleger@rivosinc.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/include/asm/csr.h | 2 +-
>  drivers/perf/riscv_pmu_sbi.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 2468c55933cd..9d1b07932794 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -281,7 +281,7 @@
>  #define CSR_HPMCOUNTER30H	0xc9e
>  #define CSR_HPMCOUNTER31H	0xc9f
>  
> -#define CSR_SSCOUNTOVF		0xda0
> +#define CSR_SCOUNTOVF		0xda0
>  
>  #define CSR_SSTATUS		0x100
>  #define CSR_SIE			0x104
> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
> index 8cbe6e5f9c39..3e44d2fb8bf8 100644
> --- a/drivers/perf/riscv_pmu_sbi.c
> +++ b/drivers/perf/riscv_pmu_sbi.c
> @@ -27,7 +27,7 @@
>  
>  #define ALT_SBI_PMU_OVERFLOW(__ovl)					\
>  asm volatile(ALTERNATIVE_2(						\
> -	"csrr %0, " __stringify(CSR_SSCOUNTOVF),			\
> +	"csrr %0, " __stringify(CSR_SCOUNTOVF),				\
>  	"csrr %0, " __stringify(THEAD_C9XX_CSR_SCOUNTEROF),		\
>  		THEAD_VENDOR_ID, ERRATA_THEAD_PMU,			\
>  		CONFIG_ERRATA_THEAD_PMU,				\
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

