Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0805D495823
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 03:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378470AbiAUCOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 21:14:10 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:35799 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378458AbiAUCOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 21:14:09 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Jg2xR4c2Xz4y3l;
        Fri, 21 Jan 2022 13:14:03 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1642731244;
        bh=+Pi5RsOdBjiKv+TlOIaEVsZLy6x79QD+ktWgsdTYLaU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WkAqZwBY2xQStMdsNi+46dW3zkzyse7J4f3G20P6KzmNPTngg3Aqdgiv0oQ7/IN6O
         q5Spmb/eXh8tQb5CX3t5Ev5D7LnIzcSbIL//ylrlFTq8eQl921JTaCpVY5pivEJfVm
         FLGAjeenXkxpsxs6r4o/4Rem8mbwCct0bhiro8ESysaknX+u92rf3wg9nI4QKGHutt
         +IreSubn5hqbKoFHO1O4gSJy/YNrg1ffPhQ501EIlOK93V3/nGcJF2ORkRx6p0lt/w
         LBgrFkElzHl6UWLk0no/uMAdr2E2+RTvsmEj10tyQtwzJvT2Xa3rZp+obnJkZr8hJw
         ENVG2CSO/+IZg==
Date:   Fri, 21 Jan 2022 13:14:02 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Linux Next Mailing List" <linux-next@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20220121131336.1912885a@elm.ozlabs.ibm.com>
In-Reply-To: <52efe36ef887430ba27ad718afc55a5d@intel.com>
References: <20220121081432.5b671602@canb.auug.org.au>
        <52efe36ef887430ba27ad718afc55a5d@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/lk72fSIGkMgXmE2aLfW4QII";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/lk72fSIGkMgXmE2aLfW4QII
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Wei,

On Fri, 21 Jan 2022 01:42:50 +0000 "Wang, Wei W" <wei.w.wang@intel.com> wro=
te:
>
> On Friday, January 21, 2022 5:15 AM, Stephen Rothwell wrote:
> >=20
> > In commit
> >=20
> >   1a1d1dbce6d5 ("kvm: selftests: conditionally build vm_xsave_req_perm(=
)")
> >=20
> > Fixes tag
> >=20
> >   Fixes: 415a3c33e8 ("kvm: selftests: Add support for KVM_CAP_XSAVE2") =
=20
>=20
> OK, for 12 digits, it should be: 415a3c33e847
>=20
> Paolo, would you like to change it directly or need me to resend the patc=
h?

I probably doesn't need updating, just remember for next time.

--=20
Cheers,
Stephen Rothwell

--Sig_/lk72fSIGkMgXmE2aLfW4QII
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHqFuoACgkQAVBC80lX
0GyczAf+Jp3ZrTDS9+F7WiXmL9aa1tztVjgaAf0m7qxNLGxumwj3HN9nB7cI1cvV
4XgL7BoK8nqU3oNnoUqKBbdw+mbCzhnXF4p0ZVA8Qen0bMJW0ZC2UdELGBeUpS09
ReMFgyeVbL6I6sleNQNZ8yD0b214twOArgH5RFS9bjJ3iUFA4eAuw6anxk1fwiNF
JhiR/Ll8PO7dHpu6uuXvBAhaUXA9d5mKPOSKGiwR/Zzoke4N3P2AAVTso6vp6CJV
kaiOtXtMS6NyOwF3DvM2/ub2g/c1RLcGfnEdlohFZzQuEL8vLueBdPzZmABLV8Jg
PKbLZbvowIGlTQjb6UXm7QMVdPhRNg==
=0EWw
-----END PGP SIGNATURE-----

--Sig_/lk72fSIGkMgXmE2aLfW4QII--
