Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37F641E3F3
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 00:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245398AbhI3Wao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 18:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbhI3Wan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 18:30:43 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A03BC06176A;
        Thu, 30 Sep 2021 15:29:00 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HL7FH4Vf2z4xLs;
        Fri,  1 Oct 2021 08:28:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1633040934;
        bh=iBGg7B6nCcHV+X3Y3NMsuA3k0lSEDhucAV/y/amUSI4=;
        h=Date:From:To:Cc:Subject:From;
        b=LUriSsjG+tI0mpnlgmiajJy7POBEiy3H2DEmUhiWAQgrd0wdB9f9TSGFPUmjys2oW
         NtLofZbOVs7F/hIh71/4rYBCow5uOLYF0lJmQmO2DxIXh9yqMWbWW2WVE5tuK3rG/6
         G+XQTK/JQ/9BZWq3TSPdUa4vY7QXDMQoJPMLC1upyAi5bLzXeGw9WByvoActvjIxpu
         Bs7BJpj7SDFfHB6Jd7M+7GUdtyWTibferk6G8AgPB9qV0nER0YeCjoiH1PKFimyx5J
         qirRtGSAMFVsMNlaqq+Ua0feW7V5De8K7B2VdB1Yr7QvT+itGwiUSYSQkaReFcMdVa
         ODPwb1ro3R5gw==
Date:   Fri, 1 Oct 2021 08:28:49 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Zelin Deng <zelin.deng@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20211001082849.61f2316e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/04gfg3hyt7obho/kWJUO3Qo";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/04gfg3hyt7obho/kWJUO3Qo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  773e89ab0056 ("ptp: Fix ptp_kvm_getcrosststamp issue for x86 ptp_kvm")

Fixes tag

  Fixes: 95a3d4454bb1 ("Switch kvmclock data to a PER_CPU variable")

has these problem(s):

  - Subject does not match target commit subject
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

--=20
Cheers,
Stephen Rothwell

--Sig_/04gfg3hyt7obho/kWJUO3Qo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFWOiEACgkQAVBC80lX
0GxZngf/aEI8Fbvi9VME5tfa9gT7cZ+rH923o9kJMlGpW41Svdd5PFoz9AMCa5W9
Zg/0FTjiiN+zigHvCBBEmzsJ2Da93ZoQTSlFEkxpXdbf7xQfBVilHUpO/HLPnucw
rXJT43jbbtu+6dphbtW/cYDlqV0vTcNuBzN4+kyjvvkqCrEyBoMx1PC6+37PJKZN
5I5QUYJ7cXy1KY5IJF5yCe13AItFTktjNEnK0Kyz7LwlAyDJzRsEiO/ryXjPGYS2
hEe+1ISjP/e9eymTJzkCEVgqCpLQuxajY96kLl84lbpIfXc6o/JEPsB9H5Qt/Rp/
m0czNR7UoXz+dE/kk1Bbg3DXBD5rfw==
=aICz
-----END PGP SIGNATURE-----

--Sig_/04gfg3hyt7obho/kWJUO3Qo--
