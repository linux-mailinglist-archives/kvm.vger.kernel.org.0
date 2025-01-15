Return-Path: <kvm+bounces-35531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D978A12384
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 13:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FA16165A94
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 12:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A560A1EEA56;
	Wed, 15 Jan 2025 12:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Cm03brpP"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AB52475F3
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 12:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736942826; cv=none; b=awa2yphZMIh2YjyeyQXldkwsbH7Y6NpLFHJLBl4dyXFtwzVsSQgIepj6R51QgTidstwUz/WkmjEusydz5+DpQLSWluNDqZiIN7GEclNkQq87qqz+R2WVkhB90G2omWT+o+OKei/l0uG/n1PIZIi93mOnnVdgry2wKOSJqZCJKp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736942826; c=relaxed/simple;
	bh=IW6i5s+Syx1xSgSnZwDsNVWWh5m59kYxZjmHJjxMLr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Awv0XH2YLePLFWYQZFW40pEPMrauS/8CviJin0krWCBQbMfdcaXPEui+nSSM1VDH3HE2IEExM0DSXI4S44M7KI59xuJ1FwLt4zySYcdV+9BRecQ8fiCbo4dL7GA4pAKrXlyiEv5F7jnthuabK+l9gpBCD3Q9zKCGbIQpNqFskn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Cm03brpP; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 15 Jan 2025 13:06:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736942819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YgbdkOgeyzusvyB+fsODM0Lt17XNh/jVvw1SWNs3Ews=;
	b=Cm03brpPU/LBmoQmOIqyEP6Vq6uSpPAh79322F1zgs82gwppERqu5mp858ZQhwHrsspdwj
	7FVoX2tYKDh/6ixmcg/6dfesVeumHSIl3TwaduIXNSDBi4dUuTzEWyhEkiuK6dqOL2VghI
	kWxH6fZ7w1CqhKToOOGjbLlUyLOOr0c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <apatel@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [kvm-unit-tests PATCH v6 4/5] riscv: lib: Add SBI SSE extension
 definitions
Message-ID: <20250115-ce8e8a312ade5e6c362d514d@orel>
References: <20250110111247.2963146-1-cleger@rivosinc.com>
 <20250110111247.2963146-5-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250110111247.2963146-5-cleger@rivosinc.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 10, 2025 at 12:12:43PM +0100, Clément Léger wrote:
> Add SBI SSE extension definitions in sbi.h
> 
> Signed-off-by: Clément Léger <cleger@rivosinc.com>
> ---
>  lib/riscv/asm/sbi.h | 89 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 89 insertions(+)
> 
> diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
> index 98a9b097..83bdfb82 100644
> --- a/lib/riscv/asm/sbi.h
> +++ b/lib/riscv/asm/sbi.h
> @@ -11,6 +11,11 @@
>  #define SBI_ERR_ALREADY_AVAILABLE	-6
>  #define SBI_ERR_ALREADY_STARTED		-7
>  #define SBI_ERR_ALREADY_STOPPED		-8
> +#define SBI_ERR_NO_SHMEM		-9
> +#define SBI_ERR_INVALID_STATE		-10
> +#define SBI_ERR_BAD_RANGE		-11
> +#define SBI_ERR_TIMEOUT			-12
> +#define SBI_ERR_IO			-13

We need SBI_ERR_DENIED_LOCKED too, but I guess that can be added with the
FWFT extension.

>  
>  #ifndef __ASSEMBLY__
>  #include <cpumask.h>
> @@ -23,6 +28,7 @@ enum sbi_ext_id {
>  	SBI_EXT_SRST = 0x53525354,
>  	SBI_EXT_DBCN = 0x4442434E,
>  	SBI_EXT_SUSP = 0x53555350,
> +	SBI_EXT_SSE = 0x535345,
>  };
>  
>  enum sbi_ext_base_fid {
> @@ -71,6 +77,89 @@ enum sbi_ext_dbcn_fid {
>  	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE,
>  };
>  
> +enum sbi_ext_sse_fid {
> +	SBI_EXT_SSE_READ_ATTRS = 0,
> +	SBI_EXT_SSE_WRITE_ATTRS,
> +	SBI_EXT_SSE_REGISTER,
> +	SBI_EXT_SSE_UNREGISTER,
> +	SBI_EXT_SSE_ENABLE,
> +	SBI_EXT_SSE_DISABLE,
> +	SBI_EXT_SSE_COMPLETE,
> +	SBI_EXT_SSE_INJECT,
> +	SBI_EXT_SSE_HART_UNMASK,
> +	SBI_EXT_SSE_HART_MASK,
> +};
> +
> +/* SBI SSE Event Attributes. */
> +enum sbi_sse_attr_id {
> +	SBI_SSE_ATTR_STATUS		= 0x00000000,
> +	SBI_SSE_ATTR_PRIORITY		= 0x00000001,
> +	SBI_SSE_ATTR_CONFIG		= 0x00000002,
> +	SBI_SSE_ATTR_PREFERRED_HART	= 0x00000003,
> +	SBI_SSE_ATTR_ENTRY_PC		= 0x00000004,
> +	SBI_SSE_ATTR_ENTRY_ARG		= 0x00000005,
> +	SBI_SSE_ATTR_INTERRUPTED_SEPC	= 0x00000006,
> +	SBI_SSE_ATTR_INTERRUPTED_FLAGS	= 0x00000007,
> +	SBI_SSE_ATTR_INTERRUPTED_A6	= 0x00000008,
> +	SBI_SSE_ATTR_INTERRUPTED_A7	= 0x00000009,
> +};
> +
> +#define SBI_SSE_ATTR_STATUS_STATE_OFFSET	0
> +#define SBI_SSE_ATTR_STATUS_STATE_MASK		0x3
> +#define SBI_SSE_ATTR_STATUS_PENDING_OFFSET	2
> +#define SBI_SSE_ATTR_STATUS_INJECT_OFFSET	3
> +
> +#define SBI_SSE_ATTR_CONFIG_ONESHOT		BIT(0)
> +
> +#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPP	BIT(0)
> +#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_SSTATUS_SPIE	BIT(1)
> +#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPV	BIT(2)
> +#define SBI_SSE_ATTR_INTERRUPTED_FLAGS_HSTATUS_SPVP	BIT(3)
> +
> +enum sbi_sse_state {
> +	SBI_SSE_STATE_UNUSED		= 0,
> +	SBI_SSE_STATE_REGISTERED	= 1,
> +	SBI_SSE_STATE_ENABLED		= 2,
> +	SBI_SSE_STATE_RUNNING		= 3,
> +};
> +
> +/* SBI SSE Event IDs. */
> +/* Range 0x00000000 - 0x0000ffff */
> +#define SBI_SSE_EVENT_LOCAL_HIGH_PRIO_RAS	0x00000000
> +#define SBI_SSE_EVENT_LOCAL_DOUBLE_TRAP		0x00000001
> +#define SBI_SSE_EVENT_LOCAL_PLAT_0_START	0x00004000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_0_END		0x00007fff
> +
> +#define SBI_SSE_EVENT_GLOBAL_HIGH_PRIO_RAS	0x00008000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_0_START	0x0000c000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_0_END		0x0000ffff
> +
> +/* Range 0x00010000 - 0x0001ffff */
> +#define SBI_SSE_EVENT_LOCAL_PMU_OVERFLOW	0x00010000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_1_START	0x00014000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_1_END		0x00017fff
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_1_START	0x0001c000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_1_END		0x0001ffff
> +
> +/* Range 0x00100000 - 0x0010ffff */
> +#define SBI_SSE_EVENT_LOCAL_LOW_PRIO_RAS	0x00100000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_2_START	0x00104000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_2_END		0x00107fff
> +#define SBI_SSE_EVENT_GLOBAL_LOW_PRIO_RAS	0x00108000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_2_START	0x0010c000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_2_END		0x0010ffff
> +
> +/* Range 0xffff0000 - 0xffffffff */
> +#define SBI_SSE_EVENT_LOCAL_SOFTWARE		0xffff0000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_3_START	0xffff4000
> +#define SBI_SSE_EVENT_LOCAL_PLAT_3_END		0xffff7fff
> +#define SBI_SSE_EVENT_GLOBAL_SOFTWARE		0xffff8000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_3_START	0xffffc000
> +#define SBI_SSE_EVENT_GLOBAL_PLAT_3_END		0xffffffff
> +
> +#define SBI_SSE_EVENT_PLATFORM_BIT		BIT(14)
> +#define SBI_SSE_EVENT_GLOBAL_BIT		BIT(15)
> +
>  struct sbiret {
>  	long error;
>  	long value;
> -- 
> 2.47.1
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

