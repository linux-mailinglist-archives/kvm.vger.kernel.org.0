Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF26214D9DB
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 12:33:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbgA3LdK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 06:33:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53040 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727103AbgA3LdK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 06:33:10 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00UBNnLx051549
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 06:33:09 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xuagnwdqg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 06:33:08 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 30 Jan 2020 11:33:06 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 30 Jan 2020 11:33:02 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00UBX1Ew53805178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 11:33:01 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C447A405C;
        Thu, 30 Jan 2020 11:33:01 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 292E8A4054;
        Thu, 30 Jan 2020 11:33:01 +0000 (GMT)
Received: from dyn-9-152-224-44.boeblingen.de.ibm.com (unknown [9.152.224.44])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jan 2020 11:33:01 +0000 (GMT)
Subject: Re: [PATCH v8 4/4] selftests: KVM: testing the local IRQs resets
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20200129200312.3200-1-frankja@linux.ibm.com>
 <20200129200312.3200-5-frankja@linux.ibm.com>
 <a9fd8939-503e-bf11-7f5e-bb83a79a1bf9@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 mQINBFubpD4BEADX0uhkRhkj2AVn7kI4IuPY3A8xKat0ihuPDXbynUC77mNox7yvK3X5QBO6
 qLqYr+qrG3buymJJRD9xkp4mqgasHdB5WR9MhXWKH08EvtvAMkEJLnqxgbqf8td3pCQ2cEpv
 15mH49iKSmlTcJ+PvJpGZcq/jE42u9/0YFHhozm8GfQdb9SOI/wBSsOqcXcLTUeAvbdqSBZe
 zuMRBivJQQI1esD9HuADmxdE7c4AeMlap9MvxvUtWk4ZJ/1Z3swMVCGzZb2Xg/9jZpLsyQzb
 lDbbTlEeyBACeED7DYLZI3d0SFKeJZ1SUyMmSOcr9zeSh4S4h4w8xgDDGmeDVygBQZa1HaoL
 Esb8Y4avOYIgYDhgkCh0nol7XQ5i/yKLtnNThubAcxNyryw1xSstnKlxPRoxtqTsxMAiSekk
 0m3WJwvwd1s878HrQNK0orWd8BzzlSswzjNfQYLF466JOjHPWFOok9pzRs+ucrs6MUwDJj0S
 cITWU9Rxb04XyigY4XmZ8dywaxwi2ZVTEg+MD+sPmRrTw+5F+sU83cUstuymF3w1GmyofgsU
 Z+/ldjToHnq21MNa1wx0lCEipCCyE/8K9B9bg9pUwy5lfx7yORP3JuAUfCYb8DVSHWBPHKNj
 HTOLb2g2UT65AjZEQE95U2AY9iYm5usMqaWD39pAHfhC09/7NQARAQABtCVKYW5vc2NoIEZy
 YW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+iQI3BBMBCAAhBQJbm6Q+AhsjBQsJCAcCBhUI
 CQoLAgQWAgMBAh4BAheAAAoJEONU5rjiOLn4p9gQALjkdj5euJVI2nNT3/IAxAhQSmRhPEt0
 AmnCYnuTcHRWPujNr5kqgtyER9+EMQ0ZkX44JU2q7OWxTdSNSAN/5Z7qmOR9JySvDOf4d3mS
 bMB5zxL9d8SbnSs1uW96H9ZBTlTQnmLfsiM9TetAjSrR8nUmjGhe2YUhJLR1v1LguME+YseT
 eXnLzIzqqpu311/eYiiIGcmaOjPCE+vFjcXL5oLnGUE73qSYiujwhfPCCUK0850o1fUAYq5p
 CNBCoKT4OddZR+0itKc/cT6NwEDwdokeg0+rAhxb4Rv5oFO70lziBplEjOxu3dqgIKbHbjza
 EXTb+mr7VI9O4tTdqrwJo2q9zLqqOfDBi7NDvZFLzaCewhbdEpDYVu6/WxprAY94hY3F4trT
 rQMHJKQENtF6ZTQc9fcT5I3gAmP+OEvDE5hcTALpWm6Z6SzxO7gEYCnF+qGXqp8sJVrweMub
 UscyLqHoqdZC2UG4LQ1OJ97nzDpIRe0g6oJ9ZIYHKmfw5jjwH6rASTld5MFWajWdNsqK15k/
 RZnHAGICKVIBOBsq26m4EsBlfCdt3b/6emuBjUXR1pyjHMz2awWzCq6/6OWs5eANZ0sdosNq
 dq2v0ULYTazJz2rlCXV89qRa7ukkNwdBSZNEwsD4eEMicj1LSrqWDZMAALw50L4jxaMD7lPL
 jJbauQINBFubpD4BEADAcUTRqXF/aY53OSH7IwIK9lFKxIm0IoFkOEh7LMfp7FGzaP7ANrZd
 cIzhZi38xyOkcaFY+npGEWvko7rlIAn0JpBO4x3hfhmhBD/WSY8LQIFQNNjEm3vzrMo7b9Jb
 JAqQxfbURY3Dql3GUzeWTG9uaJ00u+EEPlY8zcVShDltIl5PLih20e8xgTnNzx5c110lQSu0
 iZv2lAE6DM+2bJQTsMSYiwKlwTuv9LI9Chnoo6+tsN55NqyMxYqJgElk3VzlTXSr3+rtSCwf
 tq2cinETbzxc1XuhIX6pu/aCGnNfuEkM34b7G1D6CPzDMqokNFbyoO6DQ1+fW6c5gctXg/lZ
 602iEl4C4rgcr3+EpfoPUWzKeM8JXv5Kpq4YDxhvbitr8Dm8gr38+UKFZKlWLlwhQ56r/zAU
 v6LIsm11GmFs2/cmgD1bqBTNHHcTWwWtRTLgmnqJbVisMJuYJt4KNPqphTWsPY8SEtbufIlY
 HXOJ2lqUzOReTrie2u0qcSvGAbSfec9apTFl2Xko/ddqPcZMpKhBiXmY8tJzSPk3+G4tqur4
 6TYAm5ouitJsgAR61Cu7s+PNuq/pTLDhK+6/Njmc94NGBcRA4qTuysEGE79vYWP2oIAU4Fv6
 gqaWHZ4MEI2XTqH8wiwzPdCQPYsSE0fXWiYu7ObeErT6iLSTZGx4rQARAQABiQIfBBgBCAAJ
 BQJbm6Q+AhsMAAoJEONU5rjiOLn4DDEP/RuyckW65SZcPG4cMfNgWxZF8rVjeVl/9PBfy01K
 8R0hajU40bWtXSMiby7j0/dMjz99jN6L+AJHJvrLz4qYRzn2Ys843W+RfXj62Zde4YNBE5SL
 jJweRCbMWKaJLj6499fctxTyeb9+AMLQS4yRSwHuAZLmAb5AyCW1gBcTWZb8ON5BmWnRqeGm
 IgC1EvCnHy++aBnHTn0m+zV89BhTLTUal35tcjUFwluBY39R2ux/HNlBO1GY3Z+WYXhBvq7q
 katThLjaQSmnOrMhzqYmdShP1leFTVbzXUUIYv/GbynO/YrL2gaQpaP1bEUEi8lUAfXJbEWG
 dnHFkciryi092E8/9j89DJg4mmZqOau7TtUxjRMlBcIliXkzSLUk+QvD4LK1kWievJse4mte
 FBdkWHfP4BH/+8DxapRcG1UAheSnSRQ5LiO50annOB7oXF+vgKIaie2TBfZxQNGAs3RQ+bga
 DchCqFm5adiSP5+OT4NjkKUeGpBe/aRyQSle/RropTgCi85pje/juYEn2P9UAgkfBJrOHvQ9
 Z+2Sva8FRd61NJLkCJ4LFumRn9wQlX2icFbi8UDV3do0hXJRRYTWCxrHscMhkrFWLhYiPF4i
 phX7UNdOWBQ90qpHyAxHmDazdo27gEjfvsgYMdveKknEOTEb5phwxWgg7BcIDoJf9UMC
Date:   Thu, 30 Jan 2020 12:33:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a9fd8939-503e-bf11-7f5e-bb83a79a1bf9@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DGrWTHLfQc3psSj5x8Y8XRQnJsi3gXgi4"
X-TM-AS-GCONF: 00
x-cbid: 20013011-0028-0000-0000-000003D5DF03
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013011-0029-0000-0000-0000249A2D7A
Message-Id: <cf61103b-86b0-5bc2-51a2-46ff6485c632@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-30_03:2020-01-28,2020-01-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 suspectscore=3 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001300084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DGrWTHLfQc3psSj5x8Y8XRQnJsi3gXgi4
Content-Type: multipart/mixed; boundary="kVu9UrRZ7yB5bsQzRiige4JyIPQv9Levn"

--kVu9UrRZ7yB5bsQzRiige4JyIPQv9Levn
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/30/20 12:10 PM, Thomas Huth wrote:
> On 29/01/2020 21.03, Janosch Frank wrote:
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
>> +	 */
>> +	if (irqs < 0)
>> +		printf("Error by getting IRQ: errno %d\n", errno);
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
>> +		return errno;
>> +	}
>=20
> Can you turn this into a TEST_ASSERT() instead? Otherwise the printf()
> error might go unnoticed.

I've converted both error checks into asserts (set/get irq) and made the
function void.


>=20
> Apart from that (and the nits that Cornelia already mentioned), the
> patch looks fine to me.
>=20
>  Thomas
>=20



--kVu9UrRZ7yB5bsQzRiige4JyIPQv9Levn--

--DGrWTHLfQc3psSj5x8Y8XRQnJsi3gXgi4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4yvuwACgkQ41TmuOI4
ufgszA/+Jcbj2JR9uFmPxNi7uBD83MYOr1fJXmEMpOeMchd0vfpPIkb5Hbh9WbYD
N4Qrw6tqZZEQU8IYdMra9RAzUgMyZWLkrDMp/BQzGwSX/GcwYzdlmUrXxISo2a4g
A+m9ua07x0PxxEm8b9TztcY8B30rQutKQZMgVXGBpeLtkRgF25qggx8GXW6CWAy6
BZTinrczp7ZQICtKWxrEtur3z59azZOdduaII3xa9tlvYKf26b870I7n5kXUUNxk
GKxWQBdTFgshXgbszfn4iqf+loVTRbDb2JW8E8r7S6J4Dpw3C8gMKYqqzm9cfRz+
hKwIIvFhy7iqts03oZTgUFTuEc6zrijIH2L9f9YNVlHqfHCjCtpy1NtROqTCImjL
raCmvr9U2h8DTPPtJZhdBAhCYtI8YL4a+G3Zjnq/MNQmrC0tI+oZN8FermTfyGM5
Kxr1jChgNptPp4EDOnzPRkcHfQRw8Ql6JvZlj94SkDWU2cqRU4Ml4B01jkTuYGeW
4P6ZEHxIO2UrRP/FIKiP0ysdnpydT9NoGUAhIL29MhyXyXKCmpo0U0/wMuNpG+7o
01sQ3iV8BBuKrW85rgtfhgg+afg3XqaIqc2jHNMUIUgJwgpjOmikWqwIV293fSIK
fmnFOKf2lLH3f7MOvjSQacfJQOJDCsEN9UCAiQpOWuTgWBfNHcA=
=MHpG
-----END PGP SIGNATURE-----

--DGrWTHLfQc3psSj5x8Y8XRQnJsi3gXgi4--

