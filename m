Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58CC711AB10
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 13:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbfLKMh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 07:37:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64340 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728128AbfLKMh2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 07:37:28 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBCWcDG089197
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 07:37:27 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wtf83n4rj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 07:37:26 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Wed, 11 Dec 2019 12:37:25 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 11 Dec 2019 12:37:22 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xBBCbLpi42009040
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Dec 2019 12:37:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEAF34C040;
        Wed, 11 Dec 2019 12:37:20 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5FA94C052;
        Wed, 11 Dec 2019 12:37:20 +0000 (GMT)
Received: from dyn-9-152-224-149.boeblingen.de.ibm.com (unknown [9.152.224.149])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 11 Dec 2019 12:37:20 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: smp: Setup CRs from cpu 0
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org
References: <20191211115923.9191-1-frankja@linux.ibm.com>
 <20191211115923.9191-3-frankja@linux.ibm.com>
 <75eadbf8-1159-1c3f-12c4-bda518adb2ef@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Wed, 11 Dec 2019 13:37:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <75eadbf8-1159-1c3f-12c4-bda518adb2ef@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aJcP21YyZphwg8MoH3DjiGgQIPxGKKRwr"
X-TM-AS-GCONF: 00
x-cbid: 19121112-0008-0000-0000-0000033FCAB8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19121112-0009-0000-0000-00004A5F00C4
Message-Id: <15cd9f10-a56b-949d-dc0f-2d5aa175222a@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_03:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 suspectscore=3 mlxscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912110107
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aJcP21YyZphwg8MoH3DjiGgQIPxGKKRwr
Content-Type: multipart/mixed; boundary="pvzVCQyYO9xvCrYZFOMFM6cjot25DfdiL"

--pvzVCQyYO9xvCrYZFOMFM6cjot25DfdiL
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 12/11/19 1:32 PM, David Hildenbrand wrote:
> On 11.12.19 12:59, Janosch Frank wrote:
>> Grab the CRs (currently only 0, 1, 7, 13) from cpu 0, so we can
>> bringup the new cpu in DAT mode or set other control options.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/smp.c  | 5 ++++-
>>  s390x/cstart64.S | 2 +-
>>  2 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
>> index e17751a..4dfe7c6 100644
>> --- a/lib/s390x/smp.c
>> +++ b/lib/s390x/smp.c
>> @@ -191,7 +191,10 @@ int smp_cpu_setup(uint16_t addr, struct psw psw)
>>  	cpu->lowcore->sw_int_grs[15] =3D (uint64_t)cpu->stack + (PAGE_SIZE *=
 4);
>>  	lc->restart_new_psw.mask =3D 0x0000000180000000UL;
>>  	lc->restart_new_psw.addr =3D (uint64_t)smp_cpu_setup_state;
>> -	lc->sw_int_crs[0] =3D 0x0000000000040000UL;
>> +	lc->sw_int_crs[0] =3D stctg(0);
>> +	lc->sw_int_crs[1] =3D stctg(1);
>> +	lc->sw_int_crs[7] =3D stctg(7);
>> +	lc->sw_int_crs[13] =3D stctg(13);
>=20
> Wouldn't it be better to also be able to specify the CRs explicitly her=
e?
>=20

Yes, but currently there are no users for something like that and it
would mean that we might need to add more code to support it.

As I said in the cover letter, this is a good first step to allow DAT on
additional cpus without any real setup needed in a test. Later we could
add a function to specify the CRs explicitly.


--pvzVCQyYO9xvCrYZFOMFM6cjot25DfdiL--

--aJcP21YyZphwg8MoH3DjiGgQIPxGKKRwr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl3w4wAACgkQ41TmuOI4
ufgtExAAtrg3hHfo/dUwjv3cRUefXkcDs3Ta1w3MKEozD3r1Yf/9vLwYXMEAdhQA
juA1bnFKrHGIkk06ntPgexRzezWFWc1I4zfm7ha5LvC0OHS97dMAzBsk3sbmZA1a
ffl38Xptm0Y+VqS90tulY1zor+8uhheCnLK59fdYW2KHy/RP/Aa31J9UxvxmxgFx
VJRPNF/b2hRF7icYwFR7dPD7cAbyxFkrzYauQ2YEg6VQBl9sSEXACfacoJNhTQPK
9NQo33gLi2EKRCNrSweGapUk/DycWEmVVIqkv60a5eUiaqz9thDw0iss4wngVZ/4
rFFCfpFbFdA9ns7rGtk0Hn+T4tufzpTCfP6x659p6gB13gRWxGb78tDxCdHmILEP
zDe6kIDgKubOVI2PllxGmKJ7OR8oaG7qIen/uwEOwWvEUeDZNbGaw8HkfR03loNN
VsdJ/5ijBDRW6FTNLZXmq9KirlZ7h7j/XkupfvT9iuz+FMDNu7ZpwPhicpac7cNW
r1xzIoN20f9phZllW5ec4VEB4sv4U88kqLU/xJHWG1gDr+D8D+Qs2/qSSuDa7gCE
XbCfJ1prZb75GobJVz46225xLQEfxOJdmJPzTyOc0vzHsPJtWVqjPLgY0vAfOj1f
liP72Q+DHILMOIsXCBwmCfobFbjbEwYSrv/uHT6tGkbbmBQ69FY=
=7DdQ
-----END PGP SIGNATURE-----

--aJcP21YyZphwg8MoH3DjiGgQIPxGKKRwr--

