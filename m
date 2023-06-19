Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD8F7351FD
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 12:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbjFSK1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 06:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbjFSK1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 06:27:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDE7CC;
        Mon, 19 Jun 2023 03:26:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09B1160B62;
        Mon, 19 Jun 2023 10:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C3BC433D9;
        Mon, 19 Jun 2023 10:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687170418;
        bh=zAWNp/0OevPlEumSMuoU5Y4Hpba4Lhjq2T2D+MmMvi4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KkIRVchWQt8snKjWz1ozkzFISuDSJXgN4Hd7pXlJkT1nkFfF3RSFJMh2RMODMKL+d
         aVYUfASCyM2wdrGODtghwClop/0ed1toAUL/A/ZIHlwhfovd3fba4CzTKdKlSltyDJ
         9AoMqceG1+mT9+iJGUMgTMYArg/Q8N4VgDkNoJbpcZCu0RJUZJ6GfDCOXC6SIRcx7R
         aKeR4l1Fzw01sXnXPiR4qC8fMZ+7k1huyIRkVQokDuSp8jpT4RctE/zgArDS6I5iXw
         l2bLy+XgXVAnrAh7CjSqhbtbJrdnr7+Vfp7u6FVGb6r8AIlRJFuQFaoK1nS+S60Vwr
         yT0odXu52NBgA==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-51a5eec783cso695445a12.3;
        Mon, 19 Jun 2023 03:26:58 -0700 (PDT)
X-Gm-Message-State: AC+VfDxI8a1Wl7YV7OEBW6pc/aJ67o6xwXVJvWfrDj36LhRf2METbKfS
        0rBGXL8OXvBy85p5Dmn1Szp4D4zffEs0K1X4bAM=
X-Google-Smtp-Source: ACHHUZ4WwxL5yors7KJm1bcfEb2YvEOjkPYFbwGAjbdYHq9/9owWJGxbXPD1yJshlqOR5mMPrJ7DRjMAZBdaTIHF2f0=
X-Received: by 2002:a05:6402:218:b0:517:6ed9:662d with SMTP id
 t24-20020a056402021800b005176ed9662dmr6288901edv.19.1687170416744; Mon, 19
 Jun 2023 03:26:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230619083255.3841777-1-zhaotianrui@loongson.cn> <20230619083255.3841777-31-zhaotianrui@loongson.cn>
In-Reply-To: <20230619083255.3841777-31-zhaotianrui@loongson.cn>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Mon, 19 Jun 2023 18:26:45 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5Aknzi2j2S76JSDjJrRF2dGra68zWV-+FL29XDX0C6Rw@mail.gmail.com>
Message-ID: <CAAhV-H5Aknzi2j2S76JSDjJrRF2dGra68zWV-+FL29XDX0C6Rw@mail.gmail.com>
Subject: Re: [PATCH v14 30/30] LoongArch: KVM: Add maintainers for LoongArch KVM
To:     Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, tangyouling@loongson.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Acked-by: Huacai Chen <chenhuacai@loongson.cn>

On Mon, Jun 19, 2023 at 4:33=E2=80=AFPM Tianrui Zhao <zhaotianrui@loongson.=
cn> wrote:
>
> Add maintainers for LoongArch KVM.
>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  MAINTAINERS | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 27ef11624748..44db717f90c2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11357,6 +11357,18 @@ F:     include/kvm/arm_*
>  F:     tools/testing/selftests/kvm/*/aarch64/
>  F:     tools/testing/selftests/kvm/aarch64/
>
> +KERNEL VIRTUAL MACHINE FOR LOONGARCH (KVM/LoongArch)
> +M:     Tianrui Zhao <zhaotianrui@loongson.cn>
> +M:     Bibo Mao <maobibo@loongson.cn>
> +M:     Huacai Chen <chenhuacai@kernel.org>
> +L:     kvm@vger.kernel.org
> +L:     loongarch@lists.linux.dev
> +S:     Maintained
> +T:     git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
> +F:     arch/loongarch/include/asm/kvm*
> +F:     arch/loongarch/include/uapi/asm/kvm*
> +F:     arch/loongarch/kvm/
> +
>  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
>  M:     Huacai Chen <chenhuacai@kernel.org>
>  M:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> --
> 2.39.1
>
