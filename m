Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8462D1A7F12
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 16:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388743AbgDNOBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 10:01:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45889 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388638AbgDNOBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 10:01:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586872873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xW4JJ63kGzo8YleM4fDmI10qMSve7UMHVJz8z+0tNCI=;
        b=da1pHnUWQ2TS81F6lkrnsgWKOBd8Txhamu3dpmTjIQAqiDohoRIwpTNduVLrROXIAXG92+
        POblXZQFdRh8HC7jpXXLZKYCYRPUxDHi5ZxGi0Xi+ym1UXJGcuD+iZ7DugEHEy2dA1u0dG
        nWHw5EQ69ZQckXvYJkQPIpwdl+zlRhg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-uvjwZfgbOs-pTBsnv3t68w-1; Tue, 14 Apr 2020 10:01:12 -0400
X-MC-Unique: uvjwZfgbOs-pTBsnv3t68w-1
Received: by mail-wm1-f70.google.com with SMTP id h184so689941wmf.5
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 07:01:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=xW4JJ63kGzo8YleM4fDmI10qMSve7UMHVJz8z+0tNCI=;
        b=FZY7cnDyP0ug61IHeNV7bHQTN7QU+7hw3DrVBGDEl/CehGW5DFkO4Ce16iLurLCwai
         +NiKYuzhOFeroNXbr7VZGUVyjQvptsq3FKTGEJaIYp2Wv9XXrtCDEKoCyw45eirErvEc
         pD4HIDIx2aFBWqCr7ywSBhypNslh+ozkvdd7QisYBsiGVrkFXazwVBkyXlm9z47g2Xf9
         fjjU9R+KY15OAcplDM/QowcDmOEckXQQhm9Nl2XBtaWssjLx4YrO/z/MF9z/1NxaJ8Yy
         6OruzOjoCi8cL5vv5J937MdEs2s8VVwbELHGSctrWURBtYoaUaQy/MJLLdbnvvxfPHjv
         Vs0g==
X-Gm-Message-State: AGi0PuYfut4x8Iz/j6hW+rqeuN1jb3eZdkqLW2zZoNqYTTz1+HqhOWr9
        8RUYwkrlWOK9NE6lOpfvVutNmpNA2s/qNn3B/v6r0T8dwXdRy/Vv7LR0O2qlV9xTR/KWyZ+YKk+
        HxQh5JzPdM6Ci
X-Received: by 2002:adf:f282:: with SMTP id k2mr6577856wro.133.1586872870047;
        Tue, 14 Apr 2020 07:01:10 -0700 (PDT)
X-Google-Smtp-Source: APiQypICnt6J8qgnsV8wKiTHwiR7fBhIGu8H4stTfwPgbaWusVSaxQUwryR9vtfbJuAASEJAr+nlPQ==
X-Received: by 2002:adf:f282:: with SMTP id k2mr6577829wro.133.1586872869727;
        Tue, 14 Apr 2020 07:01:09 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a2sm20078762wra.71.2020.04.14.07.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 07:01:08 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     Marcelo Tosatti <mtosatti@redhat.com>, thuth@redhat.com,
        nilal@redhat.com
Subject: Re: [Patch v1] x86: Fix the logical destination mode test
In-Reply-To: <4993e419-5eef-46ba-5dd0-e35c7103190b@redhat.com>
References: <1583795750-33197-1-git-send-email-nitesh@redhat.com> <20200310140323.GA7132@fuller.cnet> <4993e419-5eef-46ba-5dd0-e35c7103190b@redhat.com>
Date:   Tue, 14 Apr 2020 16:01:07 +0200
Message-ID: <878siyyxng.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nitesh Narayan Lal <nitesh@redhat.com> writes:

> On 3/10/20 10:03 AM, Marcelo Tosatti wrote:
>> On Mon, Mar 09, 2020 at 07:15:50PM -0400, Nitesh Narayan Lal wrote:
>>> There are following issues with the ioapic logical destination mode test:
>>>
>>> - A race condition that is triggered when the interrupt handler
>>>   ioapic_isr_86() is called at the same time by multiple vCPUs. Due to this
>>>   the g_isr_86 is not correctly incremented. To prevent this a spinlock is
>>>   added around ‘g_isr_86++’.
>>>
>>> - On older QEMU versions initial x2APIC ID is not set, that is why
>>>   the local APIC IDs of each vCPUs are not configured. Hence the logical
>>>   destination mode test fails/hangs. Adding ‘+x2apic’ to the qemu -cpu params
>>>   ensures that the local APICs are configured every time, irrespective of the
>>>   QEMU version.
>>>
>>> - With ‘-machine kernel_irqchip=split’ included in the ioapic test
>>>   test_ioapic_self_reconfigure() always fails and somehow leads to a state where
>>>   after submitting IOAPIC fixed delivery - logical destination mode request we
>>>   never receive an interrupt back. For now, the physical and logical destination
>>>   mode tests are moved above test_ioapic_self_reconfigure().
>>>
>>> Fixes: b2a1ee7e ("kvm-unit-test: x86: ioapic: Test physical and logical destination mode")
>>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> Looks good to me.
>
> Hi,
>
> I just wanted to follow up and see if there are any more suggestions for me to
> improve this patch before it can be merged.
>
>
>>
>>> ---
>>>  x86/ioapic.c      | 11 +++++++----
>>>  x86/unittests.cfg |  2 +-
>>>  2 files changed, 8 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/x86/ioapic.c b/x86/ioapic.c
>>> index 742c711..3106531 100644
>>> --- a/x86/ioapic.c
>>> +++ b/x86/ioapic.c
>>> @@ -432,10 +432,13 @@ static void test_ioapic_physical_destination_mode(void)
>>>  }
>>>  
>>>  static volatile int g_isr_86;
>>> +struct spinlock ioapic_lock;
>>>  
>>>  static void ioapic_isr_86(isr_regs_t *regs)
>>>  {
>>> +	spin_lock(&ioapic_lock);
>>>  	++g_isr_86;
>>> +	spin_unlock(&ioapic_lock);
>>>  	set_irq_line(0x0e, 0);
>>>  	eoi();
>>>  }
>>> @@ -501,6 +504,10 @@ int main(void)
>>>  	test_ioapic_level_tmr(true);
>>>  	test_ioapic_edge_tmr(true);
>>>  
>>> +	test_ioapic_physical_destination_mode();

I just found out that this particular change causes 'ioapic-split' test
to hang reliably: 

# ./run_tests.sh ioapic-split
FAIL ioapic-split (timeout; duration=90s)
PASS ioapic (26 tests)

unlike 'ioapic' test we run it with '-smp 1' and
'test_ioapic_physical_destination_mode' requires > 1 CPU to work AFAICT.

Why do we move it from under 'if (cpu_count() > 1)' ?

Also, this patch could've been split.

>>> +	if (cpu_count() > 3)
>>> +		test_ioapic_logical_destination_mode();
>>> +
>>>  	if (cpu_count() > 1) {
>>>  		test_ioapic_edge_tmr_smp(false);
>>>  		test_ioapic_level_tmr_smp(false);
>>> @@ -508,11 +515,7 @@ int main(void)
>>>  		test_ioapic_edge_tmr_smp(true);
>>>  
>>>  		test_ioapic_self_reconfigure();
>>> -		test_ioapic_physical_destination_mode();
>>>  	}
>>>  
>>> -	if (cpu_count() > 3)
>>> -		test_ioapic_logical_destination_mode();
>>> -
>>>  	return report_summary();
>>>  }
>>> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
>>> index f2401eb..d658bc8 100644
>>> --- a/x86/unittests.cfg
>>> +++ b/x86/unittests.cfg
>>> @@ -46,7 +46,7 @@ timeout = 30
>>>  [ioapic]
>>>  file = ioapic.flat
>>>  smp = 4
>>> -extra_params = -cpu qemu64
>>> +extra_params = -cpu qemu64,+x2apic
>>>  arch = x86_64
>>>  
>>>  [cmpxchg8b]
>>> -- 
>>> 1.8.3.1

-- 
Vitaly

