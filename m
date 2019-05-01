Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDB4E107C8
	for <lists+kvm@lfdr.de>; Wed,  1 May 2019 14:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfEAMGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 May 2019 08:06:18 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:55957 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbfEAMGS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 May 2019 08:06:18 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44vHDQ6w2kz9sNQ;
        Wed,  1 May 2019 22:06:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1556712375;
        bh=L4xIXdsKIOlYQtIGuIRuPLfaYR8V1c0iZE8OTmuXKkA=;
        h=Date:From:To:Cc:Subject:From;
        b=WsQ5tCPxvP6YMHDc+pzNUP4lgYdEuGKs/YgHJLZkW6wW2WFlcMOabinBuJPxIgMsq
         4XuQ5BqGoxeM/aEoGEQgAo5xvNZeWo9eOjD+vY0/GUp7SwCD+R6i18/iVQ014FUkaw
         knh5re4uaFghK3tUx0pTFjz6X3UF/BqHJd7ZLxhsfsDLIgheuNLrlZqjo1HPriEESk
         yv+vLTm2oab5jCrM+eCTmIar1iWY2tjSK86tyqgofVVRNOmGkR9eZdGEoBECm9ejMS
         58+fWYUbWxN73KTKxs7K44oYDpX1sFcyGnshlvYzP+H/LAz5yMaGONzCE81XdXOSkk
         ACPoAid5kubfg==
Date:   Wed, 1 May 2019 22:06:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20190501220613.635a5bf8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Uxctia6sdY12mvb7htqdSoi"; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/Uxctia6sdY12mvb7htqdSoi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  e8ab8d24b488 ("KVM: nVMX: Fix size checks in vmx_set_nested_state")

Fixes tag

  Fixes: 8fcc4b5923af5de58b80b53a069453b135693304

has these problem(s):

  - missing subject

Did you mean

Fixes: 8fcc4b5923af ("kvm: nVMX: Introduce KVM_CAP_NESTED_STATE")

You can just use:

  git log -1 --format=3D'Fixes: %h ("%s")' <commit>

--=20
Cheers,
Stephen Rothwell

--Sig_/Uxctia6sdY12mvb7htqdSoi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzJi7UACgkQAVBC80lX
0GxOngf+PrnVpQsVNa+lQCveDJpr1DxQwBxQwnH6T+Z5BAKNbEhVa0YhGcB8Kv+I
WrHRP/9+Y2xk1k6T9qaWTWU7DtG7bUuS+CQCf3MpHjAg4oMJ34rrl5muW/8x8Fgs
8jdISLjNuRUZplcilZ+l0CmEOY2OuyMwDQ+IAq/0wwVmG3W9KViwLq764SqAnmbw
n87vfS+9hUB5jo50pWW7TMaAKTkfhvBSm5XsudZZ97g4M/ABMaXFqjXVlJFug3IX
3AF0fYzS1Y5vbJ08NCPG72FQd/VZTqpQftT6bO0sZDSRKj0M7H6zEGcrKAutob/Z
E1Z8aXcfTO7sEBtI4mKKjeZIO0xaUg==
=kmKd
-----END PGP SIGNATURE-----

--Sig_/Uxctia6sdY12mvb7htqdSoi--
