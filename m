Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1DB267E99
	for <lists+kvm@lfdr.de>; Sun, 13 Sep 2020 10:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgIMIf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Sep 2020 04:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgIMIf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Sep 2020 04:35:57 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D954C061573;
        Sun, 13 Sep 2020 01:35:56 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Bq2rT1pXDz9sTH;
        Sun, 13 Sep 2020 18:35:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1599986153;
        bh=Ct1IcVItRF83R0JfDTcsR7gfk7ZoCEKcrcV284foNcQ=;
        h=Date:From:To:Cc:Subject:From;
        b=gQMZkFXA2QarjFzqwbVEHc7sqUzUM7TmPGQp4SkdkjJ5yE2NYyAS4IoTk4D1T6woM
         lS6k6F45FHZODI0cxhX33ed2iyiEZg9Lylh1Dcv2mI2f9WINHeYUBNNO7/A/lP8aHh
         ta6SLd4OzcjaOfZCV3Cy3hIaEgoLriwrGLjzUuIEBYTaqYdm78vMmCXJGEE6kxL6yg
         OEudWjGs8aOGtDJgjqw3d3bnSciijHgHhGDZb4lrZ2+7GOCvVSrVBsQ7DW0ncxSujS
         s2kuLR4abaqYT2NJ2j7Aw4wRWMCBUh1EAthiCTfXzBgh4QC7LmaJbsGvuKY5Gc1gJ8
         JARSx7B1B+1sw==
Date:   Sun, 13 Sep 2020 18:35:52 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the kvm-fixes tree
Message-ID: <20200913183552.2e8ffaa9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/QXotM91I4NVkIgAHJ5T13x4";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/QXotM91I4NVkIgAHJ5T13x4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  e42c68281b44 ("KVM: SVM: avoid emulation with stale next_rip")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/QXotM91I4NVkIgAHJ5T13x4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9d2egACgkQAVBC80lX
0Gy0/gf+KSz/ha+kjRxDWSmomIZDVDtORsFyA0GFXFDuphzrRqGp4ni4guO6pwNP
ETAOaPEhbbA4ByYdTXQyFjMI4Ac+CLGveZAd7odZ5bZofYb7dPIxG8jTFnB5LaaF
TGw6Hn/sktcts0FznlRvKb95MOtr9mS8b9SxWxobcNOTx+jw/UsM5z8W1VudTgPu
Eav9j7ckie56n7MP/0dU1sqs7lTy/0g5VT9gxF2gJ5cx8GhWGwakjYWNJyKJYL9m
vmCzP4ELoSovIzTj/Jf7KIG7LaVza6wiP/yRnmdld4t8TcNScwoT94OSQromkWiX
0WB7zK6GDOiWvqqWRKHyJIQW+D1B5A==
=9kTW
-----END PGP SIGNATURE-----

--Sig_/QXotM91I4NVkIgAHJ5T13x4--
