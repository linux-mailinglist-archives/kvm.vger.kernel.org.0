Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93644187424
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 21:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732556AbgCPUgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 16:36:43 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:59583 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732486AbgCPUgn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 16:36:43 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48h7Ph4dHrz9sNg;
        Tue, 17 Mar 2020 07:36:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1584391000;
        bh=E1U0xLByz95YzR7wQ4JTZLnx+6/JTGLTX9JJ8HDDy+4=;
        h=Date:From:To:Cc:Subject:From;
        b=Gn7gCvG7273154JZNU6BrZ/vDeU1vVK1IFLAloT5JNe7ihOccVHXDEc3xItWKI37E
         qbRWPLoHwDoJJIPQknxigoUO2yVdYYmWyIJ4Xq8jZQjdeBAHSIGX/x2pl8SrQSSzK6
         yVPu0ZRicpbLBA0nOK8Dx8yrD4edmkNkg5v4VSIfJmsG2n4LskfDCNaj+f+inc6kvf
         aOYiXqahEOeSRBnFw84Xsj5fgKfajho1zVu+Qq3jsj96XFT0A2fIrHSpdOmxS5s/Zj
         U9cAoDF3arw27/S5Z57cPg2OIAW0d4BcrOjFUI+mkz86A+XzCIQdmcnrVId2WpwJyt
         gGVRd34a9yRaw==
Date:   Tue, 17 Mar 2020 07:36:34 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: linux-next: Fixes tag needs some work in the kvm tree
Message-ID: <20200317073634.318d875c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6OgdvJYICiguUsDS=HAoZpN";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/6OgdvJYICiguUsDS=HAoZpN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  abbed4fa94f6 ("KVM: x86: Fix warning due to implicit truncation on 32-bit=
 KVM")

Fixes tag

  Fixes: a3e967c0b87d3 ("KVM: Terminate memslot walks via used_slots"

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: 0577d1abe704 ("KVM: Terminate memslot walks via used_slots")

--=20
Cheers,
Stephen Rothwell

--Sig_/6OgdvJYICiguUsDS=HAoZpN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5v41IACgkQAVBC80lX
0Gzxzwf9HQtaXf5Bs9skXDKbSipPsKnC/xa7uyHpEo9n83bZWiBCOrpxiTG0H8TA
Yp/HSPgkgXcbQFn6q+3fx1K3YUrq0JLoz+YBya4sIjCYyqVzRuOXvRwdlCHpXz3C
G+Jx6osECD1CMln5u2znfQk17qLpoKW4fQKVXZUdVuBFm2hV4naUI25J47znP7pJ
vqFeC3l4TIBzKo3zEnQDwwgU+x+2gZ+F50J9YwE6uecf7stJ7SSQHFCe1cIqlBgP
txsq8nPy0jXDbN+ifohbPsQOCW5TfWqoSEXCwm2q8ilkyMqGNP/rTPCbQHtRvLiQ
akbILx1xSlFy2qh5Jy9ZwDsMBP484A==
=b46K
-----END PGP SIGNATURE-----

--Sig_/6OgdvJYICiguUsDS=HAoZpN--
