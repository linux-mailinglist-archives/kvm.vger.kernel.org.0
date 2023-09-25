Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2D47AD925
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 15:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbjIYNbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 09:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbjIYNa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 09:30:59 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE7B107
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 06:30:48 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-274c05edb69so3639033a91.2
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 06:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695648648; x=1696253448; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VTAe+igFn40GXZ4NBAxS7RiCj1q3ukys0lCN9eYvcaY=;
        b=A1IrmBz3pmI/MHQfCtnfQwMosOHpO/GRytwO/+Uni3ZRg5rMOvcseh4/169+JlLVcK
         t1EdIRE0NPrr+UWhYkyzRQ/umJohMWs+XvXGP6MXZjZjrE1yMiFCNI0iOrfzybTnBWCu
         f8YmYiUQ/Sd0FFq/aJVVuZBL1EXuIIJcRxwJ1KBHkkCSMyPsFzHPsaxn6r28az+M9/Qu
         j1TWaKZIafv7F6LXCBFG/E/2r3JvuiAWBIa4eMgQwHWzQBGitOegyLJkJmM6aTs7roxb
         wOf9xStK7W4rktgYqcqkdl0PORURkwT482vJKa6jK331lO4WmYg/w3m4JYtfPonL8W8m
         ZuxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695648648; x=1696253448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VTAe+igFn40GXZ4NBAxS7RiCj1q3ukys0lCN9eYvcaY=;
        b=dtlrUxaPbuXEH6VdqkI3XN/VLN6/XOqjw4qYpxV6TQtD1pivucvRHh/MtQ68HRyh3W
         2D0K0IXyW0MdGE1hWuj5riuIG0sIaffDUEfrNDOEgDwlQE30AA+Nqy371R0bBwNhvjDz
         du4EiTIqDSeApmNbVOhp/psnsNUjJ38nAYFzR0kS1izmyfGcz1EZUX9ZI9S8Qd9FBiP1
         0O0oHGR2sJ/CIDqJydEjtQ5k11owfy4l6qF8vZi0XyE6r0Vw8gLA2/8Kwna8WhwP+SKV
         fU7qyiX4Mmwi4hMfNtHTLR0HF63crXKwIxs1Ny0hXlotkqv7dnsjkA76GC+6WzgnULpB
         p3kg==
X-Gm-Message-State: AOJu0YytYwXBzZ/9ta7pWlWRJOTuDYw3eXASXvfRqCYn97yRcc/MXsCj
        /L6UBygcZjibDn0V3jbDo95+PHrTpDFboTe5K7AtNw==
X-Google-Smtp-Source: AGHT+IGU7gRk9/0iLRnse7x9jQcD2qTYI6KEpxx8F337G2Vkhth9oLL6ElHvVj6WCup2zLolI768fLqgUgDAY/Hd65U=
X-Received: by 2002:a17:90a:f40e:b0:276:6b9d:7503 with SMTP id
 ch14-20020a17090af40e00b002766b9d7503mr4488656pjb.28.1695648648206; Mon, 25
 Sep 2023 06:30:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230919035343.1399389-1-apatel@ventanamicro.com>
 <20230919035343.1399389-2-apatel@ventanamicro.com> <20230919-bbcb3627b6d9d0238c5ba351@fedora>
In-Reply-To: <20230919-bbcb3627b6d9d0238c5ba351@fedora>
From:   Anup Patel <apatel@ventanamicro.com>
Date:   Mon, 25 Sep 2023 19:00:37 +0530
Message-ID: <CAK9=C2Ub7+4QOdq4rXoSOuLoYaUczeqaLoCVRZ_63dZOZwiu1w@mail.gmail.com>
Subject: Re: [PATCH 1/7] RISC-V: Detect XVentanaCondOps from ISA string
To:     Conor Dooley <conor@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        devicetree@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 19, 2023 at 12:56=E2=80=AFPM Conor Dooley <conor@kernel.org> wr=
ote:
>
> Hey Anup,
>
> On Tue, Sep 19, 2023 at 09:23:37AM +0530, Anup Patel wrote:
> > The Veyron-V1 CPU supports custom conditional arithmetic and
> > conditional-select/move operations referred to as XVentanaCondOps
> > extension. In fact, QEMU RISC-V also has support for emulating
> > XVentanaCondOps extension.
> >
> > Let us detect XVentanaCondOps extension from ISA string available
> > through DT or ACPI.
> >
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > ---
> >  Documentation/devicetree/bindings/riscv/extensions.yaml | 7 +++++++
> >  arch/riscv/include/asm/hwcap.h                          | 1 +
> >  arch/riscv/kernel/cpufeature.c                          | 1 +
> >  3 files changed, 9 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/=
Documentation/devicetree/bindings/riscv/extensions.yaml
> > index 36ff6749fbba..cad8ef68eca7 100644
> > --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> > +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> > @@ -171,6 +171,13 @@ properties:
> >              memory types as ratified in the 20191213 version of the pr=
ivileged
> >              ISA specification.
> >
> > +        - const: xventanacondops
> > +          description: |
> > +            The Ventana specific XVentanaCondOps extension for conditi=
onal
> > +            arithmetic and conditional-select/move operations defined =
by the
> > +            Ventana custom extensions specification v1.0.1 (or higher)=
 at
> > +            https://github.com/ventanamicro/ventana-custom-extensions/=
releases.
> > +
>
> For this and the next patch, the binding change needs to be split out
> from the code. checkpatch should've complained about it.

Okay, I will split this patch.

>
> >          - const: zba
> >            description: |
> >              The standard Zba bit-manipulation extension for address ge=
neration
> > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hw=
cap.h
> > index 0f520f7d058a..b7efe9e2fa89 100644
> > --- a/arch/riscv/include/asm/hwcap.h
> > +++ b/arch/riscv/include/asm/hwcap.h
> > @@ -59,6 +59,7 @@
> >  #define RISCV_ISA_EXT_ZIFENCEI               41
> >  #define RISCV_ISA_EXT_ZIHPM          42
> >  #define RISCV_ISA_EXT_SMSTATEEN              43
> > +#define RISCV_ISA_EXT_XVENTANACONDOPS        44
> >
> >  #define RISCV_ISA_EXT_MAX            64
> >
> > diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeat=
ure.c
> > index 3755a8c2a9de..3a31d34fe709 100644
> > --- a/arch/riscv/kernel/cpufeature.c
> > +++ b/arch/riscv/kernel/cpufeature.c
> > @@ -182,6 +182,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] =3D=
 {
> >       __RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
> >       __RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
> >       __RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
> > +     __RISCV_ISA_EXT_DATA(xventanacondops, RISCV_ISA_EXT_XVENTANACONDO=
PS),
>
> I've been banging on for a bit about people doing weird stuff to detect
> their vendor extensions, so nice to see it being done properly :)
>
>
> Cheers,
> Conor.
>
> >  };
> >
> >  const size_t riscv_isa_ext_count =3D ARRAY_SIZE(riscv_isa_ext);
> > --
> > 2.34.1
> >

Regards,
Anup
