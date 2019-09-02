Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7827A5795
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2019 15:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbfIBNVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Sep 2019 09:21:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729571AbfIBNVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Sep 2019 09:21:34 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9749410A8136;
        Mon,  2 Sep 2019 13:21:33 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-48.ams2.redhat.com [10.36.116.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45A455D6A7;
        Mon,  2 Sep 2019 13:21:29 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 4/6] s390x: Add initial smp code
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190829121459.1708-1-frankja@linux.ibm.com>
 <20190829121459.1708-5-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <af43e842-9aee-9407-2a97-354efe2b81e1@redhat.com>
Date:   Mon, 2 Sep 2019 15:21:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829121459.1708-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Mon, 02 Sep 2019 13:21:33 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/08/2019 14.14, Janosch Frank wrote:
> Let's add a rudimentary SMP library, which will scan for cpus and has
> helper functions that manage the cpu state.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h |   8 ++
>  lib/s390x/asm/sigp.h     |  29 ++++-
>  lib/s390x/io.c           |   5 +-
>  lib/s390x/sclp.h         |   1 +
>  lib/s390x/smp.c          | 272 +++++++++++++++++++++++++++++++++++++++
>  lib/s390x/smp.h          |  51 ++++++++
>  s390x/Makefile           |   1 +
>  s390x/cstart64.S         |   7 +
>  8 files changed, 368 insertions(+), 6 deletions(-)
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
> index fbd94fc..ce85eb7 100644
> --- a/lib/s390x/asm/sigp.h
> +++ b/lib/s390x/asm/sigp.h
> @@ -46,14 +46,33 @@
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
> +retry:
> +	cc = sigp(addr, order, parm, status);
> +	if (cc == 2)
> +		goto retry;

Please change to:

	do {
		cc = sigp(addr, order, parm, status);
	} while (cc == 2);

> +	return cc;
>  }
>  
>  #endif /* __ASSEMBLER__ */
[...]
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> new file mode 100644
> index 0000000..b1b636a
> --- /dev/null
> +++ b/lib/s390x/smp.c
[...]
> +int smp_cpu_restart(uint16_t addr)
> +{
> +	int rc = 0;
> +	struct cpu *cpu;
> +
> +	spin_lock(&lock);
> +	cpu = smp_cpu_from_addr(addr);
> +	if (!cpu) {
> +		rc = -ENOENT;
> +		goto out;
> +	}
> +
> +	rc = sigp(cpu->addr, SIGP_RESTART, 0, NULL);

I think you could use "addr" instead of "cpu->addr" here.

> +	cpu->active = true;
> +out:
> +	spin_unlock(&lock);
> +	return rc;
> +}
> +
> +int smp_cpu_start(uint16_t addr, struct psw psw)
> +{
> +	int rc = 0;
> +	struct cpu *cpu;
> +	struct lowcore *lc;
> +
> +	spin_lock(&lock);
> +	cpu = smp_cpu_from_addr(addr);
> +	if (!cpu) {
> +		rc = -ENOENT;
> +		goto out;
> +	}
> +
> +	lc = cpu->lowcore;
> +	lc->restart_new_psw.mask = psw.mask;
> +	lc->restart_new_psw.addr = psw.addr;
> +	rc = sigp(cpu->addr, SIGP_RESTART, 0, NULL);

dito

> +out:
> +	spin_unlock(&lock);
> +	return rc;
> +}
> +
> +int smp_cpu_destroy(uint16_t addr)
> +{
> +	struct cpu *cpu;
> +	int rc = 0;
> +
> +	spin_lock(&lock);
> +	rc = smp_cpu_stop_nolock(addr, false);
> +	if (rc)
> +		goto out;
> +
> +	cpu = smp_cpu_from_addr(addr);
> +	free_pages(cpu->lowcore, 2 * PAGE_SIZE);
> +	free_pages(cpu->stack, 4 * PAGE_SIZE);

Maybe do this afterwards to make sure that nobody uses a dangling pointer:

	cpu->lowcore = cpu->stack = -1UL;

?

> +out:
> +	spin_unlock(&lock);
> +	return rc;
> +}
> +
> +int smp_cpu_setup(uint16_t addr, struct psw psw)
> +{
> +	struct lowcore *lc;
> +	struct cpu *cpu;
> +	int rc = 0;
> +
> +	spin_lock(&lock);
> +
> +	if (!cpus) {
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	cpu = smp_cpu_from_addr(addr);
> +
> +	if (!cpu) {
> +		rc = -ENOENT;
> +		goto out;
> +	}
> +
> +	if (cpu->active) {
> +		rc = -EINVAL;
> +		goto out;
> +	}
> +
> +	sigp_retry(cpu->addr, SIGP_INITIAL_CPU_RESET, 0, NULL);
> +
> +	lc = alloc_pages(1);
> +	cpu->lowcore = lc;
> +	memset(lc, 0, PAGE_SIZE * 2);
> +	sigp_retry(cpu->addr, SIGP_SET_PREFIX, (unsigned long )lc, NULL);
> +
> +	/* Copy all exception psws. */
> +	memcpy(lc, cpu0->lowcore, 512);
> +
> +	/* Setup stack */
> +	cpu->stack = (uint64_t *)alloc_pages(2);
> +
> +	/* Start without DAT and any other mask bits. */
> +	cpu->lowcore->sw_int_grs[14] = psw.addr;
> +	cpu->lowcore->sw_int_grs[15] = (uint64_t)cpu->stack + (PAGE_SIZE * 4) / sizeof(cpu->stack);

The end-of-stack calculation looks wrong to me. I think you either meant:

 ... = (uint64_t)(cpu->stack + (PAGE_SIZE * 4) / sizeof(*cpu->stack));

or:

 ... = (uint64_t)cpu->stack + (PAGE_SIZE * 4);

?

> +	lc->restart_new_psw.mask = 0x0000000180000000UL;
> +	lc->restart_new_psw.addr = (unsigned long)smp_cpu_setup_state;

Maybe use "(uint64_t)" instead of "(unsigned long)"?

> +	lc->sw_int_cr0 = 0x0000000000040000UL;
> +
> +	/* Start processing */
> +	cpu->active = true;
> +	rc = sigp_retry(cpu->addr, SIGP_RESTART, 0, NULL);

Should cpu->active only be set to true if rc == 0 ?

> +out:
> +	spin_unlock(&lock);
> +	return rc;
> +}
> +
> +/*
> + * Disregarding state, stop all cpus that once were online except for
> + * calling cpu.
> + */
> +void smp_teardown(void)
> +{
> +	int i = 0;
> +	uint16_t this_cpu = stap();
> +	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
> +
> +	spin_lock(&lock);
> +	for (; i < info->nr_configured; i++) {
> +		if (cpus[i].active &&
> +		    cpus[i].addr != this_cpu) {
> +			sigp_retry(cpus[i].addr, SIGP_STOP, 0, NULL);

Maybe set cpus[i].active = false afterwards ?

> +		}
> +	}
> +	spin_unlock(&lock);
> +}

 Thomas
