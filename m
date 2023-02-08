Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6166768F178
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 15:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjBHO5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 09:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjBHO5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 09:57:37 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC252CFED
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 06:57:35 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id az37so9785233vkb.2
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 06:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n7QxMA3i9bgZJZ+oMzvqB6JRhnnMyffk93w9MzF+qCU=;
        b=LKEmWBKZHu489+F66u16PWE5jVUYmG48LKEeNsdNae8/i1HKk6jUQpAazytEsUcVeU
         Rt5s9Hk+QpdKj9bYnA9t3GfYEV6Qd+EdQqUPwmte9hWPhu4WTvLTVfTLiTKJjbroleR8
         hK/DAh/LbCet96JhIy6oeCU6RQ4XWCO3PZ8aDY+16uZl9Ne0VYu2fxNPBAlGLUzVc/0C
         oJRwwFRAcrahaBxYgjss/Py8YeYNAvbmUi9VD20FrBHnIuiC76I7XJxBTz7gES9ERbil
         WiLzzg1vXAjwuRurG175FyScyBRx6cDYbK+2Ap988FnN/pz43hzXXyUKzndia0Px4oOL
         grqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n7QxMA3i9bgZJZ+oMzvqB6JRhnnMyffk93w9MzF+qCU=;
        b=EVU0MU+/XKp38Hirs+bx2WZXY4Q+/h0HT8TagxHqCIjl/bAPbZT9W2I+8sAXdd/aEY
         hc5rU8bFLP+XDg4GhlY65oQOIRjWm5KwbjWJfBkoxfkPbJE5h5lxB8y/dY0cfbpCeO3M
         nVIE+G1OjYtMp3ZmjfqMkXvrrolnORGSzAG5BfWNqcP4jiRHaJHnmwQlaaY+9tZJrEuQ
         duTFY2Aats2ekF9w/Jc7Pr8xA+U9raT3W8eW1znLWtYYGL0sZSoFiGG1rw/dpjFDuAie
         nEbSZdSwibaozTyBVt+PEveBwXcLraLrwI5xscXkd0qKUVRh3DE363Z1+Lt1BT74sw49
         GbRw==
X-Gm-Message-State: AO0yUKWpMgi9Z5aiQlYkZIE5fYVs01gs5HYZH+ToJpdI0VvWQf6q96sy
        V/jykUdvkXShxk7d/1JcNEiMlG3ffmRw1Df5YHBcVw==
X-Google-Smtp-Source: AK7set9melkDIey3Gt8gvBOxcDfPbVV+CVZgawl+k+kLgw/MNmbRDjOO86uN/cfafHUilzkIJaKParA7LQ19o7e1oFs=
X-Received: by 2002:a1f:a3d7:0:b0:3ea:27b8:42c with SMTP id
 m206-20020a1fa3d7000000b003ea27b8042cmr1934475vke.34.1675868254352; Wed, 08
 Feb 2023 06:57:34 -0800 (PST)
MIME-Version: 1.0
References: <20230128072737.2995881-3-apatel@ventanamicro.com>
 <mhng-0f9bdf58-5289-4db4-8fd7-38898824c44f@palmer-ri-x1c9>
 <CAK9=C2X8C4yswGhDwe1OzQXTELXQxp8=ayiFxh1aVMk4TxeDjw@mail.gmail.com>
 <Y+KS16ZNXrDU+xun@spud> <CAOnJCUKKRRCrKN17ytczYXVLTcMkFaZsg6QXKjPUuSk=PqL6JQ@mail.gmail.com>
 <Y+K3FyGrNUQJZao8@spud> <CAK9=C2VnkK5GNO4D1AWpiNcTE=OrSueN9NAyhR7rj9csuUi4Mg@mail.gmail.com>
 <Y+OcId2PZ0pi5T08@wendy>
In-Reply-To: <Y+OcId2PZ0pi5T08@wendy>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Wed, 8 Feb 2023 20:27:23 +0530
Message-ID: <CAK9=C2VeyJMHocZMQTZoULveAcH0kdH2vBKZYFt5kq9dMYP_Bw@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] RISC-V: Detect AIA CSRs from ISA string
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     Conor Dooley <conor@kernel.org>,
        Atish Patra <atishp@atishpatra.org>,
        Stephano Cetola <stephano@riscv.org>,
        Jeff Scheel <jeff@riscv.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, pbonzini@redhat.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        ajones@ventanamicro.com, anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 8, 2023 at 6:27 PM Conor Dooley <conor.dooley@microchip.com> wrote:
>
> Hey Anup!
>
> On Wed, Feb 08, 2023 at 09:24:28AM +0530, Anup Patel wrote:
> > On Wed, Feb 8, 2023 at 2:09 AM Conor Dooley <conor@kernel.org> wrote:
> > > On Tue, Feb 07, 2023 at 10:15:22AM -0800, Atish Patra wrote:
> > > > On Tue, Feb 7, 2023 at 10:05 AM Conor Dooley <conor@kernel.org> wrote:
> > > > > On Fri, Feb 03, 2023 at 05:31:01PM +0530, Anup Patel wrote:
> > > > > > On Fri, Feb 3, 2023 at 5:54 AM Palmer Dabbelt <palmer@dabbelt.com> wrote:
> > > > > > >
> > > > > > > On Fri, 27 Jan 2023 23:27:32 PST (-0800), apatel@ventanamicro.com wrote:
> > > > > > > > We have two extension names for AIA ISA support: Smaia (M-mode AIA CSRs)
> > > > > > > > and Ssaia (S-mode AIA CSRs).
> > > > > > >
> > > > > > > This has pretty much the same problem that we had with the other
> > > > > > > AIA-related ISA string patches, where there's that ambiguity with the
> > > > > > > non-ratified chapters.  IIRC when this came up in GCC the rough idea was
> > > > > > > to try and document that we're going to interpret the standard ISA
> > > > > > > strings that way, but now that we're doing custom ISA extensions it
> > > > > > > seems saner to just define on here that removes the ambiguity.
> > > > > > >
> > > > > > > I just sent
> > > > > > > <https://lore.kernel.org/r/20230203001201.14770-1-palmer@rivosinc.com/>
> > > > > > > which documents that.
> > > > > >
> > > > > > I am not sure why you say that these are custom extensions.
> > > > > >
> > > > > > Multiple folks have clarified that both Smaia and Ssaia are frozen
> > > > > > ISA extensions as-per RVI process. The individual chapters which
> > > > > > are in the draft state have nothing to do with Smaia and Ssaia CSRs.
> > > > > >
> > > > > > Please refer:
> > > > > > https://github.com/riscv/riscv-aia/pull/36
> > > > > > https://lists.riscv.org/g/tech-aia/message/336
> > > > > > https://lists.riscv.org/g/tech-aia/message/337
> > > > >
> > > > > All of these links seem to discuss the draft chapters somehow being
> > > > > incompatible with the non-draft ones. I would very expect that that,
> > > > > as pointed out in several places there, that the draft chapters
> > > > > finalisation would not lead to meaningful (and incompatible!) changes
> > > > > being made to the non-draft chapters.
> > > > >
> > > >
> > > > Here is the status of all RVI specs. It states that the Smaia, Ssaia
> > > > extensions are frozen (i.e. public review complete).
> > > > https://wiki.riscv.org/display/HOME/Specification+Status
> > > >
> > > > I have added stephano/Jeff to confirm the same.
> > > >
> > > > AFAIK, IOMMU spec is close to the public review phase and should be
> > > > frozen in this or next quarter.
> > > > IIRC, this chapter in AIA will be frozen along with IOMMU spec.
> > > >
> > > > Anup: Please correct me if that's not correct.
> > > >
> > > > > Maybe yourself and Palmer are looking at this from different
> > > > > perspectives? Looking at his patch from Friday:
> > > > > https://lore.kernel.org/linux-riscv/20230203001201.14770-1-palmer@rivosinc.com/
> > > > > He specifically mentioned this aspect, as opposed to the aspect that
> > > > > your links refer to.
> > > > >
> > > > > Surely a duo-plic, if that ever comes to be, could be detected from
> > > > > compatible strings in DT or w/e - but how do you intend differentiating
> > > > > between an implementation of S*aia that contains the IOMMU support in
> > > > > Chapter 9 in a finalised form, versus an implementation that may make
> > > > > "different decisions" when it comes to that chapter of the spec?
> > > >
> > > > We will most likely have an extension specific to iommu spec as well.
> > >
> > > Right, but unless I am misunderstanding you, that is an extension for the
> > > IOMMU spec, not for Chapter 9 of the AIA spec?
> > >
> > > I would say that it is likely that if you have AIA and IOMMU that you'd
> > > want to be implementing Chapter 9, but that would not appear sufficient to
> > > draw a conclusion from.
> > >
> > > Maybe the RVI lads that you've added (or Anup for that matter!) can
> > > clarify if there is a requirement that if you do AIA and IOMMU that you
> > > must do Chapter 9.
> > > If not, my prior question about a differentiation mechanism still applies
> > > I think!
> >
> > For the benefit of everyone, the AIA spec mainly defines three
> > modular components:
> > 1) Extended Local Interrupt CSRs (Smaia and Ssaia extensions)
> >     (ISA extension covered by: Chapter 2, Chapter 6, and Chapter 7)
> > 2) Incoming MSI Controller (IMSIC)
> >     (ISA and Non-ISA extension covered by: Chapter 3 and Chapter 8)
> > 3) Advanced PLIC (APLIC)
> >     (Non-ISA extension covered by: Chapter 4)
> >
> > Apart from above, we have Chapter 5 ("Duo-PLIC") and Chapter 9
> > ("IOMMU Support for MSIs to Virtual Machines") which are in draft
> > state.
> >
> > Currently, there are no RISC-V members who have expressed
> > interest in implementing Chapter 5 ("Duo-PLIC") so this chapter
> > will stay in draft state for a foreseeable future.
>
> Thanks for the clarifications :)
>
> > The Chapter 9 ("IOMMU Support for MSIs to Virtual Machines")
> > defines an optional feature of IOMMU which can be implemented
> > by a standard IOMMU (such as RISC-V IOMMU) or a vendor specific
> > IOMMU. A RISC-V platform can certainly support device pass-through
> > using IMSIC guest files and an IOMMU which does not implement
> > Chapter 9. Unfortunately, there is a limit on the maximum number
> > of per-HART IMSIC guest files which can further limit the number
> > of pass-through devices. The Chapter 9 allows RISC-V platforms
> > to support large number of pass-through devices by defining "MRIF
> > - memory resident interrupt files" for an IOMMU. Further, the MRIFs
> > defined by Chapter 9 are simply interrupt files located in main memory
> > and have nothing to do with AIA local interrupt CSRs (Smaia and Ssaia).
> >
> > The presence of S*aia in ISA string only implies that AIA extended
> > local interrupt CSRs are implemented by the underlying RISC-V
> > implementation.
>
> Would you mind linking to where this is documented & explaining in your
> commit message why it is okay operate on the basis of s*aia in the ISA
> string only mandates the presence of the CSRs and nothing more.
>
> I think when I was reading it last night, I saw some commentary in this
> vein in Section 1.6 of the rc2 spec. Although IIRC it noted changes in
> interrupt behaviour there too, so I'm not sure if that section is what you
> are referring to here.
>
> Perhaps this is all just a good argument for providing more information
> in commit messages ;)

Sure, I am anyway going to send v3 after rebase so I will cite the
Section 1.6 of AIA spec in the commit description.

>
> > I confirm that it is certainly not mandatory for a RISC-V platform to
> > implement Chapter 9 of the AIA specification if the RISC-V platform
> > already implements AIA and IOMMU.
>
> Cool, thanks.
> By what mechanism, since you say that "s*aia" in the ISA string only
> implies presence of the CSRs [sic], are we meant to discover the
> presence of Chapter 9?
> A property of the IOMMU node seems the most logical I suppose, or
> perhaps inferred from the presence/config of other properties of said
> node?

The discovery of AIA Chapter 9 features is IOMMU specific.

The upcoming RISC-V IOMMU spec defines "capabilities" MMIO register
which has read-only bits MSI_MRIF and MSI_FLAT for discovering features
defined in AIA Chapter 9. Due to this dependency, the AIA Chapter 9 is
going to be ratified along with RISC-V IOMMU ratification.

>
> > > > > I thought that would be handled by extension versions, but I am told
> > > > > that those are not a thing any more.
> > > > > If that's not true, and there'll be a version number that we can pull in
> > > > > from a DT and parse which will distinguish between the two, then please
> > > > > correct my misunderstanding here!
>
> Thanks again Anup,
> Conor.
>

Regards,
Anup
