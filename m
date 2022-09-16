Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9DF5BA631
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 06:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiIPE7i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 00:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiIPE7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 00:59:20 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E260A2615
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 21:59:10 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id g8so13966162iob.0
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 21:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=9wX0Os/v3fWWsqmWeRj6d/WnVKZOSdCwMBBhNWRxR70=;
        b=Zsq7Sluoau0Y8EpRoGjXEFmrki9+nCAvyXbkwbUsj1GZWAINsUoO2X3jW5YQxpWD+H
         arWfeMPFscfb/P6b+WvdXfdmnZy9NTj0/PCTy7yijgkOUCOC/+kQB+YhfAzlfoDvbiNs
         6bup61heaUz3XJgBcTW5V4ubRkY7MYkAPt1qp3EEjYNunDAXEFqZPkx3Fud/zLDhaAny
         hNIvmbVe8zwa7pRlMrNdQVZwsl9hzznP6piNGuhgraDCph7oKU9fmxRn//8NIsNfcLhZ
         at2naX0NQAeOHDTF5BCF9KgZ4GUVjSu4+sS7SdERQDePG3HScSsuBZTmxK7LD8v7t9Zb
         zInQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=9wX0Os/v3fWWsqmWeRj6d/WnVKZOSdCwMBBhNWRxR70=;
        b=5q8ulqlCpk0ZENTMZjhCsXw+7usB2aFT06T3Xbg8yijowLCObrNet79o5MxAtPaRuu
         KJUMOe/LjgSP5loMYzJWEWVCobrwAjmsXj0WpY6PPEFBhBj06kz8YrCZ5oMElqb53EZP
         XtiqXdFttpNxtsut6z5Or82p6O5EERhdZfakIwV35syCOlQjIEUbLCV+dJZyP5+t+atD
         EcXu8XdtjGPYEjk2fqY++xsiRuP3G1JAeDwp5apCPEECrSlXD3f3DuPdz3/MppObNsWB
         35yYCMhEZGm/qU0gRNaST9wzNi7hOhKt62/9zkWFzs2Serw75VlDErRlJ5UlQQ4guOCa
         YmfQ==
X-Gm-Message-State: ACrzQf0Izf3KSwi/XfRYK7lJ/pmnMYRIR7t3m1/avk101kxCK8O/xgb+
        3NnBG+X91cnvsQL6pqH+igzVbGknUbsDcg70t36EIVX8JSc=
X-Google-Smtp-Source: AMsMyM5izN6DIFJa0XyJ9EbNwioGVgvdO48cBsD4pTMfjEZje20lI/t2JQnMc5Gs7iZWgkq88k9bwa0WD7YaiVcyAMY=
X-Received: by 2002:a05:6638:270d:b0:35a:6246:ba76 with SMTP id
 m13-20020a056638270d00b0035a6246ba76mr1633632jav.263.1663304348836; Thu, 15
 Sep 2022 21:59:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220902170131.32334-1-apatel@ventanamicro.com>
In-Reply-To: <20220902170131.32334-1-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 16 Sep 2022 10:28:56 +0530
Message-ID: <CAAhSdy1iDXMhE_MVdj9JDu8XHXiV_Ci=aLVqQG7r-m6d28aAdw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Svinval support for KVM RISC-V
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 2, 2022 at 10:31 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> This series adds Svinval extension support for both Host hypervisor
> and Guest.
>
> These patches can also be found in riscv_kvm_svinval_v1 branch at:
> https://github.com/avpatel/linux.git
>
> The corresponding KVMTOOL patches are available in riscv_svinval_v1
> branch at: https://github.com/avpatel/kvmtool.git
>
> Anup Patel (2):
>   RISC-V: KVM: Use Svinval for local TLB maintenance when available
>   RISC-V: KVM: Allow Guest use Svinval extension
>
> Mayuresh Chitale (1):
>   RISC-V: Probe Svinval extension form ISA string

I have queued this series for 6.1

Thanks,
Anup

>
>  arch/riscv/include/asm/hwcap.h    |  4 +++
>  arch/riscv/include/asm/insn-def.h | 20 +++++++++++
>  arch/riscv/include/uapi/asm/kvm.h |  1 +
>  arch/riscv/kernel/cpu.c           |  1 +
>  arch/riscv/kernel/cpufeature.c    |  1 +
>  arch/riscv/kvm/tlb.c              | 60 ++++++++++++++++++++++++-------
>  arch/riscv/kvm/vcpu.c             |  2 ++
>  7 files changed, 77 insertions(+), 12 deletions(-)
>
> --
> 2.34.1
>
