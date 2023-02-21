Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B223869DE06
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 11:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbjBUKlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 05:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbjBUKlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 05:41:12 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E8125BAE;
        Tue, 21 Feb 2023 02:41:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676976067; x=1708512067;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=B7QA/vyewvRH8xz6i211QhpHsRW7Qheq3VCrsuFZ1m8=;
  b=uiMaSKst6U46U7h3dCWb+DcQ9GosLplG1FiTJQgHrBE9TTXcQsL1Oo2H
   L4n7GLRa8bx7IFuQDDFh1cW9c+wx5oY9nfbgQ3QOQEJperptGPfvrYh3e
   Zyb+bSieD8Zo8a1kjod3kR4aNacU02+D1WDXdCUGmlCf4w7eVE2lKQIpt
   uFMrr153uDFOy6z7uyQWIE3STQAjXIdoksXrxgzJp9wtgTjzYPJGlHoW7
   ay70vDHnlshmA2wXckd0g8FajlTL3JNToB8UcrswaO770vDkirMsBossk
   03pHmyJaXNl5W51EZokTRfQU29FQlce8iMcZb5TROzEoVD4XVxa7ZXufr
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,315,1669100400"; 
   d="asc'?scan'208";a="201567546"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Feb 2023 03:41:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 03:41:05 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Tue, 21 Feb 2023 03:41:04 -0700
Date:   Tue, 21 Feb 2023 10:40:37 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Christoph =?iso-8859-1?Q?M=FCllner?= <christoph.muellner@vrull.eu>
CC:     Palmer Dabbelt <palmer@dabbelt.com>, <apatel@ventanamicro.com>,
        <pbonzini@redhat.com>, <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        <ajones@ventanamicro.com>, <anup@brainfault.org>,
        <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/7] RISC-V: Detect AIA CSRs from ISA string
Message-ID: <Y/Sfpb2c/LS0LCiA@wendy>
References: <20230128072737.2995881-3-apatel@ventanamicro.com>
 <mhng-0f9bdf58-5289-4db4-8fd7-38898824c44f@palmer-ri-x1c9>
 <CAEg0e7hrQFu+cdZy+3QO1ML9FNTPBehZwOOBnr1F-5ABYDnkGg@mail.gmail.com>
 <CAEg0e7hRjMSgYZbPTQztbQ3bGZf-r8wAfCK5ZnDXOcx27HcTCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6iuVe0fRaCPwebfO"
Content-Disposition: inline
In-Reply-To: <CAEg0e7hRjMSgYZbPTQztbQ3bGZf-r8wAfCK5ZnDXOcx27HcTCA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--6iuVe0fRaCPwebfO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Christoph,

On Tue, Feb 21, 2023 at 08:12:58AM +0100, Christoph M=FCllner wrote:
> Hi all,
>=20
> The RISC-V Architectural Review Committee has discussed the concerns
> regarding the non-ratified chapters in the AIA specification.

Thanks for the update!

> Here is the relevant quote from the meeting minutes:
> """
> Although the Advanced Interrupt Architecture (AIA) has already passed
> Architecture Review (with a minor edit still pending), the committee
> has some suggestions about its final steps to ratification, to avoid
> the AIA document having a mixture of ratified and non-ratified content:

> - The AIA document's remaining draft chapter on the Duo-PLIC, which is
>   not currently on a path to ratification, can be removed to a separate
>   document.

That sounds promising...

> - Ratification of the full AIA (without Duo-PLIC) can be postponed to
>   coincide with ratification of the IOMMU specification, given that
>   the latter is now expected in a reasonable time, and the AIA's last
>   chapter concerning IOMMUs is already scheduled to go through public
>   review and be ratified only together with the IOMMU specification.
> """

=2E..and so does this. AIA stuff's acceptability only depending on the
IOMMU spec's freeze (and thus Chapter 9's) seems like a vast improvement
on the status quo to me!

> The full meeting minutes can be found here:
>   https://lists.riscv.org/g/tech-chairs/message/1381

This link is non functional unfortunately :/

Cheers,
Conor.


--6iuVe0fRaCPwebfO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/SfpQAKCRB4tDGHoIJi
0glVAP48ulWH0wluVY0nRbCm5mnXv2qbJhdboksLyQ9PBMmj4AEA/g4b4WQyFK4F
pOnOdQtJiSbRjyBmsB6lQ/f+ZjOGRAE=
=+DAU
-----END PGP SIGNATURE-----

--6iuVe0fRaCPwebfO--
