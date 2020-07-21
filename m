Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B292280AE
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 15:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgGUNMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 09:12:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16282 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726993AbgGUNMB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 09:12:01 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06LD7Sgs058722;
        Tue, 21 Jul 2020 09:11:59 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d5k10cks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 09:11:59 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06LDAUHR062982;
        Tue, 21 Jul 2020 09:11:59 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32d5k10cju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 09:11:59 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06LD7rI3022002;
        Tue, 21 Jul 2020 13:11:57 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 32brbgsxcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 13:11:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06LDBsiG18546988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 13:11:54 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B625D4C04E;
        Tue, 21 Jul 2020 13:11:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4ED1E4C058;
        Tue, 21 Jul 2020 13:11:54 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.20.173])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jul 2020 13:11:54 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v13 0/9] s390x: Testing the Channel
 Subsystem I/O
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, drjones@redhat.com
References: <1594887809-10521-1-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <3000fa45-2273-5ca3-f4fd-2aac5edf7c5a@linux.ibm.com>
Date:   Tue, 21 Jul 2020 15:11:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1594887809-10521-1-git-send-email-pmorel@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ZyXOvTUTP9Fn6MPQEiv8Tq2eVqjiFlluY"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_08:2020-07-21,2020-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 priorityscore=1501 mlxscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 impostorscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210089
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ZyXOvTUTP9Fn6MPQEiv8Tq2eVqjiFlluY
Content-Type: multipart/mixed; boundary="y3JPpbATEgTWNhs3bOFLoYwFC1heqkXvP"

--y3JPpbATEgTWNhs3bOFLoYwFC1heqkXvP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/16/20 10:23 AM, Pierre Morel wrote:
> Hi All,
>=20
> This new respin of the series add modifications to
> - patch 9: s390x: css: ssch/tsch with sense and interrupt
> Other patches did not change.
>=20
> Recall:
>=20
> Goal of the series is to have a framework to test Channel-Subsystem I/O=
 with
> QEMU/KVM.
>  =20
> To be able to support interrupt for CSS I/O and for SCLP we need to mod=
ify
> the interrupt framework to allow re-entrant interruptions.
>  =20
> We add a registration for IRQ callbacks to the test program to define i=
ts own
> interrupt handler. We need to do special work under interrupt like ackn=
owledging
> the interrupt.
>  =20
> This series presents three tests:
> - Enumeration:
>         The CSS is enumerated using the STSCH instruction recursively o=
n all
>         potentially existing channels.
>         Keeping the first channel found as a reference for future use.
>         Checks STSCH
> =20
> - Enable:
>         If the enumeration succeeded the tests enables the reference
>         channel with MSCH and verifies with STSCH that the channel is
>         effectively enabled, retrying a predefined count on failure
> 	to enable the channel
>         Checks MSCH      =20
> =20
> - Sense:
>         If the channel is enabled this test sends a SENSE_ID command
>         to the reference channel, analyzing the answer and expecting
>         the Control unit type being 0x3832, a.k.a. virtio-ccw.
>         Checks SSCH(READ) and IO-IRQ
>=20
> Note:
> - The following 5 patches are general usage and may be pulled first:
>   s390x: saving regs for interrupts
>   s390x: I/O interrupt registration
>   s390x: export the clock get_clock_ms() utility
>   s390x: clock and delays calculations
>   s390x: define function to wait for interrupt
>=20
> - These 4 patches are really I/O oriented:
>   s390x: Library resources for CSS tests
>   s390x: css: stsch, enumeration test
>   s390x: css: msch, enable test
>   s390x: css: ssch/tsch with sense and interrupt
>=20
> Regards,
> Pierre

Thanks, picked

>=20
> Pierre Morel (9):
>   s390x: saving regs for interrupts
>   s390x: I/O interrupt registration
>   s390x: export the clock get_clock_ms() utility
>   s390x: clock and delays calculations
>   s390x: define function to wait for interrupt
>   s390x: Library resources for CSS tests
>   s390x: css: stsch, enumeration test
>   s390x: css: msch, enable test
>   s390x: css: ssch/tsch with sense and interrupt
>=20
>  lib/s390x/asm/arch_def.h |  14 ++
>  lib/s390x/asm/time.h     |  50 ++++++
>  lib/s390x/css.h          | 294 +++++++++++++++++++++++++++++++++++
>  lib/s390x/css_dump.c     | 152 ++++++++++++++++++
>  lib/s390x/css_lib.c      | 323 +++++++++++++++++++++++++++++++++++++++=

>  lib/s390x/interrupt.c    |  23 ++-
>  lib/s390x/interrupt.h    |   8 +
>  s390x/Makefile           |   3 +
>  s390x/css.c              | 150 ++++++++++++++++++
>  s390x/cstart64.S         |  41 ++++-
>  s390x/intercept.c        |  11 +-
>  s390x/unittests.cfg      |   4 +
>  12 files changed, 1060 insertions(+), 13 deletions(-)
>  create mode 100644 lib/s390x/asm/time.h
>  create mode 100644 lib/s390x/css.h
>  create mode 100644 lib/s390x/css_dump.c
>  create mode 100644 lib/s390x/css_lib.c
>  create mode 100644 lib/s390x/interrupt.h
>  create mode 100644 s390x/css.c
>=20



--y3JPpbATEgTWNhs3bOFLoYwFC1heqkXvP--

--ZyXOvTUTP9Fn6MPQEiv8Tq2eVqjiFlluY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl8W6ZkACgkQ41TmuOI4
ufiyRw/+MB+u0jg5fpYEgzxYMkkT6Gs/42LqNsXgI6csqK15E0qTpp0gCT8TRBuw
YMr6zNQd3SR2umnz6SG2WdfzNe66lpNlpUK14Y6ajT455haufascmAOj2dGNc4F/
4owWLz/nqYWAV02pVH0WxvQadZ+c+jrxYpwNsSGe+NsyTL1pqPfIgsfwM0tY0+KH
U6WIEjCpe8rTOXDR9y3kAnOGY1ymAf4SA61PKlYEr1xdFfN+y4IYv/UOBaR6F7jM
LCJre+d262ibUETC+n/JYdBpuKefhUponX1M38wjnXlzwHR9Oy2oHmzYkWLpLG8B
gbI1oT3a4s2yWj1e8tcuy4vRWJ89nvejmh4w4ON8rrb4sYVpsWwDsfaM1XlFmRFK
IgvoRaPURD1Y0lrORGdZimBHGQnsOOotfGyt/p5f5ZSK8tTj8odxhP+sjIF6xpI3
Dpei24kEl3Kf6eOsqeUgdNrD6qcZkYe7ShCQJqzkTT9AC24BS/65bEvOO5YGSgao
HtJVo88HigLWuMJLA3dyOL77TRY4vXZD1uI+/xHcT2+NXOi8CtM3th3E2ZSkLw8w
lTWJ1RF1B/SCtrTdugQyN1IUHV6HajuUCi4GBCvdTofl8n/+/3Pi41pBPRDHB4wZ
PKmqLdX8tsowl8HcWCjaWhUPMOUGQDc1AbgLHJDjr9uUS6Cz8uw=
=CjRC
-----END PGP SIGNATURE-----

--ZyXOvTUTP9Fn6MPQEiv8Tq2eVqjiFlluY--

