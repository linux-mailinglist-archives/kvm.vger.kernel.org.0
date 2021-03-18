Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F097340C26
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 18:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhCRRvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 13:51:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27721 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232375AbhCRRuk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 13:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616089839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GaB9fVaYuzkV8qxhLF2+eypJcvPKkkijOEJmXSML3W4=;
        b=At3uhp787/Hf+3Yg88Ca0HCcQ4Lb4GwSc2v4smMD/QplHm8hSLYjN/UgU8SCWBbz260tKg
        m9oBGvJEgBG3akvX3ZjlSNsgZ6L47Rviur3xTYSU1JQGJurTUE+ttRSa1p7nN7F6XfDdPQ
        c5JAMnxoTXkiGvRaaRnbSE62syMdUfI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-Wl34B7BsO02HGW6iVbwDaA-1; Thu, 18 Mar 2021 13:50:38 -0400
X-MC-Unique: Wl34B7BsO02HGW6iVbwDaA-1
Received: by mail-wm1-f69.google.com with SMTP id i14so12124571wmq.7
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 10:50:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GaB9fVaYuzkV8qxhLF2+eypJcvPKkkijOEJmXSML3W4=;
        b=PVPFKywyCK2yuxx2O1Opb45kNPhy3kqlXvsqxsUpexKuw+zYywx+Le8Ezfjh5txpKT
         EZ5TkfCqjRcCGiuUR8ospLGHc2B+0OQZY9/A+sqDcXh5lcKmheVtUZk02gTjN0cn8sYr
         BsKaz1biEdi/5M38cq75RmLhwoJ8YTQpvNf0ihAP/YoOetIdT/zgkio22VTXvPePOOoz
         +sVxfYlYcQhdgA3514NJsvx20k+OCH0bZGags/CDQaXC/wKTHoVqb+weBkSvtA6DgkOc
         HHnqFswJyxndlTOH7N0F3ZnluS237cid7bvNXzkXyMs+y0ezODiREwOIbm9WLhxwn+45
         syTA==
X-Gm-Message-State: AOAM532slj5WF3t9pXMIigmguWPkwN2UAvYLjY79rCOwyvau6OhVcuo1
        tfa6iewojB3T4pkvp3D30DhU2u4GoZNwV3ETLiO7vbPaGEhYoKZRUEihXv5YhLJLMiDcLnKsZGE
        WPgDuLXxkJ3Pp
X-Received: by 2002:a1c:6a03:: with SMTP id f3mr277575wmc.179.1616089837171;
        Thu, 18 Mar 2021 10:50:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxzXeD06F6sGhwD1KcdbCvKAK5NOfDgyeRfdedzOIN6h9Tiq5xxchOkLItr1M4zvMBq3+/+A==
X-Received: by 2002:a1c:6a03:: with SMTP id f3mr277559wmc.179.1616089836966;
        Thu, 18 Mar 2021 10:50:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f16sm3653164wrt.21.2021.03.18.10.50.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 10:50:36 -0700 (PDT)
Subject: Re: [PATCH v2 6/4] selftests: kvm: Add basic Hyper-V clocksources
 tests
To:     Marcelo Tosatti <mtosatti@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20210316143736.964151-1-vkuznets@redhat.com>
 <20210318140949.1065740-1-vkuznets@redhat.com>
 <20210318165756.GA36190@fuller.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4882dc8f-30bf-f049-f770-24811bb96b54@redhat.com>
Date:   Thu, 18 Mar 2021 18:50:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210318165756.GA36190@fuller.cnet>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/03/21 17:57, Marcelo Tosatti wrote:
> I think this should be monotonically increasing:
> 
> 1.	r1 = rdtsc();
> 2.	t1 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
> 3.	nop_loop();
> 4.	r2 = rdtsc();
> 5.	t2 = rdmsr(HV_X64_MSR_TIME_REF_COUNT);	
> 
>>
>> +	/* 1% tolerance */
>> +	GUEST_ASSERT(delta_ns * 100 < (t2 - t1) * 100);
>> +}
> 
> Doesnt an unbounded schedule-out/schedule-in (which resembles
> overloaded host) of the qemu-kvm vcpu in any of the 
> points 1,2,3,4,5 break the assertion above?


Yes, there's a window of a handful of instructions (at least on 
non-preemptible kernels).  If anyone ever hits it, we can run the test 
100 times and check that it passes at least 95 or 99 of them.

Paolo

