Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EEC1C5528
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 14:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbgEEMMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 08:12:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39562 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728938AbgEEMMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 08:12:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588680756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EEdhDweLqjW8jAvmPi06Mv3yVCqRblNSuBY59q+aBGE=;
        b=ONMyolrGXE/ZYZyhBoAhYlkoHzO6Cf6c7RWbmGKlUzzXpcCAEJNZEHit/v4aLnoVkMJJ1N
        aZP+N4zupBL/OxGvl1B6YoXzsIxmOqRZNSNVYxS8VVPInx6canph25O0s3S8ZuMWBToF/9
        SY0YNq7OcJZx+whPJDaMpqPCQEUqbnk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-o-ehGzG0PBGhDBCrYRfk0Q-1; Tue, 05 May 2020 08:12:34 -0400
X-MC-Unique: o-ehGzG0PBGhDBCrYRfk0Q-1
Received: by mail-wm1-f71.google.com with SMTP id o26so765458wmh.1
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 05:12:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EEdhDweLqjW8jAvmPi06Mv3yVCqRblNSuBY59q+aBGE=;
        b=SclWUZ6Sk87QmtzdUGea96P06NJwbe9WTn7rGDlvT/+bClS2tB6OHazqokzh/qg7mk
         18iS7YbpOuhNS1shOn5UDh/el1NI27dlBsg6v6wOz13wEAEWzAz9n1//82J7VsFniZG/
         8592qHMvOJ1fnoYWfiSdEuEjA6ZQYw8mPhymDSd6qfnZEwZSQLr+DuVhDAEHWd+mym/a
         sF+OysYwMOpDqHbmlD07EhzqnT8OUcqNt0wtozPlhmbtfAZf4YQSlviYJGVRlebPNdnR
         Iye4Xg867L/nE0LBp1DXE9I8jOeMFqCOniwpoC222FSxH7YZme6xQgdMQMiG9do+MVqn
         w83g==
X-Gm-Message-State: AGi0PuYefppnS7joG9Gsta0ea7NsIWTDz3iAZhdcRIwmxGTQtX46WHef
        K1QI3T19TV9WB4o0+0enSgPKNPp+FXDhS3qrE+AH0QhyuqCnso72At2DmufI212hOYifVNFumeU
        tzjtQyyEst1WS
X-Received: by 2002:a1c:4603:: with SMTP id t3mr2953704wma.103.1588680753462;
        Tue, 05 May 2020 05:12:33 -0700 (PDT)
X-Google-Smtp-Source: APiQypJjwpqisMjfWbOwDPbPwXCspJW62o+EO0zALtr5RNTbzzXcDRGIep8Gx5rPbVmkARENzHhqSg==
X-Received: by 2002:a1c:4603:: with SMTP id t3mr2953691wma.103.1588680753226;
        Tue, 05 May 2020 05:12:33 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id n21sm3251171wra.15.2020.05.05.05.12.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 05:12:32 -0700 (PDT)
Subject: Re: AVIC related warning in enable_irq_window
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <9ce7bb5c4fb8bcc4ac21103f7534a6edfcbe195d.camel@redhat.com>
 <758b27a8-74c0-087d-d90b-d95faee2f561@redhat.com>
 <c5c32371-4b4e-1382-c616-3830ba46bf85@amd.com>
 <159382e7fdf0f9b50d79e29554842289e92e1ed7.camel@redhat.com>
 <d22d32de-5d91-662a-bf53-8cfb115dbe8d@redhat.com>
 <c81cf9bb-840a-d076-bc0e-496916621bdd@amd.com>
 <23b0dfe5-eba4-136b-0d4a-79f57f8a03ff@redhat.com>
 <efbe933a-3ab6-fa57-37fb-affc87369948@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6e94e9e1-64d1-de62-3bdb-75be99ddbb35@redhat.com>
Date:   Tue, 5 May 2020 14:12:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <efbe933a-3ab6-fa57-37fb-affc87369948@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/20 09:55, Suravee Suthikulpanit wrote:
>> WARN_ON((vmcb->control.int_ctl & (AVIC_ENABLE_MASK | V_IRQ_MASK))
>>     == (AVIC_ENABLE_MASK | V_IRQ_MASK));
>
> Based on my experiment, it seems that the hardware sets the V_IRQ_MASK bit
> when #VMEXIT despite this bit being ignored when AVIC is enabled.
> (I'll double check w/ HW team on this.) In this case, I don't think we can
> use the WARN_ON() as suggested above.

Indeed this is even documented:

NOTE: This value is written back to the VMCB at #VMEXIT.
      This field is ignored on VMRUN when AVIC is
      enabled.

> I think we should keep the warning in the svm_set_vintr() since we want
> to know if the V_IRQ, V_INTR_PRIO, V_IGN_TPR, and V_INTR_VECTOR are ignored when
> calling svm_set_vintr().
> 
> Instead, I would consider explicitly call kvm_vcpu_update_apicv() since
> it would be benefit from not having to wait for the next vcpu_enter_guest for
> this vcpu to process the request. This is less confusing to me. In this case,
> we would need to kvm_clear_request(KVM_REQ_APICV_UPDATE) for this vcpu as well.
> 
> On the other hand, would be it useful to implement
> kvm_make_all_cpus_request_but_self(),
> which sends request to all other vcpus excluding itself?

Yes, that's also a possibility.  It's not too much extra complication if
we add a new argument to kvm_make_vcpus_request_mask, like this:

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 74bdb7bf3295..8f9dadb1ef42 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -258,7 +258,7 @@ static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
 	return true;
 }
 
-bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
+bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req, struct kvm_vcpu *except,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp)
 {
 	int i, cpu, me;
@@ -270,6 +270,8 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (vcpu_bitmap && !test_bit(i, vcpu_bitmap))
 			continue;
+		if (vcpu == except)
+			continue;
 
 		kvm_make_request(req, vcpu);
 		cpu = vcpu->cpu;


Paolo

