Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D731D50AAFB
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 23:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442228AbiDUVx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 17:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349020AbiDUVx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 17:53:27 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B027939801;
        Thu, 21 Apr 2022 14:50:31 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KkrnF6PlPz4x7V;
        Fri, 22 Apr 2022 07:50:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1650577826;
        bh=v5D8x6mWy3R6bxOB+7bHkFTUlqaCMYDNqLBwRz57FU8=;
        h=Date:From:To:Cc:Subject:From;
        b=GYYfzcnl/hpv5n0BBqjr9Uq2vbIGZ0d8vJyH8VE5xva26yROLXoa3lAtJB9PiiAP+
         MisgvMBuI8mskQejvEp2TWXBK4sEkBiEHQoKLyzF7xzM+qWELHte6R1eJhQha3w02s
         4K+alfsg8adf+pF3ZgwoChpagmgJbBon23VXCtyptOFThBqMDOYNwknXR1HLj5BQB+
         Pzt1rPhCwPrjsAeahN11D/8iFtkymcSEFPQnyNvcV+xyhR2A29EvgDDu8uiDhnSoDZ
         jr+AOEU36qpt9NpA+yEJTIZSQyZAfxKQhB0c9dtRxISBRQr4aGKQvQ6wh255S989cB
         HD8RNWL09ewBA==
Date:   Fri, 22 Apr 2022 07:50:24 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Atish Patra <atishp@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tags need some work in the kvm-fixes tree
Message-ID: <20220422075024.161914a8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ceZP+XRH1xEcsrJaB0i9I9N";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/ceZP+XRH1xEcsrJaB0i9I9N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  38d9a4ac65f2 ("RISC-V: KVM: Restrict the extensions that can be disabled")

Fixes tag

  Fixes: 92ad82002c39 ("RISC-V: KVM: Implement

has these problem(s):

  - Subject has leading but no trailing parentheses
  - Subject has leading but no trailing quotes

In commit

  3ab75a793e49 ("RISC-V: KVM: Remove 's' & 'u' as valid ISA extension")

Fixes tag

  Fixes: a33c72faf2d7 ("RISC-V: KVM: Implement VCPU create, init and

has these problem(s):

  - Subject has leading but no trailing parentheses
  - Subject has leading but no trailing quotes

Please do not split Fixes tags over more than one line.

--=20
Cheers,
Stephen Rothwell

--Sig_/ceZP+XRH1xEcsrJaB0i9I9N
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJh0aAACgkQAVBC80lX
0Gwhngf/aLYbBhANTfzllxLMgdfjd+whtNSPhRSTYd6dvz4tMVQ+llBxeRvLrOF8
HVuFAn0innWIdUO8vI8Wc+i1QU93rLWbouFCxAkbAVbr3TB3HSBZdMLTBC0mDVGL
RZ+mOaXqUXWYCbLSmxPQs/D6ueJgiwl76YFieA4t1oqJTGwmK4YrWz08mEcyx5iI
/5WH8Uyl4DQKWxH6GPHrowlnTfwOYEkuTI5/81VxymzEGl8lcJfazGEY04Zyzsvl
XxpYmcp0ouJ3cL39FBjCxbbzs72sWShfhrHqpxV3F9EtHOnJnJBsAgvVXTz9TNn/
j1uO55RY/4AnYEoL/VS4cXQDZ4swtQ==
=bhza
-----END PGP SIGNATURE-----

--Sig_/ceZP+XRH1xEcsrJaB0i9I9N--
