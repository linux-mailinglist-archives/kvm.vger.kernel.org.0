Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F121C725038
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 00:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240117AbjFFWv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 18:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239633AbjFFWvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 18:51:49 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072361723
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 15:51:48 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2b1b86146afso51761731fa.3
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 15:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google; t=1686091906; x=1688683906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dbEOqi7UDwPGQYsVQdLqqaKOY2Ki9XGPX+PsNVb1pfQ=;
        b=mbcwf6gk5i2TF9vdZWhsZIpi4+sIJQgRjoOrNUxv/ebdwsHW5ix9YXxd42wqB7xKvv
         kocs5a9n3jYTep04cgtEtmwiRNhJhemMD4SyL6n1Gu7NpKN8WYIYZWHWb2G5NDBloBqX
         uehI7uE6GqTtYclM1PfGmlXU5wTE5HC2RRcp4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686091906; x=1688683906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dbEOqi7UDwPGQYsVQdLqqaKOY2Ki9XGPX+PsNVb1pfQ=;
        b=kov4JqgOP5MfIGwxHShMa2bUS0G2a7D5RwwOlJmpa8MWPzWsRDGMuchSg2Pny2TUIM
         odqFrxvsxa3TNcU64CtbzXKsLBqRFlIOqfx4/Uhcssx/QJlg3n9JoTX1Hc5wUoFCyu8Z
         Da6uYrsPRwMc2XpxY3hCb6OAKHZ67wnR6PYLuxEf0gU78Q9mzzp6BCJmc+M51ouBVXlB
         TbOqBqJRCE/KFbCl724cMAoS7QJBbzf0Xl3rnB+mbin9GNI7iN9BOrGd7d7//2JWwt6O
         ZxxMeLHFpR1LaTiMAeCeMtFPhBO+PJwF+bSez6BNFW60pOCO94K9O+CzZncgY9THrjbz
         hgGQ==
X-Gm-Message-State: AC+VfDwONf1bOpOxi6RpiQO+8gLzm6h+wXHfPPxG8kLFoYyLJEOadKCQ
        qGl1/poenxNNZcIrmZJQLg1spoo2fr+1zHYDBnnK
X-Google-Smtp-Source: ACHHUZ4KJVviG384lev7O3Wui5sN4TViyK0F/tK+N2XPByIrcx4WENx+9LadjCdNhsvEyIt9mDbEKgzlxPJcCWdbS/E=
X-Received: by 2002:a2e:999a:0:b0:2b1:c312:4faa with SMTP id
 w26-20020a2e999a000000b002b1c3124faamr1623384lji.53.1686091906254; Tue, 06
 Jun 2023 15:51:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230517105135.1871868-1-apatel@ventanamicro.com> <20230517105135.1871868-4-apatel@ventanamicro.com>
In-Reply-To: <20230517105135.1871868-4-apatel@ventanamicro.com>
From:   Atish Patra <atishp@atishpatra.org>
Date:   Tue, 6 Jun 2023 15:51:34 -0700
Message-ID: <CAOnJCUL0-BDJU6VCaXKKGzFbCo6hKzqDV9zJCFG_12PcX6uEXw@mail.gmail.com>
Subject: Re: [PATCH 03/10] RISC-V: KVM: Add APLIC related defines
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 17, 2023 at 3:52=E2=80=AFAM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> We add APLIC related defines in a separate header so that different
> parts of KVM code can share it. Once AIA drivers are merged will
> have a common APLIC header shared by both KVM and IRQCHIP driver.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_aia_aplic.h | 58 ++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
>  create mode 100644 arch/riscv/include/asm/kvm_aia_aplic.h
>
> diff --git a/arch/riscv/include/asm/kvm_aia_aplic.h b/arch/riscv/include/=
asm/kvm_aia_aplic.h
> new file mode 100644
> index 000000000000..6dd1a4809ec1
> --- /dev/null
> +++ b/arch/riscv/include/asm/kvm_aia_aplic.h
> @@ -0,0 +1,58 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2021 Western Digital Corporation or its affiliates.
> + * Copyright (C) 2022 Ventana Micro Systems Inc.
> + */
> +#ifndef __KVM_RISCV_AIA_IMSIC_H
> +#define __KVM_RISCV_AIA_IMSIC_H
> +
> +#include <linux/bitops.h>
> +
> +#define APLIC_MAX_IDC                  BIT(14)
> +#define APLIC_MAX_SOURCE               1024
> +
> +#define APLIC_DOMAINCFG                        0x0000
> +#define APLIC_DOMAINCFG_RDONLY         0x80000000
> +#define APLIC_DOMAINCFG_IE             BIT(8)
> +#define APLIC_DOMAINCFG_DM             BIT(2)
> +#define APLIC_DOMAINCFG_BE             BIT(0)
> +
> +#define APLIC_SOURCECFG_BASE           0x0004
> +#define APLIC_SOURCECFG_D              BIT(10)
> +#define APLIC_SOURCECFG_CHILDIDX_MASK  0x000003ff
> +#define APLIC_SOURCECFG_SM_MASK        0x00000007
> +#define APLIC_SOURCECFG_SM_INACTIVE    0x0
> +#define APLIC_SOURCECFG_SM_DETACH      0x1
> +#define APLIC_SOURCECFG_SM_EDGE_RISE   0x4
> +#define APLIC_SOURCECFG_SM_EDGE_FALL   0x5
> +#define APLIC_SOURCECFG_SM_LEVEL_HIGH  0x6
> +#define APLIC_SOURCECFG_SM_LEVEL_LOW   0x7
> +
> +#define APLIC_IRQBITS_PER_REG          32
> +
> +#define APLIC_SETIP_BASE               0x1c00
> +#define APLIC_SETIPNUM                 0x1cdc
> +
> +#define APLIC_CLRIP_BASE               0x1d00
> +#define APLIC_CLRIPNUM                 0x1ddc
> +
> +#define APLIC_SETIE_BASE               0x1e00
> +#define APLIC_SETIENUM                 0x1edc
> +
> +#define APLIC_CLRIE_BASE               0x1f00
> +#define APLIC_CLRIENUM                 0x1fdc
> +
> +#define APLIC_SETIPNUM_LE              0x2000
> +#define APLIC_SETIPNUM_BE              0x2004
> +
> +#define APLIC_GENMSI                   0x3000
> +
> +#define APLIC_TARGET_BASE              0x3004
> +#define APLIC_TARGET_HART_IDX_SHIFT    18
> +#define APLIC_TARGET_HART_IDX_MASK     0x3fff
> +#define APLIC_TARGET_GUEST_IDX_SHIFT   12
> +#define APLIC_TARGET_GUEST_IDX_MASK    0x3f
> +#define APLIC_TARGET_IPRIO_MASK        0xff
> +#define APLIC_TARGET_EIID_MASK 0x7ff
> +
> +#endif
> --
> 2.34.1
>


Reviewed-by: Atish Patra <atishp@rivosinc.com>
--=20
Regards,
Atish
