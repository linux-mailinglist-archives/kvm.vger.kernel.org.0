Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C10CF97A96
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 15:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbfHUNVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 09:21:10 -0400
Received: from ozlabs.org ([203.11.71.1]:60273 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbfHUNVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 09:21:09 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46D7b70shPz9s3Z;
        Wed, 21 Aug 2019 23:21:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1566393667;
        bh=A3n2w+elgnVQa/Jv1MFvQCT0FgiohlYlMgcuvSnKApQ=;
        h=Date:From:To:Cc:Subject:From;
        b=HFUHr1mCf3Au39dBxLalwFPWq39r/FIFrLTJ036VLVE7U/D1PjguabsLyPINvOcbH
         MICbByJvTHjqAnim4IocTIswLTFeMFYg06x7hgfSJOUc6eXsyUQxdMV6x9ffDMbLvs
         hf+F4Z/Kv7OkqZo/Yw1FT2ythBq6eR1oc8mJNOSuJ9is9fRUidhRxexSpzHcoAGdph
         MEUxQJMZzurTN97zyS7K4vHeVupUewghfVzm4qUanpCo4Fwz7N3yMbmRxqXbeDw+6W
         anOLxh6IQi228Dd4aofyH5xJhRXCLyRGrMZMseQsckjbVMxzZlzgW/qZGLMk+OHl8Q
         2qYTOnp9JfrsA==
Date:   Wed, 21 Aug 2019 23:21:06 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20190821232106.634dfa36@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/PVtkFaRcdxOh9yZnuy22eMc";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/PVtkFaRcdxOh9yZnuy22eMc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  d012a06ab1d2 ("Revert "KVM: x86/mmu: Zap only the relevant pages when rem=
oving a memslot"")

Fixes tag

  Fixes: 4e103134b862 ("KVM: x86/mmu: Zap only the relevant pages when remo=
ving a memslot", 2019-02-05)

has these problem(s):

  - The trailing date is unexpected
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

--=20
Cheers,
Stephen Rothwell

--Sig_/PVtkFaRcdxOh9yZnuy22eMc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1dRUIACgkQAVBC80lX
0GxgKwgAjFOJIKX9ANOtuELn/W6DlkbXtrxcmnkHSdvP8Nuko6gocFU+djNjeV/U
AQxGSywEMEUGTpuU2cuVUa6vPISn3TlgIU8hJvwy6ERjTsEDzPLggDE4A3AMkVcI
H29kxzgxzdLeLhXAiiPQ0pOKm9s+ctBMae+2AWqLY0OEHG5EprkUHrllTlOzEEYi
RJQM8BBb8M3rWjpIakmFiOt/8DcXnirj2kV6F68DVZTlDIFu5/3uufdDqYP4U46q
H/o76fjl7td2IAZEnq0wYmiHBww/6NDdCFj5VjdyAr0UEZLa7QsvjzalFpAQd5nm
VdUau+kSnKNPYfEMZiIoeC5iCYVQcg==
=Sorq
-----END PGP SIGNATURE-----

--Sig_/PVtkFaRcdxOh9yZnuy22eMc--
