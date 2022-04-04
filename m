Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A214F0DF0
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 06:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377069AbiDDEOQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 00:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357895AbiDDEOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 00:14:15 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA1C23BE9
        for <kvm@vger.kernel.org>; Sun,  3 Apr 2022 21:12:20 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id d5so14885229lfj.9
        for <kvm@vger.kernel.org>; Sun, 03 Apr 2022 21:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WFqQvpKwz9t3MY+vODy7R6BwTMReD9EdP51jpYbflnM=;
        b=ZCKSOsE9fWMUmrSdwyyh4jD0q/OpYUH/QL2SGajWsM7FyBvZRcWnoBFFLEyb6//gy7
         xDoghElluMymqnJk7EtAkzfN1G7LsjBEA96ENW/BTeTClIugzQHyTzi1mHTE2sy83eob
         yLHXP6PoNhvGEzTi0TyBVnZR9bKLwwgF3MiMGPNIySFyYkdeO5IL59o0act2GAvKlxo0
         EtgPgILqxaGDU69VXLnG4iw2UGQEOTQUy6BPYGV2y0C37/eKGJYFaOyOCfGQ0fVGj0zy
         aqoU1quVMMvGtJ6XRxJi6f5lQX3vcnfB6bHHAm65w687o5MCbNeX5bgQs+LdwbadFljW
         OZTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WFqQvpKwz9t3MY+vODy7R6BwTMReD9EdP51jpYbflnM=;
        b=4JqyhIu6b1hzUh3QTxWhggYlqf9CJ45aisG5C+sjaIuhjuLQtbndDLIXhuY9vpO5oj
         YOZNho6bak0vDaOseLRt45ZfI7DeBZA9SaueYNqZOAtEcn/UopcM/qVMC3Bwt0lFMYhY
         p6XA9GImcBjTRl7X+PiB6FVLq2N38YbTZOFTocn9Ev60ViYxC7VUzrnUjFQ9X6L/UeTF
         oIWVmvdO9quIlB/UftVx4tjG1sGya3cHtwWvoFrdYaw7qpEzqrzWFh2D4eAtE8/rQVNw
         NmWY0LSJmNh6nVpmjd1jq+EGirkumBxfZuARDLRf6DNSLn/do2v6w+bHAzq+tVS+YjVs
         VVlQ==
X-Gm-Message-State: AOAM531Y/FChFxzS68PBCTvoICxIf80f7UQHdMX2BDFLa58E2VWJ49fF
        qyQmNDKdhOY7N6YQsWolxx/1pN0AJikrDnGrvSDccazhwFmFN25I
X-Google-Smtp-Source: ABdhPJyinho72oQzNrsFqpzY5lxEeLn5p7+NZqaJLckd4I6rzYec05uSBjtN9ScpP9d9s378wpp70bZ4EoRuAGjAbxs=
X-Received: by 2002:a05:6512:3ca9:b0:44a:fe96:fe0e with SMTP id
 h41-20020a0565123ca900b0044afe96fe0emr3042289lfv.77.1649045538414; Sun, 03
 Apr 2022 21:12:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220329072911.1692766-1-apatel@ventanamicro.com>
In-Reply-To: <20220329072911.1692766-1-apatel@ventanamicro.com>
From:   Mayuresh Chitale <mchitale@ventanamicro.com>
Date:   Mon, 4 Apr 2022 09:41:42 +0530
Message-ID: <CAN37VV4qnjyf96EA-uo7bs1jRavh-oB+eUk08i-6f0RiqCDC-Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] Unexpected guest trap handling for KVM RISC-V selftests
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 29, 2022 at 1:00 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> Getting unexpected guest traps while running KVM RISC-V selftests should
> cause the test to fail appropriately with VCPU register dump. This series
> improves handling of unexpected traps along these lines.
>
> These patches can also be found in riscv_kvm_selftests_unexp_trap_v1 branch
> at: https://github.com/avpatel/linux.git
>
> Anup Patel (3):
>   KVM: selftests: riscv: Set PTE A and D bits in VS-stage page table
>   KVM: selftests: riscv: Fix alignment of the guest_hang() function
>   KVM: selftests: riscv: Improve unexpected guest trap handling
>
>  .../selftests/kvm/include/riscv/processor.h   | 12 ++++---
>  .../selftests/kvm/lib/riscv/processor.c       |  9 +++---
>  tools/testing/selftests/kvm/lib/riscv/ucall.c | 31 +++++++++++++------
>  3 files changed, 34 insertions(+), 18 deletions(-)
>
> --
> 2.25.1
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

I have tested the series on Qemu.

Tested-by: Mayuresh Chitale <mchitale@ventanamicro.com>
