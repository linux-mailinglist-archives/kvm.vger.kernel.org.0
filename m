Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE34864AEB3
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 05:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbiLMElq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 23:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbiLMElf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 23:41:35 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C436409;
        Mon, 12 Dec 2022 20:41:33 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NWQn74c0mz4xN4;
        Tue, 13 Dec 2022 15:41:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1670906491;
        bh=RGpbmK2Kq3DU6dhKmv7iF7CCwZAe3YtX+aVHGT+WEmI=;
        h=Date:From:To:Cc:Subject:From;
        b=PtLWk6tl9gvnPIAfXRnoAxiSBkep2vFv36BcWEwXMVxKrCE6LwAWt99H65jEMAt8G
         d1D51XZQKjON0PTriJuH7dVJeGJD7F1c42W2vdOtevZCHhycXZywXxhEUP2iNjUEbW
         y4eGWCZihWiagTXGNI/FlI3Td2c6t7Da/p07cLe8HsdftWhirMUU2ZqHgWp4CgCgs1
         L79Ifd8Zz/CkK1j9Xi/SDUG+oF5/7F43AggsafUGPcViXQyWiJCryYZ50nS4VNYGuc
         nBZ0xHBZKPXK18KncRs/zERT7/ZZu7g1ztoR61sNCzYguGo4jl34+Sjp9GLzMYMDSv
         9D2e2x/ugR0Wg==
Date:   Tue, 13 Dec 2022 15:41:30 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the kvm tree
Message-ID: <20221213154130.3f28c512@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/WA19l5UVEWXR4g5yyXT_4DA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/WA19l5UVEWXR4g5yyXT_4DA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (htmldocs) produced
this warning:

Documentation/virt/kvm/api.rst:7260: ERROR: Unexpected indentation.
Documentation/virt/kvm/api.rst:7261: WARNING: Block quote ends without a bl=
ank line; unexpected unindent.

Introduced by commit

  1f158147181b ("KVM: x86: Clean up KVM_CAP_X86_USER_SPACE_MSR documentatio=
n")

--=20
Cheers,
Stephen Rothwell

--Sig_/WA19l5UVEWXR4g5yyXT_4DA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmOYAnoACgkQAVBC80lX
0Gxqbwf/fRJWn2bvA0MWEjlpC9RO/uk7PC8D1Auj42LiUwbTOlKNQIufRPtOOXtW
TbwNE4vZ+qxYO82/aGnd5gFy4IKx5TnS72lj27vol+CWmPhkEZxp2LpPecjh2t5q
sTLUwXjucPmhelG6RuhUQ/yYrqIVrtyTbhk/S6NW9JeTtXb5otgG+FzRzwKbpmkF
cR3wZQoYgTCRsEkOdaxTeNsB4rienNbjv9yO2Y8JrEzBfpBrZ7fpnIhtUAiFmjqk
DX8v64y/xxhy6zuHTTcoZmnuxno0cXotG3wMC2uKyL7U6UeWS+rJ1QHViIknh51s
uomOqG55J2s2/jgj/xXpwKJSp87Iyg==
=rZ3+
-----END PGP SIGNATURE-----

--Sig_/WA19l5UVEWXR4g5yyXT_4DA--
