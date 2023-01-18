Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38F8672B4D
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 23:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjARW3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 17:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjARW27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 17:28:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E04B47EE2;
        Wed, 18 Jan 2023 14:28:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE7FCB81F6D;
        Wed, 18 Jan 2023 22:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E249DC433EF;
        Wed, 18 Jan 2023 22:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674080936;
        bh=ScZ75Ow6zwZdhPgHHviF9EKWXuDCiB6x4DKzTlwd52g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cxwseR+yVfF10J5NX7hd+O0OucmJo+kF0g7/KV3nNGyAOwx42aihVfGyXM4PBk41t
         Rb0eEbhVi8a5pGdbRn4t96eOGzIaE6n0RrPPq+UkdAdgpIrMIGjrB5LJDuQNWi2bvo
         hjnv3lHSz+gU9PUmQnbz950hX4GJUvv1sISWrGgIekyT3X5P7lDIZee3mg56823ubS
         O76VKhsK8DhEf6Imhi5WjcWY3AGuVuD+a6do4pweDq9Y+NVaOxqPktPsZ54rT0l3Nf
         BQ6HZokzXRIbRRvEkQ+GyYQpnSwOiF6uJEYFFva+Xt8k14fdcNi+3KqA47j1Wawclv
         QJy5NgSxHbJ2Q==
Date:   Wed, 18 Jan 2023 22:28:51 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v4 05/13] riscv: cpufeature: extend
 riscv_cpufeature_patch_func to all ISA extensions
Message-ID: <Y8hyo573/Ts6K80s@spud>
References: <20230115154953.831-1-jszhang@kernel.org>
 <20230115154953.831-6-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tBo/phUjmG15esYd"
Content-Disposition: inline
In-Reply-To: <20230115154953.831-6-jszhang@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--tBo/phUjmG15esYd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 15, 2023 at 11:49:45PM +0800, Jisheng Zhang wrote:
> riscv_cpufeature_patch_func() currently only scans a limited set of
> cpufeatures, explicitly defined with macros. Extend it to probe for all
> ISA extensions.
>=20
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

With the same rationale as 6/13:
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--tBo/phUjmG15esYd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY8hyowAKCRB4tDGHoIJi
0u6pAP9JJDIa9Bpw5oTYPylFIJAIVzlaO7zYyPfjPRNnM2mARAD/d7Xbcmb7s8Ij
91eblxdkO20X/45seDyT7eKDOyBDvQk=
=whzM
-----END PGP SIGNATURE-----

--tBo/phUjmG15esYd--
