Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E01C2FA823
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 19:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407358AbhARR7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 12:59:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25788 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406224AbhARR6c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 12:58:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610992625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NlQXtC0mzOszNv+aplUwR6g3eZHcO9aB3QV50suaILc=;
        b=hZzXWOKzMjTCwf/+tZCXLadIGqXIiy2OSwVD3ZfwG8SJjLzInJVbGQAtQXPLoVAndLrXrS
        F8QLC7GcyWnpRQdd7pCiSkT0EFCI7c5KpXD+NOqrhWkC4Ipbs7IVhHsFXdoaD2wQ6JaHtS
        gEWs1TC8CR+GQUrV7WPg4MvDeF0A8Eg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-olYHufcNOqe8bLdKD3tzRg-1; Mon, 18 Jan 2021 12:57:04 -0500
X-MC-Unique: olYHufcNOqe8bLdKD3tzRg-1
Received: by mail-ed1-f69.google.com with SMTP id x13so8188247edi.7
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 09:57:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NlQXtC0mzOszNv+aplUwR6g3eZHcO9aB3QV50suaILc=;
        b=nLQAH6siwB+vmZoG6Xxa3pln+n1hno48E/AN5WPKBLEsO/f+doiywvsmzLdOCy2LvN
         vcQHQR4N7eZb/IzITpSCLQrhGynX7gmkFlPE7wNGQUojlhG7X4ujlHCTBYzK62yJo8dv
         QRtwwdFRTusX3YLp/dsX3C6bC5KfEOfVtKsMUiclHfJAlIpojdebFBnnJOKMTPmvoTRx
         GCa1371Z/wNSSTcWYquJKqHvt9tue6a+gFiKSoJhZJ9ipelVjirYFyXldnCCwptsFmhp
         aXj+ZlgyZCOkzLHEvr9uaaqBZNuCUUDP5TD6QiZ7ukAssqx3nE2w50DmPhDRSz6A+UIR
         FxHQ==
X-Gm-Message-State: AOAM5332gKv0OtOVaOHhJ2V3XwS2XCQnMAflOBYBCJZyJAfOdjykoZlJ
        s0NUjbTP3IWMJjse2n0z0ZObWxZ6xZW7QTye2QPlaqcuh84zoFs5TYih0X3IHEbJOASjzLY9p7R
        7sa/+3WRjb3O4
X-Received: by 2002:a17:906:29d4:: with SMTP id y20mr555806eje.294.1610992622935;
        Mon, 18 Jan 2021 09:57:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyEoFbQc+ttDUuazF7d1C0cmNHto/uojPB7s4MxeJxEcNPW5tKhPP/wQuCZGYmmWPaS7jATyQ==
X-Received: by 2002:a17:906:29d4:: with SMTP id y20mr555796eje.294.1610992622784;
        Mon, 18 Jan 2021 09:57:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z24sm11040996edr.9.2021.01.18.09.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:57:02 -0800 (PST)
Subject: Re: [PATCH] KVM: x86/pmu: Fix HW_REF_CPU_CYCLES event pseudo-encoding
 in intel_arch_events[]
To:     Like Xu <like.xu@linux.intel.com>,
        Stephane Eranian <eranian@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201230081916.63417-1-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <166bdae7-529a-cd17-a164-6e86ef7f6124@redhat.com>
Date:   Mon, 18 Jan 2021 18:57:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201230081916.63417-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/12/20 09:19, Like Xu wrote:
> The HW_REF_CPU_CYCLES event on the fixed counter 2 is pseudo-encoded as
> 0x0300 in the intel_perfmon_event_map[]. Correct its usage.
> 
> Fixes: 62079d8a4312 ("KVM: PMU: add proper support for fixed counter 2")
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index a886a47daebd..013e8d253dfa 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -29,7 +29,7 @@ static struct kvm_event_hw_type_mapping intel_arch_events[] = {
>   	[4] = { 0x2e, 0x41, PERF_COUNT_HW_CACHE_MISSES },
>   	[5] = { 0xc4, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
>   	[6] = { 0xc5, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
> -	[7] = { 0x00, 0x30, PERF_COUNT_HW_REF_CPU_CYCLES },
> +	[7] = { 0x00, 0x03, PERF_COUNT_HW_REF_CPU_CYCLES },
>   };
>   
>   /* mapping between fixed pmc index and intel_arch_events array */
> 

Queued, thanks.

Paolo

