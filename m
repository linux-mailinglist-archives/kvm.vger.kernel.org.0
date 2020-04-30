Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0571BF1AB
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 09:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgD3Hk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 03:40:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11766 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726411AbgD3HkZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 03:40:25 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03U7Z9YP176699;
        Thu, 30 Apr 2020 03:40:24 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30q7qjks7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 03:40:24 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03U7ZfCj179110;
        Thu, 30 Apr 2020 03:40:23 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30q7qjks6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 03:40:23 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03U7Vita020649;
        Thu, 30 Apr 2020 07:40:22 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu723dp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Apr 2020 07:40:22 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03U7eJgw5964246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 07:40:20 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2172A4053;
        Thu, 30 Apr 2020 07:40:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F085A4057;
        Thu, 30 Apr 2020 07:40:19 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.148.130])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 30 Apr 2020 07:40:19 +0000 (GMT)
Subject: Re: [PATCH v3 08/10] s390x: smp: Wait for sigp completion
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com
References: <20200429143518.1360468-1-frankja@linux.ibm.com>
 <20200429143518.1360468-9-frankja@linux.ibm.com>
 <6fb43d45-952e-f66b-a0b2-19d8c3f44cd5@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <68e16d1a-8990-0160-307d-93e870338879@linux.ibm.com>
Date:   Thu, 30 Apr 2020 09:40:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <6fb43d45-952e-f66b-a0b2-19d8c3f44cd5@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3YBtVv1Yu0VOIKkHYA8CbE7MXXW8SoCTJ"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-30_02:2020-04-30,2020-04-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004300061
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3YBtVv1Yu0VOIKkHYA8CbE7MXXW8SoCTJ
Content-Type: multipart/mixed; boundary="mN2sWxTwlxnqnpVlJGEZJMPytCL2FaRXg"

--mN2sWxTwlxnqnpVlJGEZJMPytCL2FaRXg
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/29/20 5:15 PM, David Hildenbrand wrote:
> On 29.04.20 16:35, Janosch Frank wrote:
>> Sigp orders are not necessarily finished when the processor finished
>> the sigp instruction. We need to poll if the order has been finished
>> before we continue.
>>
>> For (re)start and stop we already use sigp sense running and sigp
>> sense loops. But we still lack completion checks for stop and store
>> status, as well as the cpu resets.
>>
>> Let's add them.
>>
>> KVM currently needs a workaround for the stop and store status test,
>> since KVM's SIGP Sense implementation doesn't honor pending SIGPs at
>> it should. Hopefully we can fix that in the future.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  lib/s390x/smp.c |  9 +++++++++
>>  lib/s390x/smp.h |  1 +
>>  s390x/smp.c     | 12 ++++++++++--
>>  3 files changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
>> index 6ef0335..8628a3d 100644
>> --- a/lib/s390x/smp.c
>> +++ b/lib/s390x/smp.c
>> @@ -49,6 +49,14 @@ struct cpu *smp_cpu_from_addr(uint16_t addr)
>>  	return NULL;
>>  }
>> =20
>> +void smp_cpu_wait_for_completion(uint16_t addr)
>> +{
>> +	uint32_t status;
>> +
>> +	/* Loops when cc =3D=3D 2, i.e. when the cpu is busy with a sigp ord=
er */
>> +	sigp_retry(1, SIGP_SENSE, 0, &status);
>> +}
>> +
>>  bool smp_cpu_stopped(uint16_t addr)
>>  {
>>  	uint32_t status;
>> @@ -100,6 +108,7 @@ int smp_cpu_stop_store_status(uint16_t addr)
>> =20
>>  	spin_lock(&lock);
>>  	rc =3D smp_cpu_stop_nolock(addr, true);
>> +	smp_cpu_wait_for_completion(addr);
>>  	spin_unlock(&lock);
>>  	return rc;
>>  }
>> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
>> index ce63a89..a8b98c0 100644
>> --- a/lib/s390x/smp.h
>> +++ b/lib/s390x/smp.h
>> @@ -45,6 +45,7 @@ int smp_cpu_restart(uint16_t addr);
>>  int smp_cpu_start(uint16_t addr, struct psw psw);
>>  int smp_cpu_stop(uint16_t addr);
>>  int smp_cpu_stop_store_status(uint16_t addr);
>> +void smp_cpu_wait_for_completion(uint16_t addr);
>>  int smp_cpu_destroy(uint16_t addr);
>>  int smp_cpu_setup(uint16_t addr, struct psw psw);
>>  void smp_teardown(void);
>> diff --git a/s390x/smp.c b/s390x/smp.c
>> index c7ff0ee..bad2131 100644
>> --- a/s390x/smp.c
>> +++ b/s390x/smp.c
>> @@ -75,7 +75,12 @@ static void test_stop_store_status(void)
>>  	lc->prefix_sa =3D 0;
>>  	lc->grs_sa[15] =3D 0;
>>  	smp_cpu_stop_store_status(1);
>> -	mb();
>> +	/*
>> +	 * This loop is workaround for KVM not reporting cc 2 for SIGP
>> +	 * sense if a stop and store status is pending.
>> +	 */
>> +	while (!lc->prefix_sa)
>> +		mb();
>>  	report(lc->prefix_sa =3D=3D (uint32_t)(uintptr_t)cpu->lowcore, "pref=
ix");
>>  	report(lc->grs_sa[15], "stack");
>>  	report(smp_cpu_stopped(1), "cpu stopped");
>> @@ -85,7 +90,8 @@ static void test_stop_store_status(void)
>>  	lc->prefix_sa =3D 0;
>>  	lc->grs_sa[15] =3D 0;
>>  	smp_cpu_stop_store_status(1);
>> -	mb();
>> +	while (!lc->prefix_sa)
>> +		mb();
>>  	report(lc->prefix_sa =3D=3D (uint32_t)(uintptr_t)cpu->lowcore, "pref=
ix");
>>  	report(lc->grs_sa[15], "stack");
>>  	report_prefix_pop();
>> @@ -215,6 +221,7 @@ static void test_reset_initial(void)
>>  	wait_for_flag();
>> =20
>>  	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
>> +	smp_cpu_wait_for_completion(1);
>=20
> ^ is this really helpful? The next order already properly synchronizes,=
 no?

Well, the next order isn't issued with sigp_retry, so we could actually
get a cc 2 on the store. I need a cpu stopped loop here as well.

>=20
>>  	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
>> =20
>>  	report_prefix_push("clear");
>> @@ -265,6 +272,7 @@ static void test_reset(void)
>>  	smp_cpu_start(1, psw);
>> =20
>>  	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
>> +	smp_cpu_wait_for_completion(1);
>=20
> Isn't this racy for KVM as well?
>=20
> I would have expected a loop until it is actually stopped.

I'd add a loop with a comment, but also keep the wait for completion.

>=20
>>  	report(smp_cpu_stopped(1), "cpu stopped");
>> =20
>>  	set_flag(0);
>>
>=20
>=20



--mN2sWxTwlxnqnpVlJGEZJMPytCL2FaRXg--

--3YBtVv1Yu0VOIKkHYA8CbE7MXXW8SoCTJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6qgOMACgkQ41TmuOI4
ufir8xAAs7VkkNz2fS8Ud70m8cF9BGYx8ku3BbItGZYpkxbzv50HYebsS9FEzzcO
bRMXhaKgLQJ2kyJ3a3Mxk7xZ+nKd9oeT6RLy0TDCV0S+ATD3YlCPdRHV7IWcFuJq
TMmipJrDnbd+fh6d7YZoOLyxecxVFRdDjrip3ZGI18gow8KBYohR6dUWBwQCOPbk
lDH5TjVFgwZPGmU72BDVUGG7ijxGwUCOHC0RaAaH5+zrhsT9pt8DuJ++kkvc95kq
1m68BQw4UjJAx1/ic4vlDfYWj36hQnzuu1Q2XEL6cmVN/Y0rk3NMZapwOxa4cLY4
ShKxYq/Ahj0K3tQDKHG//ze0idj1FjeRb2RVkevh9ZUIBPTmSLJ/n9NINd3InRe1
ak/T9s2cQEr6cKYlQla/XpF98TWModIwfD8E+8P2auzvGBYEB6R/25gdGGvv9e9R
3hhhTRQ67NvUaiM9RTtbB8L5Sx1e6/DQOcq6w6maNr8594aXs2PPKwQ1674mfPvM
Iu0F5+6ScR4cpfPUQsHif/oSYcYlsAPiVnbNaoxfyo6w5rw8N9PmlO7qt+q0uwqo
eywBrA3mRx5oebEBBpXGYgjaisfeWTsL6d4u6vn7XPHibb9EX3qz+wQEz0sbm4NV
j9jHQ3+01oP+2ibmKw3ZYtFpHlNxPtoeC4Emp29DBA0xEBvW/G0=
=bYDM
-----END PGP SIGNATURE-----

--3YBtVv1Yu0VOIKkHYA8CbE7MXXW8SoCTJ--

