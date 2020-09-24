Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E98277789
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 19:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgIXROS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 13:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727292AbgIXROS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 13:14:18 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49834C0613D3
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 10:14:18 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t12so3941868ilh.3
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 10:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d7qA2pCOjfGY2J4C9a3hK7Y31a5puzQn53pmrgclQZw=;
        b=Cm+EnbO8R6Rhe0M3XhAjM3bhfQgVVGxtQDrSKSJqwGM9vAVa9SlC1uUI+DBcqA0dbn
         RjBnswnPvPCsXOX02ryIBI1MkVvQgfyc7IxC03zwSisFAQ97O6/BzPpgsW37W/gQK7o0
         tskxlrU4MHu8vfsfYfTYBX+R5l4bqjjwC/VL1uM13kp2DAL21bfcJgmVf7j+5xnHbd43
         cjWCwkgjQv7UAMtJVQA8fl+qGxtXhBx5KLhF+sT0TD2AheDtjvt66YkNMAkaB736Ghv2
         KTM3XVCWPak4lmsSiS2jy3acc9xYX8IMmS0SeAh+k8TPMH54RgvbUOlTeTh26dexoI2b
         MBHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d7qA2pCOjfGY2J4C9a3hK7Y31a5puzQn53pmrgclQZw=;
        b=VCi57YIH3OdARe9xqPNEqxcR2m1VFYbn3e4vkv2Oq5reIqTL2QZE3A+VkqXqB+ukMM
         ahlGhFY0BQgj1r3fzkV9jfZ5lG0SHYNSMRyDK9r5wd4Suuh2COlYiOzvL27yg8xqzoSO
         b5wjIG/Ljo9qMTzvtSZD0znOSzZ/ysKUZz/3MxtfdVcej3ZdDNGdyBcmHR36xk1Hc1Qj
         NldfcfI8rdftt9s8Z8VpryiLsrdx4AvW7GlG1a6rKZMrJDdltEQMAjjuSpBzdrlgC6Zj
         i/X4ymgPcQY926XqqSUGOyo28ZGt8i612h7K3ZIy6ZF9Poubw38VtRoVsGvsEcGjLsfh
         gplg==
X-Gm-Message-State: AOAM532A4HYZhNBMccrAJLNbJpNpZGZPOwO3sH6t5z2MY6X9g0g2gb1J
        cQv0Rko+gYeFpfMr7vh78WAzVa3MTE0IDRBZk42Lcg==
X-Google-Smtp-Source: ABdhPJyz06U7SojBoggPNrHicGI7L+FubuV3kHzJJXmpoSKX350ajHa+FkeOsjjHvc/Ph1OMKcqvzA620FRalNv082U=
X-Received: by 2002:a92:9a82:: with SMTP id c2mr259843ill.285.1600967657126;
 Thu, 24 Sep 2020 10:14:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1598868203.git.yulei.kernel@gmail.com> <CANRm+CwhTVHXOV6HzawHS5E_ELA3nEw0AxY1-w8vX=EsADWGSw@mail.gmail.com>
 <CANRm+CydqYmVbYz2pkT28wjKFS4AvmZ_iS4Sn1rnHT6G1S_=Mw@mail.gmail.com>
In-Reply-To: <CANRm+CydqYmVbYz2pkT28wjKFS4AvmZ_iS4Sn1rnHT6G1S_=Mw@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 24 Sep 2020 10:14:06 -0700
Message-ID: <CANgfPd8uvkYyHLJh60vSKp1ZDi9T0ZWM9SeXEUm-1da+DqxTEQ@mail.gmail.com>
Subject: Re: [RFC V2 0/9] x86/mmu:Introduce parallel memory virtualization to
 boost performance
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Yulei Zhang <yulei.kernel@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Haiwei Li <lihaiwei.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 23, 2020 at 11:28 PM Wanpeng Li <kernellwp@gmail.com> wrote:
>
> Any comments? Paolo! :)

Hi, sorry to be so late in replying! I wanted to post the first part
of the TDP MMU series I've been working on before responding so we
could discuss the two together, but I haven't been able to get it out
as fast as I would have liked. (I'll send it ASAP!) I'm hopeful that
it will ultimately help address some of the page fault handling and
lock contention issues you're addressing with these patches. I'd also
be happy to work together to add a prepopulation feature to it. I'll
put in some more comments inline below.

> On Wed, 9 Sep 2020 at 11:04, Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > Any comments? guys!
> > On Tue, 1 Sep 2020 at 19:52, <yulei.kernel@gmail.com> wrote:
> > >
> > > From: Yulei Zhang <yulei.kernel@gmail.com>
> > >
> > > Currently in KVM memory virtulization we relay on mmu_lock to
> > > synchronize the memory mapping update, which make vCPUs work
> > > in serialize mode and slow down the execution, especially after
> > > migration to do substantial memory mapping will cause visible
> > > performance drop, and it can get worse if guest has more vCPU
> > > numbers and memories.
> > >
> > > The idea we present in this patch set is to mitigate the issue
> > > with pre-constructed memory mapping table. We will fast pin the
> > > guest memory to build up a global memory mapping table according
> > > to the guest memslots changes and apply it to cr3, so that after
> > > guest starts up all the vCPUs would be able to update the memory
> > > simultaneously without page fault exception, thus the performance
> > > improvement is expected.

My understanding from this RFC is that your primary goal is to
eliminate page fault latencies and lock contention arising from the
first page faults incurred by vCPUs when initially populating the EPT.
Is that right?

I have the impression that the pinning and generally static memory
mappings are more a convenient simplification than part of a larger
goal to avoid incurring page faults down the line. Is that correct?

I ask because I didn't fully understand, from our conversation on v1
of this RFC, why reimplementing the page fault handler and associated
functions was necessary for the above goals, as I understood them.
My impression of the prepopulation approach is that, KVM will
sequentially populate all the EPT entries to map guest memory. I
understand how this could be optimized to be quite efficient, but I
don't understand how it would scale better than the existing
implementation with one vCPU accessing memory.

> > >
> > > We use memory dirty pattern workload to test the initial patch
> > > set and get positive result even with huge page enabled. For example,
> > > we create guest with 32 vCPUs and 64G memories, and let the vcpus
> > > dirty the entire memory region concurrently, as the initial patch
> > > eliminate the overhead of mmu_lock, in 2M/1G huge page mode we would
> > > get the job done in about 50% faster.

In this benchmark did you include the time required to pre-populate
the EPT or just the time required for the vCPUs to dirty memory?
I ask because I'm curious if your priority is to decrease the total
end-to-end time, or you just care about the guest experience, and not
so much the VM startup time.
How does this compare to the case where 1 vCPU reads every page of
memory and then 32 vCPUs concurrently dirty every page?

> > >
> > > We only validate this feature on Intel x86 platform. And as Ben
> > > pointed out in RFC V1, so far we disable the SMM for resource
> > > consideration, drop the mmu notification as in this case the
> > > memory is pinned.

I'm excited to see big MMU changes like this, and I look forward to
combining our needs towards a better MMU for the x86 TDP case. Have
you thought about how you would build SMM and MMU notifier support
onto this patch series? I know that the invalidate range notifiers, at
least, added a lot of non-trivial complexity to the direct MMU
implementation I presented last year.

> > >
> > > V1->V2:
> > > * Rebase the code to kernel version 5.9.0-rc1.
> > >
> > > Yulei Zhang (9):
> > >   Introduce new fields in kvm_arch/vcpu_arch struct for direct build EPT
> > >     support
> > >   Introduce page table population function for direct build EPT feature
> > >   Introduce page table remove function for direct build EPT feature
> > >   Add release function for direct build ept when guest VM exit
> > >   Modify the page fault path to meet the direct build EPT requirement
> > >   Apply the direct build EPT according to the memory slots change
> > >   Add migration support when using direct build EPT
> > >   Introduce kvm module parameter global_tdp to turn on the direct build
> > >     EPT mode
> > >   Handle certain mmu exposed functions properly while turn on direct
> > >     build EPT mode
> > >
> > >  arch/mips/kvm/mips.c            |  13 +
> > >  arch/powerpc/kvm/powerpc.c      |  13 +
> > >  arch/s390/kvm/kvm-s390.c        |  13 +
> > >  arch/x86/include/asm/kvm_host.h |  13 +-
> > >  arch/x86/kvm/mmu/mmu.c          | 533 ++++++++++++++++++++++++++++++--
> > >  arch/x86/kvm/svm/svm.c          |   2 +-
> > >  arch/x86/kvm/vmx/vmx.c          |   7 +-
> > >  arch/x86/kvm/x86.c              |  55 ++--
> > >  include/linux/kvm_host.h        |   7 +-
> > >  virt/kvm/kvm_main.c             |  43 ++-
> > >  10 files changed, 639 insertions(+), 60 deletions(-)
> > >
> > > --
> > > 2.17.1
> > >
