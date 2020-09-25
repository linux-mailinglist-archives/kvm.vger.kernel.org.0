Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E308278FA0
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 19:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbgIYRaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 13:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbgIYRaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 13:30:35 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2AFC0613CE
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 10:30:35 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id z13so3630887iom.8
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 10:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8nj/nBo1AvPTorRhr6iOzefUqP/XNDCxwQulS7iNgf4=;
        b=mW58nTSJdktpeDKPH0JIOvRrSIhsuSn1GQFHxYuw+NWi/1UIk5RsQn74K2EQHIXmuD
         ZXOhQoJCntSBrzIcx7irXI6eycPIzjYN8Z+r+MBDCfgjbRCKiEoktLukuswfsgjpYsCb
         wk1i/WTY9UinpNxKGJag+3ol+hQvTygMDhdFsnPl/esPj4UUkuyk0+c3cIIr75nZsvN6
         DgA8mvO1ZlNXgwJUIdPNRmCubpDdcZD4+4KPunLU+nJsBjZqe4am932VdAIbPWWwAOcZ
         o5hrz2O04Q7WVkoHW947UeT0ZnS9YfV4BGuKIm5wFY6GdTpXdONNHqOj3kq6yBm+gISm
         CHuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8nj/nBo1AvPTorRhr6iOzefUqP/XNDCxwQulS7iNgf4=;
        b=ORGKaZeN/afsy+eSyQnjn53HUKlV1dqX7iFhrfxz+XtUU3sf5ccIroJJs5XVuk4Bc+
         7jnA+3cvAnC0Pf5lVveJ7n8skPoiSdN2Jz9SfVjKVn1yxNpn5KNv8sq3s0n8muzsspX0
         2bwGaj1Yq7pDzwvrrMBnfT3DZXsQulbxq2DFXFlYXzreAfGzATdpe0a5soFLeGpIR34v
         7rFm1JywqtufLl69tHfaJgecfFkeziWKtJbRmwB6egyGkQs+bZO7i0fjmGOANI98QSU2
         l7yQAecLMIJt/KbmR+l/vteb+cNY8t04ts+Gg8jp94lAvl9B1QAKarSv81VyK0WRiO3A
         lk6g==
X-Gm-Message-State: AOAM531TlqEEuqZ0RbfmvKi7/8N/XhSehuVtbiGtuJsJ1kRxz9a2jLVJ
        ugF/N3xfD89a/dsv8gYJvjVIQ5G9oye0gq6Nh0cD2Q==
X-Google-Smtp-Source: ABdhPJw0hU7NeTb3aAhwEP14Tcev/W0JSEV68QdTgPkWPvSUpp3qlzCrIAox5vYtSQd4a7DsgMh9DxKiM/6u/8Eye8A=
X-Received: by 2002:a05:6638:611:: with SMTP id g17mr145330jar.40.1601055034400;
 Fri, 25 Sep 2020 10:30:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1598868203.git.yulei.kernel@gmail.com> <CANRm+CwhTVHXOV6HzawHS5E_ELA3nEw0AxY1-w8vX=EsADWGSw@mail.gmail.com>
 <CANRm+CydqYmVbYz2pkT28wjKFS4AvmZ_iS4Sn1rnHT6G1S_=Mw@mail.gmail.com>
 <CANgfPd8uvkYyHLJh60vSKp1ZDi9T0ZWM9SeXEUm-1da+DqxTEQ@mail.gmail.com> <CACZOiM1JTX3w567dzThM-nPUrUksPnxks4goafoALDq1z_iNsw@mail.gmail.com>
In-Reply-To: <CACZOiM1JTX3w567dzThM-nPUrUksPnxks4goafoALDq1z_iNsw@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Fri, 25 Sep 2020 10:30:23 -0700
Message-ID: <CANgfPd-ZRW676grgOmm2E2+_RtFaiJfspnKseHMKgsHGfepmig@mail.gmail.com>
Subject: Re: [RFC V2 0/9] x86/mmu:Introduce parallel memory virtualization to
 boost performance
To:     yulei zhang <yulei.kernel@gmail.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
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

On Fri, Sep 25, 2020 at 5:04 AM yulei zhang <yulei.kernel@gmail.com> wrote:
>
> On Fri, Sep 25, 2020 at 1:14 AM Ben Gardon <bgardon@google.com> wrote:
> >
> > On Wed, Sep 23, 2020 at 11:28 PM Wanpeng Li <kernellwp@gmail.com> wrote:
> > >
> > > Any comments? Paolo! :)
> >
> > Hi, sorry to be so late in replying! I wanted to post the first part
> > of the TDP MMU series I've been working on before responding so we
> > could discuss the two together, but I haven't been able to get it out
> > as fast as I would have liked. (I'll send it ASAP!) I'm hopeful that
> > it will ultimately help address some of the page fault handling and
> > lock contention issues you're addressing with these patches. I'd also
> > be happy to work together to add a prepopulation feature to it. I'll
> > put in some more comments inline below.
> >
>
> Thanks for the feedback and looking forward to your patchset.
>
> > > On Wed, 9 Sep 2020 at 11:04, Wanpeng Li <kernellwp@gmail.com> wrote:
> > > >
> > > > Any comments? guys!
> > > > On Tue, 1 Sep 2020 at 19:52, <yulei.kernel@gmail.com> wrote:
> > > > >
> > > > > From: Yulei Zhang <yulei.kernel@gmail.com>
> > > > >
> > > > > Currently in KVM memory virtulization we relay on mmu_lock to
> > > > > synchronize the memory mapping update, which make vCPUs work
> > > > > in serialize mode and slow down the execution, especially after
> > > > > migration to do substantial memory mapping will cause visible
> > > > > performance drop, and it can get worse if guest has more vCPU
> > > > > numbers and memories.
> > > > >
> > > > > The idea we present in this patch set is to mitigate the issue
> > > > > with pre-constructed memory mapping table. We will fast pin the
> > > > > guest memory to build up a global memory mapping table according
> > > > > to the guest memslots changes and apply it to cr3, so that after
> > > > > guest starts up all the vCPUs would be able to update the memory
> > > > > simultaneously without page fault exception, thus the performance
> > > > > improvement is expected.
> >
> > My understanding from this RFC is that your primary goal is to
> > eliminate page fault latencies and lock contention arising from the
> > first page faults incurred by vCPUs when initially populating the EPT.
> > Is that right?
> >
>
> That's right.
>
> > I have the impression that the pinning and generally static memory
> > mappings are more a convenient simplification than part of a larger
> > goal to avoid incurring page faults down the line. Is that correct?
> >
> > I ask because I didn't fully understand, from our conversation on v1
> > of this RFC, why reimplementing the page fault handler and associated
> > functions was necessary for the above goals, as I understood them.
> > My impression of the prepopulation approach is that, KVM will
> > sequentially populate all the EPT entries to map guest memory. I
> > understand how this could be optimized to be quite efficient, but I
> > don't understand how it would scale better than the existing
> > implementation with one vCPU accessing memory.
> >
>
> I don't think our goal is to simply eliminate the page fault. Our
> target scenario
> is in live migration, when the workload resume on the destination VM after
> migrate, it will kick off the vcpus to build the gfn to pfn mapping,
> but due to the
> mmu_lock it holds the vcpus to execute in sequential which significantly slows
> down the workload execution in VM and affect the end user experience, especially
> when it is memory sensitive workload. Pre-populate the EPT entries
> will solve the
> problem smoothly as it allows the vcpus to execute in parallel after migration.

Oh, thank you for explaining that. I didn't realize the goal here was
to improve LM performance. I was under the impression that this was to
give VMs a better experience on startup for fast scaling or something.
In your testing with live migration how has this affected the
distribution of time between the phases of live migration? Just for
terminology (since I'm not sure how standard it is across the
industry) I think of a live migration as consisting of 3 stages:
precopy, blackout, and postcopy. In precopy we're tracking the VM's
working set via dirty logging and sending the contents of its memory
to the target host. In blackout we pause the vCPUs on the source, copy
minimal data to the target, and resume the vCPUs on the target. In
postcopy we may still have some pages that have not been copied to the
target and so request those in response to vCPU page faults via user
fault fd or some other mechanism.

Does EPT pre-population preclude the use of a postcopy phase? I would
expect that to make the blackout phase really long. Has that not been
a problem for you?

I love the idea of partial EPT pre-population during precopy if you
could still handle postcopy and just pre-populate as memory came in.

>
> > > > >
> > > > > We use memory dirty pattern workload to test the initial patch
> > > > > set and get positive result even with huge page enabled. For example,
> > > > > we create guest with 32 vCPUs and 64G memories, and let the vcpus
> > > > > dirty the entire memory region concurrently, as the initial patch
> > > > > eliminate the overhead of mmu_lock, in 2M/1G huge page mode we would
> > > > > get the job done in about 50% faster.
> >
> > In this benchmark did you include the time required to pre-populate
> > the EPT or just the time required for the vCPUs to dirty memory?
> > I ask because I'm curious if your priority is to decrease the total
> > end-to-end time, or you just care about the guest experience, and not
> > so much the VM startup time.
>
> We compare the time for each vcpu thread to finish the dirty job. Yes, it can
> take some time for the page table pre-populate, but as each vcpu thread
> can gain a huge advantage with concurrent dirty write, if we count that in
> the total time it is still a better result.

That makes sense to me. Your implementation definitely seems more
efficient than the existing PF handling path. It's probably much
easier to parallelize as a sort of recursive population operation too.

>
> > How does this compare to the case where 1 vCPU reads every page of
> > memory and then 32 vCPUs concurrently dirty every page?
> >
>
> Haven't tried this yet, I think the major difference would be the page fault
> latency introduced by the one vCPU read.

I agree. The whole VM exit path adds a lot of overhead. I wonder what
kind of numbers you'd get it you cranked PTE_PREFETCH_NUM way up
though. If you set that to >= your memory size, one PF could
pre-populate the entire EPT. It's a silly approach, but it would be a
lot more efficient as an easy POC.

>
> > > > >
> > > > > We only validate this feature on Intel x86 platform. And as Ben
> > > > > pointed out in RFC V1, so far we disable the SMM for resource
> > > > > consideration, drop the mmu notification as in this case the
> > > > > memory is pinned.
> >
> > I'm excited to see big MMU changes like this, and I look forward to
> > combining our needs towards a better MMU for the x86 TDP case. Have
> > you thought about how you would build SMM and MMU notifier support
> > onto this patch series? I know that the invalidate range notifiers, at
> > least, added a lot of non-trivial complexity to the direct MMU
> > implementation I presented last year.
> >
>
> Thanks for the suggestion, I will think about it.
>
> > > > >
> > > > > V1->V2:
> > > > > * Rebase the code to kernel version 5.9.0-rc1.
> > > > >
> > > > > Yulei Zhang (9):
> > > > >   Introduce new fields in kvm_arch/vcpu_arch struct for direct build EPT
> > > > >     support
> > > > >   Introduce page table population function for direct build EPT feature
> > > > >   Introduce page table remove function for direct build EPT feature
> > > > >   Add release function for direct build ept when guest VM exit
> > > > >   Modify the page fault path to meet the direct build EPT requirement
> > > > >   Apply the direct build EPT according to the memory slots change
> > > > >   Add migration support when using direct build EPT
> > > > >   Introduce kvm module parameter global_tdp to turn on the direct build
> > > > >     EPT mode
> > > > >   Handle certain mmu exposed functions properly while turn on direct
> > > > >     build EPT mode
> > > > >
> > > > >  arch/mips/kvm/mips.c            |  13 +
> > > > >  arch/powerpc/kvm/powerpc.c      |  13 +
> > > > >  arch/s390/kvm/kvm-s390.c        |  13 +
> > > > >  arch/x86/include/asm/kvm_host.h |  13 +-
> > > > >  arch/x86/kvm/mmu/mmu.c          | 533 ++++++++++++++++++++++++++++++--
> > > > >  arch/x86/kvm/svm/svm.c          |   2 +-
> > > > >  arch/x86/kvm/vmx/vmx.c          |   7 +-
> > > > >  arch/x86/kvm/x86.c              |  55 ++--
> > > > >  include/linux/kvm_host.h        |   7 +-
> > > > >  virt/kvm/kvm_main.c             |  43 ++-
> > > > >  10 files changed, 639 insertions(+), 60 deletions(-)
> > > > >
> > > > > --
> > > > > 2.17.1
> > > > >
