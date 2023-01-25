Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C9D67BFCF
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 23:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbjAYWSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 17:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjAYWSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 17:18:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C235C0F3
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 14:18:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C144B81BA4
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 22:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B39C433D2;
        Wed, 25 Jan 2023 22:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674685130;
        bh=qUbU6mhOLmqFlPJ6M9CMSUW8qu63FhjFw9HO4CS4Ius=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SR0ULMZJZaIAKNb1VEeLQfR3+5cGIObw/PpMhJQfyfoE+3cvgd1K61mYfHUH47Ctk
         3Bm9xaIub7jo+y7U73PBRd9H7Zp8WhT7BkRPF3swiGRvM4iXTA7eKvM1fTMW6W6v4h
         I6LIZFfjwhVK4yIcaV1PLhX8l8LG7WnFpfezKjqq87i0vMeUZ0hd1zw14VGqZSwyrv
         LxOM6iI3nBM5URZH3LXaFjlwgAyNr0hPD7GoMwdiJUeVZM3i/ymXJGhWUxczliWlH5
         D4puxSN7c+LeweP3OjFbn0EoyRS6WcTfsxQurzV7H7RrWFOs1CjywyS8QY4Tu/F+7x
         UPTquyLqwvRfg==
Date:   Wed, 25 Jan 2023 22:18:44 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Vineet Gupta <vineetg@rivosinc.com>
Cc:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Myrtle Shah <gatecat@ds0.me>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>
Subject: Re: [PATCH -next v13 04/19] riscv: Clear vector regfile on bootup
Message-ID: <Y9GqxMFz+m6K9k5c@spud>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-5-andy.chiu@sifive.com>
 <Y9Gk/FCFBbWC/Pyi@spud>
 <428eb479-5066-f8c6-ad98-4eeac53a5be8@rivosinc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/ZHPm/CBrzLmEWjf"
Content-Disposition: inline
In-Reply-To: <428eb479-5066-f8c6-ad98-4eeac53a5be8@rivosinc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--/ZHPm/CBrzLmEWjf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 25, 2023 at 01:57:28PM -0800, Vineet Gupta wrote:
>=20
> On 1/25/23 13:54, Conor Dooley wrote:
> > n Wed, Jan 25, 2023 at 02:20:41PM +0000, Andy Chiu wrote:
> > > clear vector registers on boot if kernel supports V.
> > >=20
> > > Signed-off-by: Greentime Hu<greentime.hu@sifive.com>
> > > Signed-off-by: Vineet Gupta<vineetg@rivosinc.com>
> > > [vineetg: broke this out to a seperate patch]
> > > Signed-off-by: Andy Chiu<andy.chiu@sifive.com>
> > But this patch didn't carry over the long list of contributors from it's
> > source? Seems a bit odd, that's all.
> > There was also an Rb from Palmer that got dropped too. Was that
> > intentional?
> > https://lore.kernel.org/linux-riscv/20220921214439.1491510-6-stillson@r=
ivosinc.com/
>=20
> In v12 this and 5/19 were in one patch, which I broke off into two for
> clarity. Hence the Rb technically doesn't apply.

Technically correct, the best kind, huh?

Anyways, I just noticed that this patch had a comment from Heiko that
wasn't addressed to maybe the omission is for the better!

https://lore.kernel.org/linux-riscv/2331455.NG923GbCHz@diego/

Thanks,
Conor.


--/ZHPm/CBrzLmEWjf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY9GqxAAKCRB4tDGHoIJi
0k2lAQD2+2dy+geW+jSBc7VzfJD+dF70e87vWWhhXkfIojnrvAD/ZbZtaBGlguSI
by+i5QSl0Gsowy15w/2Kg3yF3mLfzw0=
=Udh4
-----END PGP SIGNATURE-----

--/ZHPm/CBrzLmEWjf--
