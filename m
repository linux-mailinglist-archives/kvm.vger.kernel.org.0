Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1D124172E
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 09:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgHKHbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 03:31:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5740 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727852AbgHKHbk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Aug 2020 03:31:40 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07B7VP5O083805;
        Tue, 11 Aug 2020 03:31:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=//1HIQKQbfsz3PbiQsO7BYsIqPJJOvb6NBTEDusQ+fo=;
 b=jSEeKQWZFRvy7cYMrJCJKohAjtI1PBHBXttq2CjIazWjyb1Fubh/84IxQf/MhMk0EbPD
 FNwryK/GsILNKMmPrlrIpheK6aeAzlGwZY8X1XZeMSRJB4bZzv0KlW7vqKtgN9glaedu
 PcIUCXqpseNR5VFy3ZCya6PNQ7wZcVFBFlzJ7hS0Hu/SZ5I7PkomSVNj/ujDmU1yQkwe
 PljVgjKmBTrRBmZ0jZYZtkYI2cm2Opuam2VRV0i5NkC0/K0YXa0fdp1In1VGR0aAzxLx
 VuEKagy688LXLKFSRq0y3nD8ieBox/+vDP2B7hD1s7rWSZBksaaGyRsGEcce63n/aNQt tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32sr9jk3ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Aug 2020 03:31:39 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07B7VY60085002;
        Tue, 11 Aug 2020 03:31:38 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32sr9jk2qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Aug 2020 03:31:37 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07B7QG4X024982;
        Tue, 11 Aug 2020 07:29:16 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 32skp81vsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Aug 2020 07:29:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07B7TDdA63898094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Aug 2020 07:29:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72CF94C04A;
        Tue, 11 Aug 2020 07:29:13 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 106C24C040;
        Tue, 11 Aug 2020 07:29:13 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.158.66])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Aug 2020 07:29:12 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 0/3] PV tests part 1
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <20200807111555.11169-1-frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <8ba7de43-8195-9492-e973-1474cd75933c@linux.ibm.com>
Date:   Tue, 11 Aug 2020 09:29:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200807111555.11169-1-frankja@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="v1wZa1O4xnNrXARbCuZXaPDVNQZPq5XfV"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-11_04:2020-08-06,2020-08-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008110043
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--v1wZa1O4xnNrXARbCuZXaPDVNQZPq5XfV
Content-Type: multipart/mixed; boundary="P3brhPKYLoiYnSsMc5aC4gmvVjX2BmL6m"

--P3brhPKYLoiYnSsMc5aC4gmvVjX2BmL6m
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 8/7/20 1:15 PM, Janosch Frank wrote:
> Let's start bringing in some more PV related code.
>=20
> Somehow I missed that we can also have a key in a exception new
> PSW. The interesting bit is that if such a PSW is loaded on an
> exception it will result in a specification exception and not a
> special operation exception.
>=20
> The third patch adds a basic guest UV call API test. It has mostly
> been used for firmware testing but I also think it's good to have a
> building block like this for more PV tests.
>=20
>=20
> GIT: https://gitlab.com/frankja/kvm-unit-tests/-/tree/queue

Picked the series onto:
https://gitlab.com/frankja/kvm-unit-tests/-/commits/next

>=20
>=20
> v2:
> 	* Renamed pgm_int_func to pgm_cleanup_func() and moved the call to han=
dle_pgm_int()
> 	* Added page allocation to UV test
> 	* Cleanups
>=20
> Janosch Frank (3):
>   s390x: Add custom pgm cleanup function
>   s390x: skrf: Add exception new skey test and add test to unittests.cf=
g
>   s390x: Ultravisor guest API test
>=20
>  lib/s390x/asm/interrupt.h |   1 +
>  lib/s390x/asm/uv.h        |  74 +++++++++++++++++
>  lib/s390x/interrupt.c     |  12 ++-
>  s390x/Makefile            |   1 +
>  s390x/skrf.c              |  79 +++++++++++++++++++
>  s390x/unittests.cfg       |   7 ++
>  s390x/uv-guest.c          | 162 ++++++++++++++++++++++++++++++++++++++=

>  7 files changed, 335 insertions(+), 1 deletion(-)
>  create mode 100644 lib/s390x/asm/uv.h
>  create mode 100644 s390x/uv-guest.c
>=20



--P3brhPKYLoiYnSsMc5aC4gmvVjX2BmL6m--

--v1wZa1O4xnNrXARbCuZXaPDVNQZPq5XfV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8ySMgACgkQ41TmuOI4
ufgeURAAxt6i14y23K/04ATfEcjepJdVVKyygae687fkwSXYP4Aelp3biKXUpXKo
pNJ2dUFMhSYpMLO7ibCPLJKCmDPw60Yhr3eqqsdBC1JqtEJihGhbYRX23s1rYh/Z
YIgW+oEySvnTHzUA1H1F/1TzacxvFkvjMSHzt/qNwKVCKpYfLbxPKeQQ5kHU+BxY
ETQbSR/DqCQL8X5dXcLteXhR4eEfHt9VGnAuMYNwZuTM8LdV/osfI9v4X+rP9n6f
3PqRbcHUX3e72Ll6yeun/moC2ARCa64xHFh/RTTwz7C4Z/bEIb2xUsMTlse0HY3A
PQcDCLHOLV4SKrKUaheP+bQ9sNQQXusPNYqeKpTsNCRc5Tm23CxC6iBBWAHRYtTX
T09uBlCjUo/g+Kyc21JlxTib0DeFqoXQH06Zx55u2BeX4mRVFFIoOkf2S6wkxoNy
sLGmPgRJYwYX6qPVI5M+1aIzJjubIzyfRtkH4q7KyADr9l+tILYvfEDc6b2ZMQuX
3oTzzgwC4x+TgItkLQh05symeT+N5FD6cCJ6JgSGJLncVlltmrfRwBdSeo/lCxcC
CZ/G9U2lBjdoPYhceki9SjuWOS5Idu3mw+lgaUYsf4WPrTa3iVzfLPVLE/p6+N4w
U4WV2KHSrEK+bRsrDAP/ctNQv8RfAC7d64lzfdL3VbTGW/HymHw=
=8U8B
-----END PGP SIGNATURE-----

--v1wZa1O4xnNrXARbCuZXaPDVNQZPq5XfV--

