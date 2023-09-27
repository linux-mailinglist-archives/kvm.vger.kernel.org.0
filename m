Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074447B077F
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 17:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbjI0PBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 11:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbjI0PBg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 11:01:36 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D41180
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 08:01:32 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-690d8fb3b7eso10181866b3a.1
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 08:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1695826892; x=1696431692; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yTY333uB+lnx85QRK4UhGRcNGGIw7L3jD83kYOSz/mk=;
        b=Isgr6KgaqmmexAKyGkB8Hpoivf3+H2r2oB1yNE2ZON1oXyA7UU/kXuh8qBYeFFaeQU
         4br+w0ziVpC8/buC3NCHU4jla3zb0Dhmzgi2aadrLxO9cOCAIMMgxairPzXDVv8La+Aw
         PQbtq9qXMYNwa0lcaekQHg76pP8zhHGTU7hc2QSxEdY9BtlJmdRIu8tcp3JNrjMsRYjh
         RMMV326M1bgXSr7JUTlTdiD4C+irrVVBANvCGdkifTM/2rwyHviNhDI0k+vZpCJbn3Z+
         ONUVPDltKaqw2CpKPAzGu7ol35YSZkHUE/VcXzYEhG9IuB+Vtyu4SL0bEy0ltItn47qM
         YdhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695826892; x=1696431692;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yTY333uB+lnx85QRK4UhGRcNGGIw7L3jD83kYOSz/mk=;
        b=a79SdFvGr9X7DHmOXFHU0AuyjRC9wbSIPVjFx9wei35Z4QgNUMab3k0GNzjeTDnGxG
         fnzzS9iFpcqD38H46ZMtFek3nUeIl/fPYGXv1SXYfU4zTZfuooXW/QzaqA6u/hhyKh9/
         zspPUUn8IX7qvbNUEhou6yiD19ReMD2/F82bcW6mGXy8LmGuqvUO+k/xB23yD3y7ftVq
         OPx2Gm53J/fXPtBglvKDK/iRnLcPijVRPykHTNtGpUkfIvAGWzpgP4jnrV5hXb3wdE6h
         e3z4RIsdGWlw2myAntf2g68hz/tA90sRa/Y0gH3UVrSvnCnfk1TXg8IhawoZOPKrshDT
         9NHg==
X-Gm-Message-State: AOJu0Yw3jxoQop1Xb33fVLI5N2SrPVbTuAdImarH/292HaH7F0fDJHY2
        3lbCZxEKb+sCgz8wFIoNYyx12g==
X-Google-Smtp-Source: AGHT+IGS9wTm9vyVcNuS0LVmu2jhxPRdEUlru4/3+hbsDAoZiukfMAFderu5eKF3apag2JrFxYUQQQ==
X-Received: by 2002:a05:6a20:3d0b:b0:134:4f86:7966 with SMTP id y11-20020a056a203d0b00b001344f867966mr2743151pzi.9.1695826891666;
        Wed, 27 Sep 2023 08:01:31 -0700 (PDT)
Received: from localhost ([135.180.227.0])
        by smtp.gmail.com with ESMTPSA id b19-20020aa78113000000b0069302c3c054sm4003815pfi.207.2023.09.27.08.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 08:01:31 -0700 (PDT)
Date:   Wed, 27 Sep 2023 08:01:31 -0700 (PDT)
X-Google-Original-Date: Wed, 27 Sep 2023 08:01:29 PDT (-0700)
Subject:     Re: [PATCH v2 0/9] KVM RISC-V Conditional Operations
In-Reply-To: <20230927-snowcap-stadium-2f6aeffac59e@spud>
CC:     apatel@ventanamicro.com, pbonzini@redhat.com,
        atishp@atishpatra.org, Paul Walmsley <paul.walmsley@sifive.com>,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shuah@kernel.org, ajones@ventanamicro.com,
        mchitale@ventanamicro.com, devicetree@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Conor Dooley <conor@kernel.org>
Message-ID: <mhng-ed1b5d0a-469c-43e3-a0fe-b8e498cde538@palmer-ri-x1c9>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Sep 2023 07:45:28 PDT (-0700), Conor Dooley wrote:
> On Wed, Sep 27, 2023 at 07:54:49PM +0530, Anup Patel wrote:
>> On Mon, Sep 25, 2023 at 9:07 PM Conor Dooley <conor@kernel.org> wrote:
>> >
>> > On Mon, Sep 25, 2023 at 04:33:15PM +0100, Conor Dooley wrote:
>> > > On Mon, Sep 25, 2023 at 07:08:50PM +0530, Anup Patel wrote:
>> > > > This series extends KVM RISC-V to allow Guest/VM discover and use
>> > > > conditional operations related ISA extensions (namely XVentanaCondOps
>> > > > and Zicond).
>> > > >
>> > > > To try these patches, use KVMTOOL from riscv_zbx_zicntr_smstateen_condops_v1
>> > > > branch at: https://github.com/avpatel/kvmtool.git
>> > > >
>> > > > These patches are based upon the latest riscv_kvm_queue and can also be
>> > > > found in the riscv_kvm_condops_v2 branch at:
>> > > > https://github.com/avpatel/linux.git
>> > > >
>> > > > Changes since v1:
>> > > >  - Rebased the series on riscv_kvm_queue
>> > > >  - Split PATCH1 and PATCH2 of v1 series into two patches
>> > > >  - Added separate test configs for XVentanaCondOps and Zicond in PATCH7
>> > > >    of v1 series.
>> > > >
>> > > > Anup Patel (9):
>> > > >   dt-bindings: riscv: Add XVentanaCondOps extension entry
>> > > >   RISC-V: Detect XVentanaCondOps from ISA string
>> > > >   dt-bindings: riscv: Add Zicond extension entry
>> > > >   RISC-V: Detect Zicond from ISA string
>> > >
>> > > For these 4:
>> > > Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
>> >
>> > Actually, now that I think of it, I'm going to temporarily un-review this.
>> > From patch-acceptance.rst:
>> > | Additionally, the RISC-V specification allows implementers to create
>> > | their own custom extensions.  These custom extensions aren't required
>> > | to go through any review or ratification process by the RISC-V
>> > | Foundation.  To avoid the maintenance complexity and potential
>> > | performance impact of adding kernel code for implementor-specific
>> > | RISC-V extensions, we'll only consider patches for extensions that either:
>> > |
>> > | - Have been officially frozen or ratified by the RISC-V Foundation, or
>> > | - Have been implemented in hardware that is widely available, per standard
>> > |   Linux practice.
>> >
>> > The xventanacondops bits don't qualify under the first entry, and I
>> > don't think they qualify under the second yet. Am I wrong?
>> 
>> The Ventana Veyron V1 was announced in Dec 2022 at RISC-V summit
>> followed by press releases:
>> https://www.ventanamicro.com/ventana-introduces-veyron-worlds-first-data-center-class-risc-v-cpu-product-family/
>> https://www.embedded.com/ventana-reveals-risc-v-cpu-compute-chiplet-for-data-center/
>> https://www.prnewswire.com/news-releases/ventana-introduces-veyron-worlds-first-data-center-class-risc-v-cpu-product-family-301700985.html
>> 
>> @Palmer if the above looks good to you then please ack PATCH1-to-4
>
> These are announcements AFAICT & not an indication of "being implemented
> in hardware that is widely available".

The second two look to just be news articles quoting the first without 
any real new information, at least just from skimming them -- sorry if I 
missed something, though.

The article says "SDK released with necessary software already ported to 
Veyron" and "Veyron V1 Development Platform available", but aside from 
quotes of the press release I can't find information on either of those 
(or anything VT1 related, as there were some naming ambiguities).

Anup said during the call that they're still bringing up the chip and 
haven't started sampling yet, which usually means things are far from 
publicly availiable.  I thought I heard him say that these press 
releases would say the chip is sampling 2H23, but I can't find anything 
in them about sampling.

Anup also said it's availiable as IP and I remember something at Hot 
Chips talking about an example place and route for a VT1, which also 
sounds very much like a chip that's not availiable yet -- usually if 
there's a chip folks are a lot more concrete about that sort of thing.

So is there you can point to about this chip actually being publicly 
availiable?
