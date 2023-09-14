Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B2E7A001F
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbjINJfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236069AbjINJfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:35:05 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E63BB;
        Thu, 14 Sep 2023 02:35:00 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-52a40cf952dso821767a12.2;
        Thu, 14 Sep 2023 02:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694684099; x=1695288899; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mGMJ2iw6HfVRandtutdOtre56VxjaGvyNMWupEbmx7E=;
        b=UhllUjFqQXzuBUkm16cKLNWUsc/AqMBB+cHOEz6ZWV1zMdQyftw13k15qO4c1AXwDe
         AljLhseTeBq20HJwwytwRbVJYAMukP8uY1D7AQHKcO4vfugqfo60uDMNVvofINgEaMjO
         oTG+ns9IB8LnlkJCHKey33ZDBlRfMenGjuvUQ/X32mYaqfp99288qLEqA2NsWNB/NfnW
         s1M9flV+A6QJ16ySjuzK6pR7I8qp7sesWlqgEAXhhY98bEwfPzkvxHMeuB2DOHPXrj9a
         jxE+pV7TxL71BkmOeObGUtNo7rWoiTzbDsohqa8ZDxPt5Pp45KUVcQjtm+RWHOBhum4t
         qnVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694684099; x=1695288899;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mGMJ2iw6HfVRandtutdOtre56VxjaGvyNMWupEbmx7E=;
        b=NgIUOotZIp5sQed1MVHxS6HvUr97pR13OTBylHGdHy0oNYFqhz4xrm3ROPo2AOj7aR
         7HF9UC3ScGvZKCK48YNvkahlHjdJ/i/smof3XJHiOTVy6MgESxsAAXwE+c6Iw48K1vjA
         z5dabBDu7DBg8UVP6Po8FdqrDsrM6dmbYBOpTQwIak5WFxg1aKSLE8D+cjDyi7ccrTq9
         6NxYu6L3+2/e8A9KQBvOwhqWHse8zgxognLk30q8i4ucmxua/v4O2qiWyfhjP/VMVZCv
         lWvKm5i4vOEdEBET6lFJ9GO5+Yykci7W8GrOQXmHAWXVomtYUUFBox47NFsgCc+z/1Ug
         Worg==
X-Gm-Message-State: AOJu0YwO5hUAq6XmoFhEGXI5TCR6ih5jWaiDSWYrDbdf+BB5Sr55s+fk
        op/Rg7AUBPCSfueO0f+Osk0=
X-Google-Smtp-Source: AGHT+IEwzMfvMfBofukIKyVdizDf6WlLh26R/3RQVaQt3hq8FRkDAzru4G9D1QqZXcT7StdJxnh9Aw==
X-Received: by 2002:a17:907:2c54:b0:9aa:1e43:d0b9 with SMTP id hf20-20020a1709072c5400b009aa1e43d0b9mr4284062ejc.5.1694684098872;
        Thu, 14 Sep 2023 02:34:58 -0700 (PDT)
Received: from [192.168.6.126] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id h11-20020a170906854b00b0099ccee57ac2sm734959ejy.194.2023.09.14.02.34.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 02:34:58 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <69b2a8ae-fcae-75b8-4b2a-ca75bbd273f0@xen.org>
Date:   Thu, 14 Sep 2023 11:34:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Reply-To: paul@xen.org
Subject: Re: [PATCH 2/8] KVM: pfncache: add a mark-dirty helper
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
References: <20230914084946.200043-1-paul@xen.org>
 <20230914084946.200043-3-paul@xen.org>
 <87b3f6713a7c6aa57adc89b6c47be3e1511f66ca.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <87b3f6713a7c6aa57adc89b6c47be3e1511f66ca.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/2023 10:21, David Woodhouse wrote:
> On Thu, 2023-09-14 at 08:49 +0000, Paul Durrant wrote:
>> --- a/arch/x86/kvm/xen.c
>> +++ b/arch/x86/kvm/xen.c
>> @@ -430,14 +430,13 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
>>                  smp_wmb();
>>          }
>>   
>> -       if (user_len2)
>> +       if (user_len2) {
>> +               kvm_gpc_mark_dirty(gpc2);
>>                  read_unlock(&gpc2->lock);
>> +       }
>>   
>> +       kvm_gpc_mark_dirty(gpc1);
>>          read_unlock_irqrestore(&gpc1->lock, flags);
>> -
>> -       mark_page_dirty_in_slot(v->kvm, gpc1->memslot, gpc1->gpa >> PAGE_SHIFT);
>> -       if (user_len2)
>> -               mark_page_dirty_in_slot(v->kvm, gpc2->memslot, gpc2->gpa >> PAGE_SHIFT);
>>   }
>>   
>>   void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
> 
> ISTR there was a reason why the mark_page_dirty_in_slot() was called
> *after* unlocking. Although now I say it, that seems wrong... is that
> because the spinlock is only protecting the uHVA→kHVA mapping, while
> the memslot/gpa are going to remain valid even after unlock, because
> those are protected by sRCU?

Without the lock you could see an inconsistent GPA and memslot so I 
think you could theoretically calculate a bogus rel_gfn and walk off the 
end of the dirty bitmap. Hence moving the call inside the lock while I 
was in the neighbourhood seemed like a good idea. I could call it out in 
the commit comment if you'd like.

   Paul

