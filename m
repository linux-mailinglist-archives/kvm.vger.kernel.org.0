Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC3E9142DFD
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 15:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgATOrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 09:47:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30054 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726901AbgATOrW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jan 2020 09:47:22 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00KElAAo004226
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2020 09:47:21 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xmg7y4qfv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2020 09:47:20 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 20 Jan 2020 14:47:19 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 20 Jan 2020 14:47:17 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00KElGwo44695918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 14:47:16 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94A2F4C058;
        Mon, 20 Jan 2020 14:47:16 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 678914C05A;
        Mon, 20 Jan 2020 14:47:16 +0000 (GMT)
Received: from dyn-9-152-224-123.boeblingen.de.ibm.com (unknown [9.152.224.123])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jan 2020 14:47:16 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 4/9] s390x: smp: Rework cpu start and
 active tracking
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, cohuck@redhat.com
References: <20200117104640.1983-1-frankja@linux.ibm.com>
 <20200117104640.1983-5-frankja@linux.ibm.com>
 <0f9984f0-9768-dba8-5e36-8e667bc05c88@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 20 Jan 2020 15:47:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <0f9984f0-9768-dba8-5e36-8e667bc05c88@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KOdSjoAB2gYn745p196SwsiGtcx1V8EzA"
X-TM-AS-GCONF: 00
x-cbid: 20012014-0008-0000-0000-0000034B1CDC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012014-0009-0000-0000-00004A6B7FC5
Message-Id: <22cbcc9d-1d32-a5c9-4f3f-7892e28bc705@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-20_06:2020-01-20,2020-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 suspectscore=3
 bulkscore=0 spamscore=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001200126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KOdSjoAB2gYn745p196SwsiGtcx1V8EzA
Content-Type: multipart/mixed; boundary="jO04UJUHdqOPRYm7j9vIYaQvpmhDMYfnj"

--jO04UJUHdqOPRYm7j9vIYaQvpmhDMYfnj
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/20/20 1:06 PM, David Hildenbrand wrote:
> On 17.01.20 11:46, Janosch Frank wrote:
>> The architecture specifies that processing sigp orders may be
>> asynchronous, and this is indeed the case on some hypervisors, so we
>> need to wait until the cpu runs before we return from the setup/start
>> function.
>>
>> As there was a lot of duplicate code, a common function for cpu
>> restarts has been introduced.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  lib/s390x/smp.c | 50 ++++++++++++++++++++++++++++--------------------=
-
>>  1 file changed, 29 insertions(+), 21 deletions(-)
>>
>> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
>> index f57f420..84e681d 100644
>> --- a/lib/s390x/smp.c
>> +++ b/lib/s390x/smp.c
>> @@ -104,35 +104,46 @@ int smp_cpu_stop_store_status(uint16_t addr)
>>  	return rc;
>>  }
>> =20
>> +static int smp_cpu_restart_nolock(uint16_t addr, struct psw *psw)
>> +{
>> +	int rc;
>> +	struct cpu *cpu =3D smp_cpu_from_addr(addr);
>=20
> I'd exchange these two (reverse christmas tree)

Christmas is over

>=20
>> +
>> +	if (!cpu)
>> +		return -1;
>=20
> -EINVAL?
>=20
>> +	if (psw) {
>> +		cpu->lowcore->restart_new_psw.mask =3D psw->mask;
>> +		cpu->lowcore->restart_new_psw.addr =3D psw->addr;
>> +	}
>=20
> Does this make sense to have optional? (the other CPU will execute
> random crap if not set, won't it?)

Well, I have restarts in the smp test and I don't want to always pass a
psw if I know what the last restart psw was.
Simply restarting into test_func or wait_for_flag is certainly no problem=
=2E

>=20
>> +	rc =3D sigp(addr, SIGP_RESTART, 0, NULL);
>> +	if (rc)
>> +		return rc;
>> +	/*
>> +	 * The order has been accepted, but the actual restart may not
>> +	 * have been performed yet, so wait until the cpu is running.
>> +	 */
>> +	while (!smp_cpu_running(addr))
>> +		mb();
>=20
> Should you make sure to stop the CPU before issuing the restart?
> Otherwise you will get false positives if it is still running (but
> hasn't processed the RESTART yet)

Good point


--jO04UJUHdqOPRYm7j9vIYaQvpmhDMYfnj--

--KOdSjoAB2gYn745p196SwsiGtcx1V8EzA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4lvXQACgkQ41TmuOI4
ufg5Mw//VX5Z5VodE6UDAiKnftzOTCj1dMaRaxhmxXhk3HhNC7F1px8jIlZIKBgK
DY/FUarnT7fbbKaQ73QWSN7jcHB04Oty8AjkFHIx8AV7pEI5r7e3r7kWql/X5lrr
EienfgpMPTmYqsKJLixIywc9Zim9+tvxqN2FNvym7EuoBJ1I6itSZxRREot8peZu
+kkg5rVnIdZ/8Sur10a+UQ242gkZl41XNBkx5PnISAfqcqQdSq5gvymlT+9JYQPx
/whuHVzZjfj9ox8UbeOkYFKQK83bHAHpL5x6RlqIk9E/NuJS706Z1sDtjCJ/3iB0
Gcgd5AnP7LrnGIxdh5AmjXYvCTUv3kfX+OzyJWcSnRgQSOgHWL8Wh4rJxZ5cnzT4
lchdc363ugm8doYtVgggLoF2+gIpUSrSbNIdHnoWmuNoU82wQxxs1BjVJBfx+zxj
4IffGCvYmmGCTWHrzC/woQJa6+/0ixTEIY5qj+WvkcIBZOIYgACw2r+pYyRURfub
UDZLeUVrLbdrabFLPItfWr645dy75/9t7+3e1TTBRW8P3pgDW17DUrozrGTHha23
kpuhQssETbjeaX30LabN6UG3LGbIrKjvlVtDn1NmnjwTL8Vc1t05hyAg+HA+yeN5
VnsvMwvI3mEhn1+QbwRyb9asBGw/S4J54MzyrM/Yn7H6mg6m7fo=
=XxTY
-----END PGP SIGNATURE-----

--KOdSjoAB2gYn745p196SwsiGtcx1V8EzA--

