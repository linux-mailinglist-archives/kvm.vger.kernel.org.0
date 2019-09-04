Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920A9A7960
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 05:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfIDDjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 23:39:47 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37860 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbfIDDjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 23:39:46 -0400
Received: by mail-wm1-f68.google.com with SMTP id r195so1770887wme.2
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 20:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uUvXGKEZoPRwA5Ik3P0dfSDGF8yBJbth8FfpGl8EDP0=;
        b=ngpixdURTCml3W6w0yzV+Rhsvzl0vFP543h/AkMi8pPMOLdXtCsQTfEwUiVSRqLpRg
         ViZIIhvOQe63f80RVhqDlhTCOS3wgE0Oj72X6WYKRSGftAJId8eGdpC6JBAKqm6ZLzCD
         Jj5SSs253BgqPYfMkuxmf1VjvQ2rd9U/vSDHlydFTB6yuR2I594+Eo4/i0zzBp2UoCZZ
         rbcwTM5L1QGThHgSeH9qkLb0dZEWpTP44GQoSJqC12163YLExtnNU8N2Sc5q705qDtDg
         UyanhjDBc42fGoI41lIhgF5jl+jyx3jVe45w6t/zzRw0dH4XAHsJaQVvqtp7d3gw59zs
         DQoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uUvXGKEZoPRwA5Ik3P0dfSDGF8yBJbth8FfpGl8EDP0=;
        b=KGtahby4lki/QOibZ98YDRWGllb5lVsfA0wt1nhcNLETugeWbv518Y4oPTDUdqguR7
         xODmbCCBfJMhggcSl0kxXY64rQd5DGBIpXeOSlvZcL5pMa7pljFiqadI3wW64ULP81Gh
         6yYGS0E4Iym9F+823FN/7Pu1k7nqieIya4HzJssQz54Y2dwZIdn6Cbrnblh2vPNDtWeM
         ezo0KAJWHq/qRlM45yO8my2VjPeEu3AdS3hSZvQIzDKMpCR59XF5QfG2zvrYkPw3eq1i
         5nuTzeT0sukzEzGObK/v3Myzopl/s01wR7K+HwkKM2olKEfYvvQy4BjdSIelcUpvLMQZ
         JBAg==
X-Gm-Message-State: APjAAAUmqfCUA3/f1tXULuxPjPtGBFj+Q/be5GsWQrV9jwDZR84C/0A2
        dD76qQ9TctsgBHS19oxoPUJja0My0dnLA3OobuDLXw==
X-Google-Smtp-Source: APXvYqz0n5ioObrdz8U18x0DJ5xS+gtleSKoC8A+H7ZQqzLl9D+NvFGtDBCQUuUQr+XBDPAJjSBLpSXEFqdf7CWjOEA=
X-Received: by 2002:a1c:a697:: with SMTP id p145mr2227587wme.24.1567568384117;
 Tue, 03 Sep 2019 20:39:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190829135427.47808-1-anup.patel@wdc.com> <20190829135427.47808-22-anup.patel@wdc.com>
In-Reply-To: <20190829135427.47808-22-anup.patel@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 4 Sep 2019 09:09:32 +0530
Message-ID: <CAAhSdy3bywQhOdt4ymNwHh=VAH8D0-qK_PRy+J0s1rTe=+d=mg@mail.gmail.com>
Subject: Re: [PATCH v6 21/21] RISC-V: KVM: Add MAINTAINERS entry
To:     Anup Patel <Anup.Patel@wdc.com>
Cc:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 7:27 PM Anup Patel <Anup.Patel@wdc.com> wrote:
>
> Add myself as maintainer for KVM RISC-V as Atish as designated reviewer.
>
> For time being, we use my GitHub repo as KVM RISC-V gitrepo. We will
> update this once we have common KVM RISC-V gitrepo under kernel.org.
>
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Alexander Graf <graf@amazon.com>
> ---
>  MAINTAINERS | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9cbcf167bdd0..b4952516fc32 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8869,6 +8869,16 @@ F:       arch/powerpc/include/asm/kvm*
>  F:     arch/powerpc/kvm/
>  F:     arch/powerpc/kernel/kvm*
>
> +KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
> +M:     Anup Patel <anup.patel@wdc.com>
> +R:     Atish Patra <atish.patra@wdc.com>
> +L:     kvm@vger.kernel.org
> +T:     git git://github.com/avpatel/linux.git

We have created a shared tree (between Me and Atish) at:
git://github.com/kvm-riscv/linux.git

I will use this new repo as KVM RISC-V tree in v7 patches.

Regards,
Anup

> +S:     Maintained
> +F:     arch/riscv/include/uapi/asm/kvm*
> +F:     arch/riscv/include/asm/kvm*
> +F:     arch/riscv/kvm/
> +
>  KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
>  M:     Christian Borntraeger <borntraeger@de.ibm.com>
>  M:     Janosch Frank <frankja@linux.ibm.com>
> --
> 2.17.1
>
