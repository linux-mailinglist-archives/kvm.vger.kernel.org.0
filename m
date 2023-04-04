Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0436D5FBC
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 13:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbjDDL7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 07:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234438AbjDDL7G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 07:59:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC48198C;
        Tue,  4 Apr 2023 04:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680609542; x=1712145542;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yf84yJ47fRZZVKYSzUL/KnC/GlQL2L+iPq43dwG8FL8=;
  b=zhnhJF33f3h2DGrOi/Xn+8esktAdDrNiyb4Ff9LN5jL+CbbeHMeD6z53
   vL/hvQpTEb5uxl/yaiBqJybJwTUAaqIsn6SQNCI9AnONoPK3l1gBEkh/G
   Av9hZD6bV/xJ4hJn4K7dzRwqN0huIf8+JNpDF9GZDwvhf/5gE8Dv5HqjM
   0R7mXLkETUwoaWLMNFcByvGlKg5soPOSUQyIVB2/PK8sPp5jYdASsekR4
   gM16fRp0Nz/FEgKu9OdBhojAagUARIZRuSVF9rwJUbOXoqFFjtSJn+mfK
   brRy9mDl7NMH2y5CbUDut1C+azrBCBnSVvZM7ijnu8z2uKthsMGXg0EGm
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,317,1673938800"; 
   d="asc'?scan'208";a="208769362"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Apr 2023 04:59:00 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 04:58:57 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 4 Apr 2023 04:58:55 -0700
Date:   Tue, 4 Apr 2023 12:58:41 +0100
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Andrew Jones <ajones@ventanamicro.com>
CC:     Anup Patel <anup@brainfault.org>,
        Anup Patel <apatel@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <bjorn@kernel.org>
Subject: Re: [PATCH v3 6/8] RISC-V: KVM: Add ONE_REG interface for AIA CSRs
Message-ID: <20230404-5cfffb017198773dc3e81dab@wendy>
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
 <20230403093310.2271142-7-apatel@ventanamicro.com>
 <osrpjiywxtkgxb5i6mfvxzfrzrnjv75uqzvlu3fouo4mqsktgj@blcmyjt3twqg>
 <CAAhSdy1JEQBiO55iCy97arO63VjGc+NicUvvwzTpK97W97LmJg@mail.gmail.com>
 <ejt3x4p7xhxfvwiafnogfwdn5dzd4qyowlht22utnbvzefsbyh@7dch4mebwckm>
 <uogikq56rf7jytuufhsutdedb73b3rh67biwpzsz6ngg5rudco@qcwt7plumwpb>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5GJ1H1BOzV0sFIzx"
Content-Disposition: inline
In-Reply-To: <uogikq56rf7jytuufhsutdedb73b3rh67biwpzsz6ngg5rudco@qcwt7plumwpb>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--5GJ1H1BOzV0sFIzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04, 2023 at 01:52:43PM +0200, Andrew Jones wrote:
> On Mon, Apr 03, 2023 at 02:23:01PM +0200, Andrew Jones wrote:

> > It's probably best if neither depend on each other, since they're
> > independent, but otherwise the order doesn't matter. It'd be nice to ca=
ll
> > the order out in the cover letter to give patchwork a chance at automat=
ic
> > build testing, though. To call it out, I believe adding
> >=20
> > Based-on: 20230401112730.2105240-1-apatel@ventanamicro.com
> >=20
> > to the cover letter should work.
>=20
> I also just noticed that this based on "RISC-V: KVM: Add ONE_REG
> interface to enable/disable SBI extensions"[1] and it needs to be
> in order to pick up the KVM_REG_RISCV_SUBTYPE_MASK and
> KVM_REG_RISCV_SUBTYPE_SHIFT defines. It'd be good to call that
> patch out with Based-on.
>=20
> [1]: 20230331174542.2067560-2-apatel@ventanamicro.com

I've been waiting for a review on that for a while.. It's been 3
weeks, so just gonna merge it and see what breaks!

--5GJ1H1BOzV0sFIzx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZCwQ8QAKCRB4tDGHoIJi
0i39APsEperqNGR68oYf4cBWUJa5Q4Lux1nXIgwKhMES4jyVVAD/V7XKtbDF5fmm
GjZMMXMQKhoi5KsqHDaTwOKJ7BrEjwg=
=kicz
-----END PGP SIGNATURE-----

--5GJ1H1BOzV0sFIzx--
