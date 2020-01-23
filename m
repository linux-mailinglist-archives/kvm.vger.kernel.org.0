Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2090D14654A
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 11:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgAWKCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 05:02:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50636 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726170AbgAWKCP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Jan 2020 05:02:15 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00N9v8En069513
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 05:02:14 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xp4gkm9bw-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 05:02:14 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 23 Jan 2020 10:02:11 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 23 Jan 2020 10:02:09 -0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00NA28d034734314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 10:02:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 570D94C059;
        Thu, 23 Jan 2020 10:02:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 203A64C046;
        Thu, 23 Jan 2020 10:02:08 +0000 (GMT)
Received: from dyn-9-152-224-146.boeblingen.de.ibm.com (unknown [9.152.224.146])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 Jan 2020 10:02:08 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 3/9] s390x: Add cpu id to interrupt
 error prints
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
References: <20200121134254.4570-1-frankja@linux.ibm.com>
 <20200121134254.4570-4-frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Thu, 23 Jan 2020 11:02:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200121134254.4570-4-frankja@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QuKMEoGgLNLkEZq3WdAd9WQRmY1XwXkkP"
X-TM-AS-GCONF: 00
x-cbid: 20012310-0008-0000-0000-0000034BF861
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20012310-0009-0000-0000-00004A6C643E
Message-Id: <0eb69c66-5aa7-1609-9de0-c3d0efaed30a@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-23_01:2020-01-23,2020-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0 suspectscore=5
 spamscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001230085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QuKMEoGgLNLkEZq3WdAd9WQRmY1XwXkkP
Content-Type: multipart/mixed; boundary="cHoknl57HwFFjRuAxHcNlg9v4ZhoKdgtr"

--cHoknl57HwFFjRuAxHcNlg9v4ZhoKdgtr
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/21/20 2:42 PM, Janosch Frank wrote:
> It's good to know which cpu broke the test.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/s390x/interrupt.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>=20
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 05f30be..773752a 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -107,8 +107,8 @@ static void fixup_pgm_int(void)
>  void handle_pgm_int(void)
>  {
>  	if (!pgm_int_expected)
> -		report_abort("Unexpected program interrupt: %d at %#lx, ilen %d\n",
> -			     lc->pgm_int_code, lc->pgm_old_psw.addr,
> +		report_abort("Unexpected program interrupt: %d on cpu %d at %#lx, il=
en %d\n",
> +			     lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
>  			     lc->pgm_int_id);
> =20
>  	pgm_int_expected =3D false;
> @@ -119,8 +119,8 @@ void handle_ext_int(void)
>  {
>  	if (!ext_int_expected &&
>  	    lc->ext_int_code !=3D EXT_IRQ_SERVICE_SIG) {
> -		report_abort("Unexpected external call interrupt (code %#x): at %#lx=
",
> -			     lc->ext_int_code, lc->ext_old_psw.addr);
> +		report_abort("Unexpected external call interrupt (code %#x): on cpu =
%d at %#lx",
> +			     stap(), lc->ext_int_code, lc->ext_old_psw.addr);

The arguments are in the wrong order, stap() should come after the int
code...


>  		return;
>  	}
> =20
> @@ -137,18 +137,18 @@ void handle_ext_int(void)
> =20
>  void handle_mcck_int(void)
>  {
> -	report_abort("Unexpected machine check interrupt: at %#lx",
> -		     lc->mcck_old_psw.addr);
> +	report_abort("Unexpected machine check interrupt: on cpu %d at %#lx",=

> +		     stap(), lc->mcck_old_psw.addr);
>  }
> =20
>  void handle_io_int(void)
>  {
> -	report_abort("Unexpected io interrupt: at %#lx",
> -		     lc->io_old_psw.addr);
> +	report_abort("Unexpected io interrupt: on cpu %d at %#lx",
> +		     stap(), lc->io_old_psw.addr);
>  }
> =20
>  void handle_svc_int(void)
>  {
> -	report_abort("Unexpected supervisor call interrupt: at %#lx",
> -		     lc->svc_old_psw.addr);
> +	report_abort("Unexpected supervisor call interrupt: on cpu %d at %#lx=
",
> +		     stap(), lc->svc_old_psw.addr);
>  }
>=20



--cHoknl57HwFFjRuAxHcNlg9v4ZhoKdgtr--

--QuKMEoGgLNLkEZq3WdAd9WQRmY1XwXkkP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl4pbx8ACgkQ41TmuOI4
ufgJCRAAkMV085Xgr4bBJawmFm39u79utTIgPYZ8If25YhhqIirHAMRE9uUJMlEG
L3uY9aX814Knu6sJT2/j8Z+06oqTqIDmcQ5k7uXSEsLA7++t3RUqlGdqaBXqEfKd
gkOQKoYEu05YOmHND9QNlKxvCxC3BEl3xScQqVVSDGydkvSh/wPtqQTNSKlmL8Se
yZZV589OXxFYWwzqZDiU2iLdpwhlwWGXKHW46jo3H/2sZcR08BtGUbOWCHsUXz9a
+L7PflwGMT86MKLBgPRSEWWmuULeBfVqDPkr8d2HLpuMrJPEj5XPxMXKFiThpm7r
BB48m+sdSNHqtPn6gbMbvt1DeDhmdlqrWbmRBNa45+0fROBieJNY6+Vmcbe5Ap4d
X4Z7QfC2XIedk/IZTLPmASCBt37bmfcuh4qMi3jITNYvjKvpVqKBAF6ZA0EQChZ9
tcWbMFKFJvQvhS5uTzrfGfCPFKD2EZjRUMQOFbxjRcjF66HxOVD6IQYKUMIf9LIp
HLBQR4TYsEgW5CYyVBdts5f7eJjjfxCHuwldTjg17RpGOrLzWhebKruaiNERMHGx
RupbreYViEA8Joo4mfXW3rfuNrlt5mL0jgo5TI3Tlf6+x/IzHWUdLfEEjyv4oGE8
KbXh/Ol8uD9QESGlcCvgHRK7qsGVBOLu/adrbmCCOMxbUjSqsD8=
=8lNe
-----END PGP SIGNATURE-----

--QuKMEoGgLNLkEZq3WdAd9WQRmY1XwXkkP--

