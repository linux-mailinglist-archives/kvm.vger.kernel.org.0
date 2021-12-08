Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82E846D3E2
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 13:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbhLHNBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 08:01:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1342 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233914AbhLHNBY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 08:01:24 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8CfwaI006065;
        Wed, 8 Dec 2021 12:57:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=nY8qSaS/vtAaM6w+733eVRDOOdZKrk0Zec0Fzb1Qqrw=;
 b=gsjxc/5j/bEV83yhcim/OvKXNBHbdP+K6z6amk6/aBWTcV03KNpzltx49vxXFrmem9ET
 a7alz9HpSKJ+Bv1U+YHWqhnlGWpjxUtI1ylaGNxkj+q6BURVONZNtoArhCM6PPVx0WCr
 IcMmtwopD9XODmp4ZVX6vtnzlnLAC2KmpH3ftPLOqX9MrkT/U1k/7ChLnpkP80n9tCXB
 4LlIH/1WosdUjdWwFPXa2ENuEFdvyAdQhveTjU6Xpgf8ZrNM7cOswxv57ZNo/+2jC16w
 7OySJ4iCNslbytRN9xRRuUfezmT/mSy/rg6SzynSMKstALKW+NTKHZ3nR/ErhaNTpsLs sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctvkp0r0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:57:52 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8CghwR008634;
        Wed, 8 Dec 2021 12:57:52 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctvkp0r05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:57:51 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8CrJbU029163;
        Wed, 8 Dec 2021 12:57:49 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3cqyyayqyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 12:57:49 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8Cvk5E19071374
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 12:57:46 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 561E611C04C;
        Wed,  8 Dec 2021 12:57:46 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8A4211C050;
        Wed,  8 Dec 2021 12:57:45 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.179])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 12:57:45 +0000 (GMT)
Date:   Wed, 8 Dec 2021 13:55:20 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 10/10] s390x: sie: Add PV diag test
Message-ID: <20211208135520.2d588f37@p-imbrenda>
In-Reply-To: <20211207160005.1586-11-frankja@linux.ibm.com>
References: <20211207160005.1586-1-frankja@linux.ibm.com>
        <20211207160005.1586-11-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -j4COXGfrYJY9FbCx2tS1PIDUaSNRBYV
X-Proofpoint-ORIG-GUID: t4RoW7F4zoZ6uWwrj_bh749UROEVZZeW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Dec 2021 16:00:05 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's start testing the format 4 (PV) SIE via the diagnose
> instructions since most of them are pretty simple to handle.
> 
> The tests check for the intercept values like ipa/ipb and icptcode as
> well as the values in the registers and handling of the exception
> injection.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

this is ok for now; in the future it would be nice to also test
injection of program interrupts that are not allowed.

> ---
>  s390x/Makefile                             |   6 +
>  s390x/pv-diags.c                           | 187 +++++++++++++++++++++
>  s390x/snippets/asm/snippet-pv-diag-288.S   |  25 +++
>  s390x/snippets/asm/snippet-pv-diag-500.S   |  39 +++++
>  s390x/snippets/asm/snippet-pv-diag-yield.S |   7 +
>  5 files changed, 264 insertions(+)
>  create mode 100644 s390x/pv-diags.c
>  create mode 100644 s390x/snippets/asm/snippet-pv-diag-288.S
>  create mode 100644 s390x/snippets/asm/snippet-pv-diag-500.S
>  create mode 100644 s390x/snippets/asm/snippet-pv-diag-yield.S
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 55e6d962..0cb90466 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -26,6 +26,8 @@ tests += $(TEST_DIR)/edat.elf
>  tests += $(TEST_DIR)/mvpg-sie.elf
>  tests += $(TEST_DIR)/spec_ex-sie.elf
>  
> +pv-tests += $(TEST_DIR)/pv-diags.elf
> +
>  ifneq ($(HOST_KEY_DOCUMENT),)
>  ifneq ($(GEN_SE_HEADER),)
>  tests += $(pv-tests)
> @@ -98,6 +100,10 @@ snippet_lib = $(snippet_asmlib) lib/auxinfo.o
>  $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
>  $(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
>  
> +$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-yield.gbin
> +$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-288.gbin
> +$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-500.gbin
> +
>  ifneq ($(GEN_SE_HEADER),)
>  snippets += $(pv-snippets)
>  tests += $(pv-tests)
> diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
> new file mode 100644
> index 00000000..110547ad
> --- /dev/null
> +++ b/s390x/pv-diags.c
> @@ -0,0 +1,187 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * PV virtualization interception tests for diagnose instructions.
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
> +#include <libcflat.h>
> +#include <asm/asm-offsets.h>
> +#include <asm-generic/barrier.h>
> +#include <asm/interrupt.h>
> +#include <asm/pgtable.h>
> +#include <mmu.h>
> +#include <asm/page.h>
> +#include <asm/facility.h>
> +#include <asm/mem.h>
> +#include <asm/sigp.h>
> +#include <smp.h>
> +#include <alloc_page.h>
> +#include <vm.h>
> +#include <vmalloc.h>
> +#include <sclp.h>
> +#include <snippet.h>
> +#include <sie.h>
> +#include <uv.h>
> +#include <asm/uv.h>
> +
> +static struct vm vm;
> +
> +static void test_diag_500(void)
> +{
> +	extern const char SNIPPET_NAME_START(asm, snippet_pv_diag_500)[];
> +	extern const char SNIPPET_NAME_END(asm, snippet_pv_diag_500)[];
> +	extern const char SNIPPET_HDR_START(asm, snippet_pv_diag_500)[];
> +	extern const char SNIPPET_HDR_END(asm, snippet_pv_diag_500)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_diag_500);
> +	int size_gbin = SNIPPET_LEN(asm, snippet_pv_diag_500);
> +
> +	report_prefix_push("diag 0x500");
> +
> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_500),
> +			SNIPPET_HDR_START(asm, snippet_pv_diag_500),
> +			size_gbin, size_hdr, SNIPPET_OFF_ASM);
> +
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x500,
> +	       "intercept values");
> +	report(vm.save_area.guest.grs[1] == 1 &&
> +	       vm.save_area.guest.grs[2] == 2 &&
> +	       vm.save_area.guest.grs[3] == 3 &&
> +	       vm.save_area.guest.grs[4] == 4,
> +	       "register values");
> +	/*
> +	 * Check if we can inject a PGM operand which we are always
> +	 * allowed to do after a diag500 exit.
> +	 */
> +	vm.sblk->iictl = IICTL_CODE_OPERAND;
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x9c
> +	       && vm.save_area.guest.grs[0] == PGM_INT_CODE_OPERAND,
> +	       "operand exception");
> +
> +	/*
> +	 * Check if we can inject a PGM specification which we are always
> +	 * allowed to do after a diag500 exit.
> +	 */
> +	sie(&vm);
> +	vm.sblk->iictl = IICTL_CODE_SPECIFICATION;
> +	/* Inject PGM, next exit should be 9c */
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x9c
> +	       && vm.save_area.guest.grs[0] == PGM_INT_CODE_SPECIFICATION,
> +	       "specification exception");
> +
> +	/* No need for cleanup, just tear down the VM */
> +	uv_destroy_guest(&vm);
> +
> +	report_prefix_pop();
> +}
> +
> +
> +static void test_diag_288(void)
> +{
> +	extern const char SNIPPET_NAME_START(asm, snippet_pv_diag_288)[];
> +	extern const char SNIPPET_NAME_END(asm, snippet_pv_diag_288)[];
> +	extern const char SNIPPET_HDR_START(asm, snippet_pv_diag_288)[];
> +	extern const char SNIPPET_HDR_END(asm, snippet_pv_diag_288)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_diag_288);
> +	int size_gbin = SNIPPET_LEN(asm, snippet_pv_diag_288);
> +
> +	report_prefix_push("diag 0x288");
> +
> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_288),
> +			SNIPPET_HDR_START(asm, snippet_pv_diag_288),
> +			size_gbin, size_hdr, SNIPPET_OFF_ASM);
> +
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x288,
> +	       "intercept values");
> +	report(vm.save_area.guest.grs[0] == 1 &&
> +	       vm.save_area.guest.grs[1] == 2 &&
> +	       vm.save_area.guest.grs[2] == 3,
> +	       "register values");
> +
> +	/*
> +	 * Check if we can inject a PGM spec which we are always
> +	 * allowed to do after a diag288 exit.
> +	 */
> +	vm.sblk->iictl = IICTL_CODE_SPECIFICATION;
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x9c
> +	       && vm.save_area.guest.grs[0] == PGM_INT_CODE_SPECIFICATION,
> +	       "specification exception");
> +
> +	/* No need for cleanup, just tear down the VM */
> +	uv_destroy_guest(&vm);
> +
> +	report_prefix_pop();
> +}
> +
> +static void test_diag_yield(void)
> +{
> +	extern const char SNIPPET_NAME_START(asm, snippet_pv_diag_yield)[];
> +	extern const char SNIPPET_NAME_END(asm, snippet_pv_diag_yield)[];
> +	extern const char SNIPPET_HDR_START(asm, snippet_pv_diag_yield)[];
> +	extern const char SNIPPET_HDR_END(asm, snippet_pv_diag_yield)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_diag_yield);
> +	int size_gbin = SNIPPET_LEN(asm, snippet_pv_diag_yield);
> +
> +	report_prefix_push("diag yield");
> +
> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_yield),
> +			SNIPPET_HDR_START(asm, snippet_pv_diag_yield),
> +			size_gbin, size_hdr, SNIPPET_OFF_ASM);
> +
> +	/* 0x44 */
> +	report_prefix_push("0x44");
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x44,
> +	       "intercept values");
> +	report_prefix_pop();
> +
> +	/* 0x9c */
> +	report_prefix_push("0x9c");
> +	sie(&vm);
> +	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> +	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x9c,
> +	       "intercept values");
> +	report(vm.save_area.guest.grs[0] == 42, "r1 correct");
> +	report_prefix_pop();
> +
> +	uv_destroy_guest(&vm);
> +	report_prefix_pop();
> +}
> +
> +
> +int main(void)
> +{
> +	report_prefix_push("pv-diags");
> +	if (!test_facility(158)) {
> +		report_skip("UV Call facility unavailable");
> +		goto done;
> +	}
> +	if (!sclp_facilities.has_sief2) {
> +		report_skip("SIEF2 facility unavailable");
> +		goto done;
> +	}
> +
> +	uv_setup_asces();
> +	snippet_setup_guest(&vm, true);
> +	test_diag_yield();
> +	test_diag_288();
> +	test_diag_500();
> +	sie_guest_destroy(&vm);
> +
> +done:
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/snippets/asm/snippet-pv-diag-288.S b/s390x/snippets/asm/snippet-pv-diag-288.S
> new file mode 100644
> index 00000000..e3e63121
> --- /dev/null
> +++ b/s390x/snippets/asm/snippet-pv-diag-288.S
> @@ -0,0 +1,25 @@
> +#include <asm/asm-offsets.h>
> +.section .text
> +
> +/* Clean and pre-load registers that are used for diag 288 */
> +xgr	%r0, %r0
> +xgr	%r1, %r1
> +xgr	%r3, %r3
> +lghi	%r0, 1
> +lghi	%r1, 2
> +lghi	%r2, 3
> +
> +/* Let's jump to the pgm exit label on a PGM */
> +larl	%r4, exit_pgm
> +stg     %r4, GEN_LC_PGM_NEW_PSW + 8
> +
> +/* Execute the diag288 */
> +diag	%r0, %r2, 0x288
> +
> +/* Force exit if we don't get a PGM */
> +diag	0, 0, 0x44
> +
> +/* Communicate the PGM code via diag9c(easiest) */
> +exit_pgm:
> +lh	%r1, GEN_LC_PGM_INT_CODE
> +diag	%r1, 0, 0x9c
> diff --git a/s390x/snippets/asm/snippet-pv-diag-500.S b/s390x/snippets/asm/snippet-pv-diag-500.S
> new file mode 100644
> index 00000000..50c06779
> --- /dev/null
> +++ b/s390x/snippets/asm/snippet-pv-diag-500.S
> @@ -0,0 +1,39 @@
> +#include <asm/asm-offsets.h>
> +.section .text
> +
> +/* Clean and pre-load registers that are used for diag 500 */
> +xgr	%r1, %r1
> +xgr	%r2, %r2
> +xgr	%r3, %r3
> +xgr	%r4, %r4
> +lghi	%r1, 1
> +lghi	%r2, 2
> +lghi	%r3, 3
> +lghi	%r4, 4
> +
> +/* Let's jump to the next label on a PGM */
> +xgr	%r5, %r5
> +stg	%r5, GEN_LC_PGM_NEW_PSW
> +larl	%r5, next
> +stg	%r5, GEN_LC_PGM_NEW_PSW + 8
> +
> +/* Execute the diag500 */
> +diag	0, 0, 0x500
> +
> +/* Should never be executed because of the PGM */
> +diag	0, 0, 0x44
> +
> +/* Execute again to test spec PGM injection*/
> +next:
> +lh	%r1, GEN_LC_PGM_INT_CODE
> +diag	%r1, 0, 0x9c
> +larl	%r5, done
> +stg	%r5, GEN_LC_PGM_NEW_PSW + 8
> +diag	0, 0, 0x500
> +
> +/* Should never be executed because of the PGM */
> +diag	0, 0, 0x44
> +
> +done:
> +lh	%r1, GEN_LC_PGM_INT_CODE
> +diag	%r1, 0, 0x9c
> diff --git a/s390x/snippets/asm/snippet-pv-diag-yield.S b/s390x/snippets/asm/snippet-pv-diag-yield.S
> new file mode 100644
> index 00000000..5795cf0f
> --- /dev/null
> +++ b/s390x/snippets/asm/snippet-pv-diag-yield.S
> @@ -0,0 +1,7 @@
> +.section .text
> +
> +xgr	%r0, %r0
> +xgr	%r1, %r1
> +diag	0,0,0x44
> +lghi	%r1, 42
> +diag	1,0,0x9c

