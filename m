Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BA83AF85B
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 00:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhFUWU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 18:20:28 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57741 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229789AbhFUWU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 18:20:28 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G83nZ0zwjz9sRN;
        Tue, 22 Jun 2021 08:18:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1624313890;
        bh=AE4pqSRAtnB6ygkfAvP5+Fk5dWOHydQStK490FS4+/k=;
        h=Date:From:To:Cc:Subject:From;
        b=eG4Rb4hgprhREKREZi9IH1nXrrSkN/G/zkqVI+V03220ABwy+oIVP/1xFXe+TOLlk
         qLKndSq2RFn5gv9rGthdnup+4n3v7ZgK50DIQ+u0vVRRwIvGhngu+hgZG2Ps7kqG5f
         BZoA9a1lQ4H7h05DxwT8IgiRDfr+Z7xpUEcBjowzpxVV7gueIMTmvQsVHelc+9CtRF
         5A0YLhJlhXy9vbdTI653a2a1JWVfyWiY5ItzhwwjKU3dmb4Wg0GGw8wP8ePsX9Yoyb
         QOyZdgg+Fq5MWQ6Ol9+hKaAzlTaqtp5u8/0fIBZN06ZUfaQGhQYgnAFwB2BoaN6WL2
         KGmXi1dlBGerw==
Date:   Tue, 22 Jun 2021 08:18:09 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm tree
Message-ID: <20210622081809.13dd2299@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/geag1LsnjWrC0Eu8s.pqwmg";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/geag1LsnjWrC0Eu8s.pqwmg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  ade74e1433f3 ("KVM: x86/mmu: Grab nx_lpage_splits as an unsigned long bef=
ore division")

Fixes tag

  Fixes: 7ee093d4f3f5 ("KVM: switch per-VM stats to u64")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: e3cb6fa0e2bf ("KVM: switch per-VM stats to u64")

It is very hard to get the commit SHA right when the commit you are
"fixing" is after the fix commit :-)

--=20
Cheers,
Stephen Rothwell

--Sig_/geag1LsnjWrC0Eu8s.pqwmg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDRECEACgkQAVBC80lX
0Gw5Fgf/W8q09hzJNqm1v0sgT+ewyzOKVD0TGhpUrUvj7BOaIqslVuzSd3uxDTed
6S06T11efUGW8hOsW80D09Sgd/5f1iEAh3Ip4+c/4fafIuhojZCGnYwmdAXQ2awE
2HdZ/9qQJwq6XuFvF9fq1+HW76uZqhiUl+ly6kQHus9rGfzEVFcdJWc+fP89NXd7
nPUws8fleh340hL7SPGNtov6TrqK5Ce9E3V8jVsQ4F0J03f4wgHQ8UXWI7T8icsD
mZvqdvXiq45EgmmF7/LwUr8r/XttqIs5JYd53wQdfqa1124vifVQz2K5MihVgZZz
gZrjeyWXnygZfh2o1qBntcUAx8Dq0A==
=4tKg
-----END PGP SIGNATURE-----

--Sig_/geag1LsnjWrC0Eu8s.pqwmg--
