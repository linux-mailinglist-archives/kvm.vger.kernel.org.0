Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1016FCAB6
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 18:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbjEIQEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 12:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbjEIQEb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 12:04:31 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC98249EC
        for <kvm@vger.kernel.org>; Tue,  9 May 2023 09:04:25 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4ec8eca56cfso6807708e87.0
        for <kvm@vger.kernel.org>; Tue, 09 May 2023 09:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1683648264; x=1686240264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P5eI2yzNCfdr9SsLOpnjF/NfxrXE0SJgMXU078Kgt/I=;
        b=J0pEnRua2uyGW9LomKvzRZcRaZoMbGkoXEwVtzd/6euViySYeB9iFTNBXV0uuWPBCF
         vskxrrYyS2phpkjiJ3gMDe8j3zdvUHtszIbazvGuWdXKPVUwdCqGTa2Q0oISrb5rpFfJ
         Y2j62+v2Rq4VqYRg1FyQR1cUC0pddLk3LLrKMtHVNlQxuOj5XazbiUO6YlyY3H9CJdyK
         m7hlbAHkWcpLNeMxhjfWVu57Me7r6PHsVoqxz7eNR2V3NwYPCnIbYTijf3lHNMwdq88V
         d5K9nZ/mvV1e3rFmF5FH+AnPmxpc3CGPYodVaD2g6jeGiQNgB6Rmz4P7Jelmn6aohkHG
         Hg3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683648264; x=1686240264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P5eI2yzNCfdr9SsLOpnjF/NfxrXE0SJgMXU078Kgt/I=;
        b=LPrveSe6S3icKx7ZIsQxVVmWiXCPviW0i1H1plzICdIUaEGuf505xw2A0ObUZvIRLj
         pcF6TFPMVpNWYUia0sSg+zCZKlvpatKGI4niDwmqqsNXPRFSN4+EPkqsGmbzjCGgIcds
         D31HvB4rwmzFDZX6y+Xizp38W46JN342BBPh0ZK0UrqnTzGY+3fx2G0A97VSjJla2ZDx
         PSOxKB+l/OwF+nYD4iwPLueE00NvC8NY6JpGlLjDqLKN37c4/Zm7RWgcBlWk57v4jYUB
         OUzmc1WtugYkN3/g4QBVcPo+lnNwoMsXy7Siwwo6ADrlSNbimC8zpUlJ0acuIt/EkZi5
         l4lQ==
X-Gm-Message-State: AC+VfDyJFQhilZjcNwnCbXDeCvFhg/YW2Z8Rh1O/4N8Cz0h3NYZtYSSH
        Ml7mRaKTnSkTT4FflqO4+j9cAdFIQX1eK8azSYgcsA==
X-Google-Smtp-Source: ACHHUZ5ny9OYUO8ttAEKM8lx+rDZbiwo4O5HMSbiqxwuUjYxEq/NRzUx+9FkFZuIuyZAI6xXQ2pLEnMwlpjaOWp2y2s=
X-Received: by 2002:ac2:593a:0:b0:4eb:44c2:ab6c with SMTP id
 v26-20020ac2593a000000b004eb44c2ab6cmr845205lfi.2.1683648263872; Tue, 09 May
 2023 09:04:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230509103033.11285-1-andy.chiu@sifive.com> <20230509103033.11285-24-andy.chiu@sifive.com>
 <20230509-resilient-lagoon-265e851e5bf8@wendy>
In-Reply-To: <20230509-resilient-lagoon-265e851e5bf8@wendy>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Wed, 10 May 2023 00:04:12 +0800
Message-ID: <CABgGipXvVw8GWeVLTuTJT9Hus-pEPUcgRhO3oovKYOAZK3fAEg@mail.gmail.com>
Subject: Re: [PATCH -next v19 23/24] riscv: Enable Vector code to be built
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 9, 2023 at 8:35=E2=80=AFPM Conor Dooley <conor.dooley@microchip=
.com> wrote:
>
> Hey Andy,
>
> On Tue, May 09, 2023 at 10:30:32AM +0000, Andy Chiu wrote:
> > From: Guo Ren <guoren@linux.alibaba.com>
> >
> > This patch adds a config which enables vector feature from the kernel
> > space.
>
> This commit message probably needs to change, it's not exactly doing
> that anymore!

Yes, I totally missed that part. I will get commit messages updated
when it's time for the next revision.

>
> > Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> > Co-developed-by: Greentime Hu <greentime.hu@sifive.com>
> > Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
>
> > Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
> > Suggested-by: Atish Patra <atishp@atishpatra.org>
>
> And I suspect that these two are also likely inaccurate at this point,
> but IDC.

Agree. I am going to drop these.

>
> > Co-developed-by: Andy Chiu <andy.chiu@sifive.com>
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > ---
> > Changelog V19:
> >  - Add RISCV_V_DISABLE to set compile-time default.
> >
> >  arch/riscv/Kconfig  | 31 +++++++++++++++++++++++++++++++
> >  arch/riscv/Makefile |  6 +++++-
> >  2 files changed, 36 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > index 1019b519d590..fa256f2e23c1 100644
> > --- a/arch/riscv/Kconfig
> > +++ b/arch/riscv/Kconfig
> > @@ -466,6 +466,37 @@ config RISCV_ISA_SVPBMT
> >
> >          If you don't know what to do here, say Y.
> >
> > +config TOOLCHAIN_HAS_V
> > +     bool
> > +     default y
> > +     depends on !64BIT || $(cc-option,-mabi=3Dlp64 -march=3Drv64iv)
> > +     depends on !32BIT || $(cc-option,-mabi=3Dilp32 -march=3Drv32iv)
> > +     depends on LLD_VERSION >=3D 140000 || LD_VERSION >=3D 23800
> > +     depends on AS_HAS_OPTION_ARCH
> > +
> > +config RISCV_ISA_V
> > +     bool "VECTOR extension support"
> > +     depends on TOOLCHAIN_HAS_V
> > +     depends on FPU
> > +     select DYNAMIC_SIGFRAME
> > +     default y
> > +     help
> > +       Say N here if you want to disable all vector related procedure
> > +       in the kernel.
> > +
> > +       If you don't know what to do here, say Y.
> > +
> > +config RISCV_V_DISABLE
> > +     bool "Disable userspace Vector by default"
> > +     depends on RISCV_ISA_V
> > +     default n
> > +     help
> > +       Say Y here if you want to disable default enablement state of V=
ector
> > +       in u-mode. This way userspace has to make explicit prctl() call=
 to
> > +       enable Vector, or enable it via sysctl interface.
>
> If we are worried about breaking userspace, why is the default for this
> option not y? Or further,
>
> config RISCV_ISA_V_DEFAULT_ENABLE
>         bool "Enable userspace Vector by default"
>         depends on RISCV_ISA_V
>         help
>           Say Y here to allow use of Vector in userspace by default.
>           Otherwise, userspace has to make an explicit prctl() call to
>           enable Vector, or enable it via the sysctl interface.
>
>           If you don't know what to do here, say N.
>

Yes, expressing the option, where Y means "on", is more direct. But I
have a little concern if we make the default as "off". Yes, we create
this option in the worries of breaking userspace. But given that the
break case might be rare, is it worth making userspace Vector harder
to use by doing this? I assume in an ideal world that nothing would
break and programs could just use V without bothering with prctl(), or
sysctl. But on the other hand, to make a program robust enough, we
must check the status with the prctl() anyway. So I have no answer
here.

> Thanks,
> Conor.
