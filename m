Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A80314C68
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 11:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhBIKDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 05:03:22 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:53361 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230204AbhBIKAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 05:00:39 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DZdfd1NvMz9sBJ;
        Tue,  9 Feb 2021 20:59:53 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1612864793;
        bh=LHrNQ8zOjyc9jF0gm1ApttrgJY/ENFjxC+J3+oUlHWc=;
        h=Date:From:To:Cc:Subject:From;
        b=g3UtbvsgBX5xTQOnA1fZGdyuY/xSueKLD7Xgywfb0Ll+tBrzi1lVsWr8/NmBLtkwN
         mh3ozYJFqMws+7nlCDrj2W08MQXH8ND1JqnbuprrzglrJoC4/K/ZabopWJbhwavh/U
         SaTCRGMU+0LqI0+ozmvhEfwx6GsAkEqyeMhXiVY9VULzQfXYplEzT6H0OAIfs7BOsP
         vwtGwcVgwTCnv/oJHqcxBYYkkF+0uynEYS/btlVgMyro1GEaPRcy5n9cda13PwyCWU
         xuBl/j2R/qC9yEijbyKjdlSErXAhij9e63hQpSdZJ6qH7L6pfuXnvVf7TV5nhSjlhV
         L82Oax2oydgvw==
Date:   Tue, 9 Feb 2021 20:59:50 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: linux-next: build warning after merge of the kvm tree
Message-ID: <20210209205950.7be889db@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/c+9F9hQ89Biv5HtRxT0Yaoh";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/c+9F9hQ89Biv5HtRxT0Yaoh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (htmldocs) produced
this warning:

Documentation/virt/kvm/api.rst:4927: WARNING: Title underline too short.

4.130 KVM_XEN_VCPU_GET_ATTR
--------------------------

Introduced by commit

  e1f68169a4f8 ("KVM: Add documentation for Xen hypercall and shared_info u=
pdates")

--=20
Cheers,
Stephen Rothwell

--Sig_/c+9F9hQ89Biv5HtRxT0Yaoh
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAiXRcACgkQAVBC80lX
0Gz/NQf/c1zHOhwmZdzWv+qIcTClYuBhB8MmSo3xa5EjKKJyN9k5y1fE0WUcg5Cg
xbJ5BBDY5ERZhS6gq/dmlqAsyAwHJOagr1kQXUqfyukIAFPedkRJ7LeRgcGF5wJu
65JvQRgbDbwFcWYI1sngZFJQfM3c+vEcIz7IbP+IxX+qt2NGeaXk3P7FIUanjmIW
YJcnrnH0eRRLwUpQvCX6CuadoGez7PZkxNEqp7CMBYUGLuNU2daFN/d/yRZ7LJUX
3LgeaV2vfldSsquoOAOtfCxJoVGZuwyxJMfQQL8xsKDK3fUZKkICJI9G7jdLTFdg
ZDWYyHUqXyOmNZxjEsoxr3y/crVrKw==
=TSWl
-----END PGP SIGNATURE-----

--Sig_/c+9F9hQ89Biv5HtRxT0Yaoh--
