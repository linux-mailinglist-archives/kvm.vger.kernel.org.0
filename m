Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A64723E9B5
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 11:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgHGJDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 05:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgHGJDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 05:03:39 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3017DC061574;
        Fri,  7 Aug 2020 02:03:39 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id x24so1081253otp.3;
        Fri, 07 Aug 2020 02:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZRSac1P8m6Y9HoON8XkebBqO7NQzk7phhyPSzWi0PZk=;
        b=S02sly2cj7uxDEgK9A6TE6IHU13sCB/ugUCBZB2i6v9nyAdTfLMeIDHVidcNQOXFTm
         hZ78gU7R/ZFdpfBpY9llHXQEtg/pi+024prrvv12GlwXnXSjHK6KozxgBb6TfjdcrjVQ
         aoTZITbxG2Dmn5GvmmV4d2dFuTMa9/AL4jnRKYartry5EUv7e9Af2YhSwBGloHZhqRdq
         S0Wdn7CYooMP9UNwkeBblwTmR9K9uabJShxaQBG5GIipY94YqljJKKa0NVUH1rO5j43u
         XsNFt6g74a4kFh8i9dgRG+aGVu71f1+JNeVoDqsms3O0c19fGmmOjxeqQirVZHWhQncm
         NxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZRSac1P8m6Y9HoON8XkebBqO7NQzk7phhyPSzWi0PZk=;
        b=ZtYtbNtuaAGrdTsNgrV/7+/7wVzR1YXIg8OIHpetvbj5gWm3FzGwL5Pt6sbCX3c/hc
         M6UIe4ZtTiG8BdWlJy78Xb96R4vbl5B8T9NVmdnU2GccRyRDYPeSEXCs497iPX/pgYeA
         sO4IRiZLzzxT2Nz6YMaK0p+BrrUHCLSJoyJamUf5cNPX5R0vt2CMqzJNPNSi8VLpzw00
         GqXVG8Vi6HCrQgr0QIsECnwUSOZxIqo77FlRPH+qzRAPZa+Levv+NqlNZDkKuj3XH2NC
         /r6XKzswEYFiSoPVy589yXo4VUU/k37LOUvBKOcUJY1ADTgrbxK0LLZU5oYKJPs5qvNf
         hKJA==
X-Gm-Message-State: AOAM530eZecSMX7cvmkAtMxbyalW2mWdaA1dym6CLtA6qLQzoXxEKzLA
        ulg8RFUj1LTFM4pcGF/XEIYi7c2q6DRRUE75MXk=
X-Google-Smtp-Source: ABdhPJzLBrRvOfgpLXHkBQldJTXluuB62LEw27OwAPaAg4DdQIpyt2xTMUjCMV353wjDbsBL+04npHHrDpZMjLabBQQ=
X-Received: by 2002:a9d:6a54:: with SMTP id h20mr11178924otn.116.1596791018374;
 Fri, 07 Aug 2020 02:03:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200805141202.8641-1-yulei.kernel@gmail.com> <CANgfPd_P_bjduGgS7miCp4BLUaDXBTYb9swC1gzxwYG2baWRVw@mail.gmail.com>
In-Reply-To: <CANgfPd_P_bjduGgS7miCp4BLUaDXBTYb9swC1gzxwYG2baWRVw@mail.gmail.com>
From:   yulei zhang <yulei.kernel@gmail.com>
Date:   Fri, 7 Aug 2020 17:03:27 +0800
Message-ID: <CACZOiM3Shps4sJm4c6WWB12-mo1kWC4qYmCFD2dhJ+shaHoEeg@mail.gmail.com>
Subject: Re: [RFC 0/9] KVM:x86/mmu:Introduce parallel memory virtualization to
 boost performance
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        xiaoguangrong.eric@gmail.com, kernellwp@gmail.com,
        lihaiwei.kernel@gmail.com, Yulei Zhang <yuleixzhang@tencent.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 7, 2020 at 1:04 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Wed, Aug 5, 2020 at 9:53 AM Yulei Zhang <yulei.kernel@gmail.com> wrote:
> >
> > From: Yulei Zhang <yuleixzhang@tencent.com>
> >
> > Currently in KVM memory virtulization we relay on mmu_lock to synchronize
> > the memory mapping update, which make vCPUs work in serialize mode and
> > slow down the execution, especially after migration to do substantial
> > memory mapping setup, and performance get worse if increase vCPU numbers
> > and guest memories.
> >
> > The idea we present in this patch set is to mitigate the issue with
> > pre-constructed memory mapping table. We will fast pin the guest memory
> > to build up a global memory mapping table according to the guest memslots
> > changes and apply it to cr3, so that after guest starts up all the vCPUs
> > would be able to update the memory concurrently, thus the performance
> > improvement is expected.
>
> Is a re-implementation of the various MMU functions in this series
> necessary to pre-populate the EPT/NPT? I realize the approach you took
> is probably the fastest way to pre-populate an EPT, but it seems like
> similar pre-population could be achieved with some changes to the PF
> handler's prefault scheme or, from user space by adding a dummy vCPU
> to touch memory before loading the actual guest image.
>
> I think this series is taking a similar approach to the direct MMU RFC
> I sent out a little less than a year ago. (I will send another version
> of that series in the next month.) I'm not sure this level of
> complexity is worth it if you're only interested in EPT pre-population.
> Is pre-population your goal? You mention "parallel memory
> virtualization," does that refer to parallel page fault handling you
> intend to implement in a future series?
>
> There are a number of features I see you've chosen to leave behind in
> this series which might work for your use case, but I think they're
> necessary. These include handling vCPUs with different roles (SMM, VMX
> non root mode, etc.), MMU notifiers (which I realize matter less for
> pinned memory), demand paging through UFFD, fast EPT
> invalidation/teardown and others.
>
Thanks for the feedback. I think the target circumstance for this feature is
without memory overcommitment, thus it can fast pin the memory and
setup the GPA->HPA mapping table, and after that we don't expect PF
while vCPUs access the memory. We call it "parallel memory virtualization"
as with pre-populated EPT the vCPUs will be able to update the memory
in parallel mode.
Yes, so far we disable the SMM etc. We are looking forward to gathering
the inputs from your experts and refine the implementation.

> >
> > And after test the initial patch with memory dirty pattern workload, we
> > have seen positive results even with huge page enabled. For example,
> > guest with 32 vCPUs and 64G memories, in 2M/1G huge page mode we would get
> > more than 50% improvement.
> >
> >
> > Yulei Zhang (9):
> >   Introduce new fields in kvm_arch/vcpu_arch struct for direct build EPT
> >     support
> >   Introduce page table population function for direct build EPT feature
> >   Introduce page table remove function for direct build EPT feature
> >   Add release function for direct build ept when guest VM exit
> >   Modify the page fault path to meet the direct build EPT requirement
> >   Apply the direct build EPT according to the memory slots change
> >   Add migration support when using direct build EPT
> >   Introduce kvm module parameter global_tdp to turn on the direct build
> >     EPT mode
> >   Handle certain mmu exposed functions properly while turn on direct
> >     build EPT mode
> >
> >  arch/mips/kvm/mips.c            |  13 +
> >  arch/powerpc/kvm/powerpc.c      |  13 +
> >  arch/s390/kvm/kvm-s390.c        |  13 +
> >  arch/x86/include/asm/kvm_host.h |  13 +-
> >  arch/x86/kvm/mmu/mmu.c          | 537 ++++++++++++++++++++++++++++++--
> >  arch/x86/kvm/svm/svm.c          |   2 +-
> >  arch/x86/kvm/vmx/vmx.c          |  17 +-
> >  arch/x86/kvm/x86.c              |  55 ++--
> >  include/linux/kvm_host.h        |   7 +-
> >  virt/kvm/kvm_main.c             |  43 ++-
> >  10 files changed, 648 insertions(+), 65 deletions(-)
> >
> > --
> > 2.17.1
> >
