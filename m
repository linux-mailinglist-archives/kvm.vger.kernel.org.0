Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048E0531E9A
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 00:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiEWWdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 18:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiEWWdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 18:33:43 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945B095496;
        Mon, 23 May 2022 15:33:42 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L6XDP11Gcz4xD8;
        Tue, 24 May 2022 08:33:40 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1653345221;
        bh=LoJARPy5JdBRbdTc2siT2D09dFF5EM6/us+tEv2VxLc=;
        h=Date:From:To:Cc:Subject:From;
        b=XT+psw/YM2CuPqE5qvtcVxceYgNPOyxBKBZQKji/JqELJzJa9w821pUDv9N0IIcGv
         rS1lMRtcyYaE3rMRH0kU38+8Pre50XNbykihf4Sp1JAn+HrcimYkFblLovAOTYMV3R
         TL1tkuZ12i7mobRjpz16O8EEVmAtY/mPc/J4XNXgMMcdO2Z/3EmTCUZVWynKE1EYxT
         PbpcO7FK2Jx+vr8zOfgGm4wA0mXN0Qe2FtLOg3lfYOCcBc+yWO2q3Ci69i1+Er8PF8
         GAkyyzoYG3Nu+q5UYIKiGH9kwb9YRo73TW/EXRiTQlz8FbU72L8jRAwgRHsa6yXQls
         WRufvRxI4KvUA==
Date:   Tue, 24 May 2022 08:33:40 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the kvm tree
Message-ID: <20220524083340.5a106e8a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5OsbqSMiP_ohDtxkkT12A_W";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/5OsbqSMiP_ohDtxkkT12A_W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commits

  43e88ad5462d ("KVM: x86/pmu: Update global enable_pmu when PMU is undetec=
ted")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/5OsbqSMiP_ohDtxkkT12A_W
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKMC8QACgkQAVBC80lX
0Gw50QgAlEOY4nrxVpLfkn1ntoz1YGpixglig6keHjbppiltkUE9AQIHV5d0VgfP
G0SzAAdoG4ONs2+YGOxDyX7BFO1Orv/qpYP8YzyNH5NUq8IkBvJE2qnkgZCy55Am
kOAGQ+ocYuG1YZUadr3IpZmimX6GwJYy+4TK2mPxqym+pohBFdkVtv98HRTDyod5
bwNL+mCYl7RgMHh2awkUfuiGU2FyDQnSyJ1uVSwgcmv2w2+tayqzh182myNqD0d0
0eVmQ7N7ipxFddWztEmCr5r6IAteO9VsGVI0PvhWip9U+us2FQys0oQ1LTvOZQkj
p1ZgFT8IBYBqLm4wePaQFyK+KmxT9A==
=SDMf
-----END PGP SIGNATURE-----

--Sig_/5OsbqSMiP_ohDtxkkT12A_W--
