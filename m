Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B0A36660B
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 09:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbhDUHDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 03:03:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38816 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236429AbhDUHDS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 03:03:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618988563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=joz1D12trxVPCmLkuOCJdSehg5ak4DFNN0V29OjrZhw=;
        b=dNW5diAKtz3UpbC8c7B5t4or022loYl42gfFrt8NRoMOiKHptdTPu4M8pKrz73vPUc8GLs
        wf3bg5bfo+j0ukVViDF4V5z3tLVG5g2ZGN9QT/Z1buE04FS8emBJolTDduqXyPzNvxZunl
        uOSpQj5ReuBTdVlhgR/MoxjryJZdKDM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-HrNTgrwfMT-ZNFCNS3A4vQ-1; Wed, 21 Apr 2021 03:02:11 -0400
X-MC-Unique: HrNTgrwfMT-ZNFCNS3A4vQ-1
Received: by mail-ej1-f72.google.com with SMTP id j25-20020a1709060519b029037cb8ca241aso5542777eja.19
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 00:02:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=joz1D12trxVPCmLkuOCJdSehg5ak4DFNN0V29OjrZhw=;
        b=So6tPohuKdIRHPvLFM6B4F1c0ydTEwKauKiwaSWfDsdtMOIS3eBNGfrUEcqZLh6iTk
         /FjQUFUHfvJQgcO4BLcS8Wf4Nc5L5Slgrqxw0vlTnb97EWRlaDK6KuuqjWCJgX/O1G85
         oFcaBh982OaUA35Xv4VmzPEUKBTceFXq0NMdZT32Gaa1TIOBLOk7sA0ZCZXjOgrVoJEf
         gIsjLvIkCWZKhmET2+dfIx5GCvTdxDjlGp0BBAhNIyV9G2O/GPN6hj5G5QQejaczd0Zf
         I0Wztw6nTVpVlZWRNSPqjQo3k+775fXfpM0lS2fJJHoSe5Esngcuj9gDukv5o3uSaPTm
         qhYg==
X-Gm-Message-State: AOAM530/Itd80zr9luN2ioSSh6ddeFcXyY5s64rRc0Z9xRgwNpOfupwJ
        AeZvOlDPmZAC47CPWintdc9yKA7zhiXl5nUHAWPibONinS/2WPdH+canyb0KK9DL1LcvfMVqlpr
        VcKKmi01i+A4bNGD3lIjMayxtvhe0o6zFlp5kzNb8VT2N11g9wO9KQc9vks+9oUg=
X-Received: by 2002:a05:6402:1cc1:: with SMTP id ds1mr35472629edb.135.1618988530155;
        Wed, 21 Apr 2021 00:02:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBuY2lC5RxiExSLmog/1JDMoZ2NJHFq7GOS6dKP1VgumN8IJB9TnDry55LntDDteUC7E6oJw==
X-Received: by 2002:a05:6402:1cc1:: with SMTP id ds1mr35472588edb.135.1618988529847;
        Wed, 21 Apr 2021 00:02:09 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id n14sm1339740ejy.90.2021.04.21.00.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 00:02:08 -0700 (PDT)
Date:   Wed, 21 Apr 2021 09:02:06 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests v2 8/8] arm/arm64: psci: don't assume
 method is hvc
Message-ID: <20210421070206.mbtarb4cge5ywyuv@gator.home>
References: <20210420190002.383444-1-drjones@redhat.com>
 <20210420190002.383444-9-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420190002.383444-9-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021 at 09:00:02PM +0200, Andrew Jones wrote:
> The method can also be smc and it will be when running on bare metal.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/cstart.S       | 22 ++++++++++++++++++++++
>  arm/cstart64.S     | 22 ++++++++++++++++++++++
>  arm/selftest.c     | 34 +++++++---------------------------
>  lib/arm/asm/psci.h | 10 ++++++++--
>  lib/arm/psci.c     | 37 +++++++++++++++++++++++++++++--------
>  lib/arm/setup.c    |  2 ++
>  6 files changed, 90 insertions(+), 37 deletions(-)
> 
> diff --git a/arm/cstart.S b/arm/cstart.S
> index 446966de350d..2401d92cdadc 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -95,6 +95,28 @@ start:
>  
>  .text
>  
> +/*
> + * psci_invoke_hvc / psci_invoke_smc
> + *
> + * Inputs:
> + *   r0 -- function_id
> + *   r1 -- arg0
> + *   r2 -- arg1
> + *   r3 -- arg2
> + *
> + * Outputs:
> + *   r0 -- return code
> + */
> +.globl psci_invoke_hvc
> +psci_invoke_hvc:
> +	hvc	#0
> +	mov	pc, lr
> +
> +.globl psci_invoke_smc
> +psci_invoke_smc:
> +	smc	#0
> +	mov	pc, lr
> +
>  enable_vfp:
>  	/* Enable full access to CP10 and CP11: */
>  	mov	r0, #(3 << 22 | 3 << 20)
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 42ba3a3ca249..7610e28f06dd 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -109,6 +109,28 @@ start:
>  
>  .text
>  
> +/*
> + * psci_invoke_hvc / psci_invoke_smc
> + *
> + * Inputs:
> + *   x0 -- function_id
> + *   x1 -- arg0
> + *   x2 -- arg1
> + *   x3 -- arg2
> + *
> + * Outputs:
> + *   x0 -- return code
> + */
> +.globl psci_invoke_hvc
> +psci_invoke_hvc:
> +	hvc	#0
> +	ret
> +
> +.globl psci_invoke_smc
> +psci_invoke_smc:
> +	smc	#0
> +	ret
> +
>  get_mmu_off:
>  	adrp	x0, auxinfo
>  	ldr	x0, [x0, :lo12:auxinfo + 8]
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 4495b161cdd5..9f459ed3d571 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -400,33 +400,13 @@ static void check_vectors(void *arg __unused)
>  	exit(report_summary());
>  }
>  
> -static bool psci_check(void)
> +static void psci_print(void)
>  {
> -	const struct fdt_property *method;
> -	int node, len, ver;
> -
> -	node = fdt_node_offset_by_compatible(dt_fdt(), -1, "arm,psci-0.2");
> -	if (node < 0) {
> -		printf("PSCI v0.2 compatibility required\n");
> -		return false;
> -	}
> -
> -	method = fdt_get_property(dt_fdt(), node, "method", &len);
> -	if (method == NULL) {
> -		printf("bad psci device tree node\n");
> -		return false;
> -	}
> -
> -	if (len < 4 || strcmp(method->data, "hvc") != 0) {
> -		printf("psci method must be hvc\n");
> -		return false;
> -	}
> -
> -	ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
> -	printf("PSCI version %d.%d\n", PSCI_VERSION_MAJOR(ver),
> -				       PSCI_VERSION_MINOR(ver));
> -
> -	return true;
> +	int ver = psci_invoke(PSCI_0_2_FN_PSCI_VERSION, 0, 0, 0);
> +	report_info("PSCI version: %d.%d", PSCI_VERSION_MAJOR(ver),
> +					  PSCI_VERSION_MINOR(ver));
> +	report_info("PSCI method: %s", psci_invoke == psci_invoke_hvc ?
> +				       "hvc" : "smc");
>  }
>  
>  static void cpu_report(void *data __unused)
> @@ -465,7 +445,7 @@ int main(int argc, char **argv)
>  
>  	} else if (strcmp(argv[1], "smp") == 0) {
>  
> -		report(psci_check(), "PSCI version");
> +		psci_print();
>  		on_cpus(cpu_report, NULL);
>  		while (!cpumask_full(&ready))
>  			cpu_relax();
> diff --git a/lib/arm/asm/psci.h b/lib/arm/asm/psci.h
> index 7b956bf5987d..2820c0a3afc7 100644
> --- a/lib/arm/asm/psci.h
> +++ b/lib/arm/asm/psci.h
> @@ -3,8 +3,14 @@
>  #include <libcflat.h>
>  #include <linux/psci.h>
>  
> -extern int psci_invoke(unsigned long function_id, unsigned long arg0,
> -		       unsigned long arg1, unsigned long arg2);
> +typedef int (*psci_invoke_fn)(unsigned long function_id, unsigned long arg0,
> +			      unsigned long arg1, unsigned long arg2);
> +extern psci_invoke_fn psci_invoke;
> +extern int psci_invoke_hvc(unsigned long function_id, unsigned long arg0,
> +			   unsigned long arg1, unsigned long arg2);
> +extern int psci_invoke_smc(unsigned long function_id, unsigned long arg0,
> +			   unsigned long arg1, unsigned long arg2);

Hmm, I forgot to change function_id to 'unsigned int'.

> +extern void psci_set_conduit(void);
>  extern int psci_cpu_on(unsigned long cpuid, unsigned long entry_point);
>  extern void psci_system_reset(void);
>  extern int cpu_psci_cpu_boot(unsigned int cpu);
> diff --git a/lib/arm/psci.c b/lib/arm/psci.c
> index 936c83948b6a..168786dcf792 100644
> --- a/lib/arm/psci.c
> +++ b/lib/arm/psci.c
> @@ -6,22 +6,23 @@
>   *
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> +#include <devicetree.h>
>  #include <asm/psci.h>
>  #include <asm/setup.h>
>  #include <asm/page.h>
>  #include <asm/smp.h>
>  
> -__attribute__((noinline))
> -int psci_invoke(unsigned long function_id, unsigned long arg0,
> -		unsigned long arg1, unsigned long arg2)
> +extern void halt(void);

And, this is a left over from an earlier version of psci_invoke_none.

Will fix these things for v3.

> +
> +static int psci_invoke_none(unsigned long function_id, unsigned long arg0,
> +			    unsigned long arg1, unsigned long arg2)
>  {
> -	asm volatile(
> -		"hvc #0"
> -	: "+r" (function_id)
> -	: "r" (arg0), "r" (arg1), "r" (arg2));
> -	return function_id;
> +	printf("No PSCI method configured! Can't invoke...\n");
> +	return PSCI_RET_NOT_PRESENT;
>  }
>  
> +psci_invoke_fn psci_invoke = psci_invoke_none;
> +
>  int psci_cpu_on(unsigned long cpuid, unsigned long entry_point)
>  {
>  #ifdef __arm__
> @@ -56,3 +57,23 @@ void psci_system_off(void)
>  	int err = psci_invoke(PSCI_0_2_FN_SYSTEM_OFF, 0, 0, 0);
>  	printf("CPU%d unable to do system off (error = %d)\n", smp_processor_id(), err);
>  }
> +
> +void psci_set_conduit(void)
> +{
> +	const void *fdt = dt_fdt();
> +	const struct fdt_property *method;
> +	int node, len;
> +
> +	node = fdt_node_offset_by_compatible(fdt, -1, "arm,psci-0.2");
> +	assert_msg(node >= 0, "PSCI v0.2 compatibility required");
> +
> +	method = fdt_get_property(fdt, node, "method", &len);
> +	assert(method != NULL && len == 4);
> +
> +	if (strcmp(method->data, "hvc") == 0)
> +		psci_invoke = psci_invoke_hvc;
> +	else if (strcmp(method->data, "smc") == 0)
> +		psci_invoke = psci_invoke_smc;
> +	else
> +		assert_msg(false, "Unknown PSCI conduit: %s", method->data);
> +}
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index a5ebec3c5a12..07d52d2e5fe6 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -25,6 +25,7 @@
>  #include <asm/processor.h>
>  #include <asm/smp.h>
>  #include <asm/timer.h>
> +#include <asm/psci.h>
>  
>  #include "io.h"
>  
> @@ -266,6 +267,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
>  	mem_regions_add_assumed();
>  	mem_init(PAGE_ALIGN((unsigned long)freemem));
>  
> +	psci_set_conduit();
>  	cpu_init();
>  
>  	/* cpu_init must be called before thread_info_init */
> -- 
> 2.30.2
> 

Thanks,
drew

