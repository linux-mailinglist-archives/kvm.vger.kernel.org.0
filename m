Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36428572DD5
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 08:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbiGMGCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 02:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiGMGCr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 02:02:47 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D4A5006E;
        Tue, 12 Jul 2022 23:02:45 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LjRqM46T0z4xZD;
        Wed, 13 Jul 2022 16:02:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1657692161;
        bh=EizAc07LAFfcO/KRLoZZdNMjii3lpN/aMpY4/BYi71I=;
        h=Date:From:To:Cc:Subject:From;
        b=nNM3gYhOqPb3sxn1bPbCGSeQDRc8ldfgQK7wbOYaSpF66lw/0IoOLngiXwcbvUNlX
         xJRXIHnRv0AexotmDeromG7WpZ7wGgB/0rTjLOEnTsoHDZzUbqJ1fRuaujX7fm2BRZ
         L777q77MG91LM7WF01t5c7O0I+wFjTZU7KKJWslEoaCTo/OJxwHzPJfq1jGlZvlRGm
         Ss5rIahSmijIw2omG21xDzD8vIlVou41oBBtU2v4b2V0+ZyIaCZBvA3ETHZtThfCOV
         518cq0iJN7RNQbWMZoCtnV/QBvDVsuqQtOd48U300ANTEEknxeXhSnN2qSTq/J5S0t
         sxNKDtzmjJwGw==
Date:   Wed, 13 Jul 2022 16:02:38 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Borislav Petkov <bp@suse.de>, Josh Poimboeuf <jpoimboe@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Luwei Kang <luwei.kang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-ID: <20220713160238.3bfcdb26@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ZHKigaZCMFOD5BtFXR=nl80";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/ZHKigaZCMFOD5BtFXR=nl80
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/vmx/capabilities.h

between commit:

  07853adc29a0 ("KVM: VMX: Prevent RSB underflow before vmenter")

from Linus' tree and commits:

  cf8e55fe50df ("KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64")
  6ef25aa0a961 ("KVM: x86/pmu: Restrict advanced features based on module e=
nable_pmu")

from the kvm tree.

I didn't know if the new includes needed to be prefixed with "../"
as well ... I though it was better safe than sorry.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/x86/kvm/vmx/capabilities.h
index c0e24826a86f,069d8d298e1d..000000000000
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@@ -4,8 -4,10 +4,10 @@@
 =20
  #include <asm/vmx.h>
 =20
 -#include "lapic.h"
 -#include "x86.h"
 -#include "pmu.h"
 -#include "cpuid.h"
 +#include "../lapic.h"
 +#include "../x86.h"
++#include "../pmu.h"
++#include "../cpuid.h"
 =20
  extern bool __read_mostly enable_vpid;
  extern bool __read_mostly flexpriority_enabled;

--Sig_/ZHKigaZCMFOD5BtFXR=nl80
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmLOX/4ACgkQAVBC80lX
0Gy/3wf5AazZxPj4X8/DKHUmsdcwhIzbvB/LLirWIHbO37UqcDpmZGqFdeujf98j
CsTdftXRhA55iE8HITLrvnsTaggoj/W9yrGH6vfYwOvnCLPu4lSQ5YA8IPPe628x
TF2GJeV7G2NcpCcrxEapJ8RxiwQlYZLj2bwl6XHViCrd7LKbtQJ9qi7S0kn1z5X1
NqwygQjGElySzjYJvn7kww82qcrFgrC1SC/xZsWJSVZDtdsc0NDEqp25ZpWXcJde
cbH+Khv2L2nQwHABYcQktC6P6tHih9s/pijzdwP3EZ9xQFG7c6+Rk1Z34zi46CLY
rDLbeNT3bIbBzEpLtMjLe9GTVKliRQ==
=7gAS
-----END PGP SIGNATURE-----

--Sig_/ZHKigaZCMFOD5BtFXR=nl80--
