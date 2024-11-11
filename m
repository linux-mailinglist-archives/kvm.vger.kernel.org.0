Return-Path: <kvm+bounces-31458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6F289C3E57
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 13A0EB23A48
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 12:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 116E819C575;
	Mon, 11 Nov 2024 12:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qHKCrDgM"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1250414B962
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 12:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731327450; cv=none; b=e+vv7QsNi+S+Azk+YWH44OQDaaF5srOYjbfXM4Uiy1WjFpQX3MpR+BeX8IJqeUATtQ32NxRMuJWh+uHHL8xciylxjuPwE7EQGOYFj5zkzkmjHNVBqXrg2Vj5zt+ipI347n2E+J+uBtOBIk/1Us1qtAhjVfVDYYXGyuTvN/2Yu0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731327450; c=relaxed/simple;
	bh=g6SKv+KGmiToOpSOW70w2oK6F10rxh/i2xEFxQZ1Nak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hWtCV48IFPsvf7errj+OLCvEDBB6RgSCS+gMDbC1OPVLjMR/eID6M/PIxvhGBMjEPJSi2FXp4AvmV51BkBx3sQKwVm2YI/B6RIUa3Dlcx7R23ifGkHrOiDWMZJ/4HgpSBlsse43g778tcKJmSZsakHPuAV190CgDQEFzJGki3i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qHKCrDgM; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 11 Nov 2024 13:17:20 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731327443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XEvbYM67PS1JefvHPj6QyT8RxAqQSakrmK54vHjF5G4=;
	b=qHKCrDgMs1rNbaHO9ToVrBlpiORwlZkhBYnxoyY4/VpK1yEOwOo25MA9kYX/vVnUv8ohiO
	fjYZOcuziQyJccsh+iD+JCYQHMGjHFax+DDa+7c6xf+AOeT/3YoJcH6YpygpQwOGuG/ARS
	eLKnHkN3Cao2V57Fw9zFTAJCgRJGHaM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v7 1/2] riscv: sbi: Fix entry point of HSM
 tests
Message-ID: <20241111-96decb7aba5f6ec9ececc531@orel>
References: <20241110171633.113515-1-jamestiotio@gmail.com>
 <20241110171633.113515-2-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241110171633.113515-2-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 11, 2024 at 01:16:32AM +0800, James Raphael Tiovalen wrote:
> With the current trick of setting opaque as hartid, the HSM tests would
> not be able to catch a bug where a0 is set to opaque and a1 is set to
> hartid. Fix this issue by setting a1 to an array with some magic number
> as the first element and hartid as the second element, following the
> behavior of the SUSP tests.
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  riscv/sbi-tests.h | 13 ++++++++++---
>  riscv/sbi-asm.S   | 33 +++++++++++++++++++--------------
>  riscv/sbi.c       |  1 +
>  3 files changed, 30 insertions(+), 17 deletions(-)
> 
> diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
> index d0a7561a..162f0d53 100644
> --- a/riscv/sbi-tests.h
> +++ b/riscv/sbi-tests.h
> @@ -9,9 +9,16 @@
>  #define SBI_CSR_SATP_IDX	4
>  
>  #define SBI_HSM_TEST_DONE	(1 << 0)
> -#define SBI_HSM_TEST_HARTID_A1	(1 << 1)
> -#define SBI_HSM_TEST_SATP	(1 << 2)
> -#define SBI_HSM_TEST_SIE	(1 << 3)
> +#define SBI_HSM_TEST_MAGIC_A1	(1 << 1)
> +#define SBI_HSM_TEST_HARTID_A1	(1 << 2)

This should renamed to SBI_HSM_TEST_HARTID_A0

> +#define SBI_HSM_TEST_SATP	(1 << 3)
> +#define SBI_HSM_TEST_SIE	(1 << 4)
> +
> +#define SBI_HSM_MAGIC		0x453
> +
> +#define SBI_HSM_MAGIC_IDX	0
> +#define SBI_HSM_HARTID_IDX	1
> +#define SBI_HSM_NUM_OF_PARAMS	2
>  
>  #define SBI_SUSP_TEST_SATP	(1 << 0)
>  #define SBI_SUSP_TEST_SIE	(1 << 1)
> diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
> index e871ea50..9ac77c5c 100644
> --- a/riscv/sbi-asm.S
> +++ b/riscv/sbi-asm.S
> @@ -30,34 +30,39 @@
>  .balign 4
>  sbi_hsm_check:
>  	li	HSM_RESULTS_MAP, 0
> -	bne	a0, a1, 1f
> +	REG_L	t0, ASMARR(a1, SBI_HSM_MAGIC_IDX)
> +	li	t1, SBI_HSM_MAGIC
> +	bne	t0, t1, 1f
> +	ori	HSM_RESULTS_MAP, HSM_RESULTS_MAP, SBI_HSM_TEST_MAGIC_A1
> +1:	REG_L	t0, ASMARR(a1, SBI_HSM_HARTID_IDX)
> +	bne	a0, t0, 2f
>  	ori	HSM_RESULTS_MAP, HSM_RESULTS_MAP, SBI_HSM_TEST_HARTID_A1
> -1:	csrr	t0, CSR_SATP
> -	bnez	t0, 2f
> +2:	csrr	t0, CSR_SATP
> +	bnez	t0, 3f
>  	ori	HSM_RESULTS_MAP, HSM_RESULTS_MAP, SBI_HSM_TEST_SATP
> -2:	csrr	t0, CSR_SSTATUS
> +3:	csrr	t0, CSR_SSTATUS
>  	andi	t0, t0, SR_SIE
> -	bnez	t0, 3f
> +	bnez	t0, 4f
>  	ori	HSM_RESULTS_MAP, HSM_RESULTS_MAP, SBI_HSM_TEST_SIE
> -3:	call	hartid_to_cpu
> +4:	call	hartid_to_cpu
>  	mv	HSM_CPU_INDEX, a0
>  	li	t0, -1
> -	bne	HSM_CPU_INDEX, t0, 5f
> -4:	pause
> -	j	4b
> -5:	ori	HSM_RESULTS_MAP, HSM_RESULTS_MAP, SBI_HSM_TEST_DONE
> +	bne	HSM_CPU_INDEX, t0, 6f
> +5:	pause
> +	j	5b
> +6:	ori	HSM_RESULTS_MAP, HSM_RESULTS_MAP, SBI_HSM_TEST_DONE
>  	add	t0, HSM_RESULTS_ARRAY, HSM_CPU_INDEX
>  	sb	HSM_RESULTS_MAP, 0(t0)
>  	la	t1, sbi_hsm_stop_hart
>  	add	t1, t1, HSM_CPU_INDEX
> -6:	lb	t0, 0(t1)
> +7:	lb	t0, 0(t1)
>  	pause
> -	beqz	t0, 6b
> +	beqz	t0, 7b
>  	li	a7, 0x48534d	/* SBI_EXT_HSM */
>  	li	a6, 1		/* SBI_EXT_HSM_HART_STOP */
>  	ecall
> -7:	pause
> -	j	7b
> +8:	pause
> +	j	8b
>  
>  .balign 4
>  .global sbi_hsm_check_hart_start
> diff --git a/riscv/sbi.c b/riscv/sbi.c
> index 6f2d3e35..300e5cc9 100644
> --- a/riscv/sbi.c
> +++ b/riscv/sbi.c
> @@ -483,6 +483,7 @@ static void check_ipi(void)
>  unsigned char sbi_hsm_stop_hart[NR_CPUS];
>  unsigned char sbi_hsm_hart_start_checks[NR_CPUS];
>  unsigned char sbi_hsm_non_retentive_hart_suspend_checks[NR_CPUS];
> +unsigned long sbi_hsm_hart_start_params[NR_CPUS * SBI_HSM_NUM_OF_PARAMS];

This isn't shared with sbi-asm.S so it doesn't need to be global.

>  
>  #define DBCN_WRITE_TEST_STRING		"DBCN_WRITE_TEST_STRING\n"
>  #define DBCN_WRITE_BYTE_TEST_BYTE	((u8)'a')
> -- 
> 2.43.0
>

Thanks,
drew

