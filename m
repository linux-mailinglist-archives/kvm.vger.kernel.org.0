Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15733F22FB
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 00:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237471AbhHSWU6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 18:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237447AbhHSWUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 18:20:47 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B71CC06175F;
        Thu, 19 Aug 2021 15:20:08 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GrK2Y4V2jz9sWq;
        Fri, 20 Aug 2021 08:20:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1629411605;
        bh=G1uxALNrsDthQbLStYQZE882NWSvU8HeHilDVuGLI7Y=;
        h=Date:From:To:Cc:Subject:From;
        b=S4bQ726j0cOYxE4icldqJsoeSnq/7OmWSX4FfmU+QAVhNC7kJA+eOglBh6yczNcjz
         a7kSPl/YKsD5WYqy0qC8+ABUE36VXzgSwrllFSpEh/2vjox/0lC09sqhH/ZtKkYgcF
         Bp5+p3HV8PNzlUbkU2y+k5jzqI1zTvByO65O+o8xExLkhcawoUfviAKxiwSCBDr1TW
         Mw9NVW/EhoBPDJPUiJJqelzOw4UmQ47M/42UiyNpmBjyCph3ugRvtrxUl///g9Lulk
         a58NoFn5qdTIRq97MJI7HQlomtOVwbJMsUtAcYRPgZyFj83P//2gPJar3eCvNm+qTl
         Q0XLroCzvLOfg==
Date:   Fri, 20 Aug 2021 08:20:04 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm tree
Message-ID: <20210820082004.7556d96a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//Cb20sIlI7P9t9utNT3Zluz";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_//Cb20sIlI7P9t9utNT3Zluz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  f7782bb8d818 ("KVM: nVMX: Unconditionally clear nested.pi_pending on nest=
ed VM-Enter")

Fixes tag

  Fixes: 47d3530f86c0 ("KVM: x86: Exit to userspace when kvm_check_nested_e=
vents fails")

has these problem(s):

  - Target SHA1 does not exist

I can't easily find the intended commit.

--=20
Cheers,
Stephen Rothwell

--Sig_//Cb20sIlI7P9t9utNT3Zluz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEe2RQACgkQAVBC80lX
0GyUOAf/TBsldQpVzbM6uAs40tBOzQd+I70cPQKGiKSqFP1/2uRlVDA1lo+wp0hw
h0xIi3yOzYk8LUZt/cb7z0CB1eeKRXHPhrYOclzsX/1qLZVofe5TZoMukNhGNxPh
aTnrTTofJZr9PgrgjB8TTYUUszxECSxXEsAF85VBx35pWXzQuK9o2YMguFK5ZICb
M0hDdjQd2lne9qAYCMG92s/KF4VGv1SCuXquz9uICV0fYh2ioM5svgEcBwXQ25hH
HAlDTMC1zjVTQAv5T2bSDxq17eCbN9JWHryonDYWuPNWqEij5RruIknpiKTL+11q
pxX7GuC8GAB/nB0ZxuFh7T79hGMTow==
=487y
-----END PGP SIGNATURE-----

--Sig_//Cb20sIlI7P9t9utNT3Zluz--
