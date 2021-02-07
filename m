Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFA831274E
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 20:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhBGTtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 14:49:17 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:49371 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229445AbhBGTtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 14:49:15 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DYfpn2XcRz9sVr;
        Mon,  8 Feb 2021 06:48:33 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1612727313;
        bh=wl/S13xz9mOdUnm4g0maXyh7BN1T8qo7oiw7JVLhSPU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YSQBGtKBTke7q9FwNGStTYtqrEoZQI2AKwtdpCLI+t5r/omTlkY5YNbBKCHewF78e
         RdshWC46WmKH/U/mMZbUcHZUiB7BclURIvQ7U1WMLqFTnVrvJVdXSLUXtB4fiYNKK0
         br2CAp4Ei/9ByzIokFA5AjusGtgADQq4xotmxO5hqPGQpxg/KRz66Et3XiuX7nSEfm
         obVp00A/cf9f4blZ0tSBQPcByEwNjxNMHZIMgY6igB9dbU3U99XD+/Xy+iZw2KGT4z
         pnhm7xAVS5bMARwlB1fKuh9NaJXLX+yOX3Kuy8rka2GIEQtiUd7cEVlAmcC4pkrcjX
         +1G11NZWxs71Q==
Date:   Mon, 8 Feb 2021 06:48:32 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the kvm tree
Message-ID: <20210208064832.0624ac2e@canb.auug.org.au>
In-Reply-To: <cac800cb-2e3e-0849-1a97-ef10c29b4e10@redhat.com>
References: <20210205160224.279c6169@canb.auug.org.au>
        <cac800cb-2e3e-0849-1a97-ef10c29b4e10@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/VDLHhucgpPkXC8uKFUQHq0d";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/VDLHhucgpPkXC8uKFUQHq0d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

On Fri, 5 Feb 2021 11:08:39 +0100 Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 05/02/21 06:02, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > After merging the kvm tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >=20
> > ERROR: modpost: ".follow_pte" [arch/powerpc/kvm/kvm.ko] undefined!
> >=20
> > Caused by commit
> >=20
> >    bd2fae8da794 ("KVM: do not assume PTE is writable after follow_pfn")
> >=20
> > follow_pte is not EXPORTed.
> >=20
> > I have used the kvm tree from next-20210204 for today.
> >  =20
>=20
> Stephen, can you squash in the following for the time being?

Wiil do.  I will drop it when it no longer applies.

--=20
Cheers,
Stephen Rothwell

--Sig_/VDLHhucgpPkXC8uKFUQHq0d
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAgRBAACgkQAVBC80lX
0Gzlsgf/Vu3YM6NhY38hdezRiuj5ALhhnAJIR9mjPLbgLb/n+JD5iFzM/r/d/a7h
rvAllgpNJIJYNMIDdRtO7YUOMI9g9NS9LhbtzJ/x6FsZF97xIxt30CbYhbLCfBvN
MrXgtQJDU/3DKLSGc5fsyD0wlMmxZyq7nbIQNkqHlt8l7Ov9D/x8RXQIsHgL8qdc
DibYN+MJhgSX7fRKf3SID19E5fAsN2++nHU6as2J/rYq9/NHi5dAvqIb+6nyBf56
JpGDGIsuDHKgxMg1R91cFM44U8PY1GsPolUNxzbMY1IcXcKa9yCalfrRT1P7Erqu
EEARN3Bmx4d0RSg34mRGZn3TxuPmPw==
=Jtt3
-----END PGP SIGNATURE-----

--Sig_/VDLHhucgpPkXC8uKFUQHq0d--
