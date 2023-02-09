Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBA669146E
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 00:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjBIXbi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 18:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjBIXbg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 18:31:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07ABD76B3;
        Thu,  9 Feb 2023 15:31:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78137B82361;
        Thu,  9 Feb 2023 23:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0F6C433EF;
        Thu,  9 Feb 2023 23:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675985491;
        bh=O69LuhcZctd57x4lhJFdI4eIyFQSa4iSqPKotAdsMPs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ufFIYrT9UvLFb9qyPXt821NOnhRi4wl83XuBhkKVoT3uRaTvaXkMYdTvXuBlRiVCH
         lL4Vxuewop0JrgU9U1VGZZ59u8rjcYnZB007pA+WN9gR7juX7RHjo6rZSxIvz78jWc
         bWyP1tL9I1gNbOJ8fL1pkm1qYlIZmwEKboE5b8u3CnWaQcwtN7MYEJf3DqtTXwjo0f
         YgDAFykZxjYhC1sTpsyozbKJ40tQajhzMCx9uMoL4d/1oEFrs3y8cY86s9fCB+8Svm
         IFTjkcK9wM14PFlw1Ssh/zSpN5C/Zc5tmp/mAoOSV2cmPkqs2u1hcVwdZ8B79sswW6
         x7IVYN87AT3VA==
Date:   Thu, 9 Feb 2023 23:31:24 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Atish Patra <atishp@atishpatra.org>,
        Stephano Cetola <stephano@riscv.org>,
        Jeff Scheel <jeff@riscv.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, pbonzini@redhat.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        ajones@ventanamicro.com, anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] RISC-V: Detect AIA CSRs from ISA string
Message-ID: <Y+WCTDgtTwLB/8re@spud>
References: <20230128072737.2995881-3-apatel@ventanamicro.com>
 <mhng-0f9bdf58-5289-4db4-8fd7-38898824c44f@palmer-ri-x1c9>
 <CAK9=C2X8C4yswGhDwe1OzQXTELXQxp8=ayiFxh1aVMk4TxeDjw@mail.gmail.com>
 <Y+KS16ZNXrDU+xun@spud>
 <CAOnJCUKKRRCrKN17ytczYXVLTcMkFaZsg6QXKjPUuSk=PqL6JQ@mail.gmail.com>
 <Y+K3FyGrNUQJZao8@spud>
 <CAK9=C2VnkK5GNO4D1AWpiNcTE=OrSueN9NAyhR7rj9csuUi4Mg@mail.gmail.com>
 <Y+OcId2PZ0pi5T08@wendy>
 <CAK9=C2VeyJMHocZMQTZoULveAcH0kdH2vBKZYFt5kq9dMYP_Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Vv2d+yOSyM4AvbL5"
Content-Disposition: inline
In-Reply-To: <CAK9=C2VeyJMHocZMQTZoULveAcH0kdH2vBKZYFt5kq9dMYP_Bw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Vv2d+yOSyM4AvbL5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey all,

Just circling back to this one, since the reply from Palmer was to
another thread with a much smaller CC list.

On Wed, Feb 08, 2023 at 08:27:23PM +0530, Anup Patel wrote:
> On Wed, Feb 8, 2023 at 6:27 PM Conor Dooley <conor.dooley@microchip.com> =
wrote:
> > On Wed, Feb 08, 2023 at 09:24:28AM +0530, Anup Patel wrote:

> > > The presence of S*aia in ISA string only implies that AIA extended
> > > local interrupt CSRs are implemented by the underlying RISC-V
> > > implementation.
> >
> > Would you mind linking to where this is documented & explaining in your
> > commit message why it is okay operate on the basis of s*aia in the ISA
> > string only mandates the presence of the CSRs and nothing more.
> >
> > I think when I was reading it last night, I saw some commentary in this
> > vein in Section 1.6 of the rc2 spec. Although IIRC it noted changes in
> > interrupt behaviour there too, so I'm not sure if that section is what =
you
> > are referring to here.
> >
> > Perhaps this is all just a good argument for providing more information
> > in commit messages ;)
>=20
> Sure, I am anyway going to send v3 after rebase so I will cite the
> Section 1.6 of AIA spec in the commit description.

We had a nice conversation about this on during the weekly patchwork
sync call :)
The end result of that one was "inconclusive" and the outcome appears to
be that we will wait until the entire spec is frozen before doing
anything here.
Palmer left a comment in response to another thread to that effect:
https://lore.kernel.org/linux-riscv/mhng-474f7ecd-65b8-4cfa-8b75-e51b896cc5=
8e@palmer-ri-x1c9/

Cheers,
Conor.


--Vv2d+yOSyM4AvbL5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+WCTAAKCRB4tDGHoIJi
0q6sAP49zNucepjSQABZqre91PwzpDcltIfXd1XLoWl0qDu0CQD7BAx2at0D4LVx
XsqZPYOLysSc280F7lsVo8sayoX3Egs=
=wLGy
-----END PGP SIGNATURE-----

--Vv2d+yOSyM4AvbL5--
