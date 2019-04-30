Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C903C10226
	for <lists+kvm@lfdr.de>; Wed,  1 May 2019 00:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfD3WBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 18:01:54 -0400
Received: from ozlabs.org ([203.11.71.1]:38681 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfD3WBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 18:01:54 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44twV72Frxz9sNd;
        Wed,  1 May 2019 08:01:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1556661711;
        bh=5xzSzJd6P+awFz45jW2IFDLAXiVYATqaN0Pky21fDdM=;
        h=Date:From:To:Cc:Subject:From;
        b=h7UQQnn1QRDMOuvQHgZiuIq5AOKry0AfxxtHJJDmi+uyER+DGnrfS7uMQGOYHlHM+
         4RlnFQNzX15lKj9mzqmJIP5gTZf/A18NAVRhTMRNAqJwVFcD0C/2M/bFKbqFKn9PNm
         ncwXVs8uJVBpf5oJBvRtjodfTxsgUJRNpUCG/0uSuBx6Pc9H9k3ldWEeA8LvsIiDP1
         nrXvEXUB9Uu9H6KpOn1pqi4euRkU2pK3TZzvrQ0zt0RtN9b3EBhZosKueuqnceeEDX
         TJTt7UXSHP/C0DZwu8nvceOghqGKYruax8db9YausxDNtcUYVBBv4QwcTSxV6rt7Wp
         Wmr/u8Io0Ggpg==
Date:   Wed, 1 May 2019 08:01:44 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20190501080144.639ed144@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/aZ/E_6A3AqwvrrjhIZx4R.0"; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/aZ/E_6A3AqwvrrjhIZx4R.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  76d58e0f07ec ("KVM: fix KVM_CLEAR_DIRTY_LOG for memory slots of unaligned=
 size")

Fixes tag

  Fixes: 98938aa8edd6 ("KVM: validate userspace input in kvm_clear_dirty_lo=
g_protect()", 2019-01-02)

has these problem(s):

  - The trailing date ine the fixes tag is unexpected
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

--=20
Cheers,
Stephen Rothwell

--Sig_/aZ/E_6A3AqwvrrjhIZx4R.0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzIxcgACgkQAVBC80lX
0Gz04gf+OOlOZJQ0JfEk03Rm/muVUhLvu5k7kUeDkdbeAl4krsvvg+XghkAm/s+q
qP66SXi9c3ANrFgBhZ2lycwWyGW9vStBAsCJRN0OvfB2Bj0F4ebEJNTYKl5tc+ja
8qWpNdPkOUlnJR+TIoIW8+c2wV2olI6w4lb1Dm4r3HIK+tmAWmXx/12boXKSLwiH
iz6G3nC4VGD3mbuY7lww4S8DD2AsFllTa1IzGm14RvSGgjn4/peMWkEE2vU64Jz4
Yi1xF7RJUbUg24tGRwve8vmR7Dv20Uqv4G1apd+E+jqnF7FQKbeQx8rwlq8WHDoR
WfntJQ/wmnWfzCtTw+frXNt2F95uyA==
=pFs9
-----END PGP SIGNATURE-----

--Sig_/aZ/E_6A3AqwvrrjhIZx4R.0--
