Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFE7365617
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 12:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhDTKYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 06:24:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231486AbhDTKYV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 06:24:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618914229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b7a+2NIHct7ey/wtfhecbqVWOV2x5OoBwHuqA9oFCX0=;
        b=XIGscTCSkpkE7hak/7hH7wpclhsG7GZ5QgfQgUG3bqg10mxdbWmh+08PTrv9AMFz+M0phZ
        fpSrmPXbPg/QQJ47xcJYaBJ0zsLKeyUcNxYRuBpnQhZRoUan3vR5rNYSf6USgcMbrJGw/Q
        q0pgUSyT819zAY3wW0DidD5wRZVOWFQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-Bso1uClVO5CR6WF6Mp_vUw-1; Tue, 20 Apr 2021 06:23:47 -0400
X-MC-Unique: Bso1uClVO5CR6WF6Mp_vUw-1
Received: by mail-ej1-f70.google.com with SMTP id x21-20020a1709064bd5b029037c44cb861cso4587530ejv.4
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 03:23:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b7a+2NIHct7ey/wtfhecbqVWOV2x5OoBwHuqA9oFCX0=;
        b=VnOHrghPyN4u1xRcyMcaYGkVTPczFUFu6DRF3ThHLDi3yzV7ycpOD+A5rFISv+kYrX
         lX5CTlry/diWe5Hoj6qc26PHJ3bAdhgvQOVZ1G1mMPDpr7g5Y2bqjEjdoq1g7KXm8BDt
         X1/Df78mXbulSER2/bb2vOF/BGc3PC8BXY/uVNiMq2qkkq/Qmbwm8sMjizoae3uMbyz6
         1Exj3kHUqhkFSsmGoGyllDOw8VhRtGpRS8ZPiMYAi+5TuDqZyBvVUKCjug5yFYZn1a5+
         NQ8Eu1V1Q4TRzH1vngay0ZHyBhniNPKFgFzJpFBVmuGAdXbEYtm3joAqQbB5GzRIcPDu
         sWmA==
X-Gm-Message-State: AOAM5302MiG6ZTup01XHJVOF+O/V+xQ9Q6A8B6XDHwAwW1azdK3/Ruxm
        2WerX68nmBnbFc99r92OlLh83Epd5JtkdByhaEmxXloEu9di6PcKHRycy7RedDg5Re3PDY+IXs5
        zYvFTy3Gpg1EM
X-Received: by 2002:a17:907:2151:: with SMTP id rk17mr26644959ejb.203.1618914226686;
        Tue, 20 Apr 2021 03:23:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzodp7RMnFhaEX9D/NoF30lFskpxX7NtEUD3yP5k2w2nOq60l9HMWrqSyGFWJM4H4SbP3QJkA==
X-Received: by 2002:a17:907:2151:: with SMTP id rk17mr26644944ejb.203.1618914226491;
        Tue, 20 Apr 2021 03:23:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f20sm9015003ejw.36.2021.04.20.03.23.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 03:23:45 -0700 (PDT)
Subject: Re: [PATCH] KVM: Boost vCPU candidiate in user mode which is
 delivering interrupt
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1618542490-14756-1-git-send-email-wanpengli@tencent.com>
 <9c49c6ff-d896-e6a5-c051-b6707f6ec58a@redhat.com>
 <CANRm+Cy-xmDRQoUfOYm+GGvWiS+qC_sBjyZmcLykbKqTF2YDxQ@mail.gmail.com>
 <YH2wnl05UBqVhcHr@google.com>
 <c1909fa3-61f3-de6b-1aa1-8bc36285e1e4@redhat.com>
 <CANRm+CwQ266j6wTxqFZtGhp_HfQZ7Y_e843hzROqNUxf9BcaFA@mail.gmail.com>
 <CANRm+CyHX-_vQLck1a9wpCv8a-YnnemEWm+zVv4eWYby5gdAeg@mail.gmail.com>
 <b2fca9a5-9b2b-b8f2-0d1e-fc8b9d9b5659@redhat.com>
 <CANRm+Czysw6z1u+fbsRF3JUyiJc0jErVATusar_Vj8CcSBy5LQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e1d07b55-1539-ed33-911c-713403d776b3@redhat.com>
Date:   Tue, 20 Apr 2021 12:23:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Czysw6z1u+fbsRF3JUyiJc0jErVATusar_Vj8CcSBy5LQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/21 10:48, Wanpeng Li wrote:
>> I was thinking of something simpler:
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 9b8e30dd5b9b..455c648f9adc 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -3198,10 +3198,9 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>>    {
>>          struct kvm *kvm = me->kvm;
>>          struct kvm_vcpu *vcpu;
>> -       int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
>>          int yielded = 0;
>>          int try = 3;
>> -       int pass;
>> +       int pass, num_passes = 1;
>>          int i;
>>
>>          kvm_vcpu_set_in_spin_loop(me, true);
>> @@ -3212,13 +3211,14 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>>           * VCPU is holding the lock that we need and will release it.
>>           * We approximate round-robin by starting at the last boosted VCPU.
>>           */
>> -       for (pass = 0; pass < 2 && !yielded && try; pass++) {
>> -               kvm_for_each_vcpu(i, vcpu, kvm) {
>> -                       if (!pass && i <= last_boosted_vcpu) {
>> -                               i = last_boosted_vcpu;
>> -                               continue;
>> -                       } else if (pass && i > last_boosted_vcpu)
>> -                               break;
>> +       for (pass = 0; pass < num_passes; pass++) {
>> +               int idx = me->kvm->last_boosted_vcpu;
>> +               int n = atomic_read(&kvm->online_vcpus);
>> +               for (i = 0; i < n; i++, idx++) {
>> +                       if (idx == n)
>> +                               idx = 0;
>> +
>> +                       vcpu = kvm_get_vcpu(kvm, idx);
>>                          if (!READ_ONCE(vcpu->ready))
>>                                  continue;
>>                          if (vcpu == me)
>> @@ -3226,23 +3226,36 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>>                          if (rcuwait_active(&vcpu->wait) &&
>>                              !vcpu_dy_runnable(vcpu))
>>                                  continue;
>> -                       if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
>> -                               !kvm_arch_vcpu_in_kernel(vcpu))
>> -                               continue;
>>                          if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
>>                                  continue;
>>
>> +                       if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
>> +                           !kvm_arch_vcpu_in_kernel(vcpu)) {
>> +                           /*
>> +                            * A vCPU running in userspace can get to kernel mode via
>> +                            * an interrupt.  That's a worse choice than a CPU already
>> +                            * in kernel mode so only do it on a second pass.
>> +                            */
>> +                           if (!vcpu_dy_runnable(vcpu))
>> +                                   continue;
>> +                           if (pass == 0) {
>> +                                   num_passes = 2;
>> +                                   continue;
>> +                           }
>> +                       }
>> +
>>                          yielded = kvm_vcpu_yield_to(vcpu);
>>                          if (yielded > 0) {
>>                                  kvm->last_boosted_vcpu = i;
>> -                               break;
>> +                               goto done;
>>                          } else if (yielded < 0) {
>>                                  try--;
>>                                  if (!try)
>> -                                       break;
>> +                                       goto done;
>>                          }
>>                  }
>>          }
>> +done:
> 
> We just tested the above post against 96 vCPUs VM in an over-subscribe
> scenario, the score of pbzip2 fluctuated drastically. Sometimes it is
> worse than vanilla, but the average improvement is around 2.2%. The
> new version of my post is around 9.3%，the origial posted patch is
> around 10% which is totally as expected since now both IPI receivers
> in user-mode and lock-waiters are second class citizens.

Fair enough.  Of the two patches you posted I prefer the original, so 
I'll go with that one.

Paolo

