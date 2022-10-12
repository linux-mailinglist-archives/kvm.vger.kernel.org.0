Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B635FC682
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 15:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiJLNbI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 09:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiJLNbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 09:31:02 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B6DA9243
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 06:31:00 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29CDCC9n019996
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 13:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0maUOhoV09JYnfDm9L0UFRfwxDO5I2ZWFISpyAKzJa8=;
 b=b91T+X2t6vcwj18p1G2gaUWIk1GwXvb4XA8QidFdyvxlooXaZfGFZ3rSz1yfjb6mi2J5
 RhnnAjqC4u9Jro62kWEjsBpPfGhRcGLPXeBd/s0BSvKT0GwSKCbcMtOy3gPJfwG+SR4r
 Vc/ELr/FpMVz4jr1DLUQjIgCrvRHV+g2nuyvMoPXlrFy6kdpgv8+JP6P/c16Yij6zxvZ
 EJ2cMrDhoM7Dd1oaXH3ORRI5fuNdNourmyorZ8qrHRMaoMpaU8mPe1OApcT5AaVZv1YF
 pfiLw7q+2h27pxlV5oz+l0TKbGYOVTFsyZd1ln7nTk/GR2N3WrfGI/FOsgZriHnw+7f7 vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5vh0khec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 13:30:59 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29CDFgGM004826
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 13:30:58 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k5vh0khdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 13:30:58 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29CDLnLv014644;
        Wed, 12 Oct 2022 13:30:57 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3k30u94k5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 13:30:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29CDUrrh66322872
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 13:30:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9986BA405F;
        Wed, 12 Oct 2022 13:30:53 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4814EA4054;
        Wed, 12 Oct 2022 13:30:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.11.193])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Oct 2022 13:30:53 +0000 (GMT)
Date:   Wed, 12 Oct 2022 15:30:51 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 1/1] s390x: add exittime tests
Message-ID: <20221012153051.4b19eb33@p-imbrenda>
In-Reply-To: <20221012124453.1207013-2-nrb@linux.ibm.com>
References: <20221012124453.1207013-1-nrb@linux.ibm.com>
        <20221012124453.1207013-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 33J_LO9n94ZNG9f_XRhuJLv9BY_B9Js7
X-Proofpoint-ORIG-GUID: Xp_-FYTlsR_mNVnD4wPZUZz9z0hAlfm-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_06,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 adultscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210120086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Oct 2022 14:44:53 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Add a test to measure the execution time of several instructions. This
> can be helpful in finding performance regressions in hypervisor code.
> 
> All tests are currently reported as PASS, since the baseline for their
> execution time depends on the respective environment and since needs to
> be determined on a case-by-case basis.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/exittime.c    | 253 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   4 +
>  3 files changed, 258 insertions(+)
>  create mode 100644 s390x/exittime.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index fba09bc2df3a..a28c6746cf55 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -37,6 +37,7 @@ tests += $(TEST_DIR)/migration-skey.elf
>  tests += $(TEST_DIR)/panic-loop-extint.elf
>  tests += $(TEST_DIR)/panic-loop-pgm.elf
>  tests += $(TEST_DIR)/migration-sck.elf
> +tests += $(TEST_DIR)/exittime.elf
>  
>  pv-tests += $(TEST_DIR)/pv-diags.elf
>  
> diff --git a/s390x/exittime.c b/s390x/exittime.c
> new file mode 100644
> index 000000000000..8e00a3c3559a
> --- /dev/null
> +++ b/s390x/exittime.c
> @@ -0,0 +1,253 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Measure run time of various instructions. Can be used to find runtime
> + * regressions of instructions which cause exits.
> + *
> + * Copyright IBM Corp. 2022
> + *
> + * Authors:
> + *  Nico Boehr <nrb@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <smp.h>
> +#include <sclp.h>
> +#include <asm/time.h>
> +#include <asm/sigp.h>
> +#include <asm/interrupt.h>
> +#include <asm/page.h>
> +
> +char pagebuf[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
> +
> +static void test_sigp_sense_running(long destcpu)
> +{
> +	smp_sigp(destcpu, SIGP_SENSE_RUNNING, 0, NULL);
> +}
> +
> +static void test_nop(long ignore)
> +{
> +	/* nops don't trap into the hypervisor, so let's test them for reference */
> +	asm volatile(
> +		"nop"
> +		:
> +		:
> +		: "memory"
> +	);
> +}
> +
> +static void test_diag9c(long destcpu)
> +{
> +	asm volatile(
> +		"diag %[destcpu],0,0x9c"
> +		:
> +		: [destcpu] "d" (destcpu)
> +	);
> +}
> +
> +static long setup_get_this_cpuaddr(long ignore)
> +{
> +	return stap();
> +}
> +
> +static void test_diag44(long ignore)
> +{
> +	asm volatile(
> +		"diag 0,0,0x44"
> +	);
> +}
> +
> +static void test_stnsm(long ignore)
> +{
> +	int out;
> +
> +	asm volatile(
> +		"stnsm %[out],0xff"
> +		: [out] "=Q" (out)
> +	);
> +}
> +
> +static void test_stosm(long ignore)
> +{
> +	int out;
> +
> +	asm volatile(
> +		"stosm %[out],0"
> +		: [out] "=Q" (out)
> +	);
> +}
> +
> +static long setup_ssm(long ignore)
> +{
> +	long system_mask = 0;
> +
> +	asm volatile(
> +		"stosm %[system_mask],0"
> +		: [system_mask] "=Q" (system_mask)
> +	);
> +
> +	return system_mask;
> +}
> +
> +static void test_ssm(long old_system_mask)
> +{
> +	asm volatile(
> +		"ssm %[old_system_mask]"
> +		:
> +		: [old_system_mask] "Q" (old_system_mask)
> +	);
> +}
> +
> +static long setup_lctl4(long ignore)
> +{
> +	long ctl4_orig = 0;
> +
> +	asm volatile(
> +		"stctg 4,4,%[ctl4_orig]"
> +		: [ctl4_orig] "=S" (ctl4_orig)
> +	);
> +
> +	return ctl4_orig;
> +}
> +
> +static void test_lctl4(long ctl4_orig)
> +{
> +	asm volatile(
> +		"lctlg 4,4,%[ctl4_orig]"
> +		:
> +		: [ctl4_orig] "S" (ctl4_orig)
> +	);
> +}
> +
> +static void test_stpx(long ignore)
> +{
> +	unsigned int prefix;
> +
> +	asm volatile(
> +		"stpx %[prefix]"
> +		: [prefix] "=Q" (prefix)
> +	);
> +}
> +
> +static void test_stfl(long ignore)
> +{
> +	asm volatile(
> +		"stfl 0"
> +		:
> +		:
> +		: "memory"
> +	);
> +}
> +
> +static void test_epsw(long ignore)
> +{
> +	long r1, r2;
> +
> +	asm volatile(
> +		"epsw %[r1], %[r2]"
> +		: [r1] "=d" (r1), [r2] "=d" (r2)
> +	);
> +}
> +
> +static void test_illegal(long ignore)
> +{
> +	expect_pgm_int();
> +	asm volatile(
> +		".word 0"
> +	);
> +	clear_pgm_int();
> +}
> +
> +static long setup_servc(long arg)
> +{
> +	memset(pagebuf, 0, PAGE_SIZE);
> +	return arg;
> +}
> +
> +static void test_servc(long ignore)
> +{
> +	SCCB *sccb = (SCCB *) pagebuf;
> +
> +	sccb->h.length = 8;
> +	servc(0, (unsigned long) sccb);
> +}
> +
> +static void test_stsi(long fc)
> +{
> +	stsi(pagebuf, fc, 2, 2);
> +}
> +
> +struct test {
> +	const char *name;
> +	/*
> +	 * When non-null, will be called once before running the test loop.
> +	 * Its return value will be given as argument to testfunc.
> +	 */
> +	long (*setupfunc)(long arg);
> +	void (*testfunc)(long arg);
> +	long arg;
> +	long iters;
> +} const exittime_tests[] = {
> +	{"nop",                   NULL,                   test_nop,                0, 200000 },
> +	{"sigp sense running(0)", NULL,                   test_sigp_sense_running, 0, 20000 },
> +	{"sigp sense running(1)", NULL,                   test_sigp_sense_running, 1, 20000 },
> +	{"diag9c(self)",          setup_get_this_cpuaddr, test_diag9c,             0, 2000 },
> +	{"diag9c(0)",             NULL,                   test_diag9c,             0, 2000 },
> +	{"diag9c(1)",             NULL,                   test_diag9c,             1, 2000 },
> +	{"diag44",                NULL,                   test_diag44,             0, 2000 },
> +	{"stnsm",                 NULL,                   test_stnsm,              0, 200000 },
> +	{"stosm",                 NULL,                   test_stosm,              0, 200000 },
> +	{"ssm",                   setup_ssm,              test_ssm,                0, 200000 },
> +	{"lctl4",                 setup_lctl4,            test_lctl4,              0, 20000 },
> +	{"stpx",                  NULL,                   test_stpx,               0, 2000 },
> +	{"stfl",                  NULL,                   test_stfl,               0, 2000 },
> +	{"epsw",                  NULL,                   test_epsw,               0, 20000 },
> +	{"illegal",               NULL,                   test_illegal,            0, 2000 },
> +	{"servc",                 setup_servc,            test_servc,              0, 2000 },
> +	{"stsi122",               NULL,                   test_stsi,               1, 200 },
> +	{"stsi222",               NULL,                   test_stsi,               2, 200 },
> +	{"stsi322",               NULL,                   test_stsi,               3, 200 },
> +};
> +
> +static uint64_t tod_to_us(uint64_t tod)
> +{
> +	return tod >> STCK_SHIFT_US;
> +}
> +
> +int main(void)
> +{
> +	int i, j, k, testfunc_arg;
> +	const int outer_iters = 100;
> +	struct test const *current_test;
> +	uint64_t start, end, elapsed, worst, best, total, average;
> +
> +	report_prefix_push("exittime");
> +	report_pass("reporting total/best/worst of %d outer iterations", outer_iters);

you can just do a report_info here

> +
> +	for (i = 0; i < ARRAY_SIZE(exittime_tests); i++) {
> +		current_test = &exittime_tests[i];
> +		total = 0;
> +		worst = 0;
> +		best = -1;
> +		report_prefix_pushf("%s", current_test->name);
> +
> +		testfunc_arg = current_test->arg;
> +		if (current_test->setupfunc)
> +			testfunc_arg = current_test->setupfunc(testfunc_arg);
> +
> +		for (j = 0; j < outer_iters; j++) {
> +			stckf(&start);
> +			for (k = 0; k < current_test->iters; k++)
> +				current_test->testfunc(testfunc_arg);
> +			stckf(&end);

so the actual number of iterations is outer_iters * current_test->iters?

> +			elapsed = end - start;
> +			best = MIN(best, elapsed);
> +			worst = MAX(worst, elapsed);
> +			total += elapsed;
> +		}
> +		average = total / outer_iters;

so the average is per block

> +		report_pass("iters/total/best/avg/worst %lu/%lu/%lu/%lu/%lu us", current_test->iters, tod_to_us(total), tod_to_us(best), tod_to_us(average), tod_to_us(worst));

but here you give the number of iterations per block, but not the
number of blocks

so average min and max are per block, this means that it's not really
possible to measure the actual time of a single operation

maybe do a report_info with: outer_iters, current_test->iters, total

and then the report_pass with best avg worst, but per individual test,
not per block

something like average = total / (outer_iters * current_test->iters),

or at least normalize them, something like:

average = total / (outer_iters * current_test->iters / 1000);

so the numbers are always about the same number of actual iterations

(and then make sure current_test->iters is always at least 1000, it
doesn't matter if the test needs a few seconds to complete, as long as
it doesn't take minutes)

> +		report_prefix_pop();
> +	}
> +
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 2c04ae7c7c15..feb9abf03745 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -201,3 +201,7 @@ timeout = 5
>  [migration-sck]
>  file = migration-sck.elf
>  groups = migration
> +
> +[exittime]
> +file = exittime.elf
> +smp = 2

