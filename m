Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F56A3922E0
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 00:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbhEZWpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 18:45:32 -0400
Received: from ozlabs.org ([203.11.71.1]:46333 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234099AbhEZWpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 18:45:31 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Fr5bK0llpz9sCD;
        Thu, 27 May 2021 08:43:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1622069037;
        bh=yoHGcZrfZWRUzRlHB6uGfY1Ujgs3zJ9QzpcaUtUjtmk=;
        h=Date:From:To:Cc:Subject:From;
        b=DKdh5ij1oxJk/92uTHuuvF78FqR+aDxgGIVtLhVBbqdkonLWlw/GSLvpIVaZjLmj2
         5JyLsgtqTyfBTBN1zmxHEFXHYYdDIvjMvqorMSWAHmEisiGQLMBT6LxTwNtWxaBqbv
         gDDUhYR1N4JCVTSgOVoMoAApG5lH6BEKTb+xYKrKJt9tFIHIc3seBgzbsePj3hpdP8
         t/kqOwOUoXyphpW/34FI4XC5NUlygenBj7uH1BETAq5QA1XPPI1Ge0K6DC5H9u1gLS
         wDx6ihX+k+1x/RN5H/W3dMFnZB0b4ABHbYVxj2QzxcL6ahnIinyHDTbOWBib6ocCEh
         UmFzTEKkyRVMQ==
Date:   Thu, 27 May 2021 08:43:56 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the kvm-fixes tree
Message-ID: <20210527084356.12c2784f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4fTwIM5hZ+5y2gI_IMwP4IA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/4fTwIM5hZ+5y2gI_IMwP4IA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm-fixes tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from arch/powerpc/include/asm/kvm_ppc.h:19,
                 from arch/powerpc/include/asm/dbell.h:17,
                 from arch/powerpc/kernel/asm-offsets.c:38:
include/linux/kvm_host.h: In function 'kvm_vcpu_can_poll':
include/linux/kvm_host.h:270:9: error: implicit declaration of function 'si=
ngle_task_running' [-Werror=3Dimplicit-function-declaration]
  270 |  return single_task_running() && !need_resched() && ktime_before(cu=
r, stop);
      |         ^~~~~~~~~~~~~~~~~~~

Caused by commit

  85d4c3baeb45 ("KVM: PPC: exit halt polling on need_resched()")

I have used the kvm-fixes tree from next-20210524 again today.

--=20
Cheers,
Stephen Rothwell

--Sig_/4fTwIM5hZ+5y2gI_IMwP4IA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCuzywACgkQAVBC80lX
0GxAMQf/YaCEHH3QHYGkCsUeAbZ5L1Jk0cItYgEHAY9dGy4X7gkUAGb/uzH+AbfP
ZXUPMOK7Ucy6yudZwe/TUHQlZAGjc5nP7tTtp6WFIRSWHjL6yh0oKZg/b3maPJqy
kp/GNSUb+VIFIMei0LtggbVh+Ot3jrzi/DD1C9iuIbmhRNe78JOBOrxD5whEG+dP
dq3gVJeCDD61vCgNtF6T0E03OTdr4Aj4xTNNL/9L4urpgmEI/Ed2iHHUrk9uf9H8
okQl3CeAQt6svhxMtFmEsIYcxWzmZvUqOA1/NoIddenV7mbIPLujUm/uyxuhBmlE
MwuHBkGpnJTexv3+ewc6WlkdFqcH0Q==
=Cx9t
-----END PGP SIGNATURE-----

--Sig_/4fTwIM5hZ+5y2gI_IMwP4IA--
