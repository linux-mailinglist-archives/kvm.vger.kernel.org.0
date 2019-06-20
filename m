Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CACD64DA07
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 21:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbfFTTNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 15:13:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbfFTTNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 15:13:49 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B316586658;
        Thu, 20 Jun 2019 19:13:48 +0000 (UTC)
Received: from [10.3.116.44] (ovpn-116-44.phx2.redhat.com [10.3.116.44])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 31E261001B3D;
        Thu, 20 Jun 2019 19:13:48 +0000 (UTC)
Subject: Re: [Qemu-devel] [RFC PATCH v1 08/12] target.json: add
 migrate-set-sev-info command
To:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Cc:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20190620180247.8825-1-brijesh.singh@amd.com>
 <20190620180247.8825-9-brijesh.singh@amd.com>
From:   Eric Blake <eblake@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=eblake@redhat.com; keydata=
 xsBNBEvHyWwBCACw7DwsQIh0kAbUXyqhfiKAKOTVu6OiMGffw2w90Ggrp4bdVKmCaEXlrVLU
 xphBM8mb+wsFkU+pq9YR621WXo9REYVIl0FxKeQo9dyQBZ/XvmUMka4NOmHtFg74nvkpJFCD
 TUNzmqfcjdKhfFV0d7P/ixKQeZr2WP1xMcjmAQY5YvQ2lUoHP43m8TtpB1LkjyYBCodd+LkV
 GmCx2Bop1LSblbvbrOm2bKpZdBPjncRNob73eTpIXEutvEaHH72LzpzksfcKM+M18cyRH+nP
 sAd98xIbVjm3Jm4k4d5oQyE2HwOur+trk2EcxTgdp17QapuWPwMfhaNq3runaX7x34zhABEB
 AAHNHkVyaWMgQmxha2UgPGVibGFrZUByZWRoYXQuY29tPsLAegQTAQgAJAIbAwULCQgHAwUV
 CgkICwUWAgMBAAIeAQIXgAUCS8fL9QIZAQAKCRCnoWtKJSdDahBHCACbl/5FGkUqJ89GAjeX
 RjpAeJtdKhujir0iS4CMSIng7fCiGZ0fNJCpL5RpViSo03Q7l37ss+No+dJI8KtAp6ID+PMz
 wTJe5Egtv/KGUKSDvOLYJ9WIIbftEObekP+GBpWP2+KbpADsc7EsNd70sYxExD3liwVJYqLc
 Rw7so1PEIFp+Ni9A1DrBR5NaJBnno2PHzHPTS9nmZVYm/4I32qkLXOcdX0XElO8VPDoVobG6
 gELf4v/vIImdmxLh/w5WctUpBhWWIfQDvSOW2VZDOihm7pzhQodr3QP/GDLfpK6wI7exeu3P
 pfPtqwa06s1pae3ad13mZGzkBdNKs1HEm8x6zsBNBEvHyWwBCADGkMFzFjmmyqAEn5D+Mt4P
 zPdO8NatsDw8Qit3Rmzu+kUygxyYbz52ZO40WUu7EgQ5kDTOeRPnTOd7awWDQcl1gGBXgrkR
 pAlQ0l0ReO57Q0eglFydLMi5bkwYhfY+TwDPMh3aOP5qBXkm4qIYSsxb8A+i00P72AqFb9Q7
 3weG/flxSPApLYQE5qWGSXjOkXJv42NGS6o6gd4RmD6Ap5e8ACo1lSMPfTpGzXlt4aRkBfvb
 NCfNsQikLZzFYDLbQgKBA33BDeV6vNJ9Cj0SgEGOkYyed4I6AbU0kIy1hHAm1r6+sAnEdIKj
 cHi3xWH/UPrZW5flM8Kqo14OTDkI9EtlABEBAAHCwF8EGAEIAAkFAkvHyWwCGwwACgkQp6Fr
 SiUnQ2q03wgAmRFGDeXzc58NX0NrDijUu0zx3Lns/qZ9VrkSWbNZBFjpWKaeL1fdVeE4TDGm
 I5mRRIsStjQzc2R9b+2VBUhlAqY1nAiBDv0Qnt+9cLiuEICeUwlyl42YdwpmY0ELcy5+u6wz
 mK/jxrYOpzXKDwLq5k4X+hmGuSNWWAN3gHiJqmJZPkhFPUIozZUCeEc76pS/IUN72NfprZmF
 Dp6/QDjDFtfS39bHSWXKVZUbqaMPqlj/z6Ugk027/3GUjHHr8WkeL1ezWepYDY7WSoXwfoAL
 2UXYsMAr/uUncSKlfjvArhsej0S4zbqim2ZY6S8aRWw94J3bSvJR+Nwbs34GPTD4Pg==
Organization: Red Hat, Inc.
Message-ID: <7bade677-369a-74a5-206d-700626354028@redhat.com>
Date:   Thu, 20 Jun 2019 14:13:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190620180247.8825-9-brijesh.singh@amd.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HT5oiFuDHqTpFzZJq8r8VecoG1ZuYpWHN"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 20 Jun 2019 19:13:48 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HT5oiFuDHqTpFzZJq8r8VecoG1ZuYpWHN
Content-Type: multipart/mixed; boundary="zyUtaKnKeLzTdbH9FJhS6DBf7kGrBWcBY";
 protected-headers="v1"
From: Eric Blake <eblake@redhat.com>
To: "Singh, Brijesh" <brijesh.singh@amd.com>,
 "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Cc: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Message-ID: <7bade677-369a-74a5-206d-700626354028@redhat.com>
Subject: Re: [Qemu-devel] [RFC PATCH v1 08/12] target.json: add
 migrate-set-sev-info command
References: <20190620180247.8825-1-brijesh.singh@amd.com>
 <20190620180247.8825-9-brijesh.singh@amd.com>
In-Reply-To: <20190620180247.8825-9-brijesh.singh@amd.com>

--zyUtaKnKeLzTdbH9FJhS6DBf7kGrBWcBY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/20/19 1:03 PM, Singh, Brijesh wrote:
> The command can be used by the hypervisor to specify the target Platfor=
m
> Diffie-Hellman key (PDH) and certificate chain before starting the SEV
> guest migration. The values passed through the command will be used whi=
le
> creating the outgoing encryption context.
>=20
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  qapi/target.json       | 18 ++++++++++++++++++
>  target/i386/monitor.c  | 10 ++++++++++
>  target/i386/sev-stub.c |  5 +++++
>  target/i386/sev.c      | 11 +++++++++++
>  target/i386/sev_i386.h |  9 ++++++++-
>  5 files changed, 52 insertions(+), 1 deletion(-)
>=20

> +++ b/qapi/target.json
> @@ -512,3 +512,21 @@
>  ##
>  { 'command': 'query-cpu-definitions', 'returns': ['CpuDefinitionInfo']=
,
>    'if': 'defined(TARGET_PPC) || defined(TARGET_ARM) || defined(TARGET_=
I386) || defined(TARGET_S390X) || defined(TARGET_MIPS)' }
> +
> +##
> +# @migrate-set-sev-info:
> +#
> +# The command is used to provide the target host information used duri=
ng the
> +# SEV guest.
> +#
> +# @pdh the target host platform diffie-hellman key encoded in base64
> +#
> +# @plat-cert the target host platform certificate chain encoded in bas=
e64
> +#
> +# @amd-cert AMD certificate chain which include ASK and OCA encoded in=
 base64
> +#
> +# Since 4.3

The next release is 4.1, then likely 4.2 near the end of the calendar
year, then 5.0 in 2020. There is no planned 4.3 release.  Are you trying
to get this in 4.1?

--=20
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org


--zyUtaKnKeLzTdbH9FJhS6DBf7kGrBWcBY--

--HT5oiFuDHqTpFzZJq8r8VecoG1ZuYpWHN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEccLMIrHEYCkn0vOqp6FrSiUnQ2oFAl0L2usACgkQp6FrSiUn
Q2pfVQf/ZSvpP+buwgOeo2OL7Ok5SYhMJZEYyJaLP92CSx97u+ZEZgZWrs2vFo3w
MHH+qg3xYveSypYDidljaAuJWyy7bmtF0hz4fK3Ol8wcicZ7IX2+Jjg9OUZlnvc0
igaUjglcpuUH+kFo6a5BvPjgTwi+b9201W2AykAaTe4Hf3rxKXi22oJWvbotfajJ
KGehyRxOCBaeAE8G8ghEdEXn9T/dPwFujIEvMX1QPiDw3obMynrwmKDoL+DW9jlI
JV1k8ptRxUB+BWPA0QtkcqD5EGmEMfRddG4fqbx73EW2J1XuBLA923uqoSa17NvF
I0wrB4JV6MP1SjEVqPhJZeotUNEgUA==
=SYnb
-----END PGP SIGNATURE-----

--HT5oiFuDHqTpFzZJq8r8VecoG1ZuYpWHN--
