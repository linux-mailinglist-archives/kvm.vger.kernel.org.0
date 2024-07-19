Return-Path: <kvm+bounces-21938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 89DB8937A44
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFBF7B21B0D
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1421145B10;
	Fri, 19 Jul 2024 16:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EEsQa62M"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D69D13EFEE
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721404922; cv=none; b=KhRxwXBDm/yMSZ9xZVOuHPK6jFqlgd4XnLSjb4aik1iFP0VQMNSkiA4jBylFDtx94Ihye3PuGCxIuAkq9W2BUMBIoHBmwVq5r2Cnl7bP8J421sS1ufgwy01AQi1uIlfjt9p6G3su8BOYkK2ogCRBmCScu6U2E4mGm6lezNRuh8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721404922; c=relaxed/simple;
	bh=L6UA2yzrl5zJk15SJpoyIrNvk0tmTgp/ZoA6cl9uPaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ow+VEM4tOv+ZxjKMw8+blVHg//79NyHusjg6SzGx5LQJwl8qPUviu1uJsc616j/6YdWRtOat8O/AFykz7rcD/ML/VPmnVr+eD6xOtPvozFfMfSIKqsMgOB88QRZO6NEnHW/ngk7bi2LPvOE622LLDftzbI1WeCykm3nTPBaZ8d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EEsQa62M; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: jamestiotio@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721404918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ef2hx7VgTqugeo2l1Hev3sOM3KxfZgnaZaXHCMfScA0=;
	b=EEsQa62Mki0EU56Tak4wdpH3I8X8BcEzztWIMa/eB5wOuXITKazBZrikjqNmfjpR3tdW6X
	XHCHDZaJ5D+SIEVGa5OKBJ7P+rDmCdz/AgVuoOi8pmBtvopDyT6deFZMnFbKbHB1xt0YyH
	fImL/fZj/nAn6xoaCTPHjEfFyrgZ1iw=
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: kvm-riscv@lists.infradead.org
X-Envelope-To: atishp@rivosinc.com
X-Envelope-To: cade.richard@berkeley.edu
Date: Fri, 19 Jul 2024 11:01:54 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: James Raphael Tiovalen <jamestiotio@gmail.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	atishp@rivosinc.com, cade.richard@berkeley.edu
Subject: Re: [kvm-unit-tests PATCH v3 4/5] riscv: Add some delay and timer
 routines
Message-ID: <20240719-6c52d81961903ebb65f45784@orel>
References: <20240719023947.112609-1-jamestiotio@gmail.com>
 <20240719023947.112609-5-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240719023947.112609-5-jamestiotio@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 19, 2024 at 10:39:46AM GMT, James Raphael Tiovalen wrote:
> Add a delay method that would allow tests to wait for some specified
> number of cycles. Also add a conversion helper method between
> microseconds and cycles. This conversion is done by using the timebase
> frequency, which is obtained during setup via the device tree.
> 
> Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
> ---
>  riscv/Makefile        |  2 ++
>  lib/riscv/asm/csr.h   |  1 +
>  lib/riscv/asm/delay.h | 15 +++++++++++++++
>  lib/riscv/asm/setup.h |  1 +
>  lib/riscv/asm/timer.h | 14 ++++++++++++++
>  lib/riscv/delay.c     | 16 ++++++++++++++++
>  lib/riscv/setup.c     |  4 ++++
>  lib/riscv/timer.c     | 26 ++++++++++++++++++++++++++
>  8 files changed, 79 insertions(+)
>  create mode 100644 lib/riscv/asm/delay.h
>  create mode 100644 lib/riscv/asm/timer.h
>  create mode 100644 lib/riscv/delay.c
>  create mode 100644 lib/riscv/timer.c
> 
> diff --git a/riscv/Makefile b/riscv/Makefile
> index 919a3ebb..b0cd613f 100644
> --- a/riscv/Makefile
> +++ b/riscv/Makefile
> @@ -30,6 +30,7 @@ cflatobjs += lib/memregions.o
>  cflatobjs += lib/on-cpus.o
>  cflatobjs += lib/vmalloc.o
>  cflatobjs += lib/riscv/bitops.o
> +cflatobjs += lib/riscv/delay.o
>  cflatobjs += lib/riscv/io.o
>  cflatobjs += lib/riscv/isa.o
>  cflatobjs += lib/riscv/mmu.o
> @@ -38,6 +39,7 @@ cflatobjs += lib/riscv/sbi.o
>  cflatobjs += lib/riscv/setup.o
>  cflatobjs += lib/riscv/smp.o
>  cflatobjs += lib/riscv/stack.o
> +cflatobjs += lib/riscv/timer.o
>  ifeq ($(ARCH),riscv32)
>  cflatobjs += lib/ldiv32.o
>  endif
> diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
> index ba810c9f..a9b1bd42 100644
> --- a/lib/riscv/asm/csr.h
> +++ b/lib/riscv/asm/csr.h
> @@ -10,6 +10,7 @@
>  #define CSR_SCAUSE		0x142
>  #define CSR_STVAL		0x143
>  #define CSR_SATP		0x180
> +#define CSR_TIME		0xc01
>  
>  #define SR_SIE			_AC(0x00000002, UL)
>  
> diff --git a/lib/riscv/asm/delay.h b/lib/riscv/asm/delay.h
> new file mode 100644
> index 00000000..ce540f4c
> --- /dev/null
> +++ b/lib/riscv/asm/delay.h
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _ASMRISCV_DELAY_H_
> +#define _ASMRISCV_DELAY_H_
> +
> +#include <libcflat.h>
> +#include <asm/setup.h>
> +
> +extern void delay(u64 cycles);
> +
> +static inline uint64_t usec_to_cycles(uint64_t usec)
> +{
> +	return (timebase_frequency * usec) / 1000000;
> +}
> +
> +#endif /* _ASMRISCV_DELAY_H_ */
> diff --git a/lib/riscv/asm/setup.h b/lib/riscv/asm/setup.h
> index 7f81a705..a13159bf 100644
> --- a/lib/riscv/asm/setup.h
> +++ b/lib/riscv/asm/setup.h
> @@ -7,6 +7,7 @@
>  #define NR_CPUS 16
>  extern struct thread_info cpus[NR_CPUS];
>  extern int nr_cpus;
> +extern uint64_t timebase_frequency;
>  int hartid_to_cpu(unsigned long hartid);
>  
>  void io_init(void);
> diff --git a/lib/riscv/asm/timer.h b/lib/riscv/asm/timer.h
> new file mode 100644
> index 00000000..2e319391
> --- /dev/null
> +++ b/lib/riscv/asm/timer.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _ASMRISCV_TIMER_H_
> +#define _ASMRISCV_TIMER_H_
> +
> +#include <asm/csr.h>
> +
> +extern void timer_get_frequency(const void *fdt);

This shouldn't take an fdt pointer as input since it should also work for
ACPI. And, it doesn't need the fdt pointer since everything can get the
pointer with dt_fdt() if it needs it.

> +
> +static inline uint64_t timer_get_cycles(void)
> +{
> +	return csr_read(CSR_TIME);
> +}
> +
> +#endif /* _ASMRISCV_TIMER_H_ */
> diff --git a/lib/riscv/delay.c b/lib/riscv/delay.c
> new file mode 100644
> index 00000000..6b5c78da
> --- /dev/null
> +++ b/lib/riscv/delay.c
> @@ -0,0 +1,16 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
> + */
> +#include <libcflat.h>
> +#include <asm/barrier.h>
> +#include <asm/delay.h>
> +#include <asm/timer.h>
> +
> +void delay(uint64_t cycles)
> +{
> +	uint64_t start = timer_get_cycles();
> +
> +	while ((timer_get_cycles() - start) < cycles)
> +		cpu_relax();
> +}
> diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
> index 50ffb0d0..905ea708 100644
> --- a/lib/riscv/setup.c
> +++ b/lib/riscv/setup.c
> @@ -20,6 +20,7 @@
>  #include <asm/page.h>
>  #include <asm/processor.h>
>  #include <asm/setup.h>
> +#include <asm/timer.h>
>  
>  #define VA_BASE			((phys_addr_t)3 * SZ_1G)
>  #if __riscv_xlen == 64
> @@ -38,6 +39,7 @@ u32 initrd_size;
>  
>  struct thread_info cpus[NR_CPUS];
>  int nr_cpus;
> +uint64_t timebase_frequency;
>  
>  static struct mem_region riscv_mem_regions[NR_MEM_REGIONS + 1];
>  
> @@ -199,6 +201,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
>  
>  	mem_init(PAGE_ALIGN(__pa(freemem)));
>  	cpu_init();
> +	timer_get_frequency(dt_fdt());
>  	thread_info_init();
>  	io_init();
>  
> @@ -264,6 +267,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>  	}
>  
>  	cpu_init();
> +	timer_get_frequency(dt_fdt());
>  	thread_info_init();
>  	io_init();
>  	initrd_setup();
> diff --git a/lib/riscv/timer.c b/lib/riscv/timer.c
> new file mode 100644
> index 00000000..db8dbb36
> --- /dev/null
> +++ b/lib/riscv/timer.c
> @@ -0,0 +1,26 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
> + */
> +#include <libcflat.h>
> +#include <devicetree.h>
> +#include <asm/setup.h>
> +#include <asm/timer.h>
> +
> +void timer_get_frequency(const void *fdt)
> +{
> +	const struct fdt_property *prop;
> +	u32 *data;
> +	int cpus;
> +
> +	assert_msg(dt_available(), "ACPI not yet supported");
> +
> +	cpus = fdt_path_offset(fdt, "/cpus");
> +	assert(cpus >= 0);
> +
> +	prop = fdt_get_property(fdt, cpus, "timebase-frequency", NULL);
> +	assert(prop != NULL);

I usually also pass &len to fdt_get_property and then assert that the
length matches my expectations.

> +
> +	data = (u32 *)prop->data;
> +	timebase_frequency = fdt32_to_cpu(*data);
> +}
> -- 
> 2.43.0
>

This patch looks great. With the two changes,

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew

