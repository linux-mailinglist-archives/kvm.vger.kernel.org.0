Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB63E67A40B
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 21:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbjAXUi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 15:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjAXUiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 15:38:55 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2AA46D4A;
        Tue, 24 Jan 2023 12:38:52 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P1f2F5twlz4xN4;
        Wed, 25 Jan 2023 07:38:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1674592725;
        bh=KZz/kInveKaA8SPDm2PC8Xqw0Hm46w9QRSaZTmWmmwo=;
        h=Date:From:To:Cc:Subject:From;
        b=FLxuIulT3xpdkw/7xNRgL88v42ccQW3IWTNkzlov93+oKao5gmYv86Cdw9Q3qlQwG
         6N+U6qYInL+IcOLhRBApLBPmNPWpSXdlvoWhACGjkVoaXmZbMpP19duA/pw/dbSaO9
         Au5sAFFJRC/3f/yrAnIPso5D0P2raQBGgaWFeeLauAw9xd316MUFP+Tuz1PWxshd8R
         aPAiAD+q1VLsFew9oBAKUbqwkLWmBd1qpVuP4YKZ1eTzDmUNwS7GdIltjO2iQviQPQ
         5W6Log+QGUmG1IWgJNDdo3EeKy9LyU4pd0m0uFIoUTeDsMXD1d4npO9gObKe/HcZjH
         qBEi2Xsu4nUKg==
Date:   Wed, 25 Jan 2023 07:38:44 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the kvm-fixes tree
Message-ID: <20230125073844.53aaf29d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/sI8/YBqI7=xgp9aoczk=jZx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/sI8/YBqI7=xgp9aoczk=jZx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  50aa870ba2f7 ("selftests: kvm: move declaration at the beginning of main(=
)")

Fixes tag

  Fixes: a79b53aaaab5 ("KVM: x86: fix deadlock for KVM_XEN_EVTCHN_RESET", 2=
022-12-28)

has these problem(s):

  - Subject has leading but no trailing quotes
    Just use
	git log -1 --format=3D'Fixes: %h ("%s")'

The date at the end does not add anything.

--=20
Cheers,
Stephen Rothwell

--Sig_/sI8/YBqI7=xgp9aoczk=jZx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPQQdQACgkQAVBC80lX
0GwKzAf/WIfQyqx7umgHsDtxP+j4gMgcPcmB6W5nu5nC1POxmSatzlNHXvgqQyIp
fZajkJsVelgXRYxduljG3fsmnQVW9tSdkaPRTNefZg02/cmm8b6KkzoYa0UqtOiU
8H3z/2e14gbs8DE0IaJEkuX3RkuYP+E/gNUt2atmbcLCtuush/Gw5hArpr8umhXY
6vh7YBv5cJYapVEXOiViq76pdKEEM+/5MG4dYOn58mrnmFDEUifP3tzuxnptgHMx
AcnX1Hu0EXHWfUDSQ5aCvjqaGnpZa9T0NpnNmTp1NEshyc5v51QIx9d6y5rje4SC
b9JL0nfdF8+jbM/MMpOUT+bIEBLcXg==
=3bd4
-----END PGP SIGNATURE-----

--Sig_/sI8/YBqI7=xgp9aoczk=jZx--
