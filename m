Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2FC2A93E9
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 11:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgKFKR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 05:17:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23458 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbgKFKR2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 05:17:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604657847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c98dQk0zLTrCO2oJzlMdSO4XNM0SU0ansCker4yytFo=;
        b=ZWHrp7TNa0iuaxhzjaD00CUYWLsT5VjYAuM5qlDtLTi4OCkapqUYR4LJLsm1fV4pKZUulT
        rBCRqlmOa82nN+P7RtDT+Bk6G2oG/2K9ryqhsPWgBu78i+88Z0OxCDOb/9vKkTFWNvwSRH
        92dGbo9b/RzPkx2mZLJU8O0UTlhboRc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-fvr_DNVMOaOIkoDOkcwX1g-1; Fri, 06 Nov 2020 05:17:25 -0500
X-MC-Unique: fvr_DNVMOaOIkoDOkcwX1g-1
Received: by mail-wm1-f70.google.com with SMTP id z62so378184wmb.1
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 02:17:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c98dQk0zLTrCO2oJzlMdSO4XNM0SU0ansCker4yytFo=;
        b=N9eCxNlqvrS3XxCWKJk4dO2gSMopN7Ly6tO3ODJ0tm3x1djrs3LUuydqBEDfbBgPbz
         WjSjhcW9lxounus0HkgBVQj7YoNROrM/7jtZ5kf1X28JkIWXvXNe55Ka0pOJDQ2edySn
         0FGw62cvcNhPtwmX3ZFM/tpvDqzvpYW+9HY5nQ/RT0P8MkdOQxrgZuYI1OybGdh/6ViX
         EUXaIU4UgJqWLfzN9ePZbAidI6FgUFMrUdJ+E+a7LS3nTtp8ZvuL3TSXRqasm0w/HZTP
         CdYnPU/RE+3gPCpUy5YZdi6TNcEL+rQ/cuHEVK2k1neG10JDQl1nGzIE8Gf9jt6SE2Kr
         xAsw==
X-Gm-Message-State: AOAM530lk4ATqHXu04ZLN27QYK8950eSANVGrgPAarQ9Aa3Ap7KpwxyT
        FrQvPDbb0Ne/OV99VixwysdUb03APhX3e5CpuUKSpfhlLnAi5+u1aKtpFcgG5wJAgxVXHmQkLFL
        NBRDfzHXBPhAq
X-Received: by 2002:adf:f643:: with SMTP id x3mr1943817wrp.180.1604657844088;
        Fri, 06 Nov 2020 02:17:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwG3yefM6iYrAHyW3FdeRueDAy5/yBY0Kpc+zqzk+vfI5Ny0ljW2fbQMUCzV0oL7AHKxkNJ1A==
X-Received: by 2002:adf:f643:: with SMTP id x3mr1943794wrp.180.1604657843907;
        Fri, 06 Nov 2020 02:17:23 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id g23sm1535168wmh.21.2020.11.06.02.17.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 02:17:23 -0800 (PST)
Subject: Re: [PATCH v2 1/2] sched/wait: Add add_wait_queue_priority()
To:     David Woodhouse <dwmw2@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>
References: <20201026175325.585623-1-dwmw2@infradead.org>
 <20201027143944.648769-1-dwmw2@infradead.org>
 <20201027143944.648769-2-dwmw2@infradead.org>
 <20201028143509.GA2628@hirez.programming.kicks-ass.net>
 <ef4660dba8135ca5a1dc7e854babcf65d8cef46f.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f0901be7-1526-5b6a-90cb-6489e53cb92f@redhat.com>
Date:   Fri, 6 Nov 2020 11:17:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <ef4660dba8135ca5a1dc7e854babcf65d8cef46f.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/11/20 10:35, David Woodhouse wrote:
> On Wed, 2020-10-28 at 15:35 +0100, Peter Zijlstra wrote:
>> On Tue, Oct 27, 2020 at 02:39:43PM +0000, David Woodhouse wrote:
>>> From: David Woodhouse <dwmw@amazon.co.uk>
>>>
>>> This allows an exclusive wait_queue_entry to be added at the head of the
>>> queue, instead of the tail as normal. Thus, it gets to consume events
>>> first without allowing non-exclusive waiters to be woken at all.
>>>
>>> The (first) intended use is for KVM IRQFD, which currently has
>>> inconsistent behaviour depending on whether posted interrupts are
>>> available or not. If they are, KVM will bypass the eventfd completely
>>> and deliver interrupts directly to the appropriate vCPU. If not, events
>>> are delivered through the eventfd and userspace will receive them when
>>> polling on the eventfd.
>>>
>>> By using add_wait_queue_priority(), KVM will be able to consistently
>>> consume events within the kernel without accidentally exposing them
>>> to userspace when they're supposed to be bypassed. This, in turn, means
>>> that userspace doesn't have to jump through hoops to avoid listening
>>> on the erroneously noisy eventfd and injecting duplicate interrupts.
>>>
>>> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
>>
>> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 
> Thanks. Paolo, the conclusion was that you were going to take this set
> through the KVM tree, wasn't it?
> 

Queued, except for patch 2/3 in the eventfd series which Alex hasn't 
reviewed/acked yet.

Paolo

