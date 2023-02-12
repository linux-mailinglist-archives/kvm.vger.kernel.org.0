Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1018569393E
	for <lists+kvm@lfdr.de>; Sun, 12 Feb 2023 19:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjBLSGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 13:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBLSGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 13:06:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F0EE043;
        Sun, 12 Feb 2023 10:06:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4E6E60DBD;
        Sun, 12 Feb 2023 18:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C830C433D2;
        Sun, 12 Feb 2023 18:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676225169;
        bh=lp88wKQLqiF3Hiyw44dr0tpOeS79utafc+HLRjWlnYg=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=raJG3DXHPsmVeD91Ru+9mmbE/4O4IYRntyJ3WTHhIqt2KY2fmSrEnXz2x5bq8NLps
         pbLRXwK3BiBMN1LQNpUmZCcOYpPg4GlwJVZGv3W1Etv/r+cmPBQvo/yc5vFInIaF9b
         Aie6WTLql1XOemrAWDJjniRKO6aD23VkBeEQaZ5XAfmnB9/NOML93vi5Zp3aNbLeA9
         ykexNiySadnHumXTDovz1HQUOmqPcZYSSJhMLjkIS7tqhzIw7Ea6MPcVJYWuyDJk/L
         inx7/PxQvnaZ7X3yZ/28faDwVb99ZToMT7ZkoRcFGuHtZ6v5zzyxCZqO26gp2fMHwV
         UQfnSLYUISkLw==
Date:   Sun, 12 Feb 2023 18:06:03 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v5 00/13] riscv: improve boot time isa extensions handling
Message-ID: <Y+kqi8bQE+8hLfOF@spud>
References: <20230128172856.3814-1-jszhang@kernel.org>
 <20230212154333.GA3760469@roeck-us.net>
 <Y+kM//nuDv29Z9qJ@spud>
 <Y+kU9nDBTttZRLLq@spud>
 <Y+kcgcncQO/2DNLo@spud>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GmLjP+yv5qcdEtuf"
Content-Disposition: inline
In-Reply-To: <Y+kcgcncQO/2DNLo@spud>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--GmLjP+yv5qcdEtuf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 12, 2023 at 05:06:09PM +0000, Conor Dooley wrote:
> On Sun, Feb 12, 2023 at 04:33:58PM +0000, Conor Dooley wrote:
> > On Sun, Feb 12, 2023 at 03:59:59PM +0000, Conor Dooley wrote:
>=20
> So as not to lead anyone up the garden path, let me correct myself:
>=20
> > Hmm, so this appears to be us attempting to patch in alternatives where
> > none actually exists - seemingly F & D.
>=20
> And of course that's not true, riscv_has_extension_likely() now uses
> alternatives as of:
> bdda5d554e43 ("riscv: introduce riscv_has_extension_[un]likely()")
>=20
> From a quick look, it just happens that the only users are F & D.
>=20

Samuel pointed out that this is a lockdep splat on irc.
There's a patch on the list that removes the lockdep annotation
entirely:
https://patchwork.kernel.org/project/linux-riscv/patch/20230202114116.36957=
93-1-changbin.du@huawei.com/

So ye, no surprises that it was config based!

Palmer posted a "better" fix for that lockdep warning a while ago:
https://lore.kernel.org/all/20220322022331.32136-1-palmer@rivosinc.com/

So we'd have to duplicate/reuse that for cpufeature/errata patching.



--GmLjP+yv5qcdEtuf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+kqiwAKCRB4tDGHoIJi
0vcsAQDNCg9J+6Vcsh5GKfX2XL35m7Wf0yDTU5M28FIiLYqBUgEAshGaQIbqzGuw
8lC8srYQoSDY+hH/TPM6ZvHj9k1AqQY=
=Vm7y
-----END PGP SIGNATURE-----

--GmLjP+yv5qcdEtuf--
