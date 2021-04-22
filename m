Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4F0367CF9
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 10:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbhDVI47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 04:56:59 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:58139 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235435AbhDVIyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 04:54:41 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FQrn114ytz9sVw;
        Thu, 22 Apr 2021 18:53:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1619081621;
        bh=wD0KLBw6hf0vE0v6urSEUgTuSy5ujikqv3Mv47LYCmc=;
        h=Date:From:To:Cc:Subject:From;
        b=dGypWGoScnYtk1qGJsljc2p4SP0LsFJ6IM/1XuK9Gr5DozeKVX0zb7UjQ3v9xE6w/
         pi0g4Gs9IQkezDBL4GUbpantz07K53WbkF0DVM8Yv9ILJ1Q9ed9VTOJv32ZRjzt9tn
         DUHRvcouc+PeokQk7a501RjHeHLcqPPUNB17oqFKSgOKwSt3HSQkaJJ64G3GKZt401
         z/s36Eq9SPurd6330iqcln0WZQOxiZ84xTetEjoyHarSd9IAKSvpxdDqhhDCgl26nF
         a3p4tvj1HE7x6GYmNDIGx2sQQT1aazzOWLHiXIF5RsA8yn4StTnWlEcDTHePyF1kbM
         AgmMrZok85Akw==
Date:   Thu, 22 Apr 2021 18:53:40 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the kvm tree
Message-ID: <20210422185340.71188325@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ncbyt3IfvXNXrVuSk/VRqqM";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/ncbyt3IfvXNXrVuSk/VRqqM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (htmldocs) produced
this warning:

Documentation/virt/kvm/api.rst:6243: WARNING: Title underline too short.

7.25 KVM_CAP_SGX_ATTRIBUTE
----------------------

Introduced by commit

  fe7e948837f3 ("KVM: x86: Add capability to grant VM access to privileged =
SGX attribute")

--=20
Cheers,
Stephen Rothwell

--Sig_/ncbyt3IfvXNXrVuSk/VRqqM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCBOZQACgkQAVBC80lX
0GzdgQf/YF1mYwL/K8LY8cz1EFWPlM4tFwNvY5FYAbqzArkaIlf8UthOO0Qw1P1/
TGNOdYJfjvYYyZA+0oo9UwEtzfHSOcJbo08jxd6ICxBwPe3RcowYNm9BaPkgZinx
qxEQNQ9ahZ7wukl5JPFv+6YoqNSnjJG85B4ilcrt0Ay0ZH/pjapuoxdooAi11/l9
aTDKj+oAEY2hfgZfnUNJeP2HKKBYYfJE3aLtA80TQdd3if3Izfq3s7MToh12ZLVI
we/8+ntOfSlt3N8Fzqbt4cxQW9+FswiayXxOj5J3yx53bD7vBp/OgsxZAnvsEjcj
vOt3OtWr5E3WsTpa59215wsy/o4yRg==
=aC6X
-----END PGP SIGNATURE-----

--Sig_/ncbyt3IfvXNXrVuSk/VRqqM--
