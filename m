Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3F61BA45C
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 15:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgD0NOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 09:14:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64858 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726721AbgD0NOu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 09:14:50 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RD8r6o034865;
        Mon, 27 Apr 2020 09:14:48 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30me4vgc4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 09:14:48 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03RD2Bqf009138;
        Mon, 27 Apr 2020 09:14:47 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30me4vgc45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 09:14:47 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03RDB6EM005248;
        Mon, 27 Apr 2020 13:14:46 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu6uxdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 13:14:45 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03RDEhes52691306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 13:14:43 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A427A52065;
        Mon, 27 Apr 2020 13:14:43 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.33.119])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4842152052;
        Mon, 27 Apr 2020 13:14:43 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 10/10] s390x: css: ping pong
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
 <1587725152-25569-11-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <ecd95341-0cc2-1aee-239d-5de63cf6e7e1@linux.ibm.com>
Date:   Mon, 27 Apr 2020 15:14:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1587725152-25569-11-git-send-email-pmorel@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VyqPkqdbUITqYaIO0uC6vBUXeniAb2kHj"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_09:2020-04-24,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999
 suspectscore=0 impostorscore=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VyqPkqdbUITqYaIO0uC6vBUXeniAb2kHj
Content-Type: multipart/mixed; boundary="i0FRPbYCTBrF48cJQBESMhP1kCF65USwz"

--i0FRPbYCTBrF48cJQBESMhP1kCF65USwz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/24/20 12:45 PM, Pierre Morel wrote:
> To test a write command with the SSCH instruction we need a QEMU device=
,
> with control unit type 0xC0CA. The PONG device is such a device.
>=20
> This type of device responds to PONG_WRITE requests by incrementing an
> integer, stored as a string at offset 0 of the CCW data.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/css.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++++=

>  1 file changed, 54 insertions(+)
>=20
> diff --git a/s390x/css.c b/s390x/css.c
> index b9dbf01..7cd8731 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -23,6 +23,12 @@
>  #define PSW_PRG_MASK (PSW_MASK_EA | PSW_MASK_BA)
> =20
>  #define PONG_CU_TYPE		0xc0ca
> +/* Channel Commands for PONG device */
> +#define PONG_WRITE	0x21 /* Write */
> +#define PONG_READ	0x22 /* Read buffer */
> +
> +#define BUFSZ	9
> +static char buffer[BUFSZ];
> =20
>  struct lowcore *lowcore =3D (void *)0x0;
> =20
> @@ -262,6 +268,53 @@ unreg_cb:
>  	unregister_io_int_func(irq_io);
>  }
> =20
> +static void test_ping(void)
> +{
> +	int success, result;
> +	int cnt =3D 0, max =3D 4;
> +
> +	if (senseid.cu_type !=3D PONG_CU) {
> +		report_skip("No PONG, no ping-pong");

"Device is not a pong device."

> +		return;
> +	}
> +
> +	result =3D register_io_int_func(irq_io);
> +	if (result) {
> +		report(0, "Could not register IRQ handler");
> +		return;
> +	}

I'm not sure if it's worth checking the return values or even having a
check in register_io_int_func() in the first place.

> +
> +	while (cnt++ < max) {
> +		snprintf(buffer, BUFSZ, "%08x\n", cnt);
> +		success =3D start_subchannel(PONG_WRITE, buffer, BUFSZ);
> +		if (!success) {
> +			report(0, "start_subchannel failed");
> +			goto unreg_cb;
> +		}
> +
> +		wfi(PSW_MASK_IO);
> +
> +		success =3D start_subchannel(PONG_READ, buffer, BUFSZ);
> +		if (!success) {
> +			report(0, "start_subchannel failed");
> +			goto unreg_cb;
> +		}
> +
> +		wfi(PSW_MASK_IO);
> +
> +		result =3D atol(buffer);
> +		if (result !=3D (cnt + 1)) {
> +			report(0, "Bad answer from pong: %08x - %08x",
> +			       cnt, result);
> +			goto unreg_cb;
> +		}
> +	}
> +	report(1, "ping-pong count 0x%08x", cnt);
> +
> +unreg_cb:
> +	unregister_io_int_func(irq_io);
> +}
> +
>  static struct {
>  	const char *name;
>  	void (*func)(void);
> @@ -269,6 +322,7 @@ static struct {
>  	{ "enumerate (stsch)", test_enumerate },
>  	{ "enable (msch)", test_enable },
>  	{ "sense (ssch/tsch)", test_sense },
> +	{ "ping-pong (ssch/tsch)", test_ping },
>  	{ NULL, NULL }
>  };
> =20
>=20



--i0FRPbYCTBrF48cJQBESMhP1kCF65USwz--

--VyqPkqdbUITqYaIO0uC6vBUXeniAb2kHj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6m2sIACgkQ41TmuOI4
ufhqGQ//XzwgcznOKIT/896pX9dyVpuW0p1I7r8gE1gJ4IIpa8CU+rcUNbsmmCLX
BQw5jjnhuenHV0veHZ2HqXq+1k2DxlAKZOhxo0NC80z+wdjPEw4/IhmQEPzihSc+
keoUgN5bj+Jp5dlNpcGLnPBCTTuINSqdrwAQnZGdiuEAT3hETYAxSkdU/6hCsnR5
kUxRSil7cPlU8HMMTBemr2Y6QVM2Ew4QnWp5s+IS9051OB+lpKpeyRFXgsKsIVa+
0JHLdipTMzdw9cr2IXs5b0h2Oq5FU1Z8/eKFrAeN/yM48VkXdMeZMnPKWtWz7waa
rc5A57HbGHvKN8qsCnl7TFt30kOVwAtaD0WMVb9Wtn0tT0Cl8N5ACnoIe5Tnbqjr
OalF8K3dPD5YOKdVMCSgHvPrF1wQTry58J4d2cC1XxBpOo1Mw/QqC6tGt1himoHg
9VyI31UTVzMtJxrybNTz5dudGPQ/KbJ4Y/WRZhCDqF7nbgrfvtC6se+LQjz8hD5o
J/yHmFgySIBP1yQ+7BWwYTrht9IOrCdM06Axk/q7xh0A6ImNZ2exVUAC+JIX/eQF
iiIxgaaF2yoFiwdwl4eaBMyjWrFIgEmZYTIUbLUKEQc7uVyQoLbB2vOYvtM1ZNEW
tULRzNRRRj+uJsLvZjKQvsN03seFuZzQl623daNBUDX2NRrjRmU=
=P/+U
-----END PGP SIGNATURE-----

--VyqPkqdbUITqYaIO0uC6vBUXeniAb2kHj--

