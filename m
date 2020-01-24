Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 575B8147716
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 04:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730649AbgAXDKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 22:10:44 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:43905 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730166AbgAXDKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 22:10:44 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 483kfn6BgRz9sRK;
        Fri, 24 Jan 2020 14:10:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1579835441;
        bh=o0gHidCLrnHTuf3U8g/mqnbZ0hi7qjqQzuht3h4WkfA=;
        h=Date:From:To:Cc:Subject:From;
        b=MBJ2WBpQeA/p3rbDIn66q6nlR1YePhXXV2RpfDNPODE3IoTi923HBD7IZdzxmwrfm
         e4mx86p78xx4lgoOPxT71zbZqdLKFMnERDprzBxPyzAeK7JHV4NbebCe3yWxps3cJx
         7XMEFonApJFe90wsK07sNFJkW9vLTmWRyDQyzEhV4tuIFov3nX9waAzBO89nVUpVfT
         E9wkJdsitrzp+qem87+4Ib5qFqA1GSP8tZJuum+ZpPzAmMrl4UhESNG3oioEjiUM+X
         +rg2vA+WuLMoxZ7xi8R/scdTvua4NbPhT2rMwVh6JzSt/Ivc+eFcu1vRzXQEuBBvpy
         3KlhwJfhnXUPQ==
Date:   Fri, 24 Jan 2020 14:10:41 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM <kvm@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: build warnings after merge of the kvm tree
Message-ID: <20200124141041.187cb586@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/xH/3XufaDwGoQtESBF.88qo";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/xH/3XufaDwGoQtESBF.88qo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (x86_64 allmodconfig)
produced these warnings:

arch/x86/kvm/svm.c: In function 'svm_set_msr':
arch/x86/kvm/svm.c:4289:14: warning: '~' on a boolean expression [-Wbool-op=
eration]
 4289 |   if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
      |              ^
arch/x86/kvm/svm.c:4289:14: note: did you mean to use logical not?
 4289 |   if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
      |              ^
      |              !
arch/x86/kvm/vmx/vmx.c: In function 'vmx_set_msr':
arch/x86/kvm/vmx/vmx.c:2001:14: warning: '~' on a boolean expression [-Wboo=
l-operation]
 2001 |   if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
      |              ^
arch/x86/kvm/vmx/vmx.c:2001:14: note: did you mean to use logical not?
 2001 |   if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
      |              ^
      |              !

Introduced by commit

  e71ae535bc24 ("KVM: x86: avoid incorrect writes to host MSR_IA32_SPEC_CTR=
L")

--=20
Cheers,
Stephen Rothwell

--Sig_/xH/3XufaDwGoQtESBF.88qo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4qYDEACgkQAVBC80lX
0Gwf9Af/Qzif++vgn37mQGftCeSVck7w9Sxt4Ib8mBieJVgtrRylla9k6h36fnMo
UdspMst3/lXRB9KffWNbSFgXWFa0MfUcuaXvt/DkUDvq6NLYNQcpY0pseuH2pYyY
DHpKw2cFmsUaKexxu11FXrEPy+HC3WmYch7UFVhea6Z4CbojX3xNfXBWliYQGvdJ
+AvvwuVpb8hfZkV8EDJPU22/48anBVdRCYVFskQSrDWBHIO6Dcq/HgmnQT2lRlIL
lxw0tmu5H4AT/Ttw6SqgOC6op7UxOAMpwIlVItTctVvpShf9GTaHctRj+5cflACy
LUl7o9ve+d19/imEsUkSNgH8t7YeTw==
=YI/f
-----END PGP SIGNATURE-----

--Sig_/xH/3XufaDwGoQtESBF.88qo--
