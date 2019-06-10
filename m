Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1866F3B490
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2019 14:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389892AbfFJMTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 08:19:46 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:40663 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388952AbfFJMTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 08:19:46 -0400
Received: by mail-wr1-f44.google.com with SMTP id p11so8950451wre.7
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2019 05:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JYGZkYAD5n3RO12D0esSv14MauJq3BjWwsP8BdIX/Z4=;
        b=uD8mOrgo2XyXG3U7b2cCUIaz+vfdMITxUmHsIJcq8v8R+XlsA7H1rs3xGTO2bFtCbB
         B1bHC9k3+n9yfCmfhrSQvkLYod5CCPkH9U0Y6XFUNynPHKdz6otydp97fkkDfsyrh7/x
         4ekSjetOcsTNdtvohKI7k2t6NV7ech28ytkkNxoQSwilJ0xL1ObXJFHP+JiYF6nH7b8o
         Tye571me1awLkM/2BUIBf3JcSYMTz5Wc7DPXAFIijGgr/rfbcesWx/O9LS7s/s/jquQl
         88Tz8THc96tjON28T92tC4IRCcZ0XdXT6zDgSLEbydwPYna0TzN+KjNWtlpl/yL+aVvS
         XIhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JYGZkYAD5n3RO12D0esSv14MauJq3BjWwsP8BdIX/Z4=;
        b=Ld55+KishqbDAVksnAjHBGbppneUTTzG8hFM0wREdwwFX9SyWFSkkfbTNmLIJd1b+P
         DvN8SOD/EvyBkjU1tETeXk14YU3b5ZXHR5hbeUWmC/qNZJwCz1RZmeyko2aovHMZHnZF
         2L3T12rpt/ioJqh3EEJAS3+f8mVxzbAbqOQP3v+dVjtzBA59/Ymx9/bKhnDKrF3aBXSt
         1OPrIKttXks3vVfhy5IdYgIMpljQlUKONbevu4gRiGzjq9zsui7wSSTYJSCrcuUBhS/1
         +SkFbRWWaogZ1aWEB/2HVPiPKbLlC5pPnVtl3qWcVWubRMH847sHgs4F9Q7zIyTinqsP
         cRvw==
X-Gm-Message-State: APjAAAU0WISAN9fkUZUbv0jaa09Qv6Ac57DmJnPpRgI+tCoCw/M3BXjT
        iZZYDwkB0WsfCeYVY1/4tcc590GmjXHirw==
X-Google-Smtp-Source: APXvYqxs50R6D1XDTR8BN2WQC49+42ud9XgEr3bP4A7iMC6z/GjWOTI3JN2Qn7j+CVAAGJAKssbsjw==
X-Received: by 2002:a5d:51cb:: with SMTP id n11mr5406170wrv.143.1560169183597;
        Mon, 10 Jun 2019 05:19:43 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id u5sm13445392wmc.32.2019.06.10.05.19.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 05:19:42 -0700 (PDT)
Date:   Mon, 10 Jun 2019 13:19:41 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Gary Dale <gary@extremeground.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Kevin Wolf <kwolf@redhat.com>, John Snow <jsnow@redhat.com>
Subject: Re: kvm / virsh snapshot management
Message-ID: <20190610121941.GI14257@stefanha-x1.localdomain>
References: <abb7990e-0331-67a4-af92-05276366478c@extremeground.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8/UBlNHSEJa6utmr"
Content-Disposition: inline
In-Reply-To: <abb7990e-0331-67a4-af92-05276366478c@extremeground.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--8/UBlNHSEJa6utmr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 01, 2019 at 08:12:01PM -0400, Gary Dale wrote:
> A while back I converted a raw disk image to qcow2 to be able to use
> snapshots. However I realize that I may not really understand exactly how
> snapshots work. In this particular case, I'm only talking about internal
> snapshots currently as there seems to be some differences of opinion as to
> whether internal or external are safer/more reliable. I'm also only talki=
ng
> about shutdown state snapshots, so it should just be the disk that is
> snapshotted.
>=20
> As I understand it, the first snapshot freezes the base image and subsequ=
ent
> changes in the virtual machine's disk are stored elsewhere in the qcow2 f=
ile
> (remember, only internal snapshots). If I take a second snapshot, that
> freezes the first one, and subsequent changes are now in third location.
> Each new snapshot is incremental to the one that preceded it rather than
> differential to the base image. Each new snapshot is a child of the previ=
ous
> one.

Internal snapshots are not incremental or differential at the qcow2
level, they are simply a separate L1/L2 table pointing to data clusters.
In other words, they are an independent set of metadata showing the full
state of the image at the point of the snapshot.  qcow2 does not track
relationships between snapshots and parents/children.

>=20
> One explanation I've seen of the process is if I delete a snapshot, the
> changes it contains are merged with its immediate child.

Nope.  Deleting a snapshot decrements the reference count on all its
data clusters.  If a data cluster's reference count reaches zero it will
be freed.  That's all, there is no additional data movement or
reorganization aside from this.

> So if I deleted the
> first snapshot, the base image stays the same but any data that has chang=
ed
> since the base image is now in the second snapshot's location. The merge
> with children explanation also implies that the base image is never touch=
ed
> even if the first snapshot is deleted.
>=20
> But if I delete a snapshot that has no children, is that essentially the
> same as reverting to the point that snapshot was created and all subseque=
nt
> disk changes are lost? Or does it merge down to the parent snapshot? If I
> delete all snapshots, would that revert to the base image?

No.  qcow2 has the concept of the current disk state of the running VM -
what you get when you boot the guest - and the snapshots - they are
read-only.

When you delete snapshots the current disk state (running VM) is
unaffected.

When you apply a snapshot this throws away the current disk state and
uses the snapshot as the new current disk state.  The read-only snapshot
itself is not modified in any way and you can apply the same snapshot
again as many times as you wish later.

>=20
> I've seen it explained that a snapshot is very much like a timestamp so
> deleting a timestamp removes the dividing line between writes that occurr=
ed
> before and after that time, so that data is really only removed if I reve=
rt
> to some time stamp - all writes after that point are discarded. In this
> explanation, deleting the oldest timestamp is essentially updating the ba=
se
> image. Deleting all snapshots would leave me with the base image fully
> updated.
>=20
> Frankly, the second explanation sounds more reasonable to me, without hav=
ing
> to figure out how copy-on-write works,=A0 But I'm dealing with important =
data
> here and I don't want to mess it up by mishandling the snapshots.
>=20
> Can some provide a little clarity on this? Thanks!

If you want an analogy then git(1) is a pretty good one.  qcow2 internal
snapshots are like git tags.  Unlike branches, tags are immutable.  In
qcow2 you only have a master branch (the current disk state) from which
you can create a new tag or you can use git-checkout(1) to apply a
snapshot (discarding whatever your current disk state is).

Stefan

--8/UBlNHSEJa6utmr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAlz+St0ACgkQnKSrs4Gr
c8jLBwf9EADjPYBGSLRi0QAOiT6zoiTfGJS1yHW0HIphH6L3Fcy9DVm3Qrv3yhG6
r/w4g8HAigy9m1GIwVSy5sLADysfNSK4kxtZ8Hna8a0rjv1fq7ZSdOBSFc0wwK7Y
s047y4UIlH+wdmQktAtV2F3KFjE6zmS0MWZbHK+rFfg11AjFDGvHiiOYl8wGY10V
vz+OyIJILYjtsUn4RYYAJUB/3XlJZ6CScqoRPBBa9bkfkzUMG3SUPjOyWWPFsRgm
TS7kjiNP3AEvFDNVtuhfLFvAbWnjinW1Wg9NP9zFuzg8tihLK3az7Rer4IpL1Goe
glLXb1p7ROzTvcW/k6JZ02CrZHbGzQ==
=X0dh
-----END PGP SIGNATURE-----

--8/UBlNHSEJa6utmr--
