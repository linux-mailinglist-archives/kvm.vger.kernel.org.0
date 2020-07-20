Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD82225CEC
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 12:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgGTKvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 06:51:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57640 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728348AbgGTKvT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jul 2020 06:51:19 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KAWq0b064916;
        Mon, 20 Jul 2020 06:51:18 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d6d7pggr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 06:51:18 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06KAZ1LD071130;
        Mon, 20 Jul 2020 06:51:18 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d6d7pgg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 06:51:17 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06KAolZv013794;
        Mon, 20 Jul 2020 10:51:15 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 32brq7tkth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 10:51:15 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06KAmYjr51577224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 10:48:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10E2FAE051;
        Mon, 20 Jul 2020 10:49:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84B79AE04D;
        Mon, 20 Jul 2020 10:49:57 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.8.245])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jul 2020 10:49:57 +0000 (GMT)
Date:   Mon, 20 Jul 2020 12:49:38 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: Ultavisor guest API test
Message-ID: <20200720124938.556220fe@ibm-vm>
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
 definitions=2020-07-20_06:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=999 suspectscore=2
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200076
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

I don't like using a hardwired address here (and above). Things can get
messy if the address ends up outside memory or overlapping code.

I think the best approach would be to declare a page aligned buffer and
use that (or even allocate a page) 

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

once the above comment is addressed:
Claudio Imbrenda <imbrenda@linux.ibm.com>
