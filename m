Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A147C63E662
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 01:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiLAAUn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 19:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLAAUV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 19:20:21 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134819FA9F;
        Wed, 30 Nov 2022 16:18:34 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NMxWD1rmrz4xN4;
        Thu,  1 Dec 2022 11:18:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1669853912;
        bh=DHXAAR9V23iPaeDoT3PCmOyGLtauQGzTbCFlJUi4dSo=;
        h=Date:From:To:Cc:Subject:From;
        b=LRuZjUK7ns2IL9SKOPyEDwCs2RR+EeYt9chgJHnUbD+Zr2lGrxqEZ+8KEqk6cX4j7
         FCuyFVaVaJKzm1ZfHiy1Gg5rdF/IKe8eqRzLq+dpS6jGvvLAsOZfGhC5YeWgMW09gv
         z5SF2NIgT/oFSHqSFYGkcGDE5RfLX9hZyOmdvGfxXTBFUPHBKkF+UQ6JdcqqrfcZYu
         GCUQBHpYp7Q4M1oumXYmfJpEJ29yYCAWTuAZFVPB9IVA7UdY4n8u8swYZ2QXfpSXh5
         +xYANEpp4qf2pEOe64SSosx8dEQwRkchNEa3SEP6Ie6ZX4S3rTpvMOpVXGG1X6gAUU
         +Sxe/i7JadPjg==
Date:   Thu, 1 Dec 2022 11:18:31 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Kai Huang <kai.huang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>
Subject: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <20221201111831.1d90feec@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/UPKo7CWYNIS8N01YbgFtF_j";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/UPKo7CWYNIS8N01YbgFtF_j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/cpuid.c

between commit:

  16a7fe3728a8 ("KVM/VMX: Allow exposing EDECCSSA user leaf function to KVM=
 guest")

from the tip tree and commit:

  047c72299061 ("KVM: x86: Update KVM-only leaf handling to allow for 100% =
KVM-only leafs")

from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/x86/kvm/cpuid.c
index c92c49a0b35b,723502181a3a..000000000000
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@@ -664,8 -675,8 +675,8 @@@ void kvm_set_cpu_caps(void
  		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | f_xfd
  	);
 =20
- 	kvm_cpu_cap_init_scattered(CPUID_12_EAX,
+ 	kvm_cpu_cap_init_kvm_defined(CPUID_12_EAX,
 -		SF(SGX1) | SF(SGX2)
 +		SF(SGX1) | SF(SGX2) | SF(SGX_EDECCSSA)
  	);
 =20
  	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,

--Sig_/UPKo7CWYNIS8N01YbgFtF_j
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmOH8tcACgkQAVBC80lX
0GzudggAjCNJsJ90/FraN3KeafR/Qd3GuNEjReCc/Z+YqGN/SJK64QESotbN0ABP
LoNpnG2uNIjaC5mfLgzAVOpzeUK+Z/I3HzSXRRg1GWqPAfo9RnQcrM+7X+ygx6fe
3vx5fSAGoBvR3l68x+aZWyj9BG/ivWHsQS4Nk0b5ajYA/dlUPeKc7GYiPgLi0BeL
mHFqJTqHIqQlezd63//r1iyy/JnPCkP2TaOWZREC0N5h5D2dKekvDUimw2/l9GPB
9kp6g17g04EVAFWjI64XICJPcZOX1EyV38iIRvD4KmYnAxlM3Xtkn/En5YNHeAy+
X8q6ATRSQ4ciFkMp52HNrU9amkr/pw==
=pEwT
-----END PGP SIGNATURE-----

--Sig_/UPKo7CWYNIS8N01YbgFtF_j--
