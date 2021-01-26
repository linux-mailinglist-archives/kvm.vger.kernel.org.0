Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E961304C4A
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 23:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbhAZWgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:36:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727292AbhAZR2J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 12:28:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611681999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=InZZx23ByJsMJtgt8v5MW2KPKFZSHMum0ATgeWIjqd8=;
        b=QPAj0sEI+R319997Zm2uGU1TPqp5yidRph4JSPk6URld4d+dF5P0rCfglkkFyCE88+HqJJ
        p3W8muyb3aalY+7lon+UYDgejAQP03EfRar1E0lHY5LaPKa7yf84zviZa9bHOYmjC+ONa3
        eyZmHxpBGIfVphbf3leUcLijQWDczu8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-MiYI8mXtPvqfDZbdDwbgtQ-1; Tue, 26 Jan 2021 12:26:37 -0500
X-MC-Unique: MiYI8mXtPvqfDZbdDwbgtQ-1
Received: by mail-ej1-f71.google.com with SMTP id d15so5187431ejc.21
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 09:26:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=InZZx23ByJsMJtgt8v5MW2KPKFZSHMum0ATgeWIjqd8=;
        b=W1OdeSmu/ovdDQSX3L7y818EZAsD9dhOU6nYMf9nlQa4Sn0SF0uBu66IUg0pYbgzM8
         CZhbDQQ7SGuGlUdmUnnAKFSe+uUzKT1wfqJ6i4vUm4ob405wPYNGbunL8jwG29gawipC
         Ei1/5Eolv4orn/YW8o16er/IrmLr+oH9Kq6w/CRrg3ty0O2mWQF/ZM0JNZKN+AO/Xf2g
         7wOdBQtfPSQVwS+s7e6bXOWA3IcmyNT8FpUlB9d+1f+MuWPnM57G352gtEzgRwpWQR7g
         Ac58BgS7WCqHzA/PN/uTSKjZcST1vLfm2OGQAJFpiI3q1iJsjowWfMCGNOIQ5cXDjZg3
         JfHg==
X-Gm-Message-State: AOAM533UGexbCVVG7n2yUaq2imFszs0THrT/OCB0ghW9wZM2uo3b08K7
        oQYsqh/Bc3cGBQWvIzvNxlOw4yQCgwN0/G55fNbo/4Sh488mRlpzHBehwrWxFk1YYHB6s2u0fUL
        1zH4jls7nkbNS
X-Received: by 2002:a17:906:51d0:: with SMTP id v16mr4206647ejk.510.1611681995782;
        Tue, 26 Jan 2021 09:26:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzgaHAAGGEQ9wEkCKCReCIm094S45eXiZvU1xS2t+W5jQo1GluQUlphaRP+rMn95s2NGrkfUg==
X-Received: by 2002:a17:906:51d0:: with SMTP id v16mr4206634ejk.510.1611681995633;
        Tue, 26 Jan 2021 09:26:35 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k2sm10057634ejp.6.2021.01.26.09.26.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 09:26:34 -0800 (PST)
To:     Wanpeng Li <kernellwp@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <1610960877-3110-1-git-send-email-wanpengli@tencent.com>
 <CANRm+Cx65UHSJA+S4qRR1wdZ=dhyM=U=KwZnbNUSN4XdM1nyQA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: kvmclock: Fix vCPUs > 64 can't be
 online/hotpluged
Message-ID: <146d2a3f-88db-ff80-29d6-de2b22efdf61@redhat.com>
Date:   Tue, 26 Jan 2021 18:26:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cx65UHSJA+S4qRR1wdZ=dhyM=U=KwZnbNUSN4XdM1nyQA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/01/21 02:28, Wanpeng Li wrote:
> ping，
> On Mon, 18 Jan 2021 at 17:08, Wanpeng Li <kernellwp@gmail.com> wrote:
>>
>> From: Wanpeng Li <wanpengli@tencent.com>
>>
>> The per-cpu vsyscall pvclock data pointer assigns either an element of the
>> static array hv_clock_boot (#vCPU <= 64) or dynamically allocated memory
>> hvclock_mem (vCPU > 64), the dynamically memory will not be allocated if
>> kvmclock vsyscall is disabled, this can result in cpu hotpluged fails in
>> kvmclock_setup_percpu() which returns -ENOMEM. This patch fixes it by not
>> assigning vsyscall pvclock data pointer if kvmclock vdso_clock_mode is not
>> VDSO_CLOCKMODE_PVCLOCK.

I am sorry, I still cannot figure out this patch.

Is hotplug still broken if kvm vsyscall is enabled?

Paolo

>> Fixes: 6a1cac56f4 ("x86/kvm: Use __bss_decrypted attribute in shared variables")
>> Reported-by: Zelin Deng <zelin.deng@linux.alibaba.com>
>> Tested-by: Haiwei Li <lihaiwei@tencent.com>
>> Cc: Brijesh Singh <brijesh.singh@amd.com>
>> Cc: stable@vger.kernel.org#v4.19-rc5+
>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>> ---
>> v1 -> v2:
>>   * add code comments
>>
>>   arch/x86/kernel/kvmclock.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
>> index aa59374..01d4e55c 100644
>> --- a/arch/x86/kernel/kvmclock.c
>> +++ b/arch/x86/kernel/kvmclock.c
>> @@ -294,9 +294,11 @@ static int kvmclock_setup_percpu(unsigned int cpu)
>>          /*
>>           * The per cpu area setup replicates CPU0 data to all cpu
>>           * pointers. So carefully check. CPU0 has been set up in init
>> -        * already.
>> +        * already. Assign vsyscall pvclock data pointer iff kvmclock
>> +        * vsyscall is enabled.
>>           */
>> -       if (!cpu || (p && p != per_cpu(hv_clock_per_cpu, 0)))
>> +       if (!cpu || (p && p != per_cpu(hv_clock_per_cpu, 0)) ||
>> +           (kvm_clock.vdso_clock_mode != VDSO_CLOCKMODE_PVCLOCK))
>>                  return 0;
>>
>>          /* Use the static page for the first CPUs, allocate otherwise */
>> --
>> 2.7.4
>>
> 

