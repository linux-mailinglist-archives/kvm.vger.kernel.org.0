Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06EF492183
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 09:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344818AbiARIoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 03:44:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42020 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229943AbiARIoQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 03:44:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642495455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZTb5A3HHYcL7QYMP1DncJCS6Mg4uIaaBO9xs0b1g8Ck=;
        b=RMUAYXDluKwRBsszpeQQw3LmAqxC76zzjAU1Z6eel2OVMHdDCvjIAijaGgiKbx5mA7g1Yb
        QfoiAklEOrOq346DEy4KyoJ6u9E8LIx4jJJ74mgm2FgnOUZDUdr6gn814vyw8TAPBTBcHw
        Zx29QwxLmHEu24iFfBnl+zDI2Z640Cg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-94-TYrhtOLnPGCxB9MJ2cln8A-1; Tue, 18 Jan 2022 03:44:14 -0500
X-MC-Unique: TYrhtOLnPGCxB9MJ2cln8A-1
Received: by mail-wm1-f70.google.com with SMTP id ay11-20020a05600c1e0b00b0034afc66f1fbso1275008wmb.9
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 00:44:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZTb5A3HHYcL7QYMP1DncJCS6Mg4uIaaBO9xs0b1g8Ck=;
        b=U1qb+krfiq6fESm3kH4Jc8frsB8yKmSoXLwPEf5JX64F+ViN6DiiwozW1GUUNVATAU
         kUp453EN3/syGAD7chnMjhAZ5rNmSGByMTC4f0USw3RLcvXvDNNts1YzUue4pVm3cImy
         58DUZJETF5YDvguS4TzocccJdVnMluUgaJQMpRV1M7wR8rettkbPOST1lMhiow7uuaih
         r4/EdCAI9OhzPyg9l4pz3wZmVFxqdMSfwIgDjdsi9at3KJi9PUYTsgF8GGcQIrD9kB9m
         brzlZGMcIZ762RVBa+rxRbgxcFtw06SP27j3j3sTuqwSe8oubftiLEoAtLUEns8XKhmQ
         xGCQ==
X-Gm-Message-State: AOAM532riVWlnXYz97Q7+l+obEH47rX2mWgPKqqEI+SJJlOyt9C8cIHg
        DhjDmDCJmaNe/b1cvVy7TZ7kULR8V4CUCZ3iQzdeN/I4cyPMcdl55XB/z9HapcemUBUMMtQiEyH
        hXbblPqRFzn/R
X-Received: by 2002:adf:f287:: with SMTP id k7mr23717205wro.417.1642495453014;
        Tue, 18 Jan 2022 00:44:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwsEzNoEoc0eFP+TA8V5x9IFLr/G4qA07meB3SE7UDlgrs0z3BBio1q/NSa5JHE1ZldCfj0zQ==
X-Received: by 2002:adf:f287:: with SMTP id k7mr23717186wro.417.1642495452833;
        Tue, 18 Jan 2022 00:44:12 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id n15sm14269604wrf.79.2022.01.18.00.44.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 00:44:12 -0800 (PST)
Message-ID: <14380a1b-669f-8f0f-139b-7c89fabd4276@redhat.com>
Date:   Tue, 18 Jan 2022 09:44:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: avoid warning on s390 in mark_page_dirty
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        dwmw2@infradead.org
Cc:     butterflyhuangxx@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <e9e5521d-21e5-8f6f-902c-17b0516b9839@redhat.com>
 <20220113122924.740496-1-borntraeger@linux.ibm.com>
 <eda019b1-8e1d-5d2b-4be4-2725e5814b23@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <eda019b1-8e1d-5d2b-4be4-2725e5814b23@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 09:37, Christian Borntraeger wrote:
> Am 13.01.22 um 13:29 schrieb Christian Borntraeger:
>> Avoid warnings on s390 like
>> [ 1801.980931] CPU: 12 PID: 117600 Comm: kworker/12:0 Tainted: 
>> G            E     
>> 5.17.0-20220113.rc0.git0.32ce2abb03cf.300.fc35.s390x+next #1
>> [ 1801.980938] Workqueue: events irqfd_inject [kvm]
>> [...]
>> [ 1801.981057] Call Trace:
>> [ 1801.981060]  [<000003ff805f0f5c>] mark_page_dirty_in_slot+0xa4/0xb0 
>> [kvm]
>> [ 1801.981083]  [<000003ff8060e9fe>] adapter_indicators_set+0xde/0x268 
>> [kvm]
>> [ 1801.981104]  [<000003ff80613c24>] set_adapter_int+0x64/0xd8 [kvm]
>> [ 1801.981124]  [<000003ff805fb9aa>] kvm_set_irq+0xc2/0x130 [kvm]
>> [ 1801.981144]  [<000003ff805f8d86>] irqfd_inject+0x76/0xa0 [kvm]
>> [ 1801.981164]  [<0000000175e56906>] process_one_work+0x1fe/0x470
>> [ 1801.981173]  [<0000000175e570a4>] worker_thread+0x64/0x498
>> [ 1801.981176]  [<0000000175e5ef2c>] kthread+0x10c/0x110
>> [ 1801.981180]  [<0000000175de73c8>] __ret_from_fork+0x40/0x58
>> [ 1801.981185]  [<000000017698440a>] ret_from_fork+0xa/0x40
>>
>> when writing to a guest from an irqfd worker as long as we do not have
>> the dirty ring.
>>
>> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>> ---
>>   virt/kvm/kvm_main.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 504158f0e131..1a682d3e106d 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -3163,8 +3163,10 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>>   {
>>       struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>> +#ifdef CONFIG_HAVE_KVM_DIRTY_RING
>>       if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
>>           return;
>> +#endif
>>       if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
>>           unsigned long rel_gfn = gfn - memslot->base_gfn;
> 
> Paolo, are you going to pick this for next for the time being?
> 

Yep, done now.

Paolo

