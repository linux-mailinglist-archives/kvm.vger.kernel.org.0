Return-Path: <kvm+bounces-10709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7765486EF74
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 09:16:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E267F1F221B8
	for <lists+kvm@lfdr.de>; Sat,  2 Mar 2024 08:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13884134C0;
	Sat,  2 Mar 2024 08:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="nkCn4lPW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AAB10A1A
	for <kvm@vger.kernel.org>; Sat,  2 Mar 2024 08:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709367366; cv=none; b=RmHdxaX3Y09hFbl8MTOzDNSJVEoaBK4hqVnDAIp4upXu0UMuvAHLVTqFcwrchCXiVSrIrzdm7nk+XJ8uTUuEtDqRT/mBDOQO9yWHDr5jrsWqpsVk++fMckdUQROZoqJ+sI6YHUgM8Y1pFWRr2MRCx8tE0ArlO662CdY2B6gz0Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709367366; c=relaxed/simple;
	bh=imsGxIIQqPdVCZnOSU+QGiRGjl9zsoGfrVdggA1Gq08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SDpGfim43+jikzcyemTKuXddfDMFp6CfpgUR3TOY9T0I/vfn5fCQySfWMabivnpb7rsK1sSfQYxMp15lnXvK5Blu2dAi2wk0L4b2WcrEvVv4V0T03yNhiPx+vUFkDUqgjAO3fmHOiLuQ1iS/FqjSqm2sAigRN8sEIexby7I1L1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=nkCn4lPW; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5133d276cbaso205957e87.2
        for <kvm@vger.kernel.org>; Sat, 02 Mar 2024 00:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709367362; x=1709972162; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j+sRBWRjS//bpUjvTytLqzgwvFA5NfQ/0kKt6udHWnE=;
        b=nkCn4lPWjY7mr0p+amadO30qxhcAvozpbC8erI2rqMjD0cBAwyP8ZWlU4hIjrcpMX7
         t2gOhMrmvWKSa+iHkDtdkhgeXM5DM25fsDylmEGioHYzeNgZhZMpPh5SQuqG0d6/9qBe
         7HVx59wW26/jEAwIFGYUL03JyvtPvv2eUv1N6g8uRSgxFlNHBdk+6lH8P05rKtgaQojU
         QO0vp+59tuvCSuliNZ0SViW6KIBRRRVnFQcBF0l5mi+RXdbsQzEWa8WoLSuEjhyRpSUl
         yBkILIyN5tn5UJHfyCLoOu5DhdLgdbJngNGwk6hW+F6a0s4LtaC5heUk6CsBuCnkAxpV
         rWVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709367362; x=1709972162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j+sRBWRjS//bpUjvTytLqzgwvFA5NfQ/0kKt6udHWnE=;
        b=nuyGq/w5QjPl08/hK0sLg4ptJ01kyaIZSLnYqAEZ+TYa8dmsQ8kK/rtM4A6Yy7gqZT
         PpjwrZEku09epZL93AMUPeRhb8IIkg6ZG+dBtuCQjYNROBm+fJwsDa3+hwTA3RzkPR4T
         8O+gFuZ8GgG0Z3bI9IbhLaqa0KuHNA03zrhAT0GP6HRk+J2NYhRkOGenbUjkU42Z4cOR
         CXwx/PwWrfki/mqMCv6cIm4uMgSIyuzxHCdXpNW+OG5mOO4cnFj4MewkryXWBhKdtKt4
         IeHSQ/xB5kV7/hXnv+N8PDpf90us54hybmSxwgyQssd227CNiW3rIRsYl6upt2VRYC3x
         JzKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQTNtDWbAdrbKkO86Jei1AczmRngvhI1LShTp9CfcbpNtKTE8OjfV3HBvO4g6j24qQSCWLaRsUWaMshoGfT/l7CzGd
X-Gm-Message-State: AOJu0YwlZcHFFMH4Qj2HJY4UDj+hydn9lG2fI+F+LBEaCjrTaoqFo7JU
	fSMdI169zE/m+yLB90S+YvF/ZLMmtThHoEU1kRSk3QPdKu3awbVPU3YfdUr2zq8=
X-Google-Smtp-Source: AGHT+IEWpcwm0FZQqjctycZ68/FbELxvzDOdEDS3pWw2MGcSKO0tFBODP1icN8h9TBp1bR13mcTvxA==
X-Received: by 2002:a05:6512:308f:b0:513:24b8:90cb with SMTP id z15-20020a056512308f00b0051324b890cbmr3714993lfd.0.1709367362484;
        Sat, 02 Mar 2024 00:16:02 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id h5-20020adf9cc5000000b0033dd9b050f9sm6617089wre.14.2024.03.02.00.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Mar 2024 00:16:01 -0800 (PST)
Date: Sat, 2 Mar 2024 09:15:55 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Atish Patra <atishp@rivosinc.com>
Cc: linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Conor Dooley <conor.dooley@microchip.com>, 
	Guo Ren <guoren@kernel.org>, Icenowy Zheng <uwu@icenowy.me>, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Shuah Khan <shuah@kernel.org>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 07/15] RISC-V: KVM: No need to exit to the user space
 if perf event failed
Message-ID: <20240302-1a3c0df25f2422e1e6abecf3@orel>
References: <20240229010130.1380926-1-atishp@rivosinc.com>
 <20240229010130.1380926-8-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229010130.1380926-8-atishp@rivosinc.com>

On Wed, Feb 28, 2024 at 05:01:22PM -0800, Atish Patra wrote:
> Currently, we return a linux error code if creating a perf event failed
> in kvm. That shouldn't be necessary as guest can continue to operate
> without perf profiling or profiling with firmware counters.
> 
> Return appropriate SBI error code to indicate that PMU configuration
> failed. An error message in kvm already describes the reason for failure.

I don't know enough about the perf subsystem to know if there may be
a concern that resources are temporarily unavailable. If so, then this
patch would make it possible for a guest to do the exact same thing,
but sometimes succeed and sometimes get SBI_ERR_NOT_SUPPORTED.
sbi_pmu_counter_config_matching doesn't currently have any error types
specified that say "unsupported at the moment, maybe try again", which
would be more appropriate in that case. I do see
perf_event_create_kernel_counter() can return ENOMEM when memory isn't
available, but if the kernel isn't able to allocate a small amount of
memory, then we're in bigger trouble anyway, so the concern would be
if there are perf resource pools which may temporarily be exhausted at
the time the guest makes this request.

One comment below.

> 
> Fixes: 0cb74b65d2e5 ("RISC-V: KVM: Implement perf support without sampling")
> Reviewed-by: Anup Patel <anup@brainfault.org>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  arch/riscv/kvm/vcpu_pmu.c     | 14 +++++++++-----
>  arch/riscv/kvm/vcpu_sbi_pmu.c |  6 +++---
>  2 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
> index b1574c043f77..29bf4ca798cb 100644
> --- a/arch/riscv/kvm/vcpu_pmu.c
> +++ b/arch/riscv/kvm/vcpu_pmu.c
> @@ -229,8 +229,9 @@ static int kvm_pmu_validate_counter_mask(struct kvm_pmu *kvpmu, unsigned long ct
>  	return 0;
>  }
>  
> -static int kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_event_attr *attr,
> -				     unsigned long flags, unsigned long eidx, unsigned long evtdata)
> +static long kvm_pmu_create_perf_event(struct kvm_pmc *pmc, struct perf_event_attr *attr,
> +				      unsigned long flags, unsigned long eidx,
> +				      unsigned long evtdata)
>  {
>  	struct perf_event *event;
>  
> @@ -454,7 +455,8 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  				     unsigned long eidx, u64 evtdata,
>  				     struct kvm_vcpu_sbi_return *retdata)
>  {
> -	int ctr_idx, ret, sbiret = 0;
> +	int ctr_idx, sbiret = 0;
> +	long ret;
>  	bool is_fevent;
>  	unsigned long event_code;
>  	u32 etype = kvm_pmu_get_perf_event_type(eidx);
> @@ -513,8 +515,10 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>  			kvpmu->fw_event[event_code].started = true;
>  	} else {
>  		ret = kvm_pmu_create_perf_event(pmc, &attr, flags, eidx, evtdata);
> -		if (ret)
> -			return ret;
> +		if (ret) {
> +			sbiret = SBI_ERR_NOT_SUPPORTED;
> +			goto out;
> +		}
>  	}
>  
>  	set_bit(ctr_idx, kvpmu->pmc_in_use);
> diff --git a/arch/riscv/kvm/vcpu_sbi_pmu.c b/arch/riscv/kvm/vcpu_sbi_pmu.c
> index 7eca72df2cbd..b70179e9e875 100644
> --- a/arch/riscv/kvm/vcpu_sbi_pmu.c
> +++ b/arch/riscv/kvm/vcpu_sbi_pmu.c
> @@ -42,9 +42,9 @@ static int kvm_sbi_ext_pmu_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  #endif
>  		/*
>  		 * This can fail if perf core framework fails to create an event.
> -		 * Forward the error to userspace because it's an error which
> -		 * happened within the host kernel. The other option would be
> -		 * to convert to an SBI error and forward to the guest.
> +		 * No need to forward the error to userspace and exit the guest

Period after guest


> +		 * operation can continue without profiling. Forward the

The operation

> +		 * appropriate SBI error to the guest.
>  		 */
>  		ret = kvm_riscv_vcpu_pmu_ctr_cfg_match(vcpu, cp->a0, cp->a1,
>  						       cp->a2, cp->a3, temp, retdata);
> -- 
> 2.34.1
>

Thanks,
drew

