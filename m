Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45CD4BB260
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 12:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439530AbfIWKnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 06:43:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38470 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436612AbfIWKnO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 06:43:14 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 93ECE756;
        Mon, 23 Sep 2019 10:43:13 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-120.ams2.redhat.com [10.36.116.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 507365D71C;
        Mon, 23 Sep 2019 10:43:09 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 4/6] s390x: Add initial smp code
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190920080356.1948-1-frankja@linux.ibm.com>
 <20190920080356.1948-5-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 mQINBFH7eUwBEACzyOXKU+5Pcs6wNpKzrlJwzRl3VGZt95VCdb+FgoU9g11m7FWcOafrVRwU
 yYkTm9+7zBUc0sW5AuPGR/dp3pSLX/yFWsA/UB4nJsHqgDvDU7BImSeiTrnpMOTXb7Arw2a2
 4CflIyFqjCpfDM4MuTmzTjXq4Uov1giGE9X6viNo1pxyEpd7PanlKNnf4PqEQp06X4IgUacW
 tSGj6Gcns1bCuHV8OPWLkf4hkRnu8hdL6i60Yxz4E6TqlrpxsfYwLXgEeswPHOA6Mn4Cso9O
 0lewVYfFfsmokfAVMKWzOl1Sr0KGI5T9CpmRfAiSHpthhHWnECcJFwl72NTi6kUcUzG4se81
 O6n9d/kTj7pzTmBdfwuOZ0YUSqcqs0W+l1NcASSYZQaDoD3/SLk+nqVeCBB4OnYOGhgmIHNW
 0CwMRO/GK+20alxzk//V9GmIM2ACElbfF8+Uug3pqiHkVnKqM7W9/S1NH2qmxB6zMiJUHlTH
 gnVeZX0dgH27mzstcF786uPcdEqS0KJuxh2kk5IvUSL3Qn3ZgmgdxBMyCPciD/1cb7/Ahazr
 3ThHQXSHXkH/aDXdfLsKVuwDzHLVSkdSnZdt5HHh75/NFHxwaTlydgfHmFFwodK8y/TjyiGZ
 zg2Kje38xnz8zKn9iesFBCcONXS7txENTzX0z80WKBhK+XSFJwARAQABtB5UaG9tYXMgSHV0
 aCA8dGh1dGhAcmVkaGF0LmNvbT6JAjgEEwECACIFAlVgX6oCGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAAoJEC7Z13T+cC21EbIP/ii9cvT2HHGbFRl8HqGT6+7Wkb+XLMqJBMAIGiQK
 QIP3xk1HPTsLfVG0ao4hy/oYkGNOP8+ubLnZen6Yq3zAFiMhQ44lvgigDYJo3Ve59gfe99KX
 EbtB+X95ODARkq0McR6OAsPNJ7gpEUzfkQUUJTXRDQXfG/FX303Gvk+YU0spm2tsIKPl6AmV
 1CegDljzjycyfJbk418MQmMu2T82kjrkEofUO2a24ed3VGC0/Uz//XCR2ZTo+vBoBUQl41BD
 eFFtoCSrzo3yPFS+w5fkH9NT8ChdpSlbNS32NhYQhJtr9zjWyFRf0Zk+T/1P7ECn6gTEkp5k
 ofFIA4MFBc/fXbaDRtBmPB0N9pqTFApIUI4vuFPPO0JDrII9dLwZ6lO9EKiwuVlvr1wwzsgq
 zJTPBU3qHaUO4d/8G+gD7AL/6T4zi8Jo/GmjBsnYaTzbm94lf0CjXjsOX3seMhaE6WAZOQQG
 tZHAO1kAPWpaxne+wtgMKthyPLNwelLf+xzGvrIKvLX6QuLoWMnWldu22z2ICVnLQChlR9d6
 WW8QFEpo/FK7omuS8KvvopFcOOdlbFMM8Y/8vBgVMSsK6fsYUhruny/PahprPbYGiNIhKqz7
 UvgyZVl4pBFjTaz/SbimTk210vIlkDyy1WuS8Zsn0htv4+jQPgo9rqFE4mipJjy/iboDuQIN
 BFH7eUwBEAC2nzfUeeI8dv0C4qrfCPze6NkryUflEut9WwHhfXCLjtvCjnoGqFelH/PE9NF4
 4VPSCdvD1SSmFVzu6T9qWdcwMSaC+e7G/z0/AhBfqTeosAF5XvKQlAb9ZPkdDr7YN0a1XDfa
 +NgA+JZB4ROyBZFFAwNHT+HCnyzy0v9Sh3BgJJwfpXHH2l3LfncvV8rgFv0bvdr70U+On2XH
 5bApOyW1WpIG5KPJlDdzcQTyptOJ1dnEHfwnABEfzI3dNf63rlxsGouX/NFRRRNqkdClQR3K
 gCwciaXfZ7ir7fF0u1N2UuLsWA8Ei1JrNypk+MRxhbvdQC4tyZCZ8mVDk+QOK6pyK2f4rMf/
 WmqxNTtAVmNuZIwnJdjRMMSs4W4w6N/bRvpqtykSqx7VXcgqtv6eqoDZrNuhGbekQA0sAnCJ
 VPArerAZGArm63o39me/bRUQeQVSxEBmg66yshF9HkcUPGVeC4B0TPwz+HFcVhheo6hoJjLq
 knFOPLRj+0h+ZL+D0GenyqD3CyuyeTT5dGcNU9qT74bdSr20k/CklvI7S9yoQje8BeQAHtdV
 cvO8XCLrpGuw9SgOS7OP5oI26a0548M4KldAY+kqX6XVphEw3/6U1KTf7WxW5zYLTtadjISB
 X9xsRWSU+Yqs3C7oN5TIPSoj9tXMoxZkCIHWvnqGwZ7JhwARAQABiQIfBBgBAgAJBQJR+3lM
 AhsMAAoJEC7Z13T+cC21hPAQAIsBL9MdGpdEpvXs9CYrBkd6tS9mbaSWj6XBDfA1AEdQkBOn
 ZH1Qt7HJesk+qNSnLv6+jP4VwqK5AFMrKJ6IjE7jqgzGxtcZnvSjeDGPF1h2CKZQPpTw890k
 fy18AvgFHkVk2Oylyexw3aOBsXg6ukN44vIFqPoc+YSU0+0QIdYJp/XFsgWxnFIMYwDpxSHS
 5fdDxUjsk3UBHZx+IhFjs2siVZi5wnHIqM7eK9abr2cK2weInTBwXwqVWjsXZ4tq5+jQrwDK
 cvxIcwXdUTLGxc4/Z/VRH1PZSvfQxdxMGmNTGaXVNfdFZjm4fz0mz+OUi6AHC4CZpwnsliGV
 ODqwX8Y1zic9viSTbKS01ZNp175POyWViUk9qisPZB7ypfSIVSEULrL347qY/hm9ahhqmn17
 Ng255syASv3ehvX7iwWDfzXbA0/TVaqwa1YIkec+/8miicV0zMP9siRcYQkyTqSzaTFBBmqD
 oiT+z+/E59qj/EKfyce3sbC9XLjXv3mHMrq1tKX4G7IJGnS989E/fg6crv6NHae9Ckm7+lSs
 IQu4bBP2GxiRQ+NV3iV/KU3ebMRzqIC//DCOxzQNFNJAKldPe/bKZMCxEqtVoRkuJtNdp/5a
 yXFZ6TfE1hGKrDBYAm4vrnZ4CXFSBDllL59cFFOJCkn4Xboj/aVxxJxF30bn
Organization: Red Hat
Message-ID: <b60eee55-f013-411a-0e52-3f40a990b1c4@redhat.com>
Date:   Mon, 23 Sep 2019 12:43:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190920080356.1948-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 23 Sep 2019 10:43:13 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/2019 10.03, Janosch Frank wrote:
> Let's add a rudimentary SMP library, which will scan for cpus and has
> helper functions that manage the cpu state.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
[...]
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> new file mode 100644
> index 0000000..05379b0
> --- /dev/null
> +++ b/lib/s390x/smp.c
> @@ -0,0 +1,263 @@
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
> +#include <asm/arch_def.h>
> +#include <asm/sigp.h>
> +#include <asm/page.h>
> +#include <asm/barrier.h>
> +#include <asm/spinlock.h>
> +#include <asm/asm-offsets.h>
> +
> +#include <alloc.h>
> +#include <alloc_page.h>
> +
> +#include "smp.h"
> +#include "sclp.h"
> +
> +static char cpu_info_buffer[PAGE_SIZE] __attribute__((__aligned__(4096)));
> +static struct cpu *cpus;
> +static struct cpu *cpu0;
> +static struct spinlock lock;
> +
> +extern void smp_cpu_setup_state(void);
> +
> +int smp_query_num_cpus(void)
> +{
> +	struct ReadCpuInfo *info = (void *)cpu_info_buffer;
> +	return info->nr_configured;
> +}
> +
> +struct cpu *smp_cpu_from_addr(uint16_t addr)
> +{
> +	int i, num = smp_query_num_cpus();
> +	struct cpu *cpu = NULL;
> +
> +	for (i = 0; i < num; i++) {
> +		if (cpus[i].addr == addr)
> +			cpu = &cpus[i];

Small optimization: Add a "break" here. Or "return &cpus[i]" directly
and "return NULL" after the loop, getting rid of the "cpu" variable.

> +	}
> +	return cpu;
> +}
> +
> +bool smp_cpu_stopped(uint16_t addr)
> +{
> +	uint32_t status;
> +
> +	if (sigp(addr, SIGP_SENSE, 0, &status) != SIGP_CC_STATUS_STORED)
> +		return false;
> +	return !!(status & (SIGP_STATUS_CHECK_STOP|SIGP_STATUS_STOPPED));
> +}
> +
> +bool smp_cpu_running(uint16_t addr)
> +{
> +	if (sigp(addr, SIGP_SENSE_RUNNING, 0, NULL) != SIGP_CC_STATUS_STORED)
> +		return true;
> +	/* Status stored condition code is equivalent to cpu not running. */
> +	return false;
> +}
> +
> +static int smp_cpu_stop_nolock(uint16_t addr, bool store)
> +{
> +	struct cpu *cpu;
> +	uint8_t order = store ? SIGP_STOP_AND_STORE_STATUS : SIGP_STOP;
> +
> +	cpu = smp_cpu_from_addr(addr);
> +	if (!cpu || cpu == cpu0)
> +		return -1;
> +
> +	if (sigp_retry(addr, order, 0, NULL))
> +		return -1;
> +
> +	while (!smp_cpu_stopped(addr))
> +		mb();
> +	cpu->active = false;
> +	return 0;
> +}
> +
> +int smp_cpu_stop(uint16_t addr)
> +{
> +	int rc = 0;

You could drop the "= 0" here.

> +	spin_lock(&lock);
> +	rc = smp_cpu_stop_nolock(addr, false);
> +	spin_unlock(&lock);
> +	return rc;
> +}
> +
> +int smp_cpu_stop_store_status(uint16_t addr)
> +{
> +	int rc = 0;

dito.

> +	spin_lock(&lock);
> +	rc = smp_cpu_stop_nolock(addr, true);
> +	spin_unlock(&lock);
> +	return rc;
> +}
> +
> +int smp_cpu_restart(uint16_t addr)
> +{
> +	int rc = -1;
> +	struct cpu *cpu;
> +
> +	spin_lock(&lock);
> +	cpu = smp_cpu_from_addr(addr);
> +	if (!cpu)
> +		goto out;
> +
> +	rc = sigp(addr, SIGP_RESTART, 0, NULL);
> +	cpu->active = true;
> +out:

For such simple code, I'd prefer:

	if (cpu) {
		rc = sigp(addr, SIGP_RESTART, 0, NULL);
		cpu->active = true;
	}

instead of using a "goto" ... anyway, just my 0.02 €.

> +	spin_unlock(&lock);
> +	return rc;
> +}
> +
> +int smp_cpu_start(uint16_t addr, struct psw psw)
> +{
> +	int rc = -1;
> +	struct cpu *cpu;
> +	struct lowcore *lc;
> +
> +	spin_lock(&lock);
> +	cpu = smp_cpu_from_addr(addr);
> +	if (!cpu)
> +		goto out;
> +
> +	lc = cpu->lowcore;
> +	lc->restart_new_psw.mask = psw.mask;
> +	lc->restart_new_psw.addr = psw.addr;
> +	rc = sigp(addr, SIGP_RESTART, 0, NULL);
> +out:

dito, could be done without "goto".

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
> +	cpu->lowcore = (void *)-1UL;
> +	cpu->stack = (void *)-1UL;
> +
> +out:

dito. Well, it's just a matter of taste, I think. I'm also fine if you
want to keep it this way.

> +	spin_unlock(&lock);
> +	return rc;
> +}

... just cosmetic nits, patch looks fine to me now, so feel free to add:

Reviewed-by: Thomas Huth <thuth@redhat.com>
