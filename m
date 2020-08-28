Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F602553E9
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 06:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgH1E5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 00:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgH1E5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 00:57:18 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A71C06121B
        for <kvm@vger.kernel.org>; Thu, 27 Aug 2020 21:57:17 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q93so42364pjq.0
        for <kvm@vger.kernel.org>; Thu, 27 Aug 2020 21:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3EeBnzl55KhlznFGrhdw4wiCgK95KqATQ83rC/nkZT0=;
        b=gpMTcbpl4/LN0p/Roic31wTiMY2eUFarLAXop4+im+qllDOfxyjQyOgske9U78MIsz
         7b5/Z9Plh7i+IUCnuJs3xxHlcQ5Mqmkq3odbq4FQfOGUkYxgzO+G6y48tw4mvJ349sNr
         W1EATwnMZoXRC94aHfKUHgdFR+18slX19mje7G+6R4yAatxZU4/P4GliSt1ZDO0Vuv0q
         t4STmH5dVvVnJE8cmQIQWZYAYKIfvr62Ihc9poxPhPOWcTv2CqIB6kvuDZLU0fDUG2PO
         2noPdsy2ydKpMra9XUm0/A65slQOjYRltyLJCq/uwtJEuf/z+WrpVYDINuTrI+qnNMx0
         EIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3EeBnzl55KhlznFGrhdw4wiCgK95KqATQ83rC/nkZT0=;
        b=OMQejpd6iPmNqLMTOdy9vduW6SCh/mfm1DNCAybuESJCGQIUM5aL8I4J5u4IEeeSKB
         FLmPsMuvNmYMM5/+AFkcvt3BSccFwQPt39WXQK3dIL/7SbfKsLLnqigZnMfSvy2CKpA3
         rF+9IXN4umYbT3E42LUcWrZxiwG1AH5sbDjhttQKA0/Vcg1RH3D0miw3m++2cqHfIq8e
         aNPzMoEFkwHcWvh1PNNW4tx4+8GpD393FkVkTlNo/ugeR6Vob0Fxih5Jvtw1ImTps7mK
         HGsUTtnf1Pdpf0it8qbP09q6ubRHvdrdVeWOMH+pHKmaRAjjpD75v01uM74U6+DvZuXT
         382w==
X-Gm-Message-State: AOAM532gfQxtOhK2goULZL6Yy8PXMQ8n4HhqOfMVxz3AKqs61Kn/4yHP
        fHE6eA7256qSn0hk6oAZA95bmc9WX/3Zg0UrJzkatg==
X-Google-Smtp-Source: ABdhPJxLo7vrQLUhTi7CAJ1QiiyZWein+ivOd8qafBnWQxI56Vc3pCvlOZ2oTlRXck0fsNFr8fIGigFt8sJIz/vk4+Y=
X-Received: by 2002:a17:90a:fc98:: with SMTP id ci24mr84381pjb.101.1598590637116;
 Thu, 27 Aug 2020 21:57:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200724085441.1514-1-jiangyifei@huawei.com>
In-Reply-To: <20200724085441.1514-1-jiangyifei@huawei.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 28 Aug 2020 10:27:04 +0530
Message-ID: <CAAhSdy2qtr4EpYjFM=REigrC7DK_Fo26P-SGhVC6n21FewtFvw@mail.gmail.com>
Subject: Re: [RFC 0/2] Add risc-v vhost-net support
To:     Yifei Jiang <jiangyifei@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "Zhangxiaofeng (F)" <victor.zhangxiaofeng@huawei.com>,
        wu.wubin@huawei.com,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>,
        "dengkai (A)" <dengkai1@huawei.com>, limingwang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 24, 2020 at 2:25 PM Yifei Jiang <jiangyifei@huawei.com> wrote:
>
> Hi,
>
> These two patches enable support for vhost-net on RISC-V architecture. They are developed
> based on the Linux source in this repo: https://github.com/avpatel/linux,
> the branch is riscv_kvm_v13.
>
> The accompanying QEMU is from the repo: https://github.com/alistair23/qemu, the branch is
> hyp-ext-v0.6.next. In order for the QEMU to work with KVM, the patch found here is necessary:
> https://patchwork.kernel.org/cover/11435965/
>
> Several steps to use this:
>
> 1. create virbr0 on riscv64 emulation
> $ brctl addbr virbr0
> $ brctl stp virbr0 on
> $ ifconfig virbr0 up
> $ ifconfig virbr0 <virbr0_ip> netmask <virbr0_netmask>
>
> 2. boot riscv64 guestOS on riscv64 emulation
> $ ./qemu-system-riscv64 -M virt,accel=kvm -m 1024M -cpu host -nographic \
>         -name guest=riscv-guest \
>         -smp 2 \
>         -kernel ./Image \
>         -drive file=./guest.img,format=raw,id=hd0 \
>         -device virtio-blk,drive=hd0 \
>         -netdev type=tap,vhost=on,script=./ifup.sh,downscript=./ifdown.sh,id=net0 \
>         -append "root=/dev/vda rw console=ttyS0 earlycon=sbi"
>
> $ cat ifup.sh
> #!/bin/sh
> brctl addif virbr0 $1
> ifconfig $1 up
>
> $ cat ifdown.sh
> #!/bin/sh
> ifconfig $1 down
> brctl delif virbr0 $1
>
> This brenchmark is vhost-net compare with virtio:
>
> $ ./netperf -H <virbr0_ip> -l 100 -t TCP_STREAM
>
> vhost-net:
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
>
> 131072  16384  16384    100.07    457.55
>
> virtio:
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
>
> 131072  16384  16384    100.07    227.02
>
>
> The next step is to support irqfd on RISC-V architecture.
>
> Yifei Jiang (2):
>   RISC-V: KVM: enable ioeventfd capability and compile for risc-v
>   RISC-V: KVM: read\write kernel mmio device support
>
>  arch/riscv/kvm/Kconfig     |  2 ++
>  arch/riscv/kvm/Makefile    |  2 +-
>  arch/riscv/kvm/vcpu_exit.c | 38 ++++++++++++++++++++++++++++++++------
>  arch/riscv/kvm/vm.c        |  1 +
>  4 files changed, 36 insertions(+), 7 deletions(-)
>
> --
> 2.19.1
>
>

I will be squashing these patches into PATCH7 of v14 KVM RISC-V series.

I will also add your Signed-off-by to PATCH7 of v14 KVM RISC-V to
acknowledge your efforts.

Thanks,
Anup
