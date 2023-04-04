Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C026D580E
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 07:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbjDDFg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 01:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbjDDFgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 01:36:55 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEF91BD9;
        Mon,  3 Apr 2023 22:36:50 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PrGj93gY8z4xDr;
        Tue,  4 Apr 2023 15:36:45 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1680586605;
        bh=CB8e9bPABZQu5WY80ij6LydevUEEDlIIkBIhf6NNxfM=;
        h=Date:From:To:Cc:Subject:From;
        b=b1sgGQj6psYOUH/1qqYjTZoSYJYf5PULLIOEn1lD/Q8m0UOipMKygbmuWpAw4EycQ
         jSFLgSlkmX0mL61Hv/5VsQrQJRRiCkk/TjIt2IGl/PswAM0C8teYi9L2aB2PvrnBDN
         9qWpd0HyDXe22yULMNUnkIvFZg7pe2NT2IBU2BzeA5nIPmPGiyOY01TbQJNm+SidKy
         +kGYX7qQJVfEA1yeHWiG2D1NZMgK8FvjTFqIRuYhetdR3NcqxRDc/1aKXs74WzgoMM
         /JBPz9DBQeI0RkLX3GXlt87irgQZ+UGvw6tNIvahjb1o3zP7X5yqiNPtqk/1dMM034
         azEpDt3dTR3fg==
Date:   Tue, 4 Apr 2023 15:36:42 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Takahiro Itazuri <itazur@amazon.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the kvm-fixes tree
Message-ID: <20230404153642.769f5fb3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/BcBn5u0Rdia66C8oKfqI/5d";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/BcBn5u0Rdia66C8oKfqI/5d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm-fixes tree, today's linux-next build (htmldocs)
produced this warning:

Documentation/virt/kvm/api.rst:8343: WARNING: Field list ends without a bla=
nk line; unexpected unindent.

Introduced by commit

  c2594091d0e5 ("docs: kvm: x86: Fix broken field list")

--=20
Cheers,
Stephen Rothwell

--Sig_/BcBn5u0Rdia66C8oKfqI/5d
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQrt2oACgkQAVBC80lX
0GxG2Af/Vo0LYsuw0Ok4r3h8BvuV9hW9Y+ntFkSyNuitfPeNvqqqxj5JAUadLt7M
gUgNiRM0QAqF+caf0mSvdkwMBzio4jeIc3zj3FKvPHKwGbi86DqDxAXDSxb2f6Xk
CrPvubd8LM/GbPhT9WXFixi5EUAVsSUQ4ElN4hPkmB/PZshYN+vjfqi1k6UQJbfb
DBA5he150NOL8N4qnRI3DyRqzmNAX66t14j7Gq0Kdi9+hnll2wByk8iEulI0BxZI
FDIwwWvYvpRkwG8J4mujO1q02jGo19IVKNteTGJdkJyBt9y0jFmPkmFyaeed3/NS
zCDeoI/v7d3NCw1gYZC2Bc2seC7XCQ==
=W93s
-----END PGP SIGNATURE-----

--Sig_/BcBn5u0Rdia66C8oKfqI/5d--
