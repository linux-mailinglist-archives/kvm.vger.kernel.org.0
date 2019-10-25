Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01230E4C6B
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 15:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502085AbfJYNir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 09:38:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39142 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726285AbfJYNir (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 09:38:47 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PDbepa097078
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 09:38:45 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vv0s6km6c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 09:38:44 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Fri, 25 Oct 2019 14:38:40 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 14:38:38 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PDc3fH35389722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 13:38:03 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C336A4062;
        Fri, 25 Oct 2019 13:38:36 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48CCCA405F;
        Fri, 25 Oct 2019 13:38:36 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.39])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Oct 2019 13:38:36 +0000 (GMT)
Date:   Fri, 25 Oct 2019 15:37:36 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 5/5] s390x: SCLP unit test
In-Reply-To: <e8398bc4-f7d4-d83c-e106-3f92fb13304e@redhat.com>
References: <1571741584-17621-1-git-send-email-imbrenda@linux.ibm.com>
 <1571741584-17621-6-git-send-email-imbrenda@linux.ibm.com>
 <e8398bc4-f7d4-d83c-e106-3f92fb13304e@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19102513-0020-0000-0000-0000037E8529
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102513-0021-0000-0000-000021D4D24A
Message-Id: <20191025153736.7d1a9be9@p-imbrenda.boeblingen.de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Oct 2019 14:14:56 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 22.10.19 12:53, Claudio Imbrenda wrote:
> > SCLP unit test. Testing the following:
> > 
> > * Correctly ignoring instruction bits that should be ignored
> > * Privileged instruction check
> > * Check for addressing exceptions
> > * Specification exceptions:
> >    - SCCB size less than 8
> >    - SCCB unaligned
> >    - SCCB overlaps prefix or lowcore
> >    - SCCB address higher than 2GB
> > * Return codes for
> >    - Invalid command
> >    - SCCB too short (but at least 8)
> >    - SCCB page boundary violation
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   s390x/Makefile      |   1 +
> >   s390x/sclp.c        | 373
> > ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > s390x/unittests.cfg |   3 + 3 files changed, 377 insertions(+)
> >   create mode 100644 s390x/sclp.c
> > 
> > diff --git a/s390x/Makefile b/s390x/Makefile
> > index 3744372..ddb4b48 100644
> > --- a/s390x/Makefile
> > +++ b/s390x/Makefile
> > @@ -16,6 +16,7 @@ tests += $(TEST_DIR)/diag288.elf
> >   tests += $(TEST_DIR)/stsi.elf
> >   tests += $(TEST_DIR)/skrf.elf
> >   tests += $(TEST_DIR)/smp.elf
> > +tests += $(TEST_DIR)/sclp.elf
> >   tests_binary = $(patsubst %.elf,%.bin,$(tests))
> >   
> >   all: directories test_cases test_cases_binary
> > diff --git a/s390x/sclp.c b/s390x/sclp.c
> > new file mode 100644
> > index 0000000..d7a9212
> > --- /dev/null
> > +++ b/s390x/sclp.c
> > @@ -0,0 +1,373 @@
> > +/*
> > + * Store System Information tests
> > + *
> > + * Copyright (c) 2019 IBM Corp
> > + *
> > + * Authors:
> > + *  Claudio Imbrenda <imbrenda@linux.ibm.com>
> > + *
> > + * This code is free software; you can redistribute it and/or
> > modify it
> > + * under the terms of the GNU General Public License version 2.
> > + */
> > +
> > +#include <libcflat.h>
> > +#include <asm/page.h>
> > +#include <asm/asm-offsets.h>
> > +#include <asm/interrupt.h>
> > +#include <sclp.h>
> > +
> > +static uint8_t pagebuf[PAGE_SIZE * 2]
> > __attribute__((aligned(PAGE_SIZE * 2))); +static uint8_t
> > prefix_buf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
> > +static uint32_t valid_sclp_code; +static struct lowcore *lc;
> > +
> > +static void sclp_setup_int_test(void)
> > +{
> > +	uint64_t mask;
> > +
> > +	ctl_set_bit(0, 9);
> > +
> > +	mask = extract_psw_mask();
> > +	mask |= PSW_MASK_EXT;
> > +	load_psw_mask(mask);
> > +}
> > +
> > +static int sclp_service_call_test(unsigned int command, void
> > *sccb)  
> 
> Wouldn't it be easier to pass an uint8_t*, so you can simply forward 
> pagebuf through all functions?

I'm not sure I understand what you mean here. Sometimes I'm passing
random numbers for the addresses. so either I have to cast addresses to
integers, or integers to addresses.

I'll change it to accept pointers, we can see if it looks cleaner

> 
> > +{
> > +	int cc;
> > +
> > +	sclp_mark_busy();
> > +	sclp_setup_int_test();
> > +	lc->pgm_int_code = 0;
> > +	cc = servc(command, __pa(sccb));
> > +	if (lc->pgm_int_code) {
> > +		sclp_handle_ext();  
> 
> You receive a PGM interrupt and handle an external interrupt? That
> looks strange. Please elaborate what's going on here.

sclp_handle_ext clears the external interrupt bit, which we have set
earlier, and then sets busy=false. we need to do both things, even
though we have not received an external interrupt. I simply did not
want to reinvent the wheel

> 
> > +		return 0;
> > +	}
> > +	if (!cc)
> > +		sclp_wait_busy();
> > +	return cc;
> > +}
> > +
> > +static int test_one_sccb(uint32_t cmd, uint64_t addr, uint16_t len,
> > +			void *data, uint64_t exp_pgm, uint16_t
> > exp_rc) +{
> > +	SCCBHeader *h = (SCCBHeader *)addr;
> > +	int res, pgm;
> > +
> > +	if (data && len)
> > +		memcpy((void *)addr, data, len);
> > +	if (!exp_pgm)
> > +		exp_pgm = 1;
> > +	expect_pgm_int();
> > +	res = sclp_service_call_test(cmd, h);
> > +	if (res) {
> > +		report_info("SCLP not ready (command %#x, address
> > %#lx, cc %d)",
> > +			cmd, addr, res);
> > +		return 0;
> > +	}
> > +	pgm = lc->pgm_int_code;
> > +	if (!((1ULL << pgm) & exp_pgm)) {
> > +		report_info("First failure at addr %#lx, size %d,
> > cmd %#x, pgm code %d",
> > +				addr, len, cmd, pgm);
> > +		return 0;
> > +	}
> > +	if (exp_rc && (exp_rc != h->response_code)) {
> > +		report_info("First failure at addr %#lx, size %d,
> > cmd %#x, resp code %#x",
> > +				addr, len, cmd, h->response_code);
> > +		return 0;
> > +	}
> > +	return 1;
> > +}
> > +
> > +static int test_one_run(uint32_t cmd, uint64_t addr, uint16_t len,
> > +			uint16_t clear, uint64_t exp_pgm, uint16_t
> > exp_rc)  
> 
> I somewhat dislike passing in "exp_pgm" and "exp_rc". Why can't you 
> handle both things in the caller where the tests actually become
> readable?

how would it be more readable? this means that after each call I should
have a lot of checks for all the possible errors, and all those checks
would be all the same. Lots of possibilities for copy-paste errors, and
it would inflate the code a lot.

> 
> > +{
> > +	char sccb[4096];  
> 
> I prefer uint8_t sccb[PAGE_SIZE]

will fix

> 
> > +	void *p = sccb;
> > +
> > +	if (!len && !clear)
> > +		p = NULL;
> > +	else
> > +		memset(sccb, 0, sizeof(sccb));
> > +	((SCCBHeader *)sccb)->length = len;
> > +	if (clear && (clear < 8))
> > +		clear = 8;  
> 
> Can you elaborate what "clear" means. It is passed as "length".
> /me confused

clear indicates how much of the actual memory will be overwritten (or
cleared). if you have an 8-byte SCCB and 4096 for clear, the SCCB will
have length 8, but all 4096 bytes will be written to memory (the
remaining 4088 will be 0, hence "clear")

I will rename len to sccb_len and clear to buf_len, maybe it helps 

> 
> > +	return test_one_sccb(cmd, addr, clear, p, exp_pgm, exp_rc);
> > +}
> > +
> > +#define PGM_BIT_SPEC	(1ULL << PGM_INT_CODE_SPECIFICATION)
> > +#define PGM_BIT_ADDR	(1ULL << PGM_INT_CODE_ADDRESSING)
> > +#define PGM_BIT_PRIV	(1ULL <<
> > PGM_INT_CODE_PRIVILEGED_OPERATION) +
> > +#define PGBUF	((uintptr_t)pagebuf)
> > +#define VALID	(valid_sclp_code)  
> 
> I dislike both defines, can you get rid of these?

I was almost expecting this. the code will get more verbose, but ok

> 
> > +
> > +static void test_sccb_too_short(void)
> > +{
> > +	int cx;  
> 
> cx is passed as "len". What does cx stand for? Can we give this a
> better name?

it's just a counter, like "i" or so.

> 
> [...] (not reviewing the other stuff in detail because I am still
> confused)
> 
> > +static void test_resp(void)
> > +{
> > +	test_inval();
> > +	test_short();
> > +	test_boundary();
> > +	test_toolong();
> > +}  
> 
> Can you just get rid of this function and call all tests from main?
> (just separate them in logical blocks eventually with comments)

ok

> 
> > +
> > +static void test_priv(void)
> > +{
> > +	pagebuf[0] = 0;
> > +	pagebuf[1] = 8;
> > +	expect_pgm_int();
> > +	enter_pstate();
> > +	servc(valid_sclp_code, __pa(pagebuf));
> > +	report_prefix_push("Priv check");
> > +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> > +	report_prefix_pop();  
> 
> Can we push at the beginning of the function and pop at the end?
> 
> report_prefix_push("Privileged Operation");
> 
> expect_pgm_int();
> enter_pstate();
> servc(valid_sclp_code, __pa(pagebuf));
> check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> 
> report_prefix_pop();

ok

> 
> Also shouldn't you better mark sclp busy and wait for interrupts to
> make sore you handle it correctly in case the check *fails* and servc 
> completes (cc==0)?

In case we actually get the privileged operation exception, we will not
clear the sclp_busy flag. and check_pgm_int_code will try to write to
the console, waiting for sclp_busy to become 0, which will not happen.

The solution is to copy-paste most of sclp_service_call_test. This will
also bring no benefits, since once we have failed such a basic test, we
don't really have any guarantees that the SCLP implementation will be
sound. We simply report an error and move on.


> 
> > +}
> > +
> > +static void test_addressing(void)
> > +{
> > +	unsigned long cx, maxram = get_ram_size();
> > +
> > +	if (maxram >= 0x80000000) {
> > +		report_skip("Invalid SCCB address");
> > +		return;
> > +	}  
> 
> Do we really need maxram here, can't we simply use very high
> addresses like in all other tests?

no. the address must be both above available memory and below 2GB.
I need to know where the memory ends, so I can try to test addresses
right after the end of memory.

If the VM is started with more than 2GB of RAM, this test doesn't
make any sense, and is therefore skipped.

> 
> E.g. just user address "-PAGE_SIZE"

this might result in a specification exception, instead of an
addressing exception, since the address is above 2GB. For invalid
addresses over 2GB both are acceptable. Here I want to test explicitly
the addressing exceptions.

> 
> > +	for (cx = maxram; cx < MIN(maxram + 65536, 0x80000000); cx
> > += 8)
> > +		if (!test_one_run(VALID, cx, 0, 0, PGM_BIT_ADDR,
> > 0))
> > +			goto out;
> > +	for (; cx < MIN((maxram + 0x7fffff) & ~0xfffff,
> > 0x80000000); cx += 4096)
> > +		if (!test_one_run(VALID, cx, 0, 0, PGM_BIT_ADDR,
> > 0))
> > +			goto out;
> > +	for (; cx < 0x80000000; cx += 1048576)
> > +		if (!test_one_run(VALID, cx, 0, 0, PGM_BIT_ADDR,
> > 0))
> > +			goto out;
> > +out:
> > +	report("Invalid SCCB address", cx == 0x80000000);
> > +}
> > +
> > +static void test_instbits(void)
> > +{
> > +	SCCBHeader *h = (SCCBHeader *)pagebuf;
> > +	unsigned long mask;
> > +	int cc;
> > +
> > +	sclp_mark_busy();
> > +	h->length = 8;
> > +
> > +	ctl_set_bit(0, 9);
> > +	mask = extract_psw_mask();
> > +	mask |= PSW_MASK_EXT;
> > +	load_psw_mask(mask);
> > +
> > +	asm volatile(
> > +		"       .insn   rre,0xb2204200,%1,%2\n"  /* servc
> > %1,%2 */
> > +		"       ipm     %0\n"
> > +		"       srl     %0,28"
> > +		: "=&d" (cc) : "d" (valid_sclp_code),
> > "a" (__pa(pagebuf))
> > +		: "cc", "memory");
> > +	sclp_wait_busy();
> > +	report("Instruction format ignored bits", cc == 0);
> > +}
> > +
> > +static void find_valid_sclp_code(void)
> > +{
> > +	unsigned int commands[] = { SCLP_CMDW_READ_SCP_INFO_FORCED,
> > +				    SCLP_CMDW_READ_SCP_INFO };
> > +	SCCBHeader *h = (SCCBHeader *)pagebuf;
> > +	int i, cc;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(commands); i++) {
> > +		sclp_mark_busy();
> > +		memset(h, 0, sizeof(pagebuf));
> > +		h->length = 4096;
> > +
> > +		valid_sclp_code = commands[i];
> > +		cc = sclp_service_call(commands[i], h);
> > +		if (cc)
> > +			break;
> > +		if (h->response_code ==
> > SCLP_RC_NORMAL_READ_COMPLETION)
> > +			return;
> > +		if (h->response_code !=
> > SCLP_RC_INVALID_SCLP_COMMAND)
> > +			break;
> > +	}
> > +	valid_sclp_code = 0;
> > +	report_abort("READ_SCP_INFO failed");
> > +}
> > +
> > +int main(void)
> > +{
> > +	report_prefix_push("sclp");
> > +	find_valid_sclp_code();
> > +	test_instbits();
> > +	test_priv();
> > +	test_addressing();
> > +	test_spec();
> > +	test_resp();
> > +	return report_summary();
> > +}
> > diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> > index f1b07cd..75e3d37 100644
> > --- a/s390x/unittests.cfg
> > +++ b/s390x/unittests.cfg
> > @@ -75,3 +75,6 @@ file = stsi.elf
> >   [smp]
> >   file = smp.elf
> >   extra_params =-smp 2
> > +
> > +[sclp]
> > +file = sclp.elf
> >   
> 
> 

