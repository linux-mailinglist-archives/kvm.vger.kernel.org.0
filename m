Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C076833EEE7
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 11:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhCQKzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 06:55:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55640 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230319AbhCQKzF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 06:55:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615978504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I0iQk6VEOom/eWob3kLIdsJKi0P3emqz/ktzR7mzDu0=;
        b=QNsShnfiYMwyrVWapsPlbmR/XZPodsmkHHV0oI4bu2iFAvjniTjhv7D06KcGrn3SJWgtll
        B7+d92aDuyJpV3UzIIh8u2uGhq81QEe9bbcnDPKLBHpjTAgYRQh6pKEitjFAHch1gqd9st
        HAoWnLn3zdKaEK1MPON+DtD5Xpve2ng=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-s8We_EiNNbSBpFnWbaXHHg-1; Wed, 17 Mar 2021 06:55:03 -0400
X-MC-Unique: s8We_EiNNbSBpFnWbaXHHg-1
Received: by mail-ed1-f69.google.com with SMTP id i6so19247295edq.12
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 03:55:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I0iQk6VEOom/eWob3kLIdsJKi0P3emqz/ktzR7mzDu0=;
        b=ngIxyklFWCEeDTrJFR9YVwnIOZ9VWld7bskpMSWc1w2Kxkxu7alQr3HdD98DyhGpfp
         d9KVCyfp1oIpgjYn3TVx9Iz019ltbEZmf9GzZ0ccPSUUapECC2JSX0Bpd40U/TnvIN5/
         eJ7bFW0DxFCUFzLMmpD+UeghP+QBpZg1ExN44yjw/RtcV29Q+VCYTAKlJNbs9q0e/4XB
         Ja90kVuA2ZTravoBI0R6U2UuU9/1UhjyaKABE7uImyDYe/QOGXt843WY4KzRf48DgHo6
         F/zmssHxVypXFfKAaHlsgyAs/Mo68VL6qW8Lw8niwTFsN2mCyTi3vajOdL/1CPAFckg/
         a5Tw==
X-Gm-Message-State: AOAM532j1UqJowgpbzNcOv4rgtgJcEkQDLKKr1ATEruvCYihjtQnVexs
        JdldisKGjwQH84qxxH14l3I8JWWGT6bjDF7+pxiCh2SBEx+JVcKizaLaIgRF7+wr3RoRyPtvSmk
        zDmbvasSixoCN
X-Received: by 2002:a17:906:a0d4:: with SMTP id bh20mr2929705ejb.348.1615978502068;
        Wed, 17 Mar 2021 03:55:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+kyFZnmJb0l4PG4SXpwlc3jFPbkz+a4nfWrVz111dda3+5+tVo3sQJRINh98la4e0BrJK0Q==
X-Received: by 2002:a17:906:a0d4:: with SMTP id bh20mr2929698ejb.348.1615978501946;
        Wed, 17 Mar 2021 03:55:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ho11sm10682614ejc.112.2021.03.17.03.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 03:55:01 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm: memcg awareness
To:     Marc Zyngier <maz@kernel.org>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Shakeel Butt <shakeelb@google.com>
References: <1615959984-7122-1-git-send-email-wanpengli@tencent.com>
 <87mtv2i1s3.wl-maz@kernel.org>
 <e5fce698-9e21-5c71-c99b-a9af3f213e8f@redhat.com>
 <87im5qhwzx.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <21d1f531-fe95-224d-0dac-6917d473063d@redhat.com>
Date:   Wed, 17 Mar 2021 11:55:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <87im5qhwzx.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/21 11:53, Marc Zyngier wrote:
> On Wed, 17 Mar 2021 10:40:23 +0000,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 17/03/21 10:10, Marc Zyngier wrote:
>>>> @@ -366,7 +366,7 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>>>>    	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
>>>>    		return -EINVAL;
>>>>    -	childp = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL);
>>>> +	childp = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>>> No, this is wrong.
>>>
>>> You cannot account the hypervisor page tables to the guest because we
>>> don't ever unmap them, and that we can't distinguish two data
>>> structures from two different VMs occupying the same page.
>>
>> If you never unmap them, there should at least be a shrinker to get
>> rid of unused pages in the event of memory pressure.
> 
> We don't track where these pages are coming from or whether they can
> safely be unmapped. Until we can track such ownership and deal with
> page sharing, these mappings have to stay,
> 
> At most, this represent the amount of memory required to map the whole
> of the linear mapping.

Ah, these are the EL2 pages, not the stage2 page tables, right?  If so, 
sorry for the noise.

Paolo

