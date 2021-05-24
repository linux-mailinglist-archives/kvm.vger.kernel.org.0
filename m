Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D03038F644
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 01:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhEXXd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 19:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbhEXXd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 19:33:57 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BEBC061574;
        Mon, 24 May 2021 16:32:28 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Fptm712zLz9sSn;
        Tue, 25 May 2021 09:32:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1621899144;
        bh=R//UBP3I4gk7Nu1ajpoLEfWbDGM7+Ta6syJtcvbDEl8=;
        h=Date:From:To:Cc:Subject:From;
        b=RAug8AFFihouSinJi36M5Zv/zn+sEuYy5jiimldYHcz2VabD4BBxlQoFS4/jHXWqp
         kJPmhB5ja8h6buN4LKk6J5Ot9yPnCEIkB5M1gHzcfqJzsZ5kgXwFcHZixNDK20fQ7F
         fojHfaU3EejF9CC9oapvcgxIy9cgVUOmG5xUGszHqFvKcJ1+gozmfkSM9xeFSuWaxi
         lxPcHV1LqsNRE7POFRKk6oqEoXejWNxDWAWxRN9K7wSMnFayaM7SNLE1aQirvDos1z
         qM/poNoKLDJhwozDVYe9+hbVGnNHChGzUD+Z7UglynezKN5hixOX5ZfPL5y6TzKZEG
         IapTEaPpkQStA==
Date:   Tue, 25 May 2021 09:32:21 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the kvm-fixes tree
Message-ID: <20210525093221.1b62a5f4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Z1iCdp2gUzSu7CyUEtrQIrb";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/Z1iCdp2gUzSu7CyUEtrQIrb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm-fixes tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: modpost: ".kvm_vcpu_can_poll" [arch/powerpc/kvm/kvm-hv.ko] undefined!

Caused by commit

  0fee89fbc44b ("KVM: PPC: exit halt polling on need_resched()")

I have used the kvm-fixes tree from next-20210524 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/Z1iCdp2gUzSu7CyUEtrQIrb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCsN4UACgkQAVBC80lX
0Gzf4AgAhp0w5DSqtCsrFNqrKkz6dPUXzhLuKVVl57CfATZGdQ0HjgmHcgNwq1jO
kitQeWxEbWkitDlAfp+LYDXRZp3RdCfU1JF8d6LwQoaLDTwUJ5wD5NxjXK/UDfkX
q5bpAVztqiKq2LKM8tIJ8gPaQRn82Adhj0G62nwqCXYoEchLHBM7SVvu027aoUDc
2p2V77FhEUEj67wB/Lgj4NEr0AkgSjtkpvgGC/yQmLauZ4y41ApiIAxi3IEk/nVj
4owPaP3YY4eOIIFQrXNAFruultbLy8tpwSmx436JhfWW3j1nVSgoad2zbg5agffV
IB57FUPKN4jfJpzY/SkFI5EuZCjNGg==
=q0Ef
-----END PGP SIGNATURE-----

--Sig_/Z1iCdp2gUzSu7CyUEtrQIrb--
