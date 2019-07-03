Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF4CF5DA1F
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 03:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfGCBBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 21:01:47 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41238 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbfGCBBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 21:01:47 -0400
Received: by mail-oi1-f195.google.com with SMTP id g7so595183oia.8;
        Tue, 02 Jul 2019 18:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6/KKy82yrOyc29Ht7hH/jAIFLpMnSWEdvNOCoBZFw1Q=;
        b=jhKjrysD7F3YEX73eCP0zuxoN6eVgP3fOptbLegmT5vwCHuRLQkMVOkWYkMbzxl5yH
         MAPKEPsSy88O1W93Pwyqx6t6PdfVij0gqHjeTlllhAT5xXjk4vC0e0xS2YOVznLEohJ0
         Ol7aRIz74oGk5py35ew6KskxFs0Ciul9PxBuG0YoYFJE1XIJ/VoiQnZYH02UTVhMVqKL
         sP3hxGTSAew8NrQ9BVm3xIGmkltHe4zXtNxc7+yKFYfDf1ix7rwEtdxEzVegKYG6rfFX
         HqKH2vVeJXRjHd0nOKULDjPbGIVfyVIBVZ8FF7n3v/uOw7hIcJu/CPMd+U85C+CCnpNl
         PDzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6/KKy82yrOyc29Ht7hH/jAIFLpMnSWEdvNOCoBZFw1Q=;
        b=pNNa2BLLH8j0w2xCDeDNwYRmeTAUZ7p912N2tq+K6rD76Zdy4gZX09nSdtl7UzF+Kp
         BCuwWW+sBtDLfnuHijo94ZtugEHElxVALxdzfCDjxbAk8LA83XBPX4ZC3W+mEpQT8MpD
         Umx2eK0bK4Xfdu4AwfeyqvskBRc5295O3W9IATTw8kD+Xz0UDsT9TJNzXPT4GGB1jX4c
         RjTcJMmgpIYW0XNWCM05x3Oy9MN/wp7kRXF1u5QPDKSI7XXBWE8sDSZH/oD1y8uEretZ
         xeLKSRerPa5fcyuDzxYflCpp5G0GwaQdbiqiG7r2PJKmoHTNp9U92V1ymYvvxRRPnzW8
         Pgyw==
X-Gm-Message-State: APjAAAVjuP8qmeyQmSK7y17+f09nZcDSh8f+WZy/4ZBQcVyA6+W/QFpF
        95dGRf1pNwFLAIAsR4ITF+bF82s+p800gCTonP02bQ==
X-Google-Smtp-Source: APXvYqz/BvsXGBiKuGtL9K1WWZnAhl10U8iozK1Qx/ukOJphcCT5NdWPIUM19XiKiGta7BHHDLEmcIg8i8/9HNaV+Ks=
X-Received: by 2002:aca:544b:: with SMTP id i72mr5142037oib.174.1562115706420;
 Tue, 02 Jul 2019 18:01:46 -0700 (PDT)
MIME-Version: 1.0
References: <1561110002-4438-1-git-send-email-wanpengli@tencent.com>
 <1fbd236a-f7f9-e66a-e08c-bf2bac901d15@redhat.com> <20190702222330.GB26621@amt.cnet>
 <CANRm+CyBjfa5LsMx87faKUO8XwHkNVrq4+P+vBuFGwjuFC1jxA@mail.gmail.com>
In-Reply-To: <CANRm+CyBjfa5LsMx87faKUO8XwHkNVrq4+P+vBuFGwjuFC1jxA@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 3 Jul 2019 09:01:39 +0800
Message-ID: <CANRm+CwtWnfLmwKJSW1o3v2E6WOrKWE-iMo46tKKhERZPe+1VA@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] KVM: LAPIC: Implement Exitless Timer
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 3 Jul 2019 at 08:47, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> On Wed, 3 Jul 2019 at 06:23, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >
> > On Tue, Jul 02, 2019 at 06:38:56PM +0200, Paolo Bonzini wrote:
> > > On 21/06/19 11:39, Wanpeng Li wrote:
> > > > Dedicated instances are currently disturbed by unnecessary jitter due
> > > > to the emulated lapic timers fire on the same pCPUs which vCPUs resident.
> > > > There is no hardware virtual timer on Intel for guest like ARM. Both
> > > > programming timer in guest and the emulated timer fires incur vmexits.
> > > > This patchset tries to avoid vmexit which is incurred by the emulated
> > > > timer fires in dedicated instance scenario.
> > > >
> > > > When nohz_full is enabled in dedicated instances scenario, the unpinned
> > > > timer will be moved to the nearest busy housekeepers after commit
> > > > 9642d18eee2cd (nohz: Affine unpinned timers to housekeepers) and commit
> > > > 444969223c8 ("sched/nohz: Fix affine unpinned timers mess"). However,
> > > > KVM always makes lapic timer pinned to the pCPU which vCPU residents, the
> > > > reason is explained by commit 61abdbe0 (kvm: x86: make lapic hrtimer
> > > > pinned). Actually, these emulated timers can be offload to the housekeeping
> > > > cpus since APICv is really common in recent years. The guest timer interrupt
> > > > is injected by posted-interrupt which is delivered by housekeeping cpu
> > > > once the emulated timer fires.
> > > >
> > > > The host admin should fine tuned, e.g. dedicated instances scenario w/
> > > > nohz_full cover the pCPUs which vCPUs resident, several pCPUs surplus
> > > > for busy housekeeping, disable mwait/hlt/pause vmexits to keep in non-root
> > > > mode, ~3% redis performance benefit can be observed on Skylake server.
> > >
> > > Marcelo,
> > >
> > > does this patch work for you or can you still see the oops?
> >
> > Hi Paolo,
> >
> > No more oopses with kvm/queue. Can you include:
>
> Cool, thanks for the confirm, Marcelo!
>
> >
> > Index: kvm/arch/x86/kvm/lapic.c
> > ===================================================================
> > --- kvm.orig/arch/x86/kvm/lapic.c
> > +++ kvm/arch/x86/kvm/lapic.c
> > @@ -124,8 +124,7 @@ static inline u32 kvm_x2apic_id(struct k
> >
> >  bool posted_interrupt_inject_timer(struct kvm_vcpu *vcpu)
> >  {
> > -       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
> > -               kvm_hlt_in_guest(vcpu->kvm);
> > +       return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
> >  }
> >  EXPORT_SYMBOL_GPL(posted_interrupt_inject_timer);
> >
> > However, for some reason (hrtimer subsystems responsability) with cyclictest -i 200
> > on the guest, the timer runs on the local CPU:
> >
> >        CPU 1/KVM-9454  [003] d..2   881.674196: get_nohz_timer_target: get_nohz_timer_target 3->0
> >        CPU 1/KVM-9454  [003] d..2   881.674200: get_nohz_timer_target: get_nohz_timer_target 3->0
> >        CPU 1/KVM-9454  [003] d.h.   881.674387: apic_timer_fn <-__hrtimer_run_queues
> >        CPU 1/KVM-9454  [003] d..2   881.674393: get_nohz_timer_target: get_nohz_timer_target 3->0
> >        CPU 1/KVM-9454  [003] d..2   881.674395: get_nohz_timer_target: get_nohz_timer_target 3->0
> >        CPU 1/KVM-9454  [003] d..2   881.674399: get_nohz_timer_target: get_nohz_timer_target 3->0
> >        CPU 1/KVM-9454  [003] d.h.   881.674586: apic_timer_fn <-__hrtimer_run_queues
> >        CPU 1/KVM-9454  [003] d..2   881.674593: get_nohz_timer_target: get_nohz_timer_target 3->0
> >        CPU 1/KVM-9454  [003] d..2   881.674595: get_nohz_timer_target: get_nohz_timer_target 3->0
> >        CPU 1/KVM-9454  [003] d..2   881.674599: get_nohz_timer_target: get_nohz_timer_target 3->0
> >        CPU 1/KVM-9454  [003] d.h.   881.674787: apic_timer_fn <-__hrtimer_run_queues
> >        CPU 1/KVM-9454  [003] d..2   881.674793: get_nohz_timer_target: get_nohz_timer_target 3->0
> >        CPU 1/KVM-9454  [003] d..2   881.674795: get_nohz_timer_target: get_nohz_timer_target 3->0
> >
> > But on boot:
> >
> >        CPU 1/KVM-9454  [003] d..2   578.625394: get_nohz_timer_target: get_nohz_timer_target 3->0
> >           <idle>-0     [000] d.h1   578.626390: apic_timer_fn <-__hrtimer_run_queues
> >           <idle>-0     [000] d.h1   578.626394: apic_timer_fn<-__hrtimer_run_queues
> >        CPU 1/KVM-9454  [003] d..2   578.626401: get_nohz_timer_target: get_nohz_timer_target 3->0
> >           <idle>-0     [000] d.h1   578.628397: apic_timer_fn <-__hrtimer_run_queues
> >        CPU 1/KVM-9454  [003] d..2   578.628407: get_nohz_timer_target: get_nohz_timer_target 3->0
> >           <idle>-0     [000] d.h1   578.631403: apic_timer_fn <-__hrtimer_run_queues
> >        CPU 1/KVM-9454  [003] d..2   578.631413: get_nohz_timer_target: get_nohz_timer_target 3->0
> >           <idle>-0     [000] d.h1   578.635409: apic_timer_fn <-__hrtimer_run_queues
> >        CPU 1/KVM-9454  [003] d..2   578.635419: get_nohz_timer_target: get_nohz_timer_target 3->0
> >           <idle>-0     [000] d.h1   578.640415: apic_timer_fn <-__hrtimer_run_queues
>
> You have an idle housekeeping cpu(cpu 0), however, most of
> housekeeping cpus will be busy in product environment to avoid to
> waste money. get_nohz_timer_target() will find a busy housekeeping cpu
> but the timer migration will fail if the timer is the first expiring
> timer on the new target(as the comments above the function
> switch_hrtimer_base()). Please try taskset -c 0 stress --cpu 1 on your
> host, you can observe(through /proc/timer_list) apic_timer_fn running
> on cpu 0 most of the time and sporadically on local cpu.

Or if you have a little bigger VM/multiple VMs, the apic_timer_fn from
all virtual lapics will make a housekeeping cpu busy. :)

Regards,
Wanpeng Li
