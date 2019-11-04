Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE274EDBD5
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 10:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfKDJp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 04:45:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44276 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726100AbfKDJp0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 04:45:26 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA49iBj4070884
        for <kvm@vger.kernel.org>; Mon, 4 Nov 2019 04:45:24 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w2fm9cgjw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 04:45:23 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 4 Nov 2019 09:45:21 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 4 Nov 2019 09:45:18 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA49jG0i16580836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Nov 2019 09:45:16 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8055952051;
        Mon,  4 Nov 2019 09:45:16 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.70.20])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6EDFA5205F;
        Mon,  4 Nov 2019 09:45:08 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 5/5] s390x: SCLP unit test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com
References: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
 <1572023194-14370-6-git-send-email-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 4 Nov 2019 10:45:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1572023194-14370-6-git-send-email-imbrenda@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mHotetrfn77cTZyiT8EGp6QGqpNmeCqkn"
X-TM-AS-GCONF: 00
x-cbid: 19110409-0020-0000-0000-000003825045
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110409-0021-0000-0000-000021D872FB
Message-Id: <191dbc7f-74b2-6f78-a721-aaac49895948@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-04_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911040097
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mHotetrfn77cTZyiT8EGp6QGqpNmeCqkn
Content-Type: multipart/mixed; boundary="JQngfHj2tyWmdDlUZ7p1hyn9KiZBrlUIK"

--JQngfHj2tyWmdDlUZ7p1hyn9KiZBrlUIK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/25/19 7:06 PM, Claudio Imbrenda wrote:
> SCLP unit test. Testing the following:
>=20
> * Correctly ignoring instruction bits that should be ignored
> * Privileged instruction check
> * Check for addressing exceptions
> * Specification exceptions:
>   - SCCB size less than 8
>   - SCCB unaligned
>   - SCCB overlaps prefix or lowcore
>   - SCCB address higher than 2GB
> * Return codes for
>   - Invalid command
>   - SCCB too short (but at least 8)
>   - SCCB page boundary violation
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/sclp.c        | 413 ++++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  s390x/unittests.cfg |   3 +
>  3 files changed, 417 insertions(+)
>  create mode 100644 s390x/sclp.c
>=20
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 3744372..ddb4b48 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -16,6 +16,7 @@ tests +=3D $(TEST_DIR)/diag288.elf
>  tests +=3D $(TEST_DIR)/stsi.elf
>  tests +=3D $(TEST_DIR)/skrf.elf
>  tests +=3D $(TEST_DIR)/smp.elf
> +tests +=3D $(TEST_DIR)/sclp.elf
>  tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
> =20
>  all: directories test_cases test_cases_binary
> diff --git a/s390x/sclp.c b/s390x/sclp.c
> new file mode 100644
> index 0000000..29ac265
> --- /dev/null
> +++ b/s390x/sclp.c
> @@ -0,0 +1,413 @@
> +/*
> + * Service Call tests
> + *
> + * Copyright (c) 2019 IBM Corp
> + *
> + * Authors:
> + *  Claudio Imbrenda <imbrenda@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify i=
t
> + * under the terms of the GNU General Public License version 2.
> + */
> +
> +#include <libcflat.h>
> +#include <asm/page.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/interrupt.h>
> +#include <sclp.h>
> +
> +#define PGM_BIT_SPEC	(1ULL << PGM_INT_CODE_SPECIFICATION)
> +#define PGM_BIT_ADDR	(1ULL << PGM_INT_CODE_ADDRESSING)
> +#define PGM_BIT_PRIV	(1ULL << PGM_INT_CODE_PRIVILEGED_OPERATION)
> +#define MKPTR(x) ((void *)(uint64_t)(x))
> +
> +static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE=
 * 2)));
> +static uint8_t prefix_buf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_S=
IZE * 2)));
> +static uint8_t sccb_template[PAGE_SIZE];
> +static uint32_t valid_code;
> +static struct lowcore *lc;
> +
> +/**
> + * Enable SCLP interrupt.
> + */
> +static void sclp_setup_int_test(void)
> +{
> +	uint64_t mask;
> +
> +	ctl_set_bit(0, 9);
> +	mask =3D extract_psw_mask();
> +	mask |=3D PSW_MASK_EXT;
> +	load_psw_mask(mask);
> +}

Or you could just export the definition in sclp.c...

> +
> +/**
> + * Perform one service call, handling exceptions and interrupts.
> + */
> +static int sclp_service_call_test(unsigned int command, void *sccb)
> +{
> +	int cc;
> +
> +	sclp_mark_busy();
> +	sclp_setup_int_test();
> +	lc->pgm_int_code =3D 0;
> +	cc =3D servc(command, __pa(sccb));
> +	if (lc->pgm_int_code) {
> +		sclp_handle_ext();
> +		return 0;
> +	}
> +	if (!cc)
> +		sclp_wait_busy();
> +	return cc;
> +}
> +
> +/**
> + * Perform one test at the given address, optionally using the SCCB te=
mplate,
> + * checking for the expected program interrupts and return codes.
> + */
> +static int test_one_sccb(uint32_t cmd, uint8_t *addr, uint16_t len,
> +			uint64_t exp_pgm, uint16_t exp_rc)
> +{
> +	SCCBHeader *h =3D (SCCBHeader *)addr;
> +	int res, pgm;
> +
> +	if (len)
> +		memcpy(addr, sccb_template, len);
> +	if (!exp_pgm)
> +		exp_pgm =3D 1;
> +	expect_pgm_int();
> +	res =3D sclp_service_call_test(cmd, h);
> +	if (res) {
> +		report_info("SCLP not ready (command %#x, address %p, cc %d)", cmd, =
addr, res);
> +		return 0;
> +	}
> +	pgm =3D lc->pgm_int_code;
> +	if (!((1ULL << pgm) & exp_pgm)) {
> +		report_info("First failure at addr %p, size %d, cmd %#x, pgm code %d=
", addr, len, cmd, pgm);
> +		return 0;
> +	}
> +	if (exp_rc && (exp_rc !=3D h->response_code)) {
> +		report_info("First failure at addr %p, size %d, cmd %#x, resp code %=
#x",
> +				addr, len, cmd, h->response_code);
> +		return 0;
> +	}
> +	return 1;
> +}
> +
> +/**
> + * Wrapper for test_one_sccb to set up an SCCB template
> + */
> +static int test_one_run(uint32_t cmd, uint8_t *addr, uint16_t sccb_len=
,
> +			uint16_t buf_len, uint64_t exp_pgm, uint16_t exp_rc)
> +{
> +	if (buf_len)
> +		memset(sccb_template, 0, sizeof(sccb_template));
> +	((SCCBHeader *)sccb_template)->length =3D sccb_len;
> +	if (buf_len && buf_len < 8)
> +		buf_len =3D 8;
> +	return test_one_sccb(cmd, addr, buf_len, exp_pgm, exp_rc);
> +}
> +
> +/**
> + * Test SCCB lengths < 8
> + */
> +static void test_sccb_too_short(void)
> +{
> +	int cx;
> +
> +	for (cx =3D 0; cx < 8; cx++)
> +		if (!test_one_run(valid_code, pagebuf, cx, 8, PGM_BIT_SPEC, 0))
> +			break;
> +
> +	report("SCCB too short", cx =3D=3D 8);
> +}
> +
> +/**
> + * Test SCCBs that are not 64bits aligned
> + */
> +static void test_sccb_unaligned(void)
> +{
> +	int cx;
> +
> +	for (cx =3D 1; cx < 8; cx++)
> +		if (!test_one_run(valid_code, cx + pagebuf, 8, 8, PGM_BIT_SPEC, 0))
> +			break;
> +	report("SCCB unaligned", cx =3D=3D 8);
> +}
> +
> +/**
> + * Test SCCBs whose address is in the lowcore or prefix area
> + */
> +static void test_sccb_prefix(void)
> +{
> +	uint32_t prefix, new_prefix;
> +	int cx;
> +
> +	// can't actually trash the lowcore, unsurprisingly things break if w=
e do
> +	for (cx =3D 0; cx < 8192; cx +=3D 8)
> +		if (!test_one_sccb(valid_code, MKPTR(cx), 0, PGM_BIT_SPEC, 0))
> +			break;
> +	report("SCCB low pages", cx =3D=3D 8192);
> +
> +	memcpy(prefix_buf, 0, 8192);
> +	new_prefix =3D (uint32_t)(intptr_t)prefix_buf;
> +	asm volatile("stpx %0" : "=3DQ" (prefix));
> +	asm volatile("spx %0" : : "Q" (new_prefix) : "memory");
> +
> +	for (cx =3D 0; cx < 8192; cx +=3D 8)
> +		if (!test_one_run(valid_code, MKPTR(new_prefix + cx), 8, 8, PGM_BIT_=
SPEC, 0))
> +			break;
> +	report("SCCB prefix pages", cx =3D=3D 8192);
> +
> +	memcpy(prefix_buf, 0, 8192);
> +	asm volatile("spx %0" : : "Q" (prefix) : "memory");
> +}
> +
> +/**
> + * Test SCCBs that are above 2GB. If outside of memory, an addressing
> + * exception is also allowed.
> + */
> +static void test_sccb_high(void)
> +{
> +	SCCBHeader *h =3D (SCCBHeader *)pagebuf;
> +	uintptr_t a[33 * 4 * 2 + 2];
> +	uint64_t maxram;
> +	int cx, i, pgm;
> +
> +	h->length =3D 8;
> +
> +	i =3D 0;
> +	for (cx =3D 0; cx < 33; cx++)
> +		a[i++] =3D 1UL << (cx + 31);
> +	for (cx =3D 0; cx < 33; cx++)
> +		a[i++] =3D 3UL << (cx + 31);
> +	for (cx =3D 0; cx < 33; cx++)
> +		a[i++] =3D 0xffffffff80000000UL << cx;
> +	a[i++] =3D 0x80000000;
> +	for (cx =3D 1; cx < 33; cx++, i++)
> +		a[i] =3D a[i - 1] | (1UL << (cx + 31));
> +	for (cx =3D 0; cx < i; cx++)
> +		a[i + cx] =3D a[cx] + (intptr_t)pagebuf;
> +	i +=3D cx;
> +	a[i++] =3D 0xdeadbeef00000000;
> +	a[i++] =3D 0xdeaddeadbeef0000;
> +
> +	maxram =3D get_ram_size();
> +	for (cx =3D 0; cx < i; cx++) {
> +		pgm =3D PGM_BIT_SPEC | (a[cx] >=3D maxram ? PGM_BIT_ADDR : 0);
> +		if (!test_one_sccb(valid_code, (void *)a[cx], 0, pgm, 0))
> +			break;
> +	}
> +	report("SCCB high addresses", cx =3D=3D i);
> +}
> +
> +/**
> + * Test invalid commands, both invalid command detail codes and valid
> + * ones with invalid command class code.
> + */
> +static void test_inval(void)
> +{
> +	uint32_t cmd;
> +	int cx;
> +
> +	report_prefix_push("Invalid command");
> +	for (cx =3D 0; cx < 65536; cx++) {
> +		cmd =3D (0xdead0000) | cx;
> +		if (!test_one_run(cmd, pagebuf, PAGE_SIZE, PAGE_SIZE, 0, SCLP_RC_INV=
ALID_SCLP_COMMAND))
> +			break;
> +	}
> +	report("Command detail code", cx =3D=3D 65536);
> +
> +	for (cx =3D 0; cx < 256; cx++) {
> +		cmd =3D (valid_code & ~0xff) | cx;
> +		if (cmd =3D=3D valid_code)
> +			continue;
> +		if (!test_one_run(cmd, pagebuf, PAGE_SIZE, PAGE_SIZE, 0, SCLP_RC_INV=
ALID_SCLP_COMMAND))
> +			break;
> +	}
> +	report("Command class code", cx =3D=3D 256);
> +	report_prefix_pop();
> +}
> +
> +
> +/**
> + * Test short SCCBs (but larger than 8).
> + */
> +static void test_short(void)
> +{
> +	uint16_t res =3D SCLP_RC_INSUFFICIENT_SCCB_LENGTH;
> +	int cx;
> +
> +	for (cx =3D 8; cx < 144; cx++)
> +		if (!test_one_run(valid_code, pagebuf, cx, cx, 0, res))
> +			break;
> +	report("Insufficient SCCB length (Read SCP info)", cx =3D=3D 144);
> +
> +	for (cx =3D 8; cx < 40; cx++)
> +		if (!test_one_run(SCLP_READ_CPU_INFO, pagebuf, cx, cx, 0, res))
> +			break;
> +	report("Insufficient SCCB length (Read CPU info)", cx =3D=3D 40);
> +}
> +
> +/**
> + * Test SCCB page boundary violations.
> + */
> +static void test_boundary(void)
> +{
> +	uint32_t cmd =3D SCLP_CMD_WRITE_EVENT_DATA;
> +	uint16_t res =3D SCLP_RC_SCCB_BOUNDARY_VIOLATION;
> +	WriteEventData *sccb =3D (WriteEventData *)sccb_template;
> +	int len, cx;
> +
> +	memset(sccb_template, 0, sizeof(sccb_template));
> +	sccb->h.function_code =3D SCLP_FC_NORMAL_WRITE;
> +	for (len =3D 32; len <=3D 4096; len++) {
> +		cx =3D len & 7 ? len & ~7 : len - 8;
> +		for (cx =3D 4096 - cx; cx < 4096; cx +=3D 8) {
> +			sccb->h.length =3D len;
> +			if (!test_one_sccb(cmd, cx + pagebuf, len, 0, res))
> +				goto out;
> +		}
> +	}
> +out:
> +	report("SCCB page boundary violation", len > 4096 && cx =3D=3D 4096);=

> +}
> +
> +static void test_toolong(void)
> +{
> +	uint32_t cmd =3D SCLP_CMD_WRITE_EVENT_DATA;
> +	uint16_t res =3D SCLP_RC_SCCB_BOUNDARY_VIOLATION;

Why use variables for constants that are never touched?

> +	WriteEventData *sccb =3D (WriteEventData *)sccb_template;
> +	int cx;
> +
> +	memset(sccb_template, 0, sizeof(sccb_template));
> +	sccb->h.function_code =3D SCLP_FC_NORMAL_WRITE;
> +	for (cx =3D 4097; cx < 8192; cx++) {
> +		sccb->h.length =3D cx;
> +		if (!test_one_sccb(cmd, pagebuf, PAGE_SIZE, 0, res))
> +			break;
> +	}
> +	report("SCCB bigger than 4k", cx =3D=3D 8192);
> +}
> +
> +/**
> + * Test privileged operation.
> + */
> +static void test_priv(void)
> +{
> +	report_prefix_push("Privileged operation");
> +	pagebuf[0] =3D 0;
> +	pagebuf[1] =3D 8;

Id much rather have a proper cast using the header struct.

> +	expect_pgm_int();
> +	enter_pstate();
> +	servc(valid_code, __pa(pagebuf));
> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();
> +}
> +
> +/**
> + * Test addressing exceptions. We need to test SCCB addresses between =
the
> + * end of available memory and 2GB, because after 2GB a specification
> + * exception is also allowed.
> + * Only applicable if the VM has less than 2GB of memory
> + */
> +static void test_addressing(void)
> +{
> +	unsigned long cx, maxram =3D get_ram_size();
> +
> +	if (maxram >=3D 0x80000000) {
> +		report_skip("Invalid SCCB address");
> +		return;
> +	}
> +	for (cx =3D maxram; cx < MIN(maxram + 65536, 0x80000000); cx +=3D 8)
> +		if (!test_one_sccb(valid_code, (void *)cx, 0, PGM_BIT_ADDR, 0))
> +			goto out;
> +	for (; cx < MIN((maxram + 0x7fffff) & ~0xfffff, 0x80000000); cx +=3D =
4096)
> +		if (!test_one_sccb(valid_code, (void *)cx, 0, PGM_BIT_ADDR, 0))
> +			goto out;
> +	for (; cx < 0x80000000; cx +=3D 1048576)
> +		if (!test_one_sccb(valid_code, (void *)cx, 0, PGM_BIT_ADDR, 0))
> +			goto out;
> +out:
> +	report("Invalid SCCB address", cx =3D=3D 0x80000000);
> +}
> +
> +/**
> + * Test some bits in the instruction format that are specified to be i=
gnored.
> + */
> +static void test_instbits(void)
> +{
> +	SCCBHeader *h =3D (SCCBHeader *)pagebuf;
> +	unsigned long mask;
> +	int cc;
> +
> +	sclp_mark_busy();
> +	h->length =3D 8;
> +
> +	ctl_set_bit(0, 9);
> +	mask =3D extract_psw_mask();
> +	mask |=3D PSW_MASK_EXT;
> +	load_psw_mask(mask);

Huh, you already got a function for that at the top.

> +
> +	asm volatile(
> +		"       .insn   rre,0xb2204200,%1,%2\n"  /* servc %1,%2 */
> +		"       ipm     %0\n"
> +		"       srl     %0,28"
> +		: "=3D&d" (cc) : "d" (valid_code), "a" (__pa(pagebuf))
> +		: "cc", "memory");
> +	sclp_wait_busy();
> +	report("Instruction format ignored bits", cc =3D=3D 0);
> +}
> +
> +/**
> + * Find a valid SCLP command code; not all codes are always allowed, a=
nd
> + * probing should be performed in the right order.
> + */
> +static void find_valid_sclp_code(void)
> +{
> +	unsigned int commands[] =3D { SCLP_CMDW_READ_SCP_INFO_FORCED,
> +				    SCLP_CMDW_READ_SCP_INFO };
> +	SCCBHeader *h =3D (SCCBHeader *)pagebuf;
> +	int i, cc;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(commands); i++) {
> +		sclp_mark_busy();
> +		memset(h, 0, sizeof(pagebuf));

pagebuf is 8k, but you can only use 4k in sclp.
We don't need to clear 2 pages.

> +		h->length =3D 4096;
> +
> +		valid_code =3D commands[i];
> +		cc =3D sclp_service_call(commands[i], h);
> +		if (cc)
> +			break;
> +		if (h->response_code =3D=3D SCLP_RC_NORMAL_READ_COMPLETION)
> +			return;
> +		if (h->response_code !=3D SCLP_RC_INVALID_SCLP_COMMAND)
> +			break;

Depending on line length you could add that to the cc check.
Maybe you could also group the error conditions before the success
conditions or the other way around.

> +	}
> +	valid_code =3D 0;
> +	report_abort("READ_SCP_INFO failed");
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("sclp");
> +	find_valid_sclp_code();
> +
> +	/* Test some basic things */
> +	test_instbits();
> +	test_priv();
> +	test_addressing();
> +
> +	/* Test the specification exceptions */
> +	test_sccb_too_short();
> +	test_sccb_unaligned();
> +	test_sccb_prefix();
> +	test_sccb_high();
> +
> +	/* Test the expected response codes */
> +	test_inval();
> +	test_short();
> +	test_boundary();
> +	test_toolong();
> +
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index f1b07cd..75e3d37 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -75,3 +75,6 @@ file =3D stsi.elf
>  [smp]
>  file =3D smp.elf
>  extra_params =3D-smp 2
> +
> +[sclp]
> +file =3D sclp.elf

Don't we need a newline here?

>=20



--JQngfHj2tyWmdDlUZ7p1hyn9KiZBrlUIK--

--mHotetrfn77cTZyiT8EGp6QGqpNmeCqkn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl2/8yQACgkQ41TmuOI4
ufiLVA//e1jwstBzjmOrHbXdfHMEYOONH0pPQSzlb5ogB87wW1SH8hrlLRSyYL6M
3IFg1re4nm+MGF/GDtS4U4s41N1aqRU7s2ENHCjgNnMpqDN4ru5GMmKM7g7fXLnX
u4znrsSfMyhw/l5jjd6dcbdPcZNY4St7ioAeXlC2lzw1CQCNkLzBaCyVNf+NO5Bf
A9UWo/2IJn5T0FF48us28ETMGA7JIlGXdJ0diybeHlyYlIQ4BfRaIM5u3nOcPlUr
1/v4TCSVGnR/yBRcuwm3i/Nk6Y9oa5hWEMbDU+KGDre+rq25yVNsUxHa4Y9q169t
KiU62e/s0MJ3/LA7jorpmARyLle8T8ThaA0kbdlWrmn9kWmgNa8Mr0RA2yAX/Zxz
8ZtOsbAYQe4j9ys6ZrCTp6se9OE/7cm18WYtPgIdUIszbg5ZCILDNnefJ1pYor9s
ZjTedZb6wiIfalMGUPnOgEe+1PkkDjauI6N0u+RcasRM6shLX9VZ+pKkPoCsdL9g
w2YAfSnqcE1y7H9toSIOfjGLOxGLexHI/tOk/3jWTLzKH5vvo509iRkx2EVYFspM
B+KO9g6uOCx9J5Gct2ScJTwCIfd93IGe2CyHpk0VELzpAbNA2jk8DpvFv7q3KBUt
xJCJy7vRJPCu5BaD8v05A76Ak1C1+Fy9FF4AfIb0P3JmMTglc/I=
=nqq4
-----END PGP SIGNATURE-----

--mHotetrfn77cTZyiT8EGp6QGqpNmeCqkn--

