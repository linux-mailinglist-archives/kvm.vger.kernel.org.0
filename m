Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D329A61F2CD
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 13:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbiKGMUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 07:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbiKGMUb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 07:20:31 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F019DDD
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 04:20:30 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id f37so16482162lfv.8
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 04:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W4qVmtdtsOYLjQjBgLRdoIxGi6c/8f3yervFBdudmQ0=;
        b=OVtlb58V54BzlnZLJs8ewH4vHiZbGxVl1S56uIOoH99CNF8uDxkgtAUxMBvcw+hFaf
         Td90a34LEq7ELleSQi0XLnAZ8o/cLZBz79Ro90RxQIAZsx/Uly/Nyj9f5ZDvVkpZt6HF
         5eqmU3m1lLNK/RT0M2ZGwMlVbEVaEiKf7FVtibNnHP9ZfmBkTemc8mui4uLjCeMQAR8i
         JDJDHkJRctJDrUNUXVoROT4OuuO9YdUfAW5rvLkNlWOVOEYGNamv2GOeXkvqjMTIAPNo
         1+Ij/TqUylpCpY81R2V/r6SBIcckag9EdBrvG/WgAY6h+zSwt0/VT4v9WXp6CXF5/O8Z
         ClBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W4qVmtdtsOYLjQjBgLRdoIxGi6c/8f3yervFBdudmQ0=;
        b=ZEAuEXQ6KO0wU7h/JbD/c8Fg9Ye84vk9KECvM+cR7W+RfbKcCC2GqEaFwIDbuVAbfQ
         7ixnLoXV5i8OqgEpRNptf5EigQOLj4ZI1H33+Yzbb1HKxmXvDEq7BFcLeFiK3TcgRDtv
         rpWqNUFEX+V8LYCnvB8l721sZzTs/f7MxTb2jWmDD48a6RtrsYfZMjnekSanNnhmT+w2
         wXyiAhlXMNU53SbBJaJfUsA71fdbocxb2mbtxBbGADf9d8GOpV4XDHccl+9osPNtMVMB
         l77vmXjgBEDk2PhcXfM7ySkpSGGyyaspKLMhjchHFlY1291OjL9Tj/Ev4ziVM+fzmFdU
         rC9g==
X-Gm-Message-State: ACrzQf0tOcpYj32dVv+Xp9LOlT+CE2d5+t6t12sIRyR6nkrtIxu/y9Eg
        1h7lVyAb3RnSpVLtTkFIqY1N9i4m+sEfcZJjzSy88nvbbDM=
X-Google-Smtp-Source: AMsMyM64VZpv0ezlW602gT2S0f2DnygLTxKJjwPlsB1/Zk4AZcpGF02E6wNTEK+z1bhSrzo3V6C2h7e1J1adldg3v9Y=
X-Received: by 2002:a05:6512:3d1d:b0:4a2:48c8:8a29 with SMTP id
 d29-20020a0565123d1d00b004a248c88a29mr19768045lfv.552.1667823628371; Mon, 07
 Nov 2022 04:20:28 -0800 (PST)
MIME-Version: 1.0
References: <20221018140854.69846-1-apatel@ventanamicro.com>
In-Reply-To: <20221018140854.69846-1-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 7 Nov 2022 17:50:16 +0530
Message-ID: <CAAhSdy0KcB9_0zh9eHECW1PLN+zAAEpyL5zPWT4VB_8fQ5+4Yw@mail.gmail.com>
Subject: Re: [PATCH kvmtool 0/6] RISC-V Svinval, Zihintpause, anad Zicbom support
To:     Will Deacon <will@kernel.org>
Cc:     julien.thierry.kdev@gmail.com, maz@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        Anup Patel <apatel@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Tue, Oct 18, 2022 at 7:39 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The latest Linux-6.1-rc1 has support for Svinval, Zihintpause and Zicbom
> extensions in KVM RISC-V. This series adds corresponding changes in KVMTOOL
> to allow Guest/VM use these new RISC-V extensions.
>
> These patches can also be found in the riscv_svinval_zihintpause_zicbom_v1
> branch at: https://github.com/avpatel/kvmtool.git
>
> Andrew Jones (2):
>   riscv: Move reg encoding helpers to kvm-cpu-arch.h
>   riscv: Add Zicbom extension support
>
> Anup Patel (3):
>   Update UAPI headers based on Linux-6.1-rc1
>   riscv: Add Svinval extension support
>   riscv: Add --disable-<xyz> options to allow user disable extensions
>
> Mayuresh Chitale (1):
>   riscv: Add zihintpause extension support
>
>  arm/aarch64/include/asm/kvm.h       |  6 ++++--
>  include/linux/kvm.h                 |  1 +
>  include/linux/virtio_blk.h          | 19 +++++++++++++++++++
>  include/linux/virtio_net.h          | 14 +++++++-------
>  include/linux/virtio_ring.h         | 16 +++++++++++-----
>  riscv/fdt.c                         | 23 +++++++++++++++++++++--
>  riscv/include/asm/kvm.h             |  4 ++++
>  riscv/include/kvm/kvm-config-arch.h | 18 +++++++++++++++++-
>  riscv/include/kvm/kvm-cpu-arch.h    | 19 +++++++++++++++++++
>  riscv/kvm-cpu.c                     | 16 ----------------
>  10 files changed, 103 insertions(+), 33 deletions(-)
>
> --
> 2.34.1
>

Friendly ping ?

Please check this series.

Regards,
Anup
