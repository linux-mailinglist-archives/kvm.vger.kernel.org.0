Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5067222C3
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 11:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbjFEJ6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 05:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjFEJ6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 05:58:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35E3B0;
        Mon,  5 Jun 2023 02:58:05 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3559WYNO011829;
        Mon, 5 Jun 2023 09:58:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fVa6IukZ9YgyHpSHhY9ocJmun8aGyKG/yUriSrCVhLA=;
 b=ah5vmgHhhgCbQbABnmuCjcrBi9kHhwiIEfh8wB2fYgtMwfE7l8HsKMdbQn7H9Mkbg0GY
 U7jHkRdgnLcxUQ17bLWc34My8HpOee4AMHZoU5qutuTM9SrazK3IjhYZgj169HqaCItf
 YE6BQA/61gEkFuvGhWGIovIPuY4RtUM2p+8bRES2NdoZ4RsEkXaXpdl/uI1otBd0pUIr
 /xQf7WRtJ+b7pOe4/dmdvqNldAwdkE3cs9DRTMLwHVR0LVdKFWOqB71SLjUuMIVCOjFt
 D9VCZXR5j1p0h+RIlREyzJ1UF8+us14WFaunnoZhJQXSvU08oCAr/SxN5VvKkbjYM7Kv Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1d5hrjnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 09:58:05 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3559cNie001654;
        Mon, 5 Jun 2023 09:58:04 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1d5hrjn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 09:58:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3554gb9E001935;
        Mon, 5 Jun 2023 09:58:02 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qyxg2h8x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 09:58:02 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3559vxDA13894272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jun 2023 09:57:59 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A5452004B;
        Mon,  5 Jun 2023 09:57:59 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF3D720049;
        Mon,  5 Jun 2023 09:57:58 +0000 (GMT)
Received: from [9.171.39.161] (unknown [9.171.39.161])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jun 2023 09:57:58 +0000 (GMT)
Message-ID: <ab1047c5-77f1-d68b-cf05-4bcda44909ed@linux.ibm.com>
Date:   Mon, 5 Jun 2023 11:57:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Nico Boehr <nrb@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230601070202.152094-1-nrb@linux.ibm.com>
 <20230601070202.152094-7-nrb@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 6/6] s390x: add a test for SIE without
 MSO/MSL
In-Reply-To: <20230601070202.152094-7-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kZ3KB1dD7F19hmztpp1-0ipbBm75s06A
X-Proofpoint-GUID: 0xAmwVUvMU5oIEF3SvmTIl9Rmz5S93hk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999 phishscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050086
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/23 09:02, Nico Boehr wrote:
> Since we now have the ability to run guests without MSO/MSL, add a test
> to make sure this doesn't break.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   s390x/Makefile             |   2 +
>   s390x/sie-dat.c            | 120 +++++++++++++++++++++++++++++++++++++
>   s390x/snippets/c/sie-dat.c |  58 ++++++++++++++++++
>   s390x/unittests.cfg        |   3 +
>   4 files changed, 183 insertions(+)
>   create mode 100644 s390x/sie-dat.c
>   create mode 100644 s390x/snippets/c/sie-dat.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index a80db538810e..4921669ee4c3 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -40,6 +40,7 @@ tests += $(TEST_DIR)/panic-loop-pgm.elf
>   tests += $(TEST_DIR)/migration-sck.elf
>   tests += $(TEST_DIR)/exittime.elf
>   tests += $(TEST_DIR)/ex.elf
> +tests += $(TEST_DIR)/sie-dat.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   
> @@ -120,6 +121,7 @@ snippet_lib = $(snippet_asmlib) lib/auxinfo.o
>   # perquisites (=guests) for the snippet hosts.
>   # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
>   $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
> +$(TEST_DIR)/sie-dat.elf: snippets = $(SNIPPET_DIR)/c/sie-dat.gbin
>   $(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
>   
>   $(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-yield.gbin
> diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
> new file mode 100644
> index 000000000000..c490a2aa825c
> --- /dev/null
> +++ b/s390x/sie-dat.c
> @@ -0,0 +1,120 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Tests SIE with paging.
> + *
> + * Copyright 2023 IBM Corp.
> + *
> + * Authors:
> + *    Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <vmalloc.h>
> +#include <asm/asm-offsets.h>

I only did a cursory glance and wasn't able to see a use for this include.

> +#include <asm-generic/barrier.h>
> +#include <asm/pgtable.h>
> +#include <mmu.h>
> +#include <asm/page.h>
> +#include <asm/facility.h>

The sclp.h include should be enough, no?
You're not using test_facility() as far as I can see.

> +#include <asm/interrupt.h>
> +#include <asm/mem.h>
> +#include <alloc_page.h>
> +#include <sclp.h> > +#include <sie.h>
> +#include <snippet.h>
> +
> +static struct vm vm;
> +static pgd_t *guest_root;
> +
> +/* keep in sync with TEST_PAGE_COUNT in s390x/snippets/c/sie-dat.c */
> +#define GUEST_TEST_PAGE_COUNT 10
> +
> +/* keep in sync with TOTAL_PAGE_COUNT in s390x/snippets/c/sie-dat.c */
> +#define GUEST_TOTAL_PAGE_COUNT 256
> +
> +static void test_sie_dat(void)
> +{
> +	uint8_t r1;
> +	bool contents_match;
> +	uint64_t test_page_gpa, test_page_hpa;
> +	uint8_t *test_page_hva;
> +
> +	/* guest will tell us the guest physical address of the test buffer */
> +	sie(&vm);
> +
> +	r1 = (vm.sblk->ipa & 0xf0) >> 4;
> +	test_page_gpa = vm.save_area.guest.grs[r1];
> +	test_page_hpa = virt_to_pte_phys(guest_root, (void*)test_page_gpa);
> +	test_page_hva = __va(test_page_hpa);
> +	report(vm.sblk->icptcode == ICPT_INST &&
> +	       (vm.sblk->ipa & 0xFF00) == 0x8300 && vm.sblk->ipb == 0x9c0000,
> +	       "test buffer gpa=0x%lx hva=%p", test_page_gpa, test_page_hva);

You could rebase on my pv_icptdata.h patch.
Also the report string and boolean don't really relate to each other.

Not every exit needs to be a report.
Some should rather be asserts() or report_info()s.

> +
> +	/* guest will now write to the test buffer and we verify the contents */
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_INST &&
> +	       vm.sblk->ipa == 0x8300 && vm.sblk->ipb == 0x440000,
> +	       "guest wrote to test buffer");

Yup pv_icptdata.h

> +
> +	contents_match = true;
> +	for (unsigned int i = 0; i < GUEST_TEST_PAGE_COUNT; i++) {
> +		uint8_t expected_val = 42 + i;

Just because you can doesn't mean that you have to.
At least leave a \n when declaring new variables...

> +		if (test_page_hva[i * PAGE_SIZE] != expected_val) {
> +			report_fail("page %u mismatch actual_val=%x expected_val=%x",
> +				    i, test_page_hva[i], expected_val);
> +			contents_match = false;
> +		}
> +	}
> +	report(contents_match, "test buffer contents match");
> +
> +	/* the guest will now write to an unmapped address and we check that this causes a segment translation exception */
> +	report_prefix_push("guest write to unmapped");
> +	expect_pgm_int();
> +	sie(&vm);
> +	check_pgm_int_code(PGM_INT_CODE_SEGMENT_TRANSLATION);
> +	report_prefix_pop();
> +}
> +

[...]

> +}
> diff --git a/s390x/snippets/c/sie-dat.c b/s390x/snippets/c/sie-dat.c
> new file mode 100644
> index 000000000000..e156d0c36c4c
> --- /dev/null
> +++ b/s390x/snippets/c/sie-dat.c
> @@ -0,0 +1,58 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Snippet used by the sie-dat.c test to verify paging without MSO/MSL
> + *
> + * Copyright (c) 2023 IBM Corp
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <stddef.h>
> +#include <inttypes.h>
> +#include <string.h>
> +#include <asm-generic/page.h>
> +
> +/* keep in sync with GUEST_TEST_PAGE_COUNT in s390x/sie-dat.c */
> +#define TEST_PAGE_COUNT 10
> +static uint8_t test_page[TEST_PAGE_COUNT * PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
> +
> +/* keep in sync with GUEST_TOTAL_PAGE_COUNT in s390x/sie-dat.c */
> +#define TOTAL_PAGE_COUNT 256
> +
> +static inline void force_exit(void)
> +{
> +	asm volatile("diag	0,0,0x44\n");
> +}
> +
> +static inline void force_exit_value(uint64_t val)
> +{
> +	asm volatile(
> +		"diag	%[val],0,0x9c\n"
> +		: : [val] "d"(val)
> +	);
> +}

It feels like these need to go into a snippet lib.

> +
> +__attribute__((section(".text"))) int main(void)

The attribute shouldn't be needed anymore.

> +{
> +	uint8_t *invalid_ptr;
> +
> +	memset(test_page, 0, sizeof(test_page));
> +	/* tell the host the page's physical address (we're running DAT off) */
> +	force_exit_value((uint64_t)test_page);
> +
> +	/* write some value to the page so the host can verify it */
> +	for (size_t i = 0; i < TEST_PAGE_COUNT; i++)

Why is i a size_t type?

> +		test_page[i * PAGE_SIZE] = 42 + i;
> +
> +	/* indicate we've written all pages */
> +	force_exit();
> +
> +	/* the first unmapped address */
> +	invalid_ptr = (uint8_t *)(TOTAL_PAGE_COUNT * PAGE_SIZE);
> +	*invalid_ptr = 42;
> +
> +	/* indicate we've written the non-allowed page (should never get here) */
> +	force_exit();
> +
> +	return 0;
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index b61faf0737c3..24cd27202a08 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -218,3 +218,6 @@ extra_params = -append '--parallel'
>   
>   [execute]
>   file = ex.elf
> +
> +[sie-dat]
> +file = sie-dat.elf

