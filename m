Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D375063E655
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 01:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiLAASU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 19:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiLAARN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 19:17:13 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA1E99F23;
        Wed, 30 Nov 2022 16:14:14 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NMxQ92HzTz4xN1;
        Thu,  1 Dec 2022 11:14:09 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1669853651;
        bh=WOflUL9wdmBgWPhKgKfZ1BiVppjOCZcEv0oN6Na+PAY=;
        h=Date:From:To:Cc:Subject:From;
        b=o+MC33OCmCIcVlQ4YONnnjWyIaMYaVafTBF0cNtvyd5xO9LjcV/ziSiLrqL0fOQFw
         94mEAz9JyFLxGlMiybB6eQSFA1qcSulGkdZaK5oVoMCT3xwXwRWqiCOlt0qrE/6cHA
         xWRwMqaqnLFrebB2s+KBFwf18dsPwurNP6F1usqrZ7vdAWhw55/kOgnCrr9eXa5+HC
         GO6JMP8BWDxOb/sx9KQnKDXArCvdv5IEXrz3A89yM5fdu+VT2nWh9C9id44IPq5RPW
         jz1Gmd2ZKG6kspsRsOXM5uSKb8OxWXpBJyi0WeUSOs3QuGB6nR39hazJNS5ioDDpUN
         Hw3pMkbB0L8eg==
Date:   Thu, 1 Dec 2022 11:14:08 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <20221201111408.05e4edaa@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ZtuWN5ZcZZIjNR0uvB_UDn1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/ZtuWN5ZcZZIjNR0uvB_UDn1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/include/asm/cpufeatures.h

between commit:

  aa387b1b1e66 ("x86: CPUID and CR3/CR4 flags for Linear Address Masking")

from the tip tree and commits:

  6a19d7aa5821 ("x86: KVM: Advertise CMPccXADD CPUID to user space")
  af2872f62254 ("x86: KVM: Advertise AMX-FP16 CPUID to user space")
  5e85c4ebf206 ("x86: KVM: Advertise AVX-IFMA CPUID to user space")

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

diff --cc arch/x86/include/asm/cpufeatures.h
index 11a0e06362e4,1419c4e04d45..000000000000
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@@ -311,7 -308,9 +311,10 @@@
  /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
  #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
  #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructio=
ns */
+ #define X86_FEATURE_CMPCCXADD           (12*32+ 7) /* "" CMPccXADD instru=
ctions */
+ #define X86_FEATURE_AMX_FP16		(12*32+21) /* "" AMX fp16 Support */
+ #define X86_FEATURE_AVX_IFMA            (12*32+23) /* "" Support for VPMA=
DD52[H,L]UQ */
 +#define X86_FEATURE_LAM			(12*32+26) /* Linear Address Masking */
 =20
  /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
  #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */

--Sig_/ZtuWN5ZcZZIjNR0uvB_UDn1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmOH8dAACgkQAVBC80lX
0Gw/UQf+N6eZbAHfPNSifcilxxbIYN3mlvfhK8yCcq7yTRRqdsnRsI/7kBMjv6Bp
QT5Od3gt/JmY3NYYsZkA1J1AupRhTyT2xf7TY/5KuCIwRAqbZIpQiN0urodKGOk4
1J3XoTxclUIfPIec+jZ4l5ehtJsE+wDovyxMhFLAuX1Qeelh57Oc1HpiNHu1RCgK
juW72RiXU4mVZzJI/zKFB16lJOPLI+ifYVNw/FTc0A10uX18Jh0bJ735kgyEPCEg
AvtiziJC/bpNCsQEQ61E5W+pHcdbSqeMBBtYJwFAlUX/u5eMRqRQTs0J/CY7T6nJ
g+71x6xW/t5fCraxoDAdZRRwmfmYOA==
=BInx
-----END PGP SIGNATURE-----

--Sig_/ZtuWN5ZcZZIjNR0uvB_UDn1--
