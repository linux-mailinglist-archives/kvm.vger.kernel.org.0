Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 378F46D40D3
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 11:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbjDCJku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 05:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbjDCJka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 05:40:30 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934D4D337;
        Mon,  3 Apr 2023 02:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1680514803; x=1712050803;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jFKq8L4uhXOKBPkBPlGji3aE5ZbKk+WcLtn0OrClLrI=;
  b=pm1G3SUkc0VryYxxRVITXOU+/hnASTNQqKq0A89T0yqsVqMmSWcZVFKn
   Lktc24QWyJHWUS81iDZS9ZgSC5CqnLjKvkUKghkP4O0ir6jHf0gfDSUO3
   lOJQFaUC7zaAyoFiXwhFVUTSoCYXsCB2vkgHoRI+wlVBP8f0z2i86aZwS
   R6npFRZovNnJoAu9nbSYaIQWELw1QFertBprotyRAT/SlypOww1aH1ytw
   17Ay0eErlNniRt3f/lZVelVVcHH9jVY5OShEo4T83V7h4ll+eDYEIp01N
   mQpCTe0NCtc0Vl8HKZwZ8PhTVVx5hYUYKN1da7dCsTZ/BdsRzlTI92f7h
   w==;
X-IronPort-AV: E=Sophos;i="5.98,314,1673938800"; 
   d="asc'?scan'208";a="219147455"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Apr 2023 02:40:02 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 02:40:02 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 3 Apr 2023 02:40:00 -0700
Date:   Mon, 3 Apr 2023 10:39:46 +0100
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Anup Patel <apatel@ventanamicro.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, <kvm@vger.kernel.org>,
        <kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Atish Patra <atishp@rivosinc.com>
Subject: Re: [PATCH v3 2/8] RISC-V: Detect AIA CSRs from ISA string
Message-ID: <20230403-80af54e80a34fc70fad04e0c@wendy>
References: <20230403093310.2271142-1-apatel@ventanamicro.com>
 <20230403093310.2271142-3-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OGdrsm9wa6bk/U+d"
Content-Disposition: inline
In-Reply-To: <20230403093310.2271142-3-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--OGdrsm9wa6bk/U+d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 03, 2023 at 03:03:04PM +0530, Anup Patel wrote:

> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index 59d58ee0f68d..1b13a5823b90 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -221,8 +221,10 @@ void __init riscv_fill_hwcap(void)
>  				}
>  			} else {
>  				/* sorted alphabetically */
                                   ^^^^^^^^^^^^^^^^^^^^^

> +				SET_ISA_EXT_MAP("ssaia", RISCV_ISA_EXT_SSAIA);
>  				SET_ISA_EXT_MAP("sscofpmf", RISCV_ISA_EXT_SSCOFPMF);
>  				SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT_SSTC);
> +				SET_ISA_EXT_MAP("smaia", RISCV_ISA_EXT_SMAIA);

This entry has been added in an incorrect order chief :/

>  				SET_ISA_EXT_MAP("svinval", RISCV_ISA_EXT_SVINVAL);
>  				SET_ISA_EXT_MAP("svpbmt", RISCV_ISA_EXT_SVPBMT);
>  				SET_ISA_EXT_MAP("zbb", RISCV_ISA_EXT_ZBB);


--OGdrsm9wa6bk/U+d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZCqe4QAKCRB4tDGHoIJi
0gt+AQC9yRaN+dKTHz7fyAJWu/44+2C9yyyQhdoeOwofaMhPEAD/W0Yk90pvYVJv
dura6pOmVWifrUHBvPFooyq5BM5GIQA=
=h69e
-----END PGP SIGNATURE-----

--OGdrsm9wa6bk/U+d--
