Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB005103683
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 10:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbfKTJTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 04:19:54 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44386 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbfKTJTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 04:19:53 -0500
Received: by mail-oi1-f194.google.com with SMTP id s71so21844212oih.11
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 01:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/s9d0eBsNWs0S7Z9/kGU3/sKlBy60Nmwo0VOQi3Qb+Q=;
        b=fwFJNysxLxM2AKjob5AiJs/ELSpJ11PRSrh51RQPPhmCCuK3A4na/FO7Njmao1p7wQ
         tTv8qEj9qMeLRIFiE5eT1zrGAnHkGqSgQPJIWGvZOI+po9xrDrl21wjPigjyzMepqYuG
         nz9iThvffKTtjsMLk3OeXawHQa3oV+5st/L5K9y82DpJq/D2ZmrRJOFHScKHXWv1pQWA
         qvDFO0AVF5ED62wvuPTo+C9LPejE1Y5NFIyJR2vaGejXq5JsZyJe7ZDwNsbaZjnpYMH+
         MOR5GmVZH9aJ4kWCuK2QfJ1kP3i4shpadIkNVJoiwKqwFeyYv+/48T/jahCqquAKgOGE
         xaPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/s9d0eBsNWs0S7Z9/kGU3/sKlBy60Nmwo0VOQi3Qb+Q=;
        b=ZiPuDhH36+5+AWuc/2eX0vnSU2Uc1uF9wWffZ6h/5SXSVTG/dWhGLxC7vv0JyXqAUr
         dVHuddtfCLh56esNg8dqLtLalRvFd5Kn+q2pz0jsYfbgDxsFdKHdH+WzQVbotZXHxEHy
         r6msucugBypy0rBhOfsc5Xom7msrZkPtfqix4tis+XmGassMkJNF/+3L1zisUcvYOQxA
         nPJ4i8sJa+ZCBWUsYWxYxYffgEVMvrarp0wWd9wW9Da15ONMwtxPPa2mYBrn5nm4wAia
         DoatCkw/lGqAA/K857Yja5tBIscagZSIp4oIch+gkXpm4A0b8it5UsKMbEUzcbNPnQoh
         bboQ==
X-Gm-Message-State: APjAAAWzk/uQbRLamyeoyMdhO1afJCTFFRBRMrXIAq8Mcpf4kpi3p9nE
        8sBgd7PsPRSqY2JQN5t6j6LjJddx6aoT8SSDghk=
X-Google-Smtp-Source: APXvYqzQdC4lHcM7mhXa2zkZqPmHjIOt/84guLgyrBZu9PczPhhMRqkd+jQeue2BhZrSPGkum5P4ca+yKtveBJVRdZg=
X-Received: by 2002:a54:4783:: with SMTP id o3mr1848694oic.33.1574241592857;
 Wed, 20 Nov 2019 01:19:52 -0800 (PST)
MIME-Version: 1.0
References: <1e525b08-6204-3238-5d56-513f82f1d7fb@djy.llc> <20191016112857.293a197d@x1.home>
 <20191016174943.GG5866@linux.intel.com> <53f506b3-e864-b3ca-f18f-f8e9a1612072@djy.llc>
 <20191022202847.GO2343@linux.intel.com> <4af8cbac-39b1-1a20-8e26-54a37189fe32@djy.llc>
 <20191024173212.GC20633@linux.intel.com> <36be1503-f6f1-0ed0-b1fe-9c05d827f624@djy.llc>
 <20191119200133.GD25672@linux.intel.com>
In-Reply-To: <20191119200133.GD25672@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 20 Nov 2019 17:19:45 +0800
Message-ID: <CANRm+CzuYvZ-97EtYaCTT2GgCACKMvGGHbY_bWMZ90Z3-4TVrg@mail.gmail.com>
Subject: Re: PROBLEM: Regression of MMU causing guest VM application errors
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Derek Yerger <derek@djy.llc>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm <kvm@vger.kernel.org>, "Bonzini, Paolo" <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Nov 2019 at 04:03, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Wed, Oct 30, 2019 at 11:44:09PM -0400, Derek Yerger wrote:
> >
> > On 10/24/19 1:32 PM, Sean Christopherson wrote:
> > >On Thu, Oct 24, 2019 at 11:18:59AM -0400, Derek Yerger wrote:
> > >>On 10/22/19 4:28 PM, Sean Christopherson wrote:
> > >>>On Thu, Oct 17, 2019 at 07:57:35PM -0400, Derek Yerger wrote:
> > >>>Heh, should've checked from the get go...  It's definitely not the memslot
> > >>>issue, because the memslot bug is in 5.1.16 as well.  :-)
> > >>I didn't pick up on that, nice catch. The memslot thread was the closest
> > >>thing I could find to an educated guess.
> > >>>>I'm stuck on 5.1.x for now, maybe I'll give up and get a dedicated windows
> > >>>>machine /s
> > >>>What hardware are you running on?  I was thinking this was AMD specific,
> > >>>but then realized you said "AMD Radeon 540 GPU" and not "AMD CPU".
> > >>Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz
> > >>
> > >>07:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI]
> > >>Lexa PRO [Radeon 540/540X/550/550X / RX 540X/550/550X] (rev c7)
> > >>         Subsystem: Gigabyte Technology Co., Ltd Device 22fe
> > >>         Kernel driver in use: vfio-pci
> > >>         Kernel modules: amdgpu
> > >>(plus related audio device)
> > >>
> > >>I can't think of any other data points that would be helpful to solving
> > >>system instability in a guest OS.
> > >Can you bisect starting from v5.2?  Identifying which commit in the kernel
> > >introduced the regression would help immensely.
> > On the host, I have to install NVIDIA GPU drivers with each new kernel
> > build. During the process I discovered that I can't reproduce the issue on
> > any kernel if I skip the *host* GPU drivers and start libvirtd in single
> > mode.
> >
> > I noticed the following in the host kernel log around the time the guest
> > encountered BSOD on 5.2.7:
> >
> > [  337.841491] WARNING: CPU: 6 PID: 7548 at arch/x86/kvm/x86.c:7963
> > kvm_arch_vcpu_ioctl_run+0x19b1/0x1b00 [kvm]
>
> Rats, I overlooked this first time round.  In the future, if you get a
> WARN splat, try to make it very obvious in the bug report, they're almost
> always a smoking gun.
>
> That WARN that fired is:
>
>         /* The preempt notifier should have taken care of the FPU already.  */
>         WARN_ON_ONCE(test_thread_flag(TIF_NEED_FPU_LOAD));
>
> which was added part of a bug fix by commit:
>
>         240c35a3783a ("kvm: x86: Use task structs fpu field for user")
>
> the buggy commit that was fixed is
>
>         5f409e20b794 ("x86/fpu: Defer FPU state load until return to userspace")
>
> which was part of a FPU rewrite that went into 5.2[*].  So yep, big
> smoking gun :-)

Since 5.3-rc2, we have three commits fix it.

commitec269475cba7bc (Revert "kvm: x86: Use task structs fpu field for user")
commite751732486eb3 (KVM: X86: Fix fpu state crash in kvm guest)
commitd9a710e5fc4941 (KVM: X86: Dynamically allocate user_fpu)

    Wanpeng
