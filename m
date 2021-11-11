Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1FF44DDD3
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 23:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbhKKWXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 17:23:14 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:39813 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233659AbhKKWXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 17:23:13 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hqx431FzMz4xbw;
        Fri, 12 Nov 2021 09:20:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1636669219;
        bh=NFD0wTCrdo56jxLDaMizhrIDOrhu1DWiwRYHWWcl8wg=;
        h=Date:From:To:Cc:Subject:From;
        b=ephPEGZczSzmt+2rubJ/9iQ2ByONu/LU22jIcbn9Ik3A+2BvMqETOFEnPlFgBukh5
         WOW+KmoomiA8dgXVlntVAls6Si45v+7eadqjg0ZDnVROg0fuYFvqCxRrfU59kXVu6g
         66P503fdjfUzQ6DUCXTTvbJZNaf+yl7pXStHOR+ZlEcCceqDGo+CSytzZIMiOyplZ9
         IMzCIAUu/BYXO5q1Os6LwgGf31sQLgQ2neRjpPA9S00cDcgGBaJJpIXy/IQ05IoZke
         0kMgzKXRx+4Q0CWBMkXLPgsTjs9lAt0i8Uio2ita4eKfPF6iVbCBAEHpcVib79d4JK
         flOB6azHmjn0w==
Date:   Fri, 12 Nov 2021 09:20:18 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the kvm-fixes tree
Message-ID: <20211112092018.02d354e9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/65zZXgWEOTFBB8tJbtpp/FS";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/65zZXgWEOTFBB8tJbtpp/FS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm-fixes tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

arch/x86/kvm/x86.o: warning: objtool: record_steal_time.cold()+0x2a: call t=
o __ubsan_handle_load_invalid_value() with UACCESS enabled

Introduced by commit

  7e2175ebd695 ("KVM: x86: Fix recording of guest steal time / preempted st=
atus")

--=20
Cheers,
Stephen Rothwell

--Sig_/65zZXgWEOTFBB8tJbtpp/FS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGNlyIACgkQAVBC80lX
0GwoNgf/ZJ3NWiNNcRD8W57k4qmBg+/rEWIwfpO1kwjFjByLLEkbrCQ0u+cUkR5X
F8Tj0+NAZu1u9pLTLZgAE0kT7A3D5tTNjLkEly5iT+IV71enadhAivTGSoXpbU+0
sXsV76ZPAh/mXjnx/tH0EwRANxxwWlRhrydHRMybOgNOb8KC0bWpPDoBBz3IVAKq
IblV5hijbZ73GgOrZwpqX99i2R1ttNk0xY6ycw5mQi0ewKOYQlB+VgN3XLMEtnwM
pWifDCC8kLHiMBm8q/W/cc9fxhz9U2kpANcT2a2SubEqk+NghOJ8hNpXKgQF4UmY
PdtZym8JujP6/2DKdJcggKc1PR0HfA==
=acKU
-----END PGP SIGNATURE-----

--Sig_/65zZXgWEOTFBB8tJbtpp/FS--
