Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 293AE13DB03
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 14:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgAPNCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 08:02:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32104 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726730AbgAPNCB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jan 2020 08:02:01 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00GCwDIS138205
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 08:02:00 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xhgs7wj58-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 08:01:59 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 16 Jan 2020 13:01:58 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 16 Jan 2020 13:01:54 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00GD1r1Z55640250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jan 2020 13:01:53 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BE7442067;
        Thu, 16 Jan 2020 13:01:53 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C8FC42059;
        Thu, 16 Jan 2020 13:01:53 +0000 (GMT)
Received: from dyn-9-152-224-123.boeblingen.de.ibm.com (unknown [9.152.224.123])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 16 Jan 2020 13:01:52 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 2/7] s390x: smp: Only use smp_cpu_setup
 once
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, cohuck@redhat.com
References: <20200116120513.2244-1-frankja@linux.ibm.com>
 <20200116120513.2244-3-frankja@linux.ibm.com>
 <9847c5e8-2950-add1-e86b-0d14f0aca0bd@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 16 Jan 2020 14:01:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <9847c5e8-2950-add1-e86b-0d14f0aca0bd@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="As5EVDSvI2DGATtmvewUXZi6Cy0hoLowM"
X-TM-AS-GCONF: 00
x-cbid: 20011613-0020-0000-0000-000003A1319F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011613-0021-0000-0000-000021F8B05C
Message-Id: <7334c5fc-a125-9db3-877a-31c70c91429e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-16_04:2020-01-16,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=3 mlxlogscore=999 impostorscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001160110
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--As5EVDSvI2DGATtmvewUXZi6Cy0hoLowM
Content-Type: multipart/mixed; boundary="vhzBqbftFTjQqqSnMyrjueRgEpghAnWOC"

--vhzBqbftFTjQqqSnMyrjueRgEpghAnWOC
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/16/20 1:18 PM, David Hildenbrand wrote:
> On 16.01.20 13:05, Janosch Frank wrote:
>> Let's stop and start instead of using setup to run a function on a
>> cpu.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  s390x/smp.c | 20 +++++++++++++-------
>>  1 file changed, 13 insertions(+), 7 deletions(-)
>>
>> diff --git a/s390x/smp.c b/s390x/smp.c
>> index 02204fd..d430638 100644
>> --- a/s390x/smp.c
>> +++ b/s390x/smp.c
>> @@ -47,7 +47,7 @@ static void test_start(void)
>>  	psw.mask =3D extract_psw_mask();
>>  	psw.addr =3D (unsigned long)test_func;
>> =20
>> -	smp_cpu_setup(1, psw);
>> +	smp_cpu_start(1, psw);
>>  	wait_for_flag();
>>  	report(1, "start");
>>  }
>> @@ -132,9 +132,8 @@ static void test_ecall(void)
>> =20
>>  	report_prefix_push("ecall");
>>  	testflag =3D 0;
>> -	smp_cpu_destroy(1);
>> =20
>> -	smp_cpu_setup(1, psw);
>> +	smp_cpu_start(1, psw);
>>  	wait_for_flag();
>>  	testflag =3D 0;
>>  	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
>> @@ -167,9 +166,8 @@ static void test_emcall(void)
>> =20
>>  	report_prefix_push("emcall");
>>  	testflag =3D 0;
>> -	smp_cpu_destroy(1);
>> =20
>> -	smp_cpu_setup(1, psw);
>> +	smp_cpu_start(1, psw);
>>  	wait_for_flag();
>>  	testflag =3D 0;
>>  	sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
>> @@ -187,7 +185,7 @@ static void test_reset_initial(void)
>>  	psw.addr =3D (unsigned long)test_func;
>> =20
>>  	report_prefix_push("reset initial");
>> -	smp_cpu_setup(1, psw);
>> +	smp_cpu_start(1, psw);
>> =20
>>  	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
>>  	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
>> @@ -218,7 +216,7 @@ static void test_reset(void)
>>  	psw.addr =3D (unsigned long)test_func;
>> =20
>>  	report_prefix_push("cpu reset");
>> -	smp_cpu_setup(1, psw);
>> +	smp_cpu_start(1, psw);
>> =20
>>  	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
>>  	report(smp_cpu_stopped(1), "cpu stopped");
>> @@ -227,6 +225,7 @@ static void test_reset(void)
>> =20
>>  int main(void)
>>  {
>> +	struct psw psw;
>>  	report_prefix_push("smp");
>> =20
>>  	if (smp_query_num_cpus() =3D=3D 1) {
>> @@ -234,6 +233,12 @@ int main(void)
>>  		goto done;
>>  	}
>> =20
>> +	/* Setting up the cpu to give it a stack and lowcore */
>> +	psw.mask =3D extract_psw_mask();
>> +	psw.addr =3D (unsigned long)cpu_loop;
>> +	smp_cpu_setup(1, psw);
>> +	smp_cpu_stop(1);
>> +
>>  	test_start();
>>  	test_stop();
>>  	test_stop_store_status();
>> @@ -242,6 +247,7 @@ int main(void)
>>  	test_emcall();
>>  	test_reset();
>>  	test_reset_initial();
>> +	smp_cpu_destroy(1);
>> =20
>>  done:
>>  	report_prefix_pop();
>>
>=20
> Acked-by: David Hildenbrand <david@redhat.com>
Thanks!



--vhzBqbftFTjQqqSnMyrjueRgEpghAnWOC--

--As5EVDSvI2DGATtmvewUXZi6Cy0hoLowM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4gXsAACgkQ41TmuOI4
ufgPCQ//WTFS96qyoWLLs2cBlIGaav4M7BcJ2KmFBRk0RIy4Ai4baRrNpMGwze6+
0X0jl7vsy2Y7D74iTTs7hiM+j6iLaTqGJ2RnQSs3XPUWVVpQ6HaycS9rFC9ol6IO
rnDGUsDegutgZm0usZXcrgGYu3X56/G1xU1B/CXv4WMr0+XJBn/5ci2r0SoLm7oD
GV2LLN8KkWoIWQ662fpmtHptLcfJlHcULhczVdiHYwmFKiMrtaApgFjDD08oAnjq
WBglAJngkvCRtvVy6flsKrAZD9XBn6+nxNLy4aJXymEmA/BmtBI22qjlo4NBTJ0Q
XxiX2eq+K26aW8NzYXnEEhHBfv0VKJosjokRuPItVmR5xTlWkoJNOZg+KRwXCToB
5iLXsFdwjJqNfJkWO+mrfAf2NZ5uvb3xBDdusz26PqkktnjK3b8GkmsbeIppfX7H
BzslwpBn8U5DtScBtNf5TxCPlSTV+EoD5kFeEREvRE+N9uhDnPFL3IM/ZguFhY8O
t6qmbiH1g33cD8bbuMIOs/q9PrDIVmGXL9fObwjC9gPr7WkalHfa4slbkjOx0Udh
gqfQ5Y8CgOE6KRfOg4x6gpX/OrOGCB/5xi7ByWJ33/W/sKpCKFyG2WI5ncF2AfP2
WFuGtf7/vIqM8KYLSWewLwNZXgw4zlTrefwa4VVpNBjsQmRWEBk=
=LZ4i
-----END PGP SIGNATURE-----

--As5EVDSvI2DGATtmvewUXZi6Cy0hoLowM--

