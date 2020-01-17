Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C948214045F
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2020 08:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgAQHOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jan 2020 02:14:19 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35761 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgAQHOT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jan 2020 02:14:19 -0500
Received: by mail-wm1-f65.google.com with SMTP id p17so6433457wmb.0
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 23:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vd6rya/rtfsC3Wyfx6Rmnt5QEoiw12dxt+6jkc+paaw=;
        b=QGUwlYXDLXWES33BIFuIGaGp80Y7BWGxf6pngN3nJbYm/zIZOmRgwWHsrff1QaOBOV
         PJ4yUHpcyZeRSrxPrvu/OHeBEfNhgxCz/B748ptvmpk7G8cnve0iU5sdp1v837eKN8wK
         aXSGYFlDHWKZnFy948wEkljBxCYsf658B24kddAhVMFib/DZSu46Fc+wRveJ5IrpeSXP
         PS6ylQCfM7gNAraQJEwxV+evX93iodElkw4HVEEDxGjppjmu194KZ9JgTeeecHce6gw6
         d9XFSBC0VrakXCIR7KFgY0qhWdXaxWtyN8z/17omCaogg/A/+Et5vkR4SNixhCFZaiU0
         g7kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vd6rya/rtfsC3Wyfx6Rmnt5QEoiw12dxt+6jkc+paaw=;
        b=QORMhtgrzQrv/RD0f+DydzSfUmt73Rcew4IHlQXvmxvRGJmOCTmjgPvlsni04m4tjL
         pjAv9UyDJuOYDgpC1MukJ+1s7HsYYOwuQ3PZ3XgC36xnCYfp8EHOrn8ZYIzlJnQdh6Dc
         pExjV8u18UNVjwzhZnYRpTANXpubWkLH1RLT6cwktp98BDZjiTuyoXx59mXp+l+6jc7+
         Hqpk3zYePTaOPz8Piccc8NCnOGDxl1MhX5Rkpy1iCt0CJHSHEv8QPefXRpSAYZarzn0S
         +051lLDzhFDgFBqHZO6vkg0ECW+lqZ1VpIfx/f8qFXONNILBBypal+1c/KAOQikCnkdP
         CW1Q==
X-Gm-Message-State: APjAAAWnmWu89wmEI8S4KlQhEvlEO6X0x2pVPQGj3DNQemSrO5BVkldh
        xwDh8TsP7iklD6VnWCIKraDINVkbgOBsB1bFJ09ajQ==
X-Google-Smtp-Source: APXvYqx7M57ySyAAZEwSM21uzVMFDfIJEJJM8TqsVpW2U6GFYtKAk2CxR4HjFMIaquj1wyJaqZVcJoNO0ddd7/rny08=
X-Received: by 2002:a05:600c:10cd:: with SMTP id l13mr3094596wmd.102.1579245256835;
 Thu, 16 Jan 2020 23:14:16 -0800 (PST)
MIME-Version: 1.0
References: <20191223113443.68969-1-anup.patel@wdc.com> <20191223113443.68969-4-anup.patel@wdc.com>
 <mhng-1c0b8288-1b2b-4172-b224-5277a9d3fcaa@palmerdabbelt-glaptop>
In-Reply-To: <mhng-1c0b8288-1b2b-4172-b224-5277a9d3fcaa@palmerdabbelt-glaptop>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 17 Jan 2020 12:44:06 +0530
Message-ID: <CAAhSdy1UPS=mfoQHbsZBEAVECCtEES+x1ys63+YXNkcb8ogoSQ@mail.gmail.com>
Subject: Re: [PATCH v10 03/19] RISC-V: Add hypervisor extension related CSR defines
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>, Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 17, 2020 at 1:21 AM Palmer Dabbelt <palmerdabbelt@google.com> wrote:
>
> On Mon, 23 Dec 2019 03:35:33 PST (-0800), Anup Patel wrote:
> > This patch extends asm/csr.h by adding RISC-V hypervisor extension
> > related defines.
> >
> > Signed-off-by: Anup Patel <anup.patel@wdc.com>
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > Reviewed-by: Alexander Graf <graf@amazon.com>
> > ---
> >  arch/riscv/include/asm/csr.h | 78 ++++++++++++++++++++++++++++++++++--
> >  1 file changed, 75 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> > index 0a62d2d68455..afb6733475c2 100644
> > --- a/arch/riscv/include/asm/csr.h
> > +++ b/arch/riscv/include/asm/csr.h
> > @@ -30,6 +30,8 @@
> >  #define SR_XS_CLEAN  _AC(0x00010000, UL)
> >  #define SR_XS_DIRTY  _AC(0x00018000, UL)
> >
> > +#define SR_MXR               _AC(0x00080000, UL)
> > +
> >  #ifndef CONFIG_64BIT
> >  #define SR_SD                _AC(0x80000000, UL) /* FS/XS dirty */
> >  #else
> > @@ -51,26 +53,74 @@
> >  #define CAUSE_IRQ_FLAG               (_AC(1, UL) << (__riscv_xlen - 1))
> >
> >  /* Interrupt causes (minus the high bit) */
> > -#define IRQ_U_SOFT           0
> >  #define IRQ_S_SOFT           1
> > +#define IRQ_VS_SOFT          2
>
> Again: please don't mix up cleanups with the KVM port.  It's reasonable to
> remove the N extension cruft as it's still in draft and we probably won't
> implement it in Linux, but that shouldn't be mixed up with the KVM
> implementation.

Sure, I will send separate patch for removing IRQ_U_xyz defines
and have only H-extension related defines here.

Regards,
Anup

>
> >  #define IRQ_M_SOFT           3
> > -#define IRQ_U_TIMER          4
> >  #define IRQ_S_TIMER          5
> > +#define IRQ_VS_TIMER         6
> >  #define IRQ_M_TIMER          7
> > -#define IRQ_U_EXT            8
> >  #define IRQ_S_EXT            9
> > +#define IRQ_VS_EXT           10
> >  #define IRQ_M_EXT            11
> >
> >  /* Exception causes */
> >  #define EXC_INST_MISALIGNED  0
> >  #define EXC_INST_ACCESS              1
> > +#define EXC_INST_ILLEGAL     2
> >  #define EXC_BREAKPOINT               3
> >  #define EXC_LOAD_ACCESS              5
> >  #define EXC_STORE_ACCESS     7
> >  #define EXC_SYSCALL          8
> > +#define EXC_HYPERVISOR_SYSCALL       9
> > +#define EXC_SUPERVISOR_SYSCALL       10
> >  #define EXC_INST_PAGE_FAULT  12
> >  #define EXC_LOAD_PAGE_FAULT  13
> >  #define EXC_STORE_PAGE_FAULT 15
> > +#define EXC_INST_GUEST_PAGE_FAULT    20
> > +#define EXC_LOAD_GUEST_PAGE_FAULT    21
> > +#define EXC_STORE_GUEST_PAGE_FAULT   23
> > +
> > +/* HSTATUS flags */
> > +#define HSTATUS_VTSR         _AC(0x00400000, UL)
> > +#define HSTATUS_VTVM         _AC(0x00100000, UL)
> > +#define HSTATUS_SP2V         _AC(0x00000200, UL)
> > +#define HSTATUS_SP2P         _AC(0x00000100, UL)
> > +#define HSTATUS_SPV          _AC(0x00000080, UL)
> > +#define HSTATUS_SPRV         _AC(0x00000001, UL)
> > +
> > +/* HGATP flags */
> > +#define HGATP_MODE_OFF               _AC(0, UL)
> > +#define HGATP_MODE_SV32X4    _AC(1, UL)
> > +#define HGATP_MODE_SV39X4    _AC(8, UL)
> > +#define HGATP_MODE_SV48X4    _AC(9, UL)
> > +
> > +#define HGATP32_MODE_SHIFT   31
> > +#define HGATP32_VMID_SHIFT   22
> > +#define HGATP32_VMID_MASK    _AC(0x1FC00000, UL)
> > +#define HGATP32_PPN          _AC(0x003FFFFF, UL)
> > +
> > +#define HGATP64_MODE_SHIFT   60
> > +#define HGATP64_VMID_SHIFT   44
> > +#define HGATP64_VMID_MASK    _AC(0x03FFF00000000000, UL)
> > +#define HGATP64_PPN          _AC(0x00000FFFFFFFFFFF, UL)
> > +
> > +#ifdef CONFIG_64BIT
> > +#define HGATP_PPN            HGATP64_PPN
> > +#define HGATP_VMID_SHIFT     HGATP64_VMID_SHIFT
> > +#define HGATP_VMID_MASK              HGATP64_VMID_MASK
> > +#define HGATP_MODE           (HGATP_MODE_SV39X4 << HGATP64_MODE_SHIFT)
> > +#else
> > +#define HGATP_PPN            HGATP32_PPN
> > +#define HGATP_VMID_SHIFT     HGATP32_VMID_SHIFT
> > +#define HGATP_VMID_MASK              HGATP32_VMID_MASK
> > +#define HGATP_MODE           (HGATP_MODE_SV32X4 << HGATP32_MODE_SHIFT)
> > +#endif
> > +
> > +/* VSIP & HIP relation */
> > +#define VSIP_TO_HIP_SHIFT    (IRQ_VS_SOFT - IRQ_S_SOFT)
> > +#define VSIP_VALID_MASK              ((_AC(1, UL) << IRQ_S_SOFT) | \
> > +                              (_AC(1, UL) << IRQ_S_TIMER) | \
> > +                              (_AC(1, UL) << IRQ_S_EXT))
> >
> >  /* symbolic CSR names: */
> >  #define CSR_CYCLE            0xc00
> > @@ -91,6 +141,28 @@
> >  #define CSR_SIP                      0x144
> >  #define CSR_SATP             0x180
> >
> > +#define CSR_VSSTATUS         0x200
> > +#define CSR_VSIE             0x204
> > +#define CSR_VSTVEC           0x205
> > +#define CSR_VSSCRATCH                0x240
> > +#define CSR_VSEPC            0x241
> > +#define CSR_VSCAUSE          0x242
> > +#define CSR_VSTVAL           0x243
> > +#define CSR_VSIP             0x244
> > +#define CSR_VSATP            0x280
> > +
> > +#define CSR_HSTATUS          0x600
> > +#define CSR_HEDELEG          0x602
> > +#define CSR_HIDELEG          0x603
> > +#define CSR_HIE                      0x604
> > +#define CSR_HTIMEDELTA               0x605
> > +#define CSR_HTIMEDELTAH              0x615
> > +#define CSR_HCOUNTERNEN              0x606
> > +#define CSR_HTVAL            0x643
> > +#define CSR_HIP                      0x644
> > +#define CSR_HTINST           0x64a
> > +#define CSR_HGATP            0x680
> > +
> >  #define CSR_MSTATUS          0x300
> >  #define CSR_MISA             0x301
> >  #define CSR_MIE                      0x304
> > --
> > 2.17.1
