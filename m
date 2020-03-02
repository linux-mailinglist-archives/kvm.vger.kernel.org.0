Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F164175617
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 09:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbgCBIj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 03:39:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26600 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726887AbgCBIj1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 03:39:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583138365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=In6B5Nqay6OjSYXjdC6WBXSSPvDHOlAmJirTMaGmDew=;
        b=gG23rGul6lFJ+3FtE6A8f+tbvtlVFSrDhnIvn7jUdD9YgTJiv/kSwIwbZQxHoVcCoiFDna
        wMrTN8x1w70l5FJ+owTmXS30p2mJRptu3WK+uQ1prJ3gnPpYwxQTe/K5f4F8vwdClJpVbj
        bwyEzkpMqNnHduDQL6giA5pq4piF/TA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-OXeVLgnqMvCAi416ya49-A-1; Mon, 02 Mar 2020 03:39:23 -0500
X-MC-Unique: OXeVLgnqMvCAi416ya49-A-1
Received: by mail-wr1-f72.google.com with SMTP id m13so5486050wrw.3
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 00:39:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=In6B5Nqay6OjSYXjdC6WBXSSPvDHOlAmJirTMaGmDew=;
        b=d2cHjoWe5MEPMEOnRfJsyx5aBvZyAfS2KLu/mcHYoixA3G1xV4AMt6BAQ1r2no++Tw
         i21uc6w5+SEqX7ebfxEyE5AEbPtJke38NC1Wt7D5ehVhb51IOzgzTzl+A18jaWwMzQuz
         doucEjI28A9jxsOMAQ3HmkRIyYnw4VQwXmJ+/Wk5cxUrE+7PE4EDq6jG18yKS/1Uv9aT
         CfCvxrEWIKkCytzJlamwGQ+2dR/R9fD/AnprZaj5ATMYwwDeT7GJ5V0ysRitalG5Aykw
         as8uLyRHwDCaaojiZFDbSa0NN9berR+rTr0HkoszVrpoOfSJFVwysC/VX8bcUK9yAGbA
         qI0g==
X-Gm-Message-State: APjAAAVuppj1sAgeFoxc6HIS8jjuUQh7fNdZRjArY5StfgDxGnRCvIQj
        VCZpg5qusS2HiuJe0O+wPTXhnynTk3fqEsmnPhHLAf7VH7fLmfHYEBoyc7kDvPWOB524M61jfh+
        rwto6KS/1KVYi
X-Received: by 2002:a05:600c:2409:: with SMTP id 9mr19197780wmp.140.1583138362691;
        Mon, 02 Mar 2020 00:39:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqzHCi5FmYsYSJxxm8KEIjI1zi72JmZ0Mwdaa2HdULA6dydXqlr9ZV3N/74rR/Xnlui4XCw8sQ==
X-Received: by 2002:a05:600c:2409:: with SMTP id 9mr19197754wmp.140.1583138362459;
        Mon, 02 Mar 2020 00:39:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e1d9:d940:4798:2d81? ([2001:b07:6468:f312:e1d9:d940:4798:2d81])
        by smtp.gmail.com with ESMTPSA id w19sm13954120wmc.22.2020.03.02.00.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 00:39:21 -0800 (PST)
Subject: Re: [PATCH] KVM: X86: Fix dereference null cpufreq policy
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
References: <1583133336-7832-1-git-send-email-wanpengli@tencent.com>
 <ab51f6c9-a67d-0107-772a-7fe57a2319cf@redhat.com>
 <20200302081207.3kogqwxbkujqgc7z@vireshk-i7>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <73a7db77-c4c7-029f-fd8a-080911fde41e@redhat.com>
Date:   Mon, 2 Mar 2020 09:39:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200302081207.3kogqwxbkujqgc7z@vireshk-i7>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/03/20 09:12, Viresh Kumar wrote:
> On 02-03-20, 08:55, Paolo Bonzini wrote:
>> On 02/03/20 08:15, Wanpeng Li wrote:
>>> From: Wanpeng Li <wanpengli@tencent.com>
>>>
>>> cpufreq policy which is get by cpufreq_cpu_get() can be NULL if it is failure,
>>> this patch takes care of it.
>>>
>>> Fixes: aaec7c03de (KVM: x86: avoid useless copy of cpufreq policy)
>>> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>>> Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
>>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>>
>> My bad, I checked kobject_put but didn't check that kobj is first in
>> struct cpufreq_policy.
>>
>> I think we should do this in cpufreq_cpu_put or, even better, move the
>> kobject struct first in struct cpufreq_policy.  Rafael, Viresh, any
>> objection?
>>
>> Paolo
>>
>>>  		policy = cpufreq_cpu_get(cpu);
>>> -		if (policy && policy->cpuinfo.max_freq)
>>> -			max_tsc_khz = policy->cpuinfo.max_freq;
>>> +		if (policy) {
>>> +			if (policy->cpuinfo.max_freq)
>>> +				max_tsc_khz = policy->cpuinfo.max_freq;
>>> +			cpufreq_cpu_put(policy);
>>> +		}
> 
> I think this change makes sense and I am not sure why should we even
> try to support cpufreq_cpu_put(NULL).

For the same reason why we support kfree(NULL) and kobject_put(NULL)?

Paolo

