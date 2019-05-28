Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95D142BF17
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 08:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfE1GLM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 02:11:12 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:41618 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfE1GLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 02:11:12 -0400
Received: by mail-ot1-f65.google.com with SMTP id l25so16649143otp.8;
        Mon, 27 May 2019 23:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fBewjNEj/uZLnzd5cPgjsqFHK+r7svr6zmAyQSTmTS8=;
        b=ho2JQOaQKE4CptzxByMEKyRRuT0MJv2VE9omRHYfZyze8qjnrNWWeq1DpkJoh/3hU+
         PLgbGKR/70FNgRrmdum8iI9ehJzGhBImvfd9nZV+YrHao23j6ZFyV/1fALReiyoHjT5d
         NX+0HuMNaBt522IF7Ha6MFXWa/n2eIIQYymP3izlgMzpXHM5v/9XgTssX6DR/zL+loCK
         Tt8geRZG24qn+XtQffesw977eCC+0BSnAt/EbnGgd7MryLxXfuE112YM5mCz7xtB3rpy
         1otdtdYXEbDFUrLKXNa/sX70L6Ncr0WBvk7ms9qCRAOdp9qa+vKjXn8ylCNwGOIhSZ51
         vz7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fBewjNEj/uZLnzd5cPgjsqFHK+r7svr6zmAyQSTmTS8=;
        b=CGermeW+cTk5yau/TtMGLTO9mrjS8YFPhp9zjoBzGdzrpIBjJnRFXABuXI91rkFMGm
         DwmKL0e6m5mpJ1RF+o2ZRaJGH/22I4/dsjEDziXlz6kaEG9oQDvbQYwQN69jZ9/0ZcdL
         EEYhRktwg1AUlwyoY/YnMbr1SldCRCLYu+WUgNvNvjT9ScuQsVyZOVEIYAkab62KiKIA
         yNfMrFTzVxWHqH1pjOpDvcGsEr4GHdWpwhYLygMWPF1/wAx9V901iDgo+s6BrjVZEH/R
         TMsHCar3hlWehpYdHE5cLb40nIo4aw/yk/fSxgAgp5Wq8r4+VIri8HGj/HeKYdGWWcQL
         dbfg==
X-Gm-Message-State: APjAAAUYfTDyBdJW4M38gL3jPAfkG/tZKHcCeFzzh0ia4Bml02dpR26O
        glevPAcSfsEuI0a/SGKgrs/G5PSkAr035ucSob8=
X-Google-Smtp-Source: APXvYqzNQK/84+2BafSURzC6bZbOtrJ7cx2x9ypaM3vtdt/dLQnBIQu6rQkNywZPAV1pQp4YWHnKEwVMihNiXEKNLwU=
X-Received: by 2002:a9d:6312:: with SMTP id q18mr24589147otk.45.1559023871580;
 Mon, 27 May 2019 23:11:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190524075637.29496-1-tao3.xu@intel.com> <20190524075637.29496-2-tao3.xu@intel.com>
 <20190527103003.GX2623@hirez.programming.kicks-ass.net> <43e2a62a-e992-2138-f038-1e4b2fb79ad1@intel.com>
In-Reply-To: <43e2a62a-e992-2138-f038-1e4b2fb79ad1@intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 28 May 2019 14:11:04 +0800
Message-ID: <CANRm+CwnJoj0EwWoFC44SXVUTLdE+iFGovaMr4Yf=OzbaW36sA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: add support for user wait instructions
To:     Tao Xu <tao3.xu@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm <kvm@vger.kernel.org>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, jingqi.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 May 2019 at 13:16, Tao Xu <tao3.xu@intel.com> wrote:
>
>
> On 27/05/2019 18:30, Peter Zijlstra wrote:
> > On Fri, May 24, 2019 at 03:56:35PM +0800, Tao Xu wrote:
> >> This patch adds support for UMONITOR, UMWAIT and TPAUSE instructions
> >> in kvm, and by default dont't expose it to kvm and provide a capability
> >> to enable it.
> >
> > I'm thinking this should be conditional on the guest being a 1:1 guest,
> > and I also seem to remember we have bits for that already -- they were
> > used to disable paravirt spinlocks for example.
> >
>
> Hi Peter,
>
> I am wondering if "1:1 guest" means different guests in the same host
> should have different settings on user wait instructions?
>
> User wait instructions(UMONITOR, UMWAIT and TPAUSE) can use in guest
> only when the VMCS Secondary Processor-Based VM-Execution Control bit 26
> is 1, otherwise any execution of TPAUSE, UMONITOR, or UMWAIT causes a #UD.
>
> So with a capability to enable it, we use qemu kvm_vm_ioctl_enable_cap()
> to enable it. The qemu link is blew:
> https://lists.gnu.org/archive/html/qemu-devel/2019-05/msg05810.html
>
> By using different QEMU parameters, different guests in the same host
> would have different features with or without user wait instructions.
>
> About "disable paravirt spinlocks" case, I am wondering if it uses

Please refer to a4429e53c9 (KVM: Introduce paravirtualization hints
and KVM_HINTS_DEDICATED) and b2798ba0b87 (KVM: X86: Choose qspinlock
when dedicated physical CPUs are available).

> kernel parameters? If it uses kernel parameters, different guests in the
> same host may have same settings on user wait instructions.
>
> Or when we uses kernel parameters to disable user wait instructions, for
> a host chooses to enable user wait instructions, we should do some work
> on QEMU to choose disable or enable user wait instructions?
>
> Thanks
>
> Tao
