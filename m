Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB0B7086E3
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 19:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjERR32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 13:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjERR27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 13:28:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F0610CE
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 10:28:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C298765124
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 17:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7A6C4339B;
        Thu, 18 May 2023 17:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684430934;
        bh=92QcsgMHry019d9efae2Tj4VZis/VYU62VUDqpKGFXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RRS+DDn9w6WfvQsflgrH8SenSC4v1Yuv/8wGqfDtG6weJu9cQA1AxVBwf64s686IC
         7ft13Rcf5pBKMGCgp+Sp8VX7ECqS97WfxsY0H90YNaMXzcIZQqCvvxC9owSBIgfoiO
         cS1+p/9t0hwZq+sot3BqHd0ggzf8JUMqtlEAX56zGNMhNqggrrJFKNe91m7sG4zn3W
         z5ZDpgsb9hRaOowyEYF+Mo7IZgXqdEISXIbitlkeo4pLY5FNbZ3e9jsFWxtb8XMfbD
         lbI+jXcj+fcT6fiFr9+Bn1zosb48/HM1AvdeV5jXhUo3MizVZuIJb/BsZfkh4oiQdm
         REeSzzO/Y9OFQ==
Date:   Thu, 18 May 2023 18:28:47 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Evan Green <evan@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Celeste Liu <coelacanthus@outlook.com>
Subject: Re: [PATCH -next v20 03/26] riscv: hwprobe: Add support for probing
 V in RISCV_HWPROBE_KEY_IMA_EXT_0
Message-ID: <20230518-decade-slighting-02219199662e@spud>
References: <20230518161949.11203-1-andy.chiu@sifive.com>
 <20230518161949.11203-4-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="G2eka028RqLLt5eR"
Content-Disposition: inline
In-Reply-To: <20230518161949.11203-4-andy.chiu@sifive.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--G2eka028RqLLt5eR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 18, 2023 at 04:19:26PM +0000, Andy Chiu wrote:
> Probing kernel support for Vector extension is available now. This only
> add detection for V only. Extenions like Zvfh, Zk are not in this scope.
>=20
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

Looks grand now!
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

--G2eka028RqLLt5eR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZGZgTwAKCRB4tDGHoIJi
0ioKAP9v5j65uZSJMmCxWO99hc/abZpOXqLcl4pLcp2TGXlIrwEA6Z5gFAi0kYrs
IpiAjb2x78S5AN5z1f+e8rsWop8xdQQ=
=MG8z
-----END PGP SIGNATURE-----

--G2eka028RqLLt5eR--
