Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFA469819B
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjBORGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbjBORGi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:06:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02A211EB3;
        Wed, 15 Feb 2023 09:06:35 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31FGqW4A027688;
        Wed, 15 Feb 2023 17:06:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=gurvaWfCx++nflDtA5UxsLe9y+K2uLQNdregC07tNIQ=;
 b=BSDhCPytnSN9xLOJ6Vr8SAb6JyPMWb4UP7qYoiVDqfBsJlONTzJ9/taaMonTpkAiD+lH
 eg9WDum8RZWH3Svxc/lzPm7Er1rB689wrRHeNGRuFeOqNJ/5Gdtf8fbPDMvdrPe32YuR
 aVF+MTYohalFtnwVlPjIuQLUa5dwXO3Yc9+02Hm4+MjKk1IbJDHcHapCcIR9BQSTgpdb
 Cw0C0D+05ukLqKOcTVud80e8G82oukOSi4EF+o46eBhYeq0gPf2f7moEvNLBFbwtVJe5
 3CxrGWwlFTcNer1dE+r3C3Ke5Ua/1oS4rFTbuFg7HXyjLrpN2S2T1j0ugBScTLsUNDlw 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ns3a3ge0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 17:06:35 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31FGqokI031344;
        Wed, 15 Feb 2023 17:06:34 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ns3a3gdyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 17:06:34 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31F2nXqh007609;
        Wed, 15 Feb 2023 17:06:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3np2n6c5q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Feb 2023 17:06:31 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31FH6Swp47841720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Feb 2023 17:06:28 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0829C20040;
        Wed, 15 Feb 2023 17:06:28 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B584520043;
        Wed, 15 Feb 2023 17:06:27 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 15 Feb 2023 17:06:27 +0000 (GMT)
Date:   Wed, 15 Feb 2023 18:06:25 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: pv: Test sie entry intercepts
 and validities
Message-ID: <20230215180625.53b260a9@p-imbrenda>
In-Reply-To: <20230201084833.39846-3-frankja@linux.ibm.com>
References: <20230201084833.39846-1-frankja@linux.ibm.com>
        <20230201084833.39846-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: y55AFA-ElEl6Nhs7FbhYbwTIhlZUDMSI
X-Proofpoint-GUID: jebf2xMUSnf79NpIsp1YNT60Vxy5t6hX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-15_07,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 clxscore=1011 spamscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302150154
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  1 Feb 2023 08:48:32 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The lowcore is an important part of any s390 cpu so we need to make
> sure it's always available when we virtualize one. For non-PV guests
> that would mean ensuring that the lowcore page is read and writable by
> the guest.
> 
> For PV guests we additionally need to make sure that the page is owned
> by the guest as it is only allowed to access them if that's the
> case. The code 112 SIE intercept tells us if the lowcore pages aren't
> secure anymore.
> 
> Let's check if that intercept is reported by SIE if we export the
> lowcore pages. Additionally check if that's also the case if the guest
> shares the lowcore which will make it readable to the host but
> ownership of the page should not change.
> 
> Also we check for validities in these conditions:
>      * Manipulated cpu timer
>      * Double SIE for same vcpu
>      * Re-use of VCPU handle from another secure configuration
>      * ASCE re-use
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

looks good, see some questions below

> ---
>  s390x/Makefile                                |   5 +
>  s390x/pv-icptcode.c                           | 366 ++++++++++++++++++
>  s390x/snippets/asm/snippet-loop.S             |  12 +
>  s390x/snippets/asm/snippet-pv-icpt-112.S      |  77 ++++
>  s390x/snippets/asm/snippet-pv-icpt-loop.S     |  15 +
>  .../snippets/asm/snippet-pv-icpt-vir-timing.S |  22 ++
>  6 files changed, 497 insertions(+)
>  create mode 100644 s390x/pv-icptcode.c
>  create mode 100644 s390x/snippets/asm/snippet-loop.S
>  create mode 100644 s390x/snippets/asm/snippet-pv-icpt-112.S
>  create mode 100644 s390x/snippets/asm/snippet-pv-icpt-loop.S
>  create mode 100644 s390x/snippets/asm/snippet-pv-icpt-vir-timing.S
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 97a61611..858f5af4 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -41,6 +41,7 @@ tests += $(TEST_DIR)/migration-sck.elf
>  tests += $(TEST_DIR)/exittime.elf
>  
>  pv-tests += $(TEST_DIR)/pv-diags.elf
> +pv-tests += $(TEST_DIR)/pv-icptcode.elf
>  
>  ifneq ($(HOST_KEY_DOCUMENT),)
>  ifneq ($(GEN_SE_HEADER),)
> @@ -119,6 +120,10 @@ $(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
>  $(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-yield.gbin
>  $(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-288.gbin
>  $(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-500.gbin
> +$(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-icpt-112.gbin
> +$(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-icpt-loop.gbin
> +$(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-loop.gbin
> +$(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-icpt-vir-timing.gbin
>  
>  ifneq ($(GEN_SE_HEADER),)
>  snippets += $(pv-snippets)
> diff --git a/s390x/pv-icptcode.c b/s390x/pv-icptcode.c
> new file mode 100644
> index 00000000..1a2a4123
> --- /dev/null
> +++ b/s390x/pv-icptcode.c
> @@ -0,0 +1,366 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * PV virtualization interception tests for intercepts that are not
> + * caused by an instruction.
> + *
> + * Copyright (c) 2023 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <sie.h>
> +#include <smp.h>
> +#include <sclp.h>
> +#include <snippet.h>
> +#include <asm/facility.h>
> +#include <asm/barrier.h>
> +#include <asm/sigp.h>
> +#include <asm/uv.h>
> +
> +static struct vm vm, vm2;
> +
> +static void test_validity_timing(void)
> +{
> +	extern const char SNIPPET_NAME_START(asm, snippet_pv_icpt_vir_timing)[];
> +	extern const char SNIPPET_NAME_END(asm, snippet_pv_icpt_vir_timing)[];
> +	extern const char SNIPPET_HDR_START(asm, snippet_pv_icpt_vir_timing)[];
> +	extern const char SNIPPET_HDR_END(asm, snippet_pv_icpt_vir_timing)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_icpt_vir_timing);
> +	int size_gbin = SNIPPET_LEN(asm, snippet_pv_icpt_vir_timing);
> +
> +	report_prefix_push("manipulated cpu time");
> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_icpt_vir_timing),
> +			SNIPPET_HDR_START(asm, snippet_pv_icpt_vir_timing),
> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
> +
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x44,
> +	       "stp done");
> +	vm.sblk->cputm -= 0x280de80000 / 2;

so you are subtracting half of the value?

why not vm.sblk->cputm /= 2?
or just set a fixed (very low) magic value?

what should happen if the cpu timer is higher instead of lower?

> +
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report(uv_validity_check(&vm), "validity");
> +	uv_destroy_guest(&vm);
> +	report_prefix_pop();
> +}
> +
> +static void run_loop(void)
> +{
> +	sie(&vm);
> +	sigp_retry(stap(), SIGP_STOP, 0, NULL);
> +}
> +
> +static void test_validity_already_running(void)
> +{
> +	extern const char SNIPPET_NAME_START(asm, snippet_loop)[];
> +	extern const char SNIPPET_NAME_END(asm, snippet_loop)[];
> +	extern const char SNIPPET_HDR_START(asm, snippet_loop)[];
> +	extern const char SNIPPET_HDR_END(asm, snippet_loop)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_loop);
> +	int size_gbin = SNIPPET_LEN(asm, snippet_loop);
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
> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_loop),
> +			SNIPPET_HDR_START(asm, snippet_loop),
> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
> +
> +	sie_expect_validity(&vm);
> +	smp_cpu_setup(1, psw);
> +	smp_cpu_setup(2, psw);
> +	while (vm.sblk->icptcode != ICPT_VALIDITY) { mb(); }

maybe put the mb(); in a separate line

> +	/* Yes I know this is not reliable as one cpu might overwrite it */

the wording in this comment could be improved

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
> +	extern const char SNIPPET_NAME_START(asm, snippet_pv_icpt_loop)[];
> +	extern const char SNIPPET_NAME_END(asm, snippet_pv_icpt_loop)[];
> +	extern const char SNIPPET_HDR_START(asm, snippet_pv_icpt_loop)[];
> +	extern const char SNIPPET_HDR_END(asm, snippet_pv_icpt_loop)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_icpt_loop);
> +	int size_gbin = SNIPPET_LEN(asm, snippet_pv_icpt_loop);
> +
> +	report_prefix_push("handle not in config");
> +	/* Setup our primary vm */
> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_icpt_loop),
> +			SNIPPET_HDR_START(asm, snippet_pv_icpt_loop),
> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
> +
> +	/* Setup secondary vm */
> +	snippet_setup_guest(&vm2, true);
> +	snippet_pv_init(&vm2, SNIPPET_NAME_START(asm, snippet_pv_icpt_loop),
> +			SNIPPET_HDR_START(asm, snippet_pv_icpt_loop),
> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
> +
> +	vm.sblk->pv_handle_cpu = vm2.sblk->pv_handle_cpu;
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report(uv_validity_check(&vm), "validity");
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
> +	extern const char SNIPPET_NAME_START(asm, snippet_pv_icpt_loop)[];
> +	extern const char SNIPPET_NAME_END(asm, snippet_pv_icpt_loop)[];
> +	extern const char SNIPPET_HDR_START(asm, snippet_pv_icpt_loop)[];
> +	extern const char SNIPPET_HDR_END(asm, snippet_pv_icpt_loop)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_icpt_loop);
> +	int size_gbin = SNIPPET_LEN(asm, snippet_pv_icpt_loop);
> +	int fails = 0;
> +	int i;
> +
> +	report_prefix_push("handles");
> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_icpt_loop),
> +			SNIPPET_HDR_START(asm, snippet_pv_icpt_loop),
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
> +
> +/*
> + * Tests if we get a validity intercept if the CR1 asce at SIE entry
> + * is not the same as the one given at the UV creation of the VM.
> + */
> +static void test_validity_asce(void)
> +{
> +	extern const char SNIPPET_NAME_START(asm, snippet_pv_icpt_112)[];
> +	extern const char SNIPPET_NAME_END(asm, snippet_pv_icpt_112)[];
> +	extern const char SNIPPET_HDR_START(asm, snippet_pv_icpt_112)[];
> +	extern const char SNIPPET_HDR_END(asm, snippet_pv_icpt_112)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_icpt_112);
> +	int size_gbin = SNIPPET_LEN(asm, snippet_pv_icpt_112);
> +	uint64_t asce_old, asce_new;
> +	void *pgd_new, *pgd_old;
> +
> +	report_prefix_push("asce");
> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_icpt_112),
> +			SNIPPET_HDR_START(asm, snippet_pv_icpt_112),
> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
> +
> +	asce_old = vm.save_area.guest.asce;
> +	pgd_new = memalign_pages_flags(PAGE_SIZE, PAGE_SIZE * 4, 0);
> +	pgd_old = (void *)(asce_old & PAGE_MASK);
> +
> +	/* Copy the contents of the top most table */
> +	memcpy(pgd_new, pgd_old, PAGE_SIZE * 4);
> +
> +	/* Create the replacement ASCE */
> +	asce_new = __pa(pgd_new) | ASCE_DT_REGION1 | REGION_TABLE_LENGTH | ASCE_P;
> +	vm.save_area.guest.asce = asce_new;
> +
> +	sie_expect_validity(&vm);
> +	sie(&vm);
> +	report(uv_validity_check(&vm), "wrong CR1 validity");
> +
> +	/* Restore the old ASCE */
> +	vm.save_area.guest.asce = asce_old;
> +
> +	/* Try if we can still do an entry with the correct asce */
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x44,
> +	       "re-entry with valid CR1");
> +	uv_destroy_guest(&vm);
> +	free_pages(pgd_new);
> +	report_prefix_pop();
> +}
> +
> +static void test_icpt_112(void)
> +{
> +	extern const char SNIPPET_NAME_START(asm, snippet_pv_icpt_112)[];
> +	extern const char SNIPPET_NAME_END(asm, snippet_pv_icpt_112)[];
> +	extern const char SNIPPET_HDR_START(asm, snippet_pv_icpt_112)[];
> +	extern const char SNIPPET_HDR_END(asm, snippet_pv_icpt_112)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_icpt_112);
> +	int size_gbin = SNIPPET_LEN(asm, snippet_pv_icpt_112);
> +
> +	u64 lc_off = 0;
> +
> +	report_prefix_push("prefix");
> +
> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_icpt_112),
> +			SNIPPET_HDR_START(asm, snippet_pv_icpt_112),
> +			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
> +
> +	report_prefix_push("0x0");
> +	sie(&vm);
> +
> +	/* Guest indicates that it has been setup via the diag 0x44 */
> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x44,
> +	       "guest set up");
> +
> +	/*
> +	 * Let's export the standard prefix 0x0 and check for the 112
> +	 * intercept.
> +	 */
> +	uv_export(vm.sblk->mso + lc_off);
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_PREF, "Intercept 112 for page 0");
> +	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off);
> +
> +	uv_export(vm.sblk->mso + lc_off + PAGE_SIZE);
> +	report(vm.sblk->icptcode == ICPT_PV_PREF, "Intercept 112 for page 1");
> +
> +	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off + PAGE_SIZE);
> +
> +	/*
> +	 * Guest will share the lowcore and we need to check if that
> +	 * makes a difference (which it should not).
> +	 */
> +	report_prefix_push("shared");
> +	sie(&vm);
> +	/* Guest indicates that it has been setup via the diag 0x44 */
> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x44,
> +	       "guest shared the first lowcore page");
> +
> +	/*
> +	 * Let's export the standard prefix 0x0 and check for the 112
> +	 * intercept.
> +	 */
> +	uv_export(vm.sblk->mso + lc_off);
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_PREF, "Intercept 112");
> +	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off);
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +
> +
> +	report_prefix_push("0x8000");
> +	/*
> +	 * Import the new prefix pages so we don't get a PGM 0x3E on
> +	 * the guest's spx instruction.
> +	 */
> +	lc_off = 0x8000;
> +	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off);
> +	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off + PAGE_SIZE);
> +	sie(&vm);
> +
> +	/* SPX generates a PV instruction notification */
> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0xb210,
> +	       "Received a PV instruction notification intercept for spx");
> +	report(*(u32 *)vm.sblk->sidad == 0x8000, "New prefix is 0x8000");
> +
> +	/* Let's export the prefix at 0x8000 and check for the 112 intercept */
> +	uv_export(vm.sblk->mso + lc_off);
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_PREF, "Intercept 112 for page 0");
> +	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off);
> +
> +	uv_export(vm.sblk->mso + lc_off + PAGE_SIZE);
> +	report(vm.sblk->icptcode == ICPT_PV_PREF, "Intercept 112 for page 1");
> +
> +	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off + PAGE_SIZE);
> +
> +	report_prefix_push("shared");
> +	sie(&vm);
> +	/* Guest indicates that it has shared the new lowcore */
> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x44,
> +	       "intercept values");
> +
> +	uv_export(vm.sblk->mso + lc_off);
> +	uv_export(vm.sblk->mso + lc_off + PAGE_SIZE);

why are you not testing both pages individually here, like you did
above?

> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_PREF, "Intercept 112");
> +	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off);
> +	uv_import(vm.uv.vm_handle, vm.sblk->mso + lc_off + PAGE_SIZE);
> +
> +	/* Try a re-entry */
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x9c &&
> +	       vm.save_area.guest.grs[0] == 42,
> +	       "re-entry successful");
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +	uv_destroy_guest(&vm);
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("pv-icpts");
> +	if (!test_facility(158)) {
> +		report_skip("UV Call facility unavailable");
> +		goto done;
> +	}
> +	if (!sclp_facilities.has_sief2) {
> +		report_skip("SIEF2 facility unavailable");
> +		goto done;
> +	}
> +
> +	snippet_setup_guest(&vm, true);
> +	test_icpt_112();
> +	test_validity_asce();
> +	test_validity_seid();
> +	test_validity_handle_not_in_config();
> +	test_validity_already_running();
> +	test_validity_timing();
> +	sie_guest_destroy(&vm);
> +
> +done:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/snippets/asm/snippet-loop.S b/s390x/snippets/asm/snippet-loop.S
> new file mode 100644
> index 00000000..ee7cd863
> --- /dev/null
> +++ b/s390x/snippets/asm/snippet-loop.S
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Infinite loop snippet with no exit
> + *
> + * Copyright (c) 2023 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
> +.section .text
> +retry:
> +j 	retry
> diff --git a/s390x/snippets/asm/snippet-pv-icpt-112.S b/s390x/snippets/asm/snippet-pv-icpt-112.S
> new file mode 100644
> index 00000000..aef82dbb
> --- /dev/null
> +++ b/s390x/snippets/asm/snippet-pv-icpt-112.S
> @@ -0,0 +1,77 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Intercept 112 PV snippet
> + *
> + * We setup and share a prefix at 0x0 and 0x8000 which the hypervisor
> + * test will try to export and then execute a SIE entry which
> + * should result in a 112 SIE intercept.
> + *
> + * Copyright (c) 2023 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
> +#include <asm/asm-offsets.h>
> +
> +.section .text
> +xgr	%r0, %r0
> +xgr	%r1, %r1
> +
> +# Let's tell the hypervisor we're ready to start
> +diag	0,0,0x44
> +
> +/*
> + * Hypervisor will export the lowcore and try a SIE entry which should
> + * result in a 112. It will then import the lowcore again and we
> + * should continue with the code below.
> + */
> +
> +# Share the lowcore
> +larl	%r1, share
> +.insn rrf,0xB9A40000,0,1,0,0
> +xgr	%r1, %r1
> +
> +# Let's tell the hypervisor we're ready to start shared testing
> +diag	0,0,0x44
> +/* Host: icpt:  PV instruction diag 0x44 */
> +/* Host: icpt:  112 */
> +
> +# Copy the invalid PGM new PSW to the new lowcore
> +larl	%r1, prfx
> +l	%r2, 0(%r1)
> +mvc     GEN_LC_PGM_NEW_PSW(16, %r2), GEN_LC_PGM_NEW_PSW(%r0)
> +
> +# Change the prefix to 0x8000 and re-try
> +xgr	%r1, %r1
> +xgr	%r2, %r2
> +larl	%r2, prfx
> +spx	0(%r2)
> +/* Host: icpt:  PV instruction notification SPX*/
> +/* Host: icpt:  112 */
> +
> +# Share the new lowcore
> +larl	%r3, share_addr
> +stg	%r2, 0(%r3)
> +larl	%r2, share
> +.insn rrf,0xB9A40000,0,2,0,0
> +
> +# Let's tell the hypervisor we're ready to start shared testing
> +diag	0,0,0x44
> +/* Host: icpt:  PV instruction diag 0x44 */
> +/* Host: icpt:  112 */
> +
> +# Test re-entry
> +lghi	%r1, 42
> +diag	1,0,0x9c
> +/* Host: icpt:  PV instruction diag 0x9c */
> +
> +.align 8
> +share:
> +	.quad 0x0030100000000000
> +	.quad 0x0, 0x0, 0x0
> +share_addr:
> +	.quad 0x0
> +	.quad 0x0
> +.align 4
> +prfx:
> +	.long 0x00008000
> diff --git a/s390x/snippets/asm/snippet-pv-icpt-loop.S b/s390x/snippets/asm/snippet-pv-icpt-loop.S
> new file mode 100644
> index 00000000..2aa59c01
> --- /dev/null
> +++ b/s390x/snippets/asm/snippet-pv-icpt-loop.S
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Infinite loop snippet which can be used to test manipulated SIE
> + * control block intercepts. E.g. when manipulating the PV handles.
> + *
> + * Copyright (c) 2023 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
> +.section .text
> +xgr	%r0, %r0
> +retry:
> +diag	0,0,0x44
> +j 	retry
> diff --git a/s390x/snippets/asm/snippet-pv-icpt-vir-timing.S b/s390x/snippets/asm/snippet-pv-icpt-vir-timing.S
> new file mode 100644
> index 00000000..a0f9fe21
> --- /dev/null
> +++ b/s390x/snippets/asm/snippet-pv-icpt-vir-timing.S
> @@ -0,0 +1,22 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Sets a cpu timer which the host can manipulate to check if it will
> + *receive a validity
> + *
> + * Copyright (c) 2023 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
> +.section .text
> +larl	%r1, time_val
> +spt	0(%r1)
> +diag    0,0,0x44
> +xgr	%r1, %r1
> +lghi	%r1, 42
> +diag	1,0,0x9c
> +
> +
> +.align 8
> +time_val:
> +	.quad 0x280de80000

