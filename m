Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17146416BB
	for <lists+kvm@lfdr.de>; Sat,  3 Dec 2022 13:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLCMj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Dec 2022 07:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiLCMj1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Dec 2022 07:39:27 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE63A4509E
        for <kvm@vger.kernel.org>; Sat,  3 Dec 2022 04:39:25 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id bj12so17364078ejb.13
        for <kvm@vger.kernel.org>; Sat, 03 Dec 2022 04:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=49SXpg0viIkcd9bV8ou6W/kCNoCZOtgNWC4CjYCXnhU=;
        b=PSTRveg6xO09Jyy+2/f2eLu36Tno0cVpPwpwXi9Gu0+hXkz/8ZfMI8nWVYHCvqgMTJ
         Ot8/3Q0QXgUxtA27R659zoq98WRQrJCcLAMlCJwcrF2Vqus1J1e0qTLSekNBe4BywpyJ
         t59GrHwUNZknHU7H1DpEERVsYvqzGoLM+Ly4Qac0I1GkhktyRepwAXUzUklqLusqDTga
         ZDNzQ7/cP0C1IW8wl+E8QIPmG1S79hDkXB2OB+rStgOzS4LwK6lsrl8uhafBCc5vs0im
         TDIGp1zVCsPeeIP968heikMn6TPo08tmgkrC4lYh2hxHOQZGcuHGAT54Gf6DjjEwV0nY
         v3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=49SXpg0viIkcd9bV8ou6W/kCNoCZOtgNWC4CjYCXnhU=;
        b=qcRC2fhnxHKz0T8ETAG31lDcUZxR4CaqxLQAgdal98aWabN96N4dD8Ok8hswMcH9Vl
         i6STwDlSJR5VCnQfLFMywhrcNKtFnrEzgj6TGQClEE+xSJiibTzr7A5Xetgj2daKr1cQ
         q2wjiUKbSbPFUHRp2wlywI+DuKgDul6lTLQjr5vdjWk1vg+5dqoskDn5jdJ4r4kXKLAV
         sT5XDU/uoYAT7G4SrBfnMfx06YY0LyS2xkb52IG5rMK0Al+xAEcIBaZnIkspfA8Dbkwj
         ue1Lw4HVoRQWse6YlEOUWTaxlLsG3QaKEkEX+sUoXiqpLafJ9rZwP6EYQtilKWdtEBEF
         7MLg==
X-Gm-Message-State: ANoB5pkfRqwGBACfJAYgWczpkqoI9WykHOO8qTD1wWoihCeWnqxVWOVT
        llgIYl0rk6Ceh0FFsXV7/2mKWc9c+a4ED7PHz45Maw==
X-Google-Smtp-Source: AA0mqf65SciKagO59wuSYI5TKINseWpYtrCqxKUmH8YoaR4LIG9Igwh+LUO0IcFlL22PHHxL34aI2lZmWL3oY3TVBCY=
X-Received: by 2002:a17:906:6dd5:b0:78d:a633:b55 with SMTP id
 j21-20020a1709066dd500b0078da6330b55mr66280507ejt.106.1670071164294; Sat, 03
 Dec 2022 04:39:24 -0800 (PST)
MIME-Version: 1.0
References: <20221128161424.608889-1-apatel@ventanamicro.com>
In-Reply-To: <20221128161424.608889-1-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 3 Dec 2022 18:09:11 +0530
Message-ID: <CAAhSdy1b=uzQqaBAkysHzFtSC+ftrTEryqLT03SPrBtyTKjuWQ@mail.gmail.com>
Subject: Re: [PATCH 0/9] RISC-V KVM ONE_REG interface for SBI
To:     Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 28, 2022 at 9:44 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> This series does first does few cleanups/fixes (PATCH1 to PATCH5) and
> adds ONE-REG interface for customizing the SBI interface visible to the
> Guest/VM.
>
> The testing of this series has been done with KVMTOOL changes in
> riscv_sbi_imp_v1 branch at:
> https://github.com/avpatel/kvmtool.git
>
> These patches can also be found in the riscv_kvm_sbi_imp_v1 branch at:
> https://github.com/avpatel/linux.git
>
> Anup Patel (9):
>   RISC-V: KVM: Fix reg_val check in kvm_riscv_vcpu_set_reg_config()
>   RISC-V: KVM: Remove redundant includes of asm/kvm_vcpu_timer.h
>   RISC-V: KVM: Remove redundant includes of asm/csr.h
>   RISC-V: KVM: Use switch-case in kvm_riscv_vcpu_set/get_reg()
>   RISC-V: KVM: Move sbi related struct and functions to kvm_vcpu_sbi.h
>   RISC-V: Export sbi_get_mvendorid() and friends
>   RISC-V: KVM: Save mvendorid, marchid, and mimpid when creating VCPU
>   RISC-V: KVM: Add ONE_REG interface for mvendorid, marchid, and mimpid
>   RISC-V: KVM: Add ONE_REG interface to enable/disable SBI extensions

I have queued PATCH1 to PATCH8 for Linux-6.2.

I have deferred PATCH9 until we have an agreement about how to deal
with VM-level attributes. This is also required for the KVM SBI PMU series.

>
>  arch/riscv/include/asm/kvm_host.h     |  16 ++-
>  arch/riscv/include/asm/kvm_vcpu_sbi.h |  14 ++-
>  arch/riscv/include/uapi/asm/kvm.h     |  22 ++++
>  arch/riscv/kernel/sbi.c               |   3 +
>  arch/riscv/kvm/vcpu.c                 |  82 +++++++++++----
>  arch/riscv/kvm/vcpu_sbi.c             | 145 +++++++++++++++++++++++---
>  arch/riscv/kvm/vcpu_sbi_base.c        |  15 ++-
>  arch/riscv/kvm/vcpu_sbi_hsm.c         |   1 -
>  arch/riscv/kvm/vcpu_sbi_replace.c     |   1 -
>  arch/riscv/kvm/vcpu_sbi_v01.c         |   1 -
>  10 files changed, 244 insertions(+), 56 deletions(-)
>
> --
> 2.34.1
>

Thanks,
Anup
