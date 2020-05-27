Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8A01E50AF
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 23:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgE0Vr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 17:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgE0Vrz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 17:47:55 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E84AC05BD1E;
        Wed, 27 May 2020 14:47:55 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49XPZb4z9Rz9sRK;
        Thu, 28 May 2020 07:47:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1590616071;
        bh=mXu9qxrrYhcMrslxtNTfDTi99hlgGhfPw1uSLhfYR00=;
        h=Date:From:To:Cc:Subject:From;
        b=K0O5AJ6mpaA0/hNQp3MM5lNC8locegVJUd0sBCWNx/eYI9gH1FkQncofC8loe8lbk
         +xOy3F1UHC9HPmKcgvhV+HRwWPUPQ5xt4AsKZU8OFl5HSzgidg4fAfmDk3sjQJ1sXb
         vAGkABj1iLPvUIgJEVUkHHTvkhTAFvFXtkbXqS8sNRCBMhGz8NMfAblZPwLOy9bufC
         b15irLTRtrUSl7EFf5DaPokyu1dNWH2bmBE/CroMrueBnL7pzjZd6cA6kG81imsFZw
         SHA+p8Sp4qGp1X9qJNeGHoEsCbP/tEnhE3Qd6gMEXmCwrnvsuMEO5XXejxIOJbnM2a
         Z6qf9idIlGe3A==
Date:   Thu, 28 May 2020 07:47:50 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20200528074750.550f761b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/LyStz_oR44yVl+tok4Z2UQd";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/LyStz_oR44yVl+tok4Z2UQd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  f4cfcd2d5aea ("KVM: x86: don't expose MSR_IA32_UMWAIT_CONTROL uncondition=
ally")

Fixes tag

  Fixes: 6e3ba4abce ("KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/LyStz_oR44yVl+tok4Z2UQd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7O4AYACgkQAVBC80lX
0GwUfAf/T8bYGS2CZ+9VIOkE6z9xJC/K1D3t7G1kCaYHfHgaSkul3vExAeJDghwn
WVN+mOVwu2QFyEZ6PUqX/hjJHmMiQs1Lvv4vULMVi3QI7xK/KKuXnqfuOfjQLJhI
UyZKaa5jxhO484FylcmkGk9QtC0HWxmAXluxWSlBAaoFZHsbDSHP0vHdQVA6WPBx
Opwd0JA5U6drlQ8cZ6EhJvXfk+eW5QaIK5SPYl/fhH/F0SRCA4EtTCEIpaNVC59g
2Jr4vLnCAeBu7a9qG1FsdzgJG/Cj8s7m+AfsLCPjnTlZpRUMJAJS5jo8vwU4NukN
sWQuAKaYyfXycc2Zf0UX4RF8V2y+Eg==
=idU4
-----END PGP SIGNATURE-----

--Sig_/LyStz_oR44yVl+tok4Z2UQd--
