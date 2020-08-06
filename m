Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2871923D48C
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 02:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgHFAW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 20:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgHFAW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 20:22:27 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BC8C061574;
        Wed,  5 Aug 2020 17:22:27 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id x24so10717768otp.3;
        Wed, 05 Aug 2020 17:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3DAufWk9vSwTboJltSs7ArOo0iNxdupoCTtJrGJ9kM4=;
        b=I67mP7zNbseyzlaP/E4elCoSCfLEs5lcQU/MDL0tbqt0rJUE6yR+aAIdaTgrsRODwx
         jm8Z/+9s58LpprEAFAMxlS6296EX9HEuFu7y5NJz22d5Iwk0+tq75zXIXocZOemtutKB
         7uCdFakgCvmVwWuAv6y3Wo4BsL0X9HTbA/ybjJbLsFIN5Sjtke/n4VamOPA8K7Mo3ZFl
         CGB7M+wGBket3oaPCmc+ohDEsSpeWAEeKyB5WJx+Gu/MMUw7Ruri5TQoXYp9LwkZB87u
         PyEasWCr7kNVs+//R5N5G6dWmAo+IrijEZ7/ztHpf6ZXJ0oo6B4QE1iWcUu8MRP3zQcj
         LeUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3DAufWk9vSwTboJltSs7ArOo0iNxdupoCTtJrGJ9kM4=;
        b=LTTZ8LfoDyQYSUFbrcwyrnJPRrsy31t0IbVkqtTDKMCti7n38OSt9lEujYJd8bC5SZ
         EF/Hi68HEvkkM4elQMYeCPYImy7qyDkBgBLRYTfL+MSl4jzolg5y4E0XGYRa6LSk2ELv
         cCi2OmruN6G8rzYlQxYUONNbMTOHuGLfX0yfmAbVyvRkGFgrajaFHkxaXA3WMOjxm+75
         39Gjdz6QZhw1NfjE4LrMw2XybYXhJTkHEF2LKYI+f6xo8VARcujPUQJruFcUj+sJ0eUp
         cE+EOSnLz245XLiTP6crSIAZbInHGtdWD2FGFVJ+k0pDMpm5gdUBv37D7B05aDC3Ne08
         KT4A==
X-Gm-Message-State: AOAM5312k/vl6fVZS2K9BqxTCdUaWEE/9wdhK2K4IWO1NgFxJBCULeD4
        h7azcg5mz4ordp/kNUGAhWGzXdxhcnhnHM7B0BsnLp6r
X-Google-Smtp-Source: ABdhPJywu6kmkXLawFxNZI6Uf+Prg8T2FmHQcTexCsXa5EqmFv9HjlHp0DjCUjrXK1Wvebd4woiWGg//OEtNbiO2gvE=
X-Received: by 2002:a9d:22ca:: with SMTP id y68mr4895359ota.56.1596673347193;
 Wed, 05 Aug 2020 17:22:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200805141202.8641-1-yulei.kernel@gmail.com>
In-Reply-To: <20200805141202.8641-1-yulei.kernel@gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 6 Aug 2020 08:22:16 +0800
Message-ID: <CANRm+Czyes8N00SvUjkbgcvk1EXzkG9u_Av16bzxJGowy0V=JA@mail.gmail.com>
Subject: Re: [RFC 0/9] KVM:x86/mmu:Introduce parallel memory virtualization to
 boost performance
To:     Yulei Zhang <yulei.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Haiwei Li <lihaiwei.kernel@gmail.com>,
        Yulei Zhang <yuleixzhang@tencent.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Also Cc Junaid Shahid, Ben Gardon
On Wed, 5 Aug 2020 at 22:11, Yulei Zhang <yulei.kernel@gmail.com> wrote:
>
> From: Yulei Zhang <yuleixzhang@tencent.com>
>
> Currently in KVM memory virtulization we relay on mmu_lock to synchronize
> the memory mapping update, which make vCPUs work in serialize mode and
> slow down the execution, especially after migration to do substantial
> memory mapping setup, and performance get worse if increase vCPU numbers
> and guest memories.
>
> The idea we present in this patch set is to mitigate the issue with
> pre-constructed memory mapping table. We will fast pin the guest memory
> to build up a global memory mapping table according to the guest memslots
> changes and apply it to cr3, so that after guest starts up all the vCPUs
> would be able to update the memory concurrently, thus the performance
> improvement is expected.
>
> And after test the initial patch with memory dirty pattern workload, we
> have seen positive results even with huge page enabled. For example,
> guest with 32 vCPUs and 64G memories, in 2M/1G huge page mode we would get
> more than 50% improvement.
>
>
> Yulei Zhang (9):
>   Introduce new fields in kvm_arch/vcpu_arch struct for direct build EPT
>     support
>   Introduce page table population function for direct build EPT feature
>   Introduce page table remove function for direct build EPT feature
>   Add release function for direct build ept when guest VM exit
>   Modify the page fault path to meet the direct build EPT requirement
>   Apply the direct build EPT according to the memory slots change
>   Add migration support when using direct build EPT
>   Introduce kvm module parameter global_tdp to turn on the direct build
>     EPT mode
>   Handle certain mmu exposed functions properly while turn on direct
>     build EPT mode
>
>  arch/mips/kvm/mips.c            |  13 +
>  arch/powerpc/kvm/powerpc.c      |  13 +
>  arch/s390/kvm/kvm-s390.c        |  13 +
>  arch/x86/include/asm/kvm_host.h |  13 +-
>  arch/x86/kvm/mmu/mmu.c          | 537 ++++++++++++++++++++++++++++++--
>  arch/x86/kvm/svm/svm.c          |   2 +-
>  arch/x86/kvm/vmx/vmx.c          |  17 +-
>  arch/x86/kvm/x86.c              |  55 ++--
>  include/linux/kvm_host.h        |   7 +-
>  virt/kvm/kvm_main.c             |  43 ++-
>  10 files changed, 648 insertions(+), 65 deletions(-)
>
> --
> 2.17.1
>
