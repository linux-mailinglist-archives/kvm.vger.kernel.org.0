Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6712E45E5
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 10:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407258AbfJYIj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 04:39:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44926 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727897AbfJYIjz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 04:39:55 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9P8bTH9071822
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 04:39:54 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vuujh46af-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 04:39:54 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 25 Oct 2019 09:39:52 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 09:39:50 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9P8dnuA49152208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 08:39:49 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 169F611C052;
        Fri, 25 Oct 2019 08:39:49 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8361911C04C;
        Fri, 25 Oct 2019 08:39:48 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.50.181])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Oct 2019 08:39:48 +0000 (GMT)
Subject: Re: [RFC 06/37] s390: UV: Add import and export to UV library
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-7-frankja@linux.ibm.com>
 <32166470-43c1-f454-440f-3f660b995ca2@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 25 Oct 2019 10:39:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <32166470-43c1-f454-440f-3f660b995ca2@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TczTK0Vgqy3AOR2BpjNqBOZDwNj0wUGR7"
X-TM-AS-GCONF: 00
x-cbid: 19102508-0012-0000-0000-0000035D5625
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102508-0013-0000-0000-000021988BD6
Message-Id: <ed8860e6-176a-64dd-e697-5ed80dd3c872@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250081
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TczTK0Vgqy3AOR2BpjNqBOZDwNj0wUGR7
Content-Type: multipart/mixed; boundary="SN5pJkUObv1QcUB9Q0ONMh8kufdpmZ21N"

--SN5pJkUObv1QcUB9Q0ONMh8kufdpmZ21N
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/25/19 10:31 AM, David Hildenbrand wrote:
> On 24.10.19 13:40, Janosch Frank wrote:
>> The convert to/from secure (or also "import/export") ultravisor calls
>> are need for page management, i.e. paging, of secure execution VM.
>>
>> Export encrypts a secure guest's page and makes it accessible to the
>> guest for paging.
>=20
> How does paging play along with pinning the pages (from=20
> uv_convert_to_secure() -> kvm_s390_pv_pin_page()) in a follow up patch?=
=20
> Can you paint me the bigger picture?

That's a stale comment I should have removed before sending...
The current patches do not support paging.

>=20
> Just so I understand:
>=20
> When a page is "secure", it is actually unencrypted but only the guest =

> can access it. If the host accesses it, there is an exception.
>=20
> When a page is "not secure", it is encrypted but only the host can read=
=20
> it. If the guest accesses it, there is an exception.
>=20
> Based on these exceptions, you are able to request to convert back and =

> forth.

Yes
Shared pages are the exception, because they are accessible to both parti=
es.

>=20
>=20
>>
>> Import makes a page accessible to a secure guest.
>> On the first import of that page, the page will be cleared by the
>> Ultravisor before it is given to the guest.
>>
>> All following imports will decrypt a exported page and verify
>> integrity before giving the page to the guest.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/uv.h | 51 ++++++++++++++++++++++++++++++++++++=
++
>>   1 file changed, 51 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
>> index 0bfbafcca136..99cdd2034503 100644
>> --- a/arch/s390/include/asm/uv.h
>> +++ b/arch/s390/include/asm/uv.h
>> @@ -15,6 +15,7 @@
>>   #include <linux/errno.h>
>>   #include <linux/bug.h>
>>   #include <asm/page.h>
>> +#include <asm/gmap.h>
>>  =20
>>   #define UVC_RC_EXECUTED		0x0001
>>   #define UVC_RC_INV_CMD		0x0002
>> @@ -279,6 +280,54 @@ static inline int uv_cmd_nodata(u64 handle, u16 c=
md, u32 *ret)
>>   	return rc ? -EINVAL : 0;
>>   }
>>  =20
>> +/*
>> + * Requests the Ultravisor to encrypt a guest page and make it
>> + * accessible to the host for paging (export).
>> + *
>> + * @paddr: Absolute host address of page to be exported
>> + */
>> +static inline int uv_convert_from_secure(unsigned long paddr)
>> +{
>> +	struct uv_cb_cfs uvcb =3D {
>> +		.header.cmd =3D UVC_CMD_CONV_FROM_SEC_STOR,
>> +		.header.len =3D sizeof(uvcb),
>> +		.paddr =3D paddr
>> +	};
>> +	if (!uv_call(0, (u64)&uvcb))
>> +		return 0;
>> +	return -EINVAL;
>> +}
>> +
>> +/*
>> + * Requests the Ultravisor to make a page accessible to a guest
>> + * (import). If it's brought in the first time, it will be cleared. I=
f
>> + * it has been exported before, it will be decrypted and integrity
>> + * checked.
>> + *
>> + * @handle: Ultravisor guest handle
>> + * @gaddr: Guest 2 absolute address to be imported
>> + */
>> +static inline int uv_convert_to_secure(struct gmap *gmap, unsigned lo=
ng gaddr)
>> +{
>> +	int cc;
>> +	struct uv_cb_cts uvcb =3D {
>> +		.header.cmd =3D UVC_CMD_CONV_TO_SEC_STOR,
>> +		.header.len =3D sizeof(uvcb),
>> +		.guest_handle =3D gmap->se_handle,
>> +		.gaddr =3D gaddr
>> +	};
>> +
>> +	cc =3D uv_call(0, (u64)&uvcb);
>> +
>> +	if (!cc)
>> +		return 0;
>> +	if (uvcb.header.rc =3D=3D 0x104)
>> +		return -EEXIST;
>> +	if (uvcb.header.rc =3D=3D 0x10a)
>> +		return -EFAULT;
>> +	return -EINVAL;
>> +}
>> +
>>   void setup_uv(void);
>>   void adjust_to_uv_max(unsigned long *vmax);
>>   #else
>> @@ -286,6 +335,8 @@ void adjust_to_uv_max(unsigned long *vmax);
>>   static inline void setup_uv(void) {}
>>   static inline void adjust_to_uv_max(unsigned long *vmax) {}
>>   static inline int uv_cmd_nodata(u64 handle, u16 cmd, u32 *ret) { ret=
urn 0; }
>> +static inline int uv_convert_from_secure(unsigned long paddr) { retur=
n 0; }
>> +static inline int uv_convert_to_secure(unsigned long handle, unsigned=
 long gaddr) { return 0; }
>>   #endif
>>  =20
>>   #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||               =
           \
>>
>=20
>=20



--SN5pJkUObv1QcUB9Q0ONMh8kufdpmZ21N--

--TczTK0Vgqy3AOR2BpjNqBOZDwNj0wUGR7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl2ytNQACgkQ41TmuOI4
ufikyhAAtDivoT8s8vpUdQbwSKbW2WbmmWgM8A6k90UJJtYevktH9pwn8Wx3tN5n
BXZOChAOKzdgS9PYOUMNAZzArl60FMHwM0R89Mmvsqt60FblV9wDe7OKqqcvbqlf
fhuJSImEqqxcy0Zrjj6IrKSnN7QcBWK2yuNzjMU9iXtbHPKh0MvE+76t6KuA+XXG
OZryagF04kzaJkOC8AFrDfJNdsmtXwYzAMRArkGSkHvUoS7lNwT2xhtuCrxNUTm8
mpOeucwDi1uwoWyZlw3tmn80jnUpasRr/PkMo/s0izRrx45KD4+GErJ/SnnpqRqG
+o3omZUbAa+bboCIpyyh4VoaUAMvpfuwVU5V155hdw2KymGm4ZxRhXDh968mgqNT
MfCiP/c31o9JQ/VMcZPgY1YSuge9DIAc4l6N06mguEZHVtv6WGsqpKs5UH/YbNFe
1Zxk6G6Ti+c4X5GQOenuedxZDPYP6IKu5S5fyJvTg4kCSsxRRg4FdYRX5ZAG+uWP
zkh8MEKAY9CSIUqPYVyKYYl4DDOp2i1P9Qy417x9wDMK7LRWbgAnSG4c1TNoeENY
Zk4eVk7IA41CtXPR9JsJEhxjzMYWD+Br8y2eL3QFoOKLirMMEgST9mZ64cBuHUo9
XMOdhLFxeQs3ICzZJN99WylAKPJ3tNYGps/1DLb3HnUXNqbzIfY=
=C4qy
-----END PGP SIGNATURE-----

--TczTK0Vgqy3AOR2BpjNqBOZDwNj0wUGR7--

