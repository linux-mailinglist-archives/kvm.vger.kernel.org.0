Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51DE22EC53
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 14:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgG0Mix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 08:38:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55023 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728294AbgG0Miw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jul 2020 08:38:52 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RCWjbD189911;
        Mon, 27 Jul 2020 08:38:51 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32hvhycq3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 08:38:51 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06RCX3Gu191469;
        Mon, 27 Jul 2020 08:38:51 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32hvhycq2m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 08:38:50 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06RCBHKx003109;
        Mon, 27 Jul 2020 12:38:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 32gcy4j77q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jul 2020 12:38:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06RCcjqa31850842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Jul 2020 12:38:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1ADBAE053;
        Mon, 27 Jul 2020 12:38:45 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DD84AE055;
        Mon, 27 Jul 2020 12:38:45 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.24.25])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 Jul 2020 12:38:45 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 2/3] s390x: skrf: Add exception new skey
 test and add test to unittests.cfg
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <20200727095415.494318-1-frankja@linux.ibm.com>
 <20200727095415.494318-3-frankja@linux.ibm.com>
 <b5b0f9d1-075d-edf6-8a30-39cb84f7b42c@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <25826c5e-af31-0f43-5e2b-962887c6272f@linux.ibm.com>
Date:   Mon, 27 Jul 2020 14:38:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <b5b0f9d1-075d-edf6-8a30-39cb84f7b42c@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gOAZKg9Hwrvfhwwwu0mSvp8djceChNGH3"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_08:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 clxscore=1011 priorityscore=1501 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gOAZKg9Hwrvfhwwwu0mSvp8djceChNGH3
Content-Type: multipart/mixed; boundary="t49HWrjI7tGQtGnTqjuSQG1MyQNJpag8U"

--t49HWrjI7tGQtGnTqjuSQG1MyQNJpag8U
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/27/20 2:20 PM, Thomas Huth wrote:
> On 27/07/2020 11.54, Janosch Frank wrote:
>> When an exception new psw with a storage key in its mask is loaded
>> from lowcore, a specification exception is raised. This differs from
>> the behavior when trying to execute skey related instructions, which
>> will result in special operation exceptions.
>>
>> Also let's add the test unittests.cfg so it is run more often.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>  s390x/skrf.c        | 80 ++++++++++++++++++++++++++++++++++++++++++++=
+
>>  s390x/unittests.cfg |  4 +++
>>  2 files changed, 84 insertions(+)
>>
>> diff --git a/s390x/skrf.c b/s390x/skrf.c
>> index 9cae589..fe78711 100644
>> --- a/s390x/skrf.c
>> +++ b/s390x/skrf.c
>> @@ -11,12 +11,16 @@
>>   */
>>  #include <libcflat.h>
>>  #include <asm/asm-offsets.h>
>> +#include <asm-generic/barrier.h>
>>  #include <asm/interrupt.h>
>>  #include <asm/page.h>
>>  #include <asm/facility.h>
>>  #include <asm/mem.h>
>> +#include <asm/sigp.h>
>> +#include <smp.h>
>> =20
>>  static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZ=
E * 2)));
>> +static int testflag =3D 0;
>> =20
>>  static void test_facilities(void)
>>  {
>> @@ -106,6 +110,81 @@ static void test_tprot(void)
>>  	report_prefix_pop();
>>  }
>> =20
>> +static void wait_for_flag(void)
>> +{
>> +	while (!testflag)
>> +		mb();
>> +}
>> +
>> +static void set_flag(int val)
>> +{
>> +	mb();
>> +	testflag =3D val;
>> +	mb();
>> +}
>> +
>> +static void ecall_cleanup(void)
>> +{
>> +	struct lowcore *lc =3D (void *)0x0;
>> +
>> +	lc->ext_new_psw.mask =3D 0x0000000180000000UL;
>> +	lc->sw_int_crs[0] =3D 0x0000000000040000;
>> +
>> +	/*
>> +	 * PGM old contains the ext new PSW, we need to clean it up,
>> +	 * so we don't get a special operation exception on the lpswe
>> +	 * of pgm old.
>> +	 */
>> +	lc->pgm_old_psw.mask =3D 0x0000000180000000UL;
>> +	lc->pgm_old_psw.addr =3D (unsigned long)wait_for_flag;
>=20
> I don't quite understand why you are using wait_for_flag here? Won't
> that function return immediately due to the set_flag(1) below? And if i=
t
> returns, where does the cpu continue to exec code in that case? Wouldn'=
t
> it be better to leave the .addr unchanged, so that the CPU returns to
> the endless loop in smp_cpu_setup_state ?

That's a valid point, will change

>=20
>  Thomas
>=20
>=20
>> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
>> +	set_flag(1);
>> +}
>> +
>> +/* Set a key into the external new psw mask and open external call ma=
sks */
>> +static void ecall_setup(void)
>> +{
>> +	struct lowcore *lc =3D (void *)0x0;
>> +	uint64_t mask;
>> +
>> +	register_pgm_int_func(ecall_cleanup);
>> +	expect_pgm_int();
>> +	/* Put a skey into the ext new psw */
>> +	lc->ext_new_psw.mask =3D 0x00F0000180000000UL;
>> +	/* Open up ext masks */
>> +	ctl_set_bit(0, 13);
>> +	mask =3D extract_psw_mask();
>> +	mask |=3D PSW_MASK_EXT;
>> +	load_psw_mask(mask);
>> +	/* Tell cpu 0 that we're ready */
>> +	set_flag(1);
>> +}
>> +
>> +static void test_exception_ext_new(void)
>> +{
>> +	struct psw psw =3D {
>> +		.mask =3D extract_psw_mask(),
>> +		.addr =3D (unsigned long)ecall_setup
>> +	};
>> +
>> +	report_prefix_push("exception external new");
>> +	if (smp_query_num_cpus() < 2) {
>> +		report_skip("Need second cpu for exception external new test.");
>> +		report_prefix_pop();
>> +		return;
>> +	}
>> +
>> +	smp_cpu_setup(1, psw);
>> +	wait_for_flag();
>> +	set_flag(0);
>> +
>> +	sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
>> +	wait_for_flag();
>> +	smp_cpu_stop(1);
>> +	report_prefix_pop();
>> +}
>> +
>>  int main(void)
>>  {
>>  	report_prefix_push("skrf");
>> @@ -121,6 +200,7 @@ int main(void)
>>  	test_mvcos();
>>  	test_spka();
>>  	test_tprot();
>> +	test_exception_ext_new();
>> =20
>>  done:
>>  	report_prefix_pop();
>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>> index 0f156af..b35269b 100644
>> --- a/s390x/unittests.cfg
>> +++ b/s390x/unittests.cfg
>> @@ -88,3 +88,7 @@ extra_params =3D -m 3G
>>  [css]
>>  file =3D css.elf
>>  extra_params =3D -device virtio-net-ccw
>> +
>> +[skrf]
>> +file =3D skrf.elf
>> +smp =3D 2
>>
>=20



--t49HWrjI7tGQtGnTqjuSQG1MyQNJpag8U--

--gOAZKg9Hwrvfhwwwu0mSvp8djceChNGH3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8eytQACgkQ41TmuOI4
ufjEQBAAmTHOeK2leMi2Tcl84T48SAXBeGEssdPKqEuXc/oZEwjzSWCgt7dwEC27
f3975DUGAgaKR1C1Vaua7cQlIP7InDy4SiAaSzswjFlFNGCHAt5C1V8tytO3prs/
QWJc1uIqMyD9rthwBqHtVJ0zF/CrME2bcKjPZMLb2tNOX3l3u8/kCec/IknEELtH
s3YZEx1OHe4mk5dRz1rqQ7tg6PqeIcdhu3XizI2V2M4ulNsyvd5vJOh5SR+3PT1m
jmXEM8rlZhBp5QNs2SreEiRa3H7PsfKuEVyY0lv6HIrITE1Q8AcaJvk43YR+U4yc
NJMTSvVlAgIufCAUtw2Dp6UgdL+8CsY/892rtmloGRCvw7R4oXvEFOLQUc+hMf48
5vuzOqWgeP9rKLJKR500Zr6iFUPAnpGVGCxt04nafxeIYYljojqkI3rBJKb4R+4v
XAmwUhmpJuZVz6PURkz6hi3rGKFqRK9mHoA8jqtpdbhJUA4NW37VMvUjdcFW1eNS
clOWj4J1PbWjxtRTbcHAQKCs1/9IE1BlI3AfJJYwhgHSOotRmF7W9eM4d8JUuS/P
ICQ0VriM34tsx34v/3mrF2xV86ZoY0rPpxh0g09uhwHsZV3KuRR1xGwauf9y2VOD
6ek6LsEr107rBasnHa3FVkkfVL0PnhEC3PNq1Mtzjkb12dtl+FY=
=JbGT
-----END PGP SIGNATURE-----

--gOAZKg9Hwrvfhwwwu0mSvp8djceChNGH3--

