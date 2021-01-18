Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5752F9C9E
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 11:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389430AbhARKCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 05:02:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46386 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389361AbhARJyE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 04:54:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610963544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZAX3YbKeUxQVZkX6i2+BSlo13++SxbH40mmS2u31NFw=;
        b=F91+b9cViYPliyPk3nqjYDDDpFfJAt1AASX8vSucm/ktGEiLCV9fslxNkz4Hferzk8NnG7
        aQmAHLyyqB/ibgTFS2fSF7m5FK6tCm760l/Ab3v/EOiDHc6Kse3PozsD8F8ujNq0LM49NX
        Ea9GWmSbVWcvgWqSIj2cGQgl42SWKr4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-VzL9I39dN7OoL35C2VzqlA-1; Mon, 18 Jan 2021 04:52:22 -0500
X-MC-Unique: VzL9I39dN7OoL35C2VzqlA-1
Received: by mail-ed1-f72.google.com with SMTP id o19so960503edq.9
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 01:52:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZAX3YbKeUxQVZkX6i2+BSlo13++SxbH40mmS2u31NFw=;
        b=Faf6Ah8f/VIgyPdUhGSW3VqFICOzdeNIEr6WxvRyfh/W+bR4Y7n5ChixZnWn3AH3Kz
         S/8148A7B3aBIOLTPSaDXdobM6Cm88/0fSldBWaZml08O62mDTluL6QAbS+EZXRoWeWF
         vq0grXeeBSZE3vLJndKOJzbOuaJAyGg7fPIRvxCMdMxXe5c8dT52A6UNAI+lZUTQStdX
         b8NK1dB9bT1FGmUk3Bq+1D2/8Ax0oLVFUjg1m2ByPv1Vxpm/N5Fjl9voMUaN7++spi/S
         DAaUqm4mGUmzlSoWnDZggzTDQW/5fEi4UaFuzGn9UwA2qQO0VC9i+ozU5vZBKfefOd+x
         qMMA==
X-Gm-Message-State: AOAM530a4zxYlAHJC/4U+l2+0E6kQFnSJt+Lry+w0CxyFMmHEimzLg/+
        fEdtc0cbW1lkd+S9flthFPuu/DfW1P0okPEIE7/XzCpd/zvPymA/LtqxSF7mOgaJcMqeYk8ZJet
        cYNRZ5locormP
X-Received: by 2002:a17:906:8611:: with SMTP id o17mr5700748ejx.145.1610963541206;
        Mon, 18 Jan 2021 01:52:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzHzj2+iZ193bUiIFdT2OniXhp07Jv68wbRBuelX9gQ7IfLnFbp08IRJ6mEV5plx/jd0JT/Dw==
X-Received: by 2002:a17:906:8611:: with SMTP id o17mr5700738ejx.145.1610963541010;
        Mon, 18 Jan 2021 01:52:21 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a10sm392188ejk.75.2021.01.18.01.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 01:52:20 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 3/4] KVM: Define KVM_USER_MEM_SLOTS in arch-neutral
 include/linux/kvm_host.h
In-Reply-To: <YAHLRVhevn7adhAz@google.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
 <20210115131844.468982-4-vkuznets@redhat.com>
 <YAHLRVhevn7adhAz@google.com>
Date:   Mon, 18 Jan 2021 10:52:19 +0100
Message-ID: <87wnwa608c.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jan 15, 2021, Vitaly Kuznetsov wrote:
>> Memory slots are allocated dynamically when added so the only real
>> limitation in KVM is 'id_to_index' array which is 'short'. Define
>> KVM_USER_MEM_SLOTS to the maximum possible value in the arch-neutral
>> include/linux/kvm_host.h, architectures can still overtide the setting
>> if needed.
>
> Leaving the max number of slots nearly unbounded is probably a bad idea.  If my
> math is not completely wrong, this would let userspace allocate 6mb of kernel
> memory per VM.  Actually, worst case scenario would be 12mb since modifying
> memslots temporarily has two allocations.

Yea I had thought too but on the other hand, if your VMM went rogue and
and is trying to eat all your memory, how is allocating 32k memslots
different from e.g. creating 64 VMs with 512 slots each? We use
GFP_KERNEL_ACCOUNT to allocate memslots (and other per-VM stuff) so
e.g. cgroup limits should work ...

>
> If we remove the arbitrary limit, maybe replace it with a module param with a
> sane default?

This can be a good solution indeed. The only question then is what should
we pick as the default? It seems to me this can be KVM_MAX_VCPUS
dependent, e.g. 4 x KVM_MAX_VCPUS would suffice.

>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  include/linux/kvm_host.h | 4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index f3b1013fb22c..ab83a20a52ca 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -425,6 +425,10 @@ struct kvm_irq_routing_table {
>>  #define KVM_PRIVATE_MEM_SLOTS 0
>>  #endif
>>  
>> +#ifndef KVM_USER_MEM_SLOTS
>> +#define KVM_USER_MEM_SLOTS (SHRT_MAX - KVM_PRIVATE_MEM_SLOTS)
>> +#endif
>> +
>>  #ifndef KVM_MEM_SLOTS_NUM
>>  #define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
>>  #endif
>> -- 
>> 2.29.2
>> 
>

-- 
Vitaly

