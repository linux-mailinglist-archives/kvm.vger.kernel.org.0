Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A3868EF66
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 13:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjBHM5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 07:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjBHM5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 07:57:38 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495EDB745;
        Wed,  8 Feb 2023 04:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675861054; x=1707397054;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vX03Kta9L6dqBlFyGykVGIICORcja6M/gYVsWB8u3qI=;
  b=1I5jl76Iq38W1DYl5HKLRqdoe/cbeJIwktb9mIYCbeOl8mCkkTF3puaF
   3Z4INRHiiYTWTebA46swtlMFDkRUKAYfDxjXAjAlKEgJ91ToQ4c+Fge7P
   WHaQ23wGJomX3iaFEuvDD2az065pwGkmVV8XQhuv49S35gTibnMuEG1AT
   0kC4wG7jvasjN8zHXFiJaBsODBqwUVUJh5bMVqdqeN2lnt6G56t3I0opP
   +HQyFtH2hoPcb8kpNs7T8CZebBzAX57GOGLmblbLppYPdWriGAUjBL5vc
   nRCYaRggoMJlHfPcmeG6Odvg+3Fu+etqGj/xn9i5C/TWChUeUtWESSsvK
   g==;
X-IronPort-AV: E=Sophos;i="5.97,280,1669100400"; 
   d="asc'?scan'208";a="211089574"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Feb 2023 05:57:32 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 05:57:32 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Wed, 8 Feb 2023 05:57:30 -0700
Date:   Wed, 8 Feb 2023 12:57:05 +0000
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Anup Patel <apatel@ventanamicro.com>
CC:     Conor Dooley <conor@kernel.org>,
        Atish Patra <atishp@atishpatra.org>,
        Stephano Cetola <stephano@riscv.org>,
        Jeff Scheel <jeff@riscv.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        <ajones@ventanamicro.com>, <anup@brainfault.org>,
        <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/7] RISC-V: Detect AIA CSRs from ISA string
Message-ID: <Y+OcId2PZ0pi5T08@wendy>
References: <20230128072737.2995881-3-apatel@ventanamicro.com>
 <mhng-0f9bdf58-5289-4db4-8fd7-38898824c44f@palmer-ri-x1c9>
 <CAK9=C2X8C4yswGhDwe1OzQXTELXQxp8=ayiFxh1aVMk4TxeDjw@mail.gmail.com>
 <Y+KS16ZNXrDU+xun@spud>
 <CAOnJCUKKRRCrKN17ytczYXVLTcMkFaZsg6QXKjPUuSk=PqL6JQ@mail.gmail.com>
 <Y+K3FyGrNUQJZao8@spud>
 <CAK9=C2VnkK5GNO4D1AWpiNcTE=OrSueN9NAyhR7rj9csuUi4Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xbfYQqJmC8jjdpbB"
Content-Disposition: inline
In-Reply-To: <CAK9=C2VnkK5GNO4D1AWpiNcTE=OrSueN9NAyhR7rj9csuUi4Mg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--xbfYQqJmC8jjdpbB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Anup!

On Wed, Feb 08, 2023 at 09:24:28AM +0530, Anup Patel wrote:
> On Wed, Feb 8, 2023 at 2:09 AM Conor Dooley <conor@kernel.org> wrote:
> > On Tue, Feb 07, 2023 at 10:15:22AM -0800, Atish Patra wrote:
> > > On Tue, Feb 7, 2023 at 10:05 AM Conor Dooley <conor@kernel.org> wrote:
> > > > On Fri, Feb 03, 2023 at 05:31:01PM +0530, Anup Patel wrote:
> > > > > On Fri, Feb 3, 2023 at 5:54 AM Palmer Dabbelt <palmer@dabbelt.com=
> wrote:
> > > > > >
> > > > > > On Fri, 27 Jan 2023 23:27:32 PST (-0800), apatel@ventanamicro.c=
om wrote:
> > > > > > > We have two extension names for AIA ISA support: Smaia (M-mod=
e AIA CSRs)
> > > > > > > and Ssaia (S-mode AIA CSRs).
> > > > > >
> > > > > > This has pretty much the same problem that we had with the other
> > > > > > AIA-related ISA string patches, where there's that ambiguity wi=
th the
> > > > > > non-ratified chapters.  IIRC when this came up in GCC the rough=
 idea was
> > > > > > to try and document that we're going to interpret the standard =
ISA
> > > > > > strings that way, but now that we're doing custom ISA extension=
s it
> > > > > > seems saner to just define on here that removes the ambiguity.
> > > > > >
> > > > > > I just sent
> > > > > > <https://lore.kernel.org/r/20230203001201.14770-1-palmer@rivosi=
nc.com/>
> > > > > > which documents that.
> > > > >
> > > > > I am not sure why you say that these are custom extensions.
> > > > >
> > > > > Multiple folks have clarified that both Smaia and Ssaia are frozen
> > > > > ISA extensions as-per RVI process. The individual chapters which
> > > > > are in the draft state have nothing to do with Smaia and Ssaia CS=
Rs.
> > > > >
> > > > > Please refer:
> > > > > https://github.com/riscv/riscv-aia/pull/36
> > > > > https://lists.riscv.org/g/tech-aia/message/336
> > > > > https://lists.riscv.org/g/tech-aia/message/337
> > > >
> > > > All of these links seem to discuss the draft chapters somehow being
> > > > incompatible with the non-draft ones. I would very expect that that,
> > > > as pointed out in several places there, that the draft chapters
> > > > finalisation would not lead to meaningful (and incompatible!) chang=
es
> > > > being made to the non-draft chapters.
> > > >
> > >
> > > Here is the status of all RVI specs. It states that the Smaia, Ssaia
> > > extensions are frozen (i.e. public review complete).
> > > https://wiki.riscv.org/display/HOME/Specification+Status
> > >
> > > I have added stephano/Jeff to confirm the same.
> > >
> > > AFAIK, IOMMU spec is close to the public review phase and should be
> > > frozen in this or next quarter.
> > > IIRC, this chapter in AIA will be frozen along with IOMMU spec.
> > >
> > > Anup: Please correct me if that's not correct.
> > >
> > > > Maybe yourself and Palmer are looking at this from different
> > > > perspectives? Looking at his patch from Friday:
> > > > https://lore.kernel.org/linux-riscv/20230203001201.14770-1-palmer@r=
ivosinc.com/
> > > > He specifically mentioned this aspect, as opposed to the aspect that
> > > > your links refer to.
> > > >
> > > > Surely a duo-plic, if that ever comes to be, could be detected from
> > > > compatible strings in DT or w/e - but how do you intend differentia=
ting
> > > > between an implementation of S*aia that contains the IOMMU support =
in
> > > > Chapter 9 in a finalised form, versus an implementation that may ma=
ke
> > > > "different decisions" when it comes to that chapter of the spec?
> > >
> > > We will most likely have an extension specific to iommu spec as well.
> >
> > Right, but unless I am misunderstanding you, that is an extension for t=
he
> > IOMMU spec, not for Chapter 9 of the AIA spec?
> >
> > I would say that it is likely that if you have AIA and IOMMU that you'd
> > want to be implementing Chapter 9, but that would not appear sufficient=
 to
> > draw a conclusion from.
> >
> > Maybe the RVI lads that you've added (or Anup for that matter!) can
> > clarify if there is a requirement that if you do AIA and IOMMU that you
> > must do Chapter 9.
> > If not, my prior question about a differentiation mechanism still appli=
es
> > I think!
>=20
> For the benefit of everyone, the AIA spec mainly defines three
> modular components:
> 1) Extended Local Interrupt CSRs (Smaia and Ssaia extensions)
>     (ISA extension covered by: Chapter 2, Chapter 6, and Chapter 7)
> 2) Incoming MSI Controller (IMSIC)
>     (ISA and Non-ISA extension covered by: Chapter 3 and Chapter 8)
> 3) Advanced PLIC (APLIC)
>     (Non-ISA extension covered by: Chapter 4)
>=20
> Apart from above, we have Chapter 5 ("Duo-PLIC") and Chapter 9
> ("IOMMU Support for MSIs to Virtual Machines") which are in draft
> state.
>=20
> Currently, there are no RISC-V members who have expressed
> interest in implementing Chapter 5 ("Duo-PLIC") so this chapter
> will stay in draft state for a foreseeable future.

Thanks for the clarifications :)

> The Chapter 9 ("IOMMU Support for MSIs to Virtual Machines")
> defines an optional feature of IOMMU which can be implemented
> by a standard IOMMU (such as RISC-V IOMMU) or a vendor specific
> IOMMU. A RISC-V platform can certainly support device pass-through
> using IMSIC guest files and an IOMMU which does not implement
> Chapter 9. Unfortunately, there is a limit on the maximum number
> of per-HART IMSIC guest files which can further limit the number
> of pass-through devices. The Chapter 9 allows RISC-V platforms
> to support large number of pass-through devices by defining "MRIF
> - memory resident interrupt files" for an IOMMU. Further, the MRIFs
> defined by Chapter 9 are simply interrupt files located in main memory
> and have nothing to do with AIA local interrupt CSRs (Smaia and Ssaia).
>=20
> The presence of S*aia in ISA string only implies that AIA extended
> local interrupt CSRs are implemented by the underlying RISC-V
> implementation.

Would you mind linking to where this is documented & explaining in your
commit message why it is okay operate on the basis of s*aia in the ISA
string only mandates the presence of the CSRs and nothing more.

I think when I was reading it last night, I saw some commentary in this
vein in Section 1.6 of the rc2 spec. Although IIRC it noted changes in
interrupt behaviour there too, so I'm not sure if that section is what you
are referring to here.

Perhaps this is all just a good argument for providing more information
in commit messages ;)

> I confirm that it is certainly not mandatory for a RISC-V platform to
> implement Chapter 9 of the AIA specification if the RISC-V platform
> already implements AIA and IOMMU.

Cool, thanks.
By what mechanism, since you say that "s*aia" in the ISA string only
implies presence of the CSRs [sic], are we meant to discover the
presence of Chapter 9?
A property of the IOMMU node seems the most logical I suppose, or
perhaps inferred from the presence/config of other properties of said
node?

> > > > I thought that would be handled by extension versions, but I am told
> > > > that those are not a thing any more.
> > > > If that's not true, and there'll be a version number that we can pu=
ll in
> > > > from a DT and parse which will distinguish between the two, then pl=
ease
> > > > correct my misunderstanding here!

Thanks again Anup,
Conor.


--xbfYQqJmC8jjdpbB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+OcHAAKCRB4tDGHoIJi
0sv5AP4kAApM9wzz3RBpGeRypYwcyCH8VOf6+uAbG6ZPbjmLIwEAnZnuEbEH3/lZ
LfmwTNR0OueZhoRWpzFittOpq/IGxAg=
=b8bw
-----END PGP SIGNATURE-----

--xbfYQqJmC8jjdpbB--
