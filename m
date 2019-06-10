Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC3643BF1C
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 00:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389877AbfFJWFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 18:05:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389083AbfFJWFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 18:05:02 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DF6FA8552E;
        Mon, 10 Jun 2019 22:05:01 +0000 (UTC)
Received: from [10.3.116.85] (ovpn-116-85.phx2.redhat.com [10.3.116.85])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 032E15DA2E;
        Mon, 10 Jun 2019 22:04:58 +0000 (UTC)
Subject: Re: [Qemu-devel] kvm / virsh snapshot management
To:     Gary Dale <gary@extremeground.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Kevin Wolf <kwolf@redhat.com>, John Snow <jsnow@redhat.com>,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <abb7990e-0331-67a4-af92-05276366478c@extremeground.com>
 <20190610121941.GI14257@stefanha-x1.localdomain>
 <dc7a70ea-c94f-e975-df44-b0199da698e2@extremeground.com>
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
Message-ID: <28719bbe-fcce-9e37-f146-ad6ce3edda51@redhat.com>
Date:   Mon, 10 Jun 2019 17:04:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <dc7a70ea-c94f-e975-df44-b0199da698e2@extremeground.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="X4susEw3dDp7o8dD2P0cjEPmUpmuecXf8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 10 Jun 2019 22:05:01 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--X4susEw3dDp7o8dD2P0cjEPmUpmuecXf8
Content-Type: multipart/mixed; boundary="LgO3XgplPUzy2Wffs5YirAL6i00W4PqiA";
 protected-headers="v1"
From: Eric Blake <eblake@redhat.com>
To: Gary Dale <gary@extremeground.com>, Stefan Hajnoczi <stefanha@gmail.com>
Cc: Kevin Wolf <kwolf@redhat.com>, John Snow <jsnow@redhat.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
Message-ID: <28719bbe-fcce-9e37-f146-ad6ce3edda51@redhat.com>
Subject: Re: [Qemu-devel] kvm / virsh snapshot management
References: <abb7990e-0331-67a4-af92-05276366478c@extremeground.com>
 <20190610121941.GI14257@stefanha-x1.localdomain>
 <dc7a70ea-c94f-e975-df44-b0199da698e2@extremeground.com>
In-Reply-To: <dc7a70ea-c94f-e975-df44-b0199da698e2@extremeground.com>

--LgO3XgplPUzy2Wffs5YirAL6i00W4PqiA
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/10/19 10:54 AM, Gary Dale wrote:

>>> One explanation I've seen of the process is if I delete a snapshot, t=
he
>>> changes it contains are merged with its immediate child.
>> Nope.=A0 Deleting a snapshot decrements the reference count on all its=

>> data clusters.=A0 If a data cluster's reference count reaches zero it =
will
>> be freed.=A0 That's all, there is no additional data movement or
>> reorganization aside from this.
> Perhaps not physically but logically it would appear that the data
> clusters were merged.

No.

If I have an image that starts out as all blanks, then write to part of
it (top line showing cluster number, bottom line showing representative
data):

012345
AA----

then take internal snapshot S1, then write more:

ABB---

then take another internal snapshot S2, then write even more:

ABCC--

the single qcow2 image will have something like:

L1 table for S1 =3D> {
  guest cluster 0 =3D> host cluster 5 refcount 3 content A
  guest cluster 1 =3D> host cluster 6 refcount 1 content A
}
L1 table for S2 =3D> {
  guest cluster 0 =3D> host cluster 5 refcount 3 content A
  guest cluster 1 =3D> host cluster 7 refcount 2 content B
  guest cluster 2 =3D> host cluster 8 refcount 1 content B
}
L1 table for active image =3D> {
  guest cluster 0 =3D> host cluster 5 refcount 3 content A
  guest cluster 1 =3D> host cluster 7 refcount 2 content B
  guest cluster 2 =3D> host cluster 9 refcount 1 content C
  guest cluster 3 =3D> host cluster 10 refcount 1 content C
}


If I then delete S2, I'm left with:

L1 table for S1 =3D> {
  guest cluster 0 =3D> host cluster 5 refcount 2 content A
  guest cluster 1 =3D> host cluster 6 refcount 1 content A
}
L1 table for active image =3D> {
  guest cluster 0 =3D> host cluster 5 refcount 2 content A
  guest cluster 1 =3D> host cluster 7 refcount 1 content B
  guest cluster 2 =3D> host cluster 9 refcount 1 content C
  guest cluster 3 =3D> host cluster 10 refcount 1 content C
}

and host cluster 8 is no longer in use.

Or, if I instead use external snapshots, I have a chain of images:

base <- mid <- active

L1 table for image base =3D> {
  guest cluster 0 =3D> host cluster 5 refcount 1 content A
  guest cluster 1 =3D> host cluster 6 refcount 1 content A
}
L1 table for image mid =3D> {
  guest cluster 1 =3D> host cluster 5 refcount 1 content B
  guest cluster 2 =3D> host cluster 6 refcount 1 content B
}
L1 table for image active =3D> {
  guest cluster 2 =3D> host cluster 5 refcount 1 content C
  guest cluster 3 =3D> host cluster 6 refcount 1 content C
}

If I then delete image mid, I can do so in one of two ways:

blockcommit mid into base:
base <- active
L1 table for image base =3D> {
  guest cluster 0 =3D> host cluster 5 refcount 1 content A
  guest cluster 1 =3D> host cluster 6 refcount 1 content B
  guest cluster 2 =3D> host cluster 7 refcount 1 content B
}
L1 table for image active =3D> {
  guest cluster 2 =3D> host cluster 5 refcount 1 content C
  guest cluster 3 =3D> host cluster 6 refcount 1 content C
}


blockpull mid into active:
base <- active
L1 table for image base =3D> {
  guest cluster 0 =3D> host cluster 5 refcount 1 content A
  guest cluster 1 =3D> host cluster 6 refcount 1 content A
}
L1 table for image active =3D> {
  guest cluster 1 =3D> host cluster 7 refcount 1 content B
  guest cluster 2 =3D> host cluster 5 refcount 1 content C
  guest cluster 3 =3D> host cluster 6 refcount 1 content C
}


>>> Can some provide a little clarity on this? Thanks!
>> If you want an analogy then git(1) is a pretty good one.=A0 qcow2 inte=
rnal
>> snapshots are like git tags.=A0 Unlike branches, tags are immutable.=A0=
 In
>> qcow2 you only have a master branch (the current disk state) from whic=
h
>> you can create a new tag or you can use git-checkout(1) to apply a
>> snapshot (discarding whatever your current disk state is).
>>
>> Stefan
>=20
> That's just making things less clear - I've never tried to understand
> git either. Thanks for the attempt though.
>=20
> If I've gotten things correct, once the base image is established, ther=
e
> is a current disk state that points to a table containing all the write=
s
> since the base image. Creating a snapshot essentially takes that pointe=
r
> and gives it the snapshot name, while creating a new current disk state=

> pointer and data table where subsequent writes are recorded.

Not quite. Rather, for internal snapshots, there is a table pointing to
ALL the contents that should be visible to the guest at that point in
time (one table for each snapshot, which is effectively read-only, and
one table for the active image, which is updated dynamically as guest
writes happen).  But the table does NOT track provenance of a cluster,
only a refcount.

>=20
> Deleting snapshots removes your ability to refer to a data table by
> name, but the table itself still exists anonymously as part of a chain
> of data tables between the base image and the current state.

Wrong for internal snapshots. There is no chain of data tables, and if a
cluster's refcount goes to 0, you no longer have access to the
information that the guest saw at the time that cluster was created.

Also wrong for external snapshots - there, you do have a chain of data
between images, but when you delete an external snapshot, you should
only do so after moving the relevant data elsewhere in the chain, at
which point you reduced the length of the chain.

>=20
> This leaves a problem. The chain will very quickly get quite long which=

> will impact performance. To combat this, you can use blockcommit to
> merge a child with its parent or blockpull to merge a parent with its
> child.

Wrong for internal snapshots, where blockcommit and blockpull do not
really work.

More accurate for external snapshots.

>=20
> In my situation, I want to keep a week of daily snapshots in case
> something goes horribly wrong with the VM (I recently had a database
> file become corrupt, and reverting to the previous working day's image
> would have been a quick and easy solution, faster than recovering all
> the data tables from the prefious day). I've been shutting down the VM,=

> deleting the oldest snapshot and creating a new one before restarting
> the VM.
>=20
> While your explanation confirms that this is safe, it also implies that=

> I need to manage the data table chains. My first instinct is to use
> blockcommit before deleting the oldest snapshot, such as:
>=20
> =A0=A0=A0 virsh blockcommit <vm name> <qcow2 file path> --top <oldest
> snapshot> --delete --wait
> =A0=A0=A0 virsh snapshot-delete=A0 --domain <vm name> --snapshotname <o=
ldest
> snapshot>
>=20
> so that the base image contains the state as of one week earlier and th=
e
> snapshot chains are limited to 7 links.
>=20
> 1) does this sound reasonable?

If you want to track WHICH clusters have changed since the last backup
(which is the goal of incremental/differential backups), you probably
also want to be using persistent bitmaps.  At the moment, internal
snapshots have very little upstream development compared to external
snapshots, and are less likely to have ways to do what you want.

>=20
> 2) I note that the syntax in virsh man page is different from the synta=
x
> at
> https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/=
7/html/virtualization_deployment_and_administration_guide/sect-backing-ch=
ain
> (RedHat uses --top and --base while the man page just has optional base=

> and top names). I believe the RedHat guide is correct because the man
> page doesn't allow distinguishing between the base and the top for a
> commit.

Questions about virsh are outside the realm of what qemu does (that's
what libvirt adds on top of qemu); and the parameters exposed by virsh
may differ according to what versions you are running. Also be aware
that I'm trying to get a new incremental backup API
virDomainBackupBegin() added to libvirt that will make support for
incremental/differential backups by using qcow2 persistent bitmaps much
easier from libvirt's point of use.

>=20
> However the need for specifying the path isn't obvious to me. Isn't the=

> path contained in the VM definition?
>=20
> Since blockcommit would make it impossible for me to revert to an
> earlier state (because I'm committing the oldest snapshot, if it screws=

> up, I can't undo within virsh), I need to make sure this command is
> correct.
>=20
>=20
>=20

--=20
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3226
Virtualization:  qemu.org | libvirt.org


--LgO3XgplPUzy2Wffs5YirAL6i00W4PqiA--

--X4susEw3dDp7o8dD2P0cjEPmUpmuecXf8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEccLMIrHEYCkn0vOqp6FrSiUnQ2oFAlz+1AoACgkQp6FrSiUn
Q2oolQf/Ykcts7UAoI/mtTNRyz/wsvH9E5Wq2X8zlFH9bT9l0n/7+qF7rKOURROM
skJz2DtbWmyOMOJ/kiNaC9j3BSf0eUFaoWet2vnAEtNBHQjQQUbAA74EvyBgDKEY
QPe2DLlc/rTQ/yDaZUtuY4ge/pfuCKwWB5C/mpH8CktU8bLTtGhG4hjLnV2Gqo4I
mgUYFHKyw1teCjCpcWhp7KHv7xSz0YmvwkSYMgXKR0oqoSwZx9z/nG0giD0PgK7Z
1034SXZCagBxhj/Zaq8zxpPPAbNWSLhIxDpwiu1ZhTLfkWHHg+tFFLgnX38UxYMv
O4DPAYttFfYKdu4TLNsxpT89rxdglg==
=W/w6
-----END PGP SIGNATURE-----

--X4susEw3dDp7o8dD2P0cjEPmUpmuecXf8--
