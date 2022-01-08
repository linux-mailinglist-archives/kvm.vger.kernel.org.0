Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30793488220
	for <lists+kvm@lfdr.de>; Sat,  8 Jan 2022 08:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbiAHHY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Jan 2022 02:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbiAHHY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Jan 2022 02:24:56 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C58C061574;
        Fri,  7 Jan 2022 23:24:55 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JWBS5215fz4xZ1;
        Sat,  8 Jan 2022 18:24:53 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1641626693;
        bh=4Oi6SAO0gtr5q+eZOeJdXgsENrla7hccxRm0YSld2UE=;
        h=Date:From:To:Cc:Subject:From;
        b=RDdXyReoAVbqXAQAqdrmpYWtn6428cRy+2aKdWJxGiPKVGBb4VQg0EZ91delI8M8u
         0lBr+yLCGGeDBevQA9ErpD+PC3wPv/yiLyJKmzBNrd6aKKXrfvc37On86shNsuk+Nw
         86O7dHPZ/zRkiW4xBxhjQSJlBV2gvRmYdCFUVFU01RZyvd5vkHdiTRv1XpMw3toY01
         HsEwip3Fk76D32+RUIpG7gYOwC8HoS93BKAqKznPyLvX257XR3ZBlo4IovCJQpoOgI
         2+Ygd8HtRN5MZMM0WpnZZiSPhNLGNkNKKQlYTYXx7hstRE0TsQLFayXS/ykKBCar6o
         CIE2CIkWVQdag==
Date:   Sat, 8 Jan 2022 18:24:52 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the kvm tree
Message-ID: <20220108182452.6224558b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/=crcFEtHqMUP+QU.FZRkf/R";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/=crcFEtHqMUP+QU.FZRkf/R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  907d139318b5 ("KVM: VMX: Provide vmread version using asm-goto-with-outpu=
ts")

is missing a Signed-off-by from its author.

--=20
Cheers,
Stephen Rothwell

--Sig_/=crcFEtHqMUP+QU.FZRkf/R
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHZPEQACgkQAVBC80lX
0GyZ0wf+MVOGKFIz+SeNQXOC9gtIufu46FHTTcCGpGGRyubr607pQJjgWBeS197z
3ylsxG7i8Rs0v1INPfVwPF4Y6t6iHnzAzvfTa7+hbvpVB2MK6qM54rLkAdpKLEac
RJ/zAqpqGEX19COEhi3rZsP7OqmySH0S+0jQkUJLmnWxuo1wkbLtK2ITiNCRibBR
CE7VGDI+MfJMbES2cFSDsR0al23YNuLsRxh33BPfCRiCQQMzJuu5B8fff7frKv6t
6B6YlAULUM9n5wQqUpOGx77dwME8DRv8a9oJHb10V14YKj8I/cRyfAjCa/ZV/aEz
eeukdVq2RG/CNnImt7rD7rY3LEtDGw==
=/8mp
-----END PGP SIGNATURE-----

--Sig_/=crcFEtHqMUP+QU.FZRkf/R--
