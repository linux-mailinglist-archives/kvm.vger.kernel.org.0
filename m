Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3751670EF9
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 01:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjARAsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 19:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjARArO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 19:47:14 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D239616ADC;
        Tue, 17 Jan 2023 16:32:37 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NxRYD5CHhz4xGq;
        Wed, 18 Jan 2023 11:32:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1674001956;
        bh=52dzgLNSfEjYsbutWH5bQI6p3YDgOnII4xuOmFG9MLk=;
        h=Date:From:To:Cc:Subject:From;
        b=TG4pZ9qf4aZQvmhB3ge+fzXkXQGgWV39+N/AjiozIw0g4/nUmDIj2ApNcZ5eArSQp
         1Yeb1T2saxaf8Ddm9L+r/sbOlPoTM6DUs4YqOrlcfOIdd9NhDVx8Aa9Axh4/hVmHoo
         9lhS6Q6yr9njXvcXqssycSxdoMKQXhB0if24TfngauH//2GsH17P8IYDd2gSLmAQpo
         ByGapowjBMpp5bgMm/bi701YlccDitrcYIYKtlcf7Bawo6oQ37c7tRQnRXp0+OiZTW
         pBaDrvJxKFvcm7Je4TSai4Xid5ObbQ7obnq8L9t6OVMjdq60BwZa34FZxTsAShtQTg
         8c1wLGncr248A==
Date:   Wed, 18 Jan 2023 11:32:31 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     KVM <kvm@vger.kernel.org>, "Borislav Petkov (AMD)" <bp@alien8.de>,
        Kim Phillips <kim.phillips@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: linux-next: manual merge of the kvm tree with the tip tree
Message-ID: <20230118113231.3a111b69@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/U/KB6OceQUw6My/BKl14Pl0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/U/KB6OceQUw6My/BKl14Pl0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/reverse_cpuid.h

between commit:

  15fea09b029d ("x86/cpu, kvm: Add support for CPUID_80000021_EAX")

from the tip tree and commit:

  0fcf86f05af2 ("KVM: x86: Add a KVM-only leaf for CPUID_8000_0007_EDX")

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

diff --cc arch/x86/kvm/reverse_cpuid.h
index 81f4e9ce0c77,4945456fd646..000000000000
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@@ -68,7 -72,7 +72,8 @@@ static const struct cpuid_reg reverse_c
  	[CPUID_12_EAX]        =3D {0x00000012, 0, CPUID_EAX},
  	[CPUID_8000_001F_EAX] =3D {0x8000001f, 0, CPUID_EAX},
  	[CPUID_7_1_EDX]       =3D {         7, 1, CPUID_EDX},
 +	[CPUID_8000_0021_EAX] =3D {0x80000021, 0, CPUID_EAX},
+ 	[CPUID_8000_0007_EDX] =3D {0x80000007, 0, CPUID_EDX},
  };
 =20
  /*

--Sig_/U/KB6OceQUw6My/BKl14Pl0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPHPh8ACgkQAVBC80lX
0Gwt3Af+I/S5b5PNcDhRyrkhs9QWzIv55Uzzf+yy5Oll02Sr+6YvkFdhA7Q8Wsj1
+64C61GSvMUvQnqbgGQRFuQUeuVMemswXg6JGwWXsGHOYCcRzrJlYsDRnzw96i5t
jV0RmvrT3AC/iaPu9B63EYcYTgcEqwIFRNinuVY5829bXZvmtaD8KR/lkk/i++5D
BI6LYjf0idNDK40/UlTAQxmbTsgJW0wqmFHHb3Eyf+Yo5K4Vjy0Y1jXK0p+Lv4+a
5oquT3Z8hTv98K+yYmhmak5wINLq/Tgz77lPY66mbsJocjjaB127+tH+ftZZ0iWq
7liO3UEg23XRXUPO04xTJ2HgXojriA==
=rDIq
-----END PGP SIGNATURE-----

--Sig_/U/KB6OceQUw6My/BKl14Pl0--
