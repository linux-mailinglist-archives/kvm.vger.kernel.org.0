Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A234FC73D
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 00:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350400AbiDKWDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 18:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350354AbiDKWDN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 18:03:13 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CA112A93;
        Mon, 11 Apr 2022 15:00:53 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KcjTp63hwz4xQr;
        Tue, 12 Apr 2022 08:00:46 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1649714448;
        bh=31h0VgX2fyThn2NYmi2nE9MwJuhc+Snj7+FPi+GWQEE=;
        h=Date:From:To:Cc:Subject:From;
        b=OalkbdV5FEPQqL3fHwhVe9vjMFckCxGFgwwLdMtFJ1KYjxUkz0vMWDLKWO9lTooJ/
         WYSHOOz5H6b91uqxRX43C05YeHxki0fuOcDvGRHK+GZ/3EGB3m3ber2lVMYrHEiSWk
         LTUnb22jLSnNK0M7zDuduiwybzjbDLpUSGfqF6PLUzNl8bLPrpPa2zzoxpPnplY4zt
         D5TE/9B1cnoCQpuxskb4O01n3tbO8l+ZRL1h5qLh0AOTNtM4WJYzUF6EGeCMXWv5Ak
         BPs0C3+/fyN3J3mEGjCgZuWr5ph/w31lmc/mkvgmitukPCMSPITS17krKLk/Pc6qnu
         eFvMySPap6a6w==
Date:   Tue, 12 Apr 2022 08:00:45 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Anup Patel <apatel@ventanamicro.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tags need some work in the kvm-fixes tree
Message-ID: <20220412080045.301da5ef@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ut_K79XkU=WX26nqHqmCr31";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/ut_K79XkU=WX26nqHqmCr31
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  4054eee92902 ("RISC-V: KVM: include missing hwcap.h into vcpu_fp")

Fixes tag

  Fixes: 0a86512dc113 ("RISC-V: KVM: Factor-out FP virtualization into sepa=
rate

has these problem(s):

  - Subject has leading but no trailing parentheses
  - Subject has leading but no trailing quotes

In commit

  ebdef0de2dbc ("KVM: selftests: riscv: Fix alignment of the guest_hang() f=
unction")

Fixes tag

  Fixes: 3e06cdf10520 ("KVM: selftests: Add initial support for RISC-V

has these problem(s):

  - Subject has leading but no trailing parentheses
  - Subject has leading but no trailing quotes

In commit

  fac372536439 ("KVM: selftests: riscv: Set PTE A and D bits in VS-stage pa=
ge table")

Fixes tag

  Fixes: 3e06cdf10520 ("KVM: selftests: Add initial support for RISC-V

has these problem(s):

  - Subject has leading but no trailing parentheses
  - Subject has leading but no trailing quotes

Please do not split fixes tags over more than one line.

--=20
Cheers,
Stephen Rothwell

--Sig_/ut_K79XkU=WX26nqHqmCr31
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJUpQ0ACgkQAVBC80lX
0GwGcwf/aYL8X2y3PSPa/C3+C2yWdnuBkFRWSKZnJpUOMHsQn7Qalucz4RFtHa3j
6DRtLZbJa9qT5CiQX12DsDO6ZjLsxf5ume0e9mUANr8u5qv06VX/JwUtqqy2abAp
oo8Jddgvjk2Fh3dDT7rl7JCmqfF1+jFT2HHyM1ZESAKH1r+t5E9+EabUvXP3zbNe
PU+ySAOf1sEWArNonnqFzqNIGmo9vUj/IR3wR+AzpS7br2bxVd/6CUL06wGopZo2
FQXYv6UjB4YiDXYm2GHLwramFwHGaCi8Gy35NQmuG7nOuBhuppKjYbC9Gp1+aLlf
Bp7hlab+7oEYcNnaEsb2TMSKGH2A0w==
=VjcP
-----END PGP SIGNATURE-----

--Sig_/ut_K79XkU=WX26nqHqmCr31--
