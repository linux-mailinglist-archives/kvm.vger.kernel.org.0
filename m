Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F75314D9D7
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 12:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgA3LcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 06:32:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10330 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727149AbgA3LcT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 06:32:19 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00UBPBCF090749
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 06:32:16 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xtfh1usye-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 06:32:16 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 30 Jan 2020 11:32:14 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 30 Jan 2020 11:32:12 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00UBWBra49479778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 11:32:11 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F13AA405F;
        Thu, 30 Jan 2020 11:32:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 328F3A4060;
        Thu, 30 Jan 2020 11:32:11 +0000 (GMT)
Received: from dyn-9-152-224-44.boeblingen.de.ibm.com (unknown [9.152.224.44])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jan 2020 11:32:11 +0000 (GMT)
Subject: Re: [PATCH v8 3/4] selftests: KVM: s390x: Add reset tests
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20200129200312.3200-1-frankja@linux.ibm.com>
 <20200129200312.3200-4-frankja@linux.ibm.com>
 <e0f72503-d292-edc4-67e1-abe1cbab3f96@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 30 Jan 2020 12:32:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <e0f72503-d292-edc4-67e1-abe1cbab3f96@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aV2kLhZXopzXtRlUaYnXzoa4HARRRtF3a"
X-TM-AS-GCONF: 00
x-cbid: 20013011-4275-0000-0000-0000039C641B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013011-4276-0000-0000-000038B081B1
Message-Id: <0993d789-5cfd-d4c3-a39e-28d22d82dd43@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-30_03:2020-01-28,2020-01-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=13 mlxlogscore=999 bulkscore=0
 malwarescore=0 spamscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001300084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aV2kLhZXopzXtRlUaYnXzoa4HARRRtF3a
Content-Type: multipart/mixed; boundary="oPhuGBJpkO1xZu8AhwW788Csh2zwgGIOS"

--oPhuGBJpkO1xZu8AhwW788Csh2zwgGIOS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/30/20 11:51 AM, Thomas Huth wrote:
> On 29/01/2020 21.03, Janosch Frank wrote:
>> Test if the registers end up having the correct values after a normal,=

>> initial and clear reset.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  tools/testing/selftests/kvm/Makefile       |   1 +
>>  tools/testing/selftests/kvm/s390x/resets.c | 165 ++++++++++++++++++++=
+
>>  2 files changed, 166 insertions(+)
>>  create mode 100644 tools/testing/selftests/kvm/s390x/resets.c
>>
>> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/self=
tests/kvm/Makefile
>> index 3138a916574a..fe1ea294730c 100644
>> --- a/tools/testing/selftests/kvm/Makefile
>> +++ b/tools/testing/selftests/kvm/Makefile
>> @@ -36,6 +36,7 @@ TEST_GEN_PROGS_aarch64 +=3D kvm_create_max_vcpus
>> =20
>>  TEST_GEN_PROGS_s390x =3D s390x/memop
>>  TEST_GEN_PROGS_s390x +=3D s390x/sync_regs_test
>> +TEST_GEN_PROGS_s390x +=3D s390x/resets
>>  TEST_GEN_PROGS_s390x +=3D dirty_log_test
>>  TEST_GEN_PROGS_s390x +=3D kvm_create_max_vcpus
>> =20
>> diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testin=
g/selftests/kvm/s390x/resets.c
>> new file mode 100644
>> index 000000000000..2b2378cc9e80
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/s390x/resets.c
>> @@ -0,0 +1,165 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * Test for s390x CPU resets
>> + *
>> + * Copyright (C) 2020, IBM
>> + */
>> +
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <sys/ioctl.h>
>> +
>> +#include "test_util.h"
>> +#include "kvm_util.h"
>> +
>> +#define VCPU_ID 3
>> +
>> +struct kvm_vm *vm;
>> +struct kvm_run *run;
>> +struct kvm_sync_regs *regs;
>> +static uint64_t regs_null[16];
>> +
>> +static uint64_t crs[16] =3D { 0x40000ULL,
>> +			    0x42000ULL,
>> +			    0, 0, 0, 0, 0,
>> +			    0x43000ULL,
>> +			    0, 0, 0, 0, 0,
>> +			    0x44000ULL,
>> +			    0, 0
>> +};
>> +
>> +static void guest_code_initial(void)
>> +{
>> +	/* Round toward 0 */
>> +	uint32_t fpc =3D 0x11;
>> +
>> +	/* Dirty registers */
>> +	asm volatile (
>> +		"	lctlg	0,15,%0\n"
>> +		"	sfpc	%1\n"
>> +		: : "Q" (crs), "d" (fpc));
>=20
> I'd recommend to add a GUEST_SYNC(0) here ... otherwise the guest code
> tries to return from this function and will cause a crash - which will
> also finish execution of the guest, but might have unexpected side effe=
cts.

Ok

>=20
>> +}
>> +
>> +static void test_one_reg(uint64_t id, uint64_t value)
>> +{
>> +	struct kvm_one_reg reg;
>> +	uint64_t eval_reg;
>> +
>> +	reg.addr =3D (uintptr_t)&eval_reg;
>> +	reg.id =3D id;
>> +	vcpu_get_reg(vm, VCPU_ID, &reg);
>> +	TEST_ASSERT(eval_reg =3D=3D value, "value =3D=3D %s", value);
>> +}
>> +
>> +static void assert_clear(void)
>> +{
>> +	struct kvm_sregs sregs;
>> +	struct kvm_regs regs;
>> +	struct kvm_fpu fpu;
>> +
>> +	vcpu_regs_get(vm, VCPU_ID, &regs);
>> +	TEST_ASSERT(!memcmp(&regs.gprs, regs_null, sizeof(regs.gprs)), "grs =
=3D=3D 0");
>> +
>> +	vcpu_sregs_get(vm, VCPU_ID, &sregs);
>> +	TEST_ASSERT(!memcmp(&sregs.acrs, regs_null, sizeof(sregs.acrs)), "ac=
rs =3D=3D 0");
>> +
>> +	vcpu_fpu_get(vm, VCPU_ID, &fpu);
>> +	TEST_ASSERT(!memcmp(&fpu.fprs, regs_null, sizeof(fpu.fprs)), "fprs =3D=
=3D 0");
>> +}
>> +
>> +static void assert_initial(void)
>> +{
>> +	struct kvm_sregs sregs;
>> +	struct kvm_fpu fpu;
>> +
>> +	vcpu_sregs_get(vm, VCPU_ID, &sregs);
>> +	TEST_ASSERT(sregs.crs[0] =3D=3D 0xE0UL, "cr0 =3D=3D 0xE0");
>> +	TEST_ASSERT(sregs.crs[14] =3D=3D 0xC2000000UL, "cr14 =3D=3D 0xC20000=
00");
>> +	TEST_ASSERT(!memcmp(&sregs.crs[1], regs_null, sizeof(sregs.crs[1]) *=
 12),
>> +		    "cr1-13 =3D=3D 0");
>> +	TEST_ASSERT(sregs.crs[15] =3D=3D 0, "cr15 =3D=3D 0");
>> +
>> +	vcpu_fpu_get(vm, VCPU_ID, &fpu);
>> +	TEST_ASSERT(!fpu.fpc, "fpc =3D=3D 0");
>> +
>> +	test_one_reg(KVM_REG_S390_GBEA, 1);
>> +	test_one_reg(KVM_REG_S390_PP, 0);
>> +	test_one_reg(KVM_REG_S390_TODPR, 0);
>> +	test_one_reg(KVM_REG_S390_CPU_TIMER, 0);
>> +	test_one_reg(KVM_REG_S390_CLOCK_COMP, 0);
>> +}
>> +
>> +static void assert_normal(void)
>> +{
>> +	test_one_reg(KVM_REG_S390_PFTOKEN, KVM_S390_PFAULT_TOKEN_INVALID);
>> +}
>> +
>> +static void test_normal(void)
>> +{
>> +	printf("Testing notmal reset\n");
>> +	/* Create VM */
>> +	vm =3D vm_create_default(VCPU_ID, 0, guest_code_initial);
>> +	run =3D vcpu_state(vm, VCPU_ID);
>> +	regs =3D &run->s.regs;
>> +
>> +	_vcpu_run(vm, VCPU_ID);
>=20
> Could you use vcpu_run() instead of _vcpu_run() ?

Done.

>=20
>> +	vcpu_ioctl(vm, VCPU_ID, KVM_S390_NORMAL_RESET, 0);
>> +	assert_normal();
>> +	kvm_vm_free(vm);
>> +}
>> +
>> +static int test_initial(void)
>> +{
>> +	int rv;
>> +
>> +	printf("Testing initial reset\n");
>> +	/* Create VM */
>> +	vm =3D vm_create_default(VCPU_ID, 0, guest_code_initial);
>> +	run =3D vcpu_state(vm, VCPU_ID);
>> +	regs =3D &run->s.regs;
>> +
>> +	rv =3D _vcpu_run(vm, VCPU_ID);
>=20
> Extra bonus points if you check here that the registers contain the
> values that have been set by the guest ;-)

I started working on that yesterday

>=20
>> +	vcpu_ioctl(vm, VCPU_ID, KVM_S390_INITIAL_RESET, 0);
>> +	assert_normal();
>> +	assert_initial();
>> +	kvm_vm_free(vm);
>> +	return rv;
>> +}
>> +
>> +static int test_clear(void)
>> +{
>> +	int rv;
>> +
>> +	printf("Testing clear reset\n");
>> +	/* Create VM */
>> +	vm =3D vm_create_default(VCPU_ID, 0, guest_code_initial);
>> +	run =3D vcpu_state(vm, VCPU_ID);
>> +	regs =3D &run->s.regs;
>> +
>> +	rv =3D _vcpu_run(vm, VCPU_ID);
>> +
>> +	vcpu_ioctl(vm, VCPU_ID, KVM_S390_CLEAR_RESET, 0);
>> +	assert_normal();
>> +	assert_initial();
>> +	assert_clear();
>> +	kvm_vm_free(vm);
>> +	return rv;
>> +}
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +	int addl_resets;
>> +
>> +	setbuf(stdout, NULL);	/* Tell stdout not to buffer its content */
>> +	addl_resets =3D kvm_check_cap(KVM_CAP_S390_VCPU_RESETS);
>> +
>> +	test_initial();
>> +	if (addl_resets) {
>=20
> I think you could still fit this into one line, without the need to
> declare the addl_resets variable:

The other question is if we still need to check that if the test is
bundled with the kernel anyway?

>=20
> 	if (kvm_check_cap(KVM_CAP_S390_VCPU_RESETS)) {
>=20
>> +		test_normal();
>> +		test_clear();
>> +	}
>> +	return 0;
>> +}
>=20
> Apart from the nits, this looks pretty good already, thanks for putting=

> it together!
>=20
>  Thomas
>=20



--oPhuGBJpkO1xZu8AhwW788Csh2zwgGIOS--

--aV2kLhZXopzXtRlUaYnXzoa4HARRRtF3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4yvroACgkQ41TmuOI4
ufjVdw/6Ak0HntjpU+nvOCG45/ZpEdaqXHHpWuZicHdSY+d37tfSt7DEfY4VxLcA
t/ZYUVSjbQjcZJVJKQ7gy1DH9uYSxDroFuu8SpVl5VlGk45WQXGSsEwq/KKc2SRN
TShaPStZnOInopdP9WROFux2WLZtUrxvnE3ySDVRS2fFh1CETgvp3eJtyy8yB9DP
qKCVvcLGP7DqcAYbh9axpWWUc2CZri/7CCc45HMazgTmRteJqsxqsa4GrFJ4r315
TWXTRiLodg0Nja7aU8BuiQMciZd/y3ywh44o8FywO6oZ2T64ZfsHD5SOxyqfOEQr
tkNH7tsO3DU77ZtOs7Gsg/vmzR3r3bhcEWe69mlCs2dC52UTORqCHbIdipmRNL5x
cvk18zYCOmjkexxsyYC998YcRhX8/QvrNv/RhbL9stE9iOllJyBhO4MVv2eccXaK
iQ+tWNfMHwtLzU8P4229QWt0ULTzOJOja8afETcmsJxs+kjpnNAyijUFLTqKvYm9
MN7lJrCezVMMY54HN4iKuoV0fmaX0GYgCA64HoU6uvSOS2X3lwhKMjyMilw/NLgX
Xq3L/xtXZYozisWDut6m33DoZv6Zq1MdhxbkzGR4kUpXJyDO52KIi3B5/meUXO26
WDIRdSD/VqME/CiaZ9xUl0seopOV6g+V/8pl3pP8Ab5mtg7JdOs=
=A3gx
-----END PGP SIGNATURE-----

--aV2kLhZXopzXtRlUaYnXzoa4HARRRtF3a--

