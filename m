Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AF0434900
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 12:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhJTKfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 06:35:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229702AbhJTKfv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 06:35:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634726016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c+6ia2LTxEZdCSQG6Lo1j9cq6FIxE6MAj01YvsoiNsg=;
        b=II2Fro2U/K1d4YysqSXDbsLzydByrmVAlOYNzJqsoxwHjlxbVBZogq455bsuXc7/YoSVi4
        kVymvWjDvkFvpaHFcOwDEr90CRdrviLbD4/iig57mH52uzT3IIcX6odrcM0t6IWJ1k0k/W
        K8MsZvRaQmlwkh6akqkvSCs8BElAexg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-Ejx0Wv6kN_mRqMmYH582rA-1; Wed, 20 Oct 2021 06:33:35 -0400
X-MC-Unique: Ejx0Wv6kN_mRqMmYH582rA-1
Received: by mail-ed1-f71.google.com with SMTP id s12-20020a50dacc000000b003dbf7a78e88so17519492edj.2
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 03:33:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=c+6ia2LTxEZdCSQG6Lo1j9cq6FIxE6MAj01YvsoiNsg=;
        b=SGS3DO2f6w/Uou8GtUYSiga1Yc2LZHN2VD6cnjJZEZhVF3xphnfASzkjBeJofCaQsy
         8SIrr1QGInFH3Y0h7kT8zdjxzWZi1N8GW56WITDWezKaoGoZqoUwnBOMrvUOK//Xns+J
         2FAubgjYii3zrhZbVhX64XQ0FHdo8StYbLjiXOPyW9Ru+fm1OHx9gpFabIYh0erbB0gi
         ZmN3yylS+/jG6mnne4IPz3H5Oa3CLMNBq7ZHyRrsWfe6YEZJPoAbrxRaNIATYeTISBYQ
         9HQEyhrQ/r794Zd5w7lHTeuaQ2E/ogHeY2IiuZGkOI5Ys2tnfYjbBUt4ebHiair58rna
         1YmA==
X-Gm-Message-State: AOAM532erGNmf8CRMrG0MG/SHtDdDURIIx/z0unMWVdXfB5pep+lgoeC
        7BVSL+dRqMXFYvZevjF2tDpyGZCp1tq20mff05/1QkoVD+gVJJxjz19Dbw6PxbjA1ST1NERC4W3
        NlpqR6vXgCUNe
X-Received: by 2002:aa7:db85:: with SMTP id u5mr61582472edt.234.1634726014090;
        Wed, 20 Oct 2021 03:33:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwf69jh8Tsq/ji+O31UdlUMjv9FrJMufHa75zZI9BcMFSvJHPo4Z2tB3R/7FjmHRZjo65gyWA==
X-Received: by 2002:aa7:db85:: with SMTP id u5mr61582432edt.234.1634726013789;
        Wed, 20 Oct 2021 03:33:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z19sm861455ejp.97.2021.10.20.03.33.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 03:33:32 -0700 (PDT)
Message-ID: <9fdab135-648c-a378-9a64-f069cf6c0eba@redhat.com>
Date:   Wed, 20 Oct 2021 12:33:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 3/3] KVM: vCPU kick tax cut for running vCPU
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1634631160-67276-1-git-send-email-wanpengli@tencent.com>
 <1634631160-67276-3-git-send-email-wanpengli@tencent.com>
 <24e67e43-c50c-7e0f-305a-c7f6129f8d70@redhat.com>
 <YW8BmRJHVvFscWTo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YW8BmRJHVvFscWTo@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/10/21 19:34, Sean Christopherson wrote:
> The intent of the extra check was to avoid the locked instruction that comes with
> disabling preemption via rcu_read_lock().  But thinking more, the extra op should
> be little more than a basic arithmetic operation in the grand scheme on modern x86
> since the cache line is going to be locked and written no matter what, either
> immediately before or immediately after.

There should be no locked instructions unless you're using 
PREEMPT_RT/PREEMPT_RCU, no?  The preempt_disable count is in a percpu 
variable.

> 
> +       /*
> +        * Avoid the moderately expensive "should kick" operation if this pCPU
> +        * is currently running the target vCPU, in which case it's a KVM bug
> +        * if the vCPU is in the inner run loop.
> +        */
> +       if (vcpu == __this_cpu_read(kvm_running_vcpu) &&
> +           !WARN_ON_ONCE(vcpu->mode == IN_GUEST_MODE))
> +               goto out;
> +

It should not even be a problem if vcpu->mode == IN_GUEST_MODE, you just 
set it to EXITING_GUEST_MODE without even the need for atomic_cmpxchg.
I'll send a few patches out, since I think I found some related issues.

Paolo

