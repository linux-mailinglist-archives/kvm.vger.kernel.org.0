Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03788322B81
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 14:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbhBWNcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 08:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbhBWNcl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 08:32:41 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C04C061574
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 05:32:01 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id o63so12351527pgo.6
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 05:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=hHZUbJhPLk9o6DvZseTdExs1WtaGzP9WxZ6tEy/AWRo=;
        b=mmGQYRlAnN7UxkLvDn6c7WB5vR1PpEjdXmsaas7+e4jlQXfOAHgxMdLPXasF5grUwK
         vt9L8O+WYzicfLsvT8DQcYascau7927v4ps38M72XQq7nKkZpx76h0gg3qynYXUJ3T62
         15IGIOM28ZmCzyK5gTn2smrLTR1YEzAqmax4Ho0kDQKzA1GGRyvxkJv5sNpfeydf1rpd
         oKuNxG3x4T6ZjGlQIgN4QX0BUXbwCsXpxmZZK7POg3+9NyQldO1OT2+w24qoOCScefL6
         ThyBttjIML+i/PVXlsA0Y/SDf3lYmMCFvTS4XyZ9DCYOoVn12UKgL7+1LMWGaJMe5ExX
         563g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=hHZUbJhPLk9o6DvZseTdExs1WtaGzP9WxZ6tEy/AWRo=;
        b=t8EwgG39wgAOKPo4grpMtQdDVxWJ5wD0EANfkSHxc5W0N6VYKl9O71NQJbdmmp4WI1
         hM+DILy7E9qwlZdUISqEv5GVGoK/pdv4ki3iCQ7rwTPsZmtGLDLhwmFUM5ksqy5NS0wK
         kEHajfmyRnBjLN894vJe4US+lN3DgOIiZOx3O6ONFwHLrAHKn1zqbbAnQMQt4G/OC+S6
         FjF9R1oSWS9a5px91R/BPoPYPCavHYXp2zr0GpehlOmtliXrhg49uEVY1n/Fw/kmThA/
         NjTCgo+8wy7ZXdhEtOH4m5NK5AynO3AlrR65Xyd3YwwlsT06Lm7O4xFcgA1K+AXsDYnV
         XCiw==
X-Gm-Message-State: AOAM531ic9A9IzENaQjb8HH3m71nCFynh2OlK1QUWkINF64Zkd4+tqMd
        QYk2fCVGg2wCl+skbKTo97zt2w==
X-Google-Smtp-Source: ABdhPJzI3rFr/Pef902twsyvVGLNIEXBsXMAmh/IEFaa4WGuj5Egp0mrBwsnge3YbeO5tBkpdp0zAA==
X-Received: by 2002:a63:4956:: with SMTP id y22mr24558205pgk.309.1614087121032;
        Tue, 23 Feb 2021 05:32:01 -0800 (PST)
Received: from [10.85.116.39] ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id 72sm7965127pfv.5.2021.02.23.05.31.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 05:32:00 -0800 (PST)
Subject: Re: [External] Re: [RESEND RFC: timer passthrough 0/9] Support timer
 passthrough for VM
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        fweisbec@gmail.com, zhouyibo@bytedance.com,
        zhanghaozhong@bytedance.com
References: <20210205100317.24174-1-fengzhimin@bytedance.com>
 <YCF/ZzI3OTBRMgVf@Konrads-MacBook-Pro.local>
From:   Zhimin Feng <fengzhimin@bytedance.com>
Message-ID: <99d0a029-9523-0dc4-aa37-e22fc9080960@bytedance.com>
Date:   Tue, 23 Feb 2021 21:31:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YCF/ZzI3OTBRMgVf@Konrads-MacBook-Pro.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi

The host timer would be saved when cpu entry the non-root mode, and it 
would be restored when cpu entry the root mode. So the guest doesn't the 
host timer.

The host timer would be written to the preemption timer in non-root 
mode. When the host timer is expired(preemption timer value is '0'), the 
preemption timer would trigger immediate VMExit, so the host timer would 
be handled in the preemption timer handler.

Thanks!

Zhimin

在 2021/2/9 上午2:13, Konrad Rzeszutek Wilk 写道:
> On Fri, Feb 05, 2021 at 06:03:08PM +0800, Zhimin Feng wrote:
>> The main motivation for this patch is to improve the performance of VM.
>> This patch series introduces how to enable the timer passthrough in
>> non-root mode.
> Nice! Those are impressive numbers!
>
>> The main idea is to offload the host timer to the preemtion timer in
>> non-root mode. Through doing this, guest can write tscdeadline msr directly
>> in non-root mode and host timer isn't lost. If CPU is in root mode,
>> guest timer is switched to software timer.
> I am sorry - but I am having a hard time understanding the sentence
> above so let me ask some specific questions.
>
> - How do you protect against the guest DoS-ing the host and mucking with
>    the host timer?
>
> - As in can you explain how the host can still continue scheduling it's
>    own quanta?
>
> And one more - what happens with Live Migration? I would assume that
> becomes a no-go anymore unless you swap in the guest timer back in? So
> we end up emulating the MSR again?
>
> Thanks!
>
>> Testing on Intel(R) Xeon(R) Platinum 8260 server.
>>
>> The guest OS is Debian(kernel: 4.19.28). The specific configuration is
>>   is as follows: 8 cpu, 16GB memory, guest idle=poll
>> memcached in guest(memcached -d -t 8 -u root)
>>
>> I use the memtier_benchmark tool to test performance
>> (memtier_benchmark -P memcache_text -s guest_ip -c 16 -t 32
>>   --key-maximum=10000000000 --random-data --data-size-range=64-128 -p 11211
>>   --generate-keys --ratio 5:1 --test-time=500)
>>
>> Total Ops can be improved 25% and Avg.Latency can be improved 20% when
>> the timer-passthrough is enabled.
>>
>> =============================================================
>>                 | Enable timer-passth | Disable timer-passth |
>> =============================================================
>> Totals Ops/sec |    514869.67        |     411766.67        |
>> -------------------------------------------------------------
>> Avg.Latency    |    0.99483          |     1.24294          |
>> =============================================================
>>
>>
>> Zhimin Feng (9):
>>    KVM: vmx: hook set_next_event for getting the host tscd
>>    KVM: vmx: enable host lapic timer offload preemtion timer
>>    KVM: vmx: enable passthrough timer to guest
>>    KVM: vmx: enable passth timer switch to sw timer
>>    KVM: vmx: use tsc_adjust to enable tsc_offset timer passthrough
>>    KVM: vmx: check enable_timer_passth strictly
>>    KVM: vmx: save the initial value of host tscd
>>    KVM: vmx: Dynamically open or close the timer-passthrough for pre-vm
>>    KVM: vmx: query the state of timer-passth for vm
>>
>>   arch/x86/include/asm/kvm_host.h |  27 ++++
>>   arch/x86/kvm/lapic.c            |   1 +
>>   arch/x86/kvm/vmx/vmx.c          | 331 +++++++++++++++++++++++++++++++++++++++-
>>   arch/x86/kvm/x86.c              |  26 +++-
>>   include/linux/kvm_host.h        |   1 +
>>   include/uapi/linux/kvm.h        |   3 +
>>   kernel/time/tick-common.c       |   1 +
>>   tools/include/uapi/linux/kvm.h  |   3 +
>>   virt/kvm/kvm_main.c             |   1 +
>>   9 files changed, 389 insertions(+), 5 deletions(-)
>>
>> -- 
>> 2.11.0
>>
