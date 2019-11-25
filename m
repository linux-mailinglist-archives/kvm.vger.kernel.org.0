Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E3B10869E
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 03:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfKYC6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Nov 2019 21:58:23 -0500
Received: from ozlabs.org ([203.11.71.1]:37959 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfKYC6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Nov 2019 21:58:23 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47LsDB6D4Yz9sNx;
        Mon, 25 Nov 2019 13:58:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1574650699;
        bh=/pK/e9k2+NTbNKLUliQTUNpHdxjtj7ghm4OxacU6eY4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JhOh1s+9M1WegYuoRA1nYDpL4XDut3t2gQB13qyyxUP60t+KYQ/cFtN/xcP8qs+I1
         jX5lGGOrRshxAL9kxJsBd9NfALaieAIUfeFmLF0N+JIIxxKCLLhoIDeXg4MVRQOhcd
         BSAGxAnC/iMx7anT1DNSxu8IMJaO5WriXKwU/rJeM4l8LGdMkGlEcsC0+PtBHrmai7
         Kb9U/kvYRC+bHTAwg6Cu0AMtcIdP2Ak/lTNcFZ+64MFBBvjzN39tdHV31DWm6Tjnxs
         E9RDTHAB14K36AGuZnZ3mxBeZyu9IIM7RFaM+ElLYMDN7/+seRiRa7tP12fmLnNkIw
         i6AUt9D5I03+A==
Date:   Mon, 25 Nov 2019 13:58:11 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: linux-next: manual merge of the kvm-arm tree with the kbuild
 tree
Message-ID: <20191125135811.4a3d71da@canb.auug.org.au>
In-Reply-To: <20191118143842.2e7ad24d@canb.auug.org.au>
References: <20191118143842.2e7ad24d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/GsKszbGLlANTHuWsW92d5yE";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/GsKszbGLlANTHuWsW92d5yE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 18 Nov 2019 14:38:42 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the kvm-arm tree got a conflict in:
>=20
>   include/Kbuild
>=20
> between commit:
>=20
>   fcbb8461fd23 ("kbuild: remove header compile test")
>=20
> from the kbuild tree and commit:
>=20
>   55009c6ed2d2 ("KVM: arm/arm64: Factor out hypercall handling from PSCI =
code")
>=20
> from the kvm-arm tree.
>=20
> I fixed it up (I just removed the file) and can carry the fix as necessar=
y. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

This is now a conflict between the kvm tree and the kbuild tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/GsKszbGLlANTHuWsW92d5yE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3bQ0MACgkQAVBC80lX
0Gy6mggAo4vmbOznP2KJu5srF23Ev7bZ/y6SQhhkNYFVjWgM+3hf8IBhYTyH3LIS
BLnllPbizqKlIJwe8OVuUlu9JoC/eTdObeC9oSw7OPcwC9gMRNDVPUmQKMyYWa/S
1uR420GQMo2GBS4OmcDBiWhkqij6GqcdZWMx80NqPQeg4Qpb5GMTBbUE7HhSemrm
jjmlY83AItxJ/znsPdrSfrEIuRfel0g91FoRF7LlOO2+DMG8EwRTjCNC7r6WvcH+
zHpb/aaHhHGZzbwgaTHFVbAvkbPMh+WE+jYpFcK8wpoy73DFinyHwK8nJxvp0Um1
qMbgw0IoNeLJQmyaZUujyjIdmIO06A==
=M4RS
-----END PGP SIGNATURE-----

--Sig_/GsKszbGLlANTHuWsW92d5yE--
