Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4C8776F0C
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 06:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjHJE0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 00:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjHJE0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 00:26:04 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E45410CA
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 21:26:03 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6bd0a0a675dso465666a34.2
        for <kvm@vger.kernel.org>; Wed, 09 Aug 2023 21:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691641562; x=1692246362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8SzlWpkO/G8eXJxm+wOIHBf7k158IaeAOHQb5zwz77g=;
        b=upVErD+im9yxS2c+J1AxUOFT3gb9ROrQtXAkJQWR/Od5Hlcaal5/JQFxpd910uiHMA
         rolfKNQdETXSZHI/JmL+9MEaqGs+Y2ANtpCPS/uGV1eBhOOR7gC3xt9Y2hAbSzT5Sd5e
         j1xQ9EQ/cXytXYLYYVC3QUNKzegtH0PLhOxRICScovv49Oiab+dPO7Y0r2sIRFt+Gz/f
         bN9+Rvs3XWMUiaRLZjooMQyeM9liWdUXjJ8GB32y7dQK1Evj8mpqkM8y6va8PCI0QIvU
         fZHVJyxXZ6UWyXQa2M0/cggiZ9FYaBcFC4zDQMYeCxCYiGIemD7IrNDMmaywESM7pKEb
         4pOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691641562; x=1692246362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8SzlWpkO/G8eXJxm+wOIHBf7k158IaeAOHQb5zwz77g=;
        b=dPBwY4vvJDUfZFV/TkKxyC/1j7Dee74WHgKt3CbFQYVqaqreQUc5hyl8D98lz/Nu91
         cOYMMrq+XOygBUJ554v+bQYfSfEZM6X68ZGVxcgEKzOgD9MVSygpCHVWTLqZg6VkFNK2
         RLWbe/BNtL/8BDVHEA9GH7PTeHYeJUhcekkxAVPE32OquO12jDaxjYyyI1UcCMHs2MFO
         J1gb4f4fnfd8msOWNephpTsAbfLwcr6fAJy++umiv4okKMNLiQST/EpVzqDnr4DSXzLI
         nE/8ZKIZoUnaA3fADEyG4N5phFH7kYh8tk1iZUcBB6IALIzMUOx0IJbbVN0iw2Sd2/Ok
         +Kdg==
X-Gm-Message-State: AOJu0Yy+Kjdp5QpjJyiulVZmX/D5CKI+Q5nHH5AshKg/GGkUDbMqHscg
        npmR7TK+i/H5N+/Vt6oiW8FJH3ZR8S5zkxHNAVgyJQ==
X-Google-Smtp-Source: AGHT+IGE7wa40ggnreKv846WO4nD3TWvJ+jAyG8x8cdRmwDbn5umSrJCg95VcM4tJqGJLJXLKtibuwap8bxbSr8UtF8=
X-Received: by 2002:a05:6870:95a6:b0:1bf:2aa4:ab0f with SMTP id
 k38-20020a05687095a600b001bf2aa4ab0fmr1476246oao.31.1691641562394; Wed, 09
 Aug 2023 21:26:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230808114711.2013842-1-maz@kernel.org> <20230808114711.2013842-3-maz@kernel.org>
In-Reply-To: <20230808114711.2013842-3-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 9 Aug 2023 21:25:47 -0700
Message-ID: <CAAdAUthi8tDmFyboZzLaxSTfkUxrucBxjeh8+Fn5OahK4L5=9g@mail.gmail.com>
Subject: Re: [PATCH v3 02/27] arm64: Add missing ERX*_EL1 encodings
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 8, 2023 at 4:47=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> We only describe a few of the ERX*_EL1 registers. Add the missing
> ones (ERXPFGF_EL1, ERXPFGCTL_EL1, ERXPFGCDN_EL1, ERXMISC2_EL1 and
> ERXMISC3_EL1).
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  arch/arm64/include/asm/sysreg.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sys=
reg.h
> index 85447e68951a..ed2739897859 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -229,8 +229,13 @@
>  #define SYS_ERXCTLR_EL1                        sys_reg(3, 0, 5, 4, 1)
>  #define SYS_ERXSTATUS_EL1              sys_reg(3, 0, 5, 4, 2)
>  #define SYS_ERXADDR_EL1                        sys_reg(3, 0, 5, 4, 3)
> +#define SYS_ERXPFGF_EL1                        sys_reg(3, 0, 5, 4, 4)
> +#define SYS_ERXPFGCTL_EL1              sys_reg(3, 0, 5, 4, 5)
> +#define SYS_ERXPFGCDN_EL1              sys_reg(3, 0, 5, 4, 6)
>  #define SYS_ERXMISC0_EL1               sys_reg(3, 0, 5, 5, 0)
>  #define SYS_ERXMISC1_EL1               sys_reg(3, 0, 5, 5, 1)
> +#define SYS_ERXMISC2_EL1               sys_reg(3, 0, 5, 5, 2)
> +#define SYS_ERXMISC3_EL1               sys_reg(3, 0, 5, 5, 3)
>  #define SYS_TFSR_EL1                   sys_reg(3, 0, 5, 6, 0)
>  #define SYS_TFSRE0_EL1                 sys_reg(3, 0, 5, 6, 1)
>
> --
> 2.34.1
>
>

Reviewed-by: Jing Zhang <jingzhangos@google.com>
