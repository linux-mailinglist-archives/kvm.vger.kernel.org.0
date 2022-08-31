Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99035A7AC5
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 12:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiHaKAp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 06:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbiHaKAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 06:00:22 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6523B1A81B
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 02:59:55 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-324ec5a9e97so301903907b3.7
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 02:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=QzmBqQ4SfkIwtO5X0oA1wekRElIR/KPxIyLjjv2vIww=;
        b=Jn/UOdFd29TQgyjWRD619Kb9TnpUTJGMBPtB3Xp6OP9c0eTgGyhxQcRsVl7mYjMFe9
         Wq0WLqYSWTb5Jg8NwQXUgqEXM+flSl+pZLm5EUJo78oWqNCOZtSp9pOpAW1hs4Imw5Bl
         v0InsiLhnhvhdcahZbZjtAFlywsBlQ636e4Vfp6ZvwyS2sqciDveBBp38ECh7AY0ypuc
         sasQLg4Sisa1Ocm6Ygc/2BPuOODDFpp9yRM5oSsAwru7LqOUqGsXOju9klBf6yw80n+n
         qh57UG34fBQExSjn9Jenvpfk4Vaqz6LMQiuohfiHiudzesQ8zPrQen0zFE7FniyHutJn
         7QYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=QzmBqQ4SfkIwtO5X0oA1wekRElIR/KPxIyLjjv2vIww=;
        b=fc/WUuARRzzoGxYzsvYHjK9tsJBLWw9VIC2FIiplpJUhNinFQjMNEpjqI46qeVakVT
         470qMCZbKJRPKZ9uZcuwOA+QEnZXaQVZmud/tyi7655YIhYC80g8gqyLEMFSOiFGbLub
         eUNdH/lFHJbKZUHSWy1VKO9qrx5X8HVKbkAre2z+hmviyHCuHLQ6Af5zM70sJK0jcXJv
         x27+LyuyiUtx9Uj2Y7MtzMwU+G8gYgB3utN7M33KOABoDb/apQbw0pXdNjJ75DlczwMR
         wRFxi7TND4mM5Hr9ne82kCEEI5IK/D8xMG1lNrmtSvuvvQoNw1jycH0oIi8Q6R6LlJyf
         L8Xw==
X-Gm-Message-State: ACgBeo3aAUh+wg0o9V4mIfD8NfVRSz40d04rfLNGFUuULVTOFPVd7xbI
        5dtkZ/wu3YpcL44A7i4NLZVMgKBEF5J2XjyJSfUg0A==
X-Google-Smtp-Source: AA6agR4wjllGpmRdc6agWSxgw1dM9XwI25Q2D+CZ1o/4txWCT3JrDHeo2e3anei3zpySux4Y+pYW8EQFoPFV95xzbl0=
X-Received: by 2002:a81:10a:0:b0:333:618e:190b with SMTP id
 10-20020a81010a000000b00333618e190bmr16067876ywb.10.1661939994069; Wed, 31
 Aug 2022 02:59:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220815101325.477694-1-apatel@ventanamicro.com>
In-Reply-To: <20220815101325.477694-1-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 31 Aug 2022 15:29:42 +0530
Message-ID: <CAAhSdy3XF79M1juW7T_A2YvrZS+rcywDih2xi02=6uius33-0g@mail.gmail.com>
Subject: Re: [PATCH kvmtool 0/5] KVMTOOL RISC-V Svpbmt and Sstc Support
To:     Will Deacon <will@kernel.org>
Cc:     julien.thierry.kdev@gmail.com, maz@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Anup Patel <apatel@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Mon, Aug 15, 2022 at 3:43 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The latest Linux-6.0-rc1 has support for Svpbmt and Sstc extensions
> in KVM RISC-V. This series adds corresponding changes in KVMTOOL to
> allow Guest/VM use these new RISC-V extensions.
>
> The PATCH5 is an unrelated fix which was discovered while developing
> this series.
>
> These patches can also be found in the riscv_svpbmt_sstc_v1 branch
> at: https://github.com/avpatel/kvmtool.git
>
> Anup Patel (3):
>   Update UAPI headers based on Linux-6.0-rc1
>   riscv: Add Svpbmt extension support
>   riscv: Fix serial0 alias path
>
> Atish Patra (2):
>   riscv: Append ISA extensions to the device tree
>   riscv: Add Sstc extension support
>
>  arm/aarch64/include/asm/kvm.h    |  36 ++++++
>  include/linux/kvm.h              | 181 +++++++++++++++++++++++++++++--
>  include/linux/virtio_9p.h        |   2 +-
>  include/linux/virtio_config.h    |   7 +-
>  include/linux/virtio_ids.h       |  14 +--
>  include/linux/virtio_net.h       |  34 +++++-
>  include/linux/virtio_pci.h       |   2 +
>  riscv/fdt.c                      |  44 +++++++-
>  riscv/include/asm/kvm.h          |  22 ++++
>  riscv/include/kvm/kvm-cpu-arch.h |  11 ++
>  riscv/kvm-cpu.c                  |  11 --
>  x86/include/asm/kvm.h            |  33 +++---
>  12 files changed, 352 insertions(+), 45 deletions(-)
>
> --
> 2.34.1
>

Ping ?
Does this series look fine to you ?

Regards,
Anup
