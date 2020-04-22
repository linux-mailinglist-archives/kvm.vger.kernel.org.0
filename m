Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C451B3AEC
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 11:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgDVJNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 05:13:44 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21752 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726154AbgDVJNo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Apr 2020 05:13:44 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03M92i6X093639
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 05:13:42 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gg28s551-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 05:13:42 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 22 Apr 2020 10:13:05 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 22 Apr 2020 10:13:02 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03M9DbQ967043558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 09:13:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 23CC6A40A7;
        Wed, 22 Apr 2020 09:13:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C00FAA4055;
        Wed, 22 Apr 2020 09:13:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.53.90])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Apr 2020 09:13:36 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 02/10] s390x: Use PSW bits definitions
 in cstart
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
 <1582200043-21760-3-git-send-email-pmorel@linux.ibm.com>
 <aae40a5a-63a6-e802-53bb-9683d03ad57d@linux.ibm.com>
 <1b38a0e5-76cf-c3da-fe8d-7a75bf44f19f@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 22 Apr 2020 11:13:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1b38a0e5-76cf-c3da-fe8d-7a75bf44f19f@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FWFeuPrxzRFAC695Gb7eTjLM0D2d1Njmw"
X-TM-AS-GCONF: 00
x-cbid: 20042209-0008-0000-0000-000003754355
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042209-0009-0000-0000-00004A970BEE
Message-Id: <9fb32067-4175-cbe3-94d9-e877d5dce703@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-22_03:2020-04-21,2020-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=0 spamscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220069
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FWFeuPrxzRFAC695Gb7eTjLM0D2d1Njmw
Content-Type: multipart/mixed; boundary="ceVmlMSVVz2ETwoBtrqNSp7AibVMe6J0l"

--ceVmlMSVVz2ETwoBtrqNSp7AibVMe6J0l
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/22/20 11:06 AM, Pierre Morel wrote:
>=20
>=20
> On 2020-04-22 09:35, Janosch Frank wrote:
>> On 2/20/20 1:00 PM, Pierre Morel wrote:
>>> This patch defines the PSW bits EA/BA used to initialize the PSW mask=
s
>>> for exceptions.
>>>
>>> Since some PSW mask definitions exist already in arch_def.h we add th=
ese
>>> definitions there.
>>> We move all PSW definitions together and protect assembler code again=
st
>>> C syntax.
>>
>> Please fix the issue mentioned below and run *all* tests against your
>> new code to verify you didn't introduce regressions.
>>
>> The rest looks good to me.
>=20
> Thanks,
>=20
>>
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   lib/s390x/asm/arch_def.h | 15 +++++++++++----
>>>   s390x/cstart64.S         | 15 ++++++++-------
>>>   2 files changed, 19 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>>> index 15a4d49..69a8256 100644
>>> --- a/lib/s390x/asm/arch_def.h
>>> +++ b/lib/s390x/asm/arch_def.h
>>> @@ -10,15 +10,21 @@
>>>   #ifndef _ASM_S390X_ARCH_DEF_H_
>>>   #define _ASM_S390X_ARCH_DEF_H_
>>>  =20
>>> +#define PSW_MASK_EXT			0x0100000000000000UL
>>> +#define PSW_MASK_DAT			0x0400000000000000UL
>>> +#define PSW_MASK_PSTATE			0x0001000000000000UL
>>> +#define PSW_MASK_BA			0x0000000080000000UL
>>> +#define PSW_MASK_EA			0x0000000100000000UL
>>> +
>>> +#define PSW_EXCEPTION_MASK (PSW_MASK_EA|PSW_MASK_BA)
>>
>> Could you add a space before and after the | ?
>>
>>> +
>>> +#ifndef __ASSEMBLER__
>>> +
>>>   struct psw {
>>>   	uint64_t	mask;
>>>   	uint64_t	addr;
>>>   };
>>>  =20
>>> -#define PSW_MASK_EXT			0x0100000000000000UL
>>> -#define PSW_MASK_DAT			0x0400000000000000UL
>>> -#define PSW_MASK_PSTATE			0x0001000000000000UL
>>> -
>>>   #define CR0_EXTM_SCLP			0X0000000000000200UL
>>>   #define CR0_EXTM_EXTC			0X0000000000002000UL
>>>   #define CR0_EXTM_EMGC			0X0000000000004000UL
>>> @@ -297,4 +303,5 @@ static inline uint32_t get_prefix(void)
>>>   	return current_prefix;
>>>   }
>>>  =20
>>> +#endif /* not __ASSEMBLER__ */
>>>   #endif
>>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>>> index 45da523..2885a36 100644
>>> --- a/s390x/cstart64.S
>>> +++ b/s390x/cstart64.S
>>> @@ -12,6 +12,7 @@
>>>    */
>>>   #include <asm/asm-offsets.h>
>>>   #include <asm/sigp.h>
>>> +#include <asm/arch_def.h>
>>>  =20
>>>   .section .init
>>>  =20
>>> @@ -214,19 +215,19 @@ svc_int:
>>>  =20
>>>   	.align	8
>>>   reset_psw:
>>> -	.quad	0x0008000180000000
>>> +	.quad	PSW_EXCEPTION_MASK
>>
>> That won't work, this is a short PSW and you're removing the short
>> indication here. Notice the 0008 at the front.
>>
>=20
> Will change and define PSW_MASK_SHORT_PSW and PSW_RESET_MASK like:
>=20
> #define PSW_MASK_SHORT_PSW              0x0008000000000000UL
> ...
>=20
> #define PSW_EXCEPTION_MASK      (PSW_MASK_EA | PSW_MASK_BA)
> #define PSW_RESET_MASK          (PSW_EXCEPTION_MASK | PSW_MASK_SHORT_PS=
W)


Looks good to me, but please send out a new version.



--ceVmlMSVVz2ETwoBtrqNSp7AibVMe6J0l--

--FWFeuPrxzRFAC695Gb7eTjLM0D2d1Njmw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6gCsAACgkQ41TmuOI4
ufj5DA/+LhF0yVqIvMXo+jUcijds3G4oI2vCpypVExcr98D21VnyXEuyElmBpSBH
SAME7WehLfOPluRLf+wyRIB13lkiTnJLIDP+SXhL3x7fWQFHuSgB6kHsChKttNLD
8hino4Zo6a1JoUwJ2mVZnVtl0ALkJP/z6kkLV22hLLY36KyWYsD3yGVsHeTRc1D5
Jn7qufoijbBHIDWnli2n373xonrK8xgGU3/40svBFMBPgrPWomLrSxR35yn6hG6l
7sujsFd3CfNwIkKGeFGUvFKzvj5tvTdoTV/b7XAdmnkRU0YOafzysG6a4nrDn/U5
m0dx/0//OpAx9ibzzfZgp7CUQBHb+Kqwzr8+tyLQZM/I5PjSMcVl+qWMFojKZFJI
8SA/mByT70bwGrvaw3c11GPAzJJ2DKjBRuF1Agi0RY7SkGVDojfSU0L5hnCCC3hb
zHIIz0fj6wtRrmyEBsKSVZkyPWfvvsOibJGxfl3dCDgYjJ9GoItNI+6t0Fwd7j9V
PVi7x8VpvrkbHBR8sAPwHhxe1/FVvkgxJQzV/kzeoNTSvGGnoMmyDdq9GWjQKc8H
0SzC2mtAMcN5S2nTbAlCe0XtsOIFeUBT+EmevrFpXqWyG3krkDO2zKzrLr5g4yS0
ktK+E+ksDNAZABbgJU5btOQ7ifwZpDOdkYxwRk58zmxdmdiJ2dE=
=JTtW
-----END PGP SIGNATURE-----

--FWFeuPrxzRFAC695Gb7eTjLM0D2d1Njmw--

