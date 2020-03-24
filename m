Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA88190A34
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 11:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgCXKIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 06:08:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41236 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726563AbgCXKIM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 06:08:12 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02OA4ldr022824
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 06:08:11 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ywd2rvcdf-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 06:08:11 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Tue, 24 Mar 2020 10:08:08 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 24 Mar 2020 10:08:05 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02OA74ZA46399840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Mar 2020 10:07:04 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 225F7A405C;
        Tue, 24 Mar 2020 10:08:06 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDE36A4054;
        Tue, 24 Mar 2020 10:08:05 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.9.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Mar 2020 10:08:05 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 01/10] s390x: smp: Test all CRs on initial
 reset
To:     Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com
References: <20200324081251.28810-1-frankja@linux.ibm.com>
 <20200324081251.28810-2-frankja@linux.ibm.com>
 <fb384a50-6c38-b636-ecde-ad220aad950c@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Tue, 24 Mar 2020 11:08:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <fb384a50-6c38-b636-ecde-ad220aad950c@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="of4QRSXK2r8W6dDSKIp6uDMUUCRscT4c3"
X-TM-AS-GCONF: 00
x-cbid: 20032410-4275-0000-0000-000003B206EC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032410-4276-0000-0000-000038C74040
Message-Id: <c1f01ea5-219e-4680-72bd-56f68270bf9b@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_02:2020-03-23,2020-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003240050
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--of4QRSXK2r8W6dDSKIp6uDMUUCRscT4c3
Content-Type: multipart/mixed; boundary="FZAi9xJTASK4KTKHj2k30Z3ojYGXVkRC2"

--FZAi9xJTASK4KTKHj2k30Z3ojYGXVkRC2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/24/20 10:52 AM, Christian Borntraeger wrote:
>=20
>=20
> On 24.03.20 09:12, Janosch Frank wrote:
>> All CRs are set to 0 and CRs 0 and 14 are set to pre-defined values,
>> so we also need to test 1-13 and 15 for 0.
>>
>> And while we're at it, let's also set some values to cr 1, 7 and 13, s=
o
>> we can actually be sure that they will be zeroed.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  s390x/smp.c | 16 +++++++++++++++-
>>  1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/s390x/smp.c b/s390x/smp.c
>> index fa40753524f321d4..8c9b98aabd9e8222 100644
>> --- a/s390x/smp.c
>> +++ b/s390x/smp.c
>> @@ -182,16 +182,28 @@ static void test_emcall(void)
>>  	report_prefix_pop();
>>  }
>>
>> +/* Used to dirty registers of cpu #1 before it is reset */
>> +static void test_func_initial(void)
>> +{
>> +	lctlg(1, 0x42000UL);
>> +	lctlg(7, 0x43000UL);
>> +	lctlg(13, 0x44000UL);
>> +	set_flag(1);
>> +}
>> +
>>  static void test_reset_initial(void)
>>  {
>>  	struct cpu_status *status =3D alloc_pages(0);
>> +	uint64_t nullp[12] =3D {};
>>  	struct psw psw;
>>
>>  	psw.mask =3D extract_psw_mask();
>> -	psw.addr =3D (unsigned long)test_func;
>> +	psw.addr =3D (unsigned long)test_func_initial;
>>
>>  	report_prefix_push("reset initial");
>> +	set_flag(0);
>>  	smp_cpu_start(1, psw);
>> +	wait_for_flag();
>>
>>  	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
>>  	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
>> @@ -202,6 +214,8 @@ static void test_reset_initial(void)
>>  	report(!status->fpc, "fpc");
>>  	report(!status->cputm, "cpu timer");
>>  	report(!status->todpr, "todpr");
>> +	report(!memcmp(&status->crs[1], nullp, sizeof(status->crs[1]) * 12),=
 "cr1-13 =3D=3D 0");
>> +	report(status->crs[15] =3D=3D 0, "cr15 =3D=3D 0");
>>  	report_prefix_pop();
>=20
> Why not add a check for crs[0] =3D=3D 0xe0=20
> and crs[14] =3D 0xc2000000

You mean the checks which are done a few lines below this?
This patch just actually dirties registers which should be set to 0 so
we can really be sure that they have been touched.



--FZAi9xJTASK4KTKHj2k30Z3ojYGXVkRC2--

--of4QRSXK2r8W6dDSKIp6uDMUUCRscT4c3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl553AUACgkQ41TmuOI4
ufjkfQ//eacC+WqPAOArkFUZ11Dk8p30hZowaO2RUacMpQTbOdsJ50pFpiOjGohv
+l3aeF8IagP7fxdgtxqdMSPH56KGFPTylsv4vNv2ONQottRkzPGolg9z9IOsPL06
dYBr06yDN0CHyPQzoAXjavivNDPew57j1/qiT8o21gKioZmpdeggdaG5EO3NuREj
9FTpTkEryr/osMYmG3IJgZ77eoh0YrDO2u7zcfyLMMXdnS6dwmqD6GG2UGAQ0eu+
/O3T9I0dqgo21zj3YmBVET/slrELT1q5WVHQCAWjNqqNDhYflLJH/xj4KY7ypJu5
zrpQV9koeyf9aH2+7qBRX0QqwqgDYuRFmPDKjSy5dO+oXSuN27Y9LYu6kxSU9+mK
5GUP4tJs5DpJz4ya1hP4FTRN0eXnSGrn0YxwJtvABg1+oFSO/JgIitJSuIyHPn3E
hSkfuAnbUazC7FRfmr0jpzAtfNGT+ZWhNNvapw3F7UXWKPf83puDONxM6uX6+gxl
tbdFyw1xhl5L2Cl1MuZIpiU43GELZeks+6uuGgLD1/s9qZROVxA3ESJYFMODz9v6
fhfDzN2y4LlNdJQwkBgciY7QDipc2yTrXBfsDKP351ZCC/mR/Qi874a95TYyJc8e
Cs25WjYOT6dnz77iC75vrBw7Iu/VavDe48iZC5vCNsqka6kcjnI=
=tqfD
-----END PGP SIGNATURE-----

--of4QRSXK2r8W6dDSKIp6uDMUUCRscT4c3--

