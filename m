Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E42362336
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 16:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243191AbhDPO7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 10:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240740AbhDPO7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 10:59:01 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772A0C061756;
        Fri, 16 Apr 2021 07:58:36 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FMK8n1kfXz9sWK;
        Sat, 17 Apr 2021 00:58:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1618585113;
        bh=cIlMdrmnY8xfUotlk3HjA+3AaMQAPaEqG0+WRFRFMzY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lxvk3EsayIuu49a14DRd3ArX/Xa2jMszBu/PeFy9V2YOI6MLPDfnKZ/wroYFEkjoZ
         ruxhG+2jOinHLzd1gZpuvf1pg2+h5snEDcnSAWz9r86PiZRARRaWqAh1TGBCupm7Ei
         zX8a9vsnM2AaNGbh+lvjv1boh2ii0vXB3vscwAwI7559JbVazl6Gu1NSl6MxR0h7R4
         UEvaiJ/l2Ya4xKXXdyeTaktjI42a+TvRpbOF3FC4JiaCqs9gmE7jgNI2qZikWe5HRG
         rZk1ITj2w4mNFHMXODhTw6fB/czUTuAJOhqikDpK9xXexgsHkgqmsUh6bK6pkNbbVE
         6aPRK8udIi5vg==
Date:   Sat, 17 Apr 2021 00:58:31 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the kvm tree
Message-ID: <20210417005831.3785688b@canb.auug.org.au>
In-Reply-To: <2b825142-fdd9-be35-6d88-bb3b9c985122@redhat.com>
References: <20210416222731.3e82b3a0@canb.auug.org.au>
        <00222197-fb22-ab0a-97e2-11c9f85a67f1@de.ibm.com>
        <2b825142-fdd9-be35-6d88-bb3b9c985122@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/0DmwpD/swBEIc1UY/TlK=+X";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/0DmwpD/swBEIc1UY/TlK=+X
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 16 Apr 2021 16:02:01 +0200 Paolo Bonzini <pbonzini@redhat.com> wrot=
e:
>
> On 16/04/21 14:38, Christian Borntraeger wrote:
> > On 16.04.21 14:27, Stephen Rothwell wrote: =20
> >> Hi all,
> >>
> >> In commit
> >>
> >> =C2=A0=C2=A0 c3171e94cc1c ("KVM: s390: VSIE: fix MVPG handling for pre=
fixing and >> MSO")
> >>
> >> Fixes tag
> >>
> >> =C2=A0=C2=A0 Fixes: bdf7509bbefa ("s390/kvm: VSIE: correctly handle MV=
PG when in >> VSIE")
> >>
> >> has these problem(s):
> >>
> >> =C2=A0=C2=A0 - Subject does not match target commit subject
> >> =C2=A0=C2=A0=C2=A0=C2=A0 Just use
> >> =C2=A0=C2=A0=C2=A0=C2=A0git log -1 --format=3D'Fixes: %h ("%s")' =20
> >=20
> > Hmm, this has been sitting in kvms390/next for some time now. Is this a=
 > new check?
> >  =20
>=20
> Maybe you just missed it when it was reported for kvms390?
>=20
> https://www.spinics.net/lists/linux-next/msg59652.html

It was a different commit SHA then and was reported because the Fixes
SHA did not exist.  It was fixed the next day, so I guess either I
missed reporting this different problem, or I thought at least it had
been fixed to use the correct SHA.  I am not completely consistent,
sometimes :-)
--=20
Cheers,
Stephen Rothwell

--Sig_/0DmwpD/swBEIc1UY/TlK=+X
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmB5phcACgkQAVBC80lX
0GwoqggAhj7E4OiKMOnBWhl1ZjaMdZAidgXea6JGZGTB3UEhRtJVCMk3zjqfN6N5
BHE3GS3zfIlipzavzSDc/Qu0Vy/CqTndlYVZB+RzJszegcwTVu9Z1Cv9f+gHARjz
QGhwHSMcJncqzICp/3fyPQvbmruZr8e3ah7iWucCOfgWj6vri5A/jDjSjIR1UKoN
kbf38gi14BGsULsASiSEMREo2bksWBkhea0mQ8qzd/FFQgc/IS1kInazRNfxzH6k
hGzdVc+Np9e1W3Q0LIzWiENnFiFL+hyWKkQZs+W6pk/g68jaKt4X6CG/+weKOzsv
Ld0tGk7SIU3DhXdxstZPgnph3UiyDA==
=5y7J
-----END PGP SIGNATURE-----

--Sig_/0DmwpD/swBEIc1UY/TlK=+X--
