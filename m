Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABAB1C4795
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 22:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgEDUBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 16:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728081AbgEDUB3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 16:01:29 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9265FC061A41
        for <kvm@vger.kernel.org>; Mon,  4 May 2020 13:01:29 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f15so226720plr.3
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 13:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=ZFRO3RhADYIeDpbw4dnAWyjVt7yzrlI/aPmG+9d8qeE=;
        b=qrHszcJGGSIsCedROR57TweuB7bX5mbZsxDa1hb+YaSY5m/twRdgsGDaKjFpj1FT4N
         V3ECCU3uh6lis3rOAqcfqTQFIoLtc4zGPki5ISHQzFRgDjGkRwdfSu8CkSBUiSKcJgiN
         NM4EF5poDdfcNB/62wYhnyLMSNCzCJpcWte6mNPF9NsqMNcZhm0uMDZQWCgNOYDo1Ohu
         GlAjPDD1qGAC1SHA99cElOMjxrhYtOKW+YnG3vVMHZXdgDCy9UwHxWSNR0bKV3na+jYG
         eJUzGB70l7kBEHhrWRgbWMAsO+hihmceg9Zo2H2vXXs0My0GoiqKsOph6Z3gBJZL0qwe
         pXIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=ZFRO3RhADYIeDpbw4dnAWyjVt7yzrlI/aPmG+9d8qeE=;
        b=Ww1uH8B7wBu6HeiFeXhzKsamx3aeR28KYU1d1swHr4Sq/k18PPSQ6Tu7QD64XtRn7/
         jUSiu3BWXLIy5r/TkQSyeFXLLhnwWOaSexsNK67FK/YUGmz4nIPnrJb17D3dinHN7XDa
         dTmgP8M/iTKlLAZSvlIVytzIPoR+7LaXL6610nighs1tybu4mU/fLANT7nSa1WVCOnmp
         YMSiPiYC/AfhyIhgBtW9eglbaU8MgcgDb8saEmjEqvcmdQrwE6Y/AToqgD6FX3XnRwOX
         aoJ5v6QFihNdI15ByA/0w/UH5e2rufahR4Q/OobE6hkp7pS+S6gvT2GqpPbPkIwaNYlQ
         vsfA==
X-Gm-Message-State: AGi0PuZX4oCl7njePGiwP54P769dmCLY7ll9lrpk5lIM49NQtLIKT/fx
        8i+nR9uFdI+BbhmqXuzMDJqPng==
X-Google-Smtp-Source: APiQypIFC8V36B+W7lp+3i/NHiQ8u4AgxMSexVW/Rp60TpLxCPv8LY5YL73POlfEskWD07QJhyN/kQ==
X-Received: by 2002:a17:902:8497:: with SMTP id c23mr868287plo.335.1588622488940;
        Mon, 04 May 2020 13:01:28 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id p189sm9716682pfp.135.2020.05.04.13.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 13:01:28 -0700 (PDT)
Date:   Mon, 04 May 2020 13:01:28 -0700 (PDT)
X-Google-Original-Date: Mon, 04 May 2020 13:01:06 PDT (-0700)
Subject:     Re: [PATCH 0/3] RISC-V KVM preparation
In-Reply-To: <20200424045928.79324-1-anup.patel@wdc.com>
CC:     Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
        pbonzini@redhat.com, Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <Anup.Patel@wdc.com>
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     Anup Patel <Anup.Patel@wdc.com>
Message-ID: <mhng-be6b9ad5-d81c-4ae1-9eed-9b2d63600b37@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Apr 2020 21:59:25 PDT (-0700), Anup Patel wrote:
> This patch series is factored-out from the KVM RISC-V v11 series and is
> based upon Linux-5.7-rc2.
>
> These patches are mostly preparatory changes in Linux RISC-V kernel which
> we require for KVM RISC-V implementation. Also, most of these patches are
> already reviewed as part of original KVM RISC-V series.
>
> Anup Patel (3):
>   RISC-V: Export riscv_cpuid_to_hartid_mask() API
>   RISC-V: Add bitmap reprensenting ISA features common across CPUs
>   RISC-V: Remove N-extension related defines
>
>  arch/riscv/include/asm/csr.h   |  3 --
>  arch/riscv/include/asm/hwcap.h | 22 +++++++++
>  arch/riscv/kernel/cpufeature.c | 83 ++++++++++++++++++++++++++++++++--
>  arch/riscv/kernel/smp.c        |  2 +
>  4 files changed, 104 insertions(+), 6 deletions(-)

These are on fixes.
