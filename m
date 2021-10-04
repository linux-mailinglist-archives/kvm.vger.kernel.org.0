Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A555E420576
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 06:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbhJDEtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 00:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbhJDEtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 00:49:15 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A59AC061783
        for <kvm@vger.kernel.org>; Sun,  3 Oct 2021 21:47:26 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id s21so28387909wra.7
        for <kvm@vger.kernel.org>; Sun, 03 Oct 2021 21:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f4tKoSTK3inceMY79QUe3y1d0IroqdLSv2OwkWk2/A8=;
        b=vWWDVV47UEHkiIDoYrLU082WRdmSUQHbaJsK0RBGw+i4JyXd9rB/yX9KmIKfNBBgm9
         kqVPd0C9LMEc2i+5pNaKXcDDCWbt46i9W7lxZynQakH4aNdjNBs5+ST9hEs9h+4IkF7k
         zo4sMI9EwV/Y3h8sLXNIpcORk9a/qN4SlNmdlccZL2X0dIwAbpjEoYM6djVbFLGp+8ED
         K1HvhLZiW4DXx8nY3M3tc9sPnV3RNHd/O60P33ye2tcuQbhTDTXzUesV//3fymsnY6TD
         DM0GxD4TdxFNDbAXyFQateeN3vnqqyLU2JGij5IKaOn71GcK9c+QKQ36yjvCYBZwGFnR
         1MaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f4tKoSTK3inceMY79QUe3y1d0IroqdLSv2OwkWk2/A8=;
        b=CInEbsQZM4QT3vhLZF0jZh7yYdbqbsCVqP2o+q/pfKC2uU+hjvYGhIQ0pWfio3epY1
         6M6iRuLOl3nY2QjxbQTjT9wZlJbYRGsqzxQzly5hh1SzF/fsdVpotwZac/9RPZzP56dU
         6UYGcESCnylPt0tsJqzRiayh8NuhgGjlw8McgEaAdm+DllY19Lt6BupPEGvyR9tRMQpR
         6VKAC0dgamY2IMpbba7kM1hYFO0zOzSZCEVyLG9pCOfj5nm4mxktaTDmXBjm6JDFOKMV
         1V3AXxDzNrrpuHd/WtpR+o46aeDADgYyCjZYF21mPw4LM+u46g42GSPwnTKR9roktSQY
         TkLA==
X-Gm-Message-State: AOAM5307bJbDmmT/KdIXHeuln0UxdowHA34ktjjijYHozGwhD3GlmrwH
        rPMWY96Qp9FDhiQjFqXFH5OMhlzMnE4I1JMcqdICgQ==
X-Google-Smtp-Source: ABdhPJx37gv7S86waNUH+xL9Pa5+R4uyJSjSCccv/5SpnP1pbD+BHOOHyD+wYk5jf+xLYyO5QKxloQtS2nSz9VCP1U4=
X-Received: by 2002:adf:ab57:: with SMTP id r23mr12045283wrc.199.1633322844751;
 Sun, 03 Oct 2021 21:47:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210927114016.1089328-1-anup.patel@wdc.com> <CAAhSdy1yZ11L=A3g06GXM8tFtonBX0Cj5NDyGHQ1v44vJ8MqSA@mail.gmail.com>
 <CAFiDJ5_--KsNd3aH1gT_cgU32C+wzunzXeSKtn8HTNj_La7n5A@mail.gmail.com>
 <CAAhSdy1un6ab62LN-0ihV=oku8EH3fZ5YzbX1zzUFAEbatVAuQ@mail.gmail.com> <CAFiDJ5-Pew6311w7pS-_ADWQnP=H7gFEUUuU8MqhsMHEDrofdA@mail.gmail.com>
In-Reply-To: <CAFiDJ5-Pew6311w7pS-_ADWQnP=H7gFEUUuU8MqhsMHEDrofdA@mail.gmail.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 4 Oct 2021 10:17:13 +0530
Message-ID: <CAAhSdy3a6MqR5bmgA3Znwsn7RXWYhpokWzSP308JV7MQJ0NmWg@mail.gmail.com>
Subject: Re: [PATCH v20 00/17] KVM RISC-V Support
To:     Ley Foon Tan <lftan.linux@gmail.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Anup Patel <anup.patel@wdc.com>,
        Philipp Tomsich <philipp.tomsich@vrull.eu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 4, 2021 at 7:58 AM Ley Foon Tan <lftan.linux@gmail.com> wrote:
>
> On Fri, Oct 1, 2021 at 6:41 PM Anup Patel <anup@brainfault.org> wrote:
> >
> > On Fri, Oct 1, 2021 at 2:33 PM Ley Foon Tan <lftan.linux@gmail.com> wrote:
> > >
> > > On Mon, Sep 27, 2021 at 8:01 PM Anup Patel <anup@brainfault.org> wrote:
> > > >
> > > > Hi Palmer, Hi Paolo,
> > > >
> > > > On Mon, Sep 27, 2021 at 5:10 PM Anup Patel <anup.patel@wdc.com> wrote:
> > > > >
> > > > > This series adds initial KVM RISC-V support. Currently, we are able to boot
> > > > > Linux on RV64/RV32 Guest with multiple VCPUs.
> > > > >
> > > > > Key aspects of KVM RISC-V added by this series are:
> > > > > 1. No RISC-V specific KVM IOCTL
> > > > > 2. Loadable KVM RISC-V module supported
> > > > > 3. Minimal possible KVM world-switch which touches only GPRs and few CSRs
> > > > > 4. Both RV64 and RV32 host supported
> > > > > 5. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure
> > > > > 6. KVM ONE_REG interface for VCPU register access from user-space
> > > > > 7. PLIC emulation is done in user-space
> > > > > 8. Timer and IPI emuation is done in-kernel
> > > > > 9. Both Sv39x4 and Sv48x4 supported for RV64 host
> > > > > 10. MMU notifiers supported
> > > > > 11. Generic dirtylog supported
> > > > > 12. FP lazy save/restore supported
> > > > > 13. SBI v0.1 emulation for KVM Guest available
> > > > > 14. Forward unhandled SBI calls to KVM userspace
> > > > > 15. Hugepage support for Guest/VM
> > > > > 16. IOEVENTFD support for Vhost
> > > > >
> > > > > Here's a brief TODO list which we will work upon after this series:
> > > > > 1. KVM unit test support
> > > > > 2. KVM selftest support
> > > > > 3. SBI v0.3 emulation in-kernel
> > > > > 4. In-kernel PMU virtualization
> > > > > 5. In-kernel AIA irqchip support
> > > > > 6. Nested virtualizaiton
> > > > > 7. ..... and more .....
> > > > >
> > > > > This series can be found in riscv_kvm_v20 branch at:
> > > > > https//github.com/avpatel/linux.git
> > > > >
> > > > > Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v9 branch
> > > > > at: https//github.com/avpatel/kvmtool.git
> > > > >
> > > > > The QEMU RISC-V hypervisor emulation is done by Alistair and is available
> > > > > in master branch at: https://git.qemu.org/git/qemu.git
> > > > >
> > > > > To play around with KVM RISC-V, refer KVM RISC-V wiki at:
> > > > > https://github.com/kvm-riscv/howto/wiki
> > > > > https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-QEMU
> > > > > https://github.com/kvm-riscv/howto/wiki/KVM-RISCV64-on-Spike
> > > > >

<snip>

> Hi Anup
>
> It is able to boot up to kvm guest OS after change to use
> https://github.com/avpatel/qemu.git, riscv_aia_v2 branch.
> Is there dependency to AIA hardware feature for KVM?

No, there is no dependency on AIA hardware and KVM RISC-V
v20 series.

I quickly tried the latest QEMU master with KVM RISC-V v20 and
it worked perfectly fine for me.
(QEMU master commit 30bd1db58b09c12b68c35f041f919014b885482d)

Although, I did see that VS-mode interrupts were broken in the latest
Spike due to some recent merge. I have sent fix PR to Spike for this.
(Refer, https://github.com/riscv-software-src/riscv-isa-sim/pull/822)

With Spike fix PR (above), the KVM RISC-V v20 series works fine
on Spike as well.

>
>
> Log:
>
> [    6.212484] Run /virt/init as init process
> Mounting...
> [    7.202552] random: fast init done
> / # cat /proc/cpuinfo
> processor : 0
> hart : 1
> isa : rv64imafdcsu
> mmu : sv48
>
> processor : 1
> hart : 0
> isa : rv64imafdcsu
> mmu : sv48
>
> / # cat /proc/interrupts
>            CPU0       CPU1
>   1:        355          0  SiFive PLIC   5 Edge      virtio0
>   2:        212          0  SiFive PLIC   6 Edge      virtio1
>   3:         11          0  SiFive PLIC   7 Edge      virtio2
>   4:        155          0  SiFive PLIC   1 Edge      ttyS0
>   5:       1150        942  RISC-V INTC   5 Edge      riscv-timer
> IPI0:        19          5  Rescheduling interrupts
> IPI1:        50        565  Function call interrupts
> IPI2:         0          0  CPU stop interrupts
> IPI3:         0          0  IRQ work interrupts
> IPI4:         0          0  Timer broadcast interrupts
>
>
> Thanks.
>
> Regards
> Ley Foon

Regards,
Anup
