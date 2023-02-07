Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FC668E206
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 21:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjBGUkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 15:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbjBGUkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 15:40:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E238F3A5B9;
        Tue,  7 Feb 2023 12:39:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4354DCE1E8F;
        Tue,  7 Feb 2023 20:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9A6C433EF;
        Tue,  7 Feb 2023 20:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675802396;
        bh=w+rrQhOyjX+xSn+lkCQA/ZfXpy18C9NT1orJsYu8WrQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jh1hM7/xhNsp/euzJURNrI+OgX9NYfI06u2yZss0I6KDbq+5mrqpNKv8MsLvkwADB
         lQVMSiYfmlhEGfJ8RT7Wyx1XMNSSU3n1K3AA0HyOQ/e2OrqIZTTuBA6xNg2Iy+tF+p
         8YA7hGhyU2ppwZAdeqqXhoKcCS4xLok2D12P55uEl+xu/KT5UiW880XEbUwHpOQgG7
         rFApPUaz18FwXMUy1KfE7zc4IygGCc3fjLTJVvn3M7OlqpfY8jiVToMNaa7ldr6YsP
         kW6BoUPcRZb7OoxuxQGq/t6TsGqZ5s0MfMGNZVDKOqKHUv8+qM3erYHWl0G4oaO9FJ
         YSP3OLGluXDHg==
Date:   Tue, 7 Feb 2023 20:39:51 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Atish Patra <atishp@atishpatra.org>
Cc:     Stephano Cetola <stephano@riscv.org>, Jeff Scheel <jeff@riscv.org>,
        Anup Patel <apatel@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, pbonzini@redhat.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        ajones@ventanamicro.com, anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] RISC-V: Detect AIA CSRs from ISA string
Message-ID: <Y+K3FyGrNUQJZao8@spud>
References: <20230128072737.2995881-3-apatel@ventanamicro.com>
 <mhng-0f9bdf58-5289-4db4-8fd7-38898824c44f@palmer-ri-x1c9>
 <CAK9=C2X8C4yswGhDwe1OzQXTELXQxp8=ayiFxh1aVMk4TxeDjw@mail.gmail.com>
 <Y+KS16ZNXrDU+xun@spud>
 <CAOnJCUKKRRCrKN17ytczYXVLTcMkFaZsg6QXKjPUuSk=PqL6JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zu6F9f3ZsZxSjFKz"
Content-Disposition: inline
In-Reply-To: <CAOnJCUKKRRCrKN17ytczYXVLTcMkFaZsg6QXKjPUuSk=PqL6JQ@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--zu6F9f3ZsZxSjFKz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 07, 2023 at 10:15:22AM -0800, Atish Patra wrote:
> On Tue, Feb 7, 2023 at 10:05 AM Conor Dooley <conor@kernel.org> wrote:
> > On Fri, Feb 03, 2023 at 05:31:01PM +0530, Anup Patel wrote:
> > > On Fri, Feb 3, 2023 at 5:54 AM Palmer Dabbelt <palmer@dabbelt.com> wr=
ote:
> > > >
> > > > On Fri, 27 Jan 2023 23:27:32 PST (-0800), apatel@ventanamicro.com w=
rote:
> > > > > We have two extension names for AIA ISA support: Smaia (M-mode AI=
A CSRs)
> > > > > and Ssaia (S-mode AIA CSRs).
> > > >
> > > > This has pretty much the same problem that we had with the other
> > > > AIA-related ISA string patches, where there's that ambiguity with t=
he
> > > > non-ratified chapters.  IIRC when this came up in GCC the rough ide=
a was
> > > > to try and document that we're going to interpret the standard ISA
> > > > strings that way, but now that we're doing custom ISA extensions it
> > > > seems saner to just define on here that removes the ambiguity.
> > > >
> > > > I just sent
> > > > <https://lore.kernel.org/r/20230203001201.14770-1-palmer@rivosinc.c=
om/>
> > > > which documents that.
> > >
> > > I am not sure why you say that these are custom extensions.
> > >
> > > Multiple folks have clarified that both Smaia and Ssaia are frozen
> > > ISA extensions as-per RVI process. The individual chapters which
> > > are in the draft state have nothing to do with Smaia and Ssaia CSRs.
> > >
> > > Please refer:
> > > https://github.com/riscv/riscv-aia/pull/36
> > > https://lists.riscv.org/g/tech-aia/message/336
> > > https://lists.riscv.org/g/tech-aia/message/337
> >
> > All of these links seem to discuss the draft chapters somehow being
> > incompatible with the non-draft ones. I would very expect that that,
> > as pointed out in several places there, that the draft chapters
> > finalisation would not lead to meaningful (and incompatible!) changes
> > being made to the non-draft chapters.
> >
>=20
> Here is the status of all RVI specs. It states that the Smaia, Ssaia
> extensions are frozen (i.e. public review complete).
> https://wiki.riscv.org/display/HOME/Specification+Status
>=20
> I have added stephano/Jeff to confirm the same.
>=20
> AFAIK, IOMMU spec is close to the public review phase and should be
> frozen in this or next quarter.
> IIRC, this chapter in AIA will be frozen along with IOMMU spec.
>=20
> Anup: Please correct me if that's not correct.
>=20
> > Maybe yourself and Palmer are looking at this from different
> > perspectives? Looking at his patch from Friday:
> > https://lore.kernel.org/linux-riscv/20230203001201.14770-1-palmer@rivos=
inc.com/
> > He specifically mentioned this aspect, as opposed to the aspect that
> > your links refer to.
> >
> > Surely a duo-plic, if that ever comes to be, could be detected from
> > compatible strings in DT or w/e - but how do you intend differentiating
> > between an implementation of S*aia that contains the IOMMU support in
> > Chapter 9 in a finalised form, versus an implementation that may make
> > "different decisions" when it comes to that chapter of the spec?
>=20
> We will most likely have an extension specific to iommu spec as well.

Right, but unless I am misunderstanding you, that is an extension for the
IOMMU spec, not for Chapter 9 of the AIA spec?

I would say that it is likely that if you have AIA and IOMMU that you'd
want to be implementing Chapter 9, but that would not appear sufficient to
draw a conclusion from.

Maybe the RVI lads that you've added (or Anup for that matter!) can
clarify if there is a requirement that if you do AIA and IOMMU that you
must do Chapter 9.
If not, my prior question about a differentiation mechanism still applies
I think!

> > I thought that would be handled by extension versions, but I am told
> > that those are not a thing any more.
> > If that's not true, and there'll be a version number that we can pull in
> > from a DT and parse which will distinguish between the two, then please
> > correct my misunderstanding here!

--zu6F9f3ZsZxSjFKz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+K3FwAKCRB4tDGHoIJi
0nRUAQCzGk/oJbWN9mf9OIFLN+uyotpOGeyxY90lVVK4R5DBpgD/SR9y2qhD9PD/
NukTfTz4ynWyNGYdGD5ZL6W7V2x9DAg=
=ZDei
-----END PGP SIGNATURE-----

--zu6F9f3ZsZxSjFKz--
