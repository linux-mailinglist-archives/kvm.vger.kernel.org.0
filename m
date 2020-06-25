Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB21C209A48
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 09:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390184AbgFYHH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 03:07:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21126 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390159AbgFYHHz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 03:07:55 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05P73SEh028321;
        Thu, 25 Jun 2020 03:07:54 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31vbn6swvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 03:07:53 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05P73jZo030229;
        Thu, 25 Jun 2020 03:07:52 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31vbn6swst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 03:07:52 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05P77gYn018596;
        Thu, 25 Jun 2020 07:07:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 31uusjheaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 07:07:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05P77iku34668592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 07:07:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2E2052059;
        Thu, 25 Jun 2020 07:07:44 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.152.44])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 32F0A52057;
        Thu, 25 Jun 2020 07:07:44 +0000 (GMT)
Subject: Re: [PATCH 2/2] docs: kvm: fix rst formatting
To:     Cornelia Huck <cohuck@redhat.com>,
        Collin Walling <walling@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        pbonzini@redhat.com, borntraeger@de.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, thuth@redhat.com
References: <20200624202200.28209-1-walling@linux.ibm.com>
 <20200624202200.28209-3-walling@linux.ibm.com>
 <20200625083423.2ee75bb1.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <22b7d435-480e-ac7f-de4f-b992df6c9ebb@linux.ibm.com>
Date:   Thu, 25 Jun 2020 09:07:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200625083423.2ee75bb1.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="r8PQzRBMtvHxMhJquyO2vgoicXXzFnx6J"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_02:2020-06-25,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 adultscore=0 impostorscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 cotscore=-2147483648 suspectscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250041
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r8PQzRBMtvHxMhJquyO2vgoicXXzFnx6J
Content-Type: multipart/mixed; boundary="zziIhm2JXBOZYIejBv8fhBMMiik0t30Mj"

--zziIhm2JXBOZYIejBv8fhBMMiik0t30Mj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/25/20 8:34 AM, Cornelia Huck wrote:
> On Wed, 24 Jun 2020 16:22:00 -0400
> Collin Walling <walling@linux.ibm.com> wrote:
>=20
>> KVM_CAP_S390_VCPU_RESETS and KVM_CAP_S390_PROTECTED needed
>> just a little bit of rst touch-up
>>
>=20
> Fixes: 7de3f1423ff9 ("KVM: s390: Add new reset vcpu API")
> Fixes: 04ed89dc4aeb ("KVM: s390: protvirt: Add KVM api documentation")

Do we really do that for documentation changes?


>=20
>> Signed-off-by: Collin Walling <walling@linux.ibm.com>
>> ---
>>  Documentation/virt/kvm/api.rst | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/a=
pi.rst
>> index 056608e8f243..2d1572d92616 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -6134,16 +6134,17 @@ in CPUID and only exposes Hyper-V identificati=
on. In this case, guest
>>  thinks it's running on Hyper-V and only use Hyper-V hypercalls.
>> =20
>>  8.22 KVM_CAP_S390_VCPU_RESETS
>> +-----------------------------
>> =20
>> -Architectures: s390
>> +:Architectures: s390
>> =20
>>  This capability indicates that the KVM_S390_NORMAL_RESET and
>>  KVM_S390_CLEAR_RESET ioctls are available.
>> =20
>>  8.23 KVM_CAP_S390_PROTECTED
>> +---------------------------
>> =20
>> -Architecture: s390
>> -
>> +:Architecture: s390
>> =20
>>  This capability indicates that the Ultravisor has been initialized an=
d
>>  KVM can therefore start protected VMs.
>=20
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>=20



--zziIhm2JXBOZYIejBv8fhBMMiik0t30Mj--

--r8PQzRBMtvHxMhJquyO2vgoicXXzFnx6J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl70TT8ACgkQ41TmuOI4
ufhqcw/9E1ANIy0CCWrofIiqj8bQBbjT7uEmPNQ3YhmU9yphY21f+XDLxXKv4Ax5
pgz5eCqwrf7ZFN5aniYnNF6Kac2oPcZK67yLXInTLYlBXP/yUJLWKKpsoc+B5XQx
tnC/87JQ0yLhKIGoUlbiNwc+2+IX49WOOY7SE4CBmrgYUDGl6AISlCBOPbJHYVBK
KaXkBYqlsyKRCy+KiTK9H8BSScMA2hyP48eimV7Ffjvn3BxBJCSGbXL8+lhO2tGf
iTYLSHAPtrRB9UEn3eb8Zaa1DrA+f252JRH7qMxpvvQBo0/fKZwPBNEPCeBwKGrG
uXusk9WJTxK5qMM4An2HyxAWO9i4mGSrbVw/L+NonHuEg+ak5VcGfmjZKXdDyHh9
C4A+FsnRshniFDGP19EwGNvY5MiN1ztMyeXgbb0v1vEIABRiCzpE2eGrPwg5N+R+
W9Zw7aoL9xXrQjiaXzV7P9TonTyv61untUUYOzBhYfTK3dHCczLmRUcwk0cGWALm
x5eBvcfpN/sGlIX502cnYYMFm0bLl68o1WS3flQaid4j9khEumYkVUDeib4JmG1N
mVSMgXu/vbOEswu4TumciLU3GVUV/lKGZW5LfROYsoCAPuypAGoJY7m9aKlsXXUZ
HFIKv44rYECPZJchLWp1ThySD8rS309TaMF3itb6f4bVvVeCSpg=
=jGyM
-----END PGP SIGNATURE-----

--r8PQzRBMtvHxMhJquyO2vgoicXXzFnx6J--

