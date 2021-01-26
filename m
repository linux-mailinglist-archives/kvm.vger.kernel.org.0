Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC46303C5F
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 13:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405577AbhAZMBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 07:01:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30594 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391345AbhAZMAs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 07:00:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611662352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PGWpLftuQjuNLzaye3U4GXzH5jHxTUQ43zYa3q7xdcE=;
        b=hKIGYgMUljJgZRUHU9TGFzWh2YZ0fZIdJg54m4FdWSQQcOxJXB9d98ULx/NE+9y9X24drI
        d2hV/yKXhx4N/gwwSRyDmSkSuiqo01i8sX7yBylqd1Kl5g2dyLt9pqO8cMWFjDwxob79Cj
        Fw6LL5qZbQscQSVvnEBT8TZvzCHU0bU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-oTmVKqaWNvSu76-UInbsmQ-1; Tue, 26 Jan 2021 06:59:10 -0500
X-MC-Unique: oTmVKqaWNvSu76-UInbsmQ-1
Received: by mail-ej1-f69.google.com with SMTP id h18so4844883ejx.17
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 03:59:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PGWpLftuQjuNLzaye3U4GXzH5jHxTUQ43zYa3q7xdcE=;
        b=e/SPuji2iDWBnYh1XUu+KxZPOCPKpnFcvA9HaX8aW9ejgeCe7riDal7KZhfTfPmQVo
         fsbqMXczDkXr8FA/xzfXiA/aVzZlkKDzIp3KIqJcfPqVRgAzZRTRx1v7NeCzZzzRklZh
         c9g+6p5ll0EEUyWVC6V0/JPNLzH5zlqRZAOuRHdgGNRLDE4hP/ixM6lGecXVLDj/iLT4
         m8/AHOZyU0jzabuOJpPimCVrA7TbN5gAFAZjMdJ4gdjpCBr5/v3knmvm8w0pNbWNrXKw
         AAb+y7XIuNTYwNSQDo/ZWny+0AYPvSPlrA2BOKitBP/hXShpjOrELDqlE/9RgTAa1M66
         UHmg==
X-Gm-Message-State: AOAM532OAXyZQX1ZfrqvgP6zidpTuTNnDVeayzog4gYVG4EJOqcC+vak
        iJv9vku2wMJc+R0+fWL0Dt20MKKk22jYWb1NxiTidfmsqPpvqJeVDwb5Ur0vOrl2kCcT6GyQLSY
        RHS6YXquFEifp
X-Received: by 2002:aa7:d489:: with SMTP id b9mr4351200edr.374.1611662349166;
        Tue, 26 Jan 2021 03:59:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzIyFPHtxFmVQ3d8XTjk6mdNMKe92Qtm419gPqr857txoSLgGP0zBfu8z/i+vQBWTylyc4YNQ==
X-Received: by 2002:aa7:d489:: with SMTP id b9mr4351186edr.374.1611662348992;
        Tue, 26 Jan 2021 03:59:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a11sm12275795edt.26.2021.01.26.03.59.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 03:59:08 -0800 (PST)
Subject: Re: [PATCH] perf/intel: Remove Perfmon-v4 counter_freezing support
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>, luwei.kang@intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
References: <20201109021254.79755-1-like.xu@linux.intel.com>
 <20201110151257.GP2611@hirez.programming.kicks-ass.net>
 <20201110153721.GQ2651@hirez.programming.kicks-ass.net>
 <CABPqkBS+-g0qbsruAMfOJf-Zfac8nz9v2LCWfrrvVd+ptoLxZg@mail.gmail.com>
 <2ce24056-0711-26b3-a62c-3bedc88d7aa7@intel.com>
 <9a85e154-d552-3478-6e99-3f693b3da7ed@redhat.com>
 <0d26d8fc-5192-afbc-abab-88dd3d428eca@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d8cb6532-ee76-0bb4-3fc9-e14483a17517@redhat.com>
Date:   Tue, 26 Jan 2021 12:59:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <0d26d8fc-5192-afbc-abab-88dd3d428eca@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/01/21 12:35, Xu, Like wrote:
>>
> 
> Ah, now we have the v3 version on guest PEBS feature.
> It does not rely on counter_freezing, but disables the co-existence of 
> guest PEBS and host PEBS.
> I am not clear about your attitude towards this co-existence.
> 
> There are also more interesting topics for you to review and comment.
> Please check 
> https://lore.kernel.org/kvm/20210104131542.495413-1-like.xu@linux.intel.com/ 
> 

Thanks Like, I'll review that one.

Paolo

