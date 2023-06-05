Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537F9722836
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 16:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbjFEOHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 10:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbjFEOH1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 10:07:27 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84418E51
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 07:07:04 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-565a6837a0bso53725797b3.3
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 07:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1685974023; x=1688566023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=22URbF900EBd4icpqPzx3Q5fCps0hcQuXxW2iJbAl4c=;
        b=W/mRSqfJctGPWaId4D6Y6/E2gyd+EQQdG0jI5tOxk00x7tcpnlaoZ+k6bLEM1hvo3o
         Km+ysnriKJopRLz9K2d4jLJCIX7QZDxg2yk0loJl2VIVD5cnJdxRzxhclXU4NZ1WT8rm
         GwlfnaXbDZa/T48d/ljBugcAQbZpJdupLJe3wXs5XADMT62oC6Pg5iVxtH0BRhhXfvKT
         ON+4AIclq8VoE+0I3XTdV8W7OSGNrqnmIh6oTUh2TjTftLX30muPrX57uAJ9Zejm/QcD
         fzm+Ry9uIBq0xN9BidJMSme3dYnH5sjolAfzGDyjLCokkImeTL6LgB9efqxTTf90nDsB
         lMKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685974023; x=1688566023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=22URbF900EBd4icpqPzx3Q5fCps0hcQuXxW2iJbAl4c=;
        b=WFGztnskmCl61baoUz4j79hfxA9sFbbeouCa/FPJKkzPnCpQxjeznfp/gWUjZpPZ6j
         XxrWmr+fGlknbvmRmQsd/mQ6UuCnDHYTX5++IE/lWxP/Cb8e4UYbiIzWA1SBViKMVuwT
         ff7eeDLrSUwYaFKWRBty1ygkWBirpZMNhq01esGO0DqqNmf3E5oAL8ZSJlKJGIQ45Nr2
         LdMviCwBzXioq86kjUZ8Q1qpsvlK65LZ8owzOP8ZjMISARF9HPZhwUgUDdPuDtGDFKgB
         Nql28X/EOfVxCG4rf/OOLaAHDPFng05sAMQCO3cM/TwlSaA1KZtvgxW3wlceTgZyQNsh
         d8kA==
X-Gm-Message-State: AC+VfDyKJT/vG3XLAaOwnoz0bBVtONx9vHmeteYPGDzKcapyQLwXiMNb
        4ibjD1lNInV5PJPsRzS1PgkInxqOCq0n2Iw56CCnrQ==
X-Google-Smtp-Source: ACHHUZ4+yWZUP1bmbjIaklr8eQbioKSYJIvRVs7VOTy6ZFuFIq8RstzWeV8Rj8CITOGwCcP1AepesLBgFnaTTxuPid0=
X-Received: by 2002:a81:92cc:0:b0:565:d3f9:209e with SMTP id
 j195-20020a8192cc000000b00565d3f9209emr9414177ywg.34.1685974023316; Mon, 05
 Jun 2023 07:07:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230510083748.1056704-1-apatel@ventanamicro.com>
 <20230510083748.1056704-2-apatel@ventanamicro.com> <20230605121221.GA20843@willie-the-truck>
 <CAK9=C2WfNSsW-OODnNVrrxq9YvxBqjT94tWp81pBiKj5e-jjVQ@mail.gmail.com> <20230605134938.GA21212@willie-the-truck>
In-Reply-To: <20230605134938.GA21212@willie-the-truck>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Mon, 5 Jun 2023 19:36:52 +0530
Message-ID: <CAK9=C2VtB+usAivCiQFi37y=aRxwJpFRwSKk7Z=f1tY4LV4d+g@mail.gmail.com>
Subject: Re: [PATCH kvmtool 1/8] Sync-up headers with Linux-6.4-rc1
To:     Will Deacon <will@kernel.org>
Cc:     julien.thierry.kdev@gmail.com, maz@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 5, 2023 at 7:19=E2=80=AFPM Will Deacon <will@kernel.org> wrote:
>
> On Mon, Jun 05, 2023 at 07:04:27PM +0530, Anup Patel wrote:
> > On Mon, Jun 5, 2023 at 5:42=E2=80=AFPM Will Deacon <will@kernel.org> wr=
ote:
> > > On Wed, May 10, 2023 at 02:07:41PM +0530, Anup Patel wrote:
> > > > We sync-up Linux headers to get latest KVM RISC-V headers having
> > > > SBI extension enable/disable, Zbb, Zicboz, and Ssaia support.
> > > >
> > > > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > > > ---
> > > >  arm/aarch64/include/asm/kvm.h |  38 ++++++++++++
> > > >  include/linux/kvm.h           |  57 +++++++++++-------
> > > >  include/linux/virtio_blk.h    | 105 ++++++++++++++++++++++++++++++=
++++
> > > >  include/linux/virtio_config.h |   6 ++
> > > >  include/linux/virtio_net.h    |   5 ++
> > > >  riscv/include/asm/kvm.h       |  56 +++++++++++++++++-
> > > >  x86/include/asm/kvm.h         |  50 ++++++++++++----
> > > >  7 files changed, 286 insertions(+), 31 deletions(-)
> > >
> > > This breaks the build for x86:
> > >
> > > Makefile:386: Skipping optional libraries: vncserver SDL
> > >   CC       builtin-balloon.o
> > > In file included from include/linux/kvm.h:15,
> > >                  from include/kvm/pci.h:5,
> > >                  from include/kvm/vfio.h:6,
> > >                  from include/kvm/kvm-config.h:5,
> > >                  from include/kvm/kvm.h:6,
> > >                  from builtin-balloon.c:9:
> > > x86/include/asm/kvm.h:511:17: error: expected specifier-qualifier-lis=
t before =E2=80=98__DECLARE_FLEX_ARRAY=E2=80=99
> > >   511 |                 __DECLARE_FLEX_ARRAY(struct kvm_vmx_nested_st=
ate_data, vmx);
> > >       |                 ^~~~~~~~~~~~~~~~~~~~
> > > make: *** [Makefile:508: builtin-balloon.o] Error 1
> >
> > It seems __DECLARE_FLEX_ARRAY() is not defined in
> > include/linux/stddef.h header of KVMTOOL.
> >
> > I will send v2 series with this fixed.
>
> Alternatively, you could take a look at the series from Oliver which
> also pulls in the -rc1 headers (I've not had chance to test it out yet,
> though).
>
> https://lore.kernel.org/r/20230526221712.317287-1-oliver.upton@linux.dev


I did not try this series but I think we will get x86 compile error with th=
is
series as well because this series does not add __DECLARE_FLEX_ARRAY()
define.

Regards,
Anup

>
> Will
