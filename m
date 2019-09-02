Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E40A5AAD
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2019 17:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbfIBPkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Sep 2019 11:40:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52914 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbfIBPkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Sep 2019 11:40:05 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E324D877A66;
        Mon,  2 Sep 2019 15:40:04 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-48.ams2.redhat.com [10.36.116.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EAA160603;
        Mon,  2 Sep 2019 15:40:00 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 6/6] s390x: SMP test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190829121459.1708-1-frankja@linux.ibm.com>
 <20190829121459.1708-7-frankja@linux.ibm.com>
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
Message-ID: <50b70561-f39d-6edc-600a-ccb707fe5b92@redhat.com>
Date:   Mon, 2 Sep 2019 17:40:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829121459.1708-7-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Mon, 02 Sep 2019 15:40:05 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/08/2019 14.14, Janosch Frank wrote:
> Testing SIGP emulation for the following order codes:
> * start
> * stop
> * restart
> * set prefix
> * store status
> * stop and store status
> * reset
> * initial reset
> * external call
> * emegergency call
> 
> restart and set prefix are part of the library and needed to start
> other cpus.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/Makefile |   1 +
>  s390x/smp.c    | 242 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 243 insertions(+)
>  create mode 100644 s390x/smp.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index d83dd0b..3744372 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -15,6 +15,7 @@ tests += $(TEST_DIR)/cpumodel.elf
>  tests += $(TEST_DIR)/diag288.elf
>  tests += $(TEST_DIR)/stsi.elf
>  tests += $(TEST_DIR)/skrf.elf
> +tests += $(TEST_DIR)/smp.elf
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  
>  all: directories test_cases test_cases_binary
> diff --git a/s390x/smp.c b/s390x/smp.c
> new file mode 100644
> index 0000000..9363cd2
> --- /dev/null
> +++ b/s390x/smp.c
> @@ -0,0 +1,242 @@
> +/*
> + * Tests sigp emulation
> + *
> + * Copyright 2019 IBM Corp.
> + *
> + * Authors:
> + *    Janosch Frank <frankja@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2.
> + */
> +#include <libcflat.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <asm/page.h>
> +#include <asm/facility.h>
> +#include <asm-generic/barrier.h>
> +#include <asm/sigp.h>
> +
> +#include <smp.h>
> +#include <alloc_page.h>
> +
> +static int t = 0;

Single letter variables that are used accross functions are a little bit
ugly. I'd maybe give this a better name, like "testflag" or something
similar?

> +static void cpu_loop(void)
> +{
> +	for (;;) {}
> +}
> +
> +static void test_func(void)
> +{
> +	t = 1;

I think I'd rather place a mb() here, just to be sure...?

> +	cpu_loop();
> +}
> +
> +static void test_start(void)
> +{
> +	struct psw psw;
> +	psw.mask =  extract_psw_mask();
> +	psw.addr = (unsigned long)test_func;
> +
> +	smp_cpu_setup(1, psw);
> +	while (!t) {
> +		mb();
> +	}
> +	report("start", 1);
> +}
> +
> +static void test_stop(void)
> +{
> +	int i = 0;
> +
> +	smp_cpu_stop(1);
> +	/*
> +	 * The smp library waits for the CPU to shut down, but let's
> +	 * also do it here, so we don't rely on the library
> +	 * implementation
> +	 */
> +	while (!smp_cpu_stopped(1)) {}
> +	t = 0;
> +	/* Let's leave some time for cpu #2 to change t */

CPU #2 ? Where? Why?

> +	for (; i < 0x100000; i++) {}

I'm pretty sure the compiler optimizes empty loops away.

> +	report("stop", !t);
> +}
> +
> +static void test_stop_store_status(void)
> +{
> +	struct cpu *cpu = smp_cpu_from_addr(1);
> +	struct lowcore *lc = (void *)0x0;

Do you want to erase the values in the save area before calling the
"store_status"? ... just to be sure that we don't see old values there?

> +	smp_cpu_stop_store_status(1);
> +	mb();
> +	report("stop store status",
> +	       lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore);

That confused me. Why does the prefix_sa of the lowcore of CPU 0 match
the prefix of CPU 1 ? I'd rather expect cpu->lowcore->prefix_sa to
contain this value?

Maybe you could also check that at least the stack pointer GPR is != 0
in the save area?

> +}
> +
> +static void test_store_status(void)
> +{
> +	struct cpu_status *status = alloc_pages(0);
> +	uint32_t r;
> +
> +	report_prefix_push("status");
> +	memset(status, 0, PAGE_SIZE);
> +
> +	smp_cpu_restart(1);
> +	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, &r);
> +	report("not stopped", r == SIGP_STATUS_INCORRECT_STATE);

Maybe also check that the save are is still 0?

> +	memset(status, 0, PAGE_SIZE);
> +	smp_cpu_stop(1);
> +	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
> +	while (!status->prefix) {}

status->prefix is not marked as volatile, so please put a "mb()" into
the curly braces here.

> +	report("store status", 1);
> +	free_pages(status, PAGE_SIZE);
> +	report_prefix_pop();
> +}
> +
> +static void ecall(void)
> +{
> +	unsigned long mask;
> +	struct lowcore *lc = (void *)0x0;
> +
> +	ctl_set_bit(0, 13);
> +	mask = extract_psw_mask();
> +	mask |= PSW_MASK_EXT;
> +	load_psw_mask(mask);
> +	expect_ext_int();

I think you should move the expect_ext_int() before the enablement of
the interrupt, to avoid races?

> +	t = 1;
> +	while (lc->ext_int_code != 0x1202) {mb();}

Spaces around the "mb();", please.

> +	report("ecall", 1);
> +	t = 1;
> +}
> +
> +static void test_ecall(void)
> +{
> +	struct psw psw;
> +	psw.mask =  extract_psw_mask();
> +	psw.addr = (unsigned long)ecall;
> +
> +	report_prefix_push("ecall");
> +	t = 0;
> +	smp_cpu_destroy(1);
> +
> +	mb();

Why this mb() here?

> +	smp_cpu_setup(1, psw);
> +	while (!t) {
> +		mb();
> +	}
> +	t = 0;
> +	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
> +	while(!t) {mb();}

Spaces, please.

> +	smp_cpu_stop(1);
> +	report_prefix_pop();
> +}
> +
> +static void emcall(void)
> +{
> +	unsigned long mask;
> +	struct lowcore *lc = (void *)0x0;
> +
> +	ctl_set_bit(0, 14);
> +	mask = extract_psw_mask();
> +	mask |= PSW_MASK_EXT;
> +	load_psw_mask(mask);
> +	expect_ext_int();

I think you should move the expect_ext_int() before the enablement of
the interrupt, to avoid races?

> +	t = 1;
> +	while (lc->ext_int_code != 0x1201) {mb();}

Spaces.

> +	report("ecall", 1);
> +	t = 1;
> +}
> +
> +static void test_emcall(void)
> +{
> +	struct psw psw;
> +	psw.mask =  extract_psw_mask();
> +	psw.addr = (unsigned long)emcall;
> +
> +	report_prefix_push("emcall");
> +	t = 0;
> +	smp_cpu_destroy(1);
> +
> +	mb();
> +	smp_cpu_setup(1, psw);
> +	while (!t) {
> +		mb();
> +	}
> +	t = 0;
> +	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
> +	while(!t) {mb();}

Spaces.

> +	smp_cpu_stop(1);
> +	report_prefix_pop();
> +}
> +
> +static void test_reset_initial(void)
> +{
> +	struct cpu_status *status = alloc_pages(0);
> +	struct psw psw;
> +
> +	psw.mask =  extract_psw_mask();
> +	psw.addr = (unsigned long)test_func;
> +
> +	report_prefix_push("reset initial");
> +	smp_cpu_setup(1, psw);
> +
> +	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
> +	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
> +
> +	report_prefix_push("clear");
> +	report("psw", !status->psw.mask && !status->psw.addr);
> +	report("prefix", !status->prefix);
> +	report("fpc", !status->fpc);
> +	report("cpu timer", !status->cputm);
> +	report("todpr", !status->todpr);
> +	report_prefix_pop();
> +
> +	report_prefix_push("initialized");
> +	report("cr0 == 0xE0", status->crs[0] == 0xE0UL);
> +	report("cr14 == 0xC2000000", status->crs[14] == 0xC2000000UL);
> +	report_prefix_pop();
> +
> +	report("cpu stopped", smp_cpu_stopped(1));
> +	free_pages(status, PAGE_SIZE);
> +	report_prefix_pop();
> +}
> +
> +static void test_reset(void)
> +{
> +	struct psw psw;
> +
> +	psw.mask =  extract_psw_mask();
> +	psw.addr = (unsigned long)test_func;
> +
> +	report_prefix_push("cpu reset");
> +	smp_cpu_setup(1, psw);
> +
> +	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
> +	report("cpu stopped", smp_cpu_stopped(1));
> +	report_prefix_pop();
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("smp");
> +
> +	if (smp_query_num_cpus() == 1) {
> +		report_abort("need at least 2 cpus for this test");
> +		goto done;
> +	}
> +
> +	test_start();
> +	test_stop();
> +	test_stop_store_status();
> +	test_store_status();
> +	test_ecall();
> +	test_emcall();
> +	test_reset();
> +	test_reset_initial();
> +
> +done:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> 

 Thomas
