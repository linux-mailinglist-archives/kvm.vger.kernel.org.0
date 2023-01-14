Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70CB66ADA9
	for <lists+kvm@lfdr.de>; Sat, 14 Jan 2023 21:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjANUct (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Jan 2023 15:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjANUcq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Jan 2023 15:32:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DE7BBB5;
        Sat, 14 Jan 2023 12:32:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5881560C15;
        Sat, 14 Jan 2023 20:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61CDC433EF;
        Sat, 14 Jan 2023 20:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673728362;
        bh=eS/dp6A/Ayp4qiNJxarXEqc+FGCtPq6hZJp6OUD6ZMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uBbG/5G+64ZRNSgPMRoil6n1Qcc2ZtrvSIbkayI/q45MQqkcROAVac2B4pTw74dPB
         r7tbaUuf8Ikt5cmI2ix8tBCNGedhRSIf/cw1U1cBYcRWjapbJAoIsQi2mA/nwFOXNZ
         ZHn8KYAY7ywLGKA1rSeXC0+eaakFBj4EBHnZHVcsGB3gs3V60Ehjm+q8EGb2sdSiEf
         hE9agK7eeGRE5qdoxkSVgBNA8gnb+/WHwg97rNxYAUD5VSggAmrmOxG4M8NG7VwWNq
         Uep2Ni6KlVV2/I2zhj2h533dZQrZfVKWD9Uc8dGxkiI3wPKMHB6mZ7GRNGJTXwIoz1
         yAkWagQbfPrqw==
Date:   Sat, 14 Jan 2023 20:32:37 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Andrew Jones <ajones@ventanamicro.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc:     Andrew Jones <ajones@ventanamicro.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 05/13] riscv: cpufeature: extend
 riscv_cpufeature_patch_func to all ISA extensions
Message-ID: <Y8MRZQENua+wi34T@spud>
References: <20230111171027.2392-1-jszhang@kernel.org>
 <20230111171027.2392-6-jszhang@kernel.org>
 <2398293.3Lj2Plt8kZ@diego>
 <20230112092136.f2g43hrhmrqouy4y@orel>
 <Y8F2YxMHUt+djhX4@wendy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EFHGJ8DlNAqr/5NN"
Content-Disposition: inline
In-Reply-To: <Y8F2YxMHUt+djhX4@wendy>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--EFHGJ8DlNAqr/5NN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello again!

On Fri, Jan 13, 2023 at 03:18:59PM +0000, Conor Dooley wrote:
> On Thu, Jan 12, 2023 at 10:21:36AM +0100, Andrew Jones wrote:
> > On Thu, Jan 12, 2023 at 12:29:57AM +0100, Heiko St=C3=BCbner wrote:
> > > Am Mittwoch, 11. Januar 2023, 18:10:19 CET schrieb Jisheng Zhang:
> > > > riscv_cpufeature_patch_func() currently only scans a limited set of
> > > > cpufeatures, explicitly defined with macros. Extend it to probe for=
 all
> > > > ISA extensions.
> > > >=20
> > > > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > > > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > > > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> > > > ---
> > > >  arch/riscv/include/asm/errata_list.h |  9 ++--
> > > >  arch/riscv/kernel/cpufeature.c       | 63 ++++--------------------=
----
> > > >  2 files changed, 11 insertions(+), 61 deletions(-)
> > >=20
> > > hmmm ... I do see a somewhat big caveat for this.
> > > and would like to take back my Reviewed-by for now
> > >=20
> > >=20
> > > With this change we would limit the patchable cpufeatures to actual
> > > riscv extensions. But cpufeatures can also be soft features like
> > > how performant the core handles unaligned accesses.
> >=20
> > I agree that this needs to be addressed and Jisheng also raised this
> > yesterday here [*]. It seems we need the concept of cpufeatures, which
> > may be extensions or non-extensions.
> >=20
> > [*] https://lore.kernel.org/all/Y77xyNPNqnFQUqAx@xhacker/
> >=20
> > > See Palmer's series [0].
> > >=20
> > >=20
> > > Also this essentially codifies that each ALTERNATIVE can only ever
> > > be attached to exactly one extension.
> > >=20
> > > But contrary to vendor-errata, it is very likely that we will need
> > > combinations of different extensions for some alternatives in the fut=
ure.
> >=20
> > One possible approach may be to combine extensions/non-extensions at bo=
ot
> > time into pseudo-cpufeatures. Then, alternatives can continue attaching=
 to
> > a single "feature". (I'm not saying that's a better approach than the
> > bitmap, I'm just suggesting it as something else to consider.)
>=20
>=20
> > >         ALTERNATIVE_2("nop",
> > >                       "j strcmp_zbb_unaligned", 0, CPUFEATURE_ZBB | C=
PUFEATURE_FAST_UNALIGNED, 0, CONFIG_RISCV_ISA_ZBB,
> > >                       "j variant_zbb", 0, CPUFEATURE_ZBB, CPUFEATURE_=
FAST_UNALIGNED, CONFIG_RISCV_ISA_ZBB)
> > >=20
> > > [the additional field there models a "not" component]
>=20
> Since we're discussing theoretical implementations, and it's a little hard
> to picture all that they entail in my head, I might be making a fool of
> myself here with assumptions...
>=20
> Heiko's suggestion sounded along the lines of: keep probing individual
> "features" as we are now. Features in this case being the presence of
> the extension or non-extension capability. And then in the alternative,
> make all of the decisions about which to apply.
>=20
> Drew's suggestion would have significantly more defined CPUFEATURE_FOOs,
> but would offload the decision making about which extensions or non-
> extension capabilities constitute a feature to regular old cpufeature
> code. However, the order of precedence would remain in the alt macro, as
> it does now.
>=20
> I think I am just a wee bit biased, but adding the complexity somewhere
> other than alternative macros seems a wise choice, especially as we are
> likely to find that complexity increases over time?
>=20
> The other thing that came to mind, and maybe this is just looking for
> holes where they don't exist (or are not worth addressing), is that
> order of precedence.
> I can imagine that, in some cases, the order of precedence is not a
> constant per psuedo-cpufeature, but determined by implementation of
> the capabilities that comprise it?

Having spent longer than I maybe should've looking at your patches
Heiko, given it's a Saturday evening, the precedence stuff is still
sticking out to me..

For Zbb & fast unaligned, the order may be non-controversial, but in
the general case I don't see how it can be true that the order of
precedence for variants is a constant.

Creating pseudo cpufeatures as Drew suggested does seem like a way to
extract complexity from the alternatives themselves (which I think is a
good thing) but at the expense of eating up cpu_req_feature bits...
By itself, it doesn't help with precedence, but it may better allow us
to deal with some of the precedence in cpufeature.c, since the
alternative would operate based on the pseudo cpufeature rather than on
the individual capabilities that the pseudo cpufeature depends on.

I tried to come up with a suggestion for what to do about precedence,
but everything I thought up felt a bit horrific tbh.
The thing that fits the current model best is just allowing cpu vendors
to add, yet more, "errata" that pick the variant that works best for
their implementation... Although I'd be worried about ballooning some of
these ALT_FOO macros out to a massive degree with that sort of approach.

> If my assumption/understanding holds, moving decision making out of the
> alternative seems like it would better provision for scenarios like
> that? I dunno, maybe that is whatever the corollary of "premature
> optimisation" is for this discussion.
>=20
> That's my unsolicited =E2=82=AC 0.02, hopefully I wasn't off-base with the
> assumptions I made.

The order in which an alternative is added to the macro does matter,
right? At least, that's how I thought it worked and hope I've not had
an incorrect interpretation there all along... I wasn't until I started
reading your patch and couldn't understand why you had a construct that
looked like

if (zbb && !fast_unaligned)
=2E..
else if (zbb && fast_unaligned)
=2E..

rather than just inverting the order and dropping the !fast_unaligned
that I realised I might have a gap in my understanding after all..

> Heiko, I figure you've got some sort of WIP stuff for this anyway since
> you're interested in the fast unaligned? How close are you to posting any
> of that?
>=20
> While I think of it, w.r.t. extension versus (pseudo)cpufeature etc
> naming, it may make sense to call the functions that this series adds
> in patch 6 has_cpufeature_{un,}likely(), no matter what decision gets
> made here?
> IMO using cpufeature seems to make more sense for a general use API that
> may be used later on for the likes of unaligned access, even if
> initially it is not used for anything other than extensions.


--EFHGJ8DlNAqr/5NN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY8MRZQAKCRB4tDGHoIJi
0vudAQC31tiRjpcm56PHIfs6Gzs96iGhXmnQpnSLSDyU1//0OAD/ZEgoRPzZTxTs
ypTdSCOrUmPymftzpD1JpKKAJ0Cafwc=
=HM7X
-----END PGP SIGNATURE-----

--EFHGJ8DlNAqr/5NN--
