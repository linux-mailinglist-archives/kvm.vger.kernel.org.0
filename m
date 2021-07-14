Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00353C9377
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 23:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbhGNWCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 18:02:02 -0400
Received: from ozlabs.org ([203.11.71.1]:51047 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhGNWCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 18:02:02 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GQBH02M5Tz9sWc;
        Thu, 15 Jul 2021 07:59:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1626299948;
        bh=lZowu6TCncgieD+03LVBGwmYWkQCp97oyX8y/Q9Rc9Y=;
        h=Date:From:To:Cc:Subject:From;
        b=C5yDZwaTV6o2mYte3adh9IMH+BL0wG1MJrJix5xD+mnWLAnECXB4Jm6xAt+cQdGb5
         VrPwZr6MXmfQEIkAC9JRbop/G79n39bKvbperfQT3mK2Sfjmp7saCfqcfQmt41Lckk
         4+39HecmnrAJ5X/SuhYX4ARGK7Hi9lENK4XACRmGMBriT8elvjQN96hlnxDWZizKmc
         FF7uZVLxhov2YQGXcPVWojhbxwQ1UqOzD7c6Zs/5IdDmJz2EpElV/ypGZFNbEA3ZFA
         x1G4Z8q8lQ3eRDOJOKIRw0INehrt/u/XrcnQz+NvEkjR3c6JL7DE0+IzIV4AFdLmAR
         sDkJ67S/hYQlg==
Date:   Thu, 15 Jul 2021 07:59:07 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20210715075907.31dad3c0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ijlCBQh3P8OVD=wK45frHrc";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/ijlCBQh3P8OVD=wK45frHrc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  23fa2e46a555 ("KVM: mmio: Fix use-after-free Read in kvm_vm_ioctl_unregis=
ter_coalesced_mmio")

Fixes tag

  Fixes: 5d3c4c79384a ("KVM: Stop looking for coalesced MMIO zones if the b=
us is destroyed", 2021-04-20)

has these problem(s):

  - Subject has leading but no trailing quotes
  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

The date does not add any useful information to the Fixes tag.

--=20
Cheers,
Stephen Rothwell

--Sig_/ijlCBQh3P8OVD=wK45frHrc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDvXisACgkQAVBC80lX
0GyuSAgAnGeV4+kvfhESqf5yUx7Tg+irDAB072Xev8MdfbQR+IG1+4GBN/Cuz5Jx
HQ5tgL9+TTmSDO+mmFxAeKUqpW3iMH4DMeiHPkLjG1WmGgFkzFlYnQWhRc5LWO9K
8IXhuDKZoZZKArd4iZRLZCIPxP/Uh5k3nd4aCSRAgNZBjOiZry3BijHcHfKpBfKH
mon49DsClmzEH5xMNFEfxp9467tbU/zN5sti9KkhJ99Ygz9xkK70YhdERUPKCpeO
JxTzUmiQOec2YlytFrT0DVZLQOmZdU698wC3Rn0GwyeVKmtfnvYKLWVZdAQbqPd9
ShreqKKJ/bCCvzgOnuwZG7DAavFtwA==
=ppK5
-----END PGP SIGNATURE-----

--Sig_/ijlCBQh3P8OVD=wK45frHrc--
