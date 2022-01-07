Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E72487ADF
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 18:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348423AbiAGRDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 12:03:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33030 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240297AbiAGRDG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 12:03:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641574985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eOMl7Din8scPcX4i9u0nmf8/CJIoSqLDwGlSdjGTQSg=;
        b=QhZTwfF4KkqISjE5YnkZwli0nGcg82d5Rf/2KGzJWaLhuBzlux5+8HalUNL2VGXy5xBGu4
        n+vfTfRu0AAVDYnovV1r5BUUy0eROAl32Urvydr3jHMtCQsjH8sm/W9p7yC1tlETzLmHMq
        UpCdD2GH7hNI9sN9mOHzw9BWJg/mPHk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-gtDyqoHSOgutToEvDtns9Q-1; Fri, 07 Jan 2022 12:03:04 -0500
X-MC-Unique: gtDyqoHSOgutToEvDtns9Q-1
Received: by mail-ed1-f70.google.com with SMTP id z8-20020a056402274800b003f8580bfb99so5160769edd.11
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 09:03:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eOMl7Din8scPcX4i9u0nmf8/CJIoSqLDwGlSdjGTQSg=;
        b=bUtUOR/nQhXyTg75VL9JvFqRoPtjJ9ZhkmudMm+g3Jud9amP15nZV2q/ppF/H5/z3A
         kc/No7x6IT/MaT6qjkBN8je5btwMTUOBN0e27pf1s5r0NyqoOsFo6NHrcmNRqhC+LAwh
         mRBamPoQV/6SkQsQbnIiDCh/ZLfFB1UncA55iGnK65RYdHQjBr89sW4K6wtpWmWgzsfj
         Q1MWliAeq4QnlzSF+TS7hSHZuSp2gzQ8qKDbPXwg6lJNtX8axA5ieET60625X3l811fu
         QLufnoYpJOMZTicv2ZCwO6myc9s1Wdwo9nfRfetdheJ0FFimpB99geFZMQIBvQfAqYIB
         nZow==
X-Gm-Message-State: AOAM532lEa5uPMrVI5BjI2xrDaN0dh4pihrXFsy5GBfiJ5IPFGqgFrJR
        rWtPWB5RJ9moF1pJPIaRrwy2hynsk4hWw8Rl5Re9UIOWkfwDtsUSB1sFofRhbKhK6GGyePRYAfn
        Breu2Z/ciQOUB
X-Received: by 2002:a05:6402:35cc:: with SMTP id z12mr62033464edc.285.1641574983161;
        Fri, 07 Jan 2022 09:03:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFr7eF3bZsfEIhy3BEr7y+EXMk7etp5+RuYoUF63kUUZgZhCPb9+2w4VCnRkIWLMyXOYfHVA==
X-Received: by 2002:a05:6402:35cc:: with SMTP id z12mr62033433edc.285.1641574982959;
        Fri, 07 Jan 2022 09:03:02 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id c19sm2322987ede.62.2022.01.07.09.03.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 09:03:01 -0800 (PST)
Message-ID: <19241e3d-f7eb-2b7f-046e-6a004a2225de@redhat.com>
Date:   Fri, 7 Jan 2022 18:03:00 +0100
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

paolo

