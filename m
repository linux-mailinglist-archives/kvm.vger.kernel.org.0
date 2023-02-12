Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5B8693956
	for <lists+kvm@lfdr.de>; Sun, 12 Feb 2023 19:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBLSUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 13:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBLSUM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 13:20:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBBC1025E;
        Sun, 12 Feb 2023 10:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B4E2B80CBF;
        Sun, 12 Feb 2023 18:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BACDC433EF;
        Sun, 12 Feb 2023 18:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676226009;
        bh=MJjysyKBHGe9JZ/bqgooxVcRfzQCFzHhpHVyrLvWeA4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=enQuMwuBn6D1txzxnlMuUu8ScrNWig9UjQGKD3652roF/zJR5ynT6DibKKroUQdNL
         SCnOxAZfTlMGflXLK8xXj6Wq85KudB0sH+5yPds/d+hsfy/A/RyFZfB4/9+L7ulH1n
         kHip0k1TGvb3iew8gX8mwxp1QJzdPZtiC0V1KSx1HY7N0kYpqlY95LeYSMfwVg/sz1
         IUio0/iMp3+iSO6NepZVELn4vDb1I1ISnzWsPczD7EQssrLsUe/95qjbKvxTjyfjM4
         pjGELgtKA8jQQQYKSr9UcKlJ9/uqLjtB9Cg41x4Ztl0j9cbt2LLI5ZB8LXWnUyJGgh
         WHnr6C8KhYIKg==
Date:   Sun, 12 Feb 2023 18:20:03 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v5 00/13] riscv: improve boot time isa extensions handling
Message-ID: <Y+kt04c1iRlzUNLA@spud>
References: <20230128172856.3814-1-jszhang@kernel.org>
 <20230212154333.GA3760469@roeck-us.net>
 <Y+kM//nuDv29Z9qJ@spud>
 <Y+kU9nDBTttZRLLq@spud>
 <Y+kcgcncQO/2DNLo@spud>
 <Y+kqi8bQE+8hLfOF@spud>
 <a059a815-dcb0-c575-b5a4-f9433e268e9b@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LL9KTVybbDibeZ25"
Content-Disposition: inline
In-Reply-To: <a059a815-dcb0-c575-b5a4-f9433e268e9b@roeck-us.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--LL9KTVybbDibeZ25
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 12, 2023 at 10:14:13AM -0800, Guenter Roeck wrote:
> On 2/12/23 10:06, Conor Dooley wrote:
> > On Sun, Feb 12, 2023 at 05:06:09PM +0000, Conor Dooley wrote:
> > > On Sun, Feb 12, 2023 at 04:33:58PM +0000, Conor Dooley wrote:
> > > > On Sun, Feb 12, 2023 at 03:59:59PM +0000, Conor Dooley wrote:
> > >=20
> > > So as not to lead anyone up the garden path, let me correct myself:
> > >=20
> > > > Hmm, so this appears to be us attempting to patch in alternatives w=
here
> > > > none actually exists - seemingly F & D.
> > >=20
> > > And of course that's not true, riscv_has_extension_likely() now uses
> > > alternatives as of:
> > > bdda5d554e43 ("riscv: introduce riscv_has_extension_[un]likely()")
> > >=20
> > >  From a quick look, it just happens that the only users are F & D.
> > >=20
> >=20
> > Samuel pointed out that this is a lockdep splat on irc.
> > There's a patch on the list that removes the lockdep annotation
> > entirely:
> > https://patchwork.kernel.org/project/linux-riscv/patch/20230202114116.3=
695793-1-changbin.du@huawei.com/
> >=20
> > So ye, no surprises that it was config based!
> >=20
> > Palmer posted a "better" fix for that lockdep warning a while ago:
> > https://lore.kernel.org/all/20220322022331.32136-1-palmer@rivosinc.com/
> >=20
> > So we'd have to duplicate/reuse that for cpufeature/errata patching.
> >=20
> >=20
>=20
> This does not (only) happen in stop_machine().

Yah, sorry I meant that it's the same lockdep splat as is being
addressed there.
The first patch deletes the lockdep stuff entirely, so removes the
splat. I was thinking that we'd need to take Palmer's (IMO better)
patch and do the same thing for patching alternatives, but I figure we
can just take the text_mutex itself for alternatives & not have to
dance around the lock.

I'll go do that I suppose!

--LL9KTVybbDibeZ25
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+kt0wAKCRB4tDGHoIJi
0lCHAP9dmIfODGeFB30mrFC0ZS7H8294Wq2cp9dIc6LMlnpd2AEAiBTRGyJfm/jN
XVO7+oQ9i0CJT3HiApBW4j9H3mFCbgU=
=gBzF
-----END PGP SIGNATURE-----

--LL9KTVybbDibeZ25--
