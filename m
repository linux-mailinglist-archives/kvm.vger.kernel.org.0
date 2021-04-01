Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B6D351770
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbhDARmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 13:42:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58413 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234369AbhDARhB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:37:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617298621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FWlPTwVU/JhlFoa7PnUm7BiufeipdRCCVm3t67X/6Ck=;
        b=S+38g3MK6rlY57leg61tt4XH5OBBVTy8S6XH8IjXsLRL8RujEoSUVPemYWGt3JMBPTn8FV
        HowcEfFpnM+EpINMxJSnToxhsJRMG5EbGUm/ZuKjPKM6O2T6KQJBKYWZUOw/O2Br33GagS
        OzxEEGLHqrTM2n1slszsJ5HNV1YqRAM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-TeMo_hBBMduHV0VGDWVpUA-1; Thu, 01 Apr 2021 12:36:29 -0400
X-MC-Unique: TeMo_hBBMduHV0VGDWVpUA-1
Received: by mail-ej1-f72.google.com with SMTP id bg7so2474777ejb.12
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 09:36:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FWlPTwVU/JhlFoa7PnUm7BiufeipdRCCVm3t67X/6Ck=;
        b=VXOSwaTz+g++KUjJ8hgSjaxCYxl9M7HTvbFzKFduCQgWimR4Hs+13+mV9rO7z9T86P
         JoVfP+kDSv2x9lpAmno0w5rn9VsW6T3DpPaac933dtP0lY6ILSedF9kvpmBLsUbfKqDU
         J3DNI7YL3Z/QHzZ994mu1Idv4wQC9gTBoIgPZtJApLYhJIGsoxYo2510JKOCHggJ9cOc
         aTm5mR00XayE6apfSJUpALNa4e8aTw0rpi9HErbWzbDvlJDNK5PiXal7QfbKPscujgWl
         LeyLaR9GJ0ykh82uqL+VoArGO85av+Gsb7AfgMC6J31rm/KcqARrUXhxne8QbteO/rqA
         kAsA==
X-Gm-Message-State: AOAM531ldir47TelNJ2xTzrK4G01k9vJLKPyc4KFMw/Yc5BGd4nfcENz
        jYGWxUb8pmV34HU2E8whCfQOzV+FyoAnYr5ktiJoTh5vETdnWDOzVXgRTgpQoYaTE4dk2e4vfCA
        vKipXehVaRwM6
X-Received: by 2002:a17:906:33d9:: with SMTP id w25mr10387089eja.413.1617294988175;
        Thu, 01 Apr 2021 09:36:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJhdw9ZNAVxopX21NkBHBalklLzA7F/+seNIdWSSfqZWuAJGVcBjNNYohV15vdXdcEN2XjTw==
X-Received: by 2002:a17:906:33d9:: with SMTP id w25mr10387072eja.413.1617294988034;
        Thu, 01 Apr 2021 09:36:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f9sm3831396edq.43.2021.04.01.09.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 09:36:27 -0700 (PDT)
To:     David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mtosatti@redhat.com, vkuznets@redhat.com,
        syzbot+b282b65c2c68492df769@syzkaller.appspotmail.com
References: <20210330165958.3094759-1-pbonzini@redhat.com>
 <20210330165958.3094759-3-pbonzini@redhat.com>
 <1b37ba872b4d2e6186f8e172b95c36d92153d952.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [EXTERNAL] [PATCH 2/2] KVM: x86: disable interrupts while
 pvclock_gtod_sync_lock is taken
Message-ID: <65799142-76ce-fc90-0fcc-b384eaf2b038@redhat.com>
Date:   Thu, 1 Apr 2021 18:36:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1b37ba872b4d2e6186f8e172b95c36d92153d952.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/21 17:27, David Woodhouse wrote:
>> -       spin_lock(&ka->pvclock_gtod_sync_lock);
>> +       spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
>>          use_master_clock = ka->use_master_clock;
>>          if (use_master_clock) {
>>                  host_tsc = ka->master_cycle_now;
>>                  kernel_ns = ka->master_kernel_ns;
>>          }
>> -       spin_unlock(&ka->pvclock_gtod_sync_lock);
>> +       spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
>>
>>          /* Keep irq disabled to prevent changes to the clock */
>>          local_irq_save(flags);
> That seems a little gratuitous at the end; restoring the flags as part
> of the spin_unlock_irqrestore() and then immediately calling
> local_irq_save().
> 
> Is something going to complain if we just use spin_unlock() there and
> then later restore the flags with the existing local_irq_restore()?

Yes, I think it breaks on RT kernels.

> Or should we move the local_irq_save() up above the existing
> spin_lock() and leave the spin lock/unlock as they are?

Nope, also breaks on RT (and this one is explicitly called out by 
Documentation/locking/locktypes.rst).  Since it's necessary to use 
spin_lock_irqsave and spin_unlock_irqrestore, one would need flags and 
flags2 variables which is really horrible.

I thought of a similar one which is to move the critical section within 
the IRQ-disabled region:

         local_irq_save(flags);
	...
         spin_lock(&ka->pvclock_gtod_sync_lock);
         use_master_clock = ka->use_master_clock;
         if (use_master_clock) {
                 host_tsc = ka->master_cycle_now;
                 kernel_ns = ka->master_kernel_ns;
         } else {
                 host_tsc = rdtsc();
                 kernel_ns = get_kvmclock_base_ns();
         }
         spin_unlock(&ka->pvclock_gtod_sync_lock);
	...
	local_irq_restore(flags);

... but didn't do it because of RT again.

Paolo

