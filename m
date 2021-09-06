Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E525402127
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 23:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237526AbhIFVtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 17:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhIFVtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Sep 2021 17:49:08 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A2CC061575;
        Mon,  6 Sep 2021 14:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1630964881;
        bh=rt4QNQwF1oY7gbKBoq3sB36QFcpIoEZRtMae1lzdBfE=;
        h=Date:From:To:Cc:Subject:From;
        b=ObMYPf4+YPe7BezhAMqh0hn2u+vChqo4GM1YgBg7BTTPkdwnOPL0tj1LwpAP1Vyzg
         1slwdTnG4XMm3CTOevQLVYk1aVRtkF0fU7b8goc1AY+cE9kIeOcmilhtxZZ2jBsgv2
         CAzZazD5XqpsX3eaUzIuvqg1fm6BmGfH7qQbJj0Cr9sY9NrwmGtrnATvFWkgD24byS
         2++frnjKeKmHhtvjPvg2LeYKbLTyoGFXSQh3MQmEckjYB/PYsH+bAidzWjJbBuPTeD
         upFPhATophgfz9Gi5ao4Pk5MZtsz/p0BuG0+1ZEr48IF02/9qTHjM1AQblC9jIgY+c
         YNAKo8WoHLZTQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4H3MTF042Dz9sXk;
        Tue,  7 Sep 2021 07:48:00 +1000 (AEST)
Date:   Tue, 7 Sep 2021 07:48:00 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm tree
Message-ID: <20210907074800.115cca4a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Skpy6Thw_CAjzJxOflk_vew";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/Skpy6Thw_CAjzJxOflk_vew
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  81b4b56d4f81 ("KVM: VMX: avoid running vmx_handle_exit_irqoff in case of =
emulation")

Fixes tag

  Fixes: 95b5a48c4f2b ("KVM: VMX: Handle NMIs, #MCs and async #PFs in commo=
n irqs-disabled fn", 2019-06-18)

has these problem(s):

  - Subject has leading but no trailing quotes
  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

The date part does not add anything, please don't add it.

--=20
Cheers,
Stephen Rothwell

--Sig_/Skpy6Thw_CAjzJxOflk_vew
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmE2jJAACgkQAVBC80lX
0Gypmwf/aOP/2kvnCNQtDgc7RSVUWFby9wKLNMU0pHi1hz+by2LQyrU96cugH32D
+UvfAqiG9Qg//jZRAZeXpQukXiQCfcOLCxHEM242w/dDmpm9rgT+QBqO95nlSnCj
ExOHrOUpbaZfm8mBXssKED7f3rm1qWv/YvsZL1mCsgXkDnhZ5wkYlg/a0TB9zQ3a
sPFXUp+yl6iebwiXkEtpkxmcodsi6vyfKE0SdiwMxtXQwtbJ6bx5hTZa5OY8btCG
mStIFUzFzVH5f12f8A25ab/jB/ERTyxwe5DAiY7DJkWfOn/hMh9+S6+AZK4sI5m3
Eyz/Byoslql6MCAhn9ZTnzQKrm21zw==
=borX
-----END PGP SIGNATURE-----

--Sig_/Skpy6Thw_CAjzJxOflk_vew--
