Return-Path: <kvm+bounces-45995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0932AB06FE
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 02:19:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D83611B67959
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 00:19:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB0ADCA5A;
	Fri,  9 May 2025 00:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iGazSvdg"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B3E5383
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 00:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746749946; cv=none; b=rHRR6ZlpBXyC7SHh2a60Y9WQLfLkS446ZqW54h/JgHXdexhlTABCoAeO4IG5b3s0IsF1vwExIMVW64hRUOpF0yimWlwL7Pi01inhynjjnPNsePKaZ3l3imBdGGxx4ubKubdqkEbqpldaZdn1+41TGMbQC7RJIJ7NaAxaFky17No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746749946; c=relaxed/simple;
	bh=BSAj4lCq7Pqars/QUd4bvA45uXjzmpaXuylFWd1d05k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W9l62+cbMXOUKkVEUGv5OVGGrCX9El0tqqt4ULgVo37kzoZWMS4ZVI//3/1eMmo0o42YQeZ7fEkSgJCsesjcgM0slwLbggi3cr0ixarUJWmnNB3bdgQco8MNfc5Ol6fxlxxAp5T/HndnCRCeTxC0FGrvu7vEUtRz64/oIxy4ko8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iGazSvdg; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <1c385a47-0a01-4be4-a34b-51a2f168e62d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746749938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=679XepidSuycXdyfHp1BFAWMxdV4mUKMvIzi7W0Gi8k=;
	b=iGazSvdg0UerSGY5LF35krrRvhHcszcHHCCUdhyeSjPnV2j9Oeq51+LHgh5lsVUidMzbqM
	+QsPiJo6mZKRzX3YVarn3vwbPVp3eEb3ChrYDnp7GfUjBYH90wQwN4EAVZjBi5K9UkmDO2
	uwG8hwhmMaUG8Hkhfztpvpw9H95BPt8=
Date: Thu, 8 May 2025 17:18:51 -0700
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

What happens when cpuX executed first reported an error but cpuY 
executed this function later and report success.

The error will be masked in that case.

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


