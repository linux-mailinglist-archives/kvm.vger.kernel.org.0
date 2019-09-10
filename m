Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848E1AEA1D
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 14:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388443AbfIJMTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 08:19:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14780 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731146AbfIJMTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 08:19:19 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D5B9579705;
        Tue, 10 Sep 2019 12:19:18 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-117-98.ams2.redhat.com [10.36.117.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7F041001B07;
        Tue, 10 Sep 2019 12:19:12 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 4/6] s390x: Add initial smp code
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190905103951.36522-1-frankja@linux.ibm.com>
 <20190905103951.36522-5-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <c502505d-09ab-b91e-8596-1290f48b9c1b@redhat.com>
Date:   Tue, 10 Sep 2019 14:19:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190905103951.36522-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 10 Sep 2019 12:19:18 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/09/2019 12.39, Janosch Frank wrote:
> Let's add a rudimentary SMP library, which will scan for cpus and has
> helper functions that manage the cpu state.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h |   8 ++
>  lib/s390x/asm/sigp.h     |  28 +++-
>  lib/s390x/io.c           |   5 +-
>  lib/s390x/sclp.h         |   1 +
>  lib/s390x/smp.c          | 276 +++++++++++++++++++++++++++++++++++++++
>  lib/s390x/smp.h          |  51 ++++++++
>  s390x/Makefile           |   1 +
>  s390x/cstart64.S         |   7 +
>  8 files changed, 371 insertions(+), 6 deletions(-)
>  create mode 100644 lib/s390x/smp.c
>  create mode 100644 lib/s390x/smp.h
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 5f8f45e..d5a7f51 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -157,6 +157,14 @@ struct cpuid {
>  	uint64_t reserved : 15;
>  };
>  
> +static inline unsigned short stap(void)
> +{
> +	unsigned short cpu_address;
> +
> +	asm volatile("stap %0" : "=Q" (cpu_address));
> +	return cpu_address;
> +}
> +
>  static inline int tprot(unsigned long addr)
>  {
>  	int cc;
> diff --git a/lib/s390x/asm/sigp.h b/lib/s390x/asm/sigp.h
> index fbd94fc..2d52313 100644
> --- a/lib/s390x/asm/sigp.h
> +++ b/lib/s390x/asm/sigp.h
> @@ -46,14 +46,32 @@
>  
>  #ifndef __ASSEMBLER__
>  
> -static inline void sigp_stop(void)
> +
> +static inline int sigp(uint16_t addr, uint8_t order, unsigned long parm,
> +		       uint32_t *status)
>  {
> -	register unsigned long status asm ("1") = 0;
> -	register unsigned long cpu asm ("2") = 0;
> +	register unsigned long reg1 asm ("1") = parm;
> +	int cc;
>  
>  	asm volatile(
> -		"	sigp %0,%1,0(%2)\n"
> -		: "+d" (status)  : "d" (cpu), "d" (SIGP_STOP) : "cc");
> +		"	sigp	%1,%2,0(%3)\n"
> +		"	ipm	%0\n"
> +		"	srl	%0,28\n"
> +		: "=d" (cc), "+d" (reg1) : "d" (addr), "a" (order) : "cc");
> +	if (status)
> +		*status = reg1;
> +	return cc;
> +}
> +
> +static inline int sigp_retry(uint16_t addr, uint8_t order, unsigned long parm,
> +			     uint32_t *status)
> +{
> +	int cc;
> +
> +	do {
> +		cc = sigp(addr, order, parm, status);
> +	} while (cc == 2);
> +	return cc;
>  }
>  
>  #endif /* __ASSEMBLER__ */
> diff --git a/lib/s390x/io.c b/lib/s390x/io.c
> index becadfc..32f09b5 100644
> --- a/lib/s390x/io.c
> +++ b/lib/s390x/io.c
> @@ -16,6 +16,7 @@
>  #include <asm/facility.h>
>  #include <asm/sigp.h>
>  #include "sclp.h"
> +#include "smp.h"
>  
>  extern char ipl_args[];
>  uint8_t stfl_bytes[NR_STFL_BYTES] __attribute__((aligned(8)));
> @@ -37,12 +38,14 @@ void setup(void)
>  	setup_facilities();
>  	sclp_console_setup();
>  	sclp_memory_setup();
> +	smp_setup();
>  }
>  
>  void exit(int code)
>  {
> +	smp_teardown();
>  	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
>  	while (1) {
> -		sigp_stop();
> +		sigp(0, SIGP_STOP, 0, NULL);
>  	}
>  }
> diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
> index 98c482a..4e69845 100644
> --- a/lib/s390x/sclp.h
> +++ b/lib/s390x/sclp.h
> @@ -19,6 +19,7 @@
>  #define SCLP_CMD_CODE_MASK                      0xffff00ff
>  
>  /* SCLP command codes */
> +#define SCLP_READ_CPU_INFO			0x00010001
>  #define SCLP_CMDW_READ_SCP_INFO                 0x00020001
>  #define SCLP_CMDW_READ_SCP_INFO_FORCED          0x00120001
>  #define SCLP_READ_STORAGE_ELEMENT_INFO          0x00040001
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> new file mode 100644
> index 0000000..40c43ef
> --- /dev/null
> +++ b/lib/s390x/smp.c
> @@ -0,0 +1,276 @@
> +/*
> + * s390x smp
> + * Based on Linux's arch/s390/kernel/smp.c and
> + * arch/s390/include/asm/sigp.h
> + *
> + * Copyright (c) 2019 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2.
> + */
> +#include <libcflat.h>
> +#include <errno.h>

This breaks building on Travis:

 https://travis-ci.com/huth/kvm-unit-tests/jobs/232679058

I don't think that you can use the errno.h header from the system
library in kvm-unit-tests in a save way. It's likely better if you
define your own error codes instead.

 Thomas
