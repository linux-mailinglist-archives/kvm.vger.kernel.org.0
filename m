Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDD42C8CED
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 19:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbgK3Sge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 13:36:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41921 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728532AbgK3Sgd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 13:36:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606761307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kAtSh0vAVlhpMtD2lkobZLGqAWWIIQOz9o3aS6mPtKQ=;
        b=FWA3C1KEu1Q6HV4260SyDYrW0WtvTwTyZ7FHyF+cwslcoR2V76hdh/zSCIw6vp8EcF9mxs
        Axxkw6fQXGEhwc6lyDqvMMZucpYI7oP5rYVO56DOWHo2bzS5imWGINtgX5vD/0TfEFTnPp
        r6thaGzVB6FzSxA2z2W+nOewdmfUvNE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-4uwABYEMPpqd0M_m6xdTQw-1; Mon, 30 Nov 2020 13:35:05 -0500
X-MC-Unique: 4uwABYEMPpqd0M_m6xdTQw-1
Received: by mail-ej1-f70.google.com with SMTP id h17so336097ejk.21
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 10:35:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kAtSh0vAVlhpMtD2lkobZLGqAWWIIQOz9o3aS6mPtKQ=;
        b=ndnsbp3/sQ5IXI7kAR68Ceg2yMMEJykzNEHtfWq+Xi/SM8zmtKfNO8v+Z1z8EhsTi+
         A+LaAoHz9CxXlTcwcCDyi4Q3vw+O0gqPwKG99sRz8Ir9oQhbrTqYtHvtMJ5qmmVNVPgH
         oZQNpA/ftEbDkaRotdHeK2haFbhz7N8hH7ShhOFeHZhRV2fsFFf3FdfG1HjQEs39nniV
         KTv9DnP3KPBswSD6eZf4kr4aAr17IeTk46Y9fePcWYbS6WNxFjdSVNw22cI4NGeFYHDT
         SeSIfYFWwklyQC7YeljwAYJ7N7Bq9WYfuoSqJLcjf2TBcdl1m6AiKUFA9+J6pOBzg7Qt
         yB9A==
X-Gm-Message-State: AOAM532SlZHdMtd5nZwT5Tp8Ch2JuiAckgh16SE+enIjBsCHlf6V/sBJ
        VhYEv65olBmDEKthmfuELTnztVn8dqB96/Te8m0iRYQPkk+GVtBGJibMLZof6jW7f9bsFnE6XF6
        tMA4hu3bi0uEZ
X-Received: by 2002:a50:d784:: with SMTP id w4mr22599327edi.201.1606761303830;
        Mon, 30 Nov 2020 10:35:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwUjIL4juYIpVbV33ZJZ6ol0lRbKW1yriSL2v9cVpYAnJLQ1dU13hI1HeBdYGn/yFSNtPubzQ==
X-Received: by 2002:a50:d784:: with SMTP id w4mr22599303edi.201.1606761303657;
        Mon, 30 Nov 2020 10:35:03 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id co24sm600740edb.33.2020.11.30.10.35.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 10:35:02 -0800 (PST)
Subject: Re: [RFC PATCH 00/35] SEV-ES hypervisor support
To:     Sean Christopherson <seanjc@google.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <20200914225951.GM7192@sjchrist-ice>
 <bee6fdda-d548-8af5-f029-25c22165bf84@amd.com>
 <20200916001925.GL8420@sjchrist-ice>
 <60cbddaf-50f3-72ca-f673-ff0b421db3ad@redhat.com>
 <X8U2gyj7F2wFU3JI@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8759948d-aa0b-3929-bda6-488b6788489a@redhat.com>
Date:   Mon, 30 Nov 2020 19:35:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X8U2gyj7F2wFU3JI@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/11/20 19:14, Sean Christopherson wrote:
>>> TDX also selectively blocks/skips portions of other ioctl()s so that the
>>> TDX code itself can yell loudly if e.g. .get_cpl() is invoked.  The event
>>> injection restrictions are due to direct injection not being allowed (except
>>> for NMIs); all IRQs have to be routed through APICv (posted interrupts) and
>>> exception injection is completely disallowed.
>>>
>>>     kvm_vcpu_ioctl_x86_get_vcpu_events:
>>> 	if (!vcpu->kvm->arch.guest_state_protected)
>>>           	events->interrupt.shadow = kvm_x86_ops.get_interrupt_shadow(vcpu);
>> Perhaps an alternative implementation can enter the vCPU with immediate exit
>> until no events are pending, and then return all zeroes?
>
> This can't work.  If the guest has STI blocking, e.g. it did STI->TDVMCALL with
> a valid vIRQ in GUEST_RVI, then events->interrupt.shadow should technically be
> non-zero to reflect the STI blocking.  But, the immediate exit (a hardware IRQ
> for TDX guests) will cause VM-Exit before the guest can execute any instructions
> and thus the guest will never clear STI blocking and never consume the pending
> event.  Or there could be a valid vIRQ, but GUEST_RFLAGS.IF=0, in which case KVM
> would need to run the guest for an indeterminate amount of time to wait for the
> vIRQ to be consumed.

Delayed interrupts are fine, since they are injected according to RVI 
and the posted interrupt descriptor.  I'm thinking more of events 
(exceptions and interrupts) that caused an EPT violation exit and were 
recorded in the IDT-vectored info field.

Paolo

> Tangentially related, I haven't looked through the official external TDX docs,
> but I suspect that vmcs.GUEST_RVI is listed as inaccessible for production TDs.
> This will be changed as the VMM needs access to GUEST_RVI to handle
> STI->TDVMCALL(HLT), otherwise the VMM may incorrectly put the vCPU into a
> blocked (not runnable) state even though it has a pending wake event.
> 

