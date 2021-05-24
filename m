Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB5138F549
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 00:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbhEXWB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 18:01:28 -0400
Received: from ozlabs.org ([203.11.71.1]:41509 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232911AbhEXWB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 18:01:27 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FprjQ2Vsjz9sCD;
        Tue, 25 May 2021 07:59:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1621893597;
        bh=G2Y0e7wWrKIKRqOW15v6KmOSfL/fu6zcYoSI6jq9krU=;
        h=Date:From:To:Cc:Subject:From;
        b=TSxZz8AGFlIO40LsAhExMdR0QFMHq1kzALDqc6MAwNejQuk/mi4AcbE8OrOS3yJyY
         8kDvom6/ZGDg+6Y+9MlbgszXZHjxVSTH8BoSldqDA6oH8Va904LbSjHdAcrTpeH55J
         3rnudh5Nzc9bz72qeafFGKd7WaQQyMLUjQuFFu+Fdr2XE7zUNGP3UDnrAi2nqKA3H/
         Yb6/piXpTTzVA7fvyh2D6fyquR51ENdw161F9u409p0xaExYB5mMRo7NT374r9YGs5
         2AHEeFXcvWVn70Qgq07f6roiZNtUe3uD3ul07yr9iLZlKLdjiJ2yR5FbrHmaO9oyzA
         sxmlpnhC5U7oA==
Date:   Tue, 25 May 2021 07:59:53 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20210525075953.78857fee@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/_ez4FV699I61gMjAAD0M4p8";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/_ez4FV699I61gMjAAD0M4p8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  1c017567ae24 ("KVM: X86: hyper-v: Task srcu lock when accessing kvm_memsl=
ots()")

Fixes tag

  Fixes: e880c6ea5 (KVM: x86: hyper-v: Prevent using not-yet-updated TSC pa=
ge by secondary CPUs)

has these problem(s):

  - SHA1 should be at least 12 digits long

Probably not worth rebasing to fix, but this can be avoided in the
future by setting core.abbrev to 12 (or more) or (for git v2.11 or later)
just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/_ez4FV699I61gMjAAD0M4p8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCsIdkACgkQAVBC80lX
0GyDPwf+J/LbmSRgwIccwiUESsevPMwKZxBQ+obDqA1YSJhqts+a/j2rcovfLhZD
Or2aHlu2haj6XJfpmLtHNZJXjBQ6OQBJIr4rFxnoKp/hFaKj75iKcZeiXY1NPFo9
rg4zAoIUC4omOGW+L8/xwSlesFR9VNjHw+A/cSkySHu4boZ7iKDNnNa569wCWiES
mPZg1nTZ6sQ3qlT28KxwEAOT7kKMdQNZYX5/DkTEPBpz73pcNParfwQ0Wol3OYnV
zS4GSy5Q9IpJ+C8CnSiO1u+lC55WTHk1D5pQHMejfSgFwQN28mveTneTFUvP/s3I
dzS52G5BBsmv1NOu4mVlyzEVeedGKg==
=z8d8
-----END PGP SIGNATURE-----

--Sig_/_ez4FV699I61gMjAAD0M4p8--
