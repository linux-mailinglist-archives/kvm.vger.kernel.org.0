Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944572FF5B3
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 21:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbhAUUTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 15:19:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46564 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726587AbhAUUTO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 15:19:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611260257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VohorfWzk+8yRDGlB2g34QP+eQheRXpXwnsYx6YP7js=;
        b=bsZCG6AG5++N5s0SAOZ2yQlSyz+Zfk+fWJxCm9gioznPKPxUS6oUAfMKs4sXJkecDJus1N
        LpkTWZwsCeiVV1584Ik3r3/o00HY9M0FYg3mGIXTWVyaEFdZcHHZgxZtblKfgK4jgvii5R
        TV+fG3GGmafJflVY+0Qmw0ppdoKM7ag=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-Rp29qegYOruW-7vCHt8b5Q-1; Thu, 21 Jan 2021 15:17:35 -0500
X-MC-Unique: Rp29qegYOruW-7vCHt8b5Q-1
Received: by mail-wr1-f70.google.com with SMTP id q2so1811627wrp.4
        for <kvm@vger.kernel.org>; Thu, 21 Jan 2021 12:17:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VohorfWzk+8yRDGlB2g34QP+eQheRXpXwnsYx6YP7js=;
        b=IRSfGnMxnQ1X25YnpUxGVW8ZZ7IHc+xgS3t976BTZetVWnoWfx/pHZH0tO9v3uv0x8
         Ok5Zw3sYUdl9gehmMrVloMZcOfokOFW3F7BoFX55Fer1zsXnidyyx+aTzHsuDor5GiQp
         TMdUhqAav5t/sSE9ZolEin8kNfm2g91N9zAj1e57znhvBA9LLqGfgw14bjSC6IGkjXj5
         NnUtt2ErGqDTdJKUxSW4iGI4/memEozjVslH80DfoQ4m37SAxE8XqO5q+vah4FDVIytL
         k+kIUD6/f5vlujmMmeYKMCpHyTMQKKhwQWunAhtHRf77Ss0NBKw/+iRXmpKWjSKSzfue
         X6bQ==
X-Gm-Message-State: AOAM533Li7fjGKgpC4AES7ynebuP4wUR6ZYWQ6dYHHxXweKRi2gNn04R
        0vD7n8AAbzbeqPxNkvlPBMEzcWU8aEw+2tkstZFhpeqIMP4+AQFV6xIaXe2A4fb7GgtrN2kZrEi
        sdEI1yKyM+EWh
X-Received: by 2002:adf:dc8d:: with SMTP id r13mr1089274wrj.325.1611260254006;
        Thu, 21 Jan 2021 12:17:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy7UUFXpIhrtay7ZHpDKjdSukAnA/VRU8c2t13/MOt/RngEZ928SqFHJITIawpWdsFo5CF46g==
X-Received: by 2002:adf:dc8d:: with SMTP id r13mr1089258wrj.325.1611260253835;
        Thu, 21 Jan 2021 12:17:33 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c16sm9481816wrx.51.2021.01.21.12.17.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 12:17:32 -0800 (PST)
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Will Deacon <will@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-16-bgardon@google.com> <YAjIddUuw/SZ+7ut@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 15/24] kvm: mmu: Wrap mmu_lock cond_resched and needbreak
Message-ID: <82c4d5da-2a28-558c-5e17-d837005b8d76@redhat.com>
Date:   Thu, 21 Jan 2021 21:17:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YAjIddUuw/SZ+7ut@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/21 01:19, Sean Christopherson wrote:
> IMO, moving the lock to arch-specific code is bad for KVM. The 
> architectures' MMUs already diverge pretty horribly, and once things 
> diverge it's really hard to go the other direction. And this change, 
> along with all of the wrappers, thrash a lot of code and add a fair 
> amount of indirection without any real benefit to the other 
> architectures. What if we simply make the common mmu_lock a union? The 
> rwlock_t is probably a bit bigger, but that's a few bytes for an entire 
> VM. And maybe this would entice/inspire other architectures to move to a 
> similar MMU model.
I agree.  Most architectures don't do the lockless tricks that x86 do, 
and being able to lock for read would be better than nothing.  For 
example, I took a look at ARM and stage2_update_leaf_attrs could be 
changed to operate in cmpxchg-like style while holding the rwlock for read.

Paolo

> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f3b1013fb22c..bbc8efd4af62 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -451,7 +451,10 @@ struct kvm_memslots {
>  };
> 
>  struct kvm {
> -       spinlock_t mmu_lock;
> +       union {
> +               rwlock_t mmu_rwlock;
> +               spinlock_t mmu_lock;
> +       };
>         struct mutex slots_lock;
>         struct mm_struct *mm; /* userspace tied to this vm */
>         struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];

