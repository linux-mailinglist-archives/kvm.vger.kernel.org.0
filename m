Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7173C6FFCDE
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 00:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239473AbjEKW4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 18:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239311AbjEKW4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 18:56:39 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B1859DA
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:56:38 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-643990c5319so6636992b3a.2
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 15:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20221208.gappssmtp.com; s=20221208; t=1683845797; x=1686437797;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g32l86VlbBpmE6n5rf0sdhxv94KQRlfB8e5whYpMZ+o=;
        b=jcFT25rQ6v6RvN2QLECiOC1IK/LczGtjCtk6QrCXkb+PZAtqKNknB00Kqv+FfvZ3rQ
         GpFqo5imEAVdAbdP7DcuQ++zyQd3CXTegnsQbplLJ4fUVdKs2HXKDLhNVlCG8rb0SyD0
         OHgR7J4h2NcVZgyB+yp3QmT0FRnXv5m4udyaDJxcdF35u4DKy5v29pLABmkguFrD4I23
         V1j3XsxUdYITDXvxY4WfR+2vAxyqPMtvihq2rMjPLt/LteTWS+Mwo8zb93Ff4yWDOQ82
         ONU/0ais8VW+w1vAtcnFiQQRasapbElWODz31jMWP8GLHeZMPxv51qab0+Emp/Sr31Zc
         ng+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683845797; x=1686437797;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g32l86VlbBpmE6n5rf0sdhxv94KQRlfB8e5whYpMZ+o=;
        b=e5p0PD3QA2+zTAJ/Tqj3cIhrtQykCdwS2jkOOmydd5DHpyxpwtpkwmkpWnPsef89mS
         uVTXAvk+0IFW+n9jd4Z8PnCxpTauEL2p87lJ8pipfaHSwvrFkW05avN+Z69wssBZPJva
         KycxQVrixn1NvaKH27SkjB9qRaSvwkaMXJ/+QSmyrcbLXcx6y1VwGb/0bas7jXbl4SlK
         gpLE22e/SUWm7+vRCLZ2DU+Mqqb/Q+wap3Mc8nYHfSsh8sTcdDS/lDEI43asfNYVOYgd
         I6as3vLCndwspkZsco4PHP9n+dPznKXeaQjKnXHyefWPnGFQRNcqp4rQ+VNvXNJtXL1V
         k4Jg==
X-Gm-Message-State: AC+VfDwNGgATKJ2UbA3AiLaB927qSCY5SdFgkuXYSaHDzqPbJ6o2o5a0
        0vp/6erqllQ+RkgEByjaRadQ7w==
X-Google-Smtp-Source: ACHHUZ66CSa9VhqS1Aiii6WTwqwoJANRTdZgceyto+F1I9aEq7TVhTb/R0r/oe+DaGg1qA6H7Y8W+g==
X-Received: by 2002:a05:6a00:1acb:b0:646:8a8:9334 with SMTP id f11-20020a056a001acb00b0064608a89334mr20106119pfv.20.1683845797443;
        Thu, 11 May 2023 15:56:37 -0700 (PDT)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id k4-20020aa792c4000000b0063aa1763146sm6008689pfa.17.2023.05.11.15.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 15:56:36 -0700 (PDT)
Date:   Thu, 11 May 2023 15:56:36 -0700 (PDT)
X-Google-Original-Date: Thu, 11 May 2023 15:40:02 PDT (-0700)
Subject:     Re: [PATCH -next v19 04/24] riscv: Add new csr defines related to vector extension
In-Reply-To: <20230509103033.11285-5-andy.chiu@sifive.com>
CC:     linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        vincent.chen@sifive.com, andy.chiu@sifive.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, apatel@ventanamicro.com,
        Atish Patra <atishp@rivosinc.com>, guoren@kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     andy.chiu@sifive.com
Message-ID: <mhng-18df71ab-832b-4312-9319-52ae8b3da0d8@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 09 May 2023 03:30:13 PDT (-0700), andy.chiu@sifive.com wrote:
> From: Greentime Hu <greentime.hu@sifive.com>
>
> Follow the riscv vector spec to add new csr numbers.
>
> Acked-by: Guo Ren <guoren@kernel.org>
> Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
> Suggested-by: Vineet Gupta <vineetg@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> ---
>  arch/riscv/include/asm/csr.h | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index b6acb7ed115f..b98b3b6c9da2 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -24,16 +24,24 @@
>  #define SR_FS_CLEAN	_AC(0x00004000, UL)
>  #define SR_FS_DIRTY	_AC(0x00006000, UL)
>
> +#define SR_VS		_AC(0x00000600, UL) /* Vector Status */
> +#define SR_VS_OFF	_AC(0x00000000, UL)
> +#define SR_VS_INITIAL	_AC(0x00000200, UL)
> +#define SR_VS_CLEAN	_AC(0x00000400, UL)
> +#define SR_VS_DIRTY	_AC(0x00000600, UL)
> +
>  #define SR_XS		_AC(0x00018000, UL) /* Extension Status */
>  #define SR_XS_OFF	_AC(0x00000000, UL)
>  #define SR_XS_INITIAL	_AC(0x00008000, UL)
>  #define SR_XS_CLEAN	_AC(0x00010000, UL)
>  #define SR_XS_DIRTY	_AC(0x00018000, UL)
>
> +#define SR_FS_VS	(SR_FS | SR_VS) /* Vector and Floating-Point Unit */
> +
>  #ifndef CONFIG_64BIT
> -#define SR_SD		_AC(0x80000000, UL) /* FS/XS dirty */
> +#define SR_SD		_AC(0x80000000, UL) /* FS/VS/XS dirty */
>  #else
> -#define SR_SD		_AC(0x8000000000000000, UL) /* FS/XS dirty */
> +#define SR_SD		_AC(0x8000000000000000, UL) /* FS/VS/XS dirty */
>  #endif
>
>  #ifdef CONFIG_64BIT
> @@ -375,6 +383,12 @@
>  #define CSR_MVIPH		0x319
>  #define CSR_MIPH		0x354
>
> +#define CSR_VSTART		0x8
> +#define CSR_VCSR		0xf
> +#define CSR_VL			0xc20
> +#define CSR_VTYPE		0xc21
> +#define CSR_VLENB		0xc22
> +
>  #ifdef CONFIG_RISCV_M_MODE
>  # define CSR_STATUS	CSR_MSTATUS
>  # define CSR_IE		CSR_MIE

Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
