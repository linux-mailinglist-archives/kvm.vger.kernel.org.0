Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B5F487AED
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 18:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348447AbiAGREP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 12:04:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348407AbiAGREO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 12:04:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641575053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yQ2sKCfCcZU2Bxbu6F8PHdSva7fA8R5kZpvDr4zlGGo=;
        b=fqwfmzPL4dGiAprBAr6YL2gLSRfo0pUxJW5aj5RJpsdl1OaXHq52EIuwnfg+MO2nBBxEZr
        j1dc7rcG+DOy/1BsBja5He9ttpbraBxUKSg6CiCu0JvFqdm6sCDDf6+lXJUG3m/08qxcal
        s3JGxpPdMGfcPA81nHdoKqsymoiEGoo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-UiqGG3_eNAWdvnZvux9tWQ-1; Fri, 07 Jan 2022 12:04:12 -0500
X-MC-Unique: UiqGG3_eNAWdvnZvux9tWQ-1
Received: by mail-ed1-f71.google.com with SMTP id z3-20020a05640240c300b003f9154816ffso5122522edb.9
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 09:04:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yQ2sKCfCcZU2Bxbu6F8PHdSva7fA8R5kZpvDr4zlGGo=;
        b=zn0GFZ7vvBqgMdYFEWxZV3nPmT3Z0SIqnO3Wuyx3UOEf3T4hXx8cuAL6YH78T6qard
         ZMR61SkkSyYfO0s1fo6ebE1/JsqdqJK7G5shf5ZD6SOEtdX7BnCan7g5eykiLzp+OYtJ
         2icDzCwzZXJl9f0Csm8fl54/HU4Ok9AWJA59gd9BSYa7BDyc+jlZ6+xRfjBaBeLWRrjy
         2CHpUodyH3G/2qkuvTloEpp+21U5ZF37unQiMUcCMYs6o6HDdbq6J7zMEiqEP4bmdHya
         kcYYmLH+5gYQdwxkn2CGiOndkeWm9EiBk1gPh8bIldiZNHPxDET0EoeHNqk1GNV32Rrq
         MI2w==
X-Gm-Message-State: AOAM531Z4jKozAmjNorey/UV0706YymjtBEdLcujxYYjLh0bY3AukO2g
        VjrhhipAEJoP74yj7/jJlSPpS9Qa1q26NvQovuXdoBPO+vjS+rMzS/x5rKUWNE1hR8wBK+Ra8Go
        pvSZPp5vrjZNb
X-Received: by 2002:a17:906:c14f:: with SMTP id dp15mr53895103ejc.267.1641575051124;
        Fri, 07 Jan 2022 09:04:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwxiOmqafaff21rmaGP9L/GaY7kp3AdC2ZyQUvS3e0/4WFekTuNB6HGGiXRl6CWI39JR+XUKw==
X-Received: by 2002:a17:906:c14f:: with SMTP id dp15mr53895091ejc.267.1641575050958;
        Fri, 07 Jan 2022 09:04:10 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id p4sm1559114eju.98.2022.01.07.09.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 09:04:10 -0800 (PST)
Message-ID: <f070a443-9763-a62f-38ef-3398fa942465@redhat.com>
Date:   Fri, 7 Jan 2022 18:04:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2] KVM: x86: Check for rmaps allocation
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>
Cc:     Nikunj A Dadhania <nikunj@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, vasant.hegde@amd.com,
        brijesh.singh@amd.com
References: <20220105040337.4234-1-nikunj@amd.com>
 <YdVfvp2Pw6JUR61K@xz-m1.local> <Ydhx1qguxVZxOGfo@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ydhx1qguxVZxOGfo@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/22 18:01, Sean Christopherson wrote:
> On Wed, Jan 05, 2022, Peter Xu wrote:
>> On Wed, Jan 05, 2022 at 09:33:37AM +0530, Nikunj A Dadhania wrote:
>>> With TDP MMU being the default now, access to mmu_rmaps_stat debugfs
>>> file causes following oops:
>>>
>>> BUG: kernel NULL pointer dereference, address: 0000000000000000
>>> PGD 0 P4D 0
>>> Oops: 0000 [#1] PREEMPT SMP NOPTI
>>> CPU: 7 PID: 3185 Comm: cat Not tainted 5.16.0-rc4+ #204
>>> RIP: 0010:pte_list_count+0x6/0x40
>>>   Call Trace:
>>>    <TASK>
>>>    ? kvm_mmu_rmaps_stat_show+0x15e/0x320
>>>    seq_read_iter+0x126/0x4b0
>>>    ? aa_file_perm+0x124/0x490
>>>    seq_read+0xf5/0x140
>>>    full_proxy_read+0x5c/0x80
>>>    vfs_read+0x9f/0x1a0
>>>    ksys_read+0x67/0xe0
>>>    __x64_sys_read+0x19/0x20
>>>    do_syscall_64+0x3b/0xc0
>>>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>   RIP: 0033:0x7fca6fc13912
>>>
>>> Return early when rmaps are not present.
>>>
>>> Reported-by: Vasant Hegde <vasant.hegde@amd.com>
>>> Tested-by: Vasant Hegde <vasant.hegde@amd.com>
>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>> ---
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 

Queued, thanks.

Paolo

