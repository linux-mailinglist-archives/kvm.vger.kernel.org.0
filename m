Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41CC45A1BE
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 12:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbhKWLpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 06:45:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35340 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236399AbhKWLpN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 06:45:13 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANBUTG3010287;
        Tue, 23 Nov 2021 11:42:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=fVp9iFq0ni2/iL7oMuZXRGD7i5RSpVKkHJGzb+51o/E=;
 b=ZBgrYkywFXOZ6HIBEMBu3B9eCv1NyfNOXg8l/891b+AcNdumg2ztSt0ba9itSn5T3i+r
 tl2FP88EPfglOtLoNErdYFPJwmB2mpUi7u3vc6BC589YSP5X60wlwz6VehQ8vie0T0f3
 dwredpPTcig9rqLRTUN7sosxkuUZi3ukOf7PI/YCXL3BY9iozm/SjsLEh2/cU8Ajb06r
 PL9/QZyWOoAFNUxlzQNopqMzvvJvw5HwyL2r7X49ORb1a5OKeFhCptBg86a5ZrH97Ws3
 KZ+oB6qdTYTh7mSrMY3dPAFWtfXgnNygOfNx3Hdazq3E/7KfhnpSXAXvS3dmGCrCVz9O Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cgyfvg774-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:42:04 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANBVwPj014009;
        Tue, 23 Nov 2021 11:42:04 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cgyfvg76j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:42:04 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANBd9b8014024;
        Tue, 23 Nov 2021 11:42:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3cernaq9ay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 11:42:02 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANBfw4S18546964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 11:41:58 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B898711C064;
        Tue, 23 Nov 2021 11:41:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48DEA11C04A;
        Tue, 23 Nov 2021 11:41:58 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.158])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 11:41:58 +0000 (GMT)
Date:   Tue, 23 Nov 2021 12:41:33 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 8/8] s390x: sie: Add PV diag test
Message-ID: <20211123124133.3a045ef0@p-imbrenda>
In-Reply-To: <20211123103956.2170-9-frankja@linux.ibm.com>
References: <20211123103956.2170-1-frankja@linux.ibm.com>
        <20211123103956.2170-9-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: F0DSJZlRtuxOLdgVOUdgDE-hNEQ9yYf2
X-Proofpoint-ORIG-GUID: XrvNsFuKL_POUF4l5uU9OuYA-KQ33aVA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_04,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 clxscore=1015 mlxscore=0 impostorscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Nov 2021 10:39:56 +0000
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

> ---
>  s390x/Makefile                             |   7 +
>  s390x/pv-diags.c                           | 240 +++++++++++++++++++++
>  s390x/snippets/asm/snippet-pv-diag-288.S   |  25 +++
>  s390x/snippets/asm/snippet-pv-diag-500.S   |  39 ++++
>  s390x/snippets/asm/snippet-pv-diag-yield.S |   7 +
>  5 files changed, 318 insertions(+)
>  create mode 100644 s390x/pv-diags.c
>  create mode 100644 s390x/snippets/asm/snippet-pv-diag-288.S
>  create mode 100644 s390x/snippets/asm/snippet-pv-diag-500.S
>  create mode 100644 s390x/snippets/asm/snippet-pv-diag-yield.S
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 55e6d962..4f2374a5 100644
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
> @@ -98,6 +100,11 @@ snippet_lib = $(snippet_asmlib) lib/auxinfo.o
>  $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
>  $(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
>  
> +$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-yield.gbin
> +$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-288.gbin
> +$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-500.gbin
> +
> +
>  ifneq ($(GEN_SE_HEADER),)
>  snippets += $(pv-snippets)
>  tests += $(pv-tests)
> diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
> new file mode 100644
> index 00000000..82288943
> --- /dev/null
> +++ b/s390x/pv-diags.c
> @@ -0,0 +1,240 @@
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
> +static u8 *guest;
> +static u8 *guest_instr;
> +static struct vm vm;
> +
> +uint64_t tweak[2] = {0x42, 0x00};
> +
> +static void setup_vmem(void)
> +{
> +	uint64_t asce;
> +
> +	/* We need to have a valid primary ASCE to run guests. */
> +	setup_vm();
> +
> +	/* Set P bit in ASCE as it is required for SE guests */
> +	asce = stctg(1) | ASCE_P;
> +	lctlg(1, asce);
> +
> +	/* Copy ASCE into home space CR */
> +	lctlg(13, asce);
> +}
> +
> +
> +static void init_guest(const char *gbin, const char *hdr, uint64_t gbin_len,
> +		       uint64_t hdr_len)
> +{
> +	uv_create_guest(&vm);
> +	uv_set_se_hdr(vm.uv.vm_handle, (void *)hdr, hdr_len);
> +
> +	/* Copy test image to guest memory */
> +	memcpy(guest_instr, gbin, gbin_len);
> +
> +	uv_unpack(&vm, SNIPPET_ENTRY_ADDR, gbin_len, tweak[0]);
> +	uv_verify_load(&vm);
> +
> +	/* Manually import lowcore */
> +	uv_import(vm.uv.vm_handle, (uint64_t)guest);
> +	uv_import(vm.uv.vm_handle, (uint64_t)(guest + PAGE_SIZE));
> +}
> +
> +static void setup_guest(void)
> +{
> +	setup_vmem();
> +
> +	/* Allocate 1MB as guest memory */
> +	guest = alloc_pages(8);
> +	memset(guest, 0, HPAGE_SIZE);
> +	/* The first two pages are the lowcore */
> +	guest_instr = guest + SNIPPET_ENTRY_ADDR;
> +
> +	sie_guest_create(&vm, (uint64_t)guest, HPAGE_SIZE);
> +	/* FMT4 needs a ESCA */
> +	sie_guest_sca_create(&vm);
> +
> +	uv_init();
> +}
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
> +	init_guest(SNIPPET_NAME_START(asm, snippet_pv_diag_500),
> +		   SNIPPET_HDR_START(asm, snippet_pv_diag_500),
> +		   size_gbin, size_hdr);
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
> +	init_guest(SNIPPET_NAME_START(asm, snippet_pv_diag_288),
> +		   SNIPPET_HDR_START(asm, snippet_pv_diag_288),
> +		   size_gbin, size_hdr);
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
> +	init_guest(SNIPPET_NAME_START(asm, snippet_pv_diag_yield),
> +		   SNIPPET_HDR_START(asm, snippet_pv_diag_yield),
> +		   size_gbin, size_hdr);
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
> +	setup_guest();
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

