Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C963C17B2
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 19:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhGHRG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 13:06:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42823 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229489AbhGHRG4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 13:06:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625763853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E8ONPfQUSVA2YZLmXzZtd9HLMlXkG1u4LXG9yECa9hM=;
        b=TLys5IVq1SbyoBK/jBRuRHZP7/qHqNY2rc89KnXV88E25jRW6d3BS/GvzI4hxLM8wB72Gs
        8KMCms2dLYiG+4dGV0MllGe2oUHJFYki+lVRbS+2UsOyiX7vmeF6lDysWPfpmHGTbvpX3Y
        +cFYoq8LYXgOQnGuwh3wA6l+fzwF3Fk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-B6OPMX-jMVSuJlKIc5AKDQ-1; Thu, 08 Jul 2021 13:04:12 -0400
X-MC-Unique: B6OPMX-jMVSuJlKIc5AKDQ-1
Received: by mail-ed1-f72.google.com with SMTP id m21-20020a50ef150000b029039c013d5b80so3650848eds.7
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 10:04:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E8ONPfQUSVA2YZLmXzZtd9HLMlXkG1u4LXG9yECa9hM=;
        b=bFxjCEqRg1eOPN6AGEs9LuMzRmC6/0tG/X37nRjRGlwV1D3+mvDz4IxzEMPuxW8bTh
         oUiutjq8YNot44s/PDpYyayzp+5P5ok4zvgC3O3zF1a7r1uAvZJnhcEoC2hJx8Jkwfee
         oP37mIDBzHVVMIwqXidxxInOQXd5OtfinpW5w9YFoMYdKUrcYBjXLyLerziSfein0O3g
         Sp55onoTI93pjV3kugJzn6wUtMMwKhNGnHdcwtMquqLHxcqJabPdzo33waaY4jph5uTo
         gfeaS+yaWv0aLAZTPy7E1c4LWTjmcTCz6GBtTnggmmKyFpDx+oo4KyA1/oCp+ZCt0mj5
         FR1g==
X-Gm-Message-State: AOAM531DD2LbH4UteYk9Bld85IjjWIJ42UUsaYxC35eEhnOZnqpGsHTC
        +A2doLpXPKVarPa51SB3Y9Av1vPqiRwyKD8XzDXJW0ZtWwderA1qJcNGB16Z17MEU6bfqPLvKfo
        7zWAw7YdyVGSs
X-Received: by 2002:aa7:dad3:: with SMTP id x19mr22354339eds.310.1625763851583;
        Thu, 08 Jul 2021 10:04:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjcSauD8vIdF5gc0z6HxXIYk+QksY8QrZj/Qmb1l6JhLIdnHokJqW/YuFdg7m1aznpGS+rag==
X-Received: by 2002:aa7:dad3:: with SMTP id x19mr22354321eds.310.1625763851459;
        Thu, 08 Jul 2021 10:04:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id eb9sm1221954ejc.32.2021.07.08.10.04.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 10:04:11 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Remove vmx_msr_index from vmx.h
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210707235702.31595-1-yu.c.zhang@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <52d7d0f8-231a-58f0-fafc-489e3b11742e@redhat.com>
Date:   Thu, 8 Jul 2021 19:04:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210707235702.31595-1-yu.c.zhang@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/21 01:57, Yu Zhang wrote:
> vmx_msr_index was used to record the list of MSRs which can be lazily
> restored when kvm returns to userspace. It is now reimplemented as
> kvm_uret_msrs_list, a common x86 list which is only used inside x86.c.
> So just remove the obsolete declaration in vmx.h.
> 
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> ---
>   arch/x86/kvm/vmx/vmx.h | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 3979a947933a..db88ed4f2121 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -14,8 +14,6 @@
>   #include "vmx_ops.h"
>   #include "cpuid.h"
>   
> -extern const u32 vmx_msr_index[];
> -
>   #define MSR_TYPE_R	1
>   #define MSR_TYPE_W	2
>   #define MSR_TYPE_RW	3
> 

Queued, thanks.

Paolo

