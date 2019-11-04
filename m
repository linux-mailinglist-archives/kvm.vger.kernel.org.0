Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6370EEDB9E
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 10:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbfKDJXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 04:23:19 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17360 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727322AbfKDJXS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Nov 2019 04:23:18 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xA49LqwF034358
        for <kvm@vger.kernel.org>; Mon, 4 Nov 2019 04:23:16 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w2ea7x6xt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 04:23:07 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Mon, 4 Nov 2019 09:23:01 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 4 Nov 2019 09:22:58 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xA49Musu47513942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Nov 2019 09:22:56 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D51FF5204F;
        Mon,  4 Nov 2019 09:22:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.70.20])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 83B845204E;
        Mon,  4 Nov 2019 09:22:56 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 4/5] s390x: sclp: add service call
 instruction wrapper
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com
References: <1572023194-14370-1-git-send-email-imbrenda@linux.ibm.com>
 <1572023194-14370-5-git-send-email-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Mon, 4 Nov 2019 10:22:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1572023194-14370-5-git-send-email-imbrenda@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YPrNEOhWAleduR4UqGl7Gb59wIlVhuQIW"
X-TM-AS-GCONF: 00
x-cbid: 19110409-0028-0000-0000-000003B2713C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19110409-0029-0000-0000-00002474C3CE
Message-Id: <8b634cc6-6675-66f2-f4e7-2a36256915a1@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-04_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1911040092
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YPrNEOhWAleduR4UqGl7Gb59wIlVhuQIW
Content-Type: multipart/mixed; boundary="qeEJT3seud3JZET4BgvxSkkrJWKXjvppk"

--qeEJT3seud3JZET4BgvxSkkrJWKXjvppk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/25/19 7:06 PM, Claudio Imbrenda wrote:
> Add a wrapper for the service call instruction, and use it for SCLP
> interactions instead of using inline assembly everywhere.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/s390x/asm/arch_def.h | 13 +++++++++++++
>  lib/s390x/sclp.c         |  7 +------
>  2 files changed, 14 insertions(+), 6 deletions(-)
>=20
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 96cca2e..b3caff6 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -269,4 +269,17 @@ static inline int stsi(void *addr, int fc, int sel=
1, int sel2)
>  	return cc;
>  }
> =20
> +static inline int servc(uint32_t command, unsigned long sccb)
> +{
> +	int cc;
> +
> +	asm volatile(
> +		"       .insn   rre,0xb2200000,%1,%2\n"  /* servc %1,%2 */
> +		"       ipm     %0\n"
> +		"       srl     %0,28"
> +		: "=3D&d" (cc) : "d" (command), "a" (sccb)
> +		: "cc", "memory");
> +	return cc;
> +}
> +
>  #endif
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 7798f04..e35c282 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -116,12 +116,7 @@ int sclp_service_call(unsigned int command, void *=
sccb)
>  	int cc;
> =20
>  	sclp_setup_int();
> -	asm volatile(
> -		"       .insn   rre,0xb2200000,%1,%2\n"  /* servc %1,%2 */
> -		"       ipm     %0\n"
> -		"       srl     %0,28"
> -		: "=3D&d" (cc) : "d" (command), "a" (__pa(sccb))
> -		: "cc", "memory");
> +	cc =3D servc(command, __pa(sccb));
>  	sclp_wait_busy();
>  	if (cc =3D=3D 3)
>  		return -1;
>=20



--qeEJT3seud3JZET4BgvxSkkrJWKXjvppk--

--YPrNEOhWAleduR4UqGl7Gb59wIlVhuQIW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl2/7fAACgkQ41TmuOI4
ufiJKw/+OsLZx9LFAmmSTtmzNlYo8g4bGzl8PX+TvbklXoOhXlaZITHEFyApLSQH
9FQQkAq/h0eQYKhAt55OyNcinldStRnKDtMREXNdmeHrYQvHqmXu7hbsXanMI5G0
+yWf18yAzIsGRdVKE4XONyV88eiHm9waRkHR8CU1FaSnbTk89WOD9cJLh3BKO7f1
+vHfQq+9v/EhXBuIbSYzMA+liB5aScDf34YdtbliBVVoU+YZZHZie3LOy1zB0J0W
GSiW1IJaKXOi5fxAc5BDa1Ckwd28MlX1J33ZqT5F/OrZ6shnfuHZTddmHriA5Kw6
rcMt97CxW2ynFHJ2ddSgQvFJWF4QbvZAoOUpQAbD435MK8X0BHlocYY98Vw80Z7n
FNXUafjCEATuYQsVmw1HXaZm+dB31jAvnvSYrYHXEzESYOHktmmo1F1LANVlAmnm
dDP/7E719hATshwQT4ItKx7QE9CqHHFqdk+wezabfRhOEuqq9bI5r1+gSuyXP9a4
23EKWeY2kHy9GOYECmbRkWobz/s03SxVSAWP+EFg9ZlAPWkD5jb/mexcbNa99C5k
nxw0/dj1d3i+i8Yvb+Y+Qy3dcz6CTSFhZjMe2hEjk6QhNY273MViB4Iox6JHzewx
seno8k0mdNjcfveV4yznOqyjRxAp7hy+zxmEunvsq9Wg6yTp7yc=
=SBAF
-----END PGP SIGNATURE-----

--YPrNEOhWAleduR4UqGl7Gb59wIlVhuQIW--

