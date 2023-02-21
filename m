Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B5F69DE56
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 12:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbjBULAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 06:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbjBULAF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 06:00:05 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76CB23338;
        Tue, 21 Feb 2023 02:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676977200; x=1708513200;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fVoyeszrnawguFMAcNS7/Ulx+Q4Q5phuGRkAbIy7V+I=;
  b=oRjIMdfcDsjukm7N4ACPSwAriFGQMnQd+1dlESWRGdYKHiPuwAqnlBeh
   XZ6pRM7IbMxwZZYVOHCA0RkbRnv5Ag6FIcTlsnj0l32Yefj7YyjEAA7+/
   Bu5xR8ofXOi1QOkm4CX4IzjiYAzVoUAOGXFPPpEzlxYNhELzI9TCn/5bx
   np3eSF1cd7HTiE7R4VIti1nfFfE249LZAhpIMjSFPPO8m+Ng7BpeM7e/a
   DeUjiQL37KZnWnu9yPQNWgoBhdtKQfEAL3Orpc4iltea52Nlgf3sq7GPD
   rBzSs1mPa/IIgT/SNNxQx37d51M9GSbB+cLqOkJaebqGCJ5YnkcuM/HIA
   g==;
X-IronPort-AV: E=Sophos;i="5.97,315,1669100400"; 
   d="asc'?scan'208";a="197966108"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Feb 2023 03:59:58 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 03:59:57 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Tue, 21 Feb 2023 03:59:55 -0700
Date:   Tue, 21 Feb 2023 10:59:29 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Jessica Clarke <jrtc27@jrtc27.com>
CC:     Christoph =?iso-8859-1?Q?M=FCllner?= 
        <christoph.muellner@vrull.eu>, Palmer Dabbelt <palmer@dabbelt.com>,
        Anup Patel <apatel@ventanamicro.com>, <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, <kvm@vger.kernel.org>,
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/7] RISC-V: Detect AIA CSRs from ISA string
Message-ID: <Y/SkES28TNBz02wM@wendy>
References: <20230128072737.2995881-3-apatel@ventanamicro.com>
 <mhng-0f9bdf58-5289-4db4-8fd7-38898824c44f@palmer-ri-x1c9>
 <CAEg0e7hrQFu+cdZy+3QO1ML9FNTPBehZwOOBnr1F-5ABYDnkGg@mail.gmail.com>
 <CAEg0e7hRjMSgYZbPTQztbQ3bGZf-r8wAfCK5ZnDXOcx27HcTCA@mail.gmail.com>
 <Y/Sfpb2c/LS0LCiA@wendy>
 <F80EBB4C-29C4-472D-B213-EFD220EF9B1F@jrtc27.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fkedauUBfv9Z3eAN"
Content-Disposition: inline
In-Reply-To: <F80EBB4C-29C4-472D-B213-EFD220EF9B1F@jrtc27.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--fkedauUBfv9Z3eAN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 21, 2023 at 10:51:13AM +0000, Jessica Clarke wrote:
> On 21 Feb 2023, at 10:40, Conor Dooley <conor.dooley@microchip.com> wrote:
> > On Tue, Feb 21, 2023 at 08:12:58AM +0100, Christoph M=FCllner wrote:
> >> The full meeting minutes can be found here:
> >>  https://lists.riscv.org/g/tech-chairs/message/1381
> >=20
> > This link is non functional unfortunately :/
>=20
> tech-chairs is private, for (co-)chairs only... not sure why it went
> there rather than tech-privileged.

Yah, that's what I was getting at.. This is a conversation on a public
ML, so it'd be annoying enough for some readers if it was gated around
RVI membership, but gating on membership of the inner circle makes it
kinda useless!



--fkedauUBfv9Z3eAN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/SkEQAKCRB4tDGHoIJi
0iIsAQD33eYII7OicrE7raQAFQf4L6dnKBZxw8YEJkvZx/SVrQEAoAmPtSKMvq8V
tiy/3pfhtR6/frhw7YmjIh1N66thdA4=
=rw0B
-----END PGP SIGNATURE-----

--fkedauUBfv9Z3eAN--
