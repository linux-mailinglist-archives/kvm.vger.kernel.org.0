Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75734B8CF8
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 10:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437670AbfITIbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Sep 2019 04:31:53 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38970 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405265AbfITIbx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Sep 2019 04:31:53 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8K8RKmG101493
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 04:31:52 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v4t3ytk0a-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 20 Sep 2019 04:31:52 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 20 Sep 2019 09:31:50 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 20 Sep 2019 09:31:48 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8K8Vlwt46858712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Sep 2019 08:31:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44689A405C;
        Fri, 20 Sep 2019 08:31:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB66AA405B;
        Fri, 20 Sep 2019 08:31:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.165.207])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 20 Sep 2019 08:31:46 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 3/6] s390x: Add linemode buffer to fix
 newline on every print
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com
References: <20190920080356.1948-1-frankja@linux.ibm.com>
 <20190920080356.1948-4-frankja@linux.ibm.com>
 <43bb9ff6-4233-3f6f-8cdb-3a00d1662d4d@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 20 Sep 2019 10:31:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <43bb9ff6-4233-3f6f-8cdb-3a00d1662d4d@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="L0YwyiZHqzRG8dvykBGYGIpfi38Dtzrre"
X-TM-AS-GCONF: 00
x-cbid: 19092008-0012-0000-0000-0000034E75D8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092008-0013-0000-0000-00002188FA88
Message-Id: <b2730c42-27a7-1fff-0687-98b587516481@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-20_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909200081
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L0YwyiZHqzRG8dvykBGYGIpfi38Dtzrre
Content-Type: multipart/mixed; boundary="QIRclMaWNmfo4Eb3LPor2gXqVYISloEpS";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, thuth@redhat.com
Message-ID: <b2730c42-27a7-1fff-0687-98b587516481@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/6] s390x: Add linemode buffer to fix
 newline on every print
References: <20190920080356.1948-1-frankja@linux.ibm.com>
 <20190920080356.1948-4-frankja@linux.ibm.com>
 <43bb9ff6-4233-3f6f-8cdb-3a00d1662d4d@redhat.com>
In-Reply-To: <43bb9ff6-4233-3f6f-8cdb-3a00d1662d4d@redhat.com>

--QIRclMaWNmfo4Eb3LPor2gXqVYISloEpS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/20/19 10:24 AM, David Hildenbrand wrote:
> On 20.09.19 10:03, Janosch Frank wrote:
>> Linemode seems to add a newline for each sent message which makes
>> reading rather hard. Hence we add a small buffer and only print if
>> it's full or a newline is encountered. Except for when the string is
>> longer than the buffer, then we flush the buffer and print directly.
>=20
> I think that last sentence is not correct anymore.
>=20
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> ---
>>  lib/s390x/sclp-console.c | 45 ++++++++++++++++++++++++++++++++++++---=
-
>>  1 file changed, 41 insertions(+), 4 deletions(-)
>>
>> diff --git a/lib/s390x/sclp-console.c b/lib/s390x/sclp-console.c
>> index 19416b5..e1b9000 100644
>> --- a/lib/s390x/sclp-console.c
>> +++ b/lib/s390x/sclp-console.c
>> @@ -13,6 +13,7 @@
>>  #include <asm/page.h>
>>  #include <asm/arch_def.h>
>>  #include <asm/io.h>
>> +#include <asm/spinlock.h>
>>  #include "sclp.h"
>> =20
>>  /*
>> @@ -87,6 +88,10 @@ static uint8_t _ascebc[256] =3D {
>>       0x90, 0x3F, 0x3F, 0x3F, 0x3F, 0xEA, 0x3F, 0xFF
>>  };
>> =20
>> +static char lm_buff[120];
>> +static unsigned char lm_buff_off;
>> +static struct spinlock lm_buff_lock;
>> +
>>  static void sclp_print_ascii(const char *str)
>>  {
>>  	int len =3D strlen(str);
>> @@ -103,10 +108,10 @@ static void sclp_print_ascii(const char *str)
>>  	sclp_service_call(SCLP_CMD_WRITE_EVENT_DATA, sccb);
>>  }
>> =20
>> -static void sclp_print_lm(const char *str)
>> +static void lm_print(const char *buff, int len)
>>  {
>>  	unsigned char *ptr, *end, ch;
>> -	unsigned int count, offset, len;
>> +	unsigned int count, offset;
>>  	struct WriteEventData *sccb;
>>  	struct mdb *mdb;
>>  	struct mto *mto;
>> @@ -117,11 +122,10 @@ static void sclp_print_lm(const char *str)
>>  	end =3D (unsigned char *) sccb + 4096 - 1;
>>  	memset(sccb, 0, sizeof(*sccb));
>>  	ptr =3D (unsigned char *) &sccb->msg.mdb.mto;
>> -	len =3D strlen(str);
>>  	offset =3D 0;
>>  	do {
>>  		for (count =3D sizeof(*mto); offset < len; count++) {
>> -			ch =3D str[offset++];
>> +			ch =3D buff[offset++];
>>  			if (ch =3D=3D 0x0a || ptr + count > end)
>>  				break;
>>  			ptr[count] =3D _ascebc[ch];
>> @@ -148,6 +152,39 @@ static void sclp_print_lm(const char *str)
>>  	sclp_service_call(SCLP_CMD_WRITE_EVENT_DATA, sccb);
>>  }
>> =20
>> +
>> +/*
>> + * In contrast to the ascii console, linemode produces a new
>> + * line with every write of data. The report() function uses
>> + * several printf() calls to generate a line of data which
>> + * would all end up on different lines.
>> + *
>> + * Hence we buffer here until we encounter a \n or the buffer
>> + * is full. That means that linemode output can look a bit
>> + * different from ascii and that it takes a bit longer for
>> + * lines to appear.
>> + */
>> +static void sclp_print_lm(const char *str)
>> +{
>> +	int len =3D strlen(str), i =3D 0;
>> +
>> +	spin_lock(&lm_buff_lock);
>> +
>> +	while (len) {
>=20
> for (i =3D 0; i < len; i++)
>=20
> Then make len const and drop "len--" and "i++" from the body.

Sure, the loop was a first draft anyway.
I'm asking myself how I ended up writing something so complicated in the
first place :-)

>=20
>> +		lm_buff[lm_buff_off] =3D str[i];
>> +		lm_buff_off++;
>=20
> lm_buff[lm_buff_off++] =3D str[i];
>=20
> if you feel like saving one LOC :)
>=20
>> +		len--;
>> +		/* Buffer full or newline? */
>> +		if (str[i] =3D=3D '\n' || lm_buff_off =3D=3D (sizeof(lm_buff) - 1))=
 {
>=20
> I still prefer ARRAY_SIZE(), but this is also fine.
>=20
>> +			lm_print(lm_buff, lm_buff_off);
>> +			memset(lm_buff, 0 , sizeof(lm_buff));
>=20
> Is the memset really necessary? (I would have assumed it would only
> print until the last "\n" ?)

It's not, I just like clearing things

>=20
>> +			lm_buff_off =3D 0;
>> +		}
>> +		i++;
>> +	}
>=20
> Guess we don't care about performance, so the simple byte-based approac=
h
> should be just fine.

;-)

>=20
>> +	spin_unlock(&lm_buff_lock);
>> +}
>> +
>>  /*
>>   * SCLP needs to be initialized by setting a send and receive mask,
>>   * indicating which messages the control program (we) want(s) to
>>
>=20
>=20
> I wonder if we have to implement some kind of fflush(), so we will flus=
h
> the buffer on any abort ... but I assume we will always end printing
> with a "\n", so we don't really care.

I haven't encountered incomplete output up to now.


--QIRclMaWNmfo4Eb3LPor2gXqVYISloEpS--

--L0YwyiZHqzRG8dvykBGYGIpfi38Dtzrre
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl2EjnIACgkQ41TmuOI4
ufjS8xAAla6M89VJF6YDkQL669ZXfq2BoOq/+nt7KncybESrdDzHRAtX6U37nmEv
vOPgl9b5UwAmupYxnKG9T7VROn6Kdbo6vCFricHG8pS/5oYjm8Rnd/QDJpAdX2iT
d3MdqBWN8fJlQnlcJzFKOjX8TUrsKsyCTBxvLdeJ8WzQXhw8uKm5iAfjE0YD5NCB
8Ou7jNxA/yXrs0wVwVEC1zpCaHC4F1G4pNaCaFEBZl3oEl2FhIa0rO+4oxqaXIFG
XdTimDDuOM0aGHqGdOE7Dp6GWUezAG6oyzg+Wsh0hZvUMOFT6yWXEyF7tIVFR/KS
aL6lecQ9uWrv14160oZ5FoNttpsfShyZDfiLr1VgPYNKkKvN5XyxoAowGDF61Kll
pZJj7fDNduWymukLD11b5faYYo/tzEzvMYax2kC36TAv6rGqP1doFosYrFJvUnka
rwyEZYE2tFCC0Fmf9tMTy3D+E9AavbDfuima+baKVYcPCFbJcXUWP+hWA35DlB3w
ts4y0cnWd0Ygnzf0irp4Vv+hHdmc8yaRx/p9VvqQJxCPviNnlNRS6MStDW+7rR1X
6GJnCyI5zRkKg1iy3LxFbFxFo+bSKNo3M85nxc7NKWy7r0Ha5R5YT6MG4BMcN1Zu
X5IZTpUSu3K8Ye3zz+0mkcXVb/zWsbAbXRmxzHa6kY5011Vy+C8=
=oC1y
-----END PGP SIGNATURE-----

--L0YwyiZHqzRG8dvykBGYGIpfi38Dtzrre--

