Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEACA67BEA9
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 22:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236632AbjAYViG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 16:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236476AbjAYViE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 16:38:04 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53241A97A
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 13:38:02 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id m7so4751888wru.8
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 13:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jrtc27.com; s=gmail.jrtc27.user;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WbZdqAhuTe9AIsgKG5ncENT/Fwm11IcS5xObaY+RarY=;
        b=UkLUBw8AwwhiORilDzbdXozeWE2tAzcPWOjBItkn4G5MvRlWWNiLNKxDEBg1Q4+exF
         NK34lXMXzWsN5JwM1A1eQw/1naFhpuGk86S21TaYfIEwjtls0hmVZXnJefidBCvZCoIc
         37zcDnL2e3NfJwU8yXvSjRNhSGIfFB9sDsjcWcVy2DOdvfpdNCV6nQ5vq+vm8k1AOxeA
         JNUCi47dnyNQoq+YQmp1QVpXI4cmU3pmXhHpBPFGcXFmhv7fZTJ5JxJas/zuja2SZplG
         3gOToxegeWg1spBfCN/4qCmgXe1t6aCzgOR0K15bM30r0oPXRTsKwRrTLPQEEjIlEbVB
         U2RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WbZdqAhuTe9AIsgKG5ncENT/Fwm11IcS5xObaY+RarY=;
        b=FzDq76RuKle9GFp5q3fOK02kP2oikpl/U6JxBkDgSj8Dp6+WAVk9ZX6m+CoHhUNo92
         jnS2T/YyYuV5Bp3nlQPNqS2EHq9TMoNIA0F+HZGK2ecebbqmDdltSl9hB22nRsOgozlm
         J7l8miXKaFTcDXiDegLzoIdCXsOxocDla9dzBj8HnwXCrTx/5L9gUho8OwvjQfCwqwmq
         85CMI19d1fatDp0KEXPQSS4BLUfYUkZ3beZbnIYEyOCrvjQkDWR4rQjiQGSDIsBRZWUY
         FrQFwgLoUiAiIBAs+iw4Vfvbca9H9oslMpN5oHZO+RabD/Xjgo2ctEkGeSk8UN/rVcC3
         SWaA==
X-Gm-Message-State: AFqh2koLmTBoufJxEV9cdyfDupO9DPNNjDor3MMaqaZF7dGh5+3wFylH
        bMLTolZOaODrEvb2OV7FrOpimq5Cc5gCS4Cz90gjgw==
X-Google-Smtp-Source: AMrXdXsR2Je/4xV9HRoKmjozZbu5PzVQTpAyfK0zfNO788NzP54zQrxCPv10LVg6W3IGFWf+qIWbEw==
X-Received: by 2002:a5d:5083:0:b0:2be:546c:4663 with SMTP id a3-20020a5d5083000000b002be546c4663mr17895375wrt.45.1674682681272;
        Wed, 25 Jan 2023 13:38:01 -0800 (PST)
Received: from smtpclient.apple (global-5-143.n-2.net.cam.ac.uk. [131.111.5.143])
        by smtp.gmail.com with ESMTPSA id y15-20020adfdf0f000000b00236883f2f5csm5597781wrl.94.2023.01.25.13.38.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Jan 2023 13:38:00 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH -next v13 19/19] riscv: Enable Vector code to be built
From:   Jessica Clarke <jrtc27@jrtc27.com>
In-Reply-To: <Y9GZbVrZxEZAraVu@spud>
Date:   Wed, 25 Jan 2023 21:38:00 +0000
Cc:     Andy Chiu <andy.chiu@sifive.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        Vineet Gupta <vineetg@rivosinc.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Content-Transfer-Encoding: quoted-printable
Message-Id: <08DF16C6-1D76-4FBE-871C-3A37C5349C87@jrtc27.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-20-andy.chiu@sifive.com> <Y9GZbVrZxEZAraVu@spud>
To:     Conor Dooley <conor@kernel.org>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25 Jan 2023, at 21:04, Conor Dooley <conor@kernel.org> wrote:
>=20
> Hey Andy,
>=20
> Thanks for respinning this, I think a lot of people will be happy to =
see
> it!
>=20
> On Wed, Jan 25, 2023 at 02:20:56PM +0000, Andy Chiu wrote:
>=20
>> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
>> index 12d91b0a73d8..67411cdc836f 100644
>> --- a/arch/riscv/Makefile
>> +++ b/arch/riscv/Makefile
>> @@ -52,6 +52,13 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:=3D rv32ima
>> riscv-march-$(CONFIG_ARCH_RV64I)	:=3D rv64ima
>> riscv-march-$(CONFIG_FPU)		:=3D $(riscv-march-y)fd
>> riscv-march-$(CONFIG_RISCV_ISA_C)	:=3D $(riscv-march-y)c
>> +riscv-march-$(CONFIG_RISCV_ISA_V)	:=3D $(riscv-march-y)v
>> +
>> +ifeq ($(CONFIG_RISCV_ISA_V), y)
>> +ifeq ($(CONFIG_CC_IS_CLANG), y)
>> +        riscv-march-y +=3D -mno-implicit-float =
-menable-experimental-extensions
>> +endif
>> +endif
>=20
> Uh, so I don't think this was actually tested with (a recent version =
of)
> clang:
> clang-15: error: unknown argument: =
'-menable-experimental-extensions_zicbom_zihintpause'
>=20
> Firstly, no-implicit-float is a CFLAG, so why add it to march?
> There is an existing patch on the list for enabling this flag, but I
> recall Palmer saying that it was not actually needed?
> Palmer, do you remember why that was?
>=20
> I dunno what enable-experimental-extensions is, but I can guess. Do we
> really want to enable vector for toolchains where the support is
> considered experimental? I'm not au fait with the details of clang
> versions nor versions of the Vector spec, so take the following with a
> bit of a pinch of salt...
> Since you've allowed this to be built with anything later than clang =
13,
> does that mean that different versions of clang may generate vector =
code
> that are not compatible?
> I'm especially concerned by:
> https://github.com/riscv/riscv-v-spec/releases/tag/0.9
> which appears to be most recently released version of the spec, prior =
to
> clang/llvm 13 being released.

For implementations of unratified extensions you both have to enable
them with -menable-experimental-extensions and have to explicitly
specify the version in the -march string specifically so this isn=E2=80=99=
t a
concern. Only once ratified can you use the unversioned extension,
which is implicitly the ratified version (ignoring the whole i2p0 vs
i2p1 fiasco).

But no, you probably don=E2=80=99t want experimental implementations, =
which can
exist when the ratified version is implemented in theory (so there=E2=80=99=
s no
compatibility concern based on ISA changes) but isn=E2=80=99t deemed
production-ready (e.g. potential ABI instability in the case of
something like V).

Jess

