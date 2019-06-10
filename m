Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2754B3BF9F
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 00:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390387AbfFJWyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 18:54:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56178 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390301AbfFJWyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 18:54:55 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 41B4C13AAE;
        Mon, 10 Jun 2019 22:54:49 +0000 (UTC)
Received: from [10.3.116.85] (ovpn-116-85.phx2.redhat.com [10.3.116.85])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 080F519C59;
        Mon, 10 Jun 2019 22:54:45 +0000 (UTC)
Subject: Re: [Qemu-devel] kvm / virsh snapshot management
To:     Gary Dale <gary@extremeground.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Kevin Wolf <kwolf@redhat.com>, John Snow <jsnow@redhat.com>,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <abb7990e-0331-67a4-af92-05276366478c@extremeground.com>
 <20190610121941.GI14257@stefanha-x1.localdomain>
 <dc7a70ea-c94f-e975-df44-b0199da698e2@extremeground.com>
 <28719bbe-fcce-9e37-f146-ad6ce3edda51@redhat.com>
 <976b1c32-a7ff-fbfd-9176-040c61649cb7@extremeground.com>
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
Message-ID: <e9165f13-7c4d-584d-6934-d9d89eca26cc@redhat.com>
Date:   Mon, 10 Jun 2019 17:54:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <976b1c32-a7ff-fbfd-9176-040c61649cb7@extremeground.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ci01lKIQK6dBtBntGBUl0tG20rh1iYNha"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 10 Jun 2019 22:54:54 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ci01lKIQK6dBtBntGBUl0tG20rh1iYNha
Content-Type: multipart/mixed; boundary="6WZD6ibWulGMtUKZUQVo7Uq07Ol8rKujb";
 protected-headers="v1"
From: Eric Blake <eblake@redhat.com>
To: Gary Dale <gary@extremeground.com>, Stefan Hajnoczi <stefanha@gmail.com>
Cc: Kevin Wolf <kwolf@redhat.com>, John Snow <jsnow@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
Message-ID: <e9165f13-7c4d-584d-6934-d9d89eca26cc@redhat.com>
Subject: Re: [Qemu-devel] kvm / virsh snapshot management
References: <abb7990e-0331-67a4-af92-05276366478c@extremeground.com>
 <20190610121941.GI14257@stefanha-x1.localdomain>
 <dc7a70ea-c94f-e975-df44-b0199da698e2@extremeground.com>
 <28719bbe-fcce-9e37-f146-ad6ce3edda51@redhat.com>
 <976b1c32-a7ff-fbfd-9176-040c61649cb7@extremeground.com>
In-Reply-To: <976b1c32-a7ff-fbfd-9176-040c61649cb7@extremeground.com>

--6WZD6ibWulGMtUKZUQVo7Uq07Ol8rKujb
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/10/19 5:47 PM, Gary Dale wrote:

>>>
>>> Since blockcommit would make it impossible for me to revert to an
>>> earlier state (because I'm committing the oldest snapshot, if it scre=
ws
>>> up, I can't undo within virsh), I need to make sure this command is
>>> correct.
>>>
>>>
> Interesting. Your comments are quite different from what the Redhat

It's "Red Hat", two words :)

> online documentation suggests. It spends some time talking about
> flattening the chains (e.g.
> https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/=
6/html/virtualization_administration_guide/sub-sect-domain_commands-using=
_blockcommit_to_shorten_a_backing_chain)

That is all about external snapshot file chains (Red Hat specifically
discourages the use of internal snapshots).

> while you are saying the chains don't exist. I gather this is because
> Redhat doesn't like internal snapshots, so they focus purely on
> documenting external ones.
>=20
> It does strike me as a little bizarre to handle internal and external
> snapshots differently since the essential difference only seems to be
> where the data is stored. Using chains for one and reference counts for=

> the other sounds like a recipe for for things not working right.

If nothing else, it's a reason WHY Red Hat discourages the use of
internal snapshots.

>=20
> Anyway, if I understand what you are saying, with internal snapshots, i=

> can simply delete old ones and create new ones without worrying about
> there being any performance penalty. All internal snapshots are one hop=

> away from the base image.

Still not quite right. All internal snapshots ARE a complete base image,
they do not track a delta from any other point in time, but rather the
complete disk contents of the point in time in question.

Yes, you can delete internal snapshots at will, because nothing else
depends on them. We don't yet have good code for compacting unused
portions of a qcow2 image, though, so your file size may still appear
larger than necessary (hopefully it's sparse, though, so not actually
consuming extra storage).

Also, don't try to mix-and-match internal and external snapshots on a
single guest image - once you've used one style, trying to switch to the
other can cause data loss if you aren't precise about which files
require which clusters to stick around.

--=20
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org


--6WZD6ibWulGMtUKZUQVo7Uq07Ol8rKujb--

--ci01lKIQK6dBtBntGBUl0tG20rh1iYNha
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEccLMIrHEYCkn0vOqp6FrSiUnQ2oFAlz+37UACgkQp6FrSiUn
Q2rH/wf+MoMA4THerVRu+yRp2bZmdCZLNq2OlUpwfL12G64Bv76bQaXAfmcJkKcw
ph+CIQc8H7vq5hlP7efL4IXeWvcZIeZ5ie/oO9PXwXbTh9eYdHXyAPQSuPYpPwAu
/OYLIXuWx5NRSF2PtZAPgI/9CJI1/+QWDqpy6IqRpARfxUw11mSaREsCjCj4Hv1M
nBy51LzOtgwSTGawc+AByTD5W/dU0MwlzA4Wx9Oh5Od16N8aTX3LY4U5jJOPgTnI
mq6kPfCGbdfqL3kC8hLkVDB/CP1OA6Xj61Tp21sfxncfQkLfTI8AjJTBope5Wtdn
VO5tWz72XTKFRzi8S9+yJyP8WulGdg==
=3PTP
-----END PGP SIGNATURE-----

--ci01lKIQK6dBtBntGBUl0tG20rh1iYNha--
