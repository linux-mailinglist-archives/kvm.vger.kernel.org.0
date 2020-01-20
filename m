Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4192142E01
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 15:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgATOtg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 09:49:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41646 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726642AbgATOtg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jan 2020 09:49:36 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00KEmcrM101565
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2020 09:49:35 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xkyea29qs-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2020 09:49:34 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 20 Jan 2020 14:49:31 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 20 Jan 2020 14:49:29 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00KEnSqK34668730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 14:49:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB4E24C052;
        Mon, 20 Jan 2020 14:49:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E5C14C044;
        Mon, 20 Jan 2020 14:49:28 +0000 (GMT)
Received: from dyn-9-152-224-123.boeblingen.de.ibm.com (unknown [9.152.224.123])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jan 2020 14:49:28 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 8/9] s390x: smp: Test all CRs on initial
 reset
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, cohuck@redhat.com
References: <20200117104640.1983-1-frankja@linux.ibm.com>
 <20200117104640.1983-9-frankja@linux.ibm.com>
 <15f8b733-1b81-4a1b-22fe-53099878c013@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 20 Jan 2020 15:49:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <15f8b733-1b81-4a1b-22fe-53099878c013@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kTwcvY8zcgtZ2MGIvkJZKQ27tt4L8PObw"
X-TM-AS-GCONF: 00
x-cbid: 20012014-0028-0000-0000-000003D2D13E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012014-0029-0000-0000-000024970346
Message-Id: <d866273e-5108-e634-4e92-93aa66bbed57@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-20_06:2020-01-20,2020-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 suspectscore=3 bulkscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001200126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kTwcvY8zcgtZ2MGIvkJZKQ27tt4L8PObw
Content-Type: multipart/mixed; boundary="ym7yKKQ0hBlb4olf6wf6P4Y14J2n6Ba1F"

--ym7yKKQ0hBlb4olf6wf6P4Y14J2n6Ba1F
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/20/20 1:10 PM, David Hildenbrand wrote:
> On 17.01.20 11:46, Janosch Frank wrote:
>> All CRs are set to 0 and CRs 0 and 14 are set to pre-defined values,
>> so we also need to test 1-13 and 15 for 0.
>>
>> And while we're at it, let's also set some values to cr 1, 7 and 13, s=
o
>> we can actually be sure that they will be zeroed.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/smp.c | 18 +++++++++++++++++-
>>  1 file changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/s390x/smp.c b/s390x/smp.c
>> index c12a3db..1385488 100644
>> --- a/s390x/smp.c
>> +++ b/s390x/smp.c
>> @@ -169,16 +169,30 @@ static void test_emcall(void)
>>  	report_prefix_pop();
>>  }
>> =20
>> +/* Used to dirty registers of cpu #1 before it is reset */
>> +static void test_func_initial(void)
>> +{
>> +	lctlg(1, 0x42000UL);
>> +	lctlg(7, 0x43000UL);
>> +	lctlg(13, 0x44000UL);
>> +	mb();
>> +	testflag =3D 1;
>> +}
>> +
>>  static void test_reset_initial(void)
>>  {
>>  	struct cpu_status *status =3D alloc_pages(0);
>> +	uint64_t nullp[12] =3D {};
>>  	struct psw psw;
>> =20
>>  	psw.mask =3D extract_psw_mask();
>> -	psw.addr =3D (unsigned long)test_func;
>> +	psw.addr =3D (unsigned long)test_func_initial;
>> =20
>>  	report_prefix_push("reset initial");
>> +	testflag =3D 0;
>> +	mb();
>=20
> maybe use a  set_flag() function like
>=20
> mb();
> testflag =3D val;
> mb();
>=20
> and use it everywhere you set the flag? (e.g., in test_func_initial())

Hmm, so basically a set_test_flag() function in a new patch :)
Ok, I'll have a look.

>=20
> Apart from that
>=20
> Reviewed-by: David Hildenbrand <david@redhat.com>
>=20
>>  	smp_cpu_start(1, psw);
>> +	wait_for_flag();
>> =20
>>  	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
>>  	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
>> @@ -189,6 +203,8 @@ static void test_reset_initial(void)
>>  	report(!status->fpc, "fpc");
>>  	report(!status->cputm, "cpu timer");
>>  	report(!status->todpr, "todpr");
>> +	report(!memcmp(&status->crs[1], nullp, sizeof(status->crs[1]) * 12),=
 "cr1-13 =3D=3D 0");
>> +	report(status->crs[15] =3D=3D 0, "cr15 =3D=3D 0");
>>  	report_prefix_pop();
>> =20
>>  	report_prefix_push("initialized");
>>
>=20
>=20



--ym7yKKQ0hBlb4olf6wf6P4Y14J2n6Ba1F--

--kTwcvY8zcgtZ2MGIvkJZKQ27tt4L8PObw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4lvfgACgkQ41TmuOI4
ufjgWRAArhi9PosMeixZOGJEVcZIntB4MDWAFDfOUAngo5m7L9Oagcnt6SF3zCNd
iXqVe7txQliSa///ePPKHtqBeryy0xtynsfYtZjHlmwGb9Epo5qUQY5jLxOCXMOX
j3XwOm1vI4n5n6JA+DSLg0RZNZPvBHNjVKudNSoTGxC417/q80dqQbr2RxCddvkH
SVZFjYZcdkRoggxKmEzoaMjjNN89zUvz0j6gu5diQLQp8M930Kf1vSERiYPIIj2X
s9Vy6PIvhxQGAgxiE19QQeuybMiI0k7q4bmxBx9vQtEIF7pfR8HaRAqoe+Q+BmQ/
kyoeWRs3LQugxvB7Dg3+56nkMpXqmN7DwdaLTKyxtRZHNLqYuYThH8UtCDffq9CM
bJhqUjOZ4bfOYldswrsjFCOZ/Mb/bvwxtcqZCODENZMUjDrXN0Hi5oa15NiT+HMz
dwgOOhZb8lSTbvwTGRA+HNZjM8C6pADNY0MctKn+5QBYj7fF8I5YORoF5SYMVH7j
ioWHA50chnzfE2OKvytmBERgsOH2y+77T1hucpntC/+0O/WdKCim08wfiC+UBTuV
TqK544KX9Gas763TCDsPE0Dr0JPWJdW7//yUcbT0A7kySJ/KPUTz8K6tPVx1+hu7
PbRqYIWBR5my3dKFmLPLtPbBv4/eG6XIUhmVWoIIegNpUFOBwSQ=
=4tKr
-----END PGP SIGNATURE-----

--kTwcvY8zcgtZ2MGIvkJZKQ27tt4L8PObw--

