Return-Path: <kvm+bounces-45989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93B1BAB0622
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 00:53:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 717259E517F
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 22:52:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62E0E230BC8;
	Thu,  8 May 2025 22:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PJk/lmKo"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C451E4AE
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 22:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746744771; cv=none; b=sw4umA65wVmGK+5KXD94e7nSmY/QdbSHdq3E+LZfgYBeLjqmJ9JkWy9CAMfHERTDaaIV+qN1IOobkUoRU4ijbFoezCoOFy1uD0s+B0blA3A0IBMKu97DwZhaV892LtErEplQtB9DZ4CucZUeCvXhaAa9tgJrCTCnPSpHS18Mub8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746744771; c=relaxed/simple;
	bh=ebQnwIE4eCQ1v69xs/aB+wZRwd1xgMuNaZrGEND8M4w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qrxZGivpBX9yYB3hAWBiJOCgwz87Go/O7501Ifom8saYKTKAsJLSaOZ7iaQRYT4YL0RFI7TuuHFKRhcPqE4Vc0vDTsNR6NNn8kfIzrDWgUY672sLz5JbDIfaO2VqNof+gjOH6Q3Bqw5du+bMjt8KXVBNSIWl0aALRU9L7CvxCcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PJk/lmKo; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <4618bd56-c085-4147-b119-d2f57e17ebec@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746744767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LVUIn3q1JFdYUFjgqyctbUvKd01vJdtvdQeZ0/vC43Y=;
	b=PJk/lmKo7NOwOpC15l9ImrjsFfO7HEDN1mA+5rMBeabobpM5fmIg5J0V4mkYKA+VwOgGuk
	GFieYhcuyrpBC006QXIQvijs5b/Tf8Hrn+iXDe1KsqEN9CYJSfd6eMkyRNIMerVGpNM+4B
	xtxbc8nMk2tJ09P5HyXhXM1iLuesBdU=
Date: Thu, 8 May 2025 15:52:25 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 04/14] riscv: sbi: add FWFT extension interface
To: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kselftest@vger.kernel.org
Cc: Samuel Holland <samuel.holland@sifive.com>,
 Andrew Jones <ajones@ventanamicro.com>, Deepak Gupta <debug@rivosinc.com>
References: <20250424173204.1948385-1-cleger@rivosinc.com>
 <20250424173204.1948385-5-cleger@rivosinc.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250424173204.1948385-5-cleger@rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 4/24/25 10:31 AM, ClÃ©ment LÃ©ger wrote:
> This SBI extensions enables supervisor mode to control feature that are
> under M-mode control (For instance, Svadu menvcfg ADUE bit, Ssdbltrp
> DTE, etc). Add an interface to set local features for a specific cpu
> mask as well as for the online cpu mask.
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> ---
>   arch/riscv/include/asm/sbi.h | 17 +++++++++++
>   arch/riscv/kernel/sbi.c      | 57 ++++++++++++++++++++++++++++++++++++
>   2 files changed, 74 insertions(+)
> 
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index 7ec249fea880..3bbef56bcefc 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -503,6 +503,23 @@ int sbi_remote_hfence_vvma_asid(const struct cpumask *cpu_mask,
>   				unsigned long asid);
>   long sbi_probe_extension(int ext);
>   
> +int sbi_fwft_set(u32 feature, unsigned long value, unsigned long flags);
> +int sbi_fwft_set_cpumask(const cpumask_t *mask, u32 feature,
> +			 unsigned long value, unsigned long flags);
> +/**
> + * sbi_fwft_set_online_cpus() - Set a feature on all online cpus
> + * @feature: The feature to be set
> + * @value: The feature value to be set
> + * @flags: FWFT feature set flags
> + *
> + * Return: 0 on success, appropriate linux error code otherwise.
> + */
> +static inline int sbi_fwft_set_online_cpus(u32 feature, unsigned long value,
> +					   unsigned long flags)
> +{
> +	return sbi_fwft_set_cpumask(cpu_online_mask, feature, value, flags);
> +}
> +
>   /* Check if current SBI specification version is 0.1 or not */
>   static inline int sbi_spec_is_0_1(void)
>   {
> diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
> index 1d44c35305a9..d57e4dae7dac 100644
> --- a/arch/riscv/kernel/sbi.c
> +++ b/arch/riscv/kernel/sbi.c
> @@ -299,6 +299,63 @@ static int __sbi_rfence_v02(int fid, const struct cpumask *cpu_mask,
>   	return 0;
>   }
>   
> +/**
> + * sbi_fwft_set() - Set a feature on the local hart
> + * @feature: The feature ID to be set
> + * @value: The feature value to be set
> + * @flags: FWFT feature set flags
> + *
> + * Return: 0 on success, appropriate linux error code otherwise.
> + */
> +int sbi_fwft_set(u32 feature, unsigned long value, unsigned long flags)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +struct fwft_set_req {
> +	u32 feature;
> +	unsigned long value;
> +	unsigned long flags;
> +	atomic_t error;
> +};
> +
> +static void cpu_sbi_fwft_set(void *arg)
> +{
> +	struct fwft_set_req *req = arg;
> +	int ret;
> +
> +	ret = sbi_fwft_set(req->feature, req->value, req->flags);
> +	if (ret)
> +		atomic_set(&req->error, ret);
> +}
> +
> +/**
> + * sbi_fwft_set_cpumask() - Set a feature for the specified cpumask
> + * @mask: CPU mask of cpus that need the feature to be set
> + * @feature: The feature ID to be set
> + * @value: The feature value to be set
> + * @flags: FWFT feature set flags
> + *
> + * Return: 0 on success, appropriate linux error code otherwise.
> + */
> +int sbi_fwft_set_cpumask(const cpumask_t *mask, u32 feature,
> +			       unsigned long value, unsigned long flags)
> +{
> +	struct fwft_set_req req = {
> +		.feature = feature,
> +		.value = value,
> +		.flags = flags,
> +		.error = ATOMIC_INIT(0),
> +	};
> +
> +	if (feature & SBI_FWFT_GLOBAL_FEATURE_BIT)
> +		return -EINVAL;
> +
> +	on_each_cpu_mask(mask, cpu_sbi_fwft_set, &req, 1);
> +
> +	return atomic_read(&req.error);
> +}
> +
>   /**
>    * sbi_set_timer() - Program the timer for next timer event.
>    * @stime_value: The value after which next timer event should fire.

LGTM.
Reviewed-by: Atish Patra <atishp@rivosinc.com>

