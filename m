Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4ACA6617
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 11:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbfICJxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 05:53:43 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43385 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728546AbfICJxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 05:53:43 -0400
Received: by mail-wr1-f68.google.com with SMTP id y8so16719673wrn.10
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 02:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MgXnM5PtLLeZR4goT8pEjOEmDwznieCs/oR5Oy3fuSo=;
        b=mC+xMiASacXX5Uk14z3V94sf/GweT8FVxSnDjFgNxflc+SESaM+kJtWD7A4gHXeOVw
         IS4nM7LmLSn0eMs4n6RyWTsiB5dYrRpod1s9zlnwBlH+SYDW3H6mAyUd+GskjPPjDYg/
         aoy79/mGZRoMqacGUmZyfZu9zd/QaWVrWzZiQ1Td4pz7gcUbVI9Nbf6H8yf75QYrcLfg
         JLcXAe8v45vL2Udit4uIwMGnC8Zr6LOuIgXi3uoKdum4/dJo114l4ya5YCY68jAKkQI0
         d1yQcFMKTB+q4eWM05V/8lVB0V9eACtMUlJ9aPvcYN2H46Dk5vkMBJbteUZ871iJvfOF
         O6RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MgXnM5PtLLeZR4goT8pEjOEmDwznieCs/oR5Oy3fuSo=;
        b=LLGPu2VTNZcM9eHQ9rqknWVCAryH6tFIXdE6RWw/LayJ2Ej7OXciqz6uASQt9YZk8i
         jHqy9Oulx1qauH2JRrLVAsh/iLtOYhJlxcCg2t7TkWKux73USi/Mj0rnK6yridDFoSsU
         +p9SB1BZT3AVxiHrDgqCu6yw1UlWWhQT10qxTDbvFa4shQmflYgeGIGvFjA++dY+uMxX
         0zVXd1HmvTiaf4eqtC2tZEI/+35GpVkIf4PiOXTxwLCc7LKI14OvA1oX/9Rybc+FI3dv
         eUrawur3IJI9DgpWBYmQl/9vinVqG1C33edxJu7yJiJQDIeH/G4lyNkXChazR4xmjToQ
         0q+Q==
X-Gm-Message-State: APjAAAWcjyjeJ0XCj65WpsPayCORmU7/khsRWQLqQfxLoPgGAuYyrpcg
        UMFGfSCvS+bvkIPMVyaV57LpGdAPmQtX79rTjhGJRw==
X-Google-Smtp-Source: APXvYqycePSqD+xZkUq3liN2M817pw47hXAQodFDEYagVeYhgTTX3a0PlLUiIzLP1hWxxrx++aWFnSwGmEJ5WYAkNl8=
X-Received: by 2002:a5d:5444:: with SMTP id w4mr26076311wrv.180.1567504420046;
 Tue, 03 Sep 2019 02:53:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190829135427.47808-1-anup.patel@wdc.com> <20190829135427.47808-20-anup.patel@wdc.com>
In-Reply-To: <20190829135427.47808-20-anup.patel@wdc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 3 Sep 2019 15:23:29 +0530
Message-ID: <CAAhSdy2jd79-=bPN0gwm8iTg2BqzLgamTqO5TDXswPc29VPrCQ@mail.gmail.com>
Subject: Re: [PATCH v6 19/21] RISC-V: KVM: Document RISC-V specific parts of
 KVM API.
To:     Anup Patel <Anup.Patel@wdc.com>
Cc:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 7:27 PM Anup Patel <Anup.Patel@wdc.com> wrote:
>
> Document RISC-V specific parts of the KVM API, such as:
>  - The interrupt numbers passed to the KVM_INTERRUPT ioctl.
>  - The states supported by the KVM_{GET,SET}_MP_STATE ioctls.
>  - The registers supported by the KVM_{GET,SET}_ONE_REG interface
>    and the encoding of those register ids.
>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> ---
>  Documentation/virt/kvm/api.txt | 140 +++++++++++++++++++++++++++++++--
>  1 file changed, 133 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index 2d067767b617..80c4ffad8bd7 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -471,7 +471,7 @@ struct kvm_translation {
>  4.16 KVM_INTERRUPT
>
>  Capability: basic
> -Architectures: x86, ppc, mips
> +Architectures: x86, ppc, mips, riscv
>  Type: vcpu ioctl
>  Parameters: struct kvm_interrupt (in)
>  Returns: 0 on success, negative on failure.
> @@ -531,6 +531,22 @@ interrupt number dequeues the interrupt.
>
>  This is an asynchronous vcpu ioctl and can be invoked from any thread.
>
> +RISC-V:
> +
> +Queues an external interrupt to be injected into the virutal CPU. This ioctl
> +is overloaded with 2 different irq values:
> +
> +a) KVM_INTERRUPT_SET
> +
> +  This sets external interrupt for a virtual CPU and it will receive
> +  once it is ready.
> +
> +b) KVM_INTERRUPT_UNSET
> +
> +  This clears pending external interrupt for a virtual CPU.
> +
> +This is an asynchronous vcpu ioctl and can be invoked from any thread.
> +
>
>  4.17 KVM_DEBUG_GUEST
>
> @@ -1206,7 +1222,7 @@ for vm-wide capabilities.
>  4.38 KVM_GET_MP_STATE
>
>  Capability: KVM_CAP_MP_STATE
> -Architectures: x86, s390, arm, arm64
> +Architectures: x86, s390, arm, arm64, riscv
>  Type: vcpu ioctl
>  Parameters: struct kvm_mp_state (out)
>  Returns: 0 on success; -1 on error
> @@ -1220,7 +1236,8 @@ uniprocessor guests).
>
>  Possible values are:
>
> - - KVM_MP_STATE_RUNNABLE:        the vcpu is currently running [x86,arm/arm64]
> + - KVM_MP_STATE_RUNNABLE:        the vcpu is currently running
> +                                 [x86,arm/arm64,riscv]
>   - KVM_MP_STATE_UNINITIALIZED:   the vcpu is an application processor (AP)
>                                   which has not yet received an INIT signal [x86]
>   - KVM_MP_STATE_INIT_RECEIVED:   the vcpu has received an INIT signal, and is
> @@ -1229,7 +1246,7 @@ Possible values are:
>                                   is waiting for an interrupt [x86]
>   - KVM_MP_STATE_SIPI_RECEIVED:   the vcpu has just received a SIPI (vector
>                                   accessible via KVM_GET_VCPU_EVENTS) [x86]
> - - KVM_MP_STATE_STOPPED:         the vcpu is stopped [s390,arm/arm64]
> + - KVM_MP_STATE_STOPPED:         the vcpu is stopped [s390,arm/arm64,riscv]
>   - KVM_MP_STATE_CHECK_STOP:      the vcpu is in a special error state [s390]
>   - KVM_MP_STATE_OPERATING:       the vcpu is operating (running or halted)
>                                   [s390]
> @@ -1240,7 +1257,7 @@ On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
>  in-kernel irqchip, the multiprocessing state must be maintained by userspace on
>  these architectures.
>
> -For arm/arm64:
> +For arm/arm64/riscv:
>
>  The only states that are valid are KVM_MP_STATE_STOPPED and
>  KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
> @@ -1248,7 +1265,7 @@ KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
>  4.39 KVM_SET_MP_STATE
>
>  Capability: KVM_CAP_MP_STATE
> -Architectures: x86, s390, arm, arm64
> +Architectures: x86, s390, arm, arm64, riscv
>  Type: vcpu ioctl
>  Parameters: struct kvm_mp_state (in)
>  Returns: 0 on success; -1 on error
> @@ -1260,7 +1277,7 @@ On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
>  in-kernel irqchip, the multiprocessing state must be maintained by userspace on
>  these architectures.
>
> -For arm/arm64:
> +For arm/arm64/riscv:
>
>  The only states that are valid are KVM_MP_STATE_STOPPED and
>  KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
> @@ -2269,6 +2286,115 @@ following id bit patterns:
>    0x7020 0000 0003 02 <0:3> <reg:5>
>
>
> +RISC-V registers are mapped using the lower 32 bits. The upper 8 bits of
> +that is the register group type.
> +
> +RISC-V config registers are meant for configuring a Guest VCPU and it has
> +the following id bit patterns:
> +  0x8020 0000 01 <index into the kvm_riscv_config struct:24> (32bit Host)
> +  0x8030 0000 01 <index into the kvm_riscv_config struct:24> (64bit Host)
> +
> +Following are the RISC-V config registers:
> +
> +    Encoding            Register  Description
> +------------------------------------------------------------------
> +  0x80x0 0000 0100 0000 isa       ISA feature bitmap of Guest VCPU
> +  0x80x0 0000 0100 0001 tbfreq    Time base frequency
> +
> +The isa config register can be read anytime but can only be written before
> +a Guest VCPU runs. It will have ISA feature bits matching underlying host
> +set by default. The tbfreq config register is a read-only register and it
> +will return host timebase frequenc.
> +
> +RISC-V core registers represent the general excution state of a Guest VCPU
> +and it has the following id bit patterns:
> +  0x8020 0000 02 <index into the kvm_regs struct:24> (32bit Host)
> +  0x8030 0000 02 <index into the kvm_regs struct:24> (64bit Host)
> +
> +Following are the RISC-V core registers:
> +
> +    Encoding            Register  Description
> +------------------------------------------------------------------
> +  0x80x0 0000 0200 0000 regs.pc   Program counter
> +  0x80x0 0000 0200 0001 regs.ra   Return address
> +  0x80x0 0000 0200 0002 regs.sp   Stack pointer
> +  0x80x0 0000 0200 0003 regs.gp   Global pointer
> +  0x80x0 0000 0200 0004 regs.tp   Task pointer
> +  0x80x0 0000 0200 0005 regs.t0   Caller saved register 0
> +  0x80x0 0000 0200 0006 regs.t1   Caller saved register 1
> +  0x80x0 0000 0200 0007 regs.t2   Caller saved register 2
> +  0x80x0 0000 0200 0008 regs.s0   Callee saved register 0
> +  0x80x0 0000 0200 0009 regs.s1   Callee saved register 1
> +  0x80x0 0000 0200 000a regs.a0   Function argument (or return value) 0
> +  0x80x0 0000 0200 000b regs.a1   Function argument (or return value) 1
> +  0x80x0 0000 0200 000c regs.a2   Function argument 2
> +  0x80x0 0000 0200 000d regs.a3   Function argument 3
> +  0x80x0 0000 0200 000e regs.a4   Function argument 4
> +  0x80x0 0000 0200 000f regs.a5   Function argument 5
> +  0x80x0 0000 0200 0010 regs.a6   Function argument 6
> +  0x80x0 0000 0200 0011 regs.a7   Function argument 7
> +  0x80x0 0000 0200 0012 regs.s2   Callee saved register 2
> +  0x80x0 0000 0200 0013 regs.s3   Callee saved register 3
> +  0x80x0 0000 0200 0014 regs.s4   Callee saved register 4
> +  0x80x0 0000 0200 0015 regs.s5   Callee saved register 5
> +  0x80x0 0000 0200 0016 regs.s6   Callee saved register 6
> +  0x80x0 0000 0200 0017 regs.s7   Callee saved register 7
> +  0x80x0 0000 0200 0018 regs.s8   Callee saved register 8
> +  0x80x0 0000 0200 0019 regs.s9   Callee saved register 9
> +  0x80x0 0000 0200 001a regs.s10  Callee saved register 10
> +  0x80x0 0000 0200 001b regs.s11  Callee saved register 11
> +  0x80x0 0000 0200 001c regs.t3   Caller saved register 3
> +  0x80x0 0000 0200 001d regs.t4   Caller saved register 4
> +  0x80x0 0000 0200 001e regs.t5   Caller saved register 5
> +  0x80x0 0000 0200 001f regs.t6   Caller saved register 6

I missed documenting "mode" register here. I will update it in v7.

Regards,
Anup

> +
> +RISC-V csr registers represent the supervisor mode control/status registers
> +of a Guest VCPU and it has the following id bit patterns:
> +  0x8020 0000 03 <index into the kvm_sregs struct:24> (32bit Host)
> +  0x8030 0000 03 <index into the kvm_sregs struct:24> (64bit Host)
> +
> +Following are the RISC-V csr registers:
> +
> +    Encoding            Register  Description
> +------------------------------------------------------------------
> +  0x80x0 0000 0300 0000 sstatus   Supervisor status
> +  0x80x0 0000 0300 0001 sie       Supervisor interrupt enable
> +  0x80x0 0000 0300 0002 stvec     Supervisor trap vector base
> +  0x80x0 0000 0300 0003 sscratch  Supervisor scratch register
> +  0x80x0 0000 0300 0004 sepc      Supervisor exception program counter
> +  0x80x0 0000 0300 0005 scause    Supervisor trap cause
> +  0x80x0 0000 0300 0006 stval     Supervisor bad address or instruction
> +  0x80x0 0000 0300 0007 sip       Supervisor interrupt pending
> +  0x80x0 0000 0300 0008 satp      Supervisor address translation and protection
> +
> +RISC-V F extension registers represent the single precision floating point
> +state of a Guest VCPU and it has the following id bit patterns:
> +  0x8020 0000 04 <index into the __riscv_f_ext_state struct:24>
> +
> +Following are the RISC-V F extension registers:
> +
> +    Encoding            Register  Description
> +------------------------------------------------------------------
> +  0x8020 0000 0400 0000 f[0]      Floating point register 0
> +  ...
> +  0x8020 0000 0400 001f f[31]     Floating point register 31
> +  0x8020 0000 0400 0020 fcsr      Floating point control and status register
> +
> +RISC-V D extension registers represent the double precision floating point
> +state of a Guest VCPU and it has the following id bit patterns:
> +  0x8020 0000 05 <index into the __riscv_d_ext_state struct:24> (fcsr)
> +  0x8030 0000 05 <index into the __riscv_d_ext_state struct:24> (non-fcsr)
> +
> +Following are the RISC-V D extension registers:
> +
> +    Encoding            Register  Description
> +------------------------------------------------------------------
> +  0x8030 0000 0500 0000 f[0]      Floating point register 0
> +  ...
> +  0x8030 0000 0500 001f f[31]     Floating point register 31
> +  0x8020 0000 0500 0020 fcsr      Floating point control and status register
> +
> +
>  4.69 KVM_GET_ONE_REG
>
>  Capability: KVM_CAP_ONE_REG
> --
> 2.17.1
>
