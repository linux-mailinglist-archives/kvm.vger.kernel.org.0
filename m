Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B80197C58
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 15:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbgC3NAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 09:00:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2776 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729862AbgC3NAZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 09:00:25 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02UCWVGu128865
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 09:00:23 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3021vtjmah-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 09:00:23 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 30 Mar 2020 14:00:10 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 30 Mar 2020 14:00:06 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02UD0G3P34144424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Mar 2020 13:00:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71F98A4065;
        Mon, 30 Mar 2020 13:00:16 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1ACD1A405C;
        Mon, 30 Mar 2020 13:00:16 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.43.209])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 Mar 2020 13:00:16 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH] s390x: Add stsi 3.2.2 tests
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, cohuck@redhat.com,
        borntraeger@de.ibm.com
References: <20200330122035.19607-1-frankja@linux.ibm.com>
 <860a5575-226a-9b6e-4db0-b1b9dc72b3ed@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 30 Mar 2020 15:00:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <860a5575-226a-9b6e-4db0-b1b9dc72b3ed@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GcsqjnL6B1KjJNv95lqQOP89AkRTqP6T3"
X-TM-AS-GCONF: 00
x-cbid: 20033013-4275-0000-0000-000003B63F05
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20033013-4276-0000-0000-000038CB8B2D
Message-Id: <e1bcfeda-c05d-712b-3c38-4c27188c33bf@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-30_01:2020-03-27,2020-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003300116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GcsqjnL6B1KjJNv95lqQOP89AkRTqP6T3
Content-Type: multipart/mixed; boundary="CVeTfAK8d2adN8uKCD2aOig2i7wZd0B6Z"

--CVeTfAK8d2adN8uKCD2aOig2i7wZd0B6Z
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/30/20 2:51 PM, David Hildenbrand wrote:
> On 30.03.20 14:20, Janosch Frank wrote:
>> Subcode 3.2.2 is handled by KVM/QEMU and should therefore be tested
>> a bit more thorough.
>>
>> In this test we set a custom name and uuid through the QEMU command
>> line. Both parameters will be passed to the guest on a stsi subcode
>> 3.2.2 call and will then be checked.
>>
>> We also compare the total and configured cpu numbers against the smp
>> reported numbers.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  s390x/stsi.c        | 62 ++++++++++++++++++++++++++++++++++++++++++++=
+
>>  s390x/unittests.cfg |  1 +
>>  2 files changed, 63 insertions(+)
>>
>> diff --git a/s390x/stsi.c b/s390x/stsi.c
>> index e9206bca137d2edb..10e588a78cc05186 100644
>> --- a/s390x/stsi.c
>> +++ b/s390x/stsi.c
>> @@ -14,7 +14,28 @@
>>  #include <asm/page.h>
>>  #include <asm/asm-offsets.h>
>>  #include <asm/interrupt.h>
>> +#include <smp.h>
>> =20
>> +struct stsi_322 {
>> +    uint8_t  reserved[31];
>> +    uint8_t  count;
>> +    struct {
>> +        uint8_t  reserved2[4];
>> +        uint16_t total_cpus;
>> +        uint16_t conf_cpus;
>> +        uint16_t standby_cpus;
>> +        uint16_t reserved_cpus;
>> +        uint8_t  name[8];
>> +        uint32_t caf;
>> +        uint8_t  cpi[16];
>> +        uint8_t reserved5[3];
>> +        uint8_t ext_name_encoding;
>> +        uint32_t reserved3;
>> +        uint8_t uuid[16];
>> +    } vm[8];
>> +    uint8_t reserved4[1504];
>> +    uint8_t ext_names[8][256];
>> +};
>>  static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZ=
E * 2)));
>> =20
>>  static void test_specs(void)
>> @@ -76,11 +97,52 @@ static void test_fc(void)
>>  	report(stsi_get_fc(pagebuf) >=3D 2, "query fc >=3D 2");
>>  }
>> =20
>> +static void test_3_2_2(void)
>> +{
>> +	int rc;
>> +	/* EBCDIC for "kvm-unit" */
>> +	uint8_t vm_name[] =3D { 0x92, 0xa5, 0x94, 0x60, 0xa4, 0x95, 0x89, 0x=
a3 };
>> +	uint8_t uuid[] =3D { 0x0f, 0xb8, 0x4a, 0x86, 0x72, 0x7c,
>> +			   0x11, 0xea, 0xbc, 0x55, 0x02, 0x42, 0xac, 0x13,
>> +			   0x00, 0x03 };
>> +	/* EBCDIC for "KVM/" */
>> +	uint8_t cpi_kvm[] =3D { 0xd2, 0xe5, 0xd4, 0x61 };
>> +	const char *vm_name_ext =3D "kvm-unit-test";
>> +	struct stsi_322 *data =3D (void *)pagebuf;
>> +
>> +	/* Is the function code available at all? */
>> +	if (stsi_get_fc(pagebuf) < 3)
>> +		return;
>> +
>> +	report_prefix_push("3.2.2");
>> +	rc =3D stsi(pagebuf, 3, 2, 2);
>> +	report(!rc, "call");
>> +
>> +	/* For now we concentrate on KVM/QEMU */
>> +	if (memcmp(&data->vm[0].cpi, cpi_kvm, sizeof(cpi_kvm)))
>> +		goto out;
>> +
>> +	report(data->vm[0].total_cpus =3D=3D smp_query_num_cpus(), "cpu # to=
tal");
>> +	report(data->vm[0].conf_cpus =3D=3D smp_query_num_cpus(), "cpu # con=
figured");
>> +	report(data->vm[0].standby_cpus =3D=3D 0, "cpu # standby");
>> +	report(data->vm[0].reserved_cpus =3D=3D 0, "cpu # reserved");
>> +	report(!memcmp(data->vm[0].name, vm_name, sizeof(data->vm[0].name)),=

>> +	       "VM name =3D=3D kvm-unit-test");
>> +	report(data->vm[0].ext_name_encoding =3D=3D 2, "ext name encoding UT=
F-8");
>=20
> should you rather do
>=20
> if (data->vm[0].ext_name_encoding =3D=3D 2) {
> 	...
> } else {
> 	report_skip(...);
> }
>=20
> to make this future-proof?
>=20
Do you expect UTF-16 or EBCDIC in the future? :)


--CVeTfAK8d2adN8uKCD2aOig2i7wZd0B6Z--

--GcsqjnL6B1KjJNv95lqQOP89AkRTqP6T3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6B7V8ACgkQ41TmuOI4
ufhxlxAAn8rGm3Oo0C4N3oxopqHvXMTTR5AvW817gZeXnXIzhMFbKeS+7kEo5f5K
gJ6hI3Jlb1FHVfts2NG8HWSsqvlZEFUWMQI8Zu4xhUQHchCsAeMN8TlnkokqztHb
kM3wpVtfQx+akNnAW1IkMBHqO4Aft50bHgUxhKeRXJWBFicbInVqPDZnvjmbtF/f
lWNhfK+GJEyiPPUmuVdfGJPTbjZA/f00hGjQFq9QKJC0V+8HY6u199+h3mFCfrPN
1tP+zk/rUNLU5N11tnW1rVlz34BDzJ198Ybr/0CM5I9MHlraiPjF8HKFXTm4i4rC
SSURG3rRXv5owB2R/r851hbO0Yrwj0Fn+yH7mtFzkYw5DyhXEw72PHzs5fO9609t
R+zNI9Eb2FExtEsFmTcNjIiYBN6j040At40sNQ0AsIgKMreIExUjON9DSyZmMi7X
geMjpxkDzsazA3UxeRfd/IT4OxYXXDDejQN6ySKk2pZi5Vo9Sqh2q2IGRgbSmM36
v1zu49urn4QJyiUKSyiANp29ynYqWfI4Sdqsmni8+NExvNIPn0eDvOLvSzS12QGQ
/sbGGENfaAZ5RonfYTmGCtEePBO0uK6mEFlxTeX/ZUxVXVErkAlrAss8M7qLYvp7
1uUulUauioQTygWL50zKuV+aq8mp8xCbnhX1EqKiryjWsQczVns=
=uxLl
-----END PGP SIGNATURE-----

--GcsqjnL6B1KjJNv95lqQOP89AkRTqP6T3--

