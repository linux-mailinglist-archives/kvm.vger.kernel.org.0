Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C44226E77
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 20:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbgGTSnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 14:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGTSnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 14:43:10 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DF8C061794;
        Mon, 20 Jul 2020 11:43:09 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B9VwX0y0wz9sRN;
        Tue, 21 Jul 2020 04:43:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1595270588;
        bh=+4fZqzsxFnaIHx+7cpxpLq2jR5BVjVxJXGeJc3V+N54=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oNf6dSVe+1GCC6DdMmOM6g41j/tzXitGuhZQ5kHOppikTOVuC95a5RjRfR42RwTgW
         Gn4ew68xSvE2S1IUtY1PrkYHbdXk14wG7DBOZJ8qghWYup5Qa3cASFBPxvj8V14+r0
         utRi8p+WiDb/QuAoK7rp5TAV1qGtJ3Nd/E/TkJ1vfs754Op58JxLhtw2NuhZQ3Gn7r
         TM0bQH5F9/V0zc0hxlWkkPozNTaLeDwQn9tiCkwTpn+ghBDRuF6Edc+odxgP4Kt4Vc
         yVoTizRhXpVtge/wNgT5zxBILXrwtQcGgXDs6zJOCsxlUm/8PXMShNDKwnpnSwDygz
         tlpp7jecoc1HQ==
Date:   Tue, 21 Jul 2020 04:43:07 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: Re: linux-next: Tree for Jul 20 (arch/x86/kvm/)
Message-ID: <20200721044307.6b263e5b@canb.auug.org.au>
In-Reply-To: <1d2aa97d-4a94-673c-dc82-509da221c5d6@infradead.org>
References: <20200720194225.17de9962@canb.auug.org.au>
        <1d2aa97d-4a94-673c-dc82-509da221c5d6@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qigNzgqNSb8xRKNnC2ybGUo";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/qigNzgqNSb8xRKNnC2ybGUo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Mon, 20 Jul 2020 09:56:08 -0700 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> on x86_64:
>=20
>   CC [M]  arch/x86/kvm/mmu/page_track.o
> In file included from ../include/linux/pid.h:5:0,
>                  from ../include/linux/sched.h:14,
>                  from ../include/linux/kvm_host.h:12,
>                  from ../arch/x86/kvm/mmu/page_track.c:14:
> ../arch/x86/kvm/mmu/page_track.c: In function =E2=80=98kvm_page_track_wri=
te=E2=80=99:
> ../include/linux/rculist.h:727:30: error: left-hand operand of comma expr=
ession has no effect [-Werror=3Dunused-value]
>   for (__list_check_srcu(cond),     \
>                               ^
> ../arch/x86/kvm/mmu/page_track.c:232:2: note: in expansion of macro =E2=
=80=98hlist_for_each_entry_srcu=E2=80=99
>   hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
>   ^~~~~~~~~~~~~~~~~~~~~~~~~
> ../arch/x86/kvm/mmu/page_track.c: In function =E2=80=98kvm_page_track_flu=
sh_slot=E2=80=99:
> ../include/linux/rculist.h:727:30: error: left-hand operand of comma expr=
ession has no effect [-Werror=3Dunused-value]
>   for (__list_check_srcu(cond),     \
>                               ^
> ../arch/x86/kvm/mmu/page_track.c:258:2: note: in expansion of macro =E2=
=80=98hlist_for_each_entry_srcu=E2=80=99
>   hlist_for_each_entry_srcu(n, &head->track_notifier_list, node,
>   ^~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors

Caused by commit

  bd4444c47de9 ("rculist : Introduce list/hlist_for_each_entry_srcu() macro=
s")

presumably with CONFIG_PROVE_RCU_LIST not set.

--=20
Cheers,
Stephen Rothwell

--Sig_/qigNzgqNSb8xRKNnC2ybGUo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8V5bsACgkQAVBC80lX
0GyVQAf8D59dKFMeuZe4W5Ay7oGvQOtXZXcQFnrIz1U5Jf54S+6swjErCT7v51Cx
kh+RVzGarJD4xwa/hz9keR+csECE0RTJN1OGPmYOmpBe3X42++vGGo7lDg5DNn+S
X3eP/8AEd13g/Ll4Cu461y5j40aW4tiuaj9NGACWUxzjSEaGde3oRqgtL51iAjEC
9RCSZrPkaagEWpqIrKvPZaSQpS73k0Jgq6HoQrsz/3wWYYpbzWEOoa2MyyR0ciUk
DpPngJ0lqrzYJhFfAIQfnHudD49i33aRfdTAfVsXTD5KMidyjWfxAKDpNNXzl0Fh
SK9pOD0e8aI1xa6izuDbjiwbPa3/TA==
=ZrJA
-----END PGP SIGNATURE-----

--Sig_/qigNzgqNSb8xRKNnC2ybGUo--
