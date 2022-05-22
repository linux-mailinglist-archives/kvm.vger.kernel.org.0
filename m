Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F2153001A
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 02:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348635AbiEVAv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 20:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348559AbiEVAv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 20:51:27 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDB812D23;
        Sat, 21 May 2022 17:51:26 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L5MND3CqDz4xXj;
        Sun, 22 May 2022 10:51:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1653180684;
        bh=0TJy5ahx0coIPA/M3HmMyFEx4q0ZAxNz4mXvT9u/iyA=;
        h=Date:From:To:Cc:Subject:From;
        b=MOQY+bm4TO9oOSmcKZZ9ioVf5OtbUecdBIRRyQ6wyzWDfqd31CriBH8ieMaF4Pwvl
         j9vlcVRqu87VfxkOA7MvbmYN5iq0EoITmRXeWD6eVujpyOLLGiidrjmza6Uy/sYC4x
         PdRYO/XNiEEJU+OKcUVXOhyo8P/nZjqhN9DLer9KcTGE/NVwTcdImb5+SEngKubwvl
         IeoKWNof8vAlstyGm+WXDJGP25gIOdC39Wg6hVzLBJMjO8a6DmmM5hnx37+YEHfCjY
         PDvtSz9h2LsZJS3iozQb/rezVvtiAdkOCvMBr+cjyD00LzCtFKWCj/DgdSL3Td2ztd
         iCSJoZcUgw04A==
Date:   Sun, 22 May 2022 10:51:23 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the kvm tree
Message-ID: <20220522105123.7a177f32@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4r7=ckXUIpcQYEWut3Fg7f.";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/4r7=ckXUIpcQYEWut3Fg7f.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  56b06f47a371 ("KVM: nSVM: Drop support for CPUs without NRIPS (NextRIP Sa=
ve) support")

is missing a Signed-off-by from its author.

("Not-signed-off-by"?)
--=20
Cheers,
Stephen Rothwell

--Sig_/4r7=ckXUIpcQYEWut3Fg7f.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKJiQsACgkQAVBC80lX
0Gw9cQf+JvSzU/kJbmK4whR/cpr6w/JEZ3H0L3B4t/kQ9O61UEpgPdX5DboCSJaH
hAfib8qxotUF/zTfBm/LeTORiL86F59n6GxlvYeN4ST7QW2eYAEQUrONZAbeef7b
fu8AXeAW01BO3B5nGEjF4GR9zhzuiQE6Be94njCkeWlNcYSrDJC8WW9QhCMbI3pc
zQj2wV4RiiE78NGNkatsPKz3Alw2qfK6iTZcchhIFX0McCatchvx49Re1t34wpWg
hn/WvrqXBOYuUtz+rFCjrEz5w3XMP7eLBwSeZADK2btfc3jr8QDqTRstTeyQFUAP
oJp2C3qlEIoFiISeR9MNGdpkpAg8SA==
=ZaUu
-----END PGP SIGNATURE-----

--Sig_/4r7=ckXUIpcQYEWut3Fg7f.--
