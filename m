Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DC51B198E
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 00:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgDTWcs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 18:32:48 -0400
Received: from ozlabs.org ([203.11.71.1]:56629 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgDTWcs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 18:32:48 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 495hKT56G5z9sSG;
        Tue, 21 Apr 2020 08:32:45 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1587421965;
        bh=O72eIpCf8zazYzgsrKNeUeXHmZLVFVsmnfoQj4nfRgk=;
        h=Date:From:To:Cc:Subject:From;
        b=N5dxBH/KnfKMZFNwsa+mKD3p6OUnHJafx/Y+aLki50dFyZ0juEUlUINeliT3+oWr8
         uo0aJhBCwqb49oqOYiszM19u99msYcUPkxVovCAH6zcE/x34iXfYEmMJeDMFSBDINb
         pVj/HfqtNf+Bo9AJxSVFacv66jNrVqFvn2/qsMXahWiSK0eEvwqXN4eG0JvyJaGddk
         AC3e6r9/e14woatkEiG17uSZDO4U/GFJW9TGIywxk2CaWzKeAXyFjnh7Zvoev/BDob
         dzAvNZVN57YzgWgWP4IBxvTsnrKLUNQfUh/cbiiVuzRLVOnY/HnERJ7N6BJmytiM76
         kmmFjkJFJgiCQ==
Date:   Tue, 21 Apr 2020 08:32:38 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the kvm tree
Message-ID: <20200421083238.7b2751fb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Lc2QxRh9WBkdpZYm6DCtmPz";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/Lc2QxRh9WBkdpZYm6DCtmPz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  afc541d07f9d ("KVM: x86: make Hyper-V PV TLB flush use tlb_flush_guest()")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/Lc2QxRh9WBkdpZYm6DCtmPz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6eIwcACgkQAVBC80lX
0Gxvxwf+OoPoEMIgMkdqUtjMpxkAYEjo6EXoBx+KwQcKyRebsjTFIU7OlSlhh0Du
CC2bceaJzr/ObFejiL5AwR2aafqFhj2RXLBrVI4TCQegBR2lQTkM25f8np2Z2iYo
vGdjyRO5cZmGU2cMkM/8h3KuJ7eCL9v73FlZ2m7QyvLf98ic3Zc/Y/DJrXDbvXo4
WkmXJ1lUGE1Yb6L4W4SFCUVkV081/tFq5QJZ1DUJmQ1vHpacePJncyHP5qhybb+8
W1hQV3e/TdpZyJXQzz8pAXYjaX8prnnLQhr+vtn37XElYPXIfSfwTESZq4ex7WpN
LAAVciQHB77WBpKwWG3j5HD8YcHiWg==
=r0UA
-----END PGP SIGNATURE-----

--Sig_/Lc2QxRh9WBkdpZYm6DCtmPz--
