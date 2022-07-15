Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B527A575B1B
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 07:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiGOF4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 01:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGOF4H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 01:56:07 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8AF4F668;
        Thu, 14 Jul 2022 22:56:04 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LkgZj5yH2z4xZB;
        Fri, 15 Jul 2022 15:55:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1657864558;
        bh=lW0fBGZ83Ym1P4dAAfXAwmwE8gdVd0eRG6eRH+Hgpg4=;
        h=Date:From:To:Cc:Subject:From;
        b=ZtWXus4PGlp9lO0wWR0wulhGu0SrVDQdt7t9llUIzRN9t68L6HQ9UXjOtWQFGGVd6
         G1zT2MEHTVUZJjEGBfRF14l93jnuhR5bOy6Aazn36c5m12+4xS7nmrbajP5GEriRfp
         091kwMHJVg/OW9+QQwCW4pvxaMwIyyNQVQArqvMc6nXCmqua59m9SAlBWjLHvxJfn6
         kMgIU86NcRkN6Ye0RIPVDK6gZTLMlWnnrYC3KB+DKYFNCBovXJx5Cf5nuR/rm/CIWr
         CD5rArz+A0uC+vACDYhlXZRTdleL7d7cHV0JSfsNX26E0KkWY/EFp83kCBuB1G3AaL
         ZUUt4Zv+CBt4A==
Date:   Fri, 15 Jul 2022 15:55:56 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Chenyi Qiang <chenyi.qiang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Tao Xu <tao3.xu@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: linux-next: manual merge of the kvm tree with the kvm-fixes tree
Message-ID: <20220715155556.77911cfe@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/SccVHT+w0Pg2sOJQu1cOCFD";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/SccVHT+w0Pg2sOJQu1cOCFD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/x86.c

between commit:

  1b870fa5573e ("kvm: stats: tell userspace which values are boolean")

from the kvm-fixes tree and commit:

  2f4073e08f4c ("KVM: VMX: Enable Notify VM exit")

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

diff --cc arch/x86/kvm/x86.c
index af0c5b5fc28f,031678eff28e..000000000000
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@@ -298,7 -286,8 +286,8 @@@ const struct _kvm_stats_desc kvm_vcpu_s
  	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
  	STATS_DESC_COUNTER(VCPU, preemption_reported),
  	STATS_DESC_COUNTER(VCPU, preemption_other),
- 	STATS_DESC_IBOOLEAN(VCPU, guest_mode)
 -	STATS_DESC_ICOUNTER(VCPU, guest_mode),
++	STATS_DESC_IBOOLEAN(VCPU, guest_mode),
+ 	STATS_DESC_COUNTER(VCPU, notify_window_exits),
  };
 =20
  const struct kvm_stats_header kvm_vcpu_stats_header =3D {

--Sig_/SccVHT+w0Pg2sOJQu1cOCFD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmLRAWwACgkQAVBC80lX
0GyPGwf/REik8Nq1tANNerJH+9c1LLZv+lA/q798tY3m3LoLHh4jRFCa/JLrl3Eg
E81b7WAmLUKGMCu2IvKpAh4XObKuvpqVNnntkZZAla1KiRx+EA0pzYXc8g9n37O9
PIesefM1M5Q/got8zwehj2Ol38887njTWhFzWitNC67aCe59XInzKrEGD8I0JxoZ
8YvjrUmEuE8ssX1BfensqdwsM3UptAhQrxqukPQJWH1/M2CXQlGBJp0qP0+nSp/9
+miabahe7NXaheBLhb2IKEDkRtM1RBeyGaOHL4z6j0wKNxzPkP/lFnJhQ6dNfaUb
RSGRNj5PonFhQCI/bMnX0SFdlwKktA==
=p/EE
-----END PGP SIGNATURE-----

--Sig_/SccVHT+w0Pg2sOJQu1cOCFD--
