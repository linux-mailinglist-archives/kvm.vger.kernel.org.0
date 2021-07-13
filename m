Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7733C6DBC
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 11:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235262AbhGMJwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 05:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbhGMJwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 05:52:13 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA45AC0613DD;
        Tue, 13 Jul 2021 02:49:22 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id o201so14001358pfd.1;
        Tue, 13 Jul 2021 02:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IWSTYmC+Gac/5Ldupb1nMyka7wi/+11TTLpxgLg5GHM=;
        b=pt7ylunuAhUhBsF4LTcq9NewSXEZ81QBmP/CZyUDcn4u8txh6flQ+f/T11LwekBIN0
         Hbq49Y5irTZ/GD/NRoB/RlOGq8kvUKS+vOzabsDvLnaJh7EZfZLlDdlt3j09ehm9VtKk
         /L4QboZucO8ACimWE9NISPsIe3jLzSQg3Z2JPlM0xpc9sQspDRsqNPTJUzdCydBnQuMc
         BHY/KEtygzQ9GLVZ5XVc4POkkjw5xfXgf4oTjTZiZDHwyYxe5xdI94OVIY+vaVdaT49t
         SNaiFYPX+fgrUwcUosFxYa3QLyfl6gTaVPi5fQ+44tfARmLH1wQklbkGedfquNz8VWcB
         VXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IWSTYmC+Gac/5Ldupb1nMyka7wi/+11TTLpxgLg5GHM=;
        b=q3YBWX5nyHe2XxLczFosyORec270uH9Kyom7kpdxizMlrk5klWjs09aV9LwJt86q6L
         Pd28LnnPbxz57pOBOrZZ1sMMi6oefBcsCg38NIqc0Bua6KTpLMOBbdR/kjR2/0hZyP5u
         m3P+yXq2P39nNHTtB+qwYheZ4/KxDfYUaPr27eKN8icSaYwzy86Wnin1zO7A5eTWq7es
         iQd6fYiaM9gNpY19WdrP/HBfovUW1q52R++UD2+qkMDT/zgMy9y3rt/u8RJmy0TFBRRK
         TPxYwmEH/Bhlb848pjX6yBqV8lEhcQnDaFK5vDdBn/gGVrUGRmqxDZafqDi6VoxJmssG
         E6JA==
X-Gm-Message-State: AOAM533fbIix7jty4TdP5LDHn0G7phieIJjWbuI3UZtO0LR8hBUAkmN/
        f7Ulsv3PhUOk5uA8GFMMH3I=
X-Google-Smtp-Source: ABdhPJztHe9NoZYxGJJbjJfelTtp19bEeBQfBUe49b64bl0QScpBHBU1MvKg4Rq9EZqmgIfazZ6NNw==
X-Received: by 2002:aa7:97bd:0:b029:32c:56cc:8fa9 with SMTP id d29-20020aa797bd0000b029032c56cc8fa9mr3810333pfq.65.1626169762386;
        Tue, 13 Jul 2021 02:49:22 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j22sm20334415pgb.62.2021.07.13.02.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 02:49:21 -0700 (PDT)
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-7-git-send-email-weijiang.yang@intel.com>
 <CALMp9eQEs9pUyy1PpwLPG0_PtF07tR2Opw+1b=w4-knOwYPvvg@mail.gmail.com>
 <CALMp9eQ+9czB0ayBFR3-nW-ynKuH0v9uHAGeV4wgkXYJMSs1=w@mail.gmail.com>
 <20210712095305.GE12162@intel.com>
 <d73eb316-4e09-a924-5f60-e3778db91df4@gmail.com>
 <CALMp9eQmK+asv7fXeUpF2UiRKL7VmZx44HMGj67aSqm0k9nKVg@mail.gmail.com>
 <CALMp9eSWDmWerj5CaxRyMiNqnBf1akHHaWV2Cfq_66Xjg-0MEw@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH v5 06/13] KVM: x86/vmx: Save/Restore host MSR_ARCH_LBR_CTL
 state
Message-ID: <12a3e8e4-3183-9917-c9d5-59ab257b8fd3@gmail.com>
Date:   Tue, 13 Jul 2021 17:49:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSWDmWerj5CaxRyMiNqnBf1akHHaWV2Cfq_66Xjg-0MEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/7/2021 1:45 am, Jim Mattson wrote:
> On Mon, Jul 12, 2021 at 10:20 AM Jim Mattson <jmattson@google.com> wrote:
>>
>> On Mon, Jul 12, 2021 at 3:19 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>>
>>> On 12/7/2021 5:53 pm, Yang Weijiang wrote:
>>>> On Fri, Jul 09, 2021 at 04:41:30PM -0700, Jim Mattson wrote:
>>>>> On Fri, Jul 9, 2021 at 3:54 PM Jim Mattson <jmattson@google.com> wrote:
>>>>>>
>>>>>> On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>>>>>>>
>>>>>>> If host is using MSR_ARCH_LBR_CTL then save it before vm-entry
>>>>>>> and reload it after vm-exit.
>>>>>>
>>>>>> I don't see anything being done here "before VM-entry" or "after
>>>>>> VM-exit." This code seems to be invoked on vcpu_load and vcpu_put.
>>>>>>
>>>>>> In any case, I don't see why this one MSR is special. It seems that if
>>>>>> the host is using the architectural LBR MSRs, then *all* of the host
>>>>>> architectural LBR MSRs have to be saved on vcpu_load and restored on
>>>>>> vcpu_put. Shouldn't  kvm_load_guest_fpu() and kvm_put_guest_fpu() do
>>>>>> that via the calls to kvm_save_current_fpu(vcpu->arch.user_fpu) and
>>>>>> restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state)?
>>>>>
>>>>> It does seem like there is something special about IA32_LBR_DEPTH, though...
>>>>>
>>>>> Section 7.3.1 of the Intel® Architecture Instruction Set Extensions
>>>>> and Future Features Programming Reference
>>>>> says, "IA32_LBR_DEPTH is saved by XSAVES, but it is not written by
>>>>> XRSTORS in any circumstance." It seems like that would require some
>>>>> special handling if the host depth and the guest depth do not match.
>>>> In our vPMU design, guest depth is alway kept the same as that of host,
>>>> so this won't be a problem. But I'll double check the code again, thanks!
>>>
>>> KVM only exposes the host's depth value to the user space
>>> so the guest can only use the same depth as the host.
>>
>> The allowed depth supplied by KVM_GET_SUPPORTED_CPUID isn't enforced,
>> though, is it?

Like other hardware dependent features, the functionality will not
promise to work properly if the guest uses the unsupported CPUID.

> 
> Also, doesn't this end up being a major constraint on future
> platforms? Every host that this vCPU will ever run on will have to use
> the same LBR depth as the host on which it was started.
> 

As a first step, we made the guest LBR feature only available for the
"migratable=off" user space, which is why we intentionally did not add
MSR_ARCH_LBR_* stuff to msrs_to_save_all[] in earlier versions.

But hopefully, we may make it at least migratable for Arch LBR.

I'm personally curious about the cost of using XSAVES to swicth
guest lbr msrs during vmx transaction, and if the cost is unacceptable,
we may ask the perf host to adjust different depths for threads.


