Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129E23EA582
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 15:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237817AbhHLNWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 09:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237674AbhHLNVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 09:21:35 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD38C00EA85;
        Thu, 12 Aug 2021 06:21:05 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id l11so7259755plk.6;
        Thu, 12 Aug 2021 06:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RrGE9qY6q5pKFuZWe8wC47/1qSM0FaVp53alD7sacQE=;
        b=OGNXPwUdKji1eWBa5xXxJDq3MgBncwNQKXtkauakvygJ0dKVUn7plbxTp/KCakypZK
         snQOX9YC0+5HSAf7yZ9a49Qg0kyOQpP3mUTR25ICYbi9PwleAf0OCASYBIIz6p2Vtym3
         h2Qa5Rf63XLsbVkcXVperA+PUin2+kDeOweWqwr5A7oUx9b31K1sUv6LyfODCQ4s3W1k
         Nf5hpAveP3kO+tbsqg6juaKysvroqZWJCnjWKQYFV/5/UXGjk0fwrGAgXV/hymUukkPV
         sMXdeI3E9D85PvCAz3yIn7ohHufCsyIxGAgRLdJRsdjKM9uE/jINnctlpzTUXqTY9iLo
         CBow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RrGE9qY6q5pKFuZWe8wC47/1qSM0FaVp53alD7sacQE=;
        b=IbNPxNcwt6hQReCjCOfinfi+3l1AAo7xx9NEX10bxAN1LxtyaK0mDjuNPDEKV3EC5b
         H/CiiJZxmIeYexcOPPefARxLKB/oC2RPmaEh5AlhB/s5rJEZPLxVA2IbdFFyLOXbM1UA
         KAIWUkFaOuGj4AMzc0/P7sdaU4JRtO/jNbrlUR2PJTN4GH1O9u9tDhSFMmvmovtSSdRT
         D2sJ7PT5PgNAuJjYvh8cW8xk5Eh/2L/zsBsQkMlWxGdCzW248nkArEZaDA+KGo8ErsZh
         uwVblwUVCELHbBBolZvGAl7hV6EQUEagnAgkLG8WWN7k6I2a8XpptLG5gUlMAm9o5+FY
         /wIw==
X-Gm-Message-State: AOAM533lw3P2z56dk/HPHp7Fr17xaNcOt95ClU7oVTUYIqLUInaz/oft
        B1kO/dbzxYhVenLUhufDWwY=
X-Google-Smtp-Source: ABdhPJxI5Tt5vtX0zDMijSjVIafzeaLyGnUw+kmctuBeTvjTDKCowjwc84IH7yc1FevEY92nWvuqIw==
X-Received: by 2002:a17:902:ea03:b029:12d:13d8:63d1 with SMTP id s3-20020a170902ea03b029012d13d863d1mr3420739plg.49.1628774465161;
        Thu, 12 Aug 2021 06:21:05 -0700 (PDT)
Received: from Likes-MacBook-Pro.local ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j185sm3674708pfb.86.2021.08.12.06.21.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 06:21:04 -0700 (PDT)
Subject: Re: [PING][PATCH V9 00/18] KVM: x86/pmu: Add *basic* support to
 enable guest PEBS via DS
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        boris.ostrvsky@oracle.com, Zhu Lingshan <lingshan.zhu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20210722054159.4459-1-lingshan.zhu@intel.com>
 <YQF7lwM6qzYso0Gg@hirez.programming.kicks-ass.net>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Message-ID: <d4899d1b-b04d-6d96-7a29-dfb10355d601@gmail.com>
Date:   Thu, 12 Aug 2021 21:20:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YQF7lwM6qzYso0Gg@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 28/7/2021 11:45 pm, Peter Zijlstra wrote:
>> Like Xu (17):
>>    perf/core: Use static_call to optimize perf_guest_info_callbacks
>>    perf/x86/intel: Add EPT-Friendly PEBS for Ice Lake Server
>>    perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
>>    perf/x86/core: Pass "struct kvm_pmu *" to determine the guest values
>>    KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit when vPMU is enabled
>>    KVM: x86/pmu: Introduce the ctrl_mask value for fixed counter
>>    KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
>>    KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter
>>    KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
>>    KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS
>>    KVM: x86/pmu: Add PEBS_DATA_CFG MSR emulation to support adaptive PEBS
>>    KVM: x86: Set PEBS_UNAVAIL in IA32_MISC_ENABLE when PEBS is enabled
>>    KVM: x86/pmu: Move pmc_speculative_in_use() to arch/x86/kvm/pmu.h
>>    KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
>>    KVM: x86/pmu: Add kvm_pmu_cap to optimize perf_get_x86_pmu_capability
>>    KVM: x86/cpuid: Refactor host/guest CPU model consistency check
>>    KVM: x86/pmu: Expose CPUIDs feature bits PDCM, DS, DTES64
>>
>> Peter Zijlstra (Intel) (1):
>>    x86/perf/core: Add pebs_capable to store valid PEBS_COUNTER_MASK value
> Looks good:
> 
> Acked-by: Peter Zijlstra (Intel)<peterz@infradead.org>
> 
> How do we want to route this, all through the KVM tree?

Do you have any comments for the latest version[1]
or do we have a chance to get it queued for mainline ?

I would really like to ease the burden of Lingshan on
maintaining this feature and on the basis of this work,
the guest BTS (Branch Tracking Store) is also ready to go.

Thanks,
Like Xu

[1] https://lore.kernel.org/kvm/20210806133802.3528-1-lingshan.zhu@intel.com/
