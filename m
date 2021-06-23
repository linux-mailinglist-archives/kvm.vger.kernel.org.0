Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E323B1B33
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 15:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhFWNeo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 09:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbhFWNeh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 09:34:37 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28C8C06175F;
        Wed, 23 Jun 2021 06:32:15 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id t9so1798117pgn.4;
        Wed, 23 Jun 2021 06:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mJH7rACNlel6eUyneHxIwMW/GXu36vjTuPNE7PBMzIg=;
        b=l8RoFeCH7xmCkTqznyBujWUHSA5ikw7BcIAtLyePN9+xI5lFB1kAUW6FlzcSiPP2M2
         adW06ZNYgsZKjD8oqvtcF5PTvDEykL+KG5ai6+OZroTbxOWzXYIVOO00gwCZKVIc3IhG
         yaATYsj0Yb6n9LzS6TrH2wQeS9DnQUJFWtHLJS8PeiC1O4lQ6qAnIY8Ejo5cTrHU59Pg
         uIkvjlWA9+IA8eMezXZ6QoWqJ56efdJ/mD3oZa2z0Dm3oucn2baKQntZdRKwXIb64F+W
         C0sih7wy6NACN0Ic++csKFOohz7qbEqy4OmyV28WH6kNgTDGgoHI66q5pFXwQa6jCUUL
         0WpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mJH7rACNlel6eUyneHxIwMW/GXu36vjTuPNE7PBMzIg=;
        b=M9SigwEC07LUu6s5BwMGUsfhxHMiWzZsFOhb/LKsAZzbGv0f9LZelgCxy1/qHCHnJA
         pbK8JRwBLSzKeecsMFO8n0e1q4Ik5gSYn6xNBe5/QB41OfKt0YM3D45WMF6baM9UVKkG
         GRU1oHGlBTBt3QQ6IODKbSeQalni1DA/zGQ3evHlOJOduCb/SQqbvI9k2CjLlAJLI6qv
         HPM+VMwuI5zN0P2c1tMcKqziyMrcMfI1fVsRUQD1wouvzuCelfpXLMMYhhqNMUlXd1Rk
         VO0bTzZnBFIpkQIP5cVH++deXMAGtlzQjM74IClXHUTaPakJJ+b0/2JaGV8O9Zn5ttrJ
         +bmw==
X-Gm-Message-State: AOAM532AnYDyErMTK7wyPnzKlT3BaF/Ne6ZL/yEXCqLd07BowEA0Dzgv
        ChHi8YBcx9c9XJH+GPq+TTM=
X-Google-Smtp-Source: ABdhPJyjGwKnGi4vn/R3jRF2XDTo7onVA3+42SoHnaXGbqyfpDV7J/q7rcYSq75qfn7tHyJcb/4eIA==
X-Received: by 2002:a63:5d19:: with SMTP id r25mr3859541pgb.317.1624455135179;
        Wed, 23 Jun 2021 06:32:15 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y2sm24414pfa.195.2021.06.23.06.32.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 06:32:14 -0700 (PDT)
To:     pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Weijiang <weijiang.yang@intel.com>
References: <20210510081535.94184-1-like.xu@linux.intel.com>
 <20210622090152.GA13141@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Subject: Re: [RESEND PATCH v4 00/10] KVM: x86/pmu: Guest Architectural LBR
 Enabling
Message-ID: <1183cac7-eab9-d3ab-99bc-5f1fa0a552a8@gmail.com>
Date:   Wed, 23 Jun 2021 21:32:06 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210622090152.GA13141@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

It looks that we don't have perf subsystem dependency
to enable guest Arch LBR here and it also has tests to cover it.

Do you have any concerns about not accepting them ?

Thanks,
Like Xu

On 22/6/2021 5:01 pm, Yang Weijiang wrote:
> 
> Hello, maintainers,
> 
> I took over the work from Like and will carry it forward. Here I'd like to
> get your valuable comments on this patch series before I post next version.
> 
> Thanks a lot!
> 
>> Hi geniuses,
>>
>> A new kernel cycle has begun, and this version looks promising.
>>
>> >From the end user's point of view, the usage of Arch LBR is the same as
>> the legacy LBR we have merged in the mainline, but it is much faster.
>>
>> The Architectural Last Branch Records (LBRs) is published
>> in the 319433-040 release of Intel Architecture Instruction
>> Set Extensions and Future Features Programming Reference[0].
>>
>> The main advantages for the Arch LBR users are [1]:
>> - Faster context switching due to XSAVES support and faster reset of
>>    LBR MSRs via the new DEPTH MSR
>> - Faster LBR read for a non-PEBS event due to XSAVES support, which
>>    lowers the overhead of the NMI handler.
>> - Linux kernel can support the LBR features without knowing the model
>>    number of the current CPU.
>>
>> Please check more details in each commit and feel free to comment.
>>
>> [0] https://software.intel.com/content/www/us/en/develop/download/
>> intel-architecture-instruction-set-extensions-and-future-features-programming-reference.html
>> [1] https://lore.kernel.org/lkml/1593780569-62993-1-git-send-email-kan.liang@linux.intel.com/
>>
>> ---
>> v13->v13 RESEND Changelog:
>> - Rebase to kvm/queue tree tag: kvm-5.13-2;
>> - Includes two XSS dependency patches from kvm/intel tree;
>>
>> v3->v4 Changelog:
>> - Add one more host patch to reuse ARCH_LBR_CTL_MASK;
>> - Add reserve_lbr_buffers() instead of using GFP_ATOMIC;
>> - Fia a bug in the arch_lbr_depth_is_valid();
>> - Add LBR_CTL_EN to unify DEBUGCTLMSR_LBR and ARCH_LBR_CTL_LBREN;
>> - Add vmx->host_lbrctlmsr to save/restore host values;
>> - Add KVM_SUPPORTED_XSS to refactoring supported_xss;
>> - Clear Arch_LBR ans its XSS bit if it's not supported;
>> - Add negative testing to the related kvm-unit-tests;
>> - Refine code and commit messages;
>>
>> Previous:
>> v4: https://lore.kernel.org/kvm/20210314155225.206661-1-like.xu@linux.intel.com/
>> v3: https://lore.kernel.org/kvm/20210303135756.1546253-1-like.xu@linux.intel.com/
>>
>> Like Xu (8):
>>    perf/x86/intel: Fix the comment about guest LBR support on KVM
>>    perf/x86/lbr: Simplify the exposure check for the LBR_INFO registers
>>    KVM: vmx/pmu: Add MSR_ARCH_LBR_DEPTH emulation for Arch LBR
>>    KVM: vmx/pmu: Add MSR_ARCH_LBR_CTL emulation for Arch LBR
>>    KVM: vmx/pmu: Add Arch LBR emulation and its VMCS field
>>    KVM: x86: Expose Architectural LBR CPUID leaf
>>    KVM: x86: Refine the matching and clearing logic for supported_xss
>>    KVM: x86: Add XSAVE Support for Architectural LBRs
>>
>> Sean Christopherson (1):
>>    KVM: x86: Report XSS as an MSR to be saved if there are supported
>>      features
>>
>> Yang Weijiang (1):
>>    KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
>>
>>   arch/x86/events/intel/core.c     |   3 +-
>>   arch/x86/events/intel/lbr.c      |   6 +-
>>   arch/x86/include/asm/kvm_host.h  |   1 +
>>   arch/x86/include/asm/msr-index.h |   1 +
>>   arch/x86/include/asm/vmx.h       |   4 ++
>>   arch/x86/kvm/cpuid.c             |  46 ++++++++++++--
>>   arch/x86/kvm/vmx/capabilities.h  |  25 +++++---
>>   arch/x86/kvm/vmx/pmu_intel.c     | 103 ++++++++++++++++++++++++++++---
>>   arch/x86/kvm/vmx/vmx.c           |  50 +++++++++++++--
>>   arch/x86/kvm/vmx/vmx.h           |   4 ++
>>   arch/x86/kvm/x86.c               |  19 +++++-
>>   11 files changed, 226 insertions(+), 36 deletions(-)
>>
>> -- 
>> 2.31.1
> 
