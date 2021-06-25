Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5343B3D6D
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 09:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhFYHf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 03:35:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59496 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229616AbhFYHf1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 03:35:27 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15P7IYfD071979;
        Fri, 25 Jun 2021 03:33:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jdOwdoNP6+BDeqpGrBsq6XAPD2CssAu9tXPeEbqlQoo=;
 b=J5ygw4nNh1DccT9UTbcI98Bko3x8578hTaaP1YkKirzVfd6xok0mG8fHohxWbL2O9bUI
 TblIzMz1avUcnJxFotzGkktSlC9QdCBQswbczcdQ6Tx2c+N2h8RCGhsqUk6hQhclfXeY
 XN38y+G6Lgz3MnXZu1vYgsAgEL2AloX9g7ncnSBm8BSALkcK7FWgz6xHXqZ7KWboHDEp
 4YyYPdxAaEbdocTH1g2yP10SNbGLTcsrilzzaY6mtzRoIYIOPSv+ZgiRJ48ddbWuT9fG
 hc088/r5H6aXu0COcLzBjuWzanyKTomh/5QCUyxtfPoO58co/UcDowNumgM1NIYUNWfH vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39dan1reft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 03:33:06 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15P7InX1072978;
        Fri, 25 Jun 2021 03:33:06 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39dan1reeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 03:33:06 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15P7IMsM020973;
        Fri, 25 Jun 2021 07:33:03 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3997uhhm6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 07:33:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15P7X0OV23658960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 07:33:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60B0F4C046;
        Fri, 25 Jun 2021 07:33:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE0294C052;
        Fri, 25 Jun 2021 07:32:59 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.46.136])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Jun 2021 07:32:59 +0000 (GMT)
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, seiden@linux.ibm.com
References: <20210624120152.344009-1-frankja@linux.ibm.com>
 <20210624120152.344009-4-frankja@linux.ibm.com>
 <725852b8-d24d-9429-b4bc-7c5d6a07ef63@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 3/3] s390x: mvpg: Add SIE mvpg test
Message-ID: <89d155aa-a9e8-676f-c972-8077509c852d@linux.ibm.com>
Date:   Fri, 25 Jun 2021 09:32:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <725852b8-d24d-9429-b4bc-7c5d6a07ef63@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: e5VmjmXLak2YOujGIiVVgT1fGTCOm9kW
X-Proofpoint-GUID: 4ub3vDKQ10utJvXo-7RCbM0D2hdPduy5
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_02:2021-06-24,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 spamscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250040
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/24/21 6:27 PM, Thomas Huth wrote:
> On 24/06/2021 14.01, Janosch Frank wrote:
>> Let's also check the PEI values to make sure our VSIE implementation
>> is correct.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   s390x/Makefile                  |   2 +
>>   s390x/mvpg-sie.c                | 150 ++++++++++++++++++++++++++++++++
>>   s390x/snippets/c/mvpg-snippet.c |  33 +++++++
>>   s390x/unittests.cfg             |   3 +
>>   4 files changed, 188 insertions(+)
>>   create mode 100644 s390x/mvpg-sie.c
>>   create mode 100644 s390x/snippets/c/mvpg-snippet.c
>>
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index ba32f4c..07af26d 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -23,6 +23,7 @@ tests += $(TEST_DIR)/sie.elf
>>   tests += $(TEST_DIR)/mvpg.elf
>>   tests += $(TEST_DIR)/uv-host.elf
>>   tests += $(TEST_DIR)/edat.elf
>> +tests += $(TEST_DIR)/mvpg-sie.elf
>>   
>>   tests_binary = $(patsubst %.elf,%.bin,$(tests))
>>   ifneq ($(HOST_KEY_DOCUMENT),)
>> @@ -82,6 +83,7 @@ snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
>>   
>>   # perquisites (=guests) for the snippet hosts.
>>   # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
>> +$(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
>>   
>>   $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(FLATLIBS)
>>   	$(OBJCOPY) -O binary $(patsubst %.gbin,%.o,$@) $@
>> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
>> new file mode 100644
>> index 0000000..a18c1b0
>> --- /dev/null
>> +++ b/s390x/mvpg-sie.c
>> @@ -0,0 +1,150 @@
>> +#include <libcflat.h>
>> +#include <asm/asm-offsets.h>
>> +#include <asm-generic/barrier.h>
>> +#include <asm/interrupt.h>
>> +#include <asm/pgtable.h>
>> +#include <mmu.h>
>> +#include <asm/page.h>
>> +#include <asm/facility.h>
>> +#include <asm/mem.h>
>> +#include <asm/sigp.h>
>> +#include <smp.h>
>> +#include <alloc_page.h>
>> +#include <bitops.h>
>> +#include <vm.h>
>> +#include <sclp.h>
>> +#include <sie.h>
> 
> The list of headers that get included here is rather long for this file that 
> is rather short ... e.g. do we really need such headers like sigp.h and 
> sclp.h here?

sclp.h is used for the sie facility check.
I've removed asm/sigp.h, smp.h and bitops.h

> 
>> +static u8 *guest;
>> +static u8 *guest_instr;
>> +static struct vm vm;
>> +
>> +static uint8_t *src;
>> +static uint8_t *dst;
>> +static uint8_t *cmp;
>> +
>> +extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_start[];
>> +extern const char _binary_s390x_snippets_c_mvpg_snippet_gbin_end[];
>> +int binary_size;
>> +
>> +static void sie(struct vm *vm)
>> +{
>> +	/* Reset icptcode so we don't trip below */
>> +	vm->sblk->icptcode = 0;
>> +
>> +	while (vm->sblk->icptcode == 0) {
>> +		sie64a(vm->sblk, &vm->save_area);
>> +		if (vm->sblk->icptcode == ICPT_VALIDITY)
>> +			assert(0);
> 
> 
>                  assert(vm->sblk->icptcode != ICPT_VALIDITY)
> 
> ?
> 
>> +	}
>> +	vm->save_area.guest.grs[14] = vm->sblk->gg14;
>> +	vm->save_area.guest.grs[15] = vm->sblk->gg15;
>> +}
>> +
>> +static void test_mvpg_pei(void)
>> +{
>> +	uint64_t **pei_dst = (uint64_t **)((uintptr_t) vm.sblk + 0xc0);
>> +	uint64_t **pei_src = (uint64_t **)((uintptr_t) vm.sblk + 0xc8);
> 
> Hmm, magic values ... according to the public SA22-7095-0 from 1984, the 
> array at offset 0xc0 is called "Interruption parameters" ... could we maybe 
> at least use a similar name in our
> kvm_s390_sie_block?

That's very much a thing that moved over from KVM and the reason for
that is that the interruption parameters contain a lot of things
especially when PV is added into the mix.

We can now either choose to make the interruption parameters an
interesing looking union or we define the offsets properly. I'm also not
too happy about the VSIE PEI code using "u64 *pei_block =
&vsie_page->scb_o->mcic;" for that.

#define SBLK_OFF_PEI_DST 0xc0
#define SBLK_OFF_PEI_SRC 0xc8

> 
>> +	report_prefix_push("pei");
>> +
>> +	report_prefix_push("src");
>> +	memset(dst, 0, PAGE_SIZE);
>> +	protect_page(src, PAGE_ENTRY_I);
>> +	sie(&vm);
>> +	report(vm.sblk->icptcode == ICPT_PARTEXEC, "Partial execution");
>> +	report((uintptr_t)**pei_src == ((uintptr_t)vm.sblk->mso) + 0x6000 + PAGE_ENTRY_I, "PEI_SRC correct");
>> +	report((uintptr_t)**pei_dst == vm.sblk->mso + 0x5000, "PEI_DST correct");
>> +	unprotect_page(src, PAGE_ENTRY_I);
>> +	report(!memcmp(cmp, dst, PAGE_SIZE), "Destination intact");
>> +	/* Jump over the diag44 */

How about:

/*
 * We need to execute the diag44 which is used as a blocker behind the
 * mvpg. It makes sure we fail the tests above if the mvpg wouldn't
* have intercepted.
*/

>> +	sie(&vm);

And:

/* Make sure we intercepted for the diag44 and noting else */

>> +	assert(vm.sblk->icptcode == ICPT_INST &&
>> +	       vm.sblk->ipa == 0x8300 && vm.sblk->ipb == 0x440000);
> 
> Maybe add a comment about the magic values?

Since these will be used extensively in the future I think it might make
sense to introduce constants.

#define SIE_ICPT_IPA_DIAG 0x8300

> 
>> +	report_prefix_pop();
>> +
>> +	/* Clear PEI data for next check */
>> +	report_prefix_push("dst");
>> +	memset((uint64_t *)((uintptr_t) vm.sblk + 0xc0), 0, 16);
>> +	memset(dst, 0, PAGE_SIZE);
>> +	protect_page(dst, PAGE_ENTRY_I);
>> +	sie(&vm);
>> +	report(vm.sblk->icptcode == ICPT_PARTEXEC, "Partial execution");
>> +	report((uintptr_t)**pei_src == vm.sblk->mso + 0x6000, "PEI_SRC correct");
>> +	report((uintptr_t)**pei_dst == vm.sblk->mso + 0x5000 + PAGE_ENTRY_I, "PEI_DST correct");
>> +	/* Needed for the memcmp and general cleanup */
>> +	unprotect_page(dst, PAGE_ENTRY_I);
>> +	report(!memcmp(cmp, dst, PAGE_SIZE), "Destination intact");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_pop();
>> +}
>> +
>> +static void test_mvpg(void)
>> +{
>> +	int binary_size = ((uintptr_t)_binary_s390x_snippets_c_mvpg_snippet_gbin_end -
>> +			   (uintptr_t)_binary_s390x_snippets_c_mvpg_snippet_gbin_start);
>> +
>> +	memcpy(guest, _binary_s390x_snippets_c_mvpg_snippet_gbin_start, binary_size);
>> +	memset(src, 0x42, PAGE_SIZE);
>> +	memset(dst, 0x43, PAGE_SIZE);
>> +	sie(&vm);
>> +	mb();
>> +	report(!memcmp(src, dst, PAGE_SIZE) && *dst == 0x42, "Page moved");
>> +}
>> +
>> +static void setup_guest(void)
>> +{
>> +	setup_vm();
>> +
>> +	/* Allocate 1MB as guest memory */
>> +	guest = alloc_pages(8);
>> +	/* The first two pages are the lowcore */
>> +	guest_instr = guest + PAGE_SIZE * 2;
>> +
>> +	vm.sblk = alloc_page();
>> +
>> +	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
>> +	vm.sblk->prefix = 0;
>> +	/*
>> +	 * Pageable guest with the same ASCE as the test programm, but
>> +	 * the guest memory 0x0 is offset to start at the allocated
>> +	 * guest pages and end after 1MB.
>> +	 *
>> +	 * It's not pretty but faster and easier than managing guest ASCEs.
>> +	 */
>> +	vm.sblk->mso = (u64)guest;
>> +	vm.sblk->msl = (u64)guest;
>> +	vm.sblk->ihcpu = 0xffff;
>> +
>> +	vm.sblk->crycbd = (uint64_t)alloc_page();
>> +
>> +	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
>> +	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
>> +	vm.sblk->ictl = ICTL_OPEREXC | ICTL_PINT;
>> +	/* Enable MVPG interpretation as we want to test KVM and not ourselves */
>> +	vm.sblk->eca = ECA_MVPGI;
>> +
>> +	src = guest + PAGE_SIZE * 6;
>> +	dst = guest + PAGE_SIZE * 5;
>> +	cmp = alloc_page();
>> +	memset(cmp, 0, PAGE_SIZE);
>> +}
>> +
>> +int main(void)
>> +{
>> +	report_prefix_push("mvpg-sie");
>> +	if (!sclp_facilities.has_sief2) {
>> +		report_skip("SIEF2 facility unavailable");
>> +		goto done;
>> +	}
>> +
>> +	setup_guest();
>> +	test_mvpg();
>> +	test_mvpg_pei();
>> +
>> +done:
>> +	report_prefix_pop();
>> +	return report_summary();
>> +
>> +}
>> diff --git a/s390x/snippets/c/mvpg-snippet.c b/s390x/snippets/c/mvpg-snippet.c
>> new file mode 100644
>> index 0000000..96b70c9
>> --- /dev/null
>> +++ b/s390x/snippets/c/mvpg-snippet.c
>> @@ -0,0 +1,33 @@
>> +#include <libcflat.h>
>> +
>> +static inline void force_exit(void)
>> +{
>> +	asm volatile("	diag	0,0,0x44\n");
>> +}
>> +
>> +static inline int mvpg(unsigned long r0, void *dest, void *src)
>> +{
>> +	register unsigned long reg0 asm ("0") = r0;
>> +	int cc;
>> +
>> +	asm volatile("	mvpg    %1,%2\n"
>> +		     "	ipm     %0\n"
>> +		     "	srl     %0,28"
>> +		     : "=&d" (cc) : "a" (dest), "a" (src), "d" (reg0)
> 
> Why is cc marked with "&" here?

I copied that from s390x/mvpg.c

> 
>   Thomas
> 

