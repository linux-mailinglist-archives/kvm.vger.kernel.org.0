Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33DDC5F6515
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 13:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbiJFLQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 07:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiJFLQF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 07:16:05 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4415F7CA
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 04:16:04 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 296Amtdb018700
        for <kvm@vger.kernel.org>; Thu, 6 Oct 2022 11:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=K0I2qraPSITNWBVkq32msI/w3+CHOY7QTILkjV3Tk4A=;
 b=UFx+Xc4oZT5+gy8XVlo4sPQECTQtUaHYmNTwZGEktW0QAJF5oSQnhwb1Nj/uwRsV+CQI
 Fkt1gKuJEWZoDXJ8niU0A38q8fhJpJfAFBzjyvkiXSM4OFxTfAi0fpHlR2rdK1dtxVrt
 lQgPF9nbVU6MGazbvWS9lqdzDlxFO73gU31903DkihSBlMw526YgqtITiIlHSwxpi/cz
 1Rm9586VePqZroIRLk83Y/IqVDedLg3oMRYoe6g1RRhohEA4VDJV/pzlOvANBeb8UyOg
 soJ1U504O5TRe4HjYDPAyHMm0Et6lPvDUZTlATUSgoeLWLAvnoyRg3I8K3qnnz3R4hG8 Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1wkhgnvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 11:16:03 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 296AnsfM021001
        for <kvm@vger.kernel.org>; Thu, 6 Oct 2022 11:16:03 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k1wkhgnuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 11:16:03 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 296B6Qrk012877;
        Thu, 6 Oct 2022 11:16:01 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3jxd68w3f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 11:16:01 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 296BFvBa7209572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Oct 2022 11:15:58 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8273A4059;
        Thu,  6 Oct 2022 11:15:57 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A84E2A4053;
        Thu,  6 Oct 2022 11:15:57 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.242])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 Oct 2022 11:15:57 +0000 (GMT)
Date:   Thu, 6 Oct 2022 13:15:55 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: add exittime tests
Message-ID: <20221006131555.47f42550@p-imbrenda>
In-Reply-To: <20220901150956.1075828-3-nrb@linux.ibm.com>
References: <20220901150956.1075828-1-nrb@linux.ibm.com>
        <20220901150956.1075828-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1-DfptoO1qhWbK0hxq1oJ4S7T7exUKux
X-Proofpoint-ORIG-GUID: hy314IUe-_OmCjri2WaR42O9SdNNte6i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_05,2022-10-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 adultscore=0 clxscore=1015
 suspectscore=0 mlxscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210060066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  1 Sep 2022 17:09:56 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Add a test to measure the execution time of several instructions. This
> can be helpful in finding performance regressions in hypervisor code.
>=20
> All tests are currently reported as PASS, since the baseline for their
> execution time depends on the respective environment and since needs to
> be determined on a case-by-case basis.
>=20
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/exittime.c    | 255 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   4 +
>  3 files changed, 260 insertions(+)
>  create mode 100644 s390x/exittime.c
>=20
> diff --git a/s390x/Makefile b/s390x/Makefile
> index efd5e0c13102..5dcac244767f 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -34,6 +34,7 @@ tests +=3D $(TEST_DIR)/migration.elf
>  tests +=3D $(TEST_DIR)/pv-attest.elf
>  tests +=3D $(TEST_DIR)/migration-cmm.elf
>  tests +=3D $(TEST_DIR)/migration-skey.elf
> +tests +=3D $(TEST_DIR)/exittime.elf
> =20
>  pv-tests +=3D $(TEST_DIR)/pv-diags.elf
> =20
> diff --git a/s390x/exittime.c b/s390x/exittime.c
> new file mode 100644
> index 000000000000..543c82ff3906
> --- /dev/null
> +++ b/s390x/exittime.c
> @@ -0,0 +1,255 @@
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
> +	/* nops don't trap into the hypervisor, so let's test them for referenc=
e */
> +	asm volatile("nop" : : : "memory");
> +}
> +
> +static void test_diag9c(long destcpu)
> +{
> +	asm volatile("diag %[destcpu],0,0x9c"
> +		:
> +		: [destcpu] "d" (destcpu)
> +		:

here you leave some unused :

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
> +	asm volatile("diag 0,0,0x44");
> +}
> +
> +static void test_stnsm(long ignore)
> +{
> +	int out;
> +
> +	asm volatile(
> +		"stnsm %[out],0xff"
> +		: [out] "=3DQ" (out)
> +		:

here too, but you are using only 2

> +	);
> +}
> +
> +static void test_stosm(long ignore)
> +{
> +	int out;
> +
> +	asm volatile(
> +		"stosm %[out],0"
> +		: [out] "=3DQ" (out)
> +		:
> +	);
> +}
> +
> +static long setup_ssm(long ignore)
> +{
> +	long system_mask =3D 0;
> +
> +	asm volatile(
> +		"stosm %[system_mask],0"
> +		: [system_mask] "=3DQ" (system_mask)
> +		:
> +		:
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
> +		:
> +	);
> +}
> +
> +static long setup_lctl4(long ignore)
> +{
> +	long ctl4_orig =3D 0;
> +
> +	asm volatile(
> +		"stctg 4,4,%[ctl4_orig]"
> +		: [ctl4_orig] "=3DS" (ctl4_orig)
> +		:
> +		:
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
> +		:
> +	);
> +}
> +
> +static void test_stpx(long ignore)
> +{
> +	unsigned int prefix;
> +
> +	asm volatile(
> +		"stpx %[prefix]"
> +		: [prefix] "=3DQ" (prefix)

here you are only using the : you actually need

> +	);
> +}
> +
> +static void test_stfl(long ignore)
> +{
> +	asm volatile(
> +		"stfl 0" : : : "memory"
> +	);
> +}
> +
> +static void test_epsw(long ignore)
> +{
> +	long r1, r2;
> +
> +	asm volatile(
> +		"epsw %[r1], %[r2]"
> +		: [r1] "=3Dd" (r1), [r2] "=3Dd" (r2)
> +		:
> +		:
> +	);
> +}
> +
> +static void test_illegal(long ignore)
> +{
> +	expect_pgm_int();
> +	asm volatile(
> +		".word 0"
> +		:
> +		:
> +		:

here none are needed

> +	);
> +	clear_pgm_int();
> +}

decide how you want to do for the : and then do it uniformly.

either you always put all three : (except when none are needed), or you
always only put as many as needed, without empty trailing ones.

> +
> +static long setup_servc(long arg)
> +{
> +	memset(pagebuf, 0, PAGE_SIZE);
> +	return arg;
> +}
> +
> +static void test_servc(long ignore)
> +{
> +	SCCB *sccb =3D (SCCB *) pagebuf;
> +
> +	sccb->h.length =3D 8;
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
> +} const exittime_tests[] =3D {
> +	{"nop",                   NULL,                   test_nop,            =
    0, 200000 },
> +	{"sigp sense running(0)", NULL,                   test_sigp_sense_runni=
ng, 0, 20000 },
> +	{"sigp sense running(1)", NULL,                   test_sigp_sense_runni=
ng, 1, 20000 },
> +	{"diag9c(self)",          setup_get_this_cpuaddr, test_diag9c,         =
    0, 2000 },
> +	{"diag9c(0)",             NULL,                   test_diag9c,         =
    0, 2000 },
> +	{"diag9c(1)",             NULL,                   test_diag9c,         =
    1, 2000 },
> +	{"diag44",                NULL,                   test_diag44,         =
    0, 2000 },
> +	{"stnsm",                 NULL,                   test_stnsm,          =
    0, 200000 },
> +	{"stosm",                 NULL,                   test_stosm,          =
    0, 200000 },
> +	{"ssm",                   setup_ssm,              test_ssm,            =
    0, 200000 },
> +	{"lctl4",                 setup_lctl4,            test_lctl4,          =
    0, 20000 },
> +	{"stpx",                  NULL,                   test_stpx,           =
    0, 2000 },
> +	{"stfl",                  NULL,                   test_stfl,           =
    0, 2000 },
> +	{"epsw",                  NULL,                   test_epsw,           =
    0, 20000 },
> +	{"illegal",               NULL,                   test_illegal,        =
    0, 2000 },
> +	{"servc",                 setup_servc,            test_servc,          =
    0, 2000 },
> +	{"stsi122",               NULL,                   test_stsi,           =
    1, 200 },
> +	{"stsi222",               NULL,                   test_stsi,           =
    2, 200 },
> +	{"stsi322",               NULL,                   test_stsi,           =
    3, 200 },
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
> +	const int outer_iters =3D 100;
> +	struct test const *current_test;
> +	uint64_t start, end, elapsed, worst, best, total;
> +
> +	report_prefix_push("exittime");
> +	report_pass("reporting total/best/worst of %d outer iterations", outer_=
iters);
> +
> +	for (i =3D 0; i < ARRAY_SIZE(exittime_tests); i++) {
> +		current_test =3D &exittime_tests[i];
> +		total =3D 0;
> +		worst =3D 0;
> +		best =3D -1;
> +		report_prefix_pushf("%s", current_test->name);
> +
> +		testfunc_arg =3D current_test->arg;
> +		if (current_test->setupfunc)
> +			testfunc_arg =3D current_test->setupfunc(testfunc_arg);
> +
> +		for (j =3D 0; j < outer_iters; j++) {
> +			start =3D get_clock_fast();
> +			for (k =3D 0; k < current_test->iters; k++)
> +				current_test->testfunc(testfunc_arg);
> +			end =3D get_clock_fast();
> +			elapsed =3D end - start;
> +			best =3D MIN(best, elapsed);
> +			worst =3D MAX(worst, elapsed);
> +			total +=3D elapsed;
> +		}
> +		report_pass("iters/total/best/worst %lu/%lu/%lu/%lu us", current_test-=
>iters, tod_to_us(total), tod_to_us(best), tod_to_us(worst));

perhaps it would not be a bad idea to also print the average and the
standard deviation (=CF=83)

> +		report_prefix_pop();
> +	}
> +
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index f7b1fc3dbca1..c11d1d987c82 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -185,3 +185,7 @@ groups =3D migration
>  [migration-skey]
>  file =3D migration-skey.elf
>  groups =3D migration
> +
> +[exittime]
> +file =3D exittime.elf
> +smp =3D 2

