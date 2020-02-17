Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48EAE16186D
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 18:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgBQRCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 12:02:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27163 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726788AbgBQRCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 12:02:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581958952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LTLhp/XySgncTqhbXJWLE8j6Db6J/GYHmTmc6aeppi0=;
        b=UGHc1jCjn5OUaBjjMnq/okgZbmw+zk4vmeL9+nIghgpa5BICypSiH7bYiHaRJSBlU46mQd
        V8ibIJ0HEBmFkHCzBD/Q9M9YpA7OMVYeYluC8pXnM5iO39GSAnqpNixcGFRBkjIDX2sl2q
        kdxiU5EYubSYF5z1NDXyIcOvdFZWypc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-348UNk3pN_aj2qMfHHV1Pw-1; Mon, 17 Feb 2020 12:02:30 -0500
X-MC-Unique: 348UNk3pN_aj2qMfHHV1Pw-1
Received: by mail-wr1-f69.google.com with SMTP id j4so9239899wrs.13
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2020 09:02:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=LTLhp/XySgncTqhbXJWLE8j6Db6J/GYHmTmc6aeppi0=;
        b=ccq/zhupLq9HEjMi13eckh1IAbX0TrFjKKjHONuRyXVmA9r6DilG3/NeVJ/7aeA/wT
         J1t5C8UKk7PS1rJr6O3d0O4tBg8d1d07RXIGNGalq16YRACLD5sxiwmE9xitXPHNzkXX
         XYki+ZZPQuzddonRYm9or1pI9B6gcubMN/nUWv5slgZv/IGgsVry8wb+pgnKiIatOVby
         yBc18SCOrCw6/pj6WIW3qexH/0WjOyF6ZU4pSzzObHCdkpAMmnatUDyi7tXmQ4Xsqh5J
         0uo2ZXujr7Zf5ci/nX0noVto+u2H55inop1MHFHOOfEfzbbk2/ijSp1L20DqvfoqGU1b
         451A==
X-Gm-Message-State: APjAAAWoki1jeip4/NYJr8j9VCsuPzno96ixgUkHmFDQM74i7jr+SQN7
        NIMKRSZozge48ypTkUmB8TWXV5fv2SCJbG7zEbYC4gB7tLL1aW8Ltm0alTw4wIUWVoRsFjbDqCo
        8hGKO9HmcONkU
X-Received: by 2002:a05:600c:217:: with SMTP id 23mr13746wmi.124.1581958949334;
        Mon, 17 Feb 2020 09:02:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqwfY3yBAKQqpVX29xpVAGynUaOiw/rNs+FoKhmA06VZKtYmd9qlKU+Q7eq6SR2DhKzSa15CBQ==
X-Received: by 2002:a05:600c:217:: with SMTP id 23mr13718wmi.124.1581958949051;
        Mon, 17 Feb 2020 09:02:29 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q14sm1753448wrj.81.2020.02.17.09.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 09:02:28 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: apic: remove unused function apic_lvt_vector()
In-Reply-To: <2fb684de-30c1-ed67-600f-08168e64d6c7@oracle.com>
References: <1581561464-3893-1-git-send-email-linmiaohe@huawei.com> <2fb684de-30c1-ed67-600f-08168e64d6c7@oracle.com>
Date:   Mon, 17 Feb 2020 18:02:27 +0100
Message-ID: <87blpx9mfw.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Krish Sadhukhan <krish.sadhukhan@oracle.com> writes:

> On 2/12/20 6:37 PM, linmiaohe wrote:
>> From: Miaohe Lin <linmiaohe@huawei.com>
>>
>> The function apic_lvt_vector() is unused now, remove it.
>>
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>> ---
>>   arch/x86/kvm/lapic.c | 5 -----
>>   1 file changed, 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index eafc631d305c..0b563c280784 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -294,11 +294,6 @@ static inline int apic_lvt_enabled(struct kvm_lapic *apic, int lvt_type)
>>   	return !(kvm_lapic_get_reg(apic, lvt_type) & APIC_LVT_MASKED);
>>   }
>>   
>> -static inline int apic_lvt_vector(struct kvm_lapic *apic, int lvt_type)
>> -{
>> -	return kvm_lapic_get_reg(apic, lvt_type) & APIC_VECTOR_MASK;
>> -}
>> -
>>   static inline int apic_lvtt_oneshot(struct kvm_lapic *apic)
>>   {
>>   	return apic->lapic_timer.timer_mode == APIC_LVT_TIMER_ONESHOT;
>
> There is one place, lapic_timer_int_injected(), where this function be 
> used :
>
>          struct kvm_lapic *apic = vcpu->arch.apic;
> -       u32 reg = kvm_lapic_get_reg(apic, APIC_LVTT);
>
>          if (kvm_apic_hw_enabled(apic)) {
>
> -                int vec = reg & APIC_VECTOR_MASK;
>
> +               int vec = apic_lvt_vector(APIC_LVTT);
>                   void *bitmap = apic->regs + APIC_ISR;
>
>
> But since that's the only place I can find, we probably don't need a 
> separate function.
>

I like the alternative suggestion more than the original patch)

Also, apic_lvt_enabled() is only used once with APIC_LVTT as the second
argument so I'd suggest we also do:

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index afcd30d44cbb..d85463ff4a6f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -289,14 +289,14 @@ static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
        recalculate_apic_map(apic->vcpu->kvm);
 }
 
-static inline int apic_lvt_enabled(struct kvm_lapic *apic, int lvt_type)
+static inline int apic_lvtt_enabled(struct kvm_lapic *apic)
 {
-       return !(kvm_lapic_get_reg(apic, lvt_type) & APIC_LVT_MASKED);
+       return !(kvm_lapic_get_reg(apic, APIC_LVTT) & APIC_LVT_MASKED);
 }
 
-static inline int apic_lvt_vector(struct kvm_lapic *apic, int lvt_type)
+static inline int apic_lvtt_vector(struct kvm_lapic *apic)
 {
-       return kvm_lapic_get_reg(apic, lvt_type) & APIC_VECTOR_MASK;
+       return kvm_lapic_get_reg(apic, APIC_LVTT) & APIC_VECTOR_MASK;
 }

in addition to the above.

-- 
Vitaly

