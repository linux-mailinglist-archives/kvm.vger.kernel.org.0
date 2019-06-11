Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB4653C058
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 02:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389750AbfFKALD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 20:11:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35844 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388749AbfFKALD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 20:11:03 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0481E811D8;
        Tue, 11 Jun 2019 00:10:54 +0000 (UTC)
Received: from [10.3.116.85] (ovpn-116-85.phx2.redhat.com [10.3.116.85])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7504B19C68;
        Tue, 11 Jun 2019 00:10:48 +0000 (UTC)
Subject: Re: [Qemu-devel] kvm / virsh snapshot management
To:     Gary Dale <gary@extremeground.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Kevin Wolf <kwolf@redhat.com>, John Snow <jsnow@redhat.com>,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <abb7990e-0331-67a4-af92-05276366478c@extremeground.com>
 <20190610121941.GI14257@stefanha-x1.localdomain>
 <dc7a70ea-c94f-e975-df44-b0199da698e2@extremeground.com>
 <ab3e81c2-f0ce-2ef5-bbe7-948a87463b59@extremeground.com>
 <edf57b3a-660c-0964-2455-9461b9aa2711@redhat.com>
 <33b31422-1198-783a-cb15-8687a3f30199@extremeground.com>
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
Message-ID: <0cd5c326-4d69-92fd-406d-d9fb8b08ccfc@redhat.com>
Date:   Mon, 10 Jun 2019 19:10:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <33b31422-1198-783a-cb15-8687a3f30199@extremeground.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FSCzbwHXtR4FuKnBVd262Fjywg2C0DjUS"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 11 Jun 2019 00:11:02 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FSCzbwHXtR4FuKnBVd262Fjywg2C0DjUS
Content-Type: multipart/mixed; boundary="hWWBCJUg7xKfImdPVdCnJH2OkuF7oL8A8";
 protected-headers="v1"
From: Eric Blake <eblake@redhat.com>
To: Gary Dale <gary@extremeground.com>, Stefan Hajnoczi <stefanha@gmail.com>
Cc: Kevin Wolf <kwolf@redhat.com>, John Snow <jsnow@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
Message-ID: <0cd5c326-4d69-92fd-406d-d9fb8b08ccfc@redhat.com>
Subject: Re: [Qemu-devel] kvm / virsh snapshot management
References: <abb7990e-0331-67a4-af92-05276366478c@extremeground.com>
 <20190610121941.GI14257@stefanha-x1.localdomain>
 <dc7a70ea-c94f-e975-df44-b0199da698e2@extremeground.com>
 <ab3e81c2-f0ce-2ef5-bbe7-948a87463b59@extremeground.com>
 <edf57b3a-660c-0964-2455-9461b9aa2711@redhat.com>
 <33b31422-1198-783a-cb15-8687a3f30199@extremeground.com>
In-Reply-To: <33b31422-1198-783a-cb15-8687a3f30199@extremeground.com>

--hWWBCJUg7xKfImdPVdCnJH2OkuF7oL8A8
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/10/19 6:00 PM, Gary Dale wrote:

>>> Any ideas on what I'm doing wrong?
>> Do you know for sure whether you have internal or external snapshots?
>> And at this point, your questions are starting to wander more into
>> libvirt territory.
>>
> Yes. I'm using internal snapshots. From your other e-mail, I gather tha=
t
> the (only) benefit to blockcommit with internal snapshots would be to
> reduce the size of the various tables recording changed blocks. Without=

> a blockcommit, the L1 tables get progressively larger over time since
> they record all changes to the base file. Eventually the snapshots coul=
d
> become larger than the base image if I don't do a blockcommit.

Not quite. Blockcommit requires external images. It says to take this
image chain:

base <- active

and change it into this shorter chain:

base

by moving the cluster from active into base.  There is no such thing as
blockcommit on internal snapshots, because you don't have any backing
file to push into.

With internal snapshots, the longer an L1 table is active, the more
clusters you have to change compared to what was the case before the
snapshot was created - every time you change an existing cluster, the
refcount on the old cluster decreases and the change gets written into a
new cluster with refcount 1.  Yes, you can reach the point where there
are more clusters with refcount 1 associated with your current L1 table
than there are clusters with refcount > 1 that are shared with one or
more previous internal snapshots. But they are not recording a change to
the base file, rather, they are recording the current state of the file
where an internal snapshot says to not forget the old state of the file.
 And yes, a qcow2 file with internal snapshots can require more disk
space than the amount of space exposed to the guest.  But that's true
too with external snapshots (the sum of the space required by all images
in the chain may be larger than the space visible to the guest).

--=20
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org


--hWWBCJUg7xKfImdPVdCnJH2OkuF7oL8A8--

--FSCzbwHXtR4FuKnBVd262Fjywg2C0DjUS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEccLMIrHEYCkn0vOqp6FrSiUnQ2oFAlz+8YcACgkQp6FrSiUn
Q2r4cwf/ZwXsp7ZD4msbrRp3VpMgptdo1XwjvZn/SD8qVXLmaQ/+POcPPojOinXD
kkyGkrDXfveksaBqQ7+A+Q0igUpaEzp305m1ntNXUbx8mTNTM9pTwtEj4w2ChxRI
UyYy+UmqZWcr1ERRZtQObBfL36iK1HkCOOPg+a010OBu0tyYGvuPJc26POCtnZMH
5YKeuxf+h9FMU+tc+BXRjnB8UjDr0Vpb08JbS/tu1ffSMB/gCj+OCH73PQVvmTXA
sss1vN1kJZDeRoHSgJDcUlwLdZroyGrP2Q1fmP0kI+HB1g8LIsdf6D0PMCZel97/
wR73RPPDoyAWyrtm0tKYsGjvv/VgpA==
=e/v6
-----END PGP SIGNATURE-----

--FSCzbwHXtR4FuKnBVd262Fjywg2C0DjUS--
