Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0DB704397
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 04:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjEPCrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 22:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjEPCro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 22:47:44 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B03E5FCB
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 19:47:35 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4f13c577e36so15454167e87.1
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 19:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684205253; x=1686797253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yDLmHnpvk15EZ9t+4mD2jGDqT9ebZTM14ao6Km5+uRY=;
        b=dyF3YpJfebcxGU8xQlepQ2FyLKlhsjT6sJF7rZzkKl0P24S+FtUzSTyt2MDHZj6x6e
         Aw44soumI2lu3Y/mNDiiyEOlfPRZPnbZsJ35ZXa4trswzRaQHFcb7zi1yaifH5O7++l+
         YRi+yP7plIIX8TTdSlL9sGqzC7rGVXFZ6N2m2Y1Co7xhw7ugKDz3HuVQ2wOepXOYrhWe
         PxQOn3KG9P3ZejbT0q0LjZA2/2UDfXzBpAgPRPc95MbuuGSD4PgkMksxCeKGV7RRKuPo
         iA+7QrVHfKhdgB+R4QVGBTRfJMyEPXXjPAMIUXvcdWkW3pEdDj630nKW/4nXH4KCpGXO
         V1Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684205253; x=1686797253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yDLmHnpvk15EZ9t+4mD2jGDqT9ebZTM14ao6Km5+uRY=;
        b=PxSmTaYnpdP5g/Byivcrw8x9hL+3zTy8XvoeEpX9H/QuRqxQpRtUKK9NYZsyTnfzLK
         dgq5eCRhyPf+QV7+Tu+dLbw6mGLbf1lm6vNE8/099EF22+BSosHuB2kHtRijEeJP6dNX
         oCoxco3WPIFxCVRLTkAnOA+wGc5w6BVX+lB8xxGsvSzkg2eAoWnMMZLLxHrWJ+FTQPeW
         C/RmTZZVyfi12sm9KBhJcyJsggzfs2KFqj3d+BYisy3XVlXpMQekXQssUQ3u9U1r1L4y
         h4mD6M90ev/G8AMsrNwmq+N3lZq3JRcSu79OauOGJx6PjUqys3nO9xBgOZwzjku1CijZ
         1FTA==
X-Gm-Message-State: AC+VfDx3lRBAiH4o8zgLJ9m+BRkDYDfTn9TVaeICNHbzkpxWQ6BDjAi9
        ST5XAGdaHVBbsHbtb6/HCdS3pNmTs8VKrOMIbQkSfA==
X-Google-Smtp-Source: ACHHUZ7uHIgMczQDhqVzrXSpb/I1cUQWnTXkrh16XZmxjDNv+BBoqvsiCVI+u8uAcaYK6CVlk5ZG9Vylrez0ukFv7jg=
X-Received: by 2002:ac2:5fa5:0:b0:4d7:59e6:388e with SMTP id
 s5-20020ac25fa5000000b004d759e6388emr6063478lfe.46.1684205253535; Mon, 15 May
 2023 19:47:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230509103033.11285-2-andy.chiu@sifive.com> <mhng-b8482399-b363-402b-b095-ce1b1dc1fe71@palmer-ri-x1c9a>
In-Reply-To: <mhng-b8482399-b363-402b-b095-ce1b1dc1fe71@palmer-ri-x1c9a>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Tue, 16 May 2023 10:47:22 +0800
Message-ID: <CABgGipVS=Zww5DSQf__axMRf7DrbA3BfPyq2k5L-pXtV1nsjjw@mail.gmail.com>
Subject: Re: [PATCH -next v19 01/24] riscv: Rename __switch_to_aux() -> fpu
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        ren_guo@c-sky.com, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, heiko.stuebner@vrull.eu, guoren@kernel.org,
        Conor Dooley <conor.dooley@microchip.com>, jszhang@kernel.org
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

On Fri, May 12, 2023 at 6:56=E2=80=AFAM Palmer Dabbelt <palmer@dabbelt.com>=
 wrote:
>
> On Tue, 09 May 2023 03:30:10 PDT (-0700), andy.chiu@sifive.com wrote:
> > From: Guo Ren <ren_guo@c-sky.com>
> >
> > The name of __switch_to_aux() is not clear and rename it with the
> > determine function: __switch_to_fpu(). Next we could add other regs'
> > switch.
> >
> > Signed-off-by: Guo Ren <ren_guo@c-sky.com>
> > Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> > Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> > Reviewed-by: Anup Patel <anup@brainfault.org>
> > Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> > Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> > Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> > ---
> >  arch/riscv/include/asm/switch_to.h | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/as=
m/switch_to.h
> > index 60f8ca01d36e..4b96b13dee27 100644
> > --- a/arch/riscv/include/asm/switch_to.h
> > +++ b/arch/riscv/include/asm/switch_to.h
> > @@ -46,7 +46,7 @@ static inline void fstate_restore(struct task_struct =
*task,
> >       }
> >  }
> >
> > -static inline void __switch_to_aux(struct task_struct *prev,
> > +static inline void __switch_to_fpu(struct task_struct *prev,
> >                                  struct task_struct *next)
> >  {
> >       struct pt_regs *regs;
> > @@ -66,7 +66,7 @@ static __always_inline bool has_fpu(void)
> >  static __always_inline bool has_fpu(void) { return false; }
> >  #define fstate_save(task, regs) do { } while (0)
> >  #define fstate_restore(task, regs) do { } while (0)
> > -#define __switch_to_aux(__prev, __next) do { } while (0)
> > +#define __switch_to_fpu(__prev, __next) do { } while (0)
> >  #endif
> >
> >  extern struct task_struct *__switch_to(struct task_struct *,
> > @@ -77,7 +77,7 @@ do {                                                 =
       \
> >       struct task_struct *__prev =3D (prev);            \
> >       struct task_struct *__next =3D (next);            \
> >       if (has_fpu())                                  \
> > -             __switch_to_aux(__prev, __next);        \
> > +             __switch_to_fpu(__prev, __next);        \
> >       ((last) =3D __switch_to(__prev, __next));         \
> >  } while (0)
>
> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>

I noticed that your R-b has been here for a while (at least since v13
where I started to handle this series). Do you want me to keep the
original, or the last one?

Thanks,
Andy
