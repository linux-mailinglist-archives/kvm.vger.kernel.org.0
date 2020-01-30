Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6236F14D996
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 12:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgA3LSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 06:18:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47528 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727027AbgA3LSk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 06:18:40 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00UBE3b8106188
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 06:18:39 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xu5qc55ys-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 06:18:39 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 30 Jan 2020 11:18:36 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 30 Jan 2020 11:18:33 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00UBIWw755312490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 11:18:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEE4BA4060;
        Thu, 30 Jan 2020 11:18:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FD73A4054;
        Thu, 30 Jan 2020 11:18:32 +0000 (GMT)
Received: from dyn-9-152-224-44.boeblingen.de.ibm.com (unknown [9.152.224.44])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jan 2020 11:18:32 +0000 (GMT)
Subject: Re: [PATCH v8 4/4] selftests: KVM: testing the local IRQs resets
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org
References: <20200129200312.3200-1-frankja@linux.ibm.com>
 <20200129200312.3200-5-frankja@linux.ibm.com>
 <20200130115543.1f06a840.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 30 Jan 2020 12:18:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200130115543.1f06a840.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZGNTOLMI7yxLUd8xEEIRDSYw9ufgUN7VD"
X-TM-AS-GCONF: 00
x-cbid: 20013011-0016-0000-0000-000002E22128
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013011-0017-0000-0000-00003344EAF8
Message-Id: <bd7dc770-4613-5af5-e695-aabc70f84c16@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-30_03:2020-01-28,2020-01-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 suspectscore=11 priorityscore=1501
 malwarescore=0 mlxscore=0 clxscore=1015 bulkscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001300082
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZGNTOLMI7yxLUd8xEEIRDSYw9ufgUN7VD
Content-Type: multipart/mixed; boundary="oVvsTwUOEzZIK0M6YJ8gwPb6HhQluhAtY"

--oVvsTwUOEzZIK0M6YJ8gwPb6HhQluhAtY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/30/20 11:55 AM, Cornelia Huck wrote:
> On Wed, 29 Jan 2020 15:03:12 -0500
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> From: Pierre Morel <pmorel@linux.ibm.com>
>>
>> Local IRQs are reset by a normal cpu reset.  The initial cpu reset and=

>> the clear cpu reset, as superset of the normal reset, both clear the
>> IRQs too.
>>
>> Let's inject an interrupt to a vCPU before calling a reset and see if
>> it is gone after the reset.
>>
>> We choose to inject only an emergency interrupt at this point and can
>> extend the test to other types of IRQs later.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>=20
> You probably should add your s-o-b here as well.
>=20
>> ---
>>  tools/testing/selftests/kvm/s390x/resets.c | 57 +++++++++++++++++++++=
+
>>  1 file changed, 57 insertions(+)
>>
>> diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testin=
g/selftests/kvm/s390x/resets.c
>> index 2b2378cc9e80..299c1686f98c 100644
>> --- a/tools/testing/selftests/kvm/s390x/resets.c
>> +++ b/tools/testing/selftests/kvm/s390x/resets.c
>> @@ -14,6 +14,9 @@
>>  #include "kvm_util.h"
>> =20
>>  #define VCPU_ID 3
>> +#define LOCAL_IRQS 32
>=20
> Why 32?
>=20
>> +
>> +struct kvm_s390_irq buf[VCPU_ID + LOCAL_IRQS];
>> =20
>>  struct kvm_vm *vm;
>>  struct kvm_run *run;
>> @@ -52,6 +55,29 @@ static void test_one_reg(uint64_t id, uint64_t valu=
e)
>>  	TEST_ASSERT(eval_reg =3D=3D value, "value =3D=3D %s", value);
>>  }
>> =20
>> +static void assert_noirq(void)
>> +{
>> +	struct kvm_s390_irq_state irq_state;
>> +	int irqs;
>> +
>> +	if (!(kvm_check_cap(KVM_CAP_S390_INJECT_IRQ) &&
>> +	    kvm_check_cap(KVM_CAP_S390_IRQ_STATE)))
>> +		return;
>=20
> Might want to do a
>=20
> irq_introspection_supported =3D (check stuff);
>=20
> once for this test? Works fine as is, of course.
>=20
>> +
>> +	irq_state.len =3D sizeof(buf);
>> +	irq_state.buf =3D (unsigned long)buf;
>> +	irqs =3D _vcpu_ioctl(vm, VCPU_ID, KVM_S390_GET_IRQ_STATE, &irq_state=
);
>> +	/*
>> +	 * irqs contains the number of retrieved interrupts, apart from the
>> +	 * emergency call that should be cleared by the resets, there should=
 be
>> +	 * none.
>=20
> Even if there were any, they should have been cleared by the reset,
> right?

Yes, that's what "there should be none" should actually express.
I added the comment before sending out.

>=20
>> +	 */
>> +	if (irqs < 0)
>> +		printf("Error by getting IRQ: errno %d\n", errno);
>=20
> "Error getting pending IRQs" ?

"Could not fetch IRQs: errno %d\n" ?

>=20
>> +
>> +	TEST_ASSERT(!irqs, "IRQ pending");
>> +}
>> +
>>  static void assert_clear(void)
>>  {
>>  	struct kvm_sregs sregs;
>> @@ -93,6 +119,31 @@ static void assert_initial(void)
>>  static void assert_normal(void)
>>  {
>>  	test_one_reg(KVM_REG_S390_PFTOKEN, KVM_S390_PFAULT_TOKEN_INVALID);
>> +	assert_noirq();
>> +}
>> +
>> +static int inject_irq(int cpu_id)
>=20
> You never seem to check the return code.
>=20
>> +{
>> +	struct kvm_s390_irq_state irq_state;
>> +	struct kvm_s390_irq *irq =3D &buf[0];
>> +	int irqs;
>> +
>> +	if (!(kvm_check_cap(KVM_CAP_S390_INJECT_IRQ) &&
>> +	    kvm_check_cap(KVM_CAP_S390_IRQ_STATE)))
>> +		return 0;
>> +
>> +	/* Inject IRQ */
>> +	irq_state.len =3D sizeof(struct kvm_s390_irq);
>> +	irq_state.buf =3D (unsigned long)buf;
>> +	irq->type =3D KVM_S390_INT_EMERGENCY;
>> +	irq->u.emerg.code =3D cpu_id;
>> +	irqs =3D _vcpu_ioctl(vm, cpu_id, KVM_S390_SET_IRQ_STATE, &irq_state)=
;
>> +	if (irqs < 0) {
>> +		printf("Error by injecting INT_EMERGENCY: errno %d\n", errno);
>=20
> "Error injecting EMERGENCY IRQ" ?

Sounds good

>=20
>> +		return errno;
>> +	}
>> +
>> +	return 0;
>>  }
>> =20
>>  static void test_normal(void)
>> @@ -105,6 +156,8 @@ static void test_normal(void)
>> =20
>>  	_vcpu_run(vm, VCPU_ID);
>> =20
>> +	inject_irq(VCPU_ID);
>> +
>>  	vcpu_ioctl(vm, VCPU_ID, KVM_S390_NORMAL_RESET, 0);
>>  	assert_normal();
>>  	kvm_vm_free(vm);
>> @@ -122,6 +175,8 @@ static int test_initial(void)
>> =20
>>  	rv =3D _vcpu_run(vm, VCPU_ID);
>> =20
>> +	inject_irq(VCPU_ID);
>> +
>>  	vcpu_ioctl(vm, VCPU_ID, KVM_S390_INITIAL_RESET, 0);
>>  	assert_normal();
>>  	assert_initial();
>> @@ -141,6 +196,8 @@ static int test_clear(void)
>> =20
>>  	rv =3D _vcpu_run(vm, VCPU_ID);
>> =20
>> +	inject_irq(VCPU_ID);
>> +
>>  	vcpu_ioctl(vm, VCPU_ID, KVM_S390_CLEAR_RESET, 0);
>>  	assert_normal();
>>  	assert_initial();
>=20
> On the whole, looks good to me.
>=20



--oVvsTwUOEzZIK0M6YJ8gwPb6HhQluhAtY--

--ZGNTOLMI7yxLUd8xEEIRDSYw9ufgUN7VD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4yu4gACgkQ41TmuOI4
ufjRRA/9EkqOS9xDYfbsJCh/Ijpj0T9uj/ZB4uHUv3KlVp7nr8qBmeweOvmD10RB
PcHR8q5Vej/Kf78sZWXE9e57oSkab7/p00dtQPAOfjV/odmODD72Pltbo6aaPAzT
3P+q30ygkOVr/yAOUQs5bCCOI1O3cXF8+PKIWmn8L1BwlLelayxoVxSWvPqtUPEN
OA/Pg3wn5L1K6Ov/4y4y7F3E3XsySoq16cRh1mZ3+ArYfmgv3N+9lFe/jSweKgHD
42xSrTAWy7pWYcQ1dYGLLHwxDCYU7eddN9jOzAfwT21leXfGj1ad/G/YmIJR5Idx
DGgtKNzbPhqj73bwcpWImBqC+vvuBJIaNPrr+McLpn9IglW3DfTY6aPi/XgGvlWp
4+b75UFFZRosCOgVBONjZoAk5Ahuqo3g/cRPkxlisZSSjrGYoO4CbO2MTpFfCrjO
zQjtxpfGWPhP2FIwT87+Jo5DjnOF6cesm/9e3pRhxgxuLtt/NVyg6FHvmdQ+T8Pk
cQOaPPMSCd5H++9Apor/v/zgNkvjEBQonwyGl7uOI61vuK2g4E8YDn/+iG3LMAuC
K6d0QD4IQ5sW/s9SerueLKHHTXdxfFCyaRnatRBJaoXrqwtlLIRyqMNwzE+mD7Bz
i5dudrJrIKh6jTnjkuDhZtpuiWeDMR4Cp/2SV/oP/iiq2He6rQA=
=RFu9
-----END PGP SIGNATURE-----

--ZGNTOLMI7yxLUd8xEEIRDSYw9ufgUN7VD--

