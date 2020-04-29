Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958171BD7BD
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 10:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgD2I5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 04:57:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726366AbgD2I5y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 04:57:54 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T8Vvt6012945;
        Wed, 29 Apr 2020 04:57:54 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30me460149-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 04:57:53 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03T8g2Z6046360;
        Wed, 29 Apr 2020 04:57:53 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30me460135-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 04:57:53 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03T8tvox019176;
        Wed, 29 Apr 2020 08:57:51 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 30mcu8dnbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Apr 2020 08:57:50 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03T8ueOf54264150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Apr 2020 08:56:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A45EE4C04E;
        Wed, 29 Apr 2020 08:57:48 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 478B94C050;
        Wed, 29 Apr 2020 08:57:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.84.78])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Apr 2020 08:57:48 +0000 (GMT)
Subject: Re: [PATCH v2 08/10] s390x: smp: Wait for sigp completion
From:   Janosch Frank <frankja@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com
References: <20200423091013.11587-1-frankja@linux.ibm.com>
 <20200423091013.11587-9-frankja@linux.ibm.com>
 <6084d368-86d6-b8fd-d4d3-5e0d72cef590@redhat.com>
 <18b6f022-81b7-6e0d-996d-3abcffceca41@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <be5ed01e-f4f6-6e3a-deb0-8f983e658e0f@linux.ibm.com>
Date:   Wed, 29 Apr 2020 10:57:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <18b6f022-81b7-6e0d-996d-3abcffceca41@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JJmV7n0Z7pSiuoaW1kHEzigvZdLkQGjir"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_02:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JJmV7n0Z7pSiuoaW1kHEzigvZdLkQGjir
Content-Type: multipart/mixed; boundary="vZiWajRVpW8Er2C6gMF6UOrXRgiDzaxys"

--vZiWajRVpW8Er2C6gMF6UOrXRgiDzaxys
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/24/20 1:40 PM, Janosch Frank wrote:
> On 4/24/20 12:11 PM, David Hildenbrand wrote:
>> On 23.04.20 11:10, Janosch Frank wrote:
>>> Sigp orders are not necessarily finished when the processor finished
>>> the sigp instruction. We need to poll if the order has been finished
>>> before we continue.
>>>
>>> For (re)start and stop we already use sigp sense running and sigp
>>> sense loops. But we still lack completion checks for stop and store
>>> status, as well as the cpu resets.
>>>
>>> Let's add them.
>>>
>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>>> ---
>>>  lib/s390x/smp.c | 8 ++++++++
>>>  lib/s390x/smp.h | 1 +
>>>  s390x/smp.c     | 4 ++++
>>>  3 files changed, 13 insertions(+)
>>>
>>> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
>>> index 6ef0335..2555bf4 100644
>>> --- a/lib/s390x/smp.c
>>> +++ b/lib/s390x/smp.c
>>> @@ -154,6 +154,14 @@ int smp_cpu_start(uint16_t addr, struct psw psw)=

>>>  	return rc;
>>>  }
>>> =20
>>> +void smp_cpu_wait_for_completion(uint16_t addr)
>>> +{
>>> +	uint32_t status;
>>> +
>>> +	/* Loops when cc =3D=3D 2, i.e. when the cpu is busy with a sigp or=
der */
>>> +	sigp_retry(1, SIGP_SENSE, 0, &status);
>>> +}
>>> +
>>>  int smp_cpu_destroy(uint16_t addr)
>>>  {
>>>  	struct cpu *cpu;
>>> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
>>> index ce63a89..a8b98c0 100644
>>> --- a/lib/s390x/smp.h
>>> +++ b/lib/s390x/smp.h
>>> @@ -45,6 +45,7 @@ int smp_cpu_restart(uint16_t addr);
>>>  int smp_cpu_start(uint16_t addr, struct psw psw);
>>>  int smp_cpu_stop(uint16_t addr);
>>>  int smp_cpu_stop_store_status(uint16_t addr);
>>> +void smp_cpu_wait_for_completion(uint16_t addr);
>>>  int smp_cpu_destroy(uint16_t addr);
>>>  int smp_cpu_setup(uint16_t addr, struct psw psw);
>>>  void smp_teardown(void);
>>> diff --git a/s390x/smp.c b/s390x/smp.c
>>> index 7462211..48321f4 100644
>>> --- a/s390x/smp.c
>>> +++ b/s390x/smp.c
>>> @@ -75,6 +75,7 @@ static void test_stop_store_status(void)
>>>  	lc->prefix_sa =3D 0;
>>>  	lc->grs_sa[15] =3D 0;
>>>  	smp_cpu_stop_store_status(1);
>>> +	smp_cpu_wait_for_completion(1);
>>>  	mb();
>>>  	report(lc->prefix_sa =3D=3D (uint32_t)(uintptr_t)cpu->lowcore, "pre=
fix");
>>>  	report(lc->grs_sa[15], "stack");
>>> @@ -85,6 +86,7 @@ static void test_stop_store_status(void)
>>>  	lc->prefix_sa =3D 0;
>>>  	lc->grs_sa[15] =3D 0;
>>>  	smp_cpu_stop_store_status(1);
>>
>> Just curious: Would it make sense to add that inside
>> smp_cpu_stop_store_status() instead?
>>
>=20
> I think so, we also wait for stop and start to finish, so why not for
> this order code.
>=20

I've moved the waiting into the smp library and now the prefix check for
stop and store status fails every so often if executed repeatedly.

I've tried making the lc ptr volatile, a print of the prefix before the
report seems to fix the issue, a print after the report still shows the
issue but according to the print both values are the same.

I'm currently at a loss...


--vZiWajRVpW8Er2C6gMF6UOrXRgiDzaxys--

--JJmV7n0Z7pSiuoaW1kHEzigvZdLkQGjir
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6pQYsACgkQ41TmuOI4
ufiF+hAAqxn+XBIYYlEar4mJAvJd796XVHNB5Uqdps58mglD7tGvQrHgmpvq66C6
EJAsQj7ppws7hiIOWTfWJ62ldcYXZez60gWpX1mU8baMLpFPndKg529r0lM/B4XC
6cvmOSuWsX6GdoNTCQ9tveeTOtm0Lh0OohwBhR4/oTv4Fn+m479xtdVAkFK/TsSt
ARpTFLLZmieQOX+ObKsNdkWpUdo2cr6lWtR2PaRAK81/7HbjaPML48K0FBnqiSPW
4fqOoh0qx4sTjngwel4PqRCvzYjiFYofXOxZWa0OFe85fg1Kjwv5WO+kVCanXtiH
mchRYm1dzX1I29tK7lWYTI/sntW/0CQlC6SK8awsg6FHIMWXg1XseYrW4GjGvTPs
AhiDMU9I0/xH1R43EP5nXN1I9DhTa8y7S5TE7eh02OjUDfauNhOKeJqveWQQIUiq
ifNbINv0C1G4WZ1vSwdSrRkD3PuKvFguW00Iftzhyl8doWzun6McsGWsX52AuDP1
BE+eFwOUcU//wdMu9D0DPpVVaqYbJeit+HHNJUAinrs95c855x6ZRKuc86i3msrB
Kj+IgbrtXEcyl9yZCBZHz2MgtMAUrNxoLNyIwoeOfNc950wBPlpkU0TgKH+bQv5c
yozXK8Vo/Bn0eJT+gpAVkIZvJhUuog7DqvVGVHSAVtTCFDsZ0Hs=
=evfa
-----END PGP SIGNATURE-----

--JJmV7n0Z7pSiuoaW1kHEzigvZdLkQGjir--

