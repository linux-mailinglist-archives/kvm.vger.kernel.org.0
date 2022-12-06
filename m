Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2B4644902
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 17:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiLFQRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 11:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235531AbiLFQQ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 11:16:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F42AE44;
        Tue,  6 Dec 2022 08:12:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01DF9617AC;
        Tue,  6 Dec 2022 16:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2D0C433C1;
        Tue,  6 Dec 2022 16:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670343160;
        bh=HgFTfC9zyZQkoZmePhkz0MAY8w2m/nlUZpikKauzyNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EQOA1wFB7IjdbpNtB0kXUsH1jicB3zphJhix3CVdp7LRImEsvXizZS1+It1XCfvu0
         lzYC0HGDJUy1Rb2tVGlMB2dxjzI6bNi+p1+UMps0Za75Ua/rrbeVOnP4zBzZuqg3Ik
         oxl8BGNdB5yXmN6vl62fB4iKA7FITecNLHthCrt6eAb0NEgJ7swPvt5tUdqYgtN2OO
         E6UToeESPi6hVkSDfw0Jcp0FTiBVgSPEW8jWVNw4pqUzoVgAFUtBwLP6rf10cOIL9M
         4XaVIX3Jf8qCdwjqs9ctO1rEo0k3evwFI+FIZAjcyueXUE57OBzDe8MfBwtWKAa+kp
         zhs7703F9YS1A==
Date:   Tue, 6 Dec 2022 16:12:35 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 01/13] riscv: fix jal offsets in patched alternatives
Message-ID: <Y49p82Iac/+iYQ+1@spud>
References: <20221204174632.3677-1-jszhang@kernel.org>
 <10190559.nUPlyArG6x@diego>
 <Y45LRu0Gvrurm5Rh@spud>
 <12207576.O9o76ZdvQC@diego>
 <Y49Zi2CNv8pZSAe5@xhacker>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0yfmBJphl5BauK+i"
Content-Disposition: inline
In-Reply-To: <Y49Zi2CNv8pZSAe5@xhacker>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--0yfmBJphl5BauK+i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 06, 2022 at 11:02:35PM +0800, Jisheng Zhang wrote:

> > > Higher Powers here, but some sort of logical ordering would probably =
be
> > > a good idea so as not to hold each other up?
> > > The non-string bit of your series has been fairly well reviewed & wou=
ld,
> > > in theory, be mergeable once the tree re-opens? Timing aside, Jisheng=
's
> > > idea seems like a good one, no?
>=20
> IMHO, it will be better if Palmer can merge Heiko's alternative improveme=
nts
> into riscv-next once well reviewed and the window is reopen. Then Drew,
> Prabhakar and I can rebase on that tree.

Unless I missed something, we're saying the same thing in different ways
:)


--0yfmBJphl5BauK+i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY49p1QAKCRB4tDGHoIJi
0h75AQCs7HqktVAyyk++q+81eShEP/hyMgLVqh7NhSCXaYUMIQEA8Fq3lpbnzAbi
JQrKm36mZz/R5qyDiB9pd5bml2HvoQA=
=xqAW
-----END PGP SIGNATURE-----

--0yfmBJphl5BauK+i--
