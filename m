Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D019533ACB
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 12:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiEYKom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 06:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiEYKoi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 06:44:38 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8145994CE
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 03:44:36 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id j25so5109334wrb.6
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 03:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yq6p96C1fc+MGKIqFKbTDNPw2AFedUy/YYdKi/XXDHg=;
        b=DgLr4TC5Xs6UG5jSt/m4FS1vnThLRt9fzgnzG1csQNlpmKpt5+MIhK5kujMkIJdVTP
         GgcdkV9PMV9rdzd7t4/kvMrO41Txz5z+yOGO10vDU139EAaHhAvKMlnPlao/WRf72Jg1
         QviaH+PZop7vwYPJ8izcO6Ye0u2vy6y57C90UQ05V9ySf8W74vlXb4edGrGGlDCYcbXA
         V1igEyQBZwW81bDNunm7iWmORTpXlYSJNYempGzLs6CVVRgscHzSbOlbg7CvJDQvM+5u
         IN628Sis9j710e/jri0x2T8Hz5I/UnWCBZwXZnYTn3zJlvjGwRpGhVpwF8WjCPr8lXiR
         QT2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yq6p96C1fc+MGKIqFKbTDNPw2AFedUy/YYdKi/XXDHg=;
        b=PV56BHOLj9k2zreRQYWmfDzwz8DpyxKvyhceA9jM9uzLU0Ne610V2060WGx5jUeXz4
         hMwcSw4hCr0JDll6BhdHO2RSrjZNCwFXk6+RBgaJejtwwTM5jcVRXFNH74mPJqrAKMq1
         elgEP69i9063/JtqsgELU2OfhkRLvW3I7JcCTqzm0NV6G+hGLgSU1pCM5pPbF/uTd7MV
         WwmZHyQDo3LAF94v0KJgCEEmhLIKoJLTjnd4fnwlun03Fw8uC4T1hPZoRZgnwSpDWFgP
         eCy82JQtDMAQA9TnQ+kKyGzI83mwJzi5mNxsYRShZvRVzQPWbc4oCM4s3er77/rhdvd+
         iMsA==
X-Gm-Message-State: AOAM531S+b5/SWnJayH2fxlUPrXPnnlcmWhJTad/Px4Cv5uY65OOfmit
        4xy/mY6O1anxU+Y79SyZqmtaf0LkEBhK3xjuyFw48VCrUIBJmSN5
X-Google-Smtp-Source: ABdhPJyVssSfciolYp42GrJ5NdefDyeqUYxx/nkebXTHbrtRchYUEK/QI9WvUsXPhIxKNF3Todc6/ciPdsVS1+YKeNU=
X-Received: by 2002:a5d:6c6b:0:b0:1ea:77ea:dde8 with SMTP id
 r11-20020a5d6c6b000000b001ea77eadde8mr26805330wrz.690.1653475475287; Wed, 25
 May 2022 03:44:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220524180030.1848992-1-daolu@rivosinc.com>
In-Reply-To: <20220524180030.1848992-1-daolu@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 25 May 2022 16:14:23 +0530
Message-ID: <CAAhSdy3Cit9GvfO1oEDLXf8ncam2D8FqQNHJKBj0z5RfMZ26WA@mail.gmail.com>
Subject: Re: [PATCH kvmtool v2] Fixes: 0febaae00bb6 ("Add asm/kernel.h for riscv")
To:     Dao Lu <daolu@rivosinc.com>
Cc:     KVM General <kvm@vger.kernel.org>, Will Deacon <will@kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        Anup Patel <apatel@ventanamicro.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 24, 2022 at 11:30 PM Dao Lu <daolu@rivosinc.com> wrote:
>
> Fixes the following compilation issue:
>
> include/linux/kernel.h:5:10: fatal error: asm/kernel.h: No such file
> or directory
>     5 | #include "asm/kernel.h"
>
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Dao Lu <daolu@rivosinc.com>

I agree with Alexandre, we need a better PATCH subject. Also,
move the Fixes tag from PATCH subject to PATCH description just
above your Signed-off-by.

Otherwise, this looks good to me.
Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  riscv/include/asm/kernel.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
>  create mode 100644 riscv/include/asm/kernel.h
>
> diff --git a/riscv/include/asm/kernel.h b/riscv/include/asm/kernel.h
> new file mode 100644
> index 0000000..4ab195f
> --- /dev/null
> +++ b/riscv/include/asm/kernel.h
> @@ -0,0 +1,8 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef __ASM_KERNEL_H
> +#define __ASM_KERNEL_H
> +
> +#define NR_CPUS        512
> +
> +#endif /* __ASM_KERNEL_H */
> --
> 2.36.0
>
