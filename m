Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B7638866D
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 07:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbhESFLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 01:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbhESFLs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 01:11:48 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7ED2C06175F
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:10:27 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x8so12492601wrq.9
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=euUNmfdra3fw2767TBroA6MJ91YZAjLv3gkDPjRiyS4=;
        b=Zti7viSDHb0VTJftg3BPlW8ti+9QLDu9Xm7Yuq0CCaDfNVh6YVDf4YCUULjLTTGsGi
         R1DWHJ/IGB4/xZji/+Kmxkn7Ut0h48a9LUaXZmEXtV3uecqh2Ave3mBhZ1iW+y/ghhC3
         RjxfEb9aAI9waxiOiWBz+x9Xwn7Pg4bShrDhbcYUNn8YaTPlRC/G9POIPXYeG5kZzDoi
         e7tyARNKu5qPxBQ8uEIfyMeHaT+AUN/COoiK8qgqUbRyv/mpwUwAzDfeBOd0AxYbDcXo
         H6W9ppBsMXoACuavlTXfTcptSGl+tmDqfqQOLWDjAPSKjqVzn0MvKJPY/dYqbWhh1eqG
         iS2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=euUNmfdra3fw2767TBroA6MJ91YZAjLv3gkDPjRiyS4=;
        b=CUBsZWlD+V3TbuKBoMun4hx2CoIRMHVCwJPi3mafJfarf3y/zBh8nxXiSDiWiyqBSt
         kgI09ISDZ9Gfo9p9mZr7n5R+bOZsDwr5jZ/T0bQNlg3/AD5kdK4vwvZAa408h92hqix9
         qTLLHjc/zO/+QysJPtor7mQtmVOACmI9GJ3LSMeGXG1IZ+dFB2FetgfTQV8I6jPC57cq
         08slJen1Citb5q1Fzxida+gAN66sr4HyYYCI4inlISRl1chLnIasdyX7COvkH9n6eF4Y
         MbI6EvhJiLZagkBfhtZpPf3kDRI/RTM5b+R98cgNk+LnURmnNVr12qwSgUP4TCZxuX5a
         Pe2Q==
X-Gm-Message-State: AOAM531fSahx9uVTiMQmj5Rgfkc4z30A7BLZBucAyc3QFycYL7XGVsdd
        6AfdRaksAi/2IRSO2qWIRDVbHQKZBilAKd4y7QO/Uw==
X-Google-Smtp-Source: ABdhPJwa9Izmvx4WFIO6ko25EtfKdaY6XBgGq19Jcwm/KSSHQqpdTPyHjpR2GyhcJfmWcB9WwWyGSBKXyEBwweCxC3w=
X-Received: by 2002:adf:ffd2:: with SMTP id x18mr12055209wrs.144.1621401025109;
 Tue, 18 May 2021 22:10:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210519033553.1110536-1-anup.patel@wdc.com> <YKSa48cejI1Lax+/@kroah.com>
In-Reply-To: <YKSa48cejI1Lax+/@kroah.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Wed, 19 May 2021 10:40:13 +0530
Message-ID: <CAAhSdy18qySXbUdrEsUe-KtbtuEoYrys0TcmsV2UkEA2=7UQzw@mail.gmail.com>
Subject: Re: [PATCH v18 00/18] KVM RISC-V Support
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Anup Patel <anup.patel@wdc.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        linux-staging@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 10:28 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, May 19, 2021 at 09:05:35AM +0530, Anup Patel wrote:
> > From: Anup Patel <anup@brainfault.org>
> >
> > This series adds initial KVM RISC-V support. Currently, we are able to boot
> > Linux on RV64/RV32 Guest with multiple VCPUs.
> >
> > Key aspects of KVM RISC-V added by this series are:
> > 1. No RISC-V specific KVM IOCTL
> > 2. Minimal possible KVM world-switch which touches only GPRs and few CSRs
> > 3. Both RV64 and RV32 host supported
> > 4. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure
> > 5. KVM ONE_REG interface for VCPU register access from user-space
> > 6. PLIC emulation is done in user-space
> > 7. Timer and IPI emuation is done in-kernel
> > 8. Both Sv39x4 and Sv48x4 supported for RV64 host
> > 9. MMU notifiers supported
> > 10. Generic dirtylog supported
> > 11. FP lazy save/restore supported
> > 12. SBI v0.1 emulation for KVM Guest available
> > 13. Forward unhandled SBI calls to KVM userspace
> > 14. Hugepage support for Guest/VM
> > 15. IOEVENTFD support for Vhost
> >
> > Here's a brief TODO list which we will work upon after this series:
> > 1. SBI v0.2 emulation in-kernel
> > 2. SBI v0.2 hart state management emulation in-kernel
> > 3. In-kernel PLIC emulation
> > 4. ..... and more .....
> >
> > This series can be found in riscv_kvm_v18 branch at:
> > https//github.com/avpatel/linux.git
> >
> > Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v7 branch
> > at: https//github.com/avpatel/kvmtool.git
> >
> > The QEMU RISC-V hypervisor emulation is done by Alistair and is available
> > in master branch at: https://git.qemu.org/git/qemu.git
> >
> > To play around with KVM RISC-V, refer KVM RISC-V wiki at:
> > https://github.com/kvm-riscv/howto/wiki
> > https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU
> > https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-Spike
> >
> > Changes since v17:
> >  - Rebased on Linux-5.13-rc2
> >  - Moved to new KVM MMU notifier APIs
> >  - Removed redundant kvm_arch_vcpu_uninit()
> >  - Moved KVM RISC-V sources to drivers/staging for compliance with
> >    Linux RISC-V patch acceptance policy
>
> What is this new "patch acceptance policy" and what does it have to do
> with drivers/staging?

The Linux RISC-V patch acceptance policy is here:
Documentation/riscv/patch-acceptance.rst

As-per this policy, the Linux RISC-V maintainers will only accept
patches for frozen/ratified RISC-V extensions. Basically, it links the
Linux RISC-V development process with the RISC-V foundation
process which is painfully slow.

The KVM RISC-V patches have been sitting on the lists for almost
2 years now. The requirements for freezing RISC-V H-extension
(hypervisor extension) keeps changing and we are not clear when
it will be frozen. In fact, quite a few people have already implemented
RISC-V H-extension in hardware as well and KVM RISC-V works
on real HW as well.

Rationale of moving KVM RISC-V to drivers/staging is to continue
KVM RISC-V development without breaking the Linux RISC-V patch
acceptance policy until RISC-V H-extension is frozen. Once, RISC-V
H-extension is frozen we will move KVM RISC-V back to arch/riscv
(like other architectures).

>
> What does drivers/staging/ have to do with this at all?  Did anyone ask
> the staging maintainer about this?

Yes, Paolo (KVM maintainer) suggested having KVM RISC-V under
drivers/staging until RISC-V H-extension is frozen and continue the
KVM RISC-V development from there.

>
> Not cool, and not something I'm about to take without some very good
> reasons...

Regards,
Anup
