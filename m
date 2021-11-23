Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC0B45AB6C
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 19:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbhKWSsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 13:48:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57785 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234139AbhKWSsE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 13:48:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637693094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=atUqbi/LGR3R88oWuOD1lf3jMc+Pa506gfmC4ZKl7sA=;
        b=eAhB15OeU8B5/1MQqNKHW3hJgQesbunqOLVZ3dvgT/4QC3Q+0YbhkghIGuIY26CdQBY/xS
        dr8c/I6k9FxFFuKGgB7d72K6UaVuc9fMpqrM1gZBHYlYFWvXxMa4nj326Fazy9MWWx4V7D
        fqdTeaWkaaD2QKbX8xQgF+cqDqiNDhQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-1VLs5ALFOqKE3E6r2lIRkQ-1; Tue, 23 Nov 2021 13:44:53 -0500
X-MC-Unique: 1VLs5ALFOqKE3E6r2lIRkQ-1
Received: by mail-wm1-f72.google.com with SMTP id i131-20020a1c3b89000000b00337f92384e0so1635778wma.5
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 10:44:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=atUqbi/LGR3R88oWuOD1lf3jMc+Pa506gfmC4ZKl7sA=;
        b=dVkz7TYINH0WNA+3Q2PjCd49qqHfKo80xwcD6zN78nIk5SuYiyTHr4JDz/1yS/oFmn
         x1jWw7YcxBVsv+vt0CwyNrPGoRQ0aEsqsx2LaxZojHuqCad75bs0XnIVy05wzKFEP+Mp
         PdxuT9XVc1hDv7mhroK5FbS/HzBL3gk+jcweW5qmEdxsmabniB1RSs/Wlx6RgW92LTSx
         MDTJtnFEbNzd/5O3Wk41Ag8xLb53aEcbQsLkqX908CKaEq7ox/BK8qMQ78SGlovIa61a
         v4aaOm2vmPo8DF9v7asHoq2cBACNZjkb+EqHHlacqTfTfoV+vkla/Y4SVwi/Zyx36xex
         zo8Q==
X-Gm-Message-State: AOAM533ktrEchfHOx3kLTnDmGyS/f/+PFguo0goCItrwPXLuT2HlSx7V
        pnnoJg8LM5HjLW6lGXmt4YMYTM1cbKHXsPUKAWkK1TqaDNbPyRkErhNZqIi2mrtuvlcZtSzk/Ac
        FyS0Ezr/tiMmE
X-Received: by 2002:a05:600c:4308:: with SMTP id p8mr5825210wme.132.1637693092337;
        Tue, 23 Nov 2021 10:44:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxbaFPD94nEBZ68gs+jNNHX8jNyAeKzejwp6ZTQ5kQr2c1qNW2ALik4DmqlEP+UBCOrJExp7w==
X-Received: by 2002:a05:600c:4308:: with SMTP id p8mr5825159wme.132.1637693092032;
        Tue, 23 Nov 2021 10:44:52 -0800 (PST)
Received: from [192.168.3.132] (p5b0c6765.dip0.t-ipconnect.de. [91.12.103.101])
        by smtp.gmail.com with ESMTPSA id w2sm1763996wrn.67.2021.11.23.10.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 10:44:51 -0800 (PST)
Message-ID: <ffa6e5da-e0d2-6b21-f0aa-589ee7aabe47@redhat.com>
Date:   Tue, 23 Nov 2021 19:44:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211110203322.1374925-1-farman@linux.ibm.com>
 <20211110203322.1374925-3-farman@linux.ibm.com>
 <dd8a8b49-da6d-0ab8-dc47-b24f5604767f@redhat.com>
 <ab82e68051674ea771e2cb5371ca2a204effab40.camel@linux.ibm.com>
 <32836eb5-532f-962d-161a-faa2213a0691@linux.ibm.com>
 <b116e738d8f9b185867ab28395012aaddd58af31.camel@linux.ibm.com>
 <85ba9fa3-ca25-b598-aecd-5e0c6a0308f2@redhat.com>
 <19a2543b24015873db736bddb14d0e4d97712086.camel@linux.ibm.com>
 <9c9bbf66-54c9-3d02-6d9f-1e147945abe8@de.ibm.com>
 <cd1c11a05cc13fb8c70ce3644dcf823a840872b5.camel@linux.ibm.com>
 <858e4f2b-d601-a4f1-9e80-8f7838299c9a@redhat.com>
 <8849fcae225c2e7255db4d2aa164ea77d1b26c7a.camel@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC PATCH v3 2/2] KVM: s390: Extend the USER_SIGP capability
In-Reply-To: <8849fcae225c2e7255db4d2aa164ea77d1b26c7a.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>
>>> I ALSO took a stab at folding this into the S390 IRQ paths [2],
>>> similar
>>> to what was done with kvm_s390_stop_info. This worked reasonably
>>> well,
>>> except the QEMU interface kvm_s390_vcpu_interrupt() returns a void,
>>> and
>>> so wouldn't notice an error sent back by KVM. Not a deal breaker,
>>> but
>>> having not heard anything to this idea, I didn't go much farther.
>>
>> We only care about SIGP STOP* handling so far, if anybody is aware of
>> other issues
>> that need fixing, it would be helpful  to spell them out. 
> 
> Yes, I keep using SIGP STOP* as an example because it offers (A) a
> clear miscommunication with the status bits returned by SIGP SENSE, and
> (B) has some special handling in QEMU that to my experience is still
> incomplete. But I'm seeing issues with other orders, like SIGP RESTART
> [1] [2] (where QEMU does a kvm_s390_vcpu_interrupt() with
> KVM_S390_RESTART, and thus adds to pending_irq) and SIGP (INITIAL) CPU
> RESET [2] (admittedly not greatly researched).

Sorry I missed that discussion previously. Summarizing what the PoP says:

Once we have a pending:
* start (-> synchronous)
* stop (-> asynchronous)
* restart (-> asynchronous)
* stop-and-store-status (-> asynchronous)
* set-prefix (-> synchronous)
* store-status-at-address (-> synchronous)
* store-additional-status-at-address (-> synchronous)
* initial-CPU-reset (-> synchronous)
* CPU-reset order (-> synchronous)

The following orders have to return busy (my take: only a must if the
guest could observe the difference):
* sense
* external call
* emergency signal
* start
* stop
* restart
* stop and store status
* set prefix
* store status at address
* set architecture
* set multithreading
* store additional status at address

We have to ask ourselves

a) How could a single VCPU observe the difference if executing any other
instruction immediately afterwards. My take would be that for
synchronous orders we can't really. So we're left with:
* stop (-> asynchronous)
* restart (-> asynchronous)
* stop-and-store-status (-> asynchronous)

b) How could multiple VCPUs observe the difference that a single VCPU
can't observe. That will require more thought, but I think it will be
hardly possible.


We know that SIGP STOP * needs care.

SIGP RESTART is interesting. We inject it only for OPERATING cpus and it
will only change the LC psw. What if we execute immediately afterwards:

* sense -> does not affect any bits
* external call -> has higher IRQ priority. There could be a difference
  if injected before or after the restart was delivered. Could be fixed
  in the kernel (check IRQ_PEND_RESTART).
* emergency signal -> has higher IRQ priority. There could be a
  difference if injected before or after the restart was delivered.
  Could be fixed in the kernel (check IRQ_PEND_RESTART).
* start -> CPU is already operating
* stop -> restart is delivered first
* restart -> I think the lowcore will look different if we inject two
  RESTARTs immediately afterwards instead of only a single
  one. Could be fixed in the kernel (double-deliver the interrupt).
* stop and store status -> restart is delivered first
* set prefix -> CPU is operating, not possible
* store status at address -> CPU is operating, not possible
* set architecture -> don't care
* set multithreading -> don't care
* store additional status at address -> CPU is operating, not possible
* initial-CPU-reset -> clears local IRQ. LC will look different if
  RESTART was delivered or not. Could be fixed in the kernel quite
  easily (deliver restart first before clearing interrupts).
* CPU-reset -> clears local IRQs. LC will look different if
  injected before vs. after. Could be fixed in the kernel quite
  easily (deliver restart first before clearing interrupts)..

external call as handled by the SIGP interpretation facility will
already also violate that description. We don't know that a SIGP restart
is pending. We'd have to disable the SIGP interpretation facility
temporarily.

/me shivers

This sounds like the kind of things we should happily not be fixing
because nobody might really care :)



> 
> The reason for why I have no spent a lot of time in the latter is that
> I have also mentioned that POPS has lists of orders that will return
> busy [3], and so something more general is perhaps warranted. The QEMU
> RFC's don't handle anything further than SIGP STOP*, on account of it
> makes sense to get the interface right first.

Right. My take is to have a look what we actually have to fix -- where
the guest can actually observe the difference. If the guest can't
observe the difference there is no need to actually implement BUSY logic
as instructed in the PoP.

> 
>> I'll keep assuming that
>> only SIGP STOP*  needs fixing, as I already explained.
>>
>> Whenever QEMU tells a CPU to stop asynchronously, it does so via a
>> STOP IRQ from
>> the destination CPU thread via KVM_S390_SIGP_STOP. Then, we know the
>> CPU is busy
>> ... until we clear that interrupt, which happens via
>> kvm_s390_clear_stop_irq().
>>
>> Interestingly, we clear that interrupt via two paths:
>>
>> 1) kvm_s390_clear_local_irqs(), via KVM_S390_INITIAL_RESET and 
>>    KVM_S390_NORMAL_RESET. Here, we expect that new user space also
>> sets  
>>    the CPU to stopped via KVM_MP_STATE_STOPPED. In fact, modern QEMU 
>>    properly sets the CPU stopped before triggering clearing of the 
>>    interrupts (s390_cpu_reset()).
>> 2) kvm_s390_clear_stop_irq() via kvm_s390_vcpu_stop(), which is 
>>    triggered via:
>>
>> a) STOP intercept (handle_stop()), KVM_S390_INITIAL_RESET and 
>>    KVM_S390_NORMAL_RESET with old user space -- 
>>    !kvm_s390_user_cpu_state_ctrl().
>>
>> b) KVM_MP_STATE_STOPPED for modern user space.
>>
>>
>>
>> Would the following solve our SIGP STOP * issue w.o. uapi changes?
>>
> 
> A quick pass shows some promise, but I haven't the bandwidth to throw
> the battery of stuff at it. I'll have to take a closer look after the
> US Holiday to give a better answer. (Example: looking for
> IRQ_PEND_SIGP_STOP || IRQ_PEND_RESTART is trivial.)

Yes, extending to IRQ_PEND_RESTART would make sense.

-- 
Thanks,

David / dhildenb

