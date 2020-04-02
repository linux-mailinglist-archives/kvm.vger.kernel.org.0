Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 416BD19C2E0
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 15:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388648AbgDBNmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 09:42:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62542 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388274AbgDBNmD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 09:42:03 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 032DYS58062577
        for <kvm@vger.kernel.org>; Thu, 2 Apr 2020 09:42:02 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 304gste438-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 09:42:01 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 2 Apr 2020 14:41:44 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 2 Apr 2020 14:41:41 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 032Dfuv662390304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Apr 2020 13:41:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 215DAA4060;
        Thu,  2 Apr 2020 13:41:56 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA91EA405C;
        Thu,  2 Apr 2020 13:41:55 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.69.93])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Apr 2020 13:41:55 +0000 (GMT)
Subject: Re: [kvm-unit-tests v2] s390x/smp: add minimal test for sigp sense
 running status
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20200402110250.63677-1-borntraeger@de.ibm.com>
 <b1766baa-ca91-b1b4-c9e4-653ae4257cea@linux.ibm.com>
 <7ad39b82-171c-5ffa-a10c-1dd04358f6c2@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 2 Apr 2020 15:41:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <7ad39b82-171c-5ffa-a10c-1dd04358f6c2@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZPyjXYNuA8Depo7uBVC9IkvatqgI5sdcx"
X-TM-AS-GCONF: 00
x-cbid: 20040213-4275-0000-0000-000003B83E27
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040213-4276-0000-0000-000038CD9461
Message-Id: <c252805d-a396-bebe-a4c1-77521adf598f@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-02_04:2020-03-31,2020-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 phishscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020119
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZPyjXYNuA8Depo7uBVC9IkvatqgI5sdcx
Content-Type: multipart/mixed; boundary="5t7AQXODaSQx25ei7Z6lwBYtdIcZ8gbHq"

--5t7AQXODaSQx25ei7Z6lwBYtdIcZ8gbHq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/2/20 2:29 PM, Christian Borntraeger wrote:
>=20
>=20
> On 02.04.20 14:18, Janosch Frank wrote:
>> On 4/2/20 1:02 PM, Christian Borntraeger wrote:
>>> make sure that sigp sense running status returns a sane value for
>>
>> s/m/M/
>>
>>> stopped CPUs. To avoid potential races with the stop being processed =
we
>>> wait until sense running status is first 0.
>>
>> ENOPARSE "...is first 0?"
>=20
> Yes,  what about "....smp_sense_running_status returns false." ?

sure, or "returns 0"
"is first 0" just doesn't parse :)

>=20
>>
>>>
>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>> ---
>>>  lib/s390x/smp.c |  2 +-
>>>  lib/s390x/smp.h |  2 +-
>>>  s390x/smp.c     | 13 +++++++++++++
>>>  3 files changed, 15 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
>>> index 5ed8b7b..492cb05 100644
>>> --- a/lib/s390x/smp.c
>>> +++ b/lib/s390x/smp.c
>>> @@ -58,7 +58,7 @@ bool smp_cpu_stopped(uint16_t addr)
>>>  	return !!(status & (SIGP_STATUS_CHECK_STOP|SIGP_STATUS_STOPPED));
>>>  }
>>> =20
>>> -bool smp_cpu_running(uint16_t addr)
>>> +bool smp_sense_running_status(uint16_t addr)
>>>  {
>>>  	if (sigp(addr, SIGP_SENSE_RUNNING, 0, NULL) !=3D SIGP_CC_STATUS_STO=
RED)
>>>  		return true;
>>> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
>>> index a8b98c0..639ec92 100644
>>> --- a/lib/s390x/smp.h
>>> +++ b/lib/s390x/smp.h
>>> @@ -40,7 +40,7 @@ struct cpu_status {
>>>  int smp_query_num_cpus(void);
>>>  struct cpu *smp_cpu_from_addr(uint16_t addr);
>>>  bool smp_cpu_stopped(uint16_t addr);
>>> -bool smp_cpu_running(uint16_t addr);
>>> +bool smp_sense_running_status(uint16_t addr);
>>
>> That's completely unrelated to the test
>=20
> Right but this name seems to better reflect what the function does. Bec=
ause this is not
> the oppositite of cpu_stopped.

I'm pondering if we want to split that out.

>>
>>>  int smp_cpu_restart(uint16_t addr);
>>>  int smp_cpu_start(uint16_t addr, struct psw psw);
>>>  int smp_cpu_stop(uint16_t addr);
>>> diff --git a/s390x/smp.c b/s390x/smp.c
>>> index 79cdc1f..b4b1ff2 100644
>>> --- a/s390x/smp.c
>>> +++ b/s390x/smp.c
>>> @@ -210,6 +210,18 @@ static void test_emcall(void)
>>>  	report_prefix_pop();
>>>  }
>>> =20
>>> +static void test_sense_running(void)
>>> +{
>>> +	report_prefix_push("sense_running");
>>> +	/* make sure CPU is stopped */
>>> +	smp_cpu_stop(1);
>>> +	/* wait for stop to succeed. */
>>> +	while(smp_sense_running_status(1));
>>> +	report(!smp_sense_running_status(1), "CPU1 sense claims not running=
");
>>
>> That's basically true anyway after the loop, no?
>=20
> Yes, but  you get no "positive" message in the more verbose output vari=
ants
> without a report statement.

report(true, "CPU1 sense claims not running");
That's also possible, but I leave that up to you.

>=20
>>
>>> +	report_prefix_pop();
>>> +}
>>> +
>>> +
>>>  /* Used to dirty registers of cpu #1 before it is reset */
>>>  static void test_func_initial(void)
>>>  {
>>> @@ -319,6 +331,7 @@ int main(void)
>>>  	test_store_status();
>>>  	test_ecall();
>>>  	test_emcall();
>>> +	test_sense_running();
>>>  	test_reset();
>>>  	test_reset_initial();
>>>  	smp_cpu_destroy(1);
>>>
>>
>>



--5t7AQXODaSQx25ei7Z6lwBYtdIcZ8gbHq--

--ZPyjXYNuA8Depo7uBVC9IkvatqgI5sdcx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6F66MACgkQ41TmuOI4
ufjo3hAAkXwtVJaFtoJNxtOc4b7yBOpzXwTSfEH732UQPAt2fdWzgbbPGbSb/pnY
vPJ6NDwJaYYcEVRuhD/yhApgk3ck9TaEnQwovzjb5BBAQcf1G8Sw0vGPIdkiWPkM
jTWtfEBdyWlqvnXoyv3BmBXbAL6f99qbYodI/LEVUBjK8cY+yDj5B54K6NLkoL9I
JUw+tndKBrYjnZG9giKm4sjKk57iB/u9Z5SGWRby7hnAXXjBGGYF0UKHEHCpj8zg
OHEyMgF/xTNLQA/E2gr086AQKOJMTP5tmL+jpJe8HmzrY1rkrNPX2wso8oFhFkc3
2sPR33X7zJG0oL+E2sbf51ul1IJx3RpifyBKgA/H7AnmJ6nmqjeKdrfc3h4jFpDk
gMJn5MYnMp3neBLdUj2romXuBLKuVVcn2GM9Z2C50TPNkwpVCYSLbgVqhQKvxKXB
KJLI4pz/1XNnv1i5E5Br6CKPezAuH9klmnb/GI1ANToz+pBHStYQp7eT1trNMuJ1
j+h9YXSCBM/ze5kwMhVLWdOO2zC8LHklqObgbyESG4dUebz0051TpPq4DKYbBMZI
bJWI4wL9+DXwt4VCPij4fZLwG3+va/yNWFBNZcicT25qd6O3ETANsJoCMLnBto90
FoW/EsiTz/Do+PoMcTVCkBQWzW2YYWkEik7cMefTA7wbqSbz32I=
=fYi8
-----END PGP SIGNATURE-----

--ZPyjXYNuA8Depo7uBVC9IkvatqgI5sdcx--

