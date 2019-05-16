Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E43B41FD4C
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 03:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfEPBqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 21:46:32 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35697 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbfEPBGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 21:06:13 -0400
Received: by mail-ot1-f68.google.com with SMTP id n14so1883481otk.2;
        Wed, 15 May 2019 18:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J6f1GZ8vCMw819yikh69VjuQxUpy7OYmJvnY0pJldzc=;
        b=VCQOndVdDPVpCcmRB4XI4mPyBaz8hFP/tZZ+OrKuD/J0xM/ZN9hbmJne51MgjHXpsc
         mSclLtRVpK8X/6tfslh8J5RQQoR3HciSPXP9Iup6nZdYzKEkaIK4RW1YUDJybCZy9BTQ
         Rd8KH/9Lu/TYSmVYnyp7BfMk0xO9NuHm9MIwG9ic5Kud59FrMya2LROAt06ksGGwef+8
         jCtGhkqbq6tGS3szt6Y1Y3SbSEnWLIneuWvC8XbsLEqoYRKPwj2NM+2pl217TGYJZyEh
         odBvDMneEHV4RABX+U9+HECmzcx4/BX7BNXbD0El0Ll68ZbxCLj4G+LX1bmuDZ9CMc8w
         mvIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J6f1GZ8vCMw819yikh69VjuQxUpy7OYmJvnY0pJldzc=;
        b=nPF0OkWvklQVe4YjDAA++qQoyAFMOWKhEGRIqKgswNbSuBgcVY1l7f4ovYesQnUMHz
         Pis7vA4lx3WJei5IVINIjui6GivwqByZ/HwK6YKiU80P2PwUODetFHRaQyBkU/KsAvNR
         SHj9RP1l5tIQYbI2r3SvXVqIAGxtYr/1zC3UCjRG3tKIuGxFxeGGbyReT7jyxafGPWZ3
         f04ldeKwtH+ttz+nR6hG0fKfkDdTmgcul7KmFYA5bv/jf82A1Jt9cLuwPme0Hk4ETsRV
         E70UWCrqctuZB5cbajfdQvpXzzbNITDaQmw2D6Jvi7CET/3Qd8u/Gmm0pgm9JivlAYoz
         Mvkg==
X-Gm-Message-State: APjAAAX+abP34F0S+TLCcL6NSNQBKFO4x3jJpwr7CXhywxlqSmyVGisc
        TxS/YJB/h5z2h3WcsG6VilyhI7AauSweBCdBZKs=
X-Google-Smtp-Source: APXvYqyUghYepUxVunBrQJsSOb/EkGSL/LU3bonenux+W/r6y1N76kWBBLy2tg3qyc1ZMcipE5G908BUMvPkPl9jC14=
X-Received: by 2002:a05:6830:1356:: with SMTP id r22mr5792502otq.191.1557968772119;
 Wed, 15 May 2019 18:06:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190507185647.GA29409@amt.cnet> <CANRm+Cx8zCDG6Oz1m9eukkmx_uVFYcQOdMwZrHwsQcbLm_kuPA@mail.gmail.com>
 <20190514135022.GD4392@amt.cnet> <7e390fef-e0df-963f-4e18-e44ac2766be3@oracle.com>
In-Reply-To: <7e390fef-e0df-963f-4e18-e44ac2766be3@oracle.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 16 May 2019 09:07:32 +0800
Message-ID: <CANRm+CyrLneGkOXzEmGyB-Sr+DOqqDAF4eNB1YBpbhm3Edo3Gw@mail.gmail.com>
Subject: Re: [PATCH] sched: introduce configurable delay before entering idle
To:     Ankur Arora <ankur.a.arora@oracle.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 May 2019 at 02:42, Ankur Arora <ankur.a.arora@oracle.com> wrote:
>
> On 5/14/19 6:50 AM, Marcelo Tosatti wrote:
> > On Mon, May 13, 2019 at 05:20:37PM +0800, Wanpeng Li wrote:
> >> On Wed, 8 May 2019 at 02:57, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >>>
> >>>
> >>> Certain workloads perform poorly on KVM compared to baremetal
> >>> due to baremetal's ability to perform mwait on NEED_RESCHED
> >>> bit of task flags (therefore skipping the IPI).
> >>
> >> KVM supports expose mwait to the guest, if it can solve this?
> >>
> >> Regards,
> >> Wanpeng Li
> >
> > Unfortunately mwait in guest is not feasible (uncompatible with multiple
> > guests). Checking whether a paravirt solution is possible.
>
> Hi Marcelo,
>
> I was also looking at making MWAIT available to guests in a safe manner:
> whether through emulation or a PV-MWAIT. My (unsolicited) thoughts

MWAIT emulation is not simple, here is a research
https://www.contrib.andrew.cmu.edu/~somlo/OSXKVM/mwait.html

Regards,
Wanpeng Li

> follow.
>
> We basically want to handle this sequence:
>
>      monitor(monitor_address);
>      if (*monitor_address == base_value)
>           mwaitx(max_delay);
>
> Emulation seems problematic because, AFAICS this would happen:
>
>      guest                                   hypervisor
>      =====                                   ====
>
>      monitor(monitor_address);
>          vmexit  ===>                        monitor(monitor_address)
>      if (*monitor_address == base_value)
>           mwait();
>                vmexit    ====>               mwait()
>
> There's a context switch back to the guest in this sequence which seems
> problematic. Both the AMD and Intel specs list system calls and
> far calls as events which would lead to the MWAIT being woken up:
> "Voluntary transitions due to fast system call and far calls (occurring
> prior to issuing MWAIT but after setting the monitor)".
>
>
> We could do this instead:
>
>      guest                                   hypervisor
>      =====                                   ====
>
>      monitor(monitor_address);
>          vmexit  ===>                        cache monitor_address
>      if (*monitor_address == base_value)
>           mwait();
>                vmexit    ====>              monitor(monitor_address)
>                                             mwait()
>
> But, this would miss the "if (*monitor_address == base_value)" check in
> the host which is problematic if *monitor_address changed simultaneously
> when monitor was executed.
> (Similar problem if we cache both the monitor_address and
> *monitor_address.)
>
>
> So, AFAICS, the only thing that would work is the guest offloading the
> whole PV-MWAIT operation.
>
> AFAICS, that could be a paravirt operation which needs three parameters:
> (monitor_address, base_value, max_delay.)
>
> This would allow the guest to offload this whole operation to
> the host:
>      monitor(monitor_address);
>      if (*monitor_address == base_value)
>           mwaitx(max_delay);
>
> I'm guessing you are thinking on similar lines?
>
>
> High level semantics: If the CPU doesn't have any runnable threads, then
> we actually do this version of PV-MWAIT -- arming a timer if necessary
> so we only sleep until the time-slice expires or the MWAIT max_delay does.
>
> If the CPU has any runnable threads then this could still finish its
> time-quanta or we could just do a schedule-out.
>
>
> So the semantics guaranteed to the host would be that PV-MWAIT returns
> after >= max_delay OR with the *monitor_address changed.
>
>
>
> Ankur
