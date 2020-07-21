Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC21228051
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 14:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgGUMzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 08:55:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35390 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726687AbgGUMzO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 08:55:14 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06LC48L6128845;
        Tue, 21 Jul 2020 08:55:13 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d5pfrawu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 08:55:12 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06LC4NeI130320;
        Tue, 21 Jul 2020 08:55:12 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d5pfraw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 08:55:12 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06LCoEsN011756;
        Tue, 21 Jul 2020 12:55:10 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 32brq81yt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 12:55:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06LCt7HC26673660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 12:55:07 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25C1911C04A;
        Tue, 21 Jul 2020 12:55:07 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4D0711C04C;
        Tue, 21 Jul 2020 12:55:06 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.8.245])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jul 2020 12:55:06 +0000 (GMT)
Date:   Tue, 21 Jul 2020 14:55:04 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: Ultavisor guest API test
Message-ID: <20200721145504.6ae2cb40@ibm-vm>
In-Reply-To: <20200717145813.62573-4-frankja@linux.ibm.com>
References: <20200717145813.62573-1-frankja@linux.ibm.com>
        <20200717145813.62573-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_05:2020-07-21,2020-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=2 lowpriorityscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210087
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

btw, s/Ultavisor/Ultravisor/ in the patch title (the R is missing!)

On Fri, 17 Jul 2020 10:58:13 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Test the error conditions of guest 2 Ultravisor calls, namely:
>      * Query Ultravisor information
>      * Set shared access
>      * Remove shared access
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/uv.h  |  68 +++++++++++++++++++
>  s390x/Makefile      |   1 +
>  s390x/unittests.cfg |   3 +
>  s390x/uv-guest.c    | 156
> ++++++++++++++++++++++++++++++++++++++++++++ 4 files changed, 228
> insertions(+) create mode 100644 lib/s390x/asm/uv.h
>  create mode 100644 s390x/uv-guest.c
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> new file mode 100644
> index 0000000..14ab5cc
> --- /dev/null
> +++ b/lib/s390x/asm/uv.h
> @@ -0,0 +1,68 @@
> +/*
> + * s390x Ultravisor related definitions
> + *
> + * Copyright (c) 2020 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify
> it
> + * under the terms of the GNU General Public License version 2.
> + */
> +#ifndef UV_H
> +#define UV_H
> +
> +#define UVC_RC_EXECUTED		0x0001
> +#define UVC_RC_INV_CMD		0x0002
> +#define UVC_RC_INV_STATE	0x0003
> +#define UVC_RC_INV_LEN		0x0005
> +#define UVC_RC_NO_RESUME	0x0007
> +
> +#define UVC_CMD_QUI			0x0001
> +#define UVC_CMD_SET_SHARED_ACCESS	0x1000
> +#define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
> +
> +/* Bits in installed uv calls */
> +enum uv_cmds_inst {
> +	BIT_UVC_CMD_QUI = 0,
> +	BIT_UVC_CMD_SET_SHARED_ACCESS = 8,
> +	BIT_UVC_CMD_REMOVE_SHARED_ACCESS = 9,
> +};
> +
> +struct uv_cb_header {
> +	u16 len;
> +	u16 cmd;	/* Command Code */
> +	u16 rc;		/* Response Code */
> +	u16 rrc;	/* Return Reason Code */
> +} __attribute__((packed))  __attribute__((aligned(8)));
> +
> +struct uv_cb_qui {
> +	struct uv_cb_header header;
> +	u64 reserved08;
> +	u64 inst_calls_list[4];
> +	u64 reserved30[15];
> +} __attribute__((packed))  __attribute__((aligned(8)));
> +
> +struct uv_cb_share {
> +	struct uv_cb_header header;
> +	u64 reserved08[3];
> +	u64 paddr;
> +	u64 reserved28;
> +} __attribute__((packed))  __attribute__((aligned(8)));
> +
> +static inline int uv_call(unsigned long r1, unsigned long r2)
> +{
> +	int cc;
> +
> +	asm volatile(
> +		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
> +		"		brc	3,0b\n"
> +		"		ipm	%[cc]\n"
> +		"		srl	%[cc],28\n"
> +		: [cc] "=d" (cc)
> +		: [r1] "a" (r1), [r2] "a" (r2)
> +		: "memory", "cc");
> +	return cc;
> +}
> +
> +#endif
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 0f54bf4..c2213ad 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -18,6 +18,7 @@ tests += $(TEST_DIR)/skrf.elf
>  tests += $(TEST_DIR)/smp.elf
>  tests += $(TEST_DIR)/sclp.elf
>  tests += $(TEST_DIR)/css.elf
> +tests += $(TEST_DIR)/uv-guest.elf
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  
>  all: directories test_cases test_cases_binary
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index b35269b..38c3257 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -92,3 +92,6 @@ extra_params = -device virtio-net-ccw
>  [skrf]
>  file = skrf.elf
>  smp = 2
> +
> +[uv-guest]
> +file = uv-guest.elf
> \ No newline at end of file
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> new file mode 100644
> index 0000000..0cb5fae
> --- /dev/null
> +++ b/s390x/uv-guest.c
> @@ -0,0 +1,156 @@
> +/*
> + * Guest Ultravisor Call tests
> + *
> + * Copyright (c) 2020 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify
> it
> + * under the terms of the GNU General Public License version 2.
> + */
> +
> +#include <libcflat.h>
> +#include <alloc_page.h>
> +#include <asm/page.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <asm/facility.h>
> +#include <asm/uv.h>
> +
> +static inline int share(unsigned long addr, u16 cmd)
> +{
> +	struct uv_cb_share uvcb = {
> +		.header.cmd = cmd,
> +		.header.len = sizeof(uvcb),
> +		.paddr = addr
> +	};
> +
> +	uv_call(0, (u64)&uvcb);
> +	return uvcb.header.rc;
> +}
> +
> +static inline int uv_set_shared(unsigned long addr)
> +{
> +	return share(addr, UVC_CMD_SET_SHARED_ACCESS);
> +}
> +
> +static inline int uv_remove_shared(unsigned long addr)
> +{
> +	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
> +}
> +
> +static void test_priv(void)
> +{
> +	struct uv_cb_header uvcb = {};
> +
> +	report_prefix_push("privileged");
> +
> +	report_prefix_push("query");
> +	expect_pgm_int();
> +	uvcb.cmd = UVC_CMD_QUI;
> +	uvcb.len = sizeof(struct uv_cb_qui);
> +	enter_pstate();
> +	uv_call(0, (u64)&uvcb);
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("share");
> +	expect_pgm_int();
> +	enter_pstate();
> +	uv_set_shared(0x42000);
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();
> +
> +	report_prefix_push("unshare");
> +	expect_pgm_int();
> +	enter_pstate();
> +	uv_remove_shared(0x42000);
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +}
> +
> +static void test_query(void)
> +{
> +	struct uv_cb_qui uvcb = {
> +		.header.cmd = UVC_CMD_QUI,
> +		.header.len = sizeof(uvcb) - 8,
> +	};
> +
> +	report_prefix_push("query");
> +	uv_call(0, (u64)&uvcb);
> +	report(uvcb.header.rc == UVC_RC_INV_LEN, "length");
> +
> +	uvcb.header.len = sizeof(uvcb);
> +	uv_call(0, (u64)&uvcb);
> +	report(uvcb.header.rc == UVC_RC_EXECUTED, "successful
> query"); +
> +	/*
> +	 * These bits have been introduced with the very first
> +	 * Ultravisor version and are expected to always be available
> +	 * because they are basic building blocks.
> +	 */
> +	report(uvcb.inst_calls_list[0] & (1UL << (63 -
> BIT_UVC_CMD_QUI)),
> +	       "query indicated");
> +	report(uvcb.inst_calls_list[0] & (1UL << (63 -
> BIT_UVC_CMD_SET_SHARED_ACCESS)),
> +	       "share indicated");
> +	report(uvcb.inst_calls_list[0] & (1UL << (63 -
> BIT_UVC_CMD_REMOVE_SHARED_ACCESS)),
> +	       "unshare indicated");
> +	report_prefix_pop();
> +}
> +
> +static void test_sharing(void)
> +{
> +	unsigned long mem = (unsigned long)alloc_page();
> +	struct uv_cb_share uvcb = {
> +		.header.cmd = UVC_CMD_SET_SHARED_ACCESS,
> +		.header.len = sizeof(uvcb) - 8,
> +	};
> +
> +	report_prefix_push("share");
> +	uv_call(0, (u64)&uvcb);
> +	report(uvcb.header.rc == UVC_RC_INV_LEN, "length");
> +	report(uv_set_shared(mem) == UVC_RC_EXECUTED, "share");
> +	report_prefix_pop();
> +
> +	report_prefix_push("unshare");
> +	uvcb.header.cmd = UVC_CMD_REMOVE_SHARED_ACCESS;
> +	uv_call(0, (u64)&uvcb);
> +	report(uvcb.header.rc == UVC_RC_INV_LEN, "length");
> +	report(uv_remove_shared(mem) == UVC_RC_EXECUTED, "unshare");
> +	free_page((void *)mem);
> +	report_prefix_pop();
> +
> +	report_prefix_pop();
> +}
> +
> +static void test_invalid(void)
> +{
> +	struct uv_cb_header uvcb = {
> +		.len = 16,
> +		.cmd = 0x4242,
> +	};
> +
> +	uv_call(0, (u64)&uvcb);
> +	report(uvcb.rc == UVC_RC_INV_CMD, "invalid command");
> +}
> +
> +int main(void)
> +{
> +	bool has_uvc = test_facility(158);
> +
> +	report_prefix_push("uvc");
> +	if (!has_uvc) {
> +		report_skip("Ultravisor call facility is not
> available");
> +		goto done;
> +	}
> +
> +	test_priv();
> +	test_invalid();
> +	test_query();
> +	test_sharing();
> +done:
> +	return report_summary();
> +}

