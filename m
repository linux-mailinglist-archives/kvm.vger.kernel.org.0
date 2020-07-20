Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A2D225D9C
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 13:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgGTLmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 07:42:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4422 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728058AbgGTLmo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jul 2020 07:42:44 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KBXe1p177137;
        Mon, 20 Jul 2020 07:42:42 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d2m34cjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 07:42:42 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06KBZOhA183321;
        Mon, 20 Jul 2020 07:42:41 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d2m34cj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 07:42:41 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06KBfhJY024799;
        Mon, 20 Jul 2020 11:42:39 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 32brbh2kdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:42:39 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06KBgaDS63176836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 11:42:36 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE69E5204F;
        Mon, 20 Jul 2020 11:42:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.20.48])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5BB0C52051;
        Mon, 20 Jul 2020 11:42:36 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: Ultavisor guest API test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, cohuck@redhat.com
References: <20200717145813.62573-1-frankja@linux.ibm.com>
 <20200717145813.62573-4-frankja@linux.ibm.com>
 <20200720124938.556220fe@ibm-vm>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <36472fe5-9c74-12c0-8a67-1aea09995aba@linux.ibm.com>
Date:   Mon, 20 Jul 2020 13:42:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200720124938.556220fe@ibm-vm>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Czr7U9lTXJz9JceWpQwYktjrdbGJ48k4f"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_07:2020-07-20,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 clxscore=1015 suspectscore=2 phishscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200081
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Czr7U9lTXJz9JceWpQwYktjrdbGJ48k4f
Content-Type: multipart/mixed; boundary="z9AO3NxIdeO7k4GIr24FDkgCCwN6PMKC7"

--z9AO3NxIdeO7k4GIr24FDkgCCwN6PMKC7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/20/20 12:49 PM, Claudio Imbrenda wrote:
> On Fri, 17 Jul 2020 10:58:13 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> Test the error conditions of guest 2 Ultravisor calls, namely:
>>      * Query Ultravisor information
>>      * Set shared access
>>      * Remove shared access
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/asm/uv.h  |  68 +++++++++++++++++++
>>  s390x/Makefile      |   1 +
>>  s390x/unittests.cfg |   3 +
>>  s390x/uv-guest.c    | 156
>> ++++++++++++++++++++++++++++++++++++++++++++ 4 files changed, 228
>> insertions(+) create mode 100644 lib/s390x/asm/uv.h
>>  create mode 100644 s390x/uv-guest.c
>>
>> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
>> new file mode 100644
>> index 0000000..14ab5cc
>> --- /dev/null
>> +++ b/lib/s390x/asm/uv.h
>> @@ -0,0 +1,68 @@
>> +/*
>> + * s390x Ultravisor related definitions
>> + *
>> + * Copyright (c) 2020 IBM Corp
>> + *
>> + * Authors:
>> + *  Janosch Frank <frankja@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify
>> it
>> + * under the terms of the GNU General Public License version 2.
>> + */
>> +#ifndef UV_H
>> +#define UV_H
>> +
>> +#define UVC_RC_EXECUTED		0x0001
>> +#define UVC_RC_INV_CMD		0x0002
>> +#define UVC_RC_INV_STATE	0x0003
>> +#define UVC_RC_INV_LEN		0x0005
>> +#define UVC_RC_NO_RESUME	0x0007
>> +
>> +#define UVC_CMD_QUI			0x0001
>> +#define UVC_CMD_SET_SHARED_ACCESS	0x1000
>> +#define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
>> +
>> +/* Bits in installed uv calls */
>> +enum uv_cmds_inst {
>> +	BIT_UVC_CMD_QUI =3D 0,
>> +	BIT_UVC_CMD_SET_SHARED_ACCESS =3D 8,
>> +	BIT_UVC_CMD_REMOVE_SHARED_ACCESS =3D 9,
>> +};
>> +
>> +struct uv_cb_header {
>> +	u16 len;
>> +	u16 cmd;	/* Command Code */
>> +	u16 rc;		/* Response Code */
>> +	u16 rrc;	/* Return Reason Code */
>> +} __attribute__((packed))  __attribute__((aligned(8)));
>> +
>> +struct uv_cb_qui {
>> +	struct uv_cb_header header;
>> +	u64 reserved08;
>> +	u64 inst_calls_list[4];
>> +	u64 reserved30[15];
>> +} __attribute__((packed))  __attribute__((aligned(8)));
>> +
>> +struct uv_cb_share {
>> +	struct uv_cb_header header;
>> +	u64 reserved08[3];
>> +	u64 paddr;
>> +	u64 reserved28;
>> +} __attribute__((packed))  __attribute__((aligned(8)));
>> +
>> +static inline int uv_call(unsigned long r1, unsigned long r2)
>> +{
>> +	int cc;
>> +
>> +	asm volatile(
>> +		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
>> +		"		brc	3,0b\n"
>> +		"		ipm	%[cc]\n"
>> +		"		srl	%[cc],28\n"
>> +		: [cc] "=3Dd" (cc)
>> +		: [r1] "a" (r1), [r2] "a" (r2)
>> +		: "memory", "cc");
>> +	return cc;
>> +}
>> +
>> +#endif
>> diff --git a/s390x/Makefile b/s390x/Makefile
>> index 0f54bf4..c2213ad 100644
>> --- a/s390x/Makefile
>> +++ b/s390x/Makefile
>> @@ -18,6 +18,7 @@ tests +=3D $(TEST_DIR)/skrf.elf
>>  tests +=3D $(TEST_DIR)/smp.elf
>>  tests +=3D $(TEST_DIR)/sclp.elf
>>  tests +=3D $(TEST_DIR)/css.elf
>> +tests +=3D $(TEST_DIR)/uv-guest.elf
>>  tests_binary =3D $(patsubst %.elf,%.bin,$(tests))
>> =20
>>  all: directories test_cases test_cases_binary
>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>> index b35269b..38c3257 100644
>> --- a/s390x/unittests.cfg
>> +++ b/s390x/unittests.cfg
>> @@ -92,3 +92,6 @@ extra_params =3D -device virtio-net-ccw
>>  [skrf]
>>  file =3D skrf.elf
>>  smp =3D 2
>> +
>> +[uv-guest]
>> +file =3D uv-guest.elf
>> \ No newline at end of file
>> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
>> new file mode 100644
>> index 0000000..0cb5fae
>> --- /dev/null
>> +++ b/s390x/uv-guest.c
>> @@ -0,0 +1,156 @@
>> +/*
>> + * Guest Ultravisor Call tests
>> + *
>> + * Copyright (c) 2020 IBM Corp
>> + *
>> + * Authors:
>> + *  Janosch Frank <frankja@linux.ibm.com>
>> + *
>> + * This code is free software; you can redistribute it and/or modify
>> it
>> + * under the terms of the GNU General Public License version 2.
>> + */
>> +
>> +#include <libcflat.h>
>> +#include <alloc_page.h>
>> +#include <asm/page.h>
>> +#include <asm/asm-offsets.h>
>> +#include <asm/interrupt.h>
>> +#include <asm/facility.h>
>> +#include <asm/uv.h>
>> +
>> +static inline int share(unsigned long addr, u16 cmd)
>> +{
>> +	struct uv_cb_share uvcb =3D {
>> +		.header.cmd =3D cmd,
>> +		.header.len =3D sizeof(uvcb),
>> +		.paddr =3D addr
>> +	};
>> +
>> +	uv_call(0, (u64)&uvcb);
>> +	return uvcb.header.rc;
>> +}
>> +
>> +static inline int uv_set_shared(unsigned long addr)
>> +{
>> +	return share(addr, UVC_CMD_SET_SHARED_ACCESS);
>> +}
>> +
>> +static inline int uv_remove_shared(unsigned long addr)
>> +{
>> +	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
>> +}
>> +
>> +static void test_priv(void)
>> +{
>> +	struct uv_cb_header uvcb =3D {};
>> +
>> +	report_prefix_push("privileged");
>> +
>> +	report_prefix_push("query");
>> +	expect_pgm_int();
>> +	uvcb.cmd =3D UVC_CMD_QUI;
>> +	uvcb.len =3D sizeof(struct uv_cb_qui);
>> +	enter_pstate();
>> +	uv_call(0, (u64)&uvcb);
>> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("share");
>> +	expect_pgm_int();
>> +	enter_pstate();
>> +	uv_set_shared(0x42000);
>> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("unshare");
>> +	expect_pgm_int();
>> +	enter_pstate();
>> +	uv_remove_shared(0x42000);
>=20
> I don't like using a hardwired address here (and above). Things can get=

> messy if the address ends up outside memory or overlapping code.
>=20
> I think the best approach would be to declare a page aligned buffer and=

> use that (or even allocate a page)=20

Sure, will do

>=20
>> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
>> +	report_prefix_pop();
>> +
>> +	report_prefix_pop();
>> +}
>> +
>> +static void test_query(void)
>> +{
>> +	struct uv_cb_qui uvcb =3D {
>> +		.header.cmd =3D UVC_CMD_QUI,
>> +		.header.len =3D sizeof(uvcb) - 8,
>> +	};
>> +
>> +	report_prefix_push("query");
>> +	uv_call(0, (u64)&uvcb);
>> +	report(uvcb.header.rc =3D=3D UVC_RC_INV_LEN, "length");
>> +
>> +	uvcb.header.len =3D sizeof(uvcb);
>> +	uv_call(0, (u64)&uvcb);
>> +	report(uvcb.header.rc =3D=3D UVC_RC_EXECUTED, "successful
>> query"); +
>> +	/*
>> +	 * These bits have been introduced with the very first
>> +	 * Ultravisor version and are expected to always be available
>> +	 * because they are basic building blocks.
>> +	 */
>> +	report(uvcb.inst_calls_list[0] & (1UL << (63 -
>> BIT_UVC_CMD_QUI)),
>> +	       "query indicated");
>> +	report(uvcb.inst_calls_list[0] & (1UL << (63 -
>> BIT_UVC_CMD_SET_SHARED_ACCESS)),
>> +	       "share indicated");
>> +	report(uvcb.inst_calls_list[0] & (1UL << (63 -
>> BIT_UVC_CMD_REMOVE_SHARED_ACCESS)),
>> +	       "unshare indicated");
>> +	report_prefix_pop();
>> +}
>> +
>> +static void test_sharing(void)
>> +{
>> +	unsigned long mem =3D (unsigned long)alloc_page();
>> +	struct uv_cb_share uvcb =3D {
>> +		.header.cmd =3D UVC_CMD_SET_SHARED_ACCESS,
>> +		.header.len =3D sizeof(uvcb) - 8,
>> +	};
>> +
>> +	report_prefix_push("share");
>> +	uv_call(0, (u64)&uvcb);
>> +	report(uvcb.header.rc =3D=3D UVC_RC_INV_LEN, "length");
>> +	report(uv_set_shared(mem) =3D=3D UVC_RC_EXECUTED, "share");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("unshare");
>> +	uvcb.header.cmd =3D UVC_CMD_REMOVE_SHARED_ACCESS;
>> +	uv_call(0, (u64)&uvcb);
>> +	report(uvcb.header.rc =3D=3D UVC_RC_INV_LEN, "length");
>> +	report(uv_remove_shared(mem) =3D=3D UVC_RC_EXECUTED, "unshare");
>> +	free_page((void *)mem);
>> +	report_prefix_pop();
>> +
>> +	report_prefix_pop();
>> +}
>> +
>> +static void test_invalid(void)
>> +{
>> +	struct uv_cb_header uvcb =3D {
>> +		.len =3D 16,
>> +		.cmd =3D 0x4242,
>> +	};
>> +
>> +	uv_call(0, (u64)&uvcb);
>> +	report(uvcb.rc =3D=3D UVC_RC_INV_CMD, "invalid command");
>> +}
>> +
>> +int main(void)
>> +{
>> +	bool has_uvc =3D test_facility(158);
>> +
>> +	report_prefix_push("uvc");
>> +	if (!has_uvc) {
>> +		report_skip("Ultravisor call facility is not
>> available");
>> +		goto done;
>> +	}
>> +
>> +	test_priv();
>> +	test_invalid();
>> +	test_query();
>> +	test_sharing();
>> +done:
>> +	return report_summary();
>> +}
>=20
> once the above comment is addressed:
> Claudio Imbrenda <imbrenda@linux.ibm.com>
>=20
?


--z9AO3NxIdeO7k4GIr24FDkgCCwN6PMKC7--

--Czr7U9lTXJz9JceWpQwYktjrdbGJ48k4f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8VgysACgkQ41TmuOI4
ufi0DBAAr9BlpqaNkx1PTsi1jM11Yej8x6BNVHU0lhEi27ePG9rz2F7J06cUcmvM
MbXB+8hD/j6nUUJGkUY+LUgqd/A6S1lWjqQNMKu5QsgNslUKQF30t7Tdb8mZiQDh
xRoNRk7m564dzuw/dOVWduhuefDZWaNW5x6b9a5Y4GHlAOUq27B5XGLC+p++hDbl
39F/IMWIP2GaE9ey8JeuBI2nmi2+LZz6upwWBQ9xMNN2HThGW/GtrV9Aey647YRb
gwvD0cl0tOytNv8rn36Ba8AGQHmzdGn21dp69QhiyCU+NTs5RuYfqxoB+U2pVjPn
1kAkJjo6IRTQsxPHAR3utDTb5UI0+1aoZtQvMGPitkhCIivY5zagxnAuWchdb5rp
M4UrcY7PoRizRZvQ9lS20VAWD0z9u52u3FxOM8SFVKqX+u9dd6Tt10heBgJVn8aJ
sZ+IN8LXhrww26Xi4eUfQF2jxXU/9qwSHeMrpnV8VDIPs3H2dnVgYVX7AI6An+KO
KxUe99HARx+Zjh3R002VRERDZP26WY7A2qjIV5yXYyMjkKLCliBP7BiGkR1Z+PGO
tzyGbvgdEGjUsZq7ly+jFVndYH1jILmrrZ7ofRu/sFwZJZu3Tp3e3BJvF6aWSIuN
UakLYRS0R/zZ3MHRoqNpiRLpffc53wKOspKtnHrzFQY8EbQJ15s=
=kDVc
-----END PGP SIGNATURE-----

--Czr7U9lTXJz9JceWpQwYktjrdbGJ48k4f--

