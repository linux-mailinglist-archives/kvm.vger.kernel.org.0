Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80B7B11AB03
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 13:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbfLKMer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 07:34:47 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44216 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727457AbfLKMer (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 07:34:47 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBCX68P129267
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 07:34:45 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2wt2eu5824-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 07:34:45 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 11 Dec 2019 12:34:44 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 11 Dec 2019 12:34:41 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBBCYer740305136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Dec 2019 12:34:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9D4C4C04E;
        Wed, 11 Dec 2019 12:34:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F40A4C059;
        Wed, 11 Dec 2019 12:34:40 +0000 (GMT)
Received: from dyn-9-152-224-149.boeblingen.de.ibm.com (unknown [9.152.224.149])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 Dec 2019 12:34:40 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 1/2] s390x: smp: Use full PSW to bringup
 new cpu
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org
References: <20191211115923.9191-1-frankja@linux.ibm.com>
 <20191211115923.9191-2-frankja@linux.ibm.com>
 <6433a418-e42f-0cf6-9cd4-bbe9912b901d@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 11 Dec 2019 13:34:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <6433a418-e42f-0cf6-9cd4-bbe9912b901d@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ujKttf4NQOrgsGG6ICtA5kPzYt6ym8iB7"
X-TM-AS-GCONF: 00
x-cbid: 19121112-0016-0000-0000-000002D3CDE3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121112-0017-0000-0000-00003335EC85
Message-Id: <7391e55e-7be5-c69b-a1e5-5e1ddadbc06c@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_03:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 phishscore=0
 suspectscore=3 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912110107
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ujKttf4NQOrgsGG6ICtA5kPzYt6ym8iB7
Content-Type: multipart/mixed; boundary="5aG45P6yevNdbXuRTiw3Mw6IVKRkGzYvd"

--5aG45P6yevNdbXuRTiw3Mw6IVKRkGzYvd
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/11/19 1:31 PM, David Hildenbrand wrote:
> On 11.12.19 12:59, Janosch Frank wrote:
>> Up to now we ignored the psw mask and only used the psw address when
>> bringing up a new cpu. For DAT we need to also load the mask, so let's=

>> do that.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/smp.c  | 2 ++
>>  s390x/cstart64.S | 2 +-
>>  2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
>> index f57f420..e17751a 100644
>> --- a/lib/s390x/smp.c
>> +++ b/lib/s390x/smp.c
>> @@ -185,6 +185,8 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
>>  	cpu->stack =3D (uint64_t *)alloc_pages(2);
>> =20
>>  	/* Start without DAT and any other mask bits. */
>> +	cpu->lowcore->sw_int_psw.mask =3D psw.mask;
>> +	cpu->lowcore->sw_int_psw.addr =3D psw.addr;
>>  	cpu->lowcore->sw_int_grs[14] =3D psw.addr;
>=20
> Not looking at the code (sorry :D ), do we still need this then? (you
> drop the br bewlo)

r14 is the return address, saving/initialising it doesn't sound like a
bad idea to me. If we ever have stack traces, it might show up, or won't =
it?

>=20
>>  	cpu->lowcore->sw_int_grs[15] =3D (uint64_t)cpu->stack + (PAGE_SIZE *=
 4);
>>  	lc->restart_new_psw.mask =3D 0x0000000180000000UL;
>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>> index 86dd4c4..e6a6bdb 100644
>> --- a/s390x/cstart64.S
>> +++ b/s390x/cstart64.S
>> @@ -159,7 +159,7 @@ smp_cpu_setup_state:
>>  	xgr	%r1, %r1
>>  	lmg     %r0, %r15, GEN_LC_SW_INT_GRS
>>  	lctlg   %c0, %c0, GEN_LC_SW_INT_CRS
>> -	br	%r14
>> +	lpswe	GEN_LC_SW_INT_PSW
>> =20
>>  pgm_int:
>>  	SAVE_REGS
>>
>=20
>=20



--5aG45P6yevNdbXuRTiw3Mw6IVKRkGzYvd--

--ujKttf4NQOrgsGG6ICtA5kPzYt6ym8iB7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3w4mAACgkQ41TmuOI4
ufimEA/+ONL3Gbw4hqr4BI7FjgHYyXd6M3fIJPouOuNyWevQzEwqHU7JtQjaOSsi
kiLf+Pp1YWD1+CasGQ4zATFhIkMsas7UTCq8EbQHdaYiybwzFX670mNmU9qQruQk
UWG1M1kLpGGG3Nx8b59hCqoqCd/CPwoNUv16orRSAv8dj8WgKwUetG8bKn5OhH73
csKmKCVe0RDT5XEMU2ri0RS931/EWPZPh0MuRrXPMAsxKM2Qy6zePzxAhiosbgry
7DkrZ95uycoxM88Ypvc8FPxD4bvQI4V0Jzed+5v1KB8mwRNsE7ARhayvSGSjGWLC
ibWbhyY1Zz0x3yVhDys2juI51gtpmi+Trk39d2p5EB7PBSFGbfa1c4F1+JAunDVH
Gacs0dCyVeWrNfNqU8ZeFWGj4FOFK8z7S9TUV+0gLl60S3sVj/5MyHy6Q3lJxvEq
iVpltdaaRPdpJ+Y0PEfTmfhJXuwOV26qjSUX+s0uJK0UXiq8dliObjsD5KbHwiCu
OSdUztiokOlG7vccL/w61g6DE9muk31YZrm8IkgjRLrfT8DwSF832Vu4P8beAtbm
UrA+AeCy9ctKsBwmA+wt4Zi9Layv42I07W12GtN7F+icou0tLZrz12MFiBpStOAp
NasqxMnx+uomiO+egJcMSiXX5g+gU8EaRjMmJTCm2nDZWkRPXtk=
=+AkB
-----END PGP SIGNATURE-----

--ujKttf4NQOrgsGG6ICtA5kPzYt6ym8iB7--

