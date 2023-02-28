Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2B26A6243
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 23:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjB1WRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 17:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjB1WRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 17:17:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1259832E7A
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 14:17:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E6BA611F6
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 22:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA23BC433EF;
        Tue, 28 Feb 2023 22:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677622666;
        bh=4cq2UPWzy/APUWnFh02yE84YUWWFXLX5iWYAk2r0d4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pu3IxHfCMemeEKd5FjtVa2I8T+cf04nsN9MbQyzKfs4PoSWuKEBBOFikJO8YQcpMN
         dzV57FcQxFDSqpi0S9o+spoTHCkmgC9fGxY8q2lSmyx3pY/1RSjIhmnHctL02+PpjW
         dn7Y3zpKHX77cLxyEZ2kxJdnWuaUckT3g9b33znhXDdOmAJE3GtaHQdMQjMqu8+jlq
         4KW/7IHIQDxYXuz5VE9cfRy9hJlTxZvjzrD4DFa852ocIZSAwhDXOoSPtrXwsXNJu/
         VGOgVK05ksYlhRcrCfpu4WkII1duxBuic4gUn/TGxyQ52bng4Y44PV95uhNt8PpoN7
         a997KIM3OuXFQ==
Date:   Tue, 28 Feb 2023 22:17:40 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>
Subject: Re: [PATCH -next v14 04/19] riscv: Clear vector regfile on bootup
Message-ID: <Y/59hMj+0D0QBrG+@spud>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
 <20230224170118.16766-5-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Jd/LQnQT6zacPVri"
Content-Disposition: inline
In-Reply-To: <20230224170118.16766-5-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Jd/LQnQT6zacPVri
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2023 at 05:01:03PM +0000, Andy Chiu wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>=20
> clear vector registers on boot if kernel supports V.
>=20
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> [vineetg: broke this out to a seperate patch]
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

--Jd/LQnQT6zacPVri
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY/59hAAKCRB4tDGHoIJi
0r2gAP9CPBOPRqz9ixv3kCCVBOI8vjmI+h1F+wd1K4Xde9fH5QEA1k+rhZY+2Vcd
gyVr8xijUqqPmEgxpLKCUI9H9dd2fwU=
=qN2n
-----END PGP SIGNATURE-----

--Jd/LQnQT6zacPVri--
