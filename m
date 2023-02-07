Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843D468DF9C
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 19:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjBGSJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 13:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjBGSJP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 13:09:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B653929E;
        Tue,  7 Feb 2023 10:09:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C47AB81A62;
        Tue,  7 Feb 2023 18:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0347CC4339C;
        Tue,  7 Feb 2023 18:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675793351;
        bh=A61mxs51RQi1CT3b7+2fhV1PgeLHz3NXj6iqsSVSE3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FnXG7/FDj2CuthK8w/hJk0Az+m2K0RotFrej1UYtHfG2X03fUijM4vs/TmJw8wpMN
         u+TsBh8aAOIBRk32J11nmd7BLDNU3QNA1Rkb1rIr9A4lhrLIAkzGZNQ71DbHQNVdEe
         ev92ymE6F9bqusQZMcXz0oECdlgr0SvREjM8u1mvi80tuILVz/8X8QCcEyz3SSsgp7
         vzztwXi5NIfsuqGfKb4XWO8J4oWKG9gLmjCdPcnvl6vaPFEfcR3IToYsehDk9ZNU2U
         Z30D5p26yC5kylnkZSpeo1JMxpXXqJrsI1MgaIb1z9xqLGFxCJm2AC8thuhasnHENc
         Z0nm9c5oQFHOw==
Date:   Tue, 7 Feb 2023 18:09:06 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>, pbonzini@redhat.com,
        atishp@atishpatra.org, Paul Walmsley <paul.walmsley@sifive.com>,
        ajones@ventanamicro.com, anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] RISC-V: Detect AIA CSRs from ISA string
Message-ID: <Y+KTwoYwqhFiDerT@spud>
References: <20230128072737.2995881-3-apatel@ventanamicro.com>
 <mhng-0f9bdf58-5289-4db4-8fd7-38898824c44f@palmer-ri-x1c9>
 <CAK9=C2X8C4yswGhDwe1OzQXTELXQxp8=ayiFxh1aVMk4TxeDjw@mail.gmail.com>
 <Y+KS16ZNXrDU+xun@spud>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5ykwkVT5VxFHFard"
Content-Disposition: inline
In-Reply-To: <Y+KS16ZNXrDU+xun@spud>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--5ykwkVT5VxFHFard
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 07, 2023 at 06:05:11PM +0000, Conor Dooley wrote:
> Hey Anup, Palmer,
>=20
> On Fri, Feb 03, 2023 at 05:31:01PM +0530, Anup Patel wrote:
> > On Fri, Feb 3, 2023 at 5:54 AM Palmer Dabbelt <palmer@dabbelt.com> wrot=
e:
> > >
> > > On Fri, 27 Jan 2023 23:27:32 PST (-0800), apatel@ventanamicro.com wro=
te:
> > > > We have two extension names for AIA ISA support: Smaia (M-mode AIA =
CSRs)
> > > > and Ssaia (S-mode AIA CSRs).
> > >
> > > This has pretty much the same problem that we had with the other
> > > AIA-related ISA string patches, where there's that ambiguity with the
> > > non-ratified chapters.  IIRC when this came up in GCC the rough idea =
was
> > > to try and document that we're going to interpret the standard ISA
> > > strings that way, but now that we're doing custom ISA extensions it
> > > seems saner to just define on here that removes the ambiguity.
> > >
> > > I just sent
> > > <https://lore.kernel.org/r/20230203001201.14770-1-palmer@rivosinc.com=
/>
> > > which documents that.
> >=20
> > I am not sure why you say that these are custom extensions.
> >=20
> > Multiple folks have clarified that both Smaia and Ssaia are frozen
> > ISA extensions as-per RVI process. The individual chapters which
> > are in the draft state have nothing to do with Smaia and Ssaia CSRs.
> >=20
> > Please refer:
> > https://github.com/riscv/riscv-aia/pull/36
> > https://lists.riscv.org/g/tech-aia/message/336
> > https://lists.riscv.org/g/tech-aia/message/337
>=20
> All of these links seem to discuss the draft chapters somehow being
> incompatible with the non-draft ones. I would very expect that that,
> as pointed out in several places there, that the draft chapters
> finalisation would not lead to meaningful (and incompatible!) changes
> being made to the non-draft chapters.
>=20
> Maybe yourself and Palmer are looking at this from different
> perspectives? Looking at his patch from Friday:
> https://lore.kernel.org/linux-riscv/20230203001201.14770-1-palmer@rivosin=
c.com/
> He specifically mentioned this aspect, as opposed to the aspect that
> your links refer to.

Meh, bad re-ordering of my paragraphs. By "this aspect" I meant what is
in the below paragraph! Apologies for any confusion there :)

> Surely a duo-plic, if that ever comes to be, could be detected from
> compatible strings in DT or w/e - but how do you intend differentiating
> between an implementation of S*aia that contains the IOMMU support in
> Chapter 9 in a finalised form, versus an implementation that may make
> "different decisions" when it comes to that chapter of the spec?
> I thought that would be handled by extension versions, but I am told
> that those are not a thing any more.
> If that's not true, and there'll be a version number that we can pull in
> from a DT and parse which will distinguish between the two, then please
> correct my misunderstanding here!
>=20
> Thanks,
> Conor.
>=20
> > > > We extend the ISA string parsing to detect Smaia and Ssaia extensio=
ns.
> > > >
> > > > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > > > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > > > ---
> > > >  arch/riscv/include/asm/hwcap.h | 2 ++
> > > >  arch/riscv/kernel/cpu.c        | 2 ++
> > > >  arch/riscv/kernel/cpufeature.c | 2 ++
> > > >  3 files changed, 6 insertions(+)
> > > >
> > > > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/as=
m/hwcap.h
> > > > index 86328e3acb02..341ef30a3718 100644
> > > > --- a/arch/riscv/include/asm/hwcap.h
> > > > +++ b/arch/riscv/include/asm/hwcap.h
> > > > @@ -59,6 +59,8 @@ enum riscv_isa_ext_id {
> > > >       RISCV_ISA_EXT_ZIHINTPAUSE,
> > > >       RISCV_ISA_EXT_SSTC,
> > > >       RISCV_ISA_EXT_SVINVAL,
> > > > +     RISCV_ISA_EXT_SMAIA,
> > > > +     RISCV_ISA_EXT_SSAIA,
> > > >       RISCV_ISA_EXT_ID_MAX
> > > >  };
> > > >  static_assert(RISCV_ISA_EXT_ID_MAX <=3D RISCV_ISA_EXT_MAX);
> > > > diff --git a/arch/riscv/kernel/cpu.c b/arch/riscv/kernel/cpu.c
> > > > index 1b9a5a66e55a..a215ec929160 100644
> > > > --- a/arch/riscv/kernel/cpu.c
> > > > +++ b/arch/riscv/kernel/cpu.c
> > > > @@ -162,6 +162,8 @@ arch_initcall(riscv_cpuinfo_init);
> > > >   *    extensions by an underscore.
> > > >   */
> > > >  static struct riscv_isa_ext_data isa_ext_arr[] =3D {
> > > > +     __RISCV_ISA_EXT_DATA(smaia, RISCV_ISA_EXT_SMAIA),
> > > > +     __RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
> > >
> > > This will conflict with that ISA string refactoring I just merged.  It
> > > should be a pretty mechanical merge conflict, but if you want we can =
do
> > > a shared tag with the first few patches and I can handle the merge
> > > conflict locally.
> >=20
> > I am planning to send this series as a second PR for Linux-6.3 after yo=
ur
> > PR (which includes ISA string refactoring) is merged. Is that okay with=
 you?
> >=20
> > With that said, it would request you to ACK this patch as well.
> >=20
> > >
> > > >       __RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
> > > >       __RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
> > > >       __RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> > > > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpu=
feature.c
> > > > index 93e45560af30..3c5b51f519d5 100644
> > > > --- a/arch/riscv/kernel/cpufeature.c
> > > > +++ b/arch/riscv/kernel/cpufeature.c
> > > > @@ -228,6 +228,8 @@ void __init riscv_fill_hwcap(void)
> > > >                               SET_ISA_EXT_MAP("zihintpause", RISCV_=
ISA_EXT_ZIHINTPAUSE);
> > > >                               SET_ISA_EXT_MAP("sstc", RISCV_ISA_EXT=
_SSTC);
> > > >                               SET_ISA_EXT_MAP("svinval", RISCV_ISA_=
EXT_SVINVAL);
> > > > +                             SET_ISA_EXT_MAP("smaia", RISCV_ISA_EX=
T_SMAIA);
> > > > +                             SET_ISA_EXT_MAP("ssaia", RISCV_ISA_EX=
T_SSAIA);
> > > >                       }
> > > >  #undef SET_ISA_EXT_MAP
> > > >               }
> >=20
> > Thanks,
> > Anup



--5ykwkVT5VxFHFard
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+KTwgAKCRB4tDGHoIJi
0qtkAP98HdRwH//PH1gFL3IDu6J6bYpsjAslTrr49kx1bfYhMAEA0rIjWlFp6pVe
dYuGt2ALxKTcyyzZ3ZbOuz1/ZwvuEQw=
=eT5W
-----END PGP SIGNATURE-----

--5ykwkVT5VxFHFard--
