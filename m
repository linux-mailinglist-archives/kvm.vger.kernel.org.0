Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5320E1E1FF2
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 12:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731927AbgEZKlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 06:41:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5474 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728259AbgEZKlL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 06:41:11 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04QAXFrv118911;
        Tue, 26 May 2020 06:41:09 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 317hehm7mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 06:41:08 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04QAXPZd119158;
        Tue, 26 May 2020 06:41:08 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 317hehm7m1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 06:41:08 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04QAeMeR005257;
        Tue, 26 May 2020 10:41:06 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 316uf82abk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 May 2020 10:41:06 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04QAf3YB62390658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 May 2020 10:41:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D595611C058;
        Tue, 26 May 2020 10:41:03 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 839F611C06C;
        Tue, 26 May 2020 10:41:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.159.105])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 May 2020 10:41:03 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v7 08/12] s390x: css: stsch, enumeration
 test
To:     Thomas Huth <thuth@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
 <1589818051-20549-9-git-send-email-pmorel@linux.ibm.com>
 <da731645-c408-2e79-4c78-a55b5f0d477b@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <e87b8573-f227-6e28-9e53-3188b0374754@linux.ibm.com>
Date:   Tue, 26 May 2020 12:41:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <da731645-c408-2e79-4c78-a55b5f0d477b@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TtCelGI5WCStgWiYky1TzlW76fe5OEYsB"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-26_01:2020-05-26,2020-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015 adultscore=0
 phishscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005260080
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TtCelGI5WCStgWiYky1TzlW76fe5OEYsB
Content-Type: multipart/mixed; boundary="WQYpljlZjM5NnYVSdR25ZqrkZiPOuGvTg"

--WQYpljlZjM5NnYVSdR25ZqrkZiPOuGvTg
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 5/25/20 9:12 PM, Thomas Huth wrote:
> On 18/05/2020 18.07, Pierre Morel wrote:
>> First step for testing the channel subsystem is to enumerate the css a=
nd
>> retrieve the css devices.
>>
>> This tests the success of STSCH I/O instruction, we do not test the
>> reaction of the VM for an instruction with wrong parameters.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>  s390x/Makefile      |  1 +
>>  s390x/css.c         | 89 ++++++++++++++++++++++++++++++++++++++++++++=
+
>>  s390x/unittests.cfg |  4 ++
>>  3 files changed, 94 insertions(+)
>>  create mode 100644 s390x/css.c
> [...]
>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
>> index 07013b2..a436ec0 100644
>> --- a/s390x/unittests.cfg
>> +++ b/s390x/unittests.cfg
>> @@ -83,3 +83,7 @@ extra_params =3D -m 1G
>>  [sclp-3g]
>>  file =3D sclp.elf
>>  extra_params =3D -m 3G
>> +
>> +[css]
>> +file =3D css.elf
>> +extra_params =3D-device ccw-pong
>=20
> I gave your patch series a try on a normal upstream QEMU (that does not=

> have the ccw-pong device yet), and the css test of course fails there,
> since QEMU bails out with:
>=20
>  -device ccw-pong: 'ccw-pong' is not a valid device model name
>=20
> This is unfortunate - I think we likely have to deal with QEMUs for
> quite a while that do not have this device enabled. Could you maybe add=

> some kind of check to the kvm-unit-tests scripts that only run a test i=
f
> a given device is available, and skip the test otherwise?
>=20
>  Thomas
>=20

Could we for now remove it from unittests.cfg and let Pierre come up
with a solution without delaying this whole series? I expect changes to
run_tests.sh to attract a rather long discussion...


--WQYpljlZjM5NnYVSdR25ZqrkZiPOuGvTg--

--TtCelGI5WCStgWiYky1TzlW76fe5OEYsB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl7M8j8ACgkQ41TmuOI4
ufgTYg//VZvMEphzs5HRSEDYnCOOoc4OGRuAoSIkjjuDxPVsVtJHOBT6X+PVYsBZ
9Vu78UBNYn1nv/j6KuAnYgpJjl4a2dc65GDuNPTk3DPFPPle7W23zNhhI2KALIM9
bvTpv9R6polrON5HyrAVmMIzSePSePruoUuqxINtvp/tufqtuzljMSDQduwnNg/U
0PMLg1pcHdN7QtzOeCURKmdCCgGYBlKos4j5vRgfxR4V73p7Qc0DGMr3DEfzad2Y
UWbKdwQ8eH0IJO52/ZIhbGJf27DjGJHaDk6kwDCNl9keEzC9KhM35Y9UXUiJyxj7
FXax0n2jfZ+FK1eX6isPcd3FSteuG4F0JN8E6e7HkBpeJff24CvH0lY54CLASPTd
xWQ3TSwKhzQAUmfbKAj6z5QZYSpWx+f4zIC44d7cWzMg1J9N6KATJICQcEn8UFeL
B5guGMcza5VhmyqSuebELV+AdIpQQiplAzr69hQugmNOXGJMwZR1r1ZOFgrkxb/b
pn+CfHtCJESLWzYGvfKYnjcvfimC0ZTi8ubZ8FpM4UPDk1IBoSWk0mo46lPl75HA
snFTRnV1BiQ9/SKeL5h71vqoYEy7aALcv/tf9725tGlesurJ3fm+Y40HaG/gtLFU
japZ7sUF2X7wA0/yb3XC79BbwtKI27ddZL7CahETMc7U+45RHnQ=
=Olt8
-----END PGP SIGNATURE-----

--TtCelGI5WCStgWiYky1TzlW76fe5OEYsB--

