Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D502203375
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 11:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgFVJdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 05:33:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61754 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726982AbgFVJdh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 05:33:37 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05M9Wbjm048063;
        Mon, 22 Jun 2020 05:33:35 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31sk2r2um1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 05:33:34 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05M9X0RI048847;
        Mon, 22 Jun 2020 05:33:33 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31sk2r2uhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 05:33:33 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05M9Jvje032098;
        Mon, 22 Jun 2020 09:33:27 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 31sa3819vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 09:33:27 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05M9W63B62062956
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 09:32:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BE7F4C040;
        Mon, 22 Jun 2020 09:33:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2A134C058;
        Mon, 22 Jun 2020 09:33:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.8.171])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Jun 2020 09:33:24 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v9 08/12] s390x: retrieve decimal and
 hexadecimal kernel parameters
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, Andrew Jones <drjones@redhat.com>
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-9-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <a86a71c7-8c5e-7216-0a74-7bdc36355c02@linux.ibm.com>
Date:   Mon, 22 Jun 2020 11:33:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1592213521-19390-9-git-send-email-pmorel@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="x4c5rWxOoMlca6A7C8cqBNKUamy9aC3dC"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_02:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 cotscore=-2147483648 mlxscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 spamscore=0 phishscore=0 impostorscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006220069
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x4c5rWxOoMlca6A7C8cqBNKUamy9aC3dC
Content-Type: multipart/mixed; boundary="txW6Zx0vTgWkScy27Jc5dohT3vRniO6r5"

--txW6Zx0vTgWkScy27Jc5dohT3vRniO6r5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/15/20 11:31 AM, Pierre Morel wrote:
> We often need to retrieve hexadecimal kernel parameters.
> Let's implement a shared utility to do it.

Often?

My main problem with this patch is that it doesn't belong into the s390
library. atol() is already in string.c so htol() can be next to it.

util.c already has parse_keyval() so you should be able to extend it a
bit for hex values and add a function below that goes through argv[].

CCing Andrew as he wrote most of the common library

>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/kernel-args.c | 60 +++++++++++++++++++++++++++++++++++++++++=

>  lib/s390x/kernel-args.h | 18 +++++++++++++
>  s390x/Makefile          |  1 +
>  3 files changed, 79 insertions(+)
>  create mode 100644 lib/s390x/kernel-args.c
>  create mode 100644 lib/s390x/kernel-args.h
>=20
> diff --git a/lib/s390x/kernel-args.c b/lib/s390x/kernel-args.c
> new file mode 100644
> index 0000000..2d3b2c2
> --- /dev/null
> +++ b/lib/s390x/kernel-args.c
> @@ -0,0 +1,60 @@
> +/*
> + * Retrieving kernel arguments
> + *
> + * Copyright (c) 2020 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify i=
t
> + * under the terms of the GNU General Public License version 2.
> + */
> +
> +#include <libcflat.h>
> +#include <string.h>
> +#include <asm/arch_def.h>
> +#include <kernel-args.h>
> +
> +static const char *hex_digit =3D "0123456789abcdef";
> +
> +static unsigned long htol(char *s)
> +{
> +	unsigned long v =3D 0, shift =3D 0, value =3D 0;
> +	int i, digit, len =3D strlen(s);
> +
> +	for (shift =3D 0, i =3D len - 1; i >=3D 0; i--, shift +=3D 4) {
> +		digit =3D s[i] | 0x20;	/* Set lowercase */
> +		if (!strchr(hex_digit, digit))
> +			return 0;	/* this is not a digit ! */
> +
> +		if (digit <=3D '9')
> +			v =3D digit - '0';
> +		else
> +			v =3D digit - 'a' + 10;
> +		value +=3D (v << shift);
> +	}
> +
> +	return value;
> +}
> +
> +int kernel_arg(int argc, char *argv[], const char *str, unsigned long =
*val)
> +{
> +	int i, ret;
> +	char *p, *q;
> +
> +	for (i =3D 0; i < argc; i++) {
> +		ret =3D strncmp(argv[i], str, strlen(str));
> +		if (ret)
> +			continue;
> +		p =3D strchr(argv[i], '=3D');
> +		if (!p)
> +			return -1;
> +		q =3D strchr(p, 'x');
> +		if (!q)
> +			*val =3D atol(p + 1);
> +		else
> +			*val =3D htol(q + 1);
> +		return 0;
> +	}
> +	return -2;
> +}
> diff --git a/lib/s390x/kernel-args.h b/lib/s390x/kernel-args.h
> new file mode 100644
> index 0000000..a88e34e
> --- /dev/null
> +++ b/lib/s390x/kernel-args.h
> @@ -0,0 +1,18 @@
> +/*
> + * Kernel argument
> + *
> + * Copyright (c) 2020 IBM Corp
> + *
> + * Authors:
> + *  Pierre Morel <pmorel@linux.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify i=
t
> + * under the terms of the GNU General Public License version 2.
> + */
> +
> +#ifndef KERNEL_ARGS_H
> +#define KERNEL_ARGS_H
> +
> +int kernel_arg(int argc, char *argv[], const char *str, unsigned long =
*val);
> +
> +#endif
> diff --git a/s390x/Makefile b/s390x/Makefile
> index ddb4b48..47a94cc 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -51,6 +51,7 @@ cflatobjs +=3D lib/s390x/sclp-console.o
>  cflatobjs +=3D lib/s390x/interrupt.o
>  cflatobjs +=3D lib/s390x/mmu.o
>  cflatobjs +=3D lib/s390x/smp.o
> +cflatobjs +=3D lib/s390x/kernel-args.o
> =20
>  OBJDIRS +=3D lib/s390x
> =20
>=20



--txW6Zx0vTgWkScy27Jc5dohT3vRniO6r5--

--x4c5rWxOoMlca6A7C8cqBNKUamy9aC3dC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl7weuQACgkQ41TmuOI4
ufjZWA/+Ikh7yYITvg5lGGijgc1Q062oYsmOshLASfOdbVOR1P80GpU7aZolt/GL
ZvORUl2QpC67DKzA3l6k7Dn7a/tbF7bORchvhOQ9d448eYfXsr4tvFSdq+RTFMcb
oAQobUKNIDjcAtkAaYN87TCSfeEx1WDIgNbkChA83m9VOAJljfyi4WWJv24xS60K
2VHbSc9FpqKsAFqhfP1Ygw+mBgSr2GhJ3lZ6RzsJAQVAo5um5k0enYcEOglKZXrW
+CulEAE8QShEboaXEY2S2sPZL3+UKbRbXRt56VCLUM8IQNliqTvQjsK6bFqulhNy
fBB8BvGaWDdQu+uM3t/mCHKrqfKdbbjKgQHa9FmOOjlWD8qe8+EwP8/BlZCzoWaO
D7juVbdVKMMp7PSQWHTROV+tAjy7hts1PARF/v5P0pyQIaOoumADZBYLlfwNr9ug
ZjI9FwF4/FOKJYkvD3hFrZyz1HDzxt0K+idRdsF98isUMZerGWbjy9huOyeCEEXg
jUTbr0OFQL3khsNYYPKJgv8L+mdwRZQhbN720rgyPNjPayjHYu6HqaU6zCIxjh3S
iiPbS75KoTIO+G/SdW/NJB5HjgAOEwfnSvxbgSNJrceKjkLLhPDzRpQDbq165U4Q
J6pGdldRbjQaNZ1RzrJI6hpjh0GklfahFDhQZmkMqOMRm1fkINY=
=iohs
-----END PGP SIGNATURE-----

--x4c5rWxOoMlca6A7C8cqBNKUamy9aC3dC--

