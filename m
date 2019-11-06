Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C2EF0F5F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 07:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbfKFG6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 01:58:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48854 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726772AbfKFG6r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Nov 2019 01:58:47 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA66vUWR121895
        for <kvm@vger.kernel.org>; Wed, 6 Nov 2019 01:58:46 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w3csxn09w-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 01:58:45 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 6 Nov 2019 06:58:39 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 6 Nov 2019 06:58:37 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA66wa6951839022
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Nov 2019 06:58:36 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F93242045;
        Wed,  6 Nov 2019 06:58:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F9DA42047;
        Wed,  6 Nov 2019 06:58:35 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.24.181])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Nov 2019 06:58:35 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: Remove DAT and add short
 indication psw bits on diag308 reset
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com
References: <20191105162828.2490-1-frankja@linux.ibm.com>
 <20191105162828.2490-3-frankja@linux.ibm.com>
 <15a9d438-d906-dcc6-0bda-8c6b049c946d@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 6 Nov 2019 07:58:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <15a9d438-d906-dcc6-0bda-8c6b049c946d@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qs1tlpGuylshWuc6dJwZ6ZcL6csuQxYAJ"
X-TM-AS-GCONF: 00
x-cbid: 19110606-0020-0000-0000-00000382F910
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110606-0021-0000-0000-000021D925E4
Message-Id: <5147b7e8-0531-30a0-a25b-c36ba0dc9b30@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-06_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911060072
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qs1tlpGuylshWuc6dJwZ6ZcL6csuQxYAJ
Content-Type: multipart/mixed; boundary="u0Qzj72axJ1BERBQZEffiS220yOqOQLst"

--u0Qzj72axJ1BERBQZEffiS220yOqOQLst
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/5/19 8:53 PM, David Hildenbrand wrote:
> On 05.11.19 17:28, Janosch Frank wrote:
>=20
> In the subject "Disable" vs. "Remove" ?
>=20
>> On a diag308 subcode 0 CRs will be reset, so we need to mask of PSW
>> DAT indication until we restore our CRs.
>>
>> Also we need to set the short psw indication to be compliant with the
>> architecture.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   lib/s390x/asm-offsets.c  |  1 +
>>   lib/s390x/asm/arch_def.h |  3 ++-
>>   s390x/cstart64.S         | 20 ++++++++++++++------
>>   3 files changed, 17 insertions(+), 7 deletions(-)
>>
>> diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
>> index 4b213f8..61d2658 100644
>> --- a/lib/s390x/asm-offsets.c
>> +++ b/lib/s390x/asm-offsets.c
>> @@ -58,6 +58,7 @@ int main(void)
>>   	OFFSET(GEN_LC_SW_INT_FPRS, lowcore, sw_int_fprs);
>>   	OFFSET(GEN_LC_SW_INT_FPC, lowcore, sw_int_fpc);
>>   	OFFSET(GEN_LC_SW_INT_CRS, lowcore, sw_int_crs);
>> +	OFFSET(GEN_LC_SW_INT_PSW, lowcore, sw_int_psw);
>>   	OFFSET(GEN_LC_MCCK_EXT_SA_ADDR, lowcore, mcck_ext_sa_addr);
>>   	OFFSET(GEN_LC_FPRS_SA, lowcore, fprs_sa);
>>   	OFFSET(GEN_LC_GRS_SA, lowcore, grs_sa);
>> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
>> index 07d4e5e..7d25e4f 100644
>> --- a/lib/s390x/asm/arch_def.h
>> +++ b/lib/s390x/asm/arch_def.h
>> @@ -79,7 +79,8 @@ struct lowcore {
>>   	uint32_t	sw_int_fpc;			/* 0x0300 */
>>   	uint8_t		pad_0x0304[0x0308 - 0x0304];	/* 0x0304 */
>>   	uint64_t	sw_int_crs[16];			/* 0x0308 */
>> -	uint8_t		pad_0x0310[0x11b0 - 0x0388];	/* 0x0388 */
>> +	struct psw	sw_int_psw;			/* 0x0388 */
>> +	uint8_t		pad_0x0310[0x11b0 - 0x0390];	/* 0x0390 */
>>   	uint64_t	mcck_ext_sa_addr;		/* 0x11b0 */
>>   	uint8_t		pad_0x11b8[0x1200 - 0x11b8];	/* 0x11b8 */
>>   	uint64_t	fprs_sa[16];			/* 0x1200 */
>> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
>> index 0455591..2e0dcf5 100644
>> --- a/s390x/cstart64.S
>> +++ b/s390x/cstart64.S
>> @@ -129,8 +129,15 @@ memsetxc:
>>   .globl diag308_load_reset
>>   diag308_load_reset:
>>   	SAVE_REGS
>> -	/* Save the first PSW word to the IPL PSW */
>> +	/* Backup current PSW */
>=20
> /*
>   * Backup the current PSW MASK, as we have to restore it on
>   * success.
>   */
>=20
>>   	epsw	%r0, %r1
>> +	st	%r0, GEN_LC_SW_INT_PSW
>> +	st	%r1, GEN_LC_SW_INT_PSW + 4
>=20
> I was confused at first, but then I realized that you really only store=
=20
> the PSW mask here and not also the PSW address ...
>=20
>=20
>> +	/* Disable DAT as the CRs will be reset too */
>> +	nilh	%r0, 0xfbff
>> +	/* Add psw bit 12 to indicate short psw */
>> +	oilh	%r0, 0x0008
>=20
> Why care about the old PSW mask here at all? Wouldn't it be easier to=20
> just construct a new PSW mask from scratch? (64bit, PSW bit 12 set ...)=

>=20
> Save it somewhere and just load it directly from memory.

Sounds like a good idea, will do

>=20
>> +	/* Save the first PSW word to the IPL PSW */
>>   	st	%r0, 0
>>   	/* Store the address and the bit for 31 bit addressing */
>>   	larl    %r0, 0f
>> @@ -142,12 +149,13 @@ diag308_load_reset:
>>   	xgr	%r2, %r2
>>   	br	%r14
>>   	/* Success path */
>> -	/* We lost cr0 due to the reset */
>> -0:	larl	%r1, initial_cr0
>> -	lctlg	%c0, %c0, 0(%r1)
>> -	RESTORE_REGS
>> +	/* Switch to z/Architecture mode and 64-bit */
>> +0:	RESTORE_REGS
>>   	lhi	%r2, 1
>> -	br	%r14
>> +	larl	%r0, 1f
>> +	stg	%r0, GEN_LC_SW_INT_PSW + 8
>> +	lpswe	GEN_LC_SW_INT_PSW
>> +1:	br	%r14
>>  =20
>>   .globl smp_cpu_setup_state
>>   smp_cpu_setup_state:
>>
>=20
>=20



--u0Qzj72axJ1BERBQZEffiS220yOqOQLst--

--qs1tlpGuylshWuc6dJwZ6ZcL6csuQxYAJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3CbxsACgkQ41TmuOI4
ufiIOQ/+Pw7kbOK8m2UiEUv4nkxxgWWvrZZi65Go1e0FtziUHs05sVD8vUUYc4iw
YwqjJOs2chOD1fRVTP7meBwFNCiYMWn7sYKVYW0irp1Uldz3ffNyNfBCozD2JGco
ix+pUfL5Mv7kRL9z+kFhyzLa1iam9G/6keDQZDtqn3O8yPSefk5OC33+ZEVlFmTh
DAjNjWasMaiz38JSBI8WwJ/P10co2s0FOUa0E9+bCf2iBPeItBkXLTdVfMX7R+Rc
d6CdY8EkM7OVd+Qc7TB8PBJNn0oIyjZeXM3gNkd6NkINjxuSlL89YWEc06vNrRHt
w6CEThkjMSj6p6auk0JfGg0ZLdx5DBKSV6d4kMxD/AegKgWxUKdhOtGYB0m2FOQu
hjQEMDIsPmtEyndaPEzLaoXXJZtm6inwkBzi5LqRFtQWQUlCWCV86RstZRyte+n2
vZSKWHLDXpLXNL7ZJTVRhURv0E9IE8UbfFI8JAyhGBN0bUt3dfRUAaFqgsqapMNd
mKbVwGQHjOtVaDt+ZPKQSwUu+vQDAyIINTW8164FlLxvwdbViJUrCoEgdE3+SerD
4rGqlNqUMIPPA0udrs0VMgfsyVII3z4zuGfopQp8QIeErHDfe63QGVxFOWHqx6zE
c+4dfw6iM69g7M81p9QSVEkCSRy4YoxzrVwgxZHOg4krSWbOCnQ=
=h+Id
-----END PGP SIGNATURE-----

--qs1tlpGuylshWuc6dJwZ6ZcL6csuQxYAJ--

