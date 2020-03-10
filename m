Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1402180B14
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 23:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbgCJWB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 18:01:28 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:34347 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727688AbgCJWB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 18:01:27 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48cTZF1NB6z9s3x;
        Wed, 11 Mar 2020 09:01:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1583877685;
        bh=wzZzebi45AhIS8HGeVFhdyHkTlG8O3pVyWnqNN9rlqQ=;
        h=Date:From:To:Cc:Subject:From;
        b=jVjC6Nju7T0T9y+wjzfdyl/mtjA8IR7sw+h4jd/f7Ti0Pd40VyYazZf2eRRWGU2mJ
         PMqLMtTwnNkj3c/CHqenS59dGXobbwChG76kOW9xmamf5QnIyr5FK1eRI1sIZ2FaB0
         Bwjj+3QYsrECTk7K6BrA2eptDTkI3Hb+C8mSO6rAoAAkGKAcS54fhRGdya0LcP2sfd
         wpJVBUW/zwHo0xZaI0kF0wMR5/8TnYhOkOsZOuYz/Le8XteAsq7frdw8bLNcGq6mLf
         RwgMpX1YvHtGgNcFe5CG/0TlaZv7FMXzY3cKdh2nbwpGk2WgXWjeR8sJ/knchFE/9w
         1tv7+owRHiwVw==
Date:   Wed, 11 Mar 2020 09:01:15 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        KVM <kvm@vger.kernel.org>, S390 <linux-s390@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvms390-fixes tree
Message-ID: <20200311090115.3967bbc6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/kv.9uJJpUfaryogAyL3K1zT";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/kv.9uJJpUfaryogAyL3K1zT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  b5de9eede579 ("KVM: s390: Also reset registers in sync regs for initial c=
pu reset")

Fixes tag

  Fixes: 7de3f1423ff ("KVM: s390: Add new reset vcpu API")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/kv.9uJJpUfaryogAyL3K1zT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5oDisACgkQAVBC80lX
0GzYaAf9FXBdN/sPL0m1wS/M8NvQrp0wWqykM2mze0kNV+wY77eqasWuk3dSkCZQ
YOWpjCN/T6FTBwJpiNLZMtgoKYOKFwkPToNXjCNkl+3sXrp/8xhKREmnobTSpqyP
XWhIzMfqyXRn5/5gWg44M/pVIE5KIDeDxZzeU4tbcDCCsoHOeqkdne1n7KOkRk+L
yTw1hgzfqPeT6uegHLvSwgO1K1XwLDZagZJrPzdMgr5wGvMMEe6J4gk7msoXBpia
3n+gZjDjDeYb8erVrRxqR7niqGb7vIPeeKkP4PNVKxnVoIg2N0/kLrQHHvnZGEaU
prhFRX7EBNh0WELfnGmQDRa/L3c75Q==
=IiMa
-----END PGP SIGNATURE-----

--Sig_/kv.9uJJpUfaryogAyL3K1zT--
