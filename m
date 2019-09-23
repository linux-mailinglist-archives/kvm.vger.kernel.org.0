Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F6BBB19F
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 11:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407260AbfIWJse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 05:48:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3368 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407253AbfIWJse (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Sep 2019 05:48:34 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8N9lS9J024075
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 05:48:33 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v6tyg9ver-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 05:48:32 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 23 Sep 2019 10:48:30 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 23 Sep 2019 10:48:27 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8N9lxNt33817044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 09:47:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FC86A4055;
        Mon, 23 Sep 2019 09:48:26 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D7B1A4040;
        Mon, 23 Sep 2019 09:48:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.36.175])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 Sep 2019 09:48:26 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH] s390x: Fix stsi unaligned test and add
 selector tests
To:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org
References: <20190920075020.1698-1-frankja@linux.ibm.com>
 <9dd9362d-f8e2-a573-3833-376039dbc570@redhat.com>
 <97e39625-6675-6d01-b1da-dd6d0758c943@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 23 Sep 2019 11:48:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <97e39625-6675-6d01-b1da-dd6d0758c943@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tg1FfXXdLA1URLzSi8EjVp6EkD41og7gw"
X-TM-AS-GCONF: 00
x-cbid: 19092309-4275-0000-0000-00000369FB1C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092309-4276-0000-0000-0000387C6EA9
Message-Id: <b78fcfa7-7c80-b1c2-aecb-e72b6df91dbc@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-23_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909230098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tg1FfXXdLA1URLzSi8EjVp6EkD41og7gw
Content-Type: multipart/mixed; boundary="4AwPXWZOg9PjidYx5fqxLgjTbBMIMHY9o";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, David Hildenbrand <david@redhat.com>,
 kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Message-ID: <b78fcfa7-7c80-b1c2-aecb-e72b6df91dbc@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: Fix stsi unaligned test and add
 selector tests
References: <20190920075020.1698-1-frankja@linux.ibm.com>
 <9dd9362d-f8e2-a573-3833-376039dbc570@redhat.com>
 <97e39625-6675-6d01-b1da-dd6d0758c943@redhat.com>
In-Reply-To: <97e39625-6675-6d01-b1da-dd6d0758c943@redhat.com>

--4AwPXWZOg9PjidYx5fqxLgjTbBMIMHY9o
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/23/19 10:10 AM, Thomas Huth wrote:
> On 20/09/2019 10.10, David Hildenbrand wrote:
>> On 20.09.19 09:50, Janosch Frank wrote:
>>> Alignment and selectors test order is not specified and so, if you
>>> have an unaligned address and invalid selectors it's up to the
>>> hypervisor to decide which error is presented.
>>>
>>> Let's add valid selectors to the unaligned test and add selector
>>> tests.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> ---
>>>  s390x/stsi.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/s390x/stsi.c b/s390x/stsi.c
>>> index 7232cb0..c5bd0a2 100644
>>> --- a/s390x/stsi.c
>>> +++ b/s390x/stsi.c
>>> @@ -35,7 +35,7 @@ static void test_specs(void)
>>> =20
>>>  	report_prefix_push("unaligned");
>>>  	expect_pgm_int();
>>> -	stsi(pagebuf + 42, 1, 0, 0);
>>> +	stsi(pagebuf + 42, 1, 1, 1);
>>>  	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>>>  	report_prefix_pop();
>>> =20
>>> @@ -71,6 +71,8 @@ static inline unsigned long stsi_get_fc(void *addr)=

>>>  static void test_fc(void)
>>>  {
>>>  	report("invalid fc",  stsi(pagebuf, 7, 0, 0) =3D=3D 3);
>=20
> While you're at it, wouldn't it be better to use "(pagebuf, 7, 1, 1)" h=
ere?

The selectors depend on the command, so they need to be checked after
the command. I don't think it would make much sense to change the zeroes
here.

>=20
>  Thomas
>=20
>=20
>>> +	report("invalid selector 1", stsi(pagebuf, 1, 0, 1) =3D=3D 3);
>>> +	report("invalid selector 2", stsi(pagebuf, 1, 1, 0) =3D=3D 3);
>>>  	report("query fc >=3D 2",  stsi_get_fc(pagebuf) >=3D 2);
>>>  }
>>> =20
>>>
>>
>> Acked-by: David Hildenbrand <david@redhat.com>
>>
>=20



--4AwPXWZOg9PjidYx5fqxLgjTbBMIMHY9o--

--tg1FfXXdLA1URLzSi8EjVp6EkD41og7gw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl2IlOkACgkQ41TmuOI4
ufiSDQ//RncgsRfuOc/O6oiD1uw2RDJQt72LnmSluNoxiD5T/4M8BLDhSn7rb21D
0LC9oj2ub2CW1kDzNZAN9t6cvtx5CQ70SuiQcmSv6WkfKZ2C41sK0RvnW3ZA5SAi
bnVeRjQT45ZZlbANClrSG9WJnK1OHIFbHAQfEWMaWxQKgcL2xAlRlZJd4+pN9jIv
Znzavbx+kG84N/90OwpmMqeNrHsgmfS41JrcDraFVc8LuAub1AeIVXj2Ubo8zu4b
wXo6bzVvhQGEg7uN+lP6Td6kSRdYT9DaYj5AF1Jz45sdyXuzPYvGl68XgWLhiH2a
yLDzx36MB2Cya46+pTOMzcSmcqHUmCerLTjd9Jt03wj4edssdk3RdVdGw6+0T2EY
F77JBzzW0KS5H53UDZEYzVv8fwAtbFOQhhKo2a/Y72ldRoeIjpLWiSbv0F4XdG5C
HjxSnet8RpeI+0xfnZFdKpQhQjnAEvrr6DIUXtBMAD9dVICoBlhUHZwHjjJvDQKu
lKDXpVZ9uho4igsA/VtnAiTSAx2I65PNMx3RF5MBUwmfrqi5M/uKs//FLoTg//QT
WIeFCkERn7vKlEjSPa/tSsADXnQhDaq7t1/3D554QTdFFZo0sZUzGGLWf4aYbVqw
/spDG/eh1yPF45HiRwiOp4gHFFtNys8InzXeCWAsxD8RvOrP/60=
=ABlo
-----END PGP SIGNATURE-----

--tg1FfXXdLA1URLzSi8EjVp6EkD41og7gw--

