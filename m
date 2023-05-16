Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E197043E2
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 05:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjEPDP0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 23:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjEPDPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 23:15:23 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E21F65B2
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 20:15:21 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4f14ec8d72aso13622727e87.1
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 20:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1684206920; x=1686798920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bl+t8tHUGXHrqDdO1CHQdBE7Nio53ARCR1K6a8BjQJM=;
        b=QDSmAjGaG02MDvl0QOYVYtwVBSIYvuiSE3o7PLY2ctKCNKB5+ENkBZxLYfsGO0yIEe
         EKvIUQK5D7FDP0pRrs31heyd9tjBX0Ol3gXhaGL+ZkC/JOrdkIBHYfoFH+0r9wpfncrx
         QMN+6Qs9vrttLKpaq0X9C+pqbc3Hh0chy3u8W9wZM2M4SWdzgOS3pupmXObX/LdQI6uk
         h4Ir7o76eLpMebje7u5vup9e+RdIAYBjjtNOzBf69BK+bhXsz6gLkhPFsVlHprWAjfUA
         amrDGqVbJwR1DiMpV5F3TWSIeu2O1Y7pRm9fgzGuuSEsHyDCEBvxk3H0jEpYTElvJJvy
         HWcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684206920; x=1686798920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bl+t8tHUGXHrqDdO1CHQdBE7Nio53ARCR1K6a8BjQJM=;
        b=Tw/CZC5y3xvPy8IstSPxUz8axfeX9woYM2gqoBWScj2lFqvMsWhHhsx/m1sCQhtTh+
         /8uaJnwjw0z7DUV5tH2uSrlZ8vPv93jneoxw3BTf4WDx8jB8+mf9Htq7S5OYOd/LNiYh
         UqfYxLsh8jadpX+2LSYwJpWTEIvazO4fftKPvH4Jj1RDzTVQ/PhDffVeLuws4EZTKqrK
         HBvQm4KFZ01vF9//Ly522TO4hBWRxQslKfzuxwn42CKqJYdOyLwFsXJmTAQ0ZYH6aIcp
         S5yQUK9Hd+8IJJOrJkYmqDRpFITyIdaJTQjt3Lo4aXDMJsyiKdwYI+jYt0uTglHd9q5H
         Q4xw==
X-Gm-Message-State: AC+VfDwpmr3GDiwcdtLo2Y1LlZ9ukiG+xPuQ2pxmVMQcusLfnKLzRggp
        uZk97zhW0YgGj4rzjS53Dtv3Iu8yDAGkD7U6bWxgjQ==
X-Google-Smtp-Source: ACHHUZ6JUxopVpBE88qqEZ5JgPzNfhH8+JbSBHjancbpmQh2v+I4RepO2FFjvtV91quS6KuiypieGyHjzb6rz48gfsQ=
X-Received: by 2002:ac2:47f4:0:b0:4ef:f017:e52 with SMTP id
 b20-20020ac247f4000000b004eff0170e52mr7660035lfp.5.1684206919728; Mon, 15 May
 2023 20:15:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230509103033.11285-5-andy.chiu@sifive.com> <mhng-18df71ab-832b-4312-9319-52ae8b3da0d8@palmer-ri-x1c9a>
In-Reply-To: <mhng-18df71ab-832b-4312-9319-52ae8b3da0d8@palmer-ri-x1c9a>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Tue, 16 May 2023 11:15:08 +0800
Message-ID: <CABgGipUfekA2fHVz4L3EzynF-rVMwTJpGBcusWwXXAon3pZLYA@mail.gmail.com>
Subject: Re: [PATCH -next v19 04/24] riscv: Add new csr defines related to
 vector extension
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        vincent.chen@sifive.com, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, apatel@ventanamicro.com,
        Atish Patra <atishp@rivosinc.com>, guoren@kernel.org
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
> On Tue, 09 May 2023 03:30:13 PDT (-0700), andy.chiu@sifive.com wrote:
> > From: Greentime Hu <greentime.hu@sifive.com>
> >
> > Follow the riscv vector spec to add new csr numbers.
> >
> > Acked-by: Guo Ren <guoren@kernel.org>
> > Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> > Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> > Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> > Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> > Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> > Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
> > Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> > Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> > Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> > ---
> >  arch/riscv/include/asm/csr.h | 18 ++++++++++++++++--
> >  1 file changed, 16 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.=
h
> > index b6acb7ed115f..b98b3b6c9da2 100644
> > --- a/arch/riscv/include/asm/csr.h
> > +++ b/arch/riscv/include/asm/csr.h
> > @@ -24,16 +24,24 @@
> >  #define SR_FS_CLEAN  _AC(0x00004000, UL)
> >  #define SR_FS_DIRTY  _AC(0x00006000, UL)
> >
> > +#define SR_VS                _AC(0x00000600, UL) /* Vector Status */
> > +#define SR_VS_OFF    _AC(0x00000000, UL)
> > +#define SR_VS_INITIAL        _AC(0x00000200, UL)
> > +#define SR_VS_CLEAN  _AC(0x00000400, UL)
> > +#define SR_VS_DIRTY  _AC(0x00000600, UL)
> > +
> >  #define SR_XS                _AC(0x00018000, UL) /* Extension Status *=
/
> >  #define SR_XS_OFF    _AC(0x00000000, UL)
> >  #define SR_XS_INITIAL        _AC(0x00008000, UL)
> >  #define SR_XS_CLEAN  _AC(0x00010000, UL)
> >  #define SR_XS_DIRTY  _AC(0x00018000, UL)
> >
> > +#define SR_FS_VS     (SR_FS | SR_VS) /* Vector and Floating-Point Unit=
 */
> > +
> >  #ifndef CONFIG_64BIT
> > -#define SR_SD                _AC(0x80000000, UL) /* FS/XS dirty */
> > +#define SR_SD                _AC(0x80000000, UL) /* FS/VS/XS dirty */
> >  #else
> > -#define SR_SD                _AC(0x8000000000000000, UL) /* FS/XS dirt=
y */
> > +#define SR_SD                _AC(0x8000000000000000, UL) /* FS/VS/XS d=
irty */
> >  #endif
> >
> >  #ifdef CONFIG_64BIT
> > @@ -375,6 +383,12 @@
> >  #define CSR_MVIPH            0x319
> >  #define CSR_MIPH             0x354
> >
> > +#define CSR_VSTART           0x8
> > +#define CSR_VCSR             0xf
> > +#define CSR_VL                       0xc20
> > +#define CSR_VTYPE            0xc21
> > +#define CSR_VLENB            0xc22
> > +
> >  #ifdef CONFIG_RISCV_M_MODE
> >  # define CSR_STATUS  CSR_MSTATUS
> >  # define CSR_IE              CSR_MIE
>
> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>

This patch also has your R-b and has not been changed since v13.

Thanks,
Andy
