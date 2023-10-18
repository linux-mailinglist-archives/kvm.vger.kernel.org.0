Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363B07CD235
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 04:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjJRCXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 22:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjJRCXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 22:23:32 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE55C6;
        Tue, 17 Oct 2023 19:23:30 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 3f1490d57ef6-d9a3d737d66so6753101276.2;
        Tue, 17 Oct 2023 19:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697595809; x=1698200609; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zlAZ3Wavidk7KFF+81Wbwk8c+3Ra9Xped377HOHnccE=;
        b=NKuaXB+xg9jX1h6tStG+JYNzN+Nx+xUpCo94nrhKIugn3wIETTYqt1Rg6I9/7GZR4L
         u9Yf7pm6PxEpD54VYAvL2JlHNvlBFDdkrYyp4YOrlVig4ZKp3BMmzMzajGSmfqxsXT2/
         DhqhgzQAF0N8cYRbHybL5GX8/tiBfXy4+ccxNcWhwKsV9Hk7Rg2x4mWFwQeZ9YQ64q8H
         Mg0YJWKthBucwlO6y0vGdhdzijUMQtnAzcL0tGmjYOlSEsvDbnoDHLmecv59YFTRZ9vX
         HX+oFIqaV+eP6e5J05ERTf3xm2OS8DtB5EVCIs1W0Rit4v7QMfSxqXMky3Wx7hmP651h
         bUWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697595809; x=1698200609;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zlAZ3Wavidk7KFF+81Wbwk8c+3Ra9Xped377HOHnccE=;
        b=NDVEMOBrBZZS5/x2RsUa+IiNSkG8lSMB4JgAK8Itvzp8vYhDHTwH7k/Sn44cI7eUYh
         cGRltvPzP6HunmrJGfXm03nSIpvT/MvaPCjngyCOMuUCJpEN3FzBCYgc/2tjdBf3He8N
         utypxtuIUN0gzs+4tPhcAkBR+xjrHQeV5tnoYhR2BD6OHf3zhv2wcY+yzX9ep0Epw7dj
         x7LpmuYJ/hRt4Fm3Px77CuI+p/D7S/Stx79PrS3bNjD3Hcb34xq4wZqvdk+5wDSpz0qI
         CqMmxLuI72N5TUB3pqvQiXKTl/tjCtpwbw5PRHPDHf3O1GqajSxxI67ERnSicFyQUh+o
         dGbg==
X-Gm-Message-State: AOJu0YzO8Q42F+1R3X2OlnoM5QxdHzY/nKF48PAbGXvKdnVVirxdxoxV
        pvh7kvhl38K/BfUuXFP1GE0=
X-Google-Smtp-Source: AGHT+IGVVJLy9h0hjsJdCxRQJ7/k5z4yAlXxfsyBrTjR/bih64VS+2nLh9U1GVDujjKQlJF7IfCThA==
X-Received: by 2002:a25:d15:0:b0:d9a:5f91:c615 with SMTP id 21-20020a250d15000000b00d9a5f91c615mr3629878ybn.18.1697595809195;
        Tue, 17 Oct 2023 19:23:29 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id s4-20020aa78bc4000000b006bddd1ee5f0sm2135699pfd.5.2023.10.17.19.23.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Oct 2023 19:23:28 -0700 (PDT)
Message-ID: <9483638a-e34b-4e01-baa4-445a5984301c@gmail.com>
Date:   Wed, 18 Oct 2023 10:23:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Clean up included but non-essential header
 declarations
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20231017093335.18216-1-likexu@tencent.com>
 <ZS79MFkVB6A1N9AA@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZS79MFkVB6A1N9AA@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/2023 5:31 am, Sean Christopherson wrote:
> On Tue, Oct 17, 2023, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>> Removing these declarations as part of KVM code refactoring can also (when
>> the compiler isn't so smart) reduce compile time, compile warnings, and the
> 
> Really, warnings?  On what W= level?  W=1 builds just fine with KVM_WERROR=y.
> If any of the "supported" warn levels triggers a warn=>error, then we'll fix it.
> 
>> size of compiled artefacts, and more importantly can help developers better
>> consider decoupling when adding/refactoring unmerged code, thus relieving
>> some of the burden on the code review process.
> 
> Can you provide an example?  KVM certainly has its share of potential circular
> dependency pitfalls, e.g. it's largely why we have the ugly and seemingly
> arbitrary split between x86.h and asm/kvm_host.h.  But outside of legitimate
> collisions like that, I can't think of a single instance where superfluous existing
> includes caused problems.  On the other hand, I distinctly recall multiple
> instances where a header didn't include what it used and broke the build when the
> buggy header was included in a new file.

I've noticed that during patch iterations, developers add or forget to
remove header declarations from previous versions (just so the compiler
doesn't complain), and the status quo is that these header declarations
are rapidly ballooning.

> 
>> Specific header declaration is supposed to be retained if it makes more
>> sense for reviewers to understand. No functional changes intended.
>>
>> [*] https://lore.kernel.org/all/YdIfz+LMewetSaEB@gmail.com/
> 
> This patch violates one of the talking points of Ingo's work:
> 
>   - "Make headers standalone": over 80 headers don't build standalone and
>     depend on various accidental indirect dependencies they gain through
>     other headers, especially once headers get their unnecessary dependencies
>     removed. So there's over 80 commits changing these headers.
> 
> I think it's also worth noting that Ingo boosted build times by eliminating
> includes in common "high use" headers, not by playing whack-a-mole with "private"
> headers and C files.
> 
>> [**] https://include-what-you-use.org/
>>
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/cpuid.c           |  3 ---
>>   arch/x86/kvm/cpuid.h           |  1 -
>>   arch/x86/kvm/emulate.c         |  2 --
>>   arch/x86/kvm/hyperv.c          |  3 ---
>>   arch/x86/kvm/i8259.c           |  1 -
>>   arch/x86/kvm/ioapic.c          | 10 ----------
>>   arch/x86/kvm/irq.c             |  3 ---
>>   arch/x86/kvm/irq.h             |  3 ---
>>   arch/x86/kvm/irq_comm.c        |  2 --
>>   arch/x86/kvm/lapic.c           |  8 --------
>>   arch/x86/kvm/mmu.h             |  1 -
>>   arch/x86/kvm/mmu/mmu.c         | 11 -----------
>>   arch/x86/kvm/mmu/spte.c        |  1 -
>>   arch/x86/kvm/mmu/tdp_iter.h    |  1 -
>>   arch/x86/kvm/mmu/tdp_mmu.c     |  3 ---
>>   arch/x86/kvm/mmu/tdp_mmu.h     |  4 ----
>>   arch/x86/kvm/smm.c             |  1 -
>>   arch/x86/kvm/smm.h             |  3 ---
>>   arch/x86/kvm/svm/avic.c        |  2 --
>>   arch/x86/kvm/svm/hyperv.h      |  2 --
>>   arch/x86/kvm/svm/nested.c      |  2 --
>>   arch/x86/kvm/svm/pmu.c         |  4 ----
>>   arch/x86/kvm/svm/sev.c         |  7 -------
>>   arch/x86/kvm/svm/svm.c         | 29 -----------------------------
>>   arch/x86/kvm/svm/svm.h         |  3 ---
>>   arch/x86/kvm/vmx/hyperv.c      |  4 ----
>>   arch/x86/kvm/vmx/hyperv.h      |  7 -------
>>   arch/x86/kvm/vmx/nested.c      |  2 --
>>   arch/x86/kvm/vmx/nested.h      |  1 -
>>   arch/x86/kvm/vmx/pmu_intel.c   |  1 -
>>   arch/x86/kvm/vmx/posted_intr.c |  1 -
>>   arch/x86/kvm/vmx/sgx.h         |  5 -----
>>   arch/x86/kvm/vmx/vmx.c         | 11 -----------
>>   arch/x86/kvm/x86.c             | 17 -----------------
>>   arch/x86/kvm/xen.c             |  1 -
>>   virt/kvm/async_pf.c            |  2 --
>>   virt/kvm/binary_stats.c        |  1 -
>>   virt/kvm/coalesced_mmio.h      |  2 --
>>   virt/kvm/eventfd.c             |  2 --
>>   virt/kvm/irqchip.c             |  1 -
>>   virt/kvm/kvm_main.c            | 13 -------------
>>   virt/kvm/pfncache.c            |  1 -
>>   virt/kvm/vfio.c                |  2 --
>>   43 files changed, 184 deletions(-)
> 
> NAK, I am not taking a wholesale purge of includes.  I have no objection to
> removing truly unnecessary includes, e.g. there are definitely some includes that
> are no longer necessary due to code being moved around.  But changes like the
> removal of all includes from tdp_mmu.h and smm.h are completely bogus.  If anything,
> smm.h clearly needs more includes, because it is certainly not including everything
> it is using.

Thanks, this patch being nak is to be expected. As you've noticed in the
smm.h story, sensible dependencies should appear in sensible header files,
and are assembled correctly to promote better understanding (the compiler
seems to be happy on weird dependency combinations and doesn't complain
until something goes wrong).

In addition to "x86.h and asm/kvm_host.h", we could have gone further in
the direction of "Make headers standalone", couldn't we ?

> 
>> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
>> index 733a3aef3a96..66afdf3e262a 100644
>> --- a/arch/x86/kvm/mmu/tdp_mmu.h
>> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
>> @@ -3,10 +3,6 @@
>>   #ifndef __KVM_X86_MMU_TDP_MMU_H
>>   #define __KVM_X86_MMU_TDP_MMU_H
>>   
>> -#include <linux/kvm_host.h>
>> -
>> -#include "spte.h"
>> -
>>   void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
>>   void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
> 
> ...
> 
>> diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
>> index a1cf2ac5bd78..3e067ce1ea1d 100644
>> --- a/arch/x86/kvm/smm.h
>> +++ b/arch/x86/kvm/smm.h
>> @@ -2,11 +2,8 @@
>>   #ifndef ASM_KVM_SMM_H
>>   #define ASM_KVM_SMM_H
>>   
>> -#include <linux/build_bug.h>
>> -
>>   #ifdef CONFIG_KVM_SMM
>>   
>> -
>>   /*
>>    * 32 bit KVM's emulated SMM layout. Based on Intel P6 layout
>>    * (https://www.sandpile.org/x86/smm.htm).
