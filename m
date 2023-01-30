Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8827568072D
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 09:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235954AbjA3IPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 03:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236026AbjA3IPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 03:15:02 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E244ED4
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 00:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675066479; x=1706602479;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R2Arxju9SKmyJE8i3oT3ku44eFBP9QPyzS7LFGcZRr4=;
  b=Lqc4DhbXMEW4hQMO8kaeolS5Lngp7cJeehY4VZ9U0WMR1qumvD+rZw+K
   f25cLoh+TpERIbkaD8yUYqxk5ahclOcE8ifksu6HM4FROJuUgR+rmlrV6
   kI51+GGkvv05jmUJcIp4FAeFmg+sXQUzDRYBJ3+j94CV1/kQEb/j4ir5c
   xFUimTNsOc6TOdVhJAlsKTByMxLlP2COdilzLTejo/4Q0BpNtB6vX8cC7
   5ODnD/pw3SW5p/JUg0c05iC5pP9xl/Tc/qz5DxjRlkyxilJTh1iskQb6H
   Wd16miGO0wL+S2YwPlpCsTD+p26gretMcUQwJzXRBVWp3S2NqmQtRV1h7
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,257,1669100400"; 
   d="asc'?scan'208";a="209758505"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jan 2023 01:13:47 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 01:13:46 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Mon, 30 Jan 2023 01:13:44 -0700
Date:   Mon, 30 Jan 2023 08:13:20 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Andy Chiu <andy.chiu@sifive.com>
CC:     Conor Dooley <conor@kernel.org>, <linux-riscv@lists.infradead.org>,
        <palmer@dabbelt.com>, <anup@brainfault.org>,
        <atishp@atishpatra.org>, <kvm-riscv@lists.infradead.org>,
        <kvm@vger.kernel.org>, <vineetg@rivosinc.com>,
        <greentime.hu@sifive.com>, <guoren@linux.alibaba.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH -next v13 19/19] riscv: Enable Vector code to be built
Message-ID: <Y9d8IBqXyep+PJTq@wendy>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-20-andy.chiu@sifive.com>
 <Y9GZbVrZxEZAraVu@spud>
 <CABgGipW430Cs0OgYO94RqfwrBFJOPV3HeS24Rv3nHgr4yOVaPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CJhZexl+M95YUvmH"
Content-Disposition: inline
In-Reply-To: <CABgGipW430Cs0OgYO94RqfwrBFJOPV3HeS24Rv3nHgr4yOVaPQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--CJhZexl+M95YUvmH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2023 at 03:46:32PM +0800, Andy Chiu wrote:
> On Thu, Jan 26, 2023 at 5:04 AM Conor Dooley <conor@kernel.org> wrote:
> > Firstly, no-implicit-float is a CFLAG, so why add it to march?
> I placed it in march because I thought we need the flag in vdso. And,
> KBUILD_CFLAGS is not enough for vdso. However, I think we don't need
> this flag in vdso since it is run in user space anyway.
> > There is an existing patch on the list for enabling this flag, but I
> > recall Palmer saying that it was not actually needed?
> The flag is needed for clang builds to prevent auto-vectorization from
> using V in the kernel code [1].
>=20
> > Palmer, do you remember why that was?
> The discussion[2] suggested that we need this flag, IIUC. But somehow
> the patch did make it into the tree.

I know, in [1] I left an R-b as the patch seemed reasonable to me.
Palmer mentioned some reason for not thinking it was actually needed but
not on-list, so I was hoping he'd comment!

And I suppose, it never got any further attention as it isn't needed by
any in-tree code?

> [1]https://lore.kernel.org/all/CAOnJCULtT-y9vo6YhW7bW9XyKRdod-hvFfr02jHVa=
mR_LcsKdA@mail.gmail.com/
> [2]https://lore.kernel.org/all/20221216185012.2342675-1-abdulras@google.c=
om/

--CJhZexl+M95YUvmH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9d8IAAKCRB4tDGHoIJi
0g+MAQDJ7eBJdCaLsu0EJa72pjyXE98/RF+uv1lr+Os0xW9MZgD+IDGhAvVyfm+J
TzjupFmI4XgIGFBAGk2H10/strXdbwo=
=O31O
-----END PGP SIGNATURE-----

--CJhZexl+M95YUvmH--
