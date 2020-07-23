Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4C322AEEC
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 14:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgGWMUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 08:20:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50086 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbgGWMUH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jul 2020 08:20:07 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06NCEUj5024548;
        Thu, 23 Jul 2020 08:20:07 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32facj046u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 08:20:06 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06NCEdvj025091;
        Thu, 23 Jul 2020 08:20:05 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32facj045d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 08:20:05 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06NCFLSX016989;
        Thu, 23 Jul 2020 12:20:03 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 32dbmn1ye8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jul 2020 12:20:03 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06NCK00W262486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jul 2020 12:20:00 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E472BA4053;
        Thu, 23 Jul 2020 12:19:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8596DA4040;
        Thu, 23 Jul 2020 12:19:59 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.184.48])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Jul 2020 12:19:59 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 2/3] s390x: skrf: Add exception new skey
 test and add test to unittests.cfg
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
References: <20200717145813.62573-1-frankja@linux.ibm.com>
 <20200717145813.62573-3-frankja@linux.ibm.com>
 <78da93f7-118d-2c1d-582a-092232f36108@redhat.com>
 <032c1103-3020-9deb-a307-70ded3bdb55e@linux.ibm.com>
 <1aa0a21c-90c9-0214-1869-87cc60a46548@redhat.com>
 <acc2a56c-6157-32e1-f305-48bf5a2a285d@linux.ibm.com>
 <20200723141043.7efadd30.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <3be78ac2-6d75-2d4b-850d-e1744fbce9ef@linux.ibm.com>
Date:   Thu, 23 Jul 2020 14:19:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200723141043.7efadd30.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SRqyTEwNZ0CQDdb3VjJyo7I5PZzlbGYKq"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_05:2020-07-23,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 bulkscore=0 mlxlogscore=998
 spamscore=0 priorityscore=1501 clxscore=1015 adultscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SRqyTEwNZ0CQDdb3VjJyo7I5PZzlbGYKq
Content-Type: multipart/mixed; boundary="YVDuruXzugb6H4LdH7oEFFGyMXkIG3sJc"

--YVDuruXzugb6H4LdH7oEFFGyMXkIG3sJc
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/23/20 2:10 PM, Cornelia Huck wrote:
> On Tue, 21 Jul 2020 17:03:10 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> On 7/21/20 4:28 PM, Thomas Huth wrote:
>>> On 21/07/2020 10.52, Janosch Frank wrote: =20
>>>> On 7/21/20 9:28 AM, Thomas Huth wrote: =20
>>>>> On 17/07/2020 16.58, Janosch Frank wrote: =20
>>>>>> If a exception new psw mask contains a key a specification excepti=
on
>>>>>> instead of a special operation exception is presented. =20
>>>>>
>>>>> I have troubles parsing that sentence... could you write that diffe=
rently?
>>>>> (and: "s/a exception/an exception/") =20
>>>>
>>>> How about:
>>>>
>>>> When an exception psw new with a storage key in its mask is loaded f=
rom
>>>> lowcore a specification exception is raised instead of the special
>>>> operation exception that is normally presented when skrf is active. =
=20
>>>
>>> Still a huge beast of a sentence. Could you maybe make two sentences =
out
>>> of it? For example:
>>>
>>> " ... is raised. This differs from the normal case where ..." =20
>>
>> When an exception psw new with a storage key in its mask is loaded fro=
m
>> lowcore a specification exception is raised. This behavior differs fro=
m
>> the one that is presented when trying to execute skey related
>> instructions which will raise special operation exceptions.
>=20
> s/psw new/new psw/ ?

Yeah that would align the naming with the pop one.

>=20
> (And probably a comma after 'lowcore'.)
>=20
> "This differs from the behaviour when trying to execute skey related
> instructions, which will result in special operation exceptions."
>=20
> ?

Sure



--YVDuruXzugb6H4LdH7oEFFGyMXkIG3sJc--

--SRqyTEwNZ0CQDdb3VjJyo7I5PZzlbGYKq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8ZgG8ACgkQ41TmuOI4
ufiEwBAAk028kn/8hdqCRF7fCbsaNujQ4M11Sx40Wa7xaOXXAoos2rC4lyQu0WmE
+J8tzHs8IvCPOezaocRAt8nrGMsUsg5RUHjY1YSlWjgF8JhNjvN7jziUXcf6l320
du0KbK/URXJVdUE5eut4QmCPQc2r+S1/kmUoUlAVLsUlyrxQvIJ40GZ1iQMzzW0y
FX0iQKb+0oxUpjlnS+FN5vsJV24aB0/fMe3WvkAKkLk7GJbAINpjEBuEb9r/18au
/q6Lx4KkcTuhIbeMik1mcfU6f6lwcn5F+KLIiwfGt0L5K9DnRxqFho+0nniG2hLv
+vurNnEwD6SvSDqWBysI5QFDcfzlehqhRptGW8C8wdtgn07nio2eWA7rBg9cXjKg
3E/Tz3crAysin7acndVvWdiY26Ht2LhGOzQXuUoyktnWuEzi3xd0cUYKxFLJwtUm
bOlr0eGVe5Vbw17MTPLiOcvCAznH+1ObyL6EcWHnsF1kaNWT7UKpi/eDvmW+VO4g
Q2p+U/KvOAAKAMKKN1tAGj0QncXMV4cuBc97G5OD5HeX4bxmeUZ6tHUU02iITjoz
xCMgDEooZAIn2UthO1OPLxnBYmmcU8TkxeFRF8Bq/cszbu8jSKXGIEXnjDFPSBOX
9brTpKYqFu2r3ZfMW/TZB7i3KSA5RTp5M3vGLk7lmJbLxi4nf+w=
=04UE
-----END PGP SIGNATURE-----

--SRqyTEwNZ0CQDdb3VjJyo7I5PZzlbGYKq--

