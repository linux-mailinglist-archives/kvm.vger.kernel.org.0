Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43180350995
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 23:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhCaVgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 17:36:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24973 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229662AbhCaVfn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 31 Mar 2021 17:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617226542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QQUIznWNci7QLnwuJm69/wWy4z3NEw65AzCUXnTQPwI=;
        b=B0t700AwuWfk00HLBYsci5Cw25mSrM6nxdaYPYLNBlYc6cZSCq7r3+SIFALdkG/HjLewUH
        AypAYgl+7i+1fE8te8y2RnriywZRo5I04C6XQKGmBR4ZWa8uhPrTJ6Bou+ViC2VxLuhSKk
        ZvsRLkUj7u2JZ0zxJRUjHkVrKb/GBzU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-DnSp12fIOQqGG3TKW3OxOA-1; Wed, 31 Mar 2021 17:35:40 -0400
X-MC-Unique: DnSp12fIOQqGG3TKW3OxOA-1
Received: by mail-ej1-f69.google.com with SMTP id e13so1375890ejd.21
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:35:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QQUIznWNci7QLnwuJm69/wWy4z3NEw65AzCUXnTQPwI=;
        b=iH88ZSqOZRZ64PG6HVDBeToHPX2T3Q6k9aW+z4qULbPKfkVXO9EexdMZ7eQUsyrMiR
         6lo7lE5pl3+tDe68Cf5SWEzWLU8kb/RktSeZkBdM8fAVrzdO0wZX0AhhMNP0OfQ0rEDT
         PKqL2zJOeHgX8VYz+6o1RolO6I2Bs36z/xafPrUTXKvijrc6kdzBsIH4sxgqCXos+u6O
         95uRiV+9BPIsYlPCnfQWSwXgd3JAZFTEFNF8KMtC/vrComnPd5r2Kxl1Ie00Y8CLYhDG
         zWylgpHtCpXbrp6E7v1O/1451UzGFcA2cTYSEE/CEwyJ/hFbI+Ii/Cvyg5eFndtPp0xC
         2e4Q==
X-Gm-Message-State: AOAM533u7YKECy/3Ztt7hmg1tFcyAK+JwygcI5jUiSJLlIicsldf6Dm2
        cE0CyX1Ziny+ZM/Gty1cPwdCJwz6zM+rl617x9zZv0eUJqwKBnWJKgBzP0oKKW4+oY1wN4JHYl5
        nKC+VDXhV/dTU
X-Received: by 2002:a17:906:4d18:: with SMTP id r24mr5674543eju.493.1617226539406;
        Wed, 31 Mar 2021 14:35:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqLuIZRAxqmNZY+xbCQNtWOLNhNwqjzyhv1KwZdcnD5ToTgWvG1r7yCpG0AD5klE6UQn/quw==
X-Received: by 2002:a17:906:4d18:: with SMTP id r24mr5674529eju.493.1617226539171;
        Wed, 31 Mar 2021 14:35:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h22sm1846899eji.80.2021.03.31.14.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 14:35:38 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGSmMeSOPcjxRwf6@google.com>
 <56ea69fe-87b0-154b-e286-efce9233864e@redhat.com>
 <YGTRzf/4i9Y8XR2c@google.com>
 <0e30625f-934d-9084-e293-cb3bcbc9e4b8@redhat.com>
 <YGTkLMAzk88wOiZm@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <345ab567-386f-9080-f9cb-0e17fa90a852@redhat.com>
Date:   Wed, 31 Mar 2021 23:35:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YGTkLMAzk88wOiZm@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/03/21 23:05, Sean Christopherson wrote:
>> Wouldn't it be incorrect to lock a mutex (e.g. inside*another*  MMU
>> notifier's invalidate callback) while holding an rwlock_t?  That makes sense
>> because anybody that's busy waiting in write_lock potentially cannot be
>> preempted until the other task gets the mutex.  This is a potential
>> deadlock.
>
> Yes?  I don't think I follow your point though.  Nesting a spinlock or rwlock
> inside a rwlock is ok, so long as the locks are always taken in the same order,
> i.e. it's never mmu_lock -> mmu_notifier_slots_lock.

*Another* MMU notifier could nest a mutex inside KVM's rwlock.

But... is it correct that the MMU notifier invalidate callbacks are 
always called with the mmap_sem taken (sometimes for reading, e.g. 
try_to_merge_with_ksm_page->try_to_merge_one_page->write_protect_page)? 
  We could take it temporarily in install_memslots, since the MMU 
notifier's mm is stored in kvm->mm.

In this case, a pair of kvm_mmu_notifier_lock/unlock functions would be 
the best way to abstract it.

Paolo

