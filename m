Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CF6390072
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 13:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhEYMA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 08:00:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41547 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231903AbhEYMAZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 08:00:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621943935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4dWBj2xEpomXMG3a3sEE1w16eqLFbf3ilvoXqJLfPZM=;
        b=MWVr1iy0/wqh8uqHw0ZsPvfF7K/o/t3LS96TcKgIAeqZG2HUOUrq7dIRDNYVtQuuBMkV+B
        LS+LcZ9E8nEOPgb2+3kpgf/j7MDqWtBhvPn/tHH5dWPWLs2wRFSBLue94DIrj8R37gEbgF
        Xhis/X3uMttYkj4fsozx31wtlt5NwhA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-x3FnzazIMcaRUSHTunbNUQ-1; Tue, 25 May 2021 07:58:53 -0400
X-MC-Unique: x3FnzazIMcaRUSHTunbNUQ-1
Received: by mail-ed1-f71.google.com with SMTP id c15-20020a05640227cfb029038d710bf29cso11158818ede.16
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 04:58:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4dWBj2xEpomXMG3a3sEE1w16eqLFbf3ilvoXqJLfPZM=;
        b=D4ZaUvAbhGt3DNFSs0ZdzEvdhZlOgBDykxSWK7TP7U4oJBjJdUFjxQo95A6E0LC+Er
         m/2gDfEorbfefGROCIm8v3BVe0PXPU3hrX9VyiI71WiINdPF0AoAnSTybvvzYQJyAu31
         aFoxtxtb9CxZZOp61IUBvk5ISgw2yFepo94PAynSYbOVV9aPZ9LBR9EJL1LdMIyzVS3q
         GQ9SZindj8kD1VtyB6INh29tKbkUsnTTppTU//PPcqJsJdoee2Ql7zI28gl3jKDeLZOG
         4HYvVyOPmQ50ZgyQdKn8sRhmDpaThPCESNUuL896s3M3K4FbZT7+CvbtKTAVT/j5h2hS
         JJGA==
X-Gm-Message-State: AOAM530XWHwsbPcEANVuxN2VWPhMpwUGjQdBVhaCkSRcYQtUGRP+TeWS
        gA3bhF9DrHn8YLfevNXlBsyWT8BB5o9CCda+9ip1snzbCqS3vh4EBtxxR9l6Fug/FjHMTWElVEd
        ztVdTVA0gIGNP
X-Received: by 2002:a17:906:2dca:: with SMTP id h10mr27929001eji.507.1621943932271;
        Tue, 25 May 2021 04:58:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLLdJeI+zOpUn8iaUCgpRk0tGPchjaDsRZnklkxPbrx29q3IEewanQQ/IaFJh7fHDFIrasxw==
X-Received: by 2002:a17:906:2dca:: with SMTP id h10mr27928990eji.507.1621943932047;
        Tue, 25 May 2021 04:58:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l18sm9193593ejc.103.2021.05.25.04.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 May 2021 04:58:51 -0700 (PDT)
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>, Pei Zhang <pezhang@redhat.com>
References: <20210510172646.930550753@redhat.com>
 <20210510172818.025080848@redhat.com>
 <e929da71-8f7d-52b2-2a71-30cb078535d3@redhat.com>
 <20210524175329.GA19468@fuller.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <40b253f3-7a90-bf7a-8480-b9fa6eb30526@redhat.com>
Date:   Tue, 25 May 2021 13:58:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210524175329.GA19468@fuller.cnet>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/21 19:53, Marcelo Tosatti wrote:
> On Mon, May 24, 2021 at 05:55:18PM +0200, Paolo Bonzini wrote:
>> On 10/05/21 19:26, Marcelo Tosatti wrote:
>>> +void vmx_pi_start_assignment(struct kvm *kvm)
>>> +{
>>> +	struct kvm_vcpu *vcpu;
>>> +	int i;
>>> +
>>> +	if (!irq_remapping_cap(IRQ_POSTING_CAP))
>>> +		return;
>>> +
>>> +	/*
>>> +	 * Wakeup will cause the vCPU to bail out of kvm_vcpu_block() and
>>> +	 * go back through vcpu_block().
>>> +	 */
>>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>>> +		if (!kvm_vcpu_apicv_active(vcpu))
>>> +			continue;
>>> +
>>> +		kvm_vcpu_wake_up(vcpu);
>>
>> Would you still need the check_block callback, if you also added a
>> kvm_make_request(KVM_REQ_EVENT)?
>>
>> In fact, since this is entirely not a hot path, can you just do
>> kvm_make_all_cpus_request(kvm, KVM_REQ_EVENT) instead of this loop?
>>
>> Thanks,
>>
>> Paolo
> 
> Hi Paolo,
> 
> Don't think so:
> 
> static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
> {
>          int ret = -EINTR;
>          int idx = srcu_read_lock(&vcpu->kvm->srcu);
> 
>          if (kvm_arch_vcpu_runnable(vcpu)) {
>                  kvm_make_request(KVM_REQ_UNHALT, vcpu);  <---- don't want KVM_REQ_UNHALT

UNHALT is incorrect indeed, but requests don't have to unhalt the vCPU.

This case is somewhat similar to signal_pending(), where the next 
KVM_RUN ioctl resumes the halt.  It's also similar to 
KVM_REQ_PENDING_TIMER.  So you can:

- rename KVM_REQ_PENDING_TIMER to KVM_REQ_UNBLOCK except in 
arch/powerpc, where instead you add KVM_REQ_PENDING_TIMER to 
arch/powerpc/include/asm/kvm_host.h

- here, you add

	if (kvm_check_request(KVM_REQ_UNBLOCK, vcpu))
		goto out;

- then vmx_pi_start_assignment only needs to

	if (!irq_remapping_cap(IRQ_POSTING_CAP))
		return;
	kvm_make_all_cpus_request(kvm, KVM_REQ_UNBLOCK);

kvm_arch_vcpu_runnable() would still return false, so the mp_state would 
not change.

Paolo

