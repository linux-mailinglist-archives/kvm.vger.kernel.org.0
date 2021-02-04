Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F6730FDF1
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 21:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239929AbhBDURf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 15:17:35 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:35799 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239645AbhBDUR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 15:17:28 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DWqZg6y9cz9sWm;
        Fri,  5 Feb 2021 07:16:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1612469804;
        bh=eo4DPofwcNNNJ9VF3NYQKX07eZpflxgMOsO6MeHVr8o=;
        h=Date:From:To:Cc:Subject:From;
        b=q+wxSuID94X/5sSGleIpJuZcQdIFEnHc94+u+NUMXfG4uJNIJsiW+F2L3NYBlmQKH
         +uSgOcfdxc/lQnmrrcjTQRAqoTa3yiNRXu4lTcJF2OYOSdklQtdcVrp9w26M/HsDIM
         tN/5d2YQTNotzKkbWn2vNC5VUGF+LK5DipivfxTGbcl86eV0g9WLRcFaR1uKM1TQuB
         c3cwnZqd9JaBHBUYhBGIgmf3aSSExsl2WGxdB12TFcEn5v9XsWO/SBKgagAKXVSxEF
         hUMEcKWuPXpkjK+w8YEs1D/4lJqIp50kF8z4qvKOn9+0OIy8RA+mj8uDvCWdla1lyT
         sd/N/blUCKe1g==
Date:   Fri, 5 Feb 2021 07:16:42 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Ben Gardon <bgardon@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm tree
Message-ID: <20210205071642.23bbe137@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Wp0hn5Q39lewHKBgMwDxSLf";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/Wp0hn5Q39lewHKBgMwDxSLf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  f1b3b06a058b ("KVM: x86/mmu: Clear dirtied pages mask bit before early br=
eak")

Fixes tag

  Fixes: a6a0b05da9f3 ("kvm: x86/mmu: Support dirty logging for the TDP

has these problem(s):

  - Subject has leading but no trailing parentheses
  - Subject has leading but no trailing quotes

Please do not split Fixes tags over more than one line.  Also, keep all
the commit message tags together at the end of the message.

--=20
Cheers,
Stephen Rothwell

--Sig_/Wp0hn5Q39lewHKBgMwDxSLf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAcVioACgkQAVBC80lX
0GzXkQf8Cy6+6nnAY/LtZbqQStZysOkI5A8lKgvjURDTnVJvsqMiHz1gjlKkexrG
mZbTFZTMfx5Zt16h0QmYt/6FHk3n7SdeQkbkMODrvLQQW7pUHnryCRleqA4MLcS3
iF0pubwIEjCJ9AU/GclaHRnxiVqlyQzAlzT/jT2k3O0WCUbFC3avpHUy4iTdsYAF
uQ4L8/bPpJ2ObwH1gnU58zEpnn3LlosSzJTV6i/fdGRij5Y45P+/jy+iAXYbrhox
CqC+5V3xmlUwTtv0ACs1tt1AvnkM9QS4swDBcj3FumAO1qm6heAjawgACkd27dja
rYi+odcFDGNesyNRGa7wanJ83yBXlg==
=yoxt
-----END PGP SIGNATURE-----

--Sig_/Wp0hn5Q39lewHKBgMwDxSLf--
