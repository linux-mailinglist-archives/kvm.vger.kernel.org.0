Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08A84D0FA6
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 06:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243758AbiCHF6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 00:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240804AbiCHF6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 00:58:40 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2641ADB9
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 21:57:44 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id u10so25061399wra.9
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 21:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xIgw1CeMnBUIL/RC29fGtIeWMwiFcbnmOLdGCa76gaY=;
        b=dyvq9P0JTvA5h9bwOZCVBY5lenifpgc/O9PVmslobo52K48eIMdPbQL3M6uKNg281M
         +lkM0gl7OVKvD7qvptTyaWiBj99ozuZByicKHUS5T7G1Iak5aNnOrh6oDpNFvmch18YF
         UiYbwAV5ql7/skjeygZ03JFBTPS8LbT3TShde2YV9aMc/w526q9nwjdiAbNcOKBVuZFM
         LTBM/yoLYFCr+So/Gqt2O7XHXe9JoymfvZBYu3asQGaV2917CGOOH4GrlnZ/q52zuiKN
         u1GG+8BvXTdm3oZWlTi47HUQ9fzztnkbktKIRb4ysX785/wQrwIM6jdxBfjiy2TjJqcc
         fe3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xIgw1CeMnBUIL/RC29fGtIeWMwiFcbnmOLdGCa76gaY=;
        b=I+yKIeKkinTRpLnfWedCkbFcfJKQxtNl9BRa5aVezeUIKWA+zs3+Y8aF4EFyfppoD/
         gkNCNXapXxjyFEpguuitf4k916NxxqqC0jmbKHnBc6jdeUo6PYb4RJyQ0grp559h8S6g
         Bw+GMhpOpAguj+0Ic+BUJ/H74B7jjYoRtIpbyFPgxiJkHUJbEVcRjBSI5qInLUy4PHp0
         5/NFIEIO8DXvseGhex23R02pZ7ELoRAAbPBzNLQn4vvAyJGchbyyWM2baYiozzkFmi+7
         XczcqoARc9mpkefyUQXie19iXNQkOX50j4LPB2fGNmgy2kKkagwMm+f+75vungImy2Cd
         hGIw==
X-Gm-Message-State: AOAM531lU8I8MNO4MxyKegTIQu6110xHikHIF9633OSW6cUnzAbuea/Z
        9MgTpA/+lntiS0pmbwP0Ur5gey4S4szaxHZsqi17vg==
X-Google-Smtp-Source: ABdhPJyWy1Uyhyu9cuDZx89dRaND7TYseZQ1e/hZSNiya6vyhdBIBdrrXDP7oYGdjQ+148oOJJ8ZEA6K8aOTFu9rDjg=
X-Received: by 2002:adf:b60c:0:b0:1f0:227d:bce with SMTP id
 f12-20020adfb60c000000b001f0227d0bcemr10946306wre.313.1646719062630; Mon, 07
 Mar 2022 21:57:42 -0800 (PST)
MIME-Version: 1.0
References: <20220201082227.361967-1-apatel@ventanamicro.com>
In-Reply-To: <20220201082227.361967-1-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 8 Mar 2022 11:27:30 +0530
Message-ID: <CAAhSdy3JwLyOoNOubAS2VusNdj6O-CJJNSs+mM8+NvKErtAdmw@mail.gmail.com>
Subject: Re: [PATCH 0/6] KVM RISC-V SBI v0.3 support
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 1, 2022 at 1:53 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> This series adds initial support for SBI v0.3 which includes:
> 1) SBI SRST support for Guest
> 2) SBI HSM suspend for Guest
>
> The SBI PMU support is intentionally left out and will be added as
> a separate patch series.
>
> These patches can also be found in riscv_kvm_sbi_v03_v1 branch at:
> https://github.com/avpatel/linux.git

Queued this series for Linux-5.18

Thanks,
Anup

>
> Anup Patel (6):
>   RISC-V: KVM: Upgrade SBI spec version to v0.3
>   RISC-V: KVM: Add common kvm_riscv_vcpu_sbi_system_reset() function
>   RISC-V: KVM: Implement SBI v0.3 SRST extension
>   RISC-V: Add SBI HSM suspend related defines
>   RISC-V: KVM: Add common kvm_riscv_vcpu_wfi() function
>   RISC-V: KVM: Implement SBI HSM suspend call
>
>  arch/riscv/include/asm/kvm_host.h     |  1 +
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  5 ++-
>  arch/riscv/include/asm/sbi.h          | 27 +++++++++++++---
>  arch/riscv/kernel/cpu_ops_sbi.c       |  2 +-
>  arch/riscv/kvm/vcpu_exit.c            | 22 ++++++++++----
>  arch/riscv/kvm/vcpu_sbi.c             | 19 ++++++++++++
>  arch/riscv/kvm/vcpu_sbi_hsm.c         | 18 +++++++++--
>  arch/riscv/kvm/vcpu_sbi_replace.c     | 44 +++++++++++++++++++++++++++
>  arch/riscv/kvm/vcpu_sbi_v01.c         | 18 ++---------
>  9 files changed, 125 insertions(+), 31 deletions(-)
>
> --
> 2.25.1
>
