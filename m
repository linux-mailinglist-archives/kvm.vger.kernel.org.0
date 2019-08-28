Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3A029FA80
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 08:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfH1G0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 02:26:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11658 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726146AbfH1G0u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Aug 2019 02:26:50 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7S6NpNX109707
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 02:26:50 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2unhg9p2we-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 02:26:49 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 28 Aug 2019 07:26:47 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 28 Aug 2019 07:26:43 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7S6Qgh743909252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Aug 2019 06:26:42 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B5C2711C054;
        Wed, 28 Aug 2019 06:26:42 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CB6611C052;
        Wed, 28 Aug 2019 06:26:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.32.236])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Aug 2019 06:26:42 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: Add storage key removal
 facility
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com
References: <20190827134936.1705-1-frankja@linux.ibm.com>
 <20190827134936.1705-4-frankja@linux.ibm.com>
 <ea6d114c-9025-2e15-89b8-52b938efc129@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 28 Aug 2019 08:26:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <ea6d114c-9025-2e15-89b8-52b938efc129@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5LvCsyVCQkKunP9t8f7wuow6SOVBqPMgQ"
X-TM-AS-GCONF: 00
x-cbid: 19082806-4275-0000-0000-0000035E318B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082806-4276-0000-0000-000038706452
Message-Id: <f0cddac0-a574-1aeb-69c6-b9d67f2dfd97@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-28_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908280067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5LvCsyVCQkKunP9t8f7wuow6SOVBqPMgQ
Content-Type: multipart/mixed; boundary="x23KFKtO0yhRUGcR4Af4Mi12osHKYCEgS";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, david@redhat.com
Message-ID: <f0cddac0-a574-1aeb-69c6-b9d67f2dfd97@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 3/3] s390x: Add storage key removal
 facility
References: <20190827134936.1705-1-frankja@linux.ibm.com>
 <20190827134936.1705-4-frankja@linux.ibm.com>
 <ea6d114c-9025-2e15-89b8-52b938efc129@redhat.com>
In-Reply-To: <ea6d114c-9025-2e15-89b8-52b938efc129@redhat.com>

--x23KFKtO0yhRUGcR4Af4Mi12osHKYCEgS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/27/19 7:58 PM, Thomas Huth wrote:
> On 27/08/2019 15.49, Janosch Frank wrote:
>> The storage key removal facility (stfle bit 169) makes all key related=

>> instructions result in a special operation exception if they handle a
>> key.
>>
>> Let's make sure that the skey and pfmf tests only run non key code
>> (pfmf) or not at all (skey).
>>
>> Also let's test this new facility. As lots of instructions are
>> affected by this, only some of them are tested for now.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---

>> +static void test_skey(void)
>> +{
>> +	report_prefix_push("(i|s)ske");
>> +	expect_pgm_int();
>> +	set_storage_key(pagebuf, 0x30, 0);
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
>> +	expect_pgm_int();
>> +	get_storage_key(pagebuf);
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
>> +	report_prefix_pop();
>=20
> Wouldn't it be better to have distinct prefixes for the two tests?

Will do

>=20
>> +}
>> +
>> +static void test_pfmf(void)
>> +{
>> +	union pfmf_r1 r1;
>> +
>> +	report_prefix_push("pfmf");
>> +	r1.val =3D 0;
>> +	r1.reg.sk =3D 1;
>> +	r1.reg.fsc =3D PFMF_FSC_4K;
>> +	r1.reg.key =3D 0x30;
>> +	expect_pgm_int();
>> +	pfmf(r1.val, pagebuf);
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
>> +	report_prefix_pop();
>> +}
>> +
>> +static void test_psw_key(void)
>> +{
>> +	uint64_t psw_mask =3D extract_psw_mask() | 0xF0000000000000UL;
>> +
>> +	report_prefix_push("psw key");
>> +	expect_pgm_int();
>> +	load_psw_mask(psw_mask);
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
>> +	report_prefix_pop();
>> +}
>> +
>> +static void test_mvcos(void)
>> +{
>> +	uint64_t r3 =3D 64;
>> +	uint8_t *src =3D pagebuf;
>> +	uint8_t *dst =3D pagebuf + PAGE_SIZE;
>> +	/* K bit set, as well as keys */
>> +	register unsigned long oac asm("0") =3D 0xf002f002;
>> +
>> +	report_prefix_push("mvcos");
>> +	expect_pgm_int();
>> +	asm volatile(".machine \"z10\"\n"
>> +		     ".machine \"push\"\n"
>=20
> Shouldn't that be the other way round? first push the current one, then=

> set the new one?

Yes, I interpreted the documentation in the wrong way and it was a PPC
documentation anyway :)

>=20
> Anyway, I've now also checked this patch in the CI:
>=20
> diff a/s390x/Makefile b/s390x/Makefile
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -25,7 +25,7 @@ CFLAGS +=3D -std=3Dgnu99
>  CFLAGS +=3D -ffreestanding
>  CFLAGS +=3D -I $(SRCDIR)/lib -I $(SRCDIR)/lib/s390x -I lib
>  CFLAGS +=3D -O2
> -CFLAGS +=3D -march=3Dz900
> +CFLAGS +=3D -march=3Dz10
>  CFLAGS +=3D -fno-delete-null-pointer-checks
>  LDFLAGS +=3D -nostdlib -Wl,--build-id=3Dnone
>=20
> ... and it also seems to work fine with the TCG there:
>=20
> https://gitlab.com/huth/kvm-unit-tests/-/jobs/281450598
>=20
> So I think you can simply change it in the Makefile instead.

z10 or directly something higher?

>=20
>  Thomas
>=20
>> +		     "mvcos	%[dst],%[src],%[len]\n"
>> +		     ".machine \"pop\"\n"
>> +		     : [dst] "+Q" (*(dst))
>> +		     : [src] "Q" (*(src)), [len] "d" (r3), "d" (oac)
>> +		     : "cc", "memory");
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIAL_OPERATION);
>> +	report_prefix_pop();
>> +}



--x23KFKtO0yhRUGcR4Af4Mi12osHKYCEgS--

--5LvCsyVCQkKunP9t8f7wuow6SOVBqPMgQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl1mHqEACgkQ41TmuOI4
ufjBQw//ZkFD4cuhAPzsha0FALFVJ+wAoDvaQEYq5GG9YGIoWcdfGlXdFT//Zyg5
2kequ4SjnoAL0kp3bNbG7JWOmM1f8BHUx2nsEgyOpgtVW8JjPllRr3Gsf4R9TgS9
R9jScUcxIMHMG+enh/0TPp29kOxt1cmgErEh4eBoGog+qR8ZgMyR8x3mFJNv8RMN
Z+fqA5ot35MCygNykZmcPO4uWZit9z/HGHHh7Ub0WmiFh2H1vnkxjYRuUDUDHkF2
arghq2e+OHPcqqlTAZ01vDR7GP+OUFMp64xJCjAXa4o4/VA28aPFehV0lR7ApJfy
AJFcXvOp5aFuXY2eJE497HqgE0wKmsGR7YvEh4Q9RIDoELTb/QMJOOGksOnX/ehg
Fwp0LokEpSICvU/ReSu3+DV4TSdJwXuwnb5pIW5RjCy2UNGo1SftgD7Aw/0RvYw8
CNmzB+yDxOgvs5b8QGzTfUo34SzdU4QuXxYeiMSoUJV2J4E32jc7S6A9n4xF5ygM
C9qeVJq80l/W1nkYLsqwzBGsRxINZOdupchWzYL0FfoKHfQSVeSq7ZDimWFvB07P
YilodqnfRUcg8b+qzUokHsHYuQfTNLNsfxFbEDD9o9gmqqogqv0bdtP9hwkPZPtT
9VToVCMOMmSmiYjnxJXRIkT+ev0nFoG3a/tETw9mZn4clMKIsFQ=
=TuBi
-----END PGP SIGNATURE-----

--5LvCsyVCQkKunP9t8f7wuow6SOVBqPMgQ--

