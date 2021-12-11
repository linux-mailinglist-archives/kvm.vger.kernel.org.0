Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A4F47114C
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 04:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238675AbhLKDov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 22:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237709AbhLKDou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 22:44:50 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66220C061746
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 19:41:14 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id q3so17978363wru.5
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 19:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EO75poJK2xgDITlrG7RVKgMYEM37BaniCA9cW2F8IAE=;
        b=UUDpGaZ4TlqJucB7PlMbEakgQYttvolbBk2bus1Xxo0uqDAkjBhl6iolgunNvqfE4U
         3KMqZsunqRx3/AcboOFf5R27X31eWeINs/lCdD0CN8XoBYreShHbrLW7XS8g2GI4cW6a
         /XIe8l8fwtz17Yzq3YFS59etRNEVvfce/S12CxewPjX9R7+NV+Mzwy55+yF8c43a8rHT
         P+B+9Bq+1n6YJYgJCOEaFak1CQozKjbeQHcE6+Objr962V5BNP2bjfK+cKL0xHYt+iYf
         8BZizLTYTR72actmkvGRv0lVG7Zz42wUizEILE+4S6d+kPg/YiunXbps391KW8V9kpk5
         nupQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EO75poJK2xgDITlrG7RVKgMYEM37BaniCA9cW2F8IAE=;
        b=Bbklu0n+Vv9GFIEaj7SCCwer/n2UU/Mec9V8hncwaBc1z8rcMw+qKf79OfZmw8YCzK
         96HvnNrrmIi+Rgd5VK9m3Nl4sNEN3Z2KocZACiJQsJV6RlVGRMzDImW63gWlvaNSkTBu
         yIsFiHHun7rKItkJbWKbWHN1LSvAoThyCfqMzs7DNETpxtyTHv7Mvr3N+3PT2JsITBiq
         qdDzC82Wgk3Z7LOWrtCEhrPudyw1HJXVF3QlomQ9Zzb/aIATkiiMzMmt6TqpyCnl/mzA
         6KvptIqWGxXiRIt24VuKry3sq3oIl0v4kNOjMebru0fltoIakLOR6sKwONM4y0W1XmKV
         6PcQ==
X-Gm-Message-State: AOAM531pVqsv0mLwjT8CVXiiJ3+oSGrJPRl2YYYUe8SSskfcy4Kf4QZZ
        peyFYZcVw9t++pBuPeI4oj6HZq7udMUePY+jA3s1zA==
X-Google-Smtp-Source: ABdhPJxU5WTGxoPImoqEQQ34iwc3zq+NMIe3iv94HfKYLahaxjZujpAul0sWWjXgr8vVvi8pSAKSsitBxMOpHCyl5ZY=
X-Received: by 2002:adf:eb0f:: with SMTP id s15mr2303012wrn.690.1639194072549;
 Fri, 10 Dec 2021 19:41:12 -0800 (PST)
MIME-Version: 1.0
References: <20211129075451.418122-1-anup.patel@wdc.com>
In-Reply-To: <20211129075451.418122-1-anup.patel@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 11 Dec 2021 09:11:01 +0530
Message-ID: <CAAhSdy3S5HAYh24mH7JpZKSnk4Vjrw2SJToAHaMjyegwiR4XXg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] KVM RISC-V 64-bit selftests support
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Shuah Khan <shuah@kernel.org>, Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Mon, Nov 29, 2021 at 1:40 PM Anup Patel <anup.patel@wdc.com> wrote:
>
> This series adds initial support for testing KVM RISC-V 64-bit using
> kernel selftests framework. The PATCH1 & PATCH2 of this series does
> some ground work in KVM RISC-V to implement RISC-V support in the KVM
> selftests whereas remaining patches does required changes in the KVM
> selftests.
>
> These patches can be found in riscv_kvm_selftests_v2 branch at:
> https://github.com/avpatel/linux.git
>
> Changes since v1:
>  - Renamed kvm_sbi_ext_expevend_handler() to kvm_sbi_ext_forward_handler()
>    in PATCH1
>  - Renamed KVM_CAP_RISCV_VM_GPA_SIZE to KVM_CAP_VM_GPA_BITS in PATCH2
>    and PATCH4
>
> Anup Patel (4):
>   RISC-V: KVM: Forward SBI experimental and vendor extensions
>   RISC-V: KVM: Add VM capability to allow userspace get GPA bits
>   KVM: selftests: Add EXTRA_CFLAGS in top-level Makefile
>   KVM: selftests: Add initial support for RISC-V 64-bit

Any further comments on this series ?

Regards,
Anup

>
>  arch/riscv/include/asm/kvm_host.h             |   1 +
>  arch/riscv/kvm/mmu.c                          |   5 +
>  arch/riscv/kvm/vcpu_sbi.c                     |   4 +
>  arch/riscv/kvm/vcpu_sbi_base.c                |  27 ++
>  arch/riscv/kvm/vm.c                           |   3 +
>  include/uapi/linux/kvm.h                      |   1 +
>  tools/testing/selftests/kvm/Makefile          |  14 +-
>  .../testing/selftests/kvm/include/kvm_util.h  |  10 +
>  .../selftests/kvm/include/riscv/processor.h   | 135 +++++++
>  tools/testing/selftests/kvm/lib/guest_modes.c |  10 +
>  .../selftests/kvm/lib/riscv/processor.c       | 362 ++++++++++++++++++
>  tools/testing/selftests/kvm/lib/riscv/ucall.c |  87 +++++
>  12 files changed, 658 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/include/riscv/processor.h
>  create mode 100644 tools/testing/selftests/kvm/lib/riscv/processor.c
>  create mode 100644 tools/testing/selftests/kvm/lib/riscv/ucall.c
>
> --
> 2.25.1
>
