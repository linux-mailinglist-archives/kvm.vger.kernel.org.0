Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0922DBB4E
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 07:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgLPGkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 01:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgLPGkc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 01:40:32 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BD8C061793
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 22:39:51 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id c133so1266110wme.4
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 22:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D2WX4BJNgPr14mjH5ANRJS9xRn9sZjWoS3pkajHG8ik=;
        b=t9Jk6TN+Xdn7N2J4C9Ul6oyPqO8ZAgwiJ/3y8T8GedM5a5cf5xYyPdM9pHU0GfS7oa
         ct0gLiBiaOAt2BNf+5bXAPAdKD1RrerKcVhA2LzMPJQoAIcvwAeqVXr/mKmXP226mkYb
         ahRQNGQOED2ZwbPTBjEGCy9rsybOSXLtHfTC+QblOyZdctdEvz/KZVgmg5GLm7odTL6v
         UHdN8qIvbWte8niqnnvElbF7jmWMiMNUYcALmRKh7Q3ZL1rqldfcTWIvq6U2vSjnNYzV
         YCtLRY86IUmdsBuPF4qzayylXHbqTRqVMl/E5C86IQ/yOrH0GC3PHps/hu4S3fn6vo6C
         kTnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D2WX4BJNgPr14mjH5ANRJS9xRn9sZjWoS3pkajHG8ik=;
        b=krM380kPcQTPy4i5rwzpU8w8NT4vr9aobVTqfqYhUri4nDFhvrHzI+/EMkWQZXZocu
         XrB9ATvsmNr2ODXHkVayXReY1qoSowKigf9W0VQ7eEn8Js3xjTXtoEplRExf1He3n894
         /SQOFulPu901N21kVucSo4LAQiza4vjvQ7PyQoRWKi9I8Zie0KrXmN85ymMoHCvij352
         rDqFhpB3pNArfeE5gjWu+m9OxK6FYBAlRBvjNz/C8lc2liWXjUX2DUzTEDPGZgT9Vkhe
         feV9PSAp9x2DCkAIUeBSSPb72Z7lS0ZuTXqwcGuOoAtEgoJiGmYKrAXsurwhBuikDo4P
         foKg==
X-Gm-Message-State: AOAM532helFV3pUa8Ej1cBxq0KClvkX9u1ZQiJDU8D1gFvJpjtvesgTv
        JDo3dRjLGXB6IzeDCRz5zgwwMkPr9u7W7FT45Z05BQ==
X-Google-Smtp-Source: ABdhPJza0WaG4LzV9VqnXDbFNlAIslEWZ15sdQNLzO6N6ZZqXpkshRy9WqBSeh0M06scmtdZwHOPfU+RfMG2qA3C50A=
X-Received: by 2002:a1c:7f52:: with SMTP id a79mr1654697wmd.157.1608100790213;
 Tue, 15 Dec 2020 22:39:50 -0800 (PST)
MIME-Version: 1.0
References: <20201203121839.308-1-jiangyifei@huawei.com>
In-Reply-To: <20201203121839.308-1-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 16 Dec 2020 12:09:38 +0530
Message-ID: <CAAhSdy2zdwfOGFUtakhbeDUJBapz6fWPnQptT7nCdyFMSoLyGg@mail.gmail.com>
Subject: Re: [PATCH RFC 0/3] Implement guest time scaling in RISC-V KVM
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     Anup Patel <anup.patel@wdc.com>, Atish Patra <atish.patra@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>,
        KVM General <kvm@vger.kernel.org>,
        yinyipeng <yinyipeng1@huawei.com>,
        "Zhangxiaofeng (F)" <victor.zhangxiaofeng@huawei.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "dengkai (A)" <dengkai1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 3, 2020 at 5:51 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> This series implements guest time scaling based on RDTIME instruction
> emulation so that we can allow migrating Guest/VM across Hosts with
> different time frequency.
>
> Why not through para-virt. From arm's experience[1], para-virt implementation
> doesn't really solve the problem for the following two main reasons:
> - RDTIME not only be used in linux, but also in firmware and userspace.
> - It is difficult to be compatible with nested virtualization.

I think this approach is rather incomplete. Also, I don't see how para-virt
time scaling will be difficult for nested virtualization.

If trap-n-emulate TIME CSR for Guest Linux then it will have significant
performance impact of systems where TIME CSR is implemented in HW.

Best approach will be to have VDSO-style para-virt time-scale SBI calls
(similar to what KVM x86 does). If the Guest software (Linux/Bootloader)
does not enable para-virt time-scaling then we trap-n-emulate TIME CSR
(this series).

Please propose VDSO-style para-virt time-scale SBI call and expand this
this series to provide both:
1. VDSO-style para-virt time-scaling
2. Trap-n-emulation of TIME CSR when #1 is disabled

Regards,
Anup

>
> [1] https://lore.kernel.org/patchwork/cover/1288153/
>
> Yifei Jiang (3):
>   RISC-V: KVM: Change the method of calculating cycles to nanoseconds
>   RISC-V: KVM: Support dynamic time frequency from userspace
>   RISC-V: KVM: Implement guest time scaling
>
>  arch/riscv/include/asm/csr.h            |  3 ++
>  arch/riscv/include/asm/kvm_vcpu_timer.h | 13 +++++--
>  arch/riscv/kvm/vcpu_exit.c              | 35 +++++++++++++++++
>  arch/riscv/kvm/vcpu_timer.c             | 51 ++++++++++++++++++++++---
>  4 files changed, 93 insertions(+), 9 deletions(-)
>
> --
> 2.19.1
>
>
> --
> kvm-riscv mailing list
> kvm-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kvm-riscv
