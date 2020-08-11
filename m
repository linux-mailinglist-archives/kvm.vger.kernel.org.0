Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2742D24170C
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 09:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgHKHS3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 03:18:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43524 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726397AbgHKHS2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Aug 2020 03:18:28 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07B73RL7146669;
        Tue, 11 Aug 2020 03:18:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=33ntM1UVsEuMr3xPb6tffIzaYUKMnEjjRQerxU41p2I=;
 b=fchuoKaitM4due8QhQglR6/Sa2mtVBeUtkisD7uNDsUWUYf+JGegIMwu9TjzJVpUnyjm
 980v7qkHD12wdyNz5DTXG2b5hrGyt2Iuon5mp0SCHkfzPVwbR8C7ySsUz/pfRmufg8+f
 On8X28vbicWL+9POUDg6ZXLMajzPiho4PlPmNiBCJNhfbRX6lIJxbd3lI7tueNHRsfba
 f7ahIErtF2q2TdRygErklZC2NC3qFs+VYZqKZZETHRTzpuMcBymH2Q5sB7QfNBjeSlU3
 pk9JUqE3vtuJ8kt7LigzvER+qSl6lCratQXSj5XlZ1YWLI07Rg/c/PlQkDu4egZe5v6X mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32sr7vcybr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Aug 2020 03:18:26 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07B753GF152631;
        Tue, 11 Aug 2020 03:18:26 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32sr7vcyb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Aug 2020 03:18:25 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07B7GBmS018044;
        Tue, 11 Aug 2020 07:18:24 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 32skp81vky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Aug 2020 07:18:24 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07B7IKT629622660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Aug 2020 07:18:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2F994C052;
        Tue, 11 Aug 2020 07:18:20 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72A3D4C050;
        Tue, 11 Aug 2020 07:18:20 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.158.66])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Aug 2020 07:18:20 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3] s390x: Ultravisor guest API test
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com
References: <20200810173205.2daaaca1.cohuck@redhat.com>
 <20200810154541.32974-1-frankja@linux.ibm.com>
 <20200810175015.23b7fcf7.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <a72a494c-0f7d-b4aa-1767-72b5ecd57930@linux.ibm.com>
Date:   Tue, 11 Aug 2020 09:18:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200810175015.23b7fcf7.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qiXJYt1g92oZeQ68Il2KdGoXjUxMPN7ZL"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-11_04:2020-08-06,2020-08-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008110041
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qiXJYt1g92oZeQ68Il2KdGoXjUxMPN7ZL
Content-Type: multipart/mixed; boundary="p6CPQPXxsbNrBTO6cJTYtxZ3xfheOBmsk"

--p6CPQPXxsbNrBTO6cJTYtxZ3xfheOBmsk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/10/20 5:50 PM, Cornelia Huck wrote:
> On Mon, 10 Aug 2020 11:45:41 -0400
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> Test the error conditions of guest 2 Ultravisor calls, namely:
>>      * Query Ultravisor information
>>      * Set shared access
>>      * Remove shared access
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> Acked-by: Thomas Huth <thuth@redhat.com>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/asm/uv.h  |  74 ++++++++++++++++++++++
>>  s390x/Makefile      |   1 +
>>  s390x/unittests.cfg |   3 +
>>  s390x/uv-guest.c    | 150 +++++++++++++++++++++++++++++++++++++++++++=
+
>>  4 files changed, 228 insertions(+)
>>  create mode 100644 lib/s390x/asm/uv.h
>>  create mode 100644 s390x/uv-guest.c
>=20
> Acked-by: Cornelia Huck <cohuck@redhat.com>
>=20
Thanks!


--p6CPQPXxsbNrBTO6cJTYtxZ3xfheOBmsk--

--qiXJYt1g92oZeQ68Il2KdGoXjUxMPN7ZL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8yRjwACgkQ41TmuOI4
ufjlsA/9EnCyDusGamiEDzLhF/1EGnBHcYK6HNPKXJIOdbuk1gLJLnHkiosD7sR4
jgzc7tzTss2wXI2YouhjXNrSDaGVMGa6hPrAX+X+IUd23A2hIsJnD4koNAixOtXh
a5RKQ6hICOth83AWJAfl0ZJnH/lZux98DD4vrWigYhIG7SFrTt0V1pl8DAxzUPOP
fCpYkjh6gwTAvGC+XuVh79z6ZkRF7btqmEWIyNzIjiPt2ltUvJT6ZohPewtmYeiV
aGaZEJEw5r9rOFbRxb6mj6E337h9fVWCGaTFnHXf5PbJmaJSLLtLtdP+hSoJtQ9o
Neemd3Sv7mDEQalEc6p4mSaLhgrUtQ5GO+qJXXlwblhIihwKqUtWeGX1o0rffec3
Dt0aN19eesNtGINbI92hX3LQQd2WRjS3x0r1YZGdi3LDuNUPIsd/K9zpQeS4T4QA
JqBd40qjwojzWLPvgzrqThpSz2PblQeXOM9MQzSgQ8Ga6oIqP9HyMeSHOrFm9Q1T
rVGyvjg83XMXW9EmdgyEX+amKfsyXwZXvXdGg/fe6JvLs45dJKVMZFStGXNl2Twn
JwuRZAtr1GDfXdFrlmNa2HZ/WUdhFxOHYEOFRzvtsEwkkTlvpdsTUsFEBJu4CqHo
8H/oQro/eh062oKI5Lm1TAbLr13uZYGM/qA+ZX36P8/FHpJPgbs=
=Juxt
-----END PGP SIGNATURE-----

--qiXJYt1g92oZeQ68Il2KdGoXjUxMPN7ZL--

