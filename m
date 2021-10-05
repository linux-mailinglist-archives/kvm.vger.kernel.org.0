Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D0A4224DA
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 13:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbhJELVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 07:21:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13070 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232658AbhJELVT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 07:21:19 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195BBxSr028894;
        Tue, 5 Oct 2021 07:19:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4CYmqkBticPGHj0gJvjR3TvCR4lKgL9vgvzSqs81gq0=;
 b=TnWhsfkp9UKJLBzNPRyq3Ao6Yk4G9oxqmrNwBs0AbrImwIZrFXEn7ZcBUZtVJ9AdZgB5
 loh3lbhf+IdQmLAcTLhA1otrLuoY5kFJ+z9aA2HRX6Gcmtfh0lGXGZ/6icULw5t69Xdo
 U+6llUNZg69RP+6lu0lYO9ICyYKIJmxL2zwemUnL0aimpQAIVjNbhrn1bki1OqxhxgVw
 3K3JTlrzTKFzuO93huFU3jufz5KvujhwR87cV/atyWor3zq76qoPjNHoOOoMT9QhWzpX
 j+IV3Dl2aw6plI16F185YYjn7YoAHXky1gPdZTNEjVQUZjml2DYq2SuoWW1KpqLShETw zg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bgnm905w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 07:19:28 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 195BDBHO018231;
        Tue, 5 Oct 2021 11:19:26 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3bef2a1fd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Oct 2021 11:19:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 195BE6He47972750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Oct 2021 11:14:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12B9B11C076;
        Tue,  5 Oct 2021 11:19:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE0D511C077;
        Tue,  5 Oct 2021 11:19:22 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.51.33])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Oct 2021 11:19:22 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 1/2] [kvm-unit-tests PATCH v2 0/2] Test
 specification exception
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20211005091153.1863139-1-scgl@linux.ibm.com>
 <20211005091153.1863139-2-scgl@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Message-ID: <2641fb00-4693-68f0-efab-f115337da71c@linux.vnet.ibm.com>
Date:   Tue, 5 Oct 2021 13:19:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211005091153.1863139-2-scgl@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: p3MrfV1FNdLjR_BsqoLzk1Azv2ob-otl
X-Proofpoint-ORIG-GUID: p3MrfV1FNdLjR_BsqoLzk1Azv2ob-otl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-04_05,2021-10-04_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110050065
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Oops, forgot to Cc the lists on the cover letter, see below.


When specification exception interpretation is enabled, specification
exceptions need not result in interceptions.
However, if the exception is due to an invalid program new PSW,
interception must occur.
Test this.
Also test that interpretation does occur if interpretation is disabled.

v1 -> v2
	Add license and test description
	Use lowcore pointer instead of magic value for program new PSW
		-> need to get rid of assert in arch_def.h
	Do not use odd program new PSW, even if irrelevant
	Use SIE lib
	Reword messages
	Fix nits


Janis Schoetterl-Glausch (2):
  s390x: Remove assert from arch_def.h
  s390x: Add specification exception interception test

 s390x/Makefile             |  2 +
 lib/s390x/asm/arch_def.h   |  5 ++-
 lib/s390x/sie.h            |  1 +
 s390x/snippets/c/spec_ex.c | 20 +++++++++
 s390x/spec_ex-sie.c        | 83 ++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg        |  3 ++
 6 files changed, 112 insertions(+), 2 deletions(-)
 create mode 100644 s390x/snippets/c/spec_ex.c
 create mode 100644 s390x/spec_ex-sie.c

Range-diff against v1:
-:  ------- > 1:  8ad817c s390x: Remove assert from arch_def.h
1:  9e5e161 ! 2:  f8abbae s390x: Add specification exception interception test
    @@ lib/s390x/sie.h: struct kvm_s390_sie_block {
     
      ## s390x/snippets/c/spec_ex.c (new) ##
     @@
    ++// SPDX-License-Identifier: GPL-2.0-only
    ++/*
    ++ * © Copyright IBM Corp. 2021
    ++ *
    ++ * Snippet used by specification exception interception test.
    ++ */
     +#include <stdint.h>
     +#include <asm/arch_def.h>
     +
     +__attribute__((section(".text"))) int main(void)
     +{
    ++	struct lowcore *lowcore = (struct lowcore *) 0;
     +	uint64_t bad_psw = 0;
    -+	struct psw *pgm_new = (struct psw *)464;
     +
    -+	pgm_new->mask = 1UL << (63 - 12); //invalid program new PSW
    -+	pgm_new->addr = 0xdeadbeef;
    ++	/* PSW bit 12 has no name or meaning and must be 0 */
    ++	lowcore->pgm_new_psw.mask = 1UL << (63 - 12);
    ++	lowcore->pgm_new_psw.addr = 0xdeadbeee;
     +	asm volatile ("lpsw %0" :: "Q"(bad_psw));
     +	return 0;
     +}
     
      ## s390x/spec_ex-sie.c (new) ##
     @@
    ++// SPDX-License-Identifier: GPL-2.0-only
    ++/*
    ++ * © Copyright IBM Corp. 2021
    ++ *
    ++ * Specification exception interception test.
    ++ * Checks that specification exception interceptions occur as expected when
    ++ * specification exception interpretation is off/on.
    ++ */
     +#include <libcflat.h>
     +#include <sclp.h>
     +#include <asm/page.h>
    @@ s390x/spec_ex-sie.c (new)
     +			   (uintptr_t)_binary_s390x_snippets_c_spec_ex_gbin_start);
     +
     +	setup_vm();
    -+
    -+	/* Allocate 1MB as guest memory */
     +	guest = alloc_pages(8);
    -+	/* The first two pages are the lowcore */
    -+
    -+	vm.sblk = alloc_page();
    -+
    -+	vm.sblk->cpuflags = CPUSTAT_ZARCH | CPUSTAT_RUNNING;
    -+	vm.sblk->prefix = 0;
    -+	/*
    -+	 * Pageable guest with the same ASCE as the test program, but
    -+	 * the guest memory 0x0 is offset to start at the allocated
    -+	 * guest pages and end after 1MB.
    -+	 *
    -+	 * It's not pretty but faster and easier than managing guest ASCEs.
    -+	 */
    -+	vm.sblk->mso = (u64)guest;
    -+	vm.sblk->msl = (u64)guest;
    -+	vm.sblk->ihcpu = 0xffff;
    -+
    -+	vm.sblk->crycbd = (uint64_t)alloc_page();
    -+
     +	memcpy(guest, _binary_s390x_snippets_c_spec_ex_gbin_start, binary_size);
    ++	sie_guest_create(&vm, (uint64_t) guest, HPAGE_SIZE);
     +}
     +
     +static void reset_guest(void)
     +{
     +	vm.sblk->gpsw.addr = PAGE_SIZE * 4;
    -+	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
    ++	vm.sblk->gpsw.mask = PSW_MASK_64;
    ++	vm.sblk->icptcode = 0;
     +}
     +
     +static void test_spec_ex_sie(void)
     +{
     +	setup_guest();
     +
    -+	report_prefix_push("spec ex interpretation off");
    ++	report_prefix_push("SIE spec ex interpretation");
    ++	report_prefix_push("off");
     +	reset_guest();
    -+	sie64a(vm.sblk, &vm.save_area);
    -+	//interpretation off -> initial exception must cause interception
    ++	sie(&vm);
    ++	/* interpretation off -> initial exception must cause interception */
     +	report(vm.sblk->icptcode == ICPT_PROGI
     +	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION
    -+	       && vm.sblk->gpsw.addr != 0xdeadbeef,
    -+	       "Received specification exception intercept for non program new PSW");
    ++	       && vm.sblk->gpsw.addr != 0xdeadbeee,
    ++	       "Received specification exception intercept for initial exception");
     +	report_prefix_pop();
     +
    -+	report_prefix_push("spec ex interpretation on");
    ++	report_prefix_push("on");
     +	vm.sblk->ecb |= ECB_SPECI;
     +	reset_guest();
    -+	sie64a(vm.sblk, &vm.save_area);
    -+	// interpretation on -> configuration dependent if initial exception causes
    -+	// interception, but invalid new program PSW must
    ++	sie(&vm);
    ++	/* interpretation on -> configuration dependent if initial exception causes
    ++	 * interception, but invalid new program PSW must
    ++	 */
     +	report(vm.sblk->icptcode == ICPT_PROGI
     +	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION,
     +	       "Received specification exception intercept");
    -+	if (vm.sblk->gpsw.addr == 0xdeadbeef)
    -+		report_info("Interpreted non program new PSW specification exception");
    ++	if (vm.sblk->gpsw.addr == 0xdeadbeee)
    ++		report_info("Interpreted initial exception, intercepted invalid program new PSW exception");
     +	else
    -+		report_info("Did not interpret non program new PSW specification exception");
    ++		report_info("Did not interpret initial exception");
    ++	report_prefix_pop();
     +	report_prefix_pop();
     +}
     +

base-commit: fe26131eec769cef7ad7e2e1e4e192aa0bdb2bba
-- 
2.31.1

