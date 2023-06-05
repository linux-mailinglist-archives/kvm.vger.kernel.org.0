Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3AD722799
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbjFENgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbjFENer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:34:47 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5008CE6
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 06:34:39 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-565ee3d14c2so53261037b3.2
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 06:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1685972078; x=1688564078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61/hRwwDiVfwBZI92q2cZ8+24tNEQi99T5NZsq9+Ezo=;
        b=OCulsvhZDKk6hcSm39Xm5mdOYLw5QtoBiY2N5zPCYBumKKGN4S8Ww6IqmD3fBZek+f
         Ts3eiOHTzSgxueQUl47yeKgmG6Yndv/T6wwTbXyHoH1GL/3Cu490XA3REXOky4wYwr0P
         PQaWSE6Qaxpn7B6GYrP2MhbPJIr9S46+Umd+AqOr41Q6vTAChJ5kQpg6rjgBwBt/NsjE
         f/7RfGk2zBx7neRp3yrP2PBW7VagKD3yWTULqB00wPnt1yUjZ4D4IQi+jdbP5A68EEWQ
         p+0MPeluVxxwTwv2p1/NnRuBuzNjQglUQDyP4o8WvUk0XvjskyE8zDlpkuoCaxxUboy7
         QNGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685972078; x=1688564078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61/hRwwDiVfwBZI92q2cZ8+24tNEQi99T5NZsq9+Ezo=;
        b=LpSqH8KJdPXQZb77hvJU9KqOqV72QCTVT1Q1/Zx93I/rGeEhbp2NF1ok30GmD/6Pb+
         TYUu3c83aYiWacr3touIxVE7xhmzc8jfx4dDUSiCbYSEsTgKsyajDYy8gE1RN0s7kYwN
         YOvKwMdwKRnqr7Cpz+y/sviLO2w7r1CCPyNa/8IwneVhluNwfY8EjrojsHWVs7XOW9/B
         Qj15o0X3LW3C6q3rf8vJu/zSW0aq1TOKbSN5zqGdP2aPqEUWAOQbI8/GCdn6stWxoP1q
         onQDcxi17q6D9zOI3xb2Jg9si4B4lTxEGOqNaoefzQ30rFYtlNKWI601iJwfFrl9bBr7
         wAAA==
X-Gm-Message-State: AC+VfDycKyHOfmd2TCfWZwFXGiREf96liODGUA91sw4HZ/YFFcgJPjvH
        BwUUB0sJ628teUM0d5qi7RrRUukY6YdCiMpnPuQ0bQ==
X-Google-Smtp-Source: ACHHUZ7sX6DmU1vMLTN1BNL4dYMpNke3/qdY0fr9LGgBIeURfHdExanL2J4IVzIfVy+F2ZF9uaoL51TVeinWT7O5s8E=
X-Received: by 2002:a81:69d5:0:b0:561:b595:100e with SMTP id
 e204-20020a8169d5000000b00561b595100emr9573851ywc.37.1685972078307; Mon, 05
 Jun 2023 06:34:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230510083748.1056704-1-apatel@ventanamicro.com>
 <20230510083748.1056704-2-apatel@ventanamicro.com> <20230605121221.GA20843@willie-the-truck>
In-Reply-To: <20230605121221.GA20843@willie-the-truck>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Mon, 5 Jun 2023 19:04:27 +0530
Message-ID: <CAK9=C2WfNSsW-OODnNVrrxq9YvxBqjT94tWp81pBiKj5e-jjVQ@mail.gmail.com>
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

Hi Will,

On Mon, Jun 5, 2023 at 5:42=E2=80=AFPM Will Deacon <will@kernel.org> wrote:
>
> On Wed, May 10, 2023 at 02:07:41PM +0530, Anup Patel wrote:
> > We sync-up Linux headers to get latest KVM RISC-V headers having
> > SBI extension enable/disable, Zbb, Zicboz, and Ssaia support.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  arm/aarch64/include/asm/kvm.h |  38 ++++++++++++
> >  include/linux/kvm.h           |  57 +++++++++++-------
> >  include/linux/virtio_blk.h    | 105 ++++++++++++++++++++++++++++++++++
> >  include/linux/virtio_config.h |   6 ++
> >  include/linux/virtio_net.h    |   5 ++
> >  riscv/include/asm/kvm.h       |  56 +++++++++++++++++-
> >  x86/include/asm/kvm.h         |  50 ++++++++++++----
> >  7 files changed, 286 insertions(+), 31 deletions(-)
>
> This breaks the build for x86:
>
> Makefile:386: Skipping optional libraries: vncserver SDL
>   CC       builtin-balloon.o
> In file included from include/linux/kvm.h:15,
>                  from include/kvm/pci.h:5,
>                  from include/kvm/vfio.h:6,
>                  from include/kvm/kvm-config.h:5,
>                  from include/kvm/kvm.h:6,
>                  from builtin-balloon.c:9:
> x86/include/asm/kvm.h:511:17: error: expected specifier-qualifier-list be=
fore =E2=80=98__DECLARE_FLEX_ARRAY=E2=80=99
>   511 |                 __DECLARE_FLEX_ARRAY(struct kvm_vmx_nested_state_=
data, vmx);
>       |                 ^~~~~~~~~~~~~~~~~~~~
> make: *** [Makefile:508: builtin-balloon.o] Error 1

It seems __DECLARE_FLEX_ARRAY() is not defined in
include/linux/stddef.h header of KVMTOOL.

I will send v2 series with this fixed.

Thanks,
Anup
