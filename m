Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62E12717C1
	for <lists+kvm@lfdr.de>; Sun, 20 Sep 2020 22:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgITUDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Sep 2020 16:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgITUDe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Sep 2020 16:03:34 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A35C061755;
        Sun, 20 Sep 2020 13:03:34 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Bvdmg4WKtz9sPB;
        Mon, 21 Sep 2020 06:03:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1600632211;
        bh=QjboH7VSmbjfV++NPvYTHItW+R7R39XMr6gcOwwGB9w=;
        h=Date:From:To:Cc:Subject:From;
        b=Z6Rt7t1SVI39h79BI2Nc+cYorebjPECPyyy6GhkZ4MZm4UztCwhKNmknTzegvy4e2
         bX9zHwAle2zKYFZJ26HIG4IErjxq5MSlZrLvUkaIM2RJ/G9WVWbWbYxrjAinIwnmRU
         jsVqAexws8TcOMJ8VoALbyaOUcC25zRb6RIsYOL2NSAxO2WVXT954AseMm/UktDBIY
         Fqre2ol3RZF08NA2NgBYu8UfI7h1HwxD0feazxB1Y0gAW/nimr6gT71eo1YCNAQ+pG
         rsQ1Fg+zpSAGdZxPRj6lbeY8KTIPQo6W2Ma0MxJxT2FVA3JaJS4n3BHMWp7kgcGPYt
         wI/tJKltdQWiQ==
Date:   Mon, 21 Sep 2020 06:03:30 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: linux-next: Signed-off-by missing for commit in the kvm-fixes tree
Message-ID: <20200921060330.1e3ef67c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.zAKErYdlL2BCV/Ap+ef4iK";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/.zAKErYdlL2BCV/Ap+ef4iK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  d5eff360a675 ("Revert "KVM: Check the allocation of pv cpu mask"")

is missing a Signed-off-by from its author.

--=20
Cheers,
Stephen Rothwell

--Sig_/.zAKErYdlL2BCV/Ap+ef4iK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9ntZIACgkQAVBC80lX
0GzcpAf/emCgEulJmGLDQyctuetEDAt5KyQbKYqXizmQFiDJulNIis5oF3xwo0RS
dAwE4nd5IckjNAiw4q53MVGSyJJ6Irc687Iu6/c0rgJiLV10mCYEJP/sAeVuxsb9
gE+Tsuvk2ZDHZCfFLnShUtmsN+EqZMh5Ur245YRmDTxJJWyT85JUXXaqAGhWSa3K
BZPkIs9XzNa7FxOFM4UM0doCDgyCEVAp34ZIu3puXJ1P6jsBhXHGQUo3oYd7Yzpi
1qep5pQvmzvZyR48JbT2fTPrmht74f3iTAsqKfUGopBjzblFwN1o7mjPoOAFqXJy
0NFUGBa9LMn7/jCbQyQFk08rRa4TCA==
=hDLk
-----END PGP SIGNATURE-----

--Sig_/.zAKErYdlL2BCV/Ap+ef4iK--
