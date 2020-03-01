Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3097174FC4
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2020 22:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgCAVFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Mar 2020 16:05:47 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:45037 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgCAVFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Mar 2020 16:05:47 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48Vwm8370gz9sST;
        Mon,  2 Mar 2020 08:05:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1583096744;
        bh=ZSbkdMpMpdF5lvPMUhVIz8Aj93wihvB1224JTqYZAaE=;
        h=Date:From:To:Cc:Subject:From;
        b=Qd6LEYHbinl8xDZCXgScg0s2ZhXoquCby7PxYfORLDBi8SRLl2nyTclmNPlOlOVv6
         0P0eGrEduU69RyCm2TWr7J11OkLBl7Apzzbnw/Mri9aA3TZfZQbJiQTLVpmX/pqSVB
         9h9ubGM9ZaTFhZvgQy66qJ4RDjQJ98PICNBHOva+hl/6YnTppxytH8V6d/s+HC4aJx
         MLtd8RdS39RbQuTE0d+w7yDZekkcT6G+9IYK9lkRJLXskirnXbfScZOQzqaL8ifA8Y
         PRxEr9AB0yyskixCZsIUYneXm3H6X05bf6fBTwDnsLQYeysCbvGsEO7yPjAbno8pKE
         rWgs4zM3999hA==
Date:   Mon, 2 Mar 2020 08:05:43 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the kvm-fixes tree with Linus' tree
Message-ID: <20200302080543.51450371@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/7rWHSHf1RaPiItDCcNSWExn";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/7rWHSHf1RaPiItDCcNSWExn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm-fixes tree got a conflict in:

  arch/x86/kvm/Makefile

between commit:

  cfe2ce49b9da ("Revert "KVM: x86: enable -Werror"")

from Linus' tree and commit:

  4f337faf1c55 ("KVM: allow disabling -Werror")

from the kvm-fixes tree.

I fixed it up (I just used the latter version) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/7rWHSHf1RaPiItDCcNSWExn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5cI6cACgkQAVBC80lX
0GwgEgf8DkjI/M5iBYlJlr2nsrJ6GC630tdLdAFXhDdSD/uW/a9EzjNVbkUc2Z9P
EZKrPiZwm/8gJjvvBbgUWDat2WCDbuk1Om6FOas523gF8gGx1UIPx8GJxiFRzx0H
0tcUxhXTrMcK2KEb2z7ZaFTdwwQwWng0Cx1qe6bzoeq61IUeYVNEu2CXTpKfoziA
a0oUh8k1oULa61fxz8z0TdKh70WRDHr9P6AMNdAgW87vSQTSGJgzbyAxBO8Fvled
iv0wCxv9r5lLof84Lz4IcpjdUJBygs6kk7eJBfuvElXh8Gt4XH7IG0y8wWpbHLMw
DNNl944bec16oLgHBVI155HGZrxkug==
=IrIj
-----END PGP SIGNATURE-----

--Sig_/7rWHSHf1RaPiItDCcNSWExn--
