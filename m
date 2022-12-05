Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB42E642BDD
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbiLEPdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbiLEPdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:33:04 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC68ECE10;
        Mon,  5 Dec 2022 07:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670254319; x=1701790319;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L3TUDdEfVXXA4C8sB36l+K0kaLbB0aPyJJYOu8pH7JM=;
  b=IQ8SfO5akwmO6eZyjLHFOZkcjC+tO7opKSz3eZ+qXMxHJuQsk2nWRrCv
   3eeslsv49YLEiNZcFf7VXDr0jrLVxR65mEBy2ub7fFgRdnuVkLRXK7wiZ
   O+UPRz14mngnKwNyPIKVWP1YWxguav4J1/rZtN/sGP2JnwyYhXYdUSNpQ
   HxDjVuJ/AnHRibvp7Wgv7DgECxEXs24X5w6/ao+TLstFeGMepYVfb19vm
   SakxREq69NPkz5MIRGSuhvqqxBoD2KkWO2+AdHspBTwewAQmdqby3i9Oq
   9066Jag60rRdgshFDXSWXBiU/FW+rSEnOERxMdYM/+6R2/0LFgZ0ja6/2
   A==;
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="asc'?scan'208";a="126542243"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Dec 2022 08:31:59 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 5 Dec 2022 08:31:57 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Mon, 5 Dec 2022 08:31:55 -0700
Date:   Mon, 5 Dec 2022 15:31:36 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Jisheng Zhang <jszhang@kernel.org>
CC:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>
Subject: Re: [PATCH v2 02/13] riscv: move riscv_noncoherent_supported() out
 of ZICBOM probe
Message-ID: <Y44O2K1zBbYYuO0e@wendy>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <20221204174632.3677-3-jszhang@kernel.org>
 <5629547.DvuYhMxLoT@diego>
 <Y44LTqySUMCtKoUi@xhacker>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jz/SVZxvlhBLeUjF"
Content-Disposition: inline
In-Reply-To: <Y44LTqySUMCtKoUi@xhacker>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--jz/SVZxvlhBLeUjF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 05, 2022 at 11:16:30PM +0800, Jisheng Zhang wrote:
> will wait for one more day for more review comments, then will send out
> a v3

AFAICT, the patches were only sent yesterday? It'd be nice if you could
give us more than 2 days between versions of something please :/

Thanks
Conor.


--jz/SVZxvlhBLeUjF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY44O2AAKCRB4tDGHoIJi
0g44AP9T9glXMSJHOi4ecObAgE+gc0gODsNLSnzUijjLs51fjgD/dS8LZHDmZ80i
joINNAZsV3++O3M7VnMGG5SYyw5jdwQ=
=A9Uf
-----END PGP SIGNATURE-----

--jz/SVZxvlhBLeUjF--
