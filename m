Return-Path: <kvm+bounces-22310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03C7E93D07F
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 11:40:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34AB81C21BA1
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 09:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DC541779A4;
	Fri, 26 Jul 2024 09:40:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6E7A1A286
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 09:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721986825; cv=none; b=SXt59wsbO/Hy96QZsaPeuwGh7TZLSydytcIExZFBihZRqfrGISOwGRv6o5KuoH9vyY9EA+FAxUdZ1Mreyq6IRLDMW3LCTAOfu9NNyLdsFYFEGeKISZjldw6fex8fLHFs+gARegRBCcRq5Uz4OLayu+l9f5BLC2OE6gI2M3i1x2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721986825; c=relaxed/simple;
	bh=tl831qkSJEKrTVmVzdrfOSempNG0XdzVf1H1Skbdv28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Aj42b+TtCPhiXGh01KvHunQQmfNKKzw07iHtDrLPau8o6IxcaKgfnA68tFaTZByO8GiTlDB2YD0KTF+vfgm/4e+KQXF8cc9DNY62sLKX1utDcAXm6uELfAKE0vOsT62emPi5yrGMsFrpWyr8hWkKUHCXUKSeHFbEcPZLX6liVH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D88321007;
	Fri, 26 Jul 2024 02:40:41 -0700 (PDT)
Received: from [10.57.94.37] (unknown [10.57.94.37])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60D273F5A1;
	Fri, 26 Jul 2024 02:40:15 -0700 (PDT)
Message-ID: <4f03decb-7b03-41c7-986a-63794ced7b03@arm.com>
Date: Fri, 26 Jul 2024 10:40:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 2/6] arm: Fix kerneldoc
Content-Language: en-GB
To: Nicholas Piggin <npiggin@gmail.com>, Thomas Huth <thuth@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 Subhasish Ghosh <subhasish.ghosh@arm.com>, Joey Gouly <joey.gouly@arm.com>
References: <20240726070456.467533-1-npiggin@gmail.com>
 <20240726070456.467533-3-npiggin@gmail.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240726070456.467533-3-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/07/2024 08:04, Nicholas Piggin wrote:
> Some invalid kerneldoc comments crept in while centos ci job was down.
> 
> Cc: Subhasish Ghosh <subhasish.ghosh@arm.com>
> Cc: Joey Gouly <joey.gouly@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Fixes: d47d370c8f ("arm: Add test for FPU/SIMD context save/restore")
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Thanks for the fix !

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


> ---
>   arm/fpu.c | 24 ++++++++++++------------
>   1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/arm/fpu.c b/arm/fpu.c
> index 39413fc3e..edbd9a946 100644
> --- a/arm/fpu.c
> +++ b/arm/fpu.c
> @@ -212,8 +212,8 @@ static void nr_cpu_check(int nr)
>   		report_abort("At least %d cpus required", nr);
>   }
>   
> -/**
> - * @brief check if the FPU/SIMD/SVE register contents are the same as
> +/*
> + * check if the FPU/SIMD/SVE register contents are the same as
>    * the input data provided.
>    */
>   static uint32_t __fpuregs_testall(uint64_t *indata, int sve)
> @@ -256,8 +256,8 @@ static uint32_t __fpuregs_testall(uint64_t *indata, int sve)
>   	return result;
>   }
>   
> -/**
> - * @brief writes randomly sampled data into the FPU/SIMD registers.
> +/*
> + * Write randomly sampled data into the FPU/SIMD registers.
>    */
>   static void __fpuregs_writeall_random(uint64_t **indata, int sve)
>   {
> @@ -315,9 +315,9 @@ static void sveregs_testall_run(void *data)
>   	       "SVE register save/restore mask: 0x%x", result);
>   }
>   
> -/**
> - * @brief This test uses two CPUs to test FPU/SIMD save/restore
> - * @details CPU1 writes random data into FPU/SIMD registers,
> +/*
> + * This test uses two CPUs to test FPU/SIMD save/restore
> + * CPU1 writes random data into FPU/SIMD registers,
>    * CPU0 corrupts/overwrites the data and finally CPU1 checks
>    * if the data remains unchanged in its context.
>    */
> @@ -344,9 +344,9 @@ static void fpuregs_context_switch_cpu1(int sve)
>   	free(indata_local);
>   }
>   
> -/**
> - * @brief This test uses two CPUs to test FPU/SIMD save/restore
> - * @details CPU0 writes random data into FPU/SIMD registers,
> +/*
> + * This test uses two CPUs to test FPU/SIMD save/restore
> + * CPU0 writes random data into FPU/SIMD registers,
>    * CPU1 corrupts/overwrites the data and finally CPU0 checks if
>    * the data remains unchanged in its context.
>    */
> @@ -374,7 +374,7 @@ static void fpuregs_context_switch_cpu0(int sve)
>   	free(indata_local);
>   }
>   
> -/**
> +/*
>    * Checks if during context switch, FPU/SIMD registers
>    * are saved/restored.
>    */
> @@ -384,7 +384,7 @@ static void fpuregs_context_switch(void)
>   	fpuregs_context_switch_cpu1(0);
>   }
>   
> -/**
> +/*
>    * Checks if during context switch, SVE registers
>    * are saved/restored.
>    */


