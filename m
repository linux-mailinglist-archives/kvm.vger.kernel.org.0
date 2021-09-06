Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F02B4019B3
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 12:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241931AbhIFKWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 06:22:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241852AbhIFKWv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 06:22:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630923706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6I/+jwkS4G/jaKLYt0NFvHjgSx5PJZJIsHfHPHUbyAg=;
        b=B9ztA6Ig9/qQ3wUZoU7FFFqL8fGKtW7fMy3eeNOhOfOa/A4r0O1dWN0EWZxYfB9BZuKRTf
        ch1/9q3y5Ph6KJzSmwRbFAe8+jL0dtNZxiEO17s3kCTAHlyuJbpivNlXEPUjLZt/pu82/6
        itDZwOwjSuNw6E6lWhj+YywzLHuErgU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-BScmMlU5NsurnJilUCeQbA-1; Mon, 06 Sep 2021 06:21:45 -0400
X-MC-Unique: BScmMlU5NsurnJilUCeQbA-1
Received: by mail-ej1-f70.google.com with SMTP id bi9-20020a170906a24900b005c74b30ff24so2138719ejb.5
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 03:21:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6I/+jwkS4G/jaKLYt0NFvHjgSx5PJZJIsHfHPHUbyAg=;
        b=bGnhKCwn63e17TIrU8MlIzn/IKWnVvWd7bUeyCw2NzPcBCXVRQfDi9Ubcqc9MopJJ4
         K5gFc4FOjJa47FJzE7dqYoAztrj+gOBSgeeMipdzcXwkyFgGoLs1Naq56Erh5Hx095Rn
         BBAcBP/bTb3mLKlBgscGXuEcaEN4/QUfWhNDL2YD3X5Qk7l+hN6/kZW1kL6gKNpYGLuT
         UZNw9sTDQfDpCxP588SVXHR+CNlvw9WIlh4J7X3UgX/pxow6PndhzG7VV9aVYKopxTX+
         cfMYJVlhWSZdSzAZLeEhc5aAvXl7McNvWgMaOs68ogep/yfxT5HL7WQx75JPfKwilMHE
         meng==
X-Gm-Message-State: AOAM530fcMUcjTB+icBHvPcVsHV1R9+iZ+ls1qFhQLiEsexG8wfCjmHk
        YB5hQVF+kHE+HCP8j9j2K1jal72D5ntau8AH8OhWUIvwm6CjjbWlxgYP6B8zUnG8Q+IadXDoYpK
        BEINXSPE3GMR2
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr12682604ejc.69.1630923703989;
        Mon, 06 Sep 2021 03:21:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIfg38qh5MAYI2aL/o0JVdU/uV5GNkIIo8KH69KQ+gmjTcd3VL5L5ABWRZT4YQzrSiru1xPw==
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr12682591ejc.69.1630923703795;
        Mon, 06 Sep 2021 03:21:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s23sm4327693eds.12.2021.09.06.03.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 03:21:43 -0700 (PDT)
Subject: Re: [PATCH] KVM: Remove unnecessary export of
 kvm_{inc,dec}_notifier_count()
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210902175951.1387989-1-seanjc@google.com>
 <f539e833bd7da4800612f8ae4bdffcb1db2f8684.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <79dcce75-802d-5193-6200-c52f3b1ff90d@redhat.com>
Date:   Mon, 6 Sep 2021 12:21:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <f539e833bd7da4800612f8ae4bdffcb1db2f8684.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/09/21 09:12, Maxim Levitsky wrote:
> On Thu, 2021-09-02 at 10:59 -0700, Sean Christopherson wrote:
>> Don't export KVM's MMU notifier count helpers, under no circumstance
>> should any downstream module, including x86's vendor code, have a
>> legitimate reason to piggyback KVM's MMU notifier logic.  E.g in the x86
>> case, only KVM's MMU should be elevating the notifier count, and that
>> code is always built into the core kvm.ko module.
>>
>> Fixes: edb298c663fc ("KVM: x86/mmu: bump mmu notifier count in kvm_zap_gfn_range")
>> Cc: Maxim Levitsky <mlevitsk@redhat.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   virt/kvm/kvm_main.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 3e67c93ca403..140c7d311021 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -638,7 +638,6 @@ void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
>>   			max(kvm->mmu_notifier_range_end, end);
>>   	}
>>   }
>> -EXPORT_SYMBOL_GPL(kvm_inc_notifier_count);
>>   
>>   static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>>   					const struct mmu_notifier_range *range)
>> @@ -690,8 +689,6 @@ void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
>>   	 */
>>   	kvm->mmu_notifier_count--;
>>   }
>> -EXPORT_SYMBOL_GPL(kvm_dec_notifier_count);
>> -
>>   
>>   static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
>>   					const struct mmu_notifier_range *range)
> 
> Ah, I somehow thought when I wrote this that those two will be used by kvm_amd.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Best regards,
> 	Maxim Levitsky
> 

Queued, thanks.

Paolo

