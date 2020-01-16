Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D6713DDC7
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 15:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgAPOob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 09:44:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726362AbgAPOob (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jan 2020 09:44:31 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00GEgYC2104340
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 09:44:30 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xhy3w6qv0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 09:44:30 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 16 Jan 2020 14:44:28 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 16 Jan 2020 14:44:25 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00GEhZ9237159182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 14:43:35 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D704511CB6F;
        Thu, 16 Jan 2020 14:44:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 765CD11CB71;
        Thu, 16 Jan 2020 14:44:24 +0000 (GMT)
Received: from dyn-9-152-224-123.boeblingen.de.ibm.com (unknown [9.152.224.123])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jan 2020 14:44:24 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 4/7] s390x: smp: Rework cpu start and
 active tracking
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
References: <20200116120513.2244-1-frankja@linux.ibm.com>
 <20200116120513.2244-5-frankja@linux.ibm.com>
 <20200116151453.186cbf94.cohuck@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 16 Jan 2020 15:44:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200116151453.186cbf94.cohuck@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BcebWQbut8qV6eRk3aeIJ62QBU7JePeP1"
X-TM-AS-GCONF: 00
x-cbid: 20011614-4275-0000-0000-000003982082
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011614-4276-0000-0000-000038AC1FB1
Message-Id: <4e4587a6-efba-6f40-306b-3704e53aafc3@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_04:2020-01-16,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=3 clxscore=1015
 malwarescore=0 adultscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001160123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BcebWQbut8qV6eRk3aeIJ62QBU7JePeP1
Content-Type: multipart/mixed; boundary="Kd575vZIqmTQuNyzNIcgrVUnpbkISgq0C"

--Kd575vZIqmTQuNyzNIcgrVUnpbkISgq0C
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/16/20 3:14 PM, Cornelia Huck wrote:
> On Thu, 16 Jan 2020 07:05:10 -0500
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
>> sigp is not synchronous on all hypervisors, so we need to wait until
>=20
> "The architecture specifies that processing sigp orders may be
> asynchronous, and this is indeed the case on some hypervisors, so..."
>=20
> ? (Or is that overkill?)
>=20
>> the cpu runs until we return from the setup/start function.
>=20
> s/until we return/before we return/
>=20
>>
>> As there was a lot of duplicate code a common function for cpu
>=20
> s/code/code,/
>=20
>> restarts has been intropduced.
>=20
> s/intropduced/introduced/
>=20
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/smp.c | 45 ++++++++++++++++++++++++---------------------
>>  1 file changed, 24 insertions(+), 21 deletions(-)
>>
>> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
>> index f57f420..f984a34 100644
>> --- a/lib/s390x/smp.c
>> +++ b/lib/s390x/smp.c
>> @@ -104,35 +104,41 @@ int smp_cpu_stop_store_status(uint16_t addr)
>>  	return rc;
>>  }
>> =20
>> +static int smp_cpu_restart_nolock(uint16_t addr, struct psw *psw)
>> +{
>> +	int rc;
>> +	struct cpu *cpu =3D smp_cpu_from_addr(addr);
>> +
>> +	if (!cpu)
>> +		return -1;
>> +	if (psw) {
>> +		cpu->lowcore->restart_new_psw.mask =3D psw->mask;
>> +		cpu->lowcore->restart_new_psw.addr =3D psw->addr;
>> +	}
>> +	rc =3D sigp(addr, SIGP_RESTART, 0, NULL);
>> +	if (rc)
>> +		return rc;
>> +	while (!smp_cpu_running(addr)) { mb(); }
>=20
> Maybe split this statement? Also, maybe add a comment

/* Wait until the target cpu is running */
?

This is not QEMU with two line ifs taking up 3 lines :)

>=20
> /*
>  * The order has been accepted, but the actual restart may not
>  * have been performed yet, so wait until the cpu is running.
>  */
>=20
> ?
>=20
>> +	cpu->active =3D true;
>> +	return 0;
>> +}
>=20
> The changes look good to me AFAICS.
>=20
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Thanks!



--Kd575vZIqmTQuNyzNIcgrVUnpbkISgq0C--

--BcebWQbut8qV6eRk3aeIJ62QBU7JePeP1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4gdsgACgkQ41TmuOI4
ufj9fg/9HjnsoSw3kffHLA8+LSOCgnQ/j57pz0xtL7gbeerYybSutikwydJ+JuIq
yA8OTqLo9KMsJtksEbG9oV2piq7xPT/h7pyI6Yu7RsAuGvBLz1HjmXIHCJviYT10
8CcMLcBKcRNVxCR5IHnDzODfMnOd3AI6oTHqnccJqgPEO9zWvcKHDH7vj3te7Qzo
OIOOlhGFCWCLsnRg67ecOUHsNSwyiQHp5TQCTQE7piW1uKD3krXytLES90fUAHdr
0l4fY1dUoyb+Zg+FNiJYeEzWEPAtrUy9xbasZES5+ChP0czTeA4oAYRIhg4EFUE8
EgJxIy4alkZwqjgaMbJimoHZn8hgpaH07VkEUOGq8VeZ+IzSCklhC81CI32qFX/Y
0hSdrmKMtSvjodzM0R2BoHbFLnhU4qxfpaRq9jhUPLFi5x9+OW4HRHZbZYLMqmHy
HYkKmVzdDASBl5M4LLSHH9CVay6QnhLwqgfErVRxEk4GLXLcYMlWlQtnaloITONN
cqOkyVQsJyBl9K2g7k6lM1HcPNKLUTbtoX6jJM25K6jtcMihRKwhq9MreHkW9u8I
h90db+ovC8Vt83rXJ2DH3xS3tPoVOPQJwGeDLXrf/y4HLf55xfYQlfWHX46JjTYu
mmls7zuWx+ePtS5rTgqldwTRE7XJw+ai8PmRxfsg4pq7WuFgML8=
=cIDe
-----END PGP SIGNATURE-----

--BcebWQbut8qV6eRk3aeIJ62QBU7JePeP1--

