Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5029C365334
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 09:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhDTHXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 03:23:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38427 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229471AbhDTHXi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 03:23:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618903386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iOjPfwXb4OBqjnrtphdyCIjJaLUOZwAgc5HsS5Qcaz4=;
        b=hG/lCxzyq5/BoP6KjfiNdHAoPHFVLzNrxg9fVR+nlpco45R1AbCETegn6JQ+aq0Rw2E8Sa
        BwiWa92Pm2XwOR+OsBhXonKWSd/wTF4hwTzHNUJNr2aN0heG6CFZ7/sBV3KkcMhuihBnaB
        TC0oGbUeR3DY0ArJBC8JZedecCCN4kI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-0W2MwGJqOOOpcLO2rYBZxg-1; Tue, 20 Apr 2021 03:22:55 -0400
X-MC-Unique: 0W2MwGJqOOOpcLO2rYBZxg-1
Received: by mail-ej1-f69.google.com with SMTP id z6-20020a17090665c6b02903700252d1ccso4403710ejn.10
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 00:22:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iOjPfwXb4OBqjnrtphdyCIjJaLUOZwAgc5HsS5Qcaz4=;
        b=e+ozmCy2aZuHEgZekKwVG0lqW1gRXzWBW9BXAvZvhMQEBJlYCH92pb2L7glXvR8YvN
         9CHqLKESdJOqSfwyO1TQ+oj3WidfgwRSoQTcyHgJoIpeWWVp7Cjgw9Ji4bU3/gQm4UGJ
         t61Azqv5Rybgh8q9Law6D6+C5Y2WpGVKgLxWn1bqD6L95Ou6tL57YUkVIBdhadtX0ZzT
         01M6WydnmyAPyeQzqlj1089tGM1wOsxdIWYdzMQKnHeNlgaK37flZ9GbcSKCQo+D9zsv
         2s16BSdgc6k6JdcG90X4eIVYJ86Qj3NNowdVmDledCeVdinCj2vcGVpa2/tfyMnhvP5/
         IAnQ==
X-Gm-Message-State: AOAM533S2EJa5wfkDzkuEdJCxYPWoocq3tcBLHSxGj2EHVKppp42nWF5
        BVZrZOXdAhdat/zeQMbA520VK8o2vqOTcoEDQr8yaAXIjdAiYQn7mXWLSULT36fM6v54GWev19O
        StJJrrDFqZow4
X-Received: by 2002:a17:906:c1c5:: with SMTP id bw5mr4745268ejb.510.1618903374225;
        Tue, 20 Apr 2021 00:22:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2QJROIdRPM2hmECvsC+4FwFOAwe2nIQpMN/ME3nb0Np6MQ8btKb9/VyXKn+NHnIEEkgpirQ==
X-Received: by 2002:a17:906:c1c5:: with SMTP id bw5mr4745246ejb.510.1618903373975;
        Tue, 20 Apr 2021 00:22:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p4sm14795453edr.43.2021.04.20.00.22.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 00:22:53 -0700 (PDT)
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b2fca9a5-9b2b-b8f2-0d1e-fc8b9d9b5659@redhat.com>
Date:   Tue, 20 Apr 2021 09:22:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CyHX-_vQLck1a9wpCv8a-YnnemEWm+zVv4eWYby5gdAeg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/21 08:08, Wanpeng Li wrote:
> On Tue, 20 Apr 2021 at 14:02, Wanpeng Li <kernellwp@gmail.com> wrote:
>>
>> On Tue, 20 Apr 2021 at 00:59, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>
>>> On 19/04/21 18:32, Sean Christopherson wrote:
>>>> If false positives are a big concern, what about adding another pass to the loop
>>>> and only yielding to usermode vCPUs with interrupts in the second full pass?
>>>> I.e. give vCPUs that are already in kernel mode priority, and only yield to
>>>> handle an interrupt if there are no vCPUs in kernel mode.
>>>>
>>>> kvm_arch_dy_runnable() pulls in pv_unhalted, which seems like a good thing.
>>>
>>> pv_unhalted won't help if you're waiting for a kernel spinlock though,
>>> would it?  Doing two passes (or looking for a "best" candidate that
>>> prefers kernel mode vCPUs to user mode vCPUs waiting for an interrupt)
>>> seems like the best choice overall.
>>
>> How about something like this:

I was thinking of something simpler:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9b8e30dd5b9b..455c648f9adc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3198,10 +3198,9 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
  {
  	struct kvm *kvm = me->kvm;
  	struct kvm_vcpu *vcpu;
-	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
  	int yielded = 0;
  	int try = 3;
-	int pass;
+	int pass, num_passes = 1;
  	int i;
  
  	kvm_vcpu_set_in_spin_loop(me, true);
@@ -3212,13 +3211,14 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
  	 * VCPU is holding the lock that we need and will release it.
  	 * We approximate round-robin by starting at the last boosted VCPU.
  	 */
-	for (pass = 0; pass < 2 && !yielded && try; pass++) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			if (!pass && i <= last_boosted_vcpu) {
-				i = last_boosted_vcpu;
-				continue;
-			} else if (pass && i > last_boosted_vcpu)
-				break;
+	for (pass = 0; pass < num_passes; pass++) {
+		int idx = me->kvm->last_boosted_vcpu;
+		int n = atomic_read(&kvm->online_vcpus);
+		for (i = 0; i < n; i++, idx++) {
+			if (idx == n)
+				idx = 0;
+
+			vcpu = kvm_get_vcpu(kvm, idx);
  			if (!READ_ONCE(vcpu->ready))
  				continue;
  			if (vcpu == me)
@@ -3226,23 +3226,36 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
  			if (rcuwait_active(&vcpu->wait) &&
  			    !vcpu_dy_runnable(vcpu))
  				continue;
-			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
-				!kvm_arch_vcpu_in_kernel(vcpu))
-				continue;
  			if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
  				continue;
  
+			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
+			    !kvm_arch_vcpu_in_kernel(vcpu)) {
+			    /*
+			     * A vCPU running in userspace can get to kernel mode via
+			     * an interrupt.  That's a worse choice than a CPU already
+			     * in kernel mode so only do it on a second pass.
+			     */
+			    if (!vcpu_dy_runnable(vcpu))
+				    continue;
+			    if (pass == 0) {
+				    num_passes = 2;
+				    continue;
+			    }
+			}
+
  			yielded = kvm_vcpu_yield_to(vcpu);
  			if (yielded > 0) {
  				kvm->last_boosted_vcpu = i;
-				break;
+				goto done;
  			} else if (yielded < 0) {
  				try--;
  				if (!try)
-					break;
+					goto done;
  			}
  		}
  	}
+done:
  	kvm_vcpu_set_in_spin_loop(me, false);
  
  	/* Ensure vcpu is not eligible during next spinloop */

Paolo

