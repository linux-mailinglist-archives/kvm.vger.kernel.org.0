Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1F62768E3
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 08:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgIXG2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 02:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgIXG2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 02:28:51 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCAA3C0613CE;
        Wed, 23 Sep 2020 23:28:51 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id n61so2105522ota.10;
        Wed, 23 Sep 2020 23:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R1U3NxLbQjBixpfoPowGIH4NmhZQy3NaJU6pXboAykI=;
        b=MgDi5BomTbLhrvRAh9TM+NXFVCHyNulJ2QXWkiwF3yJjoLMt5e17ROsFDVINI7cZf+
         wBTD4ZUr+tP+sRrBhCjk2WxwT/DzMt5Lfv3Kltzh2WUXUvQqVe/8nmj3hqfT/5z2Jra5
         6k30fA01I9QBLQ3Xmkf2MnLqUzc6wInLBD/luevd28THHnDkAZB71jq9FqPE6gsiYFjn
         IYCS2EvDUvt5M1Rpps4Yn7LnGIFqXHQPODU0BLiUon/wvwB83cXcht9l7MsWQLwBD/5R
         FNrO7/vTaKnEcyO6PveRNX0+akGVdUG50K2WUoRwHXh2A/1TiBPMF+IJuEx2gUT/uBSB
         Tukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R1U3NxLbQjBixpfoPowGIH4NmhZQy3NaJU6pXboAykI=;
        b=oFpGej+h96CDAcl2f/M+OywKjbIG4DxBit+RDzfi0FSNgoUyOJzzyM0n4hCzTL4x7g
         jYrYFJq2sbbwQJe9LKFuk0svrhxQAXCLX+uJwLytz61/Ej6gacOFQGnQjwotfM8uC1PL
         hI0qx91EY3fiv96M4lVD3uYR/rFIu5HhtFsnJMKCghVTsCSIezRl/Jq8ypo7E+hwTGOr
         kPhy99eryMLk4Bexi1SV1B3RqXTIgIHRFZx6BjxKwC1cAn+d3zfFMDwt2somclEgKLwu
         PBQRml2uXCchnTlUnkJPcGTCIW97/Vo6XK+Jq8BICZc2ZpELZQipNL0i9fogQSaYUYy5
         QW5A==
X-Gm-Message-State: AOAM531O5xCXoO7WE5mLxXi4k8lzHKQ3kxxPi70FMWznHEyFFqB1AqVq
        veg8QYM+7LMhUb6+hoxQVF9luk525WmM617EGIo=
X-Google-Smtp-Source: ABdhPJwP5NgsiLY/dsAFGeqt9CMEurcB/bwqMGOUGO6Vaq+rpps+Vek05EWOwe/VO8PcTk89F6fD9C3Bn6V/EgKgiAQ=
X-Received: by 2002:a05:6830:154a:: with SMTP id l10mr2066995otp.56.1600928931177;
 Wed, 23 Sep 2020 23:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1598868203.git.yulei.kernel@gmail.com> <CANRm+CwhTVHXOV6HzawHS5E_ELA3nEw0AxY1-w8vX=EsADWGSw@mail.gmail.com>
In-Reply-To: <CANRm+CwhTVHXOV6HzawHS5E_ELA3nEw0AxY1-w8vX=EsADWGSw@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 24 Sep 2020 14:28:40 +0800
Message-ID: <CANRm+CydqYmVbYz2pkT28wjKFS4AvmZ_iS4Sn1rnHT6G1S_=Mw@mail.gmail.com>
Subject: Re: [RFC V2 0/9] x86/mmu:Introduce parallel memory virtualization to
 boost performance
To:     Yulei Zhang <yulei.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Haiwei Li <lihaiwei.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Any comments? Paolo! :)
On Wed, 9 Sep 2020 at 11:04, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> Any comments? guys!
> On Tue, 1 Sep 2020 at 19:52, <yulei.kernel@gmail.com> wrote:
> >
> > From: Yulei Zhang <yulei.kernel@gmail.com>
> >
> > Currently in KVM memory virtulization we relay on mmu_lock to
> > synchronize the memory mapping update, which make vCPUs work
> > in serialize mode and slow down the execution, especially after
> > migration to do substantial memory mapping will cause visible
> > performance drop, and it can get worse if guest has more vCPU
> > numbers and memories.
> >
> > The idea we present in this patch set is to mitigate the issue
> > with pre-constructed memory mapping table. We will fast pin the
> > guest memory to build up a global memory mapping table according
> > to the guest memslots changes and apply it to cr3, so that after
> > guest starts up all the vCPUs would be able to update the memory
> > simultaneously without page fault exception, thus the performance
> > improvement is expected.
> >
> > We use memory dirty pattern workload to test the initial patch
> > set and get positive result even with huge page enabled. For example,
> > we create guest with 32 vCPUs and 64G memories, and let the vcpus
> > dirty the entire memory region concurrently, as the initial patch
> > eliminate the overhead of mmu_lock, in 2M/1G huge page mode we would
> > get the job done in about 50% faster.
> >
> > We only validate this feature on Intel x86 platform. And as Ben
> > pointed out in RFC V1, so far we disable the SMM for resource
> > consideration, drop the mmu notification as in this case the
> > memory is pinned.
> >
> > V1->V2:
> > * Rebase the code to kernel version 5.9.0-rc1.
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
> >  arch/x86/kvm/mmu/mmu.c          | 533 ++++++++++++++++++++++++++++++--
> >  arch/x86/kvm/svm/svm.c          |   2 +-
> >  arch/x86/kvm/vmx/vmx.c          |   7 +-
> >  arch/x86/kvm/x86.c              |  55 ++--
> >  include/linux/kvm_host.h        |   7 +-
> >  virt/kvm/kvm_main.c             |  43 ++-
> >  10 files changed, 639 insertions(+), 60 deletions(-)
> >
> > --
> > 2.17.1
> >
