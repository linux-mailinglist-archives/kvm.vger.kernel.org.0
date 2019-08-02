Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2EC7EAE0
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 06:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfHBEAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 00:00:13 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37120 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbfHBEAN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 00:00:13 -0400
Received: by mail-wm1-f67.google.com with SMTP id f17so64950540wme.2
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2019 21:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I/Kfc6ZbOZnKoxJL7rV1rbyTQYfEjNQbR94dlPzKkok=;
        b=RJKKjy4lH/3bgMCwOjm1J18wa06vOSJLnIfHMmvULIy2YSHW3G15WM/m7+XeVtQwTr
         UtiihTcbvICV40K4Nt5x73lPEsV6pBUGS2RPKA5G47fKyoSSsc05AlAuvBSyjU7yAX3Z
         UoEhsAOtv282G86OCYcLO5YN8helw4/uL1qOeUEBiTmpuinXLeVN3veX4kAGMwHIkC65
         EKZaEk2RjAR5n1/oURiPuFkOL29Vt+pAgswdD0zpyPv3xy2fYhEiWrtIozD6TCcfhHcV
         OMLP1cmi5mf327NBxa+CEE9sTtQnunCR/GUerMu62fmDkaROt4YIFVsA2qWBl2CNKsLY
         7Dvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I/Kfc6ZbOZnKoxJL7rV1rbyTQYfEjNQbR94dlPzKkok=;
        b=gOOPrrJHAmCnA6XLl+6Qrc67kVSD4C0mBJ3FR8Wfwi4WkVCLrwZKH3dhUAqIHhRryb
         okZVbJKegmaImk8IOiJCyruFsAFoga0Syt5F46AgvoRbMkzrYIRDnKCbQMrTEtqwoh/D
         S5wMq2244gvWDziO+eTkqMsUR5ssaYl0lbOw8sktgWkyCQbWreW84LNEPm7zhwJSi8OV
         PqASMFefSkzQtYexl9XkUw4V81fSV+6iwr2voJ9nybtOwp/Zml81q8KqdfmZT7npvnqn
         ltMp94eX85sNskw7oNZLhKS/7ozCgwr5wl6H7h29tRUwdaHhuPm2+5qGs5zEjStSVEGc
         DrNQ==
X-Gm-Message-State: APjAAAVkstULgjPZH/zj1CnoZtJtoYq+8p2wWTDyPlttnYad9jtOO5Pt
        q3IBir6mFtI/EUS32xgOg3cG0i0If7n91k6+/6gn8A==
X-Google-Smtp-Source: APXvYqyGKKA06Ook1nC1Ms5baz5sFRFDqfDRQkOGCbnR8q7MWD+Cy/I3+JJpDuoiot2nNz8c8O4OOUXtH5DkcbO6xGI=
X-Received: by 2002:a1c:cfc5:: with SMTP id f188mr1649160wmg.24.1564718409992;
 Thu, 01 Aug 2019 21:00:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190729115544.17895-1-anup.patel@wdc.com> <20190729115544.17895-6-anup.patel@wdc.com>
 <9f9d09e5-49bc-f8e3-cfe1-bd5221e3b683@redhat.com> <CAAhSdy3JZVEEnPnssALaxvCsyznF=rt=7-d5J_OgQEJv6cPhxQ@mail.gmail.com>
 <66c4e468-7a69-31e7-778b-228908f0e737@redhat.com> <CAAhSdy3b-o6y1fsYi1iQcCN=9ZuC98TLCqjHCYAzOCx+N+_89w@mail.gmail.com>
 <828f01a9-2f11-34b6-7753-dc8fa7aa0d18@redhat.com> <CAAhSdy19_dEL7e_sEFYi-hXvhVerm_cr3BdZ-TRw0aTTL-O9ZQ@mail.gmail.com>
 <816c70e7-0ea3-1dde-510e-f1d5c6a02dd5@redhat.com>
In-Reply-To: <816c70e7-0ea3-1dde-510e-f1d5c6a02dd5@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 2 Aug 2019 09:29:59 +0530
Message-ID: <CAAhSdy0Er92SCPSyYj-59PAwXvZkgfWbJQwr_qQKGXp3s43xqA@mail.gmail.com>
Subject: Re: [RFC PATCH 05/16] RISC-V: KVM: Implement VCPU interrupts and
 requests handling
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
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

On Tue, Jul 30, 2019 at 7:38 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 30/07/19 15:35, Anup Patel wrote:
> > On Tue, Jul 30, 2019 at 6:48 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 30/07/19 14:45, Anup Patel wrote:
> >>> Here's some text from RISC-V spec regarding SIP CSR:
> >>> "software interrupt-pending (SSIP) bit in the sip register. A pending
> >>> supervisor-level software interrupt can be cleared by writing 0 to the SSIP bit
> >>> in sip. Supervisor-level software interrupts are disabled when the SSIE bit in
> >>> the sie register is clear."
> >>>
> >>> Without RISC-V hypervisor extension, the SIP is essentially a restricted
> >>> view of MIP CSR. Also as-per above, S-mode SW can only write 0 to SSIP
> >>> bit in SIP CSR whereas it can only be set by M-mode SW or some HW
> >>> mechanism (such as S-mode CLINT).
> >>
> >> But that's not what the spec says.  It just says (just before the
> >> sentence you quoted):
> >>
> >>    A supervisor-level software interrupt is triggered on the current
> >>    hart by writing 1 to its supervisor software interrupt-pending (SSIP)
> >>    bit in the sip register.
> >
> > Unfortunately, this statement does not state who is allowed to write 1
> > in SIP.SSIP bit.
>
> If it doesn't state who is allowed to write 1, whoever has access to sip
> can.
>
> > I quoted MIP CSR documentation to highlight the fact that only M-mode
> > SW can set SSIP bit.
> >
> > In fact, I had same understanding as you have regarding SSIP bit
> > until we had MSIP issue in OpenSBI.
> > (https://github.com/riscv/opensbi/issues/128)
> >
> >> and it's not written anywhere that S-mode SW cannot write 1.  In fact
> >> that text is even under sip, not under mip, so IMO there's no doubt that
> >> S-mode SW _can_ write 1, and the hypervisor must operate accordingly.
> >
> > Without hypervisor support, SIP CSR is nothing but a restricted view of
> > MIP CSR thats why MIP CSR documentation applies here.
>
> But the privileged spec says mip.MSIP is read-only, it cannot be cleared
> (as in the above OpenSBI issue).  So mip.MSIP and sip.SSIP are already
> different in that respect, and I don't see how the spec says that S-mode
> SW cannot set sip.SSIP.
>
> (As an aside, why would M-mode even bother using sip and not mip to
> write 1 to SSIP?).
>
> > I think this discussion deserves a Github issue on RISC-V ISA manual.
>
> Perhaps, but I think it makes more sense this way.  The question remains
> of why M-mode is not allowed to write to MSIP/MEIP/MTIP.  My guess is
> that then MSIP/MEIP/MTIP are simply a read-only view of an external pin,
> so it simplifies hardware a tiny bit by forcing acks to go through the
> MMIO registers.
>
> > If my interpretation is incorrect then it would be really strange that
> > HART in S-mode SW can inject IPI to itself by writing 1 to SIP.SSIP bit.
>
> Well, it can be useful, for example Windows does it when interrupt
> handlers want to schedule some work to happen out of interrupt context.
>  Going through SBI would be unpleasant if it causes an HS-mode trap.

Another way of artificially injecting interrupt would be using interrupt
controller, where Windows can just write to some pending register of
interrupt controller.

I have raised a new Github issue on GitHub for clarity on this. You can
add your comments to this issue as well.
https://github.com/riscv/riscv-isa-manual/issues/425

Also, I have raised a proposal to support mechanism for external entity
(such as PLICv2 with virtualization support) to inject virtual interrupts.
https://github.com/riscv/riscv-isa-manual/issues/429

Regards,
Anup
