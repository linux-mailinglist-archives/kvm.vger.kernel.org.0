Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B644466845A
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 21:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbjALUxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 15:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbjALUwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 15:52:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03305D895;
        Thu, 12 Jan 2023 12:25:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BF5462174;
        Thu, 12 Jan 2023 20:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C079C433F0;
        Thu, 12 Jan 2023 20:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673555108;
        bh=9zwIgfryghF/hPAyByTTWjUD8VVtMbRU5rfWoB9mj9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K8gV+ziX4Q793ObSyocCG05xJsThWXKzS7TRBVtdKpg/OBjlzXUUQSr6oAlgo6f3B
         xZIbkkRBpDgshI1VPcOjoX0pfF4b7wGjjpdyUE2HntCz9/Zs6FI15m/9VqD5zbulNV
         n1zujl8AhaXgAF5C5/CgG9jNGffgadIH/B0XanePieaHUHFATgKT5zZhxyrnBUqltA
         GVfYV4XeH0OY23RrukX0/07SCr6YqCDjt4NN4x8vIoDYFYL5oaXGIMowOImLtuNin9
         gBoim/cppZw84M6yh7odJkWkTqDfofoPvL9s1PTkGtkgZLouMidrsOlMTn08t+2bzG
         OsKOT/IAaRswA==
Date:   Thu, 12 Jan 2023 20:25:03 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 01/13] riscv: fix jal offsets in patched alternatives
Message-ID: <Y8Bsn5Q0HYMNOt/R@spud>
References: <20230111171027.2392-1-jszhang@kernel.org>
 <20230111171027.2392-2-jszhang@kernel.org>
 <3268358.687JKscXgg@diego>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Ua1i9Pzh5KF+R9ch"
Content-Disposition: inline
In-Reply-To: <3268358.687JKscXgg@diego>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Ua1i9Pzh5KF+R9ch
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2023 at 12:31:59AM +0100, Heiko St=FCbner wrote:
> Am Mittwoch, 11. Januar 2023, 18:10:15 CET schrieb Jisheng Zhang:
> > Alternatives live in a different section, so offsets used by jal
> > instruction will point to wrong locations after the patch got applied.
> >=20
> > Similar to arm64, adjust the location to consider that offset.
> >=20
> > Co-developed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> > Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
>=20
> looks good, thanks for fixing the issues Andrew and Conor pointed
> out in the variant in my zbb series. I've now switched over to this one.
>=20
> I guess as you said, we really should separate this out into a single pat=
ch
> [or if Palmer is fine with that, just pick this one patch to apply until =
the
> rest is ready]

Splitting it out may make it easier to flag for him during the pw sync
next week? Either way, I'm fine w/ it..

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>


--Ua1i9Pzh5KF+R9ch
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY8BsnwAKCRB4tDGHoIJi
0o5zAP9jGqZSSAdRHCE3N4G2XUAYUpvR8Zxi0U0OiGGa5Sr1eAEAng/g1Dt5Slg6
suspJyY0z/VoCFEReP2eDtHoy6Qzagw=
=+jG3
-----END PGP SIGNATURE-----

--Ua1i9Pzh5KF+R9ch--
