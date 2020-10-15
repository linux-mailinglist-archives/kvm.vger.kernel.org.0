Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B3628F285
	for <lists+kvm@lfdr.de>; Thu, 15 Oct 2020 14:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgJOMke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Oct 2020 08:40:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9100 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726103AbgJOMkd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Oct 2020 08:40:33 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09FCXP8I077558
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 08:40:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=7XN1XbThgTmw3dhrrJlFIuN0+9JG9uS6puICZiZPQAI=;
 b=qsKBZf5Qe++n4JNfFs+qP0pX+498cIKO4KrG2mVAxzC2F556CmyIb0kQ+r06y0YknE7I
 R4zGcr1HpadJAO70qZyTpX04Nhz0m6EKvp34/XDf9ONfWf/mnINw+YmZ+maeJvDT839d
 wg3p7QvtA6YZhzUbk5GhAl8a755y9Gc2IvHuw6iNa/itNbtcgEj9jmuSI4WEemKwkOGa
 nzQzV1nwTyV0kylXAH+Vs+dvuCQBY9NU4PNwoC/wAtsQY7TTs5KApCfQqmh3CfwfS/SZ
 SmjB1Ox2QvpnZ7440BZhOVfYeBKRaaOGRIGWg8cQH3DvFnEeIQ4TfyPZIZg20Ey1Q+KD mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 346p03stt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 08:40:32 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09FCXQDp077796
        for <kvm@vger.kernel.org>; Thu, 15 Oct 2020 08:40:32 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 346p03stsc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Oct 2020 08:40:32 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09FCWSBg002875;
        Thu, 15 Oct 2020 12:40:30 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3434k858kg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Oct 2020 12:40:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09FCeRN031195546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 12:40:27 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0C1AAE04D;
        Thu, 15 Oct 2020 12:40:27 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45C52AE053;
        Thu, 15 Oct 2020 12:40:27 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.33.162])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Oct 2020 12:40:27 +0000 (GMT)
Subject: Re: [PATCH v1] self_tests/kvm: sync_regs and reset tests for diag318
To:     Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com
References: <20201014192710.66578-1-walling@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <d90a2c37-46b7-5fc9-efb8-c5a6bb1c6d7e@linux.ibm.com>
Date:   Thu, 15 Oct 2020 14:40:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201014192710.66578-1-walling@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DXpU9MOuIfcirw6LrAlcDdueFGKZQye94"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-15_07:2020-10-14,2020-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 suspectscore=2 adultscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DXpU9MOuIfcirw6LrAlcDdueFGKZQye94
Content-Type: multipart/mixed; boundary="M7Xr2GcAVC3OqPwtwEVo9ZFlagL5ILfug"

--M7Xr2GcAVC3OqPwtwEVo9ZFlagL5ILfug
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/14/20 9:27 PM, Collin Walling wrote:
> The DIAGNOSE 0x0318 instruction, unique to s390x, is a privileged call
> that must be intercepted via SIE, handled in userspace, and the
> information set by the instruction is communicated back to KVM.

It might be nice to have a few words in here about what information can
be set via the diag.

>=20
> To test the instruction interception, an ad-hoc handler is defined whic=
h
> simply has a VM execute the instruction and then userspace will extract=

> the necessary info. The handler is defined such that the instruction
> invocation occurs only once. It is up the the caller to determine how t=
he
> info returned by this handler should be used.
>=20
> The diag318 info is communicated from userspace to KVM via a sync_regs
> call. This is tested during a sync_regs test, where the diag318 info is=

> requested via the handler, then the info is stored in the appropriate
> register in KVM via a sync registers call.
>=20
> The diag318 info is checked to be 0 after a normal and clear reset.
>=20
> If KVM does not support diag318, then the tests will print a message
> stating that diag318 was skipped, and the asserts will simply test
> against a value of 0.
>=20
> Signed-off-by: Collin Walling <walling@linux.ibm.com>

Checkpatch throws lots of errors on this patch.
Could you check if my workflow misteriously introduced windows line
endings or if they were introduced on your side?

> ---
>  tools/testing/selftests/kvm/Makefile          |  2 +-
>  .../kvm/include/s390x/diag318_test_handler.h  | 13 +++
>  .../kvm/lib/s390x/diag318_test_handler.c      | 80 +++++++++++++++++++=

>  tools/testing/selftests/kvm/s390x/resets.c    |  6 ++
>  .../selftests/kvm/s390x/sync_regs_test.c      | 16 +++-
>  5 files changed, 115 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/s390x/diag318_t=
est_handler.h
>  create mode 100644 tools/testing/selftests/kvm/lib/s390x/diag318_test_=
handler.c
>=20
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selft=
ests/kvm/Makefile
> index 4a166588d99f..ed172a0b83b6 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -36,7 +36,7 @@ endif
>  LIBKVM =3D lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebi=
t.c lib/test_util.c
>  LIBKVM_x86_64 =3D lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/s=
vm.c lib/x86_64/ucall.c
>  LIBKVM_aarch64 =3D lib/aarch64/processor.c lib/aarch64/ucall.c
> -LIBKVM_s390x =3D lib/s390x/processor.c lib/s390x/ucall.c
> +LIBKVM_s390x =3D lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/dia=
g318_test_handler.c
> =20
>  TEST_GEN_PROGS_x86_64 =3D x86_64/cr4_cpuid_sync_test
>  TEST_GEN_PROGS_x86_64 +=3D x86_64/evmcs_test
> diff --git a/tools/testing/selftests/kvm/include/s390x/diag318_test_han=
dler.h b/tools/testing/selftests/kvm/include/s390x/diag318_test_handler.h=

> new file mode 100644
> index 000000000000..d8233ebf317b
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/s390x/diag318_test_handler.h
> @@ -0,0 +1,13 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Test handler for the s390x DIAGNOSE 0x0318 instruction.
> + *
> + * Copyright (C) 2020, IBM
> + */
> +
> +#ifndef SELFTEST_KVM_DIAG318_TEST_HANDLER
> +#define SELFTEST_KVM_DIAG318_TEST_HANDLER
> +
> +uint64_t get_diag318_info(void);
> +
> +#endif
> diff --git a/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler=
=2Ec b/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
> new file mode 100644
> index 000000000000..024e3a9ffda7
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/s390x/diag318_test_handler.c
> @@ -0,0 +1,80 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Test handler for the s390x DIAGNOSE 0x0318 instruction.
> + *
> + * Copyright (C) 2020, IBM
> + */
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +
> +#define VCPU_ID	5
> +
> +#define ICPT_INSTRUCTION	0x04
> +#define IPA0_DIAG		0x8300
> +
> +static void guest_code(void)
> +{
> +	uint64_t diag318_info =3D 0x12345678;
> +
> +	asm volatile ("diag %0,0,0x318\n" : : "d" (diag318_info));
> +}
> +
> +/*
> + * The DIAGNOSE 0x0318 instruction call must be handled via userspace.=
 As such,
> + * we create an ad-hoc VM here to handle the instruction then extract =
the
> + * necessary data. It is up to the caller to decide what to do with th=
at data.
> + */
> +static uint64_t diag318_handler(void)
> +{
> +	struct kvm_vm *vm;
> +	struct kvm_run *run;
> +	uint64_t reg;
> +	uint64_t diag318_info;
> +
> +	vm =3D vm_create_default(VCPU_ID, 0, guest_code);
> +	vcpu_run(vm, VCPU_ID);
> +	run =3D vcpu_state(vm, VCPU_ID);
> +
> +	TEST_ASSERT(run->exit_reason =3D=3D KVM_EXIT_S390_SIEIC,
> +		    "DIAGNOSE 0x0318 instruction was not intercepted");
> +	TEST_ASSERT(run->s390_sieic.icptcode =3D=3D ICPT_INSTRUCTION,
> +		    "Unexpected intercept code: 0x%x", run->s390_sieic.icptcode);
> +	TEST_ASSERT((run->s390_sieic.ipa & 0xff00) =3D=3D IPA0_DIAG,
> +		    "Unexpected IPA0 code: 0x%x", (run->s390_sieic.ipa & 0xff00));
> +
> +	reg =3D (run->s390_sieic.ipa & 0x00f0) >> 4;
> +	diag318_info =3D run->s.regs.gprs[reg];
> +
> +	kvm_vm_free(vm);
> +
> +	return diag318_info;
> +}
> +
> +uint64_t get_diag318_info(void)
> +{
> +	static uint64_t diag318_info;
> +	static bool printed_skip;
> +
> +	/*
> +	 * If KVM does not support diag318, then return 0 to
> +	 * ensure tests do not break.
> +	 */
> +	if (!kvm_check_cap(KVM_CAP_S390_DIAG318)) {
> +		if (!printed_skip) {
> +			fprintf(stdout, "KVM_CAP_S390_DIAG318 not supported. "

Whitespace after .

> +				"Skipping diag318 test.\n");
> +			printed_skip =3D true;
> +		}
> +		return 0;
> +	}
> +
> +	/*
> +	 * If a test has previously requested the diag318 info,
> +	 * then don't bother spinning up a temporary VM again.
> +	 */
> +	if (!diag318_info)
> +		diag318_info =3D diag318_handler();
> +
> +	return diag318_info;
> +}
> diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing=
/selftests/kvm/s390x/resets.c
> index b143db6d8693..d0416ba94ec5 100644
> --- a/tools/testing/selftests/kvm/s390x/resets.c
> +++ b/tools/testing/selftests/kvm/s390x/resets.c
> @@ -12,6 +12,7 @@
> =20
>  #include "test_util.h"
>  #include "kvm_util.h"
> +#include "diag318_test_handler.h"
> =20
>  #define VCPU_ID 3
>  #define LOCAL_IRQS 32
> @@ -110,6 +111,8 @@ static void assert_clear(void)
> =20
>  	TEST_ASSERT(!memcmp(sync_regs->vrs, regs_null, sizeof(sync_regs->vrs)=
),
>  		    "vrs0-15 =3D=3D 0 (sync_regs)");
> +
> +	TEST_ASSERT(sync_regs->diag318 =3D=3D 0, "diag318 =3D=3D 0 (sync_regs=
)");
>  }
> =20
>  static void assert_initial_noclear(void)
> @@ -182,6 +185,7 @@ static void assert_normal(void)
>  	test_one_reg(KVM_REG_S390_PFTOKEN, KVM_S390_PFAULT_TOKEN_INVALID);
>  	TEST_ASSERT(sync_regs->pft =3D=3D KVM_S390_PFAULT_TOKEN_INVALID,
>  			"pft =3D=3D 0xff.....  (sync_regs)");
> +	TEST_ASSERT(sync_regs->diag318 =3D=3D 0, "diag318 =3D=3D 0 (sync_regs=
)");
>  	assert_noirq();
>  }
> =20
> @@ -206,6 +210,7 @@ static void test_normal(void)
>  	/* Create VM */
>  	vm =3D vm_create_default(VCPU_ID, 0, guest_code_initial);
>  	run =3D vcpu_state(vm, VCPU_ID);
> +	run->s.regs.diag318 =3D get_diag318_info();
>  	sync_regs =3D &run->s.regs;
> =20
>  	vcpu_run(vm, VCPU_ID);
> @@ -250,6 +255,7 @@ static void test_clear(void)
>  	pr_info("Testing clear reset\n");
>  	vm =3D vm_create_default(VCPU_ID, 0, guest_code_initial);
>  	run =3D vcpu_state(vm, VCPU_ID);
> +	run->s.regs.diag318 =3D get_diag318_info();
>  	sync_regs =3D &run->s.regs;
> =20
>  	vcpu_run(vm, VCPU_ID);
> diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools=
/testing/selftests/kvm/s390x/sync_regs_test.c
> index 5731ccf34917..caf7b8859a94 100644
> --- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
> +++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
> @@ -20,6 +20,7 @@
> =20
>  #include "test_util.h"
>  #include "kvm_util.h"
> +#include "diag318_test_handler.h"
> =20
>  #define VCPU_ID 5
> =20
> @@ -70,7 +71,7 @@ static void compare_sregs(struct kvm_sregs *left, str=
uct kvm_sync_regs *right)
> =20
>  #undef REG_COMPARE
> =20
> -#define TEST_SYNC_FIELDS   (KVM_SYNC_GPRS|KVM_SYNC_ACRS|KVM_SYNC_CRS)
> +#define TEST_SYNC_FIELDS   (KVM_SYNC_GPRS|KVM_SYNC_ACRS|KVM_SYNC_CRS|K=
VM_SYNC_DIAG318)
>  #define INVALID_SYNC_FIELD 0x80000000
> =20
>  int main(int argc, char *argv[])
> @@ -152,6 +153,12 @@ int main(int argc, char *argv[])
> =20
>  	run->kvm_valid_regs =3D TEST_SYNC_FIELDS;
>  	run->kvm_dirty_regs =3D KVM_SYNC_GPRS | KVM_SYNC_ACRS;
> +
> +	if (get_diag318_info() > 0) {
> +		run->s.regs.diag318 =3D get_diag318_info();
> +		run->kvm_dirty_regs |=3D KVM_SYNC_DIAG318;
> +	}
> +
>  	rv =3D _vcpu_run(vm, VCPU_ID);
>  	TEST_ASSERT(rv =3D=3D 0, "vcpu_run failed: %d\n", rv);
>  	TEST_ASSERT(run->exit_reason =3D=3D KVM_EXIT_S390_SIEIC,
> @@ -164,6 +171,9 @@ int main(int argc, char *argv[])
>  	TEST_ASSERT(run->s.regs.acrs[0]  =3D=3D 1 << 11,
>  		    "acr0 sync regs value incorrect 0x%x.",
>  		    run->s.regs.acrs[0]);
> +	TEST_ASSERT(run->s.regs.diag318 =3D=3D get_diag318_info(),
> +		    "diag318 sync regs value incorrect 0x%llx.",
> +		    run->s.regs.diag318);
> =20
>  	vcpu_regs_get(vm, VCPU_ID, &regs);
>  	compare_regs(&regs, &run->s.regs);
> @@ -177,6 +187,7 @@ int main(int argc, char *argv[])
>  	run->kvm_valid_regs =3D TEST_SYNC_FIELDS;
>  	run->kvm_dirty_regs =3D 0;
>  	run->s.regs.gprs[11] =3D 0xDEADBEEF;
> +	run->s.regs.diag318 =3D 0x4B1D;
>  	rv =3D _vcpu_run(vm, VCPU_ID);
>  	TEST_ASSERT(rv =3D=3D 0, "vcpu_run failed: %d\n", rv);
>  	TEST_ASSERT(run->exit_reason =3D=3D KVM_EXIT_S390_SIEIC,
> @@ -186,6 +197,9 @@ int main(int argc, char *argv[])
>  	TEST_ASSERT(run->s.regs.gprs[11] !=3D 0xDEADBEEF,
>  		    "r11 sync regs value incorrect 0x%llx.",
>  		    run->s.regs.gprs[11]);
> +	TEST_ASSERT(run->s.regs.diag318 !=3D 0x4B1D,
> +		    "diag318 sync regs value incorrect 0x%llx.",
> +		    run->s.regs.diag318);
> =20
>  	kvm_vm_free(vm);
> =20
>=20



--M7Xr2GcAVC3OqPwtwEVo9ZFlagL5ILfug--

--DXpU9MOuIfcirw6LrAlcDdueFGKZQye94
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl+IQzoACgkQ41TmuOI4
ufj3jg/+MKD1tgNjh2OJ7w5uyWF2frt5KnmNZlRyTANk+swWe8NrMWaWjfoM6vfD
bXpLtd8gQG4igjp9bKREzgHujGf6yjNHcaGGwdqMkHMr5DtJ/BzD6+izmA+6UKFU
Yb3B/8udugSMsV5pf8eXSwUvDw0/EZdadWugXrGILvVmzyBTC4/6nH1o4yXfpXJT
Vnyet/RnOeQUa+QFF34xE6WSz725ifdEacp3y8Qh55BMduwZFHo1stUZyBJYoZ96
SRArowmuayK15+7YpTDbbrwpv+/M8is/3Rbcvuxqvnm/rH9s7qo8pQI0h0VKFi/R
OV2X4mwa+AZy3iP/g2DR9sZMHy2ElMgYQGt0jZl5DZEQKgGqRMS49J1VbZqbLQC8
oOGkSNVt891Vg9qWBFDnd6ZdGLcLsElQEAQhwQs4WY4q8yoiilGoqt6GSmdazbnC
hbwu6ZRmq7NGzRXnl2+7SUtn4/VU2SmOWq7VSDM+P8YRwwCzRg/uihQ+dP7z0ZmM
vE0QUQ9k1SXCDC6gQaiyZeDNbTyU5FBmA0MRCkaTUYz1hYAIEoHu7puTGv/R8BzH
AnrZ0iK4mOupfgpTnOJ5zhBT3FflEAsTQPS+xZ1CiJMJThKlDHeJt24vlv8QkotZ
HivIfH4D7KYPtaOv4qpq4v+4DAnrksz86criMD9RWfGxC+c1uNY=
=equp
-----END PGP SIGNATURE-----

--DXpU9MOuIfcirw6LrAlcDdueFGKZQye94--

