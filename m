Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5B07FADFE
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 11:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfKMKE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 05:04:59 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727176AbfKMKE6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 05:04:58 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADA2i4N142313
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 05:04:57 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w8dybv81n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 05:04:56 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 13 Nov 2019 10:04:55 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 13 Nov 2019 10:04:53 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADA4qY350659342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 10:04:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56605A405B;
        Wed, 13 Nov 2019 10:04:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20C2CA4057;
        Wed, 13 Nov 2019 10:04:52 +0000 (GMT)
Received: from dyn-9-152-224-131.boeblingen.de.ibm.com (unknown [9.152.224.131])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Nov 2019 10:04:52 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Load reset psw on diag308
 reset
To:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org
References: <20191111153345.22505-1-frankja@linux.ibm.com>
 <20191111153345.22505-4-frankja@linux.ibm.com>
 <7683adc7-2cd0-1103-d231-8a1577f1e673@redhat.com>
 <a22f8407-efb1-ab0e-eaf6-77d0b853c6de@linux.ibm.com>
 <f3be87c4-135e-dd42-b9b4-aadc0d0c90ca@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 13 Nov 2019 11:04:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <f3be87c4-135e-dd42-b9b4-aadc0d0c90ca@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="R9M4CJ64KgErxY7TzRvS9mPqN6v2vSIBi"
X-TM-AS-GCONF: 00
x-cbid: 19111310-4275-0000-0000-0000037D56DC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111310-4276-0000-0000-00003890B7B1
Message-Id: <1dac633a-65f3-5331-ecd7-6173acffa360@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R9M4CJ64KgErxY7TzRvS9mPqN6v2vSIBi
Content-Type: multipart/mixed; boundary="qidyiw5avUOLYvIyf2HQhNK20D8OrDgVc"

--qidyiw5avUOLYvIyf2HQhNK20D8OrDgVc
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/12/19 5:17 PM, Thomas Huth wrote:
> On 12/11/2019 14.42, Janosch Frank wrote:
>> On 11/12/19 1:09 PM, David Hildenbrand wrote:
>>> On 11.11.19 16:33, Janosch Frank wrote:
>>>> On a diag308 subcode 0 CRs will be reset, so we need a PSW mask
>>>> without DAT. Also we need to set the short psw indication to be
>>>> compliant with the architecture.
>>>>
>>>> Let's therefore define a reset PSW mask with 64 bit addressing and
>>>> short PSW indication that is compliant with architecture and use it.=

>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>  lib/s390x/asm-offsets.c  |  1 +
>>>>  lib/s390x/asm/arch_def.h |  3 ++-
>>>>  s390x/cstart64.S         | 24 +++++++++++++++++-------
>>>>  3 files changed, 20 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
>>>> index 4b213f8..61d2658 100644
>>>> --- a/lib/s390x/asm-offsets.c
>>>> +++ b/lib/s390x/asm-offsets.c
>>>> @@ -58,6 +58,7 @@ int main(void)
>>>>  	OFFSET(GEN_LC_SW_INT_FPRS, lowcore, sw_int_fprs);
>>>>  	OFFSET(GEN_LC_SW_INT_FPC, lowcore, sw_int_fpc);
>>>>  	OFFSET(GEN_LC_SW_INT_CRS, lowcore, sw_int_crs);
>>>> +	OFFSET(GEN_LC_SW_INT_PSW, lowcore, sw_int_psw);
>>>>  	OFFSET(GEN_LC_MCCK_EXT_SA_ADDR, lowcore, mcck_ext_sa_addr);
>>>>  	OFFSET(GEN_LC_FPRS_SA, lowcore, fprs_sa);
>>>>  	OFFSET(GEN_LC_GRS_SA, lowcore, grs_sa);
>>>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>>>> index 07d4e5e..7d25e4f 100644
>>>> --- a/lib/s390x/asm/arch_def.h
>>>> +++ b/lib/s390x/asm/arch_def.h
>>>> @@ -79,7 +79,8 @@ struct lowcore {
>>>>  	uint32_t	sw_int_fpc;			/* 0x0300 */
>>>>  	uint8_t		pad_0x0304[0x0308 - 0x0304];	/* 0x0304 */
>>>>  	uint64_t	sw_int_crs[16];			/* 0x0308 */
>>>> -	uint8_t		pad_0x0310[0x11b0 - 0x0388];	/* 0x0388 */
>>>> +	struct psw	sw_int_psw;			/* 0x0388 */
>>>> +	uint8_t		pad_0x0310[0x11b0 - 0x0390];	/* 0x0390 */
>>>>  	uint64_t	mcck_ext_sa_addr;		/* 0x11b0 */
>>>>  	uint8_t		pad_0x11b8[0x1200 - 0x11b8];	/* 0x11b8 */
>>>>  	uint64_t	fprs_sa[16];			/* 0x1200 */
> [...]
>>> This patch breaks the smp test under TCG (no clue and no time to look=

>>> into the details :) ):
>>
>> I forgot to fixup the offset calculation at the top of the patch once
>> again...
>=20
> Maybe add a
>=20
> _Static_assert(sizeof(struct lowcore) =3D=3D xyz)
>=20
> after the struct definitions, to avoid that this happens again?
>=20
>  Thomas
>=20

How about this?
Or do we want to extend the struct to 8K and test for that?

diff --git i/lib/s390x/asm/arch_def.h w/lib/s390x/asm/arch_def.h
index 5f034a7..cf6e1ca 100644
--- i/lib/s390x/asm/arch_def.h
+++ w/lib/s390x/asm/arch_def.h
@@ -99,6 +99,7 @@ struct lowcore {
        uint8_t         pad_0x1400[0x1800 - 0x1400];    /* 0x1400 */
        uint8_t         pgm_int_tdb[0x1900 - 0x1800];   /* 0x1800 */
 } __attribute__ ((__packed__));
+_Static_assert(sizeof(struct lowcore) =3D=3D 0x1900, "Lowcore size");

 #define PGM_INT_CODE_OPERATION                 0x01
 #define PGM_INT_CODE_PRIVILEGED_OPERATION      0x02


--qidyiw5avUOLYvIyf2HQhNK20D8OrDgVc--

--R9M4CJ64KgErxY7TzRvS9mPqN6v2vSIBi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3L1UMACgkQ41TmuOI4
ufjDOg/9HhG3Go2fGO8oyrGYcYsUtzPpWzIvnNjN+RrC1AJ926/ILPtNSSG/Bs2t
UKyJSW6XrOWb1vGzR2+HdpOpOSO/nyxdnFfRXs9zLhNSpiYKbGRC5RH7d9k0qqSR
iMWv7rxBrIqq4pK1/1yj+mXD68lCx5HLQvdWvPPj6ErjjS9zPePLHWTETN81md8Z
Gas0KppzhVeY0VWeFfFWWFOB/KQFhbS/ubxEI76eXy5t5GYOsq7KWrI3iZxAI0m9
jAkXBeumbRWlFtDR/szqYUomGmwKyNCtjI0vI8WVTu/GATvtMPXtB7NJXNfferJi
dMJCH/1phE6/xOpfsgOsCvWMQdm2wDUYoLI12Cr1PmeBJDuL2ie4tRiy81+sGXek
9hmfCKM2E/R1vusypBPd+ycDpZdvD6fKf3rAIg1wXle9n9FXIiyRw93qOrtS99dZ
HTuFgt52T0OzkJhuCz+mMtt/nSZggtJJd1X4gQClG2KByBq7feqHWG7afRVYa+CO
EFI8L/nVwKTJL6ILOPsd4mLAjmi2urrScGhey5BLcfOpI/vpqUVuf+CJeyfjKKSV
xGAMI2q9/ypdB+GfMK2BKmpMAInZi5d+wmBAZ0k+cb4i9iy/iVswHxvPN94S8HBx
maHKca4XfHntfYH7kGNQXJ74riSjQTAiV/lFXKxlruEw4jcLips=
=ckTA
-----END PGP SIGNATURE-----

--R9M4CJ64KgErxY7TzRvS9mPqN6v2vSIBi--

