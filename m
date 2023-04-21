Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C4D6EAE1E
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 17:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbjDUPgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 11:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjDUPgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 11:36:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9DE5FE5;
        Fri, 21 Apr 2023 08:36:36 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33LFa58Y018462;
        Fri, 21 Apr 2023 15:36:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=CWpwTSJylWQeKHiZNbAV3Wsl3xXbmGllmxMIGYIixRw=;
 b=Jze1WaISzGUpaWzIRz/qs/DsVPCK8bKHPEjkKvEYS+nGrpAew5A9kBDtogOTb2UFWUTw
 wm8KLFoMfmuUEAyBC7Y4OObeaOnQ2P4Q2QxW706lFwzRFaxJVnE91Y4Hxp8OQ9fsiT9o
 fqfU3v4FmCNix/dKrBB0GUxJx9KENCJmDM8KOhkqgP0O9jWKtKnlJPwCPt4XqkV3Bnz5
 KYsxOpFsJG+9/jznRLtOhGB7WYDh8lRBHduT3f4zQyKbfNBCInniLb8YqdAO+kCM0wSW
 Sq6Y6BITaEhGmYR0rGl+aOPfW4Ek96mbAetJnJYIHpeyb96K1DExmIPpB4lzgmZkAo5D NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3tcf8yqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 15:36:31 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33LFa941018809;
        Fri, 21 Apr 2023 15:36:09 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3tcf8ybr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 15:36:09 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33LAw4ig024711;
        Fri, 21 Apr 2023 15:32:25 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3pykj6kdyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 15:32:25 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33LFWMY87537342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 15:32:22 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05D3220049;
        Fri, 21 Apr 2023 15:32:22 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A3DC20040;
        Fri, 21 Apr 2023 15:32:21 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.17.52])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
        Fri, 21 Apr 2023 15:32:21 +0000 (GMT)
Date:   Fri, 21 Apr 2023 17:23:15 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        nrb@linux.ibm.com, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 5/7] s390x: pv: Add sie entry
 intercept and validity test
Message-ID: <20230421172315.675d6b59@p-imbrenda>
In-Reply-To: <20230421113647.134536-6-frankja@linux.ibm.com>
References: <20230421113647.134536-1-frankja@linux.ibm.com>
        <20230421113647.134536-6-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: F3z-tUzCpx3z2wj0WXYhsElIJ0r-QohA
X-Proofpoint-ORIG-GUID: oiKRTta87S5NKy39EbjgfvRCzw5e56Be
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_08,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210137
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Apr 2023 11:36:45 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

[...]

> +static void run_loop(void)
> +{
> +	sie(&vm);
> +	sigp_retry(stap(), SIGP_STOP, 0, NULL);
> +}
> +
> +static void test_validity_already_running(void)
> +{
> +	extern const char SNIPPET_NAME_START(asm, loop)[];
> +	extern const char SNIPPET_NAME_END(asm, loop)[];
> +	extern const char SNIPPET_HDR_START(asm, loop)[];
> +	extern const char SNIPPET_HDR_END(asm, loop)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, loop);
> +	int size_gbin = SNIPPET_LEN(asm, loop);
> +	struct psw psw = {
> +		.mask = PSW_MASK_64,
> +		.addr = (uint64_t)run_loop,
> +	};
> +
> +	report_prefix_push("already running");
> +	if (smp_query_num_cpus() < 3) {
> +		report_skip("need at least 3 cpus for this test");
> +		goto out;
> +	}
> +
> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, loop),
> +			SNIPPET_HDR_START(asm, loop),
> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
> +
> +	sie_expect_validity(&vm);
> +	smp_cpu_setup(1, psw);

I would expect the validity here instead (one CPU should run fine)

> +	smp_cpu_setup(2, psw);
> +	while (vm.sblk->icptcode != ICPT_VALIDITY) {
> +		mb();
> +	}
> +
> +	/*
> +	 * One cpu will enter SIE and one will receive the validity.
> +	 * We rely on the expectation that the cpu in SIE won't exit
> +	 * until we had a chance to observe the validity as the exit
> +	 * would overwrite the validity.
> +	 *
> +	 * In general that expectation is valid but HW/FW can in
> +	 * theory still exit to handle their interrupts.
> +	 */
> +	report(uv_validity_check(&vm), "validity");
> +	smp_cpu_stop(1);
> +	smp_cpu_stop(2);
> +	uv_destroy_guest(&vm);
> +
> +out:
> +	report_prefix_pop();
> +}
> +
> +/* Tests if a vcpu handle from another configuration results in a validity intercept. */
> +static void test_validity_handle_not_in_config(void)
> +{
> +	extern const char SNIPPET_NAME_START(asm, icpt_loop)[];
> +	extern const char SNIPPET_NAME_END(asm, icpt_loop)[];
> +	extern const char SNIPPET_HDR_START(asm, icpt_loop)[];
> +	extern const char SNIPPET_HDR_END(asm, icpt_loop)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, icpt_loop);
> +	int size_gbin = SNIPPET_LEN(asm, icpt_loop);
> +
> +	report_prefix_push("handle not in config");
> +	/* Setup our primary vm */
> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, icpt_loop),
> +			SNIPPET_HDR_START(asm, icpt_loop),
> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
> +
> +	/* Setup secondary vm */
> +	snippet_setup_guest(&vm2, true);
> +	snippet_pv_init(&vm2, SNIPPET_NAME_START(asm, icpt_loop),
> +			SNIPPET_HDR_START(asm, icpt_loop),
> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
> +
> +	vm.sblk->pv_handle_cpu = vm2.sblk->pv_handle_cpu;
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report(uv_validity_check(&vm), "validity");

you tested the case where you have the right sie control block but with
the wrong cpu handle, could you also do the other way around? (put the
config handle of the wrong VM)

> +
> +	/* Restore cpu handle and destroy the second vm */
> +	vm.sblk->pv_handle_cpu = vm.uv.vcpu_handle;
> +	uv_destroy_guest(&vm2);
> +	sie_guest_destroy(&vm2);
> +
> +	uv_destroy_guest(&vm);
> +	report_prefix_pop();
> +}
> +
> +/* Tests if a wrong vm or vcpu handle results in a validity intercept. */
> +static void test_validity_seid(void)
> +{
> +	extern const char SNIPPET_NAME_START(asm, icpt_loop)[];
> +	extern const char SNIPPET_NAME_END(asm, icpt_loop)[];
> +	extern const char SNIPPET_HDR_START(asm, icpt_loop)[];
> +	extern const char SNIPPET_HDR_END(asm, icpt_loop)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, icpt_loop);
> +	int size_gbin = SNIPPET_LEN(asm, icpt_loop);
> +	int fails = 0;
> +	int i;
> +
> +	report_prefix_push("handles");
> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, icpt_loop),
> +			SNIPPET_HDR_START(asm, icpt_loop),
> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
> +
> +	for (i = 0; i < 64; i++) {
> +		vm.sblk->pv_handle_config ^= 1UL << i;
> +		sie_expect_validity(&vm);
> +		sie(&vm);
> +		if (!uv_validity_check(&vm)) {
> +			report_fail("SIE accepted wrong VM SEID, changed bit %d",
> +				    63 - i);
> +			fails++;
> +		}
> +		vm.sblk->pv_handle_config ^= 1UL << i;
> +	}
> +	report(!fails, "No wrong vm handle accepted");
> +
> +	fails = 0;
> +	for (i = 0; i < 64; i++) {
> +		vm.sblk->pv_handle_cpu ^= 1UL << i;
> +		sie_expect_validity(&vm);
> +		sie(&vm);
> +		if (!uv_validity_check(&vm)) {
> +			report_fail("SIE accepted wrong CPU SEID, changed bit %d",
> +				    63 - i);
> +			fails++;
> +		}
> +		vm.sblk->pv_handle_cpu ^= 1UL << i;
> +	}
> +	report(!fails, "No wrong cpu handle accepted");
> +
> +	uv_destroy_guest(&vm);
> +	report_prefix_pop();
> +}

[...]

> +static void run_icpt_122_tests_prefix(unsigned long prefix)
> +{
> +	char prfxstr[7];
> +	uint32_t *ptr = 0;
> +
> +	snprintf(prfxstr, sizeof(prfxstr), "0x%lx", prefix);
> +
> +	report_prefix_push(prfxstr);

report_prefix_pushf ?

> +	report_prefix_push("unshared");
> +	run_icpt_122_tests(prefix);
> +	report_prefix_pop();
> +
> +	/*
> +	 * Guest will share the lowcore and we need to check if that
> +	 * makes a difference (which it should not).
> +	 */
> +	report_prefix_push("shared");
> +
> +	sie(&vm);
> +	/* Guest indicates that it has been setup via the diag 0x44 */
> +	assert(pv_icptdata_check_diag(&vm, 0x44));
> +	/* If the pages have not been shared these writes will cause exceptions */
> +	ptr = (uint32_t *)prefix;
> +	WRITE_ONCE(ptr, 0);
> +	ptr = (uint32_t *)(prefix + offsetof(struct lowcore, ars_sa[0]));
> +	WRITE_ONCE(ptr, 0);
> +
> +	run_icpt_122_tests(prefix);
> +
> +	/* shared*/
> +	report_prefix_pop();
> +	/* prefix hex value */
> +	report_prefix_pop();
> +}

[...]

> diff --git a/s390x/snippets/asm/pv-icpt-vir-timing.S b/s390x/snippets/asm/pv-icpt-vir-timing.S
> new file mode 100644
> index 00000000..b35f02c9
> --- /dev/null
> +++ b/s390x/snippets/asm/pv-icpt-vir-timing.S
> @@ -0,0 +1,22 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Sets a cpu timer which the host can manipulate to check if it will
> + * receive a validity
> + *
> + * Copyright (c) 2023 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
> +.section .text
> +larl	%r1, time_val
> +spt	0 (%r1)
> +diag    0, 0, 0x44
> +xgr	%r1, %r1

why do you need the xgr?

> +lghi	%r1, 42

you're overwriting the whole register here

> +diag	1, 0, 0x9c
> +
> +
> +.align 8
> +time_val:
> +	.quad 0x280de80000
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index b61faf07..e2d3478e 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -218,3 +218,8 @@ extra_params = -append '--parallel'
>  
>  [execute]
>  file = ex.elf
> +
> +[pv-icptcode]
> +file = pv-icptcode.elf
> +smp = 3
> +extra_params = -m 2200

