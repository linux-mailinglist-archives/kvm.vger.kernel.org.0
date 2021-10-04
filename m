Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AA44213CC
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 18:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbhJDQQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 12:16:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235847AbhJDQQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 12:16:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD5C5613D5;
        Mon,  4 Oct 2021 16:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633364092;
        bh=8N3io59QQ0yk2xvq79v6A76Jo8igPpKM4ZcyigWQ5Xk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ebCyIDxHlUG0gomlz17oCQQRweYX8uD6LXm8haicom+A9TuGHwa3BLiVh5tNfdx6u
         fgihLk2EwoiAjrnNfNiE8UOxTvOWz8GjndCEZb79KhHGHTlytzOYP/avPd02p/MkNk
         ccI403SPp7EodCAVN148ExuDS0rZKk2Cab9O1N0jUdq09yXA2/dRYWmGgwNGejp6kb
         0MweI5gO0oRivlV4dZwcA9cDUHN/j6YpyzzyPxx5r/4TKyOZf3CfDcV18IsTkJ+7vh
         4LYrnovpV2pfEAHqAV3rZ20UgVDugqgV3Smqn9pVeVbVsdPIgEPaF0HLPjTdqh1+uO
         JBmxl9mzx/BWw==
Received: by mail-ua1-f49.google.com with SMTP id y3so7346415uar.5;
        Mon, 04 Oct 2021 09:14:52 -0700 (PDT)
X-Gm-Message-State: AOAM5314JOLqdoQ8DY9Sbr/mmg1wyfz1BBrvbEGsxVX1JQoWyiLYlfim
        DxlYgFgHkBrqcEyWtVXBRYmak4qiTxfzAcFY0RQ=
X-Google-Smtp-Source: ABdhPJxeJZSlFzH2l7JpmmIxwDMjE+f3XeiQGV3+sNxcCN24QoLwDI3Mc7RY4HQcxewkBtpZ/n4i9Tc16oYFgfV1/5w=
X-Received: by 2002:ab0:5b59:: with SMTP id v25mr7446923uae.57.1633364091998;
 Mon, 04 Oct 2021 09:14:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210927114016.1089328-1-anup.patel@wdc.com> <20210927114016.1089328-18-anup.patel@wdc.com>
In-Reply-To: <20210927114016.1089328-18-anup.patel@wdc.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Tue, 5 Oct 2021 00:14:40 +0800
X-Gmail-Original-Message-ID: <CAJF2gTR8JC+vMQ69t9UJxAf2q1xcYYN3Ecj23GdLEpngVN0YiQ@mail.gmail.com>
Message-ID: <CAJF2gTR8JC+vMQ69t9UJxAf2q1xcYYN3Ecj23GdLEpngVN0YiQ@mail.gmail.com>
Subject: Re: [PATCH v20 17/17] RISC-V: KVM: Add MAINTAINERS entry
To:     Anup Patel <anup.patel@wdc.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Acked-by: Guo Ren <guoren@kernel.org>

On Mon, Sep 27, 2021 at 7:42 PM Anup Patel <anup.patel@wdc.com> wrote:
>
> Add myself as maintainer for KVM RISC-V and Atish as designated reviewer.
>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Alexander Graf <graf@amazon.com>
> ---
>  MAINTAINERS | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5b33791bb8e9..65afc028f4d3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10269,6 +10269,18 @@ F:     arch/powerpc/include/uapi/asm/kvm*
>  F:     arch/powerpc/kernel/kvm*
>  F:     arch/powerpc/kvm/
>
> +KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
> +M:     Anup Patel <anup.patel@wdc.com>
> +R:     Atish Patra <atish.patra@wdc.com>
> +L:     kvm@vger.kernel.org
> +L:     kvm-riscv@lists.infradead.org
> +L:     linux-riscv@lists.infradead.org
> +S:     Maintained
> +T:     git git://github.com/kvm-riscv/linux.git
> +F:     arch/riscv/include/asm/kvm*
> +F:     arch/riscv/include/uapi/asm/kvm*
> +F:     arch/riscv/kvm/
> +
>  KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
>  M:     Christian Borntraeger <borntraeger@de.ibm.com>
>  M:     Janosch Frank <frankja@linux.ibm.com>
> --
> 2.25.1
>


-- 
Best Regards
 Guo Ren

ML: https://lore.kernel.org/linux-csky/
