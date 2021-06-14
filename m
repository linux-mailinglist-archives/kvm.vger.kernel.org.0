Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E773A676D
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 15:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbhFNNKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 09:10:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60268 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232791AbhFNNKg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 09:10:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623676113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F6VHDVVSaHbxavSBrHRbBLmC4qN56vv+UPm0zOPUbbA=;
        b=ei8byQXxVd3fZ6EcpgWfpIZqVJnG0p4ytoElDAEgDcaFlB4DeJQ1VB+yXhQL0tzGIio83a
        B1MtIkb4WWdVyhvpHmW3d/+T+aN3rCKhpEtJhQpLZ4u7GIEKEaGax3VT3Dr9IbJvrjQJ4h
        cG5LJ9MCcFOcBpeOm8mmvKq4jGazWC8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-mLAz1rgONC6-g3Xx9DU-TQ-1; Mon, 14 Jun 2021 09:08:32 -0400
X-MC-Unique: mLAz1rgONC6-g3Xx9DU-TQ-1
Received: by mail-ed1-f71.google.com with SMTP id z16-20020aa7d4100000b029038feb83da57so20168156edq.4
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 06:08:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F6VHDVVSaHbxavSBrHRbBLmC4qN56vv+UPm0zOPUbbA=;
        b=pW8GIclXXftNcKlRDpMQwAQ7cpz89Wc2uCjcsE/kMQus72jLPKj66ETF9U6Njiqykm
         VJcow+bMk8hogH3IfBfp/swkXrmdnNVD+6T+6Oy5fwmOKa1SPcP71uTxd1lCG8Z9r/Vp
         OzCA88WqwAz54z1UAjPz3CP1ug0ckenz63RJgahAANuWMm2MKcNOranwFNtqfoUf40hD
         YXRQMQqnOPvYKeYPOahC9WNEaHIZ/vFsOdgpV0zbbj++KJnQtr88QvXYFWi7Wv7sbpBS
         VTrSBB/GFCXLF4vAaO3Hs5TscCgcvUInVTzezAmbN75HN72AT1eNtwhnOWfQPkvON/hd
         DXlA==
X-Gm-Message-State: AOAM531thvvEuGh4E4zOyRkpPSH59GsFD3FRn2QCLQKJvVk/hpXS6c1l
        Yqvo1WXSRL8wogmKeFAX93gloCIB8dzW7F0a5EjACNIH1kr5Klsl9i2PqvJ38eixNuwi25NC/p1
        7Lw6QP3ycIvCiCxc1p8vGHinIUb1seNylkcIf6sc/NnyG+1ryIDELbJGbb0WCPXe0
X-Received: by 2002:a17:907:9688:: with SMTP id hd8mr14722469ejc.314.1623676109560;
        Mon, 14 Jun 2021 06:08:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSuR5TvLWzrdc/KuigLP78IW6XFGRGmeZMVeaTSaRnuge2CljWyb3YxNbk7geVnp8TgtE+IQ==
X-Received: by 2002:a17:907:9688:: with SMTP id hd8mr14722429ejc.314.1623676109241;
        Mon, 14 Jun 2021 06:08:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id au11sm7520523ejc.88.2021.06.14.06.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 06:08:28 -0700 (PDT)
Subject: Re: [PATCH v3 0/4] KVM: x86: hyper-v: Conditionally allow SynIC with
 APICv/AVIC
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210609150911.1471882-1-vkuznets@redhat.com>
 <f294faba4e5d25aba8773f36170d1309236edd3b.camel@redhat.com>
 <87zgvsx5b1.fsf@vitty.brq.redhat.com>
 <d175c6ee68f357280166464bbacf6a468c3d9a74.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2f59a441-279c-d257-52ab-cdd3f2ee5704@redhat.com>
Date:   Mon, 14 Jun 2021 15:08:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d175c6ee68f357280166464bbacf6a468c3d9a74.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/06/21 11:51, Maxim Levitsky wrote:
> On Mon, 2021-06-14 at 09:40 +0200, Vitaly Kuznetsov wrote:
>> Maxim Levitsky <mlevitsk@redhat.com> writes:
>>
>>> On Wed, 2021-06-09 at 17:09 +0200, Vitaly Kuznetsov wrote:
>>>> Changes since v2:
>>>> - First two patches got merged, rebase.
>>>> - Use 'enable_apicv = avic = ...' in PATCH1 [Paolo]
>>>> - Collect R-b tags for PATCH2 [Sean, Max]
>>>> - Use hv_apicv_update_work() to get out of SRCU lock [Max]
>>>> - "KVM: x86: Check for pending interrupts when APICv is getting disabled"
>>>>    added.
>>>>
>>>> Original description:
>>>>
>>>> APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
>>>> SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
>>>> however, possible to track whether the feature was actually used by the
>>>> guest and only inhibit APICv/AVIC when needed.
>>>>
>>>> The series can be tested with the followin hack:
>>>>
>>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>>> index 9a48f138832d..65a9974f80d9 100644
>>>> --- a/arch/x86/kvm/cpuid.c
>>>> +++ b/arch/x86/kvm/cpuid.c
>>>> @@ -147,6 +147,13 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>>>>                                             vcpu->arch.ia32_misc_enable_msr &
>>>>                                             MSR_IA32_MISC_ENABLE_MWAIT);
>>>>          }
>>>> +
>>>> +       /* Dirty hack: force HV_DEPRECATING_AEOI_RECOMMENDED. Not to be merged! */
>>>> +       best = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO, 0);
>>>> +       if (best) {
>>>> +               best->eax &= ~HV_X64_APIC_ACCESS_RECOMMENDED;
>>>> +               best->eax |= HV_DEPRECATING_AEOI_RECOMMENDED;
>>>> +       }
>>>>   }
>>>>   EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
>>>>   
>>>> Vitaly Kuznetsov (4):
>>>>    KVM: x86: Use common 'enable_apicv' variable for both APICv and AVIC
>>>>    KVM: x86: Drop vendor specific functions for APICv/AVIC enablement
>>>>    KVM: x86: Check for pending interrupts when APICv is getting disabled
>>>>    KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in
>>>>      use
>>>>
>>>>   arch/x86/include/asm/kvm_host.h |  9 +++++-
>>>>   arch/x86/kvm/hyperv.c           | 51 +++++++++++++++++++++++++++++----
>>>>   arch/x86/kvm/svm/avic.c         | 14 ++++-----
>>>>   arch/x86/kvm/svm/svm.c          | 22 ++++++++------
>>>>   arch/x86/kvm/svm/svm.h          |  2 --
>>>>   arch/x86/kvm/vmx/capabilities.h |  1 -
>>>>   arch/x86/kvm/vmx/vmx.c          |  2 --
>>>>   arch/x86/kvm/x86.c              | 18 ++++++++++--
>>>>   8 files changed, 86 insertions(+), 33 deletions(-)
>>>>
>>>
>>> Hi!
>>>
>>> I hate to say it, but at least one of my VMs doesn't boot amymore
>>> with avic=1, after the recent updates. I'll bisect this soon,
>>> but this is likely related to this series.
>>>
>>> I will also review this series very soon.
>>>
>>> When the VM fails, it hangs on the OVMF screen and I see this
>>> in qemu logs:
>>>
>>> KVM: injection failed, MSI lost (Operation not permitted)
>>> KVM: injection failed, MSI lost (Operation not permitted)
>>> KVM: injection failed, MSI lost (Operation not permitted)
>>> KVM: injection failed, MSI lost (Operation not permitted)
>>> KVM: injection failed, MSI lost (Operation not permitted)
>>> KVM: injection failed, MSI lost (Operation not permitted)
>>>
>>
>> -EPERM?? Interesting... strace(1) may come handy...
> 
> 
> Hi Vitaly!
>   
> I spent all yesterday debugging this and I found out what is going on:
> (spoiler alert: hacks are bad)
> 
> The call to kvm_request_apicv_update was moved to a delayed work which is fine at first glance
> but turns out that we both don't notice that kvm doesn't allow to update the guest
> memory map from non vcpu thread which is what kvm_request_apicv_update does
> on AVIC.
>   
> The memslot update is to switch between regular r/w mapped dummy page
> which is not really used but doesn't hurt to be there, and between paging entry with
> reserved bits, used for MMIO, which AVIC sadly needs because it is written in the
> spec that AVIC's MMIO despite being redirected to the avic_vapic_bar, still needs a valid
> R/W mapping in the NPT, whose physical address is ignored.
> 
> So, in avic_update_access_page we have this nice hack:
>   
> if ((kvm->arch.apic_access_page_done == activate) ||
> 	    (kvm->mm != current->mm))
> 		goto out;
>   
> So instead of crashing this function just does nothing.
> So AVIC MMIO is still mapped R/W to a dummy page, but the AVIC itself
> is disabled on all vCPUs by kvm_request_apicv_update (with
> KVM_REQ_APICV_UPDATE request)
> 
> So now all guest APIC writes just disappear to that dummy
> page, and we have a guest that seems to run but can't really
> continue.
> 
> The -EPERM in the error message I reported, is just -1, returned by
> KVM_SIGNAL_MSI which is likely result of gross missmatch between
> state of the KVM's APIC registers and that dummy page which contains
> whatever the guest wrote there and what the guest thinks
> the APIC registers are.
> 
> I am curently thinking on how to do the whole thing with
> KVM's requests, I'll try to prepare a patch today.

I'll drop the last two patches in the series.

Paolo

