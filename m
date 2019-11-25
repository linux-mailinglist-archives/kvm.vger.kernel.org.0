Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF9ED1086AA
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 04:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfKYDD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Nov 2019 22:03:59 -0500
Received: from ozlabs.org ([203.11.71.1]:36819 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfKYDD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Nov 2019 22:03:59 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47LsLj2Qzpz9sPK;
        Mon, 25 Nov 2019 14:03:57 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1574651037;
        bh=gdkbbamXi3Voi0pJHre0WVAHR+KZy1uw4Laxa9NGXrs=;
        h=Date:From:To:Cc:Subject:From;
        b=K3ss9+eB1GERj1Zkzh6CcAi564Fmh25lWXIaNiBZdA1c+BPFNdMl6H0ZMpDW4wXIG
         7n214Zybb/fxVAsga/fd8ivi3F6ioxwcKMqbwiBi3M//7eML0uJrTaezdq+zeVC0t4
         QwApNtKD+Y9A0qUAbSsOEeP1HZ360QgUUDoNg5RB2rPwR4fsB83W6JQnym7wEYgK0+
         zBPVrVa/NDQ6xoVvUfDY3grQoVXqzOwxcHLOm3moPeR6/0vvLNu/ooO/70nmQKPz/7
         dkMs9qMQqdk+5eWzwILaIbrojYkNL8xtnQoiHyJ45HT60NWgAxZKwHVb23uwVb/9nf
         29XSeLVtXCuRQ==
Date:   Mon, 25 Nov 2019 14:03:55 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: build warning after merge of the kvm tree
Message-ID: <20191125140355.41606a60@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/B13z5/8G.7wzBgrGSWPUJo3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/B13z5/8G.7wzBgrGSWPUJo3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

WARNING: "kvm_get_arch_capabilities" [arch/x86/kvm/kvm] is a static EXPORT_=
SYMBOL_GPL

Introduced by commit

  cbbaa2727aa3 ("KVM: x86: fix presentation of TSX feature in ARCH_CAPABILI=
TIES")

--=20
Cheers,
Stephen Rothwell

--Sig_/B13z5/8G.7wzBgrGSWPUJo3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3bRJsACgkQAVBC80lX
0Gy8hwf/ZIQBcmeKkb70dBohQsZE7wGGH3mi0L7IlEBmkXRNwoAtxWYqpbWE0UBH
J+9kJQRZOLxdQgyiU974FqGYkU6n6J0gh/oVE+9I9s77yUFFR1xob4uF++uXgmDh
ArVY2V/eqlRZ4HHSSuVuPmbibI474UvQUbZpMl1NAY0mV+Bp2MXgM4wKXQayNRTL
1kEdOsl9CpFlEZ6qbqN23w00OtBHeoMSa3GZI3OP0tn5lSto48RFyhGIPJtxQ5pk
3mR8Ymm45HjN8S1dUuX2J2qRcy9iII0P9xBHOPCQGWnmtwDOaAvCsrMHugxYKeCL
D49HmqDo/NDaZ9IO2yyW+Hgph/8opg==
=4CX7
-----END PGP SIGNATURE-----

--Sig_/B13z5/8G.7wzBgrGSWPUJo3--
