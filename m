Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688717BCF3E
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 18:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344924AbjJHQXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 12:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344915AbjJHQXm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 12:23:42 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B848F
        for <kvm@vger.kernel.org>; Sun,  8 Oct 2023 09:23:40 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2c012232792so45340301fa.0
        for <kvm@vger.kernel.org>; Sun, 08 Oct 2023 09:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1696782218; x=1697387018; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ll1xFIKgthVBkbIQ18l2VWC32SrBNao63uADKYJp67g=;
        b=aiZbyoMMC5+6fFmuHSOAb3i2JBjUjGr9SnsoA8S1vXuWC+TpxsmFRrLMM3jGVKPOea
         2xZMuDqFhI8uw5fuGbH5CLT4ILvTB6kAXIJgJ0N+3QxKwf4ITNBTeT1kVsaqjDCg8qhI
         W9VPQmhMf4g/gLtN54fVaEqs7dcqD8p2bWzdv+LQFN36TjMw2QfQfHnTa+3Nv/R3EqtO
         TEiDfgka3+/S6en82PYYHgppHJ5v28FzBjrFa/N+lucejpmhKI2KzmnSKs+BjA1KTbLL
         bCR5JJBlFTAJq1c3O44ZD/XzU34QZwd8c4zbehnyca8iH70anDiq49wL2/5sCjWx0KGc
         IfCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696782218; x=1697387018;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ll1xFIKgthVBkbIQ18l2VWC32SrBNao63uADKYJp67g=;
        b=CA0Vebfw4GMLEBWbZVKDMEad76E4+KBuP+YCR8MQyNwPXd6PTZ83Ge+aN797JIuaj/
         DeO/6We5dhIhNal8J1M/WmROjLd7fMjVV8z3dR7JTK+rkFG0bbNRSR+lhI28fMQEH6Z1
         XSMUb2z0TkvknnO031EIWVfQXpJ0OELt4s3eXdh1liq9ukQdqZDv4eLuZ0TB9biVt7o7
         JX4+KQ+zSkeePxu2Pym7EqmcCfZmr0aoeubqKJO8OAsymKEGBbchyNxFHJSfVNxNqmM6
         kw/Od7mxB9AXt3H+KDz3I4ziMq16VwyZEdfmyUWf65Sh58kjrd1rCnHDpW3OviM6MlJD
         Z20g==
X-Gm-Message-State: AOJu0YzqGCAYYHiLNB1mFx4aKZRgDVkPDC/K6Ii6az6jUEpn3nY+DH6R
        ExP7NwPsV3J5cwWAkUJQwd3Eclaq4+UmnMrrI6rNgA==
X-Google-Smtp-Source: AGHT+IEDiW/72+1fHjRwjd2QHLfwn12GJk+UvsKaCmV8jsLIrAy42uLdoJcDdY4vYIHGAMER6GtYTjOmBCv8mj+EReI=
X-Received: by 2002:a2e:828b:0:b0:2be:54b4:ff90 with SMTP id
 y11-20020a2e828b000000b002be54b4ff90mr10069767ljg.53.1696782218295; Sun, 08
 Oct 2023 09:23:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230605110724.21391-1-andy.chiu@sifive.com> <20230605110724.21391-15-andy.chiu@sifive.com>
 <ZSJ0K5JFrglyJY8o@aurel32.net>
In-Reply-To: <ZSJ0K5JFrglyJY8o@aurel32.net>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Mon, 9 Oct 2023 01:23:26 +0900
Message-ID: <CABgGipVQ3j+Njw1CDkD9cuDwTwR2-WqF7Y_yZt3NPipAedK_2Q@mail.gmail.com>
Subject: Re: [PATCH -next v21 14/27] riscv: signal: Add sigcontext
 save/restore for vector
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Rob Herring <robh@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Wenting Zhang <zephray@outlook.com>,
        Guo Ren <guoren@kernel.org>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 8, 2023 at 6:19=E2=80=AFPM Aurelien Jarno <aurelien@aurel32.net=
> wrote:
>
> Hi,
>
> On 2023-06-05 11:07, Andy Chiu wrote:
> > From: Greentime Hu <greentime.hu@sifive.com>
> >
> > This patch facilitates the existing fp-reserved words for placement of
> > the first extension's context header on the user's sigframe. A context
> > header consists of a distinct magic word and the size, including the
> > header itself, of an extension on the stack. Then, the frame is followe=
d
> > by the context of that extension, and then a header + context body for
> > another extension if exists. If there is no more extension to come, the=
n
> > the frame must be ended with a null context header. A special case is
> > rv64gc, where the kernel support no extensions requiring to expose
> > additional regfile to the user. In such case the kernel would place the
> > null context header right after the first reserved word of
> > __riscv_q_ext_state when saving sigframe. And the kernel would check if
> > all reserved words are zeros when a signal handler returns.
> >
> > __riscv_q_ext_state---->|     |<-__riscv_extra_ext_header
> >                       ~       ~
> >       .reserved[0]--->|0      |<-     .reserved
> >               <-------|magic  |<-     .hdr
> >               |       |size   |_______ end of sc_fpregs
> >               |       |ext-bdy|
> >               |       ~       ~
> >       +)size  ------->|magic  |<- another context header
> >                       |size   |
> >                       |ext-bdy|
> >                       ~       ~
> >                       |magic:0|<- null context header
> >                       |size:0 |
> >
> > The vector registers will be saved in datap pointer. The datap pointer
> > will be allocated dynamically when the task needs in kernel space. On
> > the other hand, datap pointer on the sigframe will be set right after
> > the __riscv_v_ext_state data structure.
>
> It appears that this patch somehow breaks userland, at least the rust
> compiler. This can be observed for instance by building the rust-lsd
> package in Debian, but many other rust packages are also affected:

Sorry for the time spent on pinpointing the issue. Yes, this is a bug
and we had a fix [1]. This fix was accidently not getting into the
-fixes branch, but it will. And it should be going into linux stable
as well, though I am not certain about the timing. Otherwise, this bug
may potentially break any processes which allocate a sigaltstack at an
address higher than their stack.

>
> * Failed build with kernel 6.5.3:
>   https://buildd.debian.org/status/fetch.php?pkg=3Drust-lsd&arch=3Driscv6=
4&ver=3D0.23.1-7%2Bb1&stamp=3D1696475386&raw=3D0
>
> * Successful build with kernel 6.4.13:
>   https://buildd.debian.org/status/fetch.php?pkg=3Drust-lsd&arch=3Driscv6=
4&ver=3D0.23.1-7%2Bb1&stamp=3D1696491025&raw=3D0
>
> It happens on hardware which does not have the V extension (in the above
> case on a Hifive Unmatched board). This can also be reproduced in a QEMU
> VM. Unfortunately disabling CONFIG_RISCV_ISA_V does not workaround the
> issue.
>
> It is not clear to me if it is a kernel issue or a wrong assumption on
> the rust side. Any hint on how to continue investigating?
>
> Regards
> Aurelien
>
> --
> Aurelien Jarno                          GPG: 4096R/1DDD8C9B
> aurelien@aurel32.net                     http://aurel32.net

[1]: https://yhbt.net/lore/all/mhng-7799d3a1-c12a-48e9-bb5f-e0a596892d78@pa=
lmer-ri-x1c9/
