Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A12A669C05
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 16:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjAMP1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 10:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjAMP02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 10:26:28 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A87F8D5E4;
        Fri, 13 Jan 2023 07:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673623165; x=1705159165;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rCjPB/5T/fdzdveTe1HJ5ppssFlxiUdMulVsnKmxWDI=;
  b=pxJPkcjci67lV2RIxYJZRQEjESO9vSZZ023bEjhlYOhavg/rON8jlapv
   +R+HoSIMuzM3sC+6vX9Cc/03aYDgUBTSjFvL3uurdo44Q512QncanIrfx
   L2yTvbqS8C8sLwIpNSt/L99uTNC5ePskUe36n/EnKDKpw4EK6jZXD+Ke2
   j8Wr8B1NsW0O1pq5ohZUIvaoZQqP+9fsjZdQ31n2tBCCE3ytx6TQici7f
   6oRFkJL8C1UBgFYiD0t33xGu2WId1PwJ6gV1HGiW4AORhy3VHePX6qMvE
   0ipTyIX8QKIjM/cAGdC6rI6ZNj15+MyPkbUQ+8/Z3JVx3tofeC9+4pTDY
   A==;
X-IronPort-AV: E=Sophos;i="5.97,214,1669100400"; 
   d="asc'?scan'208";a="132230154"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2023 08:19:24 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 13 Jan 2023 08:19:24 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Fri, 13 Jan 2023 08:19:22 -0700
Date:   Fri, 13 Jan 2023 15:18:59 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Andrew Jones <ajones@ventanamicro.com>
CC:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>
Subject: Re: [PATCH v3 05/13] riscv: cpufeature: extend
 riscv_cpufeature_patch_func to all ISA extensions
Message-ID: <Y8F2YxMHUt+djhX4@wendy>
References: <20230111171027.2392-1-jszhang@kernel.org>
 <20230111171027.2392-6-jszhang@kernel.org>
 <2398293.3Lj2Plt8kZ@diego>
 <20230112092136.f2g43hrhmrqouy4y@orel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eJJr4NZdBAlir24b"
Content-Disposition: inline
In-Reply-To: <20230112092136.f2g43hrhmrqouy4y@orel>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--eJJr4NZdBAlir24b
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2023 at 10:21:36AM +0100, Andrew Jones wrote:
> On Thu, Jan 12, 2023 at 12:29:57AM +0100, Heiko St=C3=BCbner wrote:
> > Am Mittwoch, 11. Januar 2023, 18:10:19 CET schrieb Jisheng Zhang:
> > > riscv_cpufeature_patch_func() currently only scans a limited set of
> > > cpufeatures, explicitly defined with macros. Extend it to probe for a=
ll
> > > ISA extensions.
> > >=20
> > > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> > > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> > > ---
> > >  arch/riscv/include/asm/errata_list.h |  9 ++--
> > >  arch/riscv/kernel/cpufeature.c       | 63 ++++----------------------=
--
> > >  2 files changed, 11 insertions(+), 61 deletions(-)
> >=20
> > hmmm ... I do see a somewhat big caveat for this.
> > and would like to take back my Reviewed-by for now
> >=20
> >=20
> > With this change we would limit the patchable cpufeatures to actual
> > riscv extensions. But cpufeatures can also be soft features like
> > how performant the core handles unaligned accesses.
>=20
> I agree that this needs to be addressed and Jisheng also raised this
> yesterday here [*]. It seems we need the concept of cpufeatures, which
> may be extensions or non-extensions.
>=20
> [*] https://lore.kernel.org/all/Y77xyNPNqnFQUqAx@xhacker/
>=20
> > See Palmer's series [0].
> >=20
> >=20
> > Also this essentially codifies that each ALTERNATIVE can only ever
> > be attached to exactly one extension.
> >=20
> > But contrary to vendor-errata, it is very likely that we will need
> > combinations of different extensions for some alternatives in the futur=
e.
>=20
> One possible approach may be to combine extensions/non-extensions at boot
> time into pseudo-cpufeatures. Then, alternatives can continue attaching to
> a single "feature". (I'm not saying that's a better approach than the
> bitmap, I'm just suggesting it as something else to consider.)


> >         ALTERNATIVE_2("nop",
> >                       "j strcmp_zbb_unaligned", 0, CPUFEATURE_ZBB | CPU=
FEATURE_FAST_UNALIGNED, 0, CONFIG_RISCV_ISA_ZBB,
> >                       "j variant_zbb", 0, CPUFEATURE_ZBB, CPUFEATURE_FA=
ST_UNALIGNED, CONFIG_RISCV_ISA_ZBB)
> >=20
> > [the additional field there models a "not" component]

Since we're discussing theoretical implementations, and it's a little hard
to picture all that they entail in my head, I might be making a fool of
myself here with assumptions...

Heiko's suggestion sounded along the lines of: keep probing individual
"features" as we are now. Features in this case being the presence of
the extension or non-extension capability. And then in the alternative,
make all of the decisions about which to apply.

Drew's suggestion would have significantly more defined CPUFEATURE_FOOs,
but would offload the decision making about which extensions or non-
extension capabilities constitute a feature to regular old cpufeature
code. However, the order of precedence would remain in the alt macro, as
it does now.

I think I am just a wee bit biased, but adding the complexity somewhere
other than alternative macros seems a wise choice, especially as we are
likely to find that complexity increases over time?

The other thing that came to mind, and maybe this is just looking for
holes where they don't exist (or are not worth addressing), is that
order of precedence.
I can imagine that, in some cases, the order of precedence is not a
constant per psuedo-cpufeature, but determined by implementation of
the capabilities that comprise it?

If my assumption/understanding holds, moving decision making out of the
alternative seems like it would better provision for scenarios like
that? I dunno, maybe that is whatever the corollary of "premature
optimisation" is for this discussion.

That's my unsolicited =E2=82=AC 0.02, hopefully I wasn't off-base with the
assumptions I made.

Heiko, I figure you've got some sort of WIP stuff for this anyway since
you're interested in the fast unaligned? How close are you to posting any
of that?

While I think of it, w.r.t. extension versus (pseudo)cpufeature etc
naming, it may make sense to call the functions that this series adds
in patch 6 has_cpufeature_{un,}likely(), no matter what decision gets
made here?
IMO using cpufeature seems to make more sense for a general use API that
may be used later on for the likes of unaligned access, even if
initially it is not used for anything other than extensions.

Thanks,
Conor.


--eJJr4NZdBAlir24b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY8F2UAAKCRB4tDGHoIJi
0mkYAP9Ci+2UMUBqP3SY4QGQiesTmNsCfaU2nMywpEkD7pp3lwEAz2lq9OwtYfZH
DzZpfIO0gPw9wLXBt0ndw8rV6hphPQQ=
=bfSv
-----END PGP SIGNATURE-----

--eJJr4NZdBAlir24b--
