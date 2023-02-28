Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96AB6A628B
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 23:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjB1Wgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 17:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjB1Wgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 17:36:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5C422A24
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 14:36:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC61F611FD
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 22:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4B0C433EF;
        Tue, 28 Feb 2023 22:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677623802;
        bh=ptAS0QM4D9CG7kJPSoXq64AQsB5YqS9PtOBPFZXM3k4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CAsXd4Z5OzYpB2xwVIfDmc8gharrVl0pD29ToeHgbQzhQTRTrtH2ADJ32lR/pWF+l
         ZGWoaKoGisLmQAs3M12M2llqKYp85jr3dAdRxIAEHTPCNp3bbIhXBpPpPOQwS40o6+
         2o/JfBjbi4joIVXoM0scWMdF/XFRYLZKa/89HsGpwSSadMUrNZMtC4+ja34sbEDibC
         a1KC1qxMM2rdfoXZzPH+ezCT7YKh4LJoqVw/uuIlWoJ8qTnij0mEst4peN1Ur83fKR
         CifdmPc1bjmSQ5t5VfFhQj77FwLA/mmc3zlaB/UBjepO3mq9ptZoUL7G3/85xhTicz
         lQToFaTb601tw==
Date:   Tue, 28 Feb 2023 22:36:36 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH -next v14 06/19] riscv: Introduce Vector enable/disable
 helpers
Message-ID: <Y/6B9DEhO0hivJVA@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-7-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WVh929Q4jXKSeDNh"
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-7-andy.chiu@sifive.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--WVh929Q4jXKSeDNh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2023 at 05:01:05PM +0000, Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> These are small and likely to be frequently called so implement as
> inline routines (vs. function call).
>=20
> Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> [vineetg: create new patch from meshup, introduced asm variant]
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> [andy.chiu: remove calls from asm thus remove asm vaiant]

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

--WVh929Q4jXKSeDNh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/6B9AAKCRB4tDGHoIJi
0qc0AP9vXPKSWRTJRZliQ5rly+kzB4+mfJwXqzlyHMotRU3nXAEA0/sXWoNJRsNq
GPR6/R/evHNQERjySHjirtXBOUO20wY=
=WyBS
-----END PGP SIGNATURE-----

--WVh929Q4jXKSeDNh--
