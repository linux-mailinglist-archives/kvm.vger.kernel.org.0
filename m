Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB0A3147C0
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 05:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhBIE5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 23:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhBIE5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 23:57:30 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3B4C061786;
        Mon,  8 Feb 2021 20:56:49 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DZVws6Tszz9sS8;
        Tue,  9 Feb 2021 15:56:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1612846606;
        bh=LYBGnbg6PJbBn4ZHonWvNa6yiHgRxdmmz1/lDMaDvB8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LAs8Xohg5A7fuTxX/usT/0CLev/RYpxVfQG7d+HLg3wwAHNX5xG8CioKf932Y3CXg
         Wx9tuxDEV3LHWAKf/ZM26aXfI4gAgRj8pwE1V2RMfhXHmU4KSThNbb8MA922SsTupK
         tQ1mUDWmGj1nYHoMqLOBknkMfjfrGr/IwKVUQNKbTFY2OgrqodYv9jq7CG+i90c+fD
         zF8bmcSfAU5Th4T8oxjZ5vF0SvG0pOb397Ky4lCEkBYeP5c/ZRIgm7CvtW0JsFvIl/
         ktkXZe08l0z0CQed72TnXf03S21WF/RK5eUS6ElhfW8k593DUGcidPstLhY201AQVM
         DMp6J75fcHorw==
Date:   Tue, 9 Feb 2021 15:56:38 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the kvm tree
Message-ID: <20210209155638.3581111a@canb.auug.org.au>
In-Reply-To: <20210208064832.0624ac2e@canb.auug.org.au>
References: <20210205160224.279c6169@canb.auug.org.au>
        <cac800cb-2e3e-0849-1a97-ef10c29b4e10@redhat.com>
        <20210208064832.0624ac2e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qs=cqcRBvneFiPe8N4Pe8.i";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/qs=cqcRBvneFiPe8N4Pe8.i
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

On Mon, 8 Feb 2021 06:48:32 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Fri, 5 Feb 2021 11:08:39 +0100 Paolo Bonzini <pbonzini@redhat.com> wro=
te:
> >
> > On 05/02/21 06:02, Stephen Rothwell wrote: =20
> > >=20
> > > After merging the kvm tree, today's linux-next build (powerpc
> > > ppc64_defconfig) failed like this:
> > >=20
> > > ERROR: modpost: ".follow_pte" [arch/powerpc/kvm/kvm.ko] undefined!
> > >=20
> > > Caused by commit
> > >=20
> > >    bd2fae8da794 ("KVM: do not assume PTE is writable after follow_pfn=
")
> > >=20
> > > follow_pte is not EXPORTed.
> > >=20
> > > I have used the kvm tree from next-20210204 for today.
> > >    =20
> >=20
> > Stephen, can you squash in the following for the time being? =20
>=20
> Wiil do.  I will drop it when it no longer applies.

I am still applying this patch.

--=20
Cheers,
Stephen Rothwell

--Sig_/qs=cqcRBvneFiPe8N4Pe8.i
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAiFgYACgkQAVBC80lX
0Gztewf9GC3aRYQxebbF1Xz4f58nRkJyk1Sh4pXXy6oSq3I4FNHibPfgb6l2PM18
ef0KAFaVJcwmn5sKg+oK2tREarnO59NwuVg6jPcq/DRLHWfrwqvAkU42rJ/+/cOF
DNgtsros1Xr0g1VDUUyAk8t5/+FBfvI/hHeIi+9Q5MI6hhwxErZnv5SlxuUat7Wj
4McLzCfnMmCebLBDCmQ7UejHgKvd0ZXFSdW3v5NGJrjzKG5XsCR0DiA9Lbn1AQD7
Bmtjc2blkuWdDo8dNTdrx+JUq2ckNCWsroOc6WEQlu3OuKnRe96GW3bomIQMQw94
ZLpmlVUCLPhJuxNEXJxkHesTvkLYOA==
=wN8T
-----END PGP SIGNATURE-----

--Sig_/qs=cqcRBvneFiPe8N4Pe8.i--
