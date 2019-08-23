Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32EBF9AF18
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 14:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390358AbfHWMTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 08:19:21 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43178 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731361AbfHWMTT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 08:19:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id y8so8427367wrn.10
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 05:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OYnKooGAz/mlH//vFYVeCnlGLtd4YMyaR7dMhD5g3Ao=;
        b=egKRBOY6T+iHEx6i2bpwOVrDK5E+iUy/1Jr2VP37Xdy4TLrla+q4pkZndjdXqnHiHK
         mtaTLIxuZBDXoLfDMhs4tYjjWnmMGtyl5dLbT1yCedbE7MMf8Mh90hvJdKJp+3qcI/tW
         MtUpYrMIf91Fd5vQMkm5yeMAHyx2FZ7jSNafbeDlyDfN9gxyJjsa4K1f68DNVX5C0VpA
         4zzgHgKKf74NPSusdkLYUGCaL7ep7967MErfnLWERuCwcRGWnaSBe7OQYYS/k/DQ+e8I
         Pj5tnbOCxnwiNxiDgpGICI9Do0qy2STOJpt8GCil1Kr5guweLZFAsmmdrDdHNVzdPm2z
         iUUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OYnKooGAz/mlH//vFYVeCnlGLtd4YMyaR7dMhD5g3Ao=;
        b=PDVkvnfVtbrZ+uAlJHErTQ9uGqsFc7eYytT72uF+LGh1YEZotwAzykYSIbsJN+DPWX
         KhnPwADW3ul45IE4ysrun95fBVLOUdDRhlO3kStg7aCL5Tqgp7/7d+YBAkkLZcuodWDL
         VvWU+e2bTuIGZ+zDxW80h9kA/abFm3QOKOSXUBbjSMa//lSHGSt4ZSEKSHxTu6azEXB9
         ns5LXcg9senUHuGRZCNtDEJyiraf2AnH6snDjW2+EITrriCwWQ/1IYbUcF9YLzHTts/w
         0+wuFiod8ypdZvlXk957zaA53+07/AsQrNJl2228u4Jve/2cThGujvLEWpHDl0E06zUA
         gXZg==
X-Gm-Message-State: APjAAAXV+CaX22iMz9Ao8AO3aw0H7JinlkF+ssUZzcSyFbXG8gkdFc+S
        2FEZJmtExn/oMqHZbsB7eifNEULfiYnis0hVI/+Ong==
X-Google-Smtp-Source: APXvYqyiffUPdRbthtoeU5iHSxUcXZATp2nwKI/3hiwIGiM2dZnwJz+txTHd6WA3LOy2smUSPUERZ3sDle/MwMI8wro=
X-Received: by 2002:adf:f641:: with SMTP id x1mr4992458wrp.179.1566562756752;
 Fri, 23 Aug 2019 05:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190822084131.114764-1-anup.patel@wdc.com> <8a2a9ea6-5636-e79a-b041-580159e703b2@amazon.com>
 <CAAhSdy2RC6Gw708wZs+FM56UkkyURgbupwdeTak7VcyarY9irg@mail.gmail.com>
 <757C929B-D26C-46D9-98E8-1191E3B86F3C@amazon.com> <fda67a5d-6984-c3ef-8125-7805d927f15b@redhat.com>
In-Reply-To: <fda67a5d-6984-c3ef-8125-7805d927f15b@redhat.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 23 Aug 2019 17:49:05 +0530
Message-ID: <CAAhSdy1k96m8GinxAhcfRL_gOxCzK+ODfyjDxCmr-AF2ycntwA@mail.gmail.com>
Subject: Re: [PATCH v5 00/20] KVM RISC-V Support
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Graf (AWS), Alexander" <graf@amazon.com>,
        Anup Patel <Anup.Patel@wdc.com>,
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

On Fri, Aug 23, 2019 at 5:40 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 23/08/19 13:44, Graf (AWS), Alexander wrote:
> >> Overall, I'm quite happy with the code. It's a very clean implementation
> >> of a KVM target.
>
> Yup, I said the same even for v1 (I prefer recursive implementation of
> page table walking but that's all I can say).
>
> >> I will send v6 next week. I will try my best to implement unpriv
> >> trap handling in v6 itself.
> > Are you sure unpriv is the only exception that can hit there? What
> > about NMIs? Do you have #MCs yet (ECC errors)? Do you have something
> > like ARM's #SError which can asynchronously hit at any time because
> > of external bus (PCI) errors?
>
> As far as I know, all interrupts on RISC-V are disabled by
> local_irq_disable()/local_irq_enable().

Yes, we don't have per-CPU interrupts for async bus errors or
non-maskable interrupts. The local_irq_disable() and local_irq_enable()
affect all interrupts (excepts traps).

Although, the async bus errors can certainly be routed to Linux
via PLIC (interrupt-controller) as regular peripheral interrupts.

Regards,
Anup

>
> Paolo
