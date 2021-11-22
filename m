Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371B8458CC2
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 11:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhKVK4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 05:56:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59216 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230130AbhKVK4D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 05:56:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637578376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YjFjGD2IogEwRV4xVN+hpzd9AclxSl7gCW7Ys+7tTGY=;
        b=BLHRZJaekGvAENXcOqAWdwYLmUU9fR6vu87o5HTD0+bL3vrtzAL+5bFa9NNHlguqGHhlBC
        86MZHv/xqQ5xYI0TOPWXNku0hQLB5AGsLFIloxy2rLDm89eDlkEGPCKBfo3RBfRLmJaNxi
        LlACtSPIUH+B3ZxGfY8PuX1hyOAbSXQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-HUrifLrLM5qnWuU48IRKBA-1; Mon, 22 Nov 2021 05:52:55 -0500
X-MC-Unique: HUrifLrLM5qnWuU48IRKBA-1
Received: by mail-wm1-f71.google.com with SMTP id l187-20020a1c25c4000000b0030da46b76daso9990616wml.9
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 02:52:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=YjFjGD2IogEwRV4xVN+hpzd9AclxSl7gCW7Ys+7tTGY=;
        b=crIREEBRF+MpNRIHViv5JT3BQI1bfo/Ht4QcjMFD1S0HJKifmUilS7g+vASOIgqBVr
         2a9jCaYtPXQHVcDRKWqMHKrBime6QwF4EEM5a8DahiKKgwM6kTxOBQLkfnUWTgjeoP5q
         qTXhA0+GM4wYy3KgjyrFpd8bDQeFGuGLX3atVmBdRD2jXOXcIliBMmDuVWYxkbyGYW8h
         7dR30F64JLJnd8LU/mnmjxVZciB+QqABrt2uaTBOrMVHDbhUFrIbwehbZTlf5NXG+Ckv
         T2h2E2UpfhnYX0eQFN7wkCeeC1yA9Rm8WwhQqk0opWdMFUSx9lr43lPIAvvNEnJm2Eah
         N9fQ==
X-Gm-Message-State: AOAM531VHq8aJxlnpcGfDMBm3+/m+Af7x9pKQ1JsttzL4J+MqbfzimR3
        +9tMZ4BIBnwRqMui+lxHH3lo54pIyUEg/bFp5EeQ1VxvB5rAviPWScI/SfBhFnFWZTZFsDO0W6e
        yxObsIjvCF2a1
X-Received: by 2002:a05:600c:2f01:: with SMTP id r1mr28710414wmn.153.1637578374142;
        Mon, 22 Nov 2021 02:52:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwS01PTa3X7+QMZ/zz1ekYZBwwX115XBIFS4vEQNv5zSWT8xUHMLn7vAmiU+e67J6RECQauBg==
X-Received: by 2002:a05:600c:2f01:: with SMTP id r1mr28710367wmn.153.1637578373824;
        Mon, 22 Nov 2021 02:52:53 -0800 (PST)
Received: from [192.168.3.132] (p5b0c667b.dip0.t-ipconnect.de. [91.12.102.123])
        by smtp.gmail.com with ESMTPSA id d7sm8336287wrw.87.2021.11.22.02.52.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 02:52:53 -0800 (PST)
Message-ID: <858e4f2b-d601-a4f1-9e80-8f7838299c9a@redhat.com>
Date:   Mon, 22 Nov 2021 11:52:52 +0100
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC PATCH v3 2/2] KVM: s390: Extend the USER_SIGP capability
In-Reply-To: <cd1c11a05cc13fb8c70ce3644dcf823a840872b5.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.11.21 21:20, Eric Farman wrote:
> On Wed, 2021-11-17 at 08:54 +0100, Christian Borntraeger wrote:
>> Am 11.11.21 um 20:05 schrieb Eric Farman:
>>> On Thu, 2021-11-11 at 19:29 +0100, David Hildenbrand wrote:
>>>> On 11.11.21 18:48, Eric Farman wrote:
>>>>> On Thu, 2021-11-11 at 17:13 +0100, Janosch Frank wrote:
>>>>>>
>>>>>> Looking at the API I'd like to avoid having two IOCTLs
>>>>>
>>>>> Since the order is a single byte, we could have the payload of
>>>>> an
>>>>> ioctl
>>>>> say "0-255 is an order that we're busy processing, anything
>>>>> higher
>>>>> than
>>>>> that resets the busy" or something. That would remove the need
>>>>> for
>>>>> a
>>>>> second IOCTL.
>>>>
>>>> Maybe just pass an int and treat a negative (or just -1) value as
>>>> clearing the order.
>>>>
>>>
>>> Right, that's exactly what I had at one point. I thought it was too
>>> cumbersome, but maybe not. Will dust it off, pending my question to
>>> Janosch about 0-vs-1 IOCTLs.
>>
>> As a totally different idea. Would a sync_reg value called SIGP_BUSY
>> work as well?
>>
> 
> Hrm... I'm not sure. I played with it a bit, and it's not looking
> great. I'm almost certainly missing some serialization, because I was
> frequently "losing" one of the toggles (busy/not-busy) when hammering
> CPUs with various SIGP orders on this interface and thus getting
> incorrect responses from the in-kernel orders.

You can only modify the destination CPU from the destination CPU thread,
after synchronizing the CPU state. This would be trivial with my QEMU proposal.

> 
> I also took a stab at David's idea of tying it to KVM_MP_STATE [1]. I
> still think it's a little odd, considering the existing states are all
> z/Arch-defined CPU states, but it does sound like the sort of thing
> we're trying to do (letting userspace announce what the CPU is up to).
> One flaw is that most of the rest of QEMU uses s390_cpu_set_state() for
> this, which returns the number of running CPUs instead of the return
> code from the MP_STATE ioctl (via kvm_s390_set_cpu_state()) that SIGP
> would be interested in. Even if I made the ioctl call directly, I still
> encounter some system problems that smell like ones I've addressed in
> v2 and v3. Possibly fixable, but I didn't pursue them far enough to be
> certain.

Well, we can essentially observe this special state of that CPU ("stopping"), so
it's not that weird. STOPPING is essentially OPERATING with the notion of
"the CPU is blocked for some actions.".

> 
> I ALSO took a stab at folding this into the S390 IRQ paths [2], similar
> to what was done with kvm_s390_stop_info. This worked reasonably well,
> except the QEMU interface kvm_s390_vcpu_interrupt() returns a void, and
> so wouldn't notice an error sent back by KVM. Not a deal breaker, but
> having not heard anything to this idea, I didn't go much farther.

We only care about SIGP STOP* handling so far, if anybody is aware of other issues
that need fixing, it would be helpful  to spell them out. I'll keep assuming that
only SIGP STOP*  needs fixing, as I already explained.

Whenever QEMU tells a CPU to stop asynchronously, it does so via a STOP IRQ from
the destination CPU thread via KVM_S390_SIGP_STOP. Then, we know the CPU is busy
... until we clear that interrupt, which happens via kvm_s390_clear_stop_irq().

Interestingly, we clear that interrupt via two paths:

1) kvm_s390_clear_local_irqs(), via KVM_S390_INITIAL_RESET and 
   KVM_S390_NORMAL_RESET. Here, we expect that new user space also sets  
   the CPU to stopped via KVM_MP_STATE_STOPPED. In fact, modern QEMU 
   properly sets the CPU stopped before triggering clearing of the 
   interrupts (s390_cpu_reset()).
2) kvm_s390_clear_stop_irq() via kvm_s390_vcpu_stop(), which is 
   triggered via:

a) STOP intercept (handle_stop()), KVM_S390_INITIAL_RESET and 
   KVM_S390_NORMAL_RESET with old user space -- 
   !kvm_s390_user_cpu_state_ctrl().

b) KVM_MP_STATE_STOPPED for modern user space.



Would the following solve our SIGP STOP * issue w.o. uapi changes?


a) Kernel

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c6257f625929..bd7ee1ea8aa8 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4643,10 +4643,15 @@ int kvm_s390_vcpu_stop(struct kvm_vcpu *vcpu)
                }
        }
 
-       /* SIGP STOP and SIGP STOP AND STORE STATUS has been fully processed */
+       /*
+        * SIGP STOP and SIGP STOP AND STORE STATUS have been fully
+        * processed. Clear the interrupt after setting the VCPU stopped,
+        * such that the VCPU remains busy for most SIGP orders until fully
+        * stopped.
+        */
+       kvm_s390_set_cpuflags(vcpu, CPUSTAT_STOPPED);
        kvm_s390_clear_stop_irq(vcpu);
 
-       kvm_s390_set_cpuflags(vcpu, CPUSTAT_STOPPED);
        __disable_ibs_on_vcpu(vcpu);
 
        for (i = 0; i < online_vcpus; i++) {
diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index cf4de80bd541..e40f6412106d 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -276,6 +276,38 @@ static int handle_sigp_dst(struct kvm_vcpu *vcpu, u8 order_code,
        if (!dst_vcpu)
                return SIGP_CC_NOT_OPERATIONAL;
 
+       /*
+        * SIGP STOP * orders are the only SIGP orders that are processed
+        * asynchronously, and can theoretically, never complete.
+        *
+        * Until the destination VCPU is stopped via kvm_s390_vcpu_stop(), we
+        * have a stop interrupt pending. While we have a pending stop
+        * interrupt, that CPU is busy for most SIGP orders.
+        *
+        * This is important, because otherwise a single VCPU could issue on an
+        * operating destination VCPU:
+        * 1) SIGP STOP $DEST
+        * 2) SIGP SENSE $DEST
+        * And have 2) not rejected with BUSY although the destination is still
+        * processing the pending SIGP STOP * order.
+        *
+        * Relevant code has to make sure to complete the SIGP STOP * action
+        * (e.g., setting the CPU stopped, storing the status) before clearing
+        * the STOP interrupt.
+        */
+       if (order_code != SIGP_INITIAL_CPU_RESET &&
+           order_code != SIGP_CPU_RESET) {
+               /*
+                * Lockless check. SIGP STOP / SIGP RE(START) properly
+                * synchronizes when processing these orders. In any other case,
+                * we don't particularly care about races, as the guest cannot
+                * observe the difference really when issuing orders from two
+                * differing VCPUs.
+                */
+               if (kvm_s390_is_stop_irq_pending(dst_vcpu))
+                       return SIGP_CC_BUSY;
+       }
+
        switch (order_code) {
        case SIGP_SENSE:
                vcpu->stat.instruction_sigp_sense++;

b) QEMU

diff --git a/target/s390x/sigp.c b/target/s390x/sigp.c
index 51c727834c..e97e3a60fd 100644
--- a/target/s390x/sigp.c
+++ b/target/s390x/sigp.c
@@ -479,13 +479,17 @@ void do_stop_interrupt(CPUS390XState *env)
 {
     S390CPU *cpu = env_archcpu(env);
 
-    if (s390_cpu_set_state(S390_CPU_STATE_STOPPED, cpu) == 0) {
-        qemu_system_shutdown_request(SHUTDOWN_CAUSE_GUEST_SHUTDOWN);
-    }
+    /*
+     * Complete the STOP operation before exposing the CPU as STOPPED to
+     * the system.
+     */
     if (cpu->env.sigp_order == SIGP_STOP_STORE_STATUS) {
         s390_store_status(cpu, S390_STORE_STATUS_DEF_ADDR, true);
     }
     env->sigp_order = 0;
+    if (s390_cpu_set_state(S390_CPU_STATE_STOPPED, cpu) == 0) {
+        qemu_system_shutdown_request(SHUTDOWN_CAUSE_GUEST_SHUTDOWN);
+    }
     env->pending_int &= ~INTERRUPT_STOP;
 }
 


-- 
Thanks,

David / dhildenb

