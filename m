Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B55C27C285
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 12:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgI2Kgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 06:36:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37017 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbgI2Kgg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 06:36:36 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601375793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I5YYFgfx5BlxcJjZ2anX8oHsy00ljGmpjltg0at7zMM=;
        b=QQDfjGisA0XIcKFESFkOTd8CLfVzkgUWa7MauPYhNZHx6dSY+TObjHIhRJdELH3UHorVal
        8NgcJZo9noLMiKOCsxAH87LQpFpHTIj5kT8eo00pAvk9ZrgYiBE3dINDMdTwH8ocjmtoRk
        FpY6UI3svOrj3IknL+eBAgGtCGvWNBk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-7KKxUMVoN6mAZ0Dyfkg89A-1; Tue, 29 Sep 2020 06:36:31 -0400
X-MC-Unique: 7KKxUMVoN6mAZ0Dyfkg89A-1
Received: by mail-wm1-f69.google.com with SMTP id x6so1666084wmi.1
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 03:36:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=I5YYFgfx5BlxcJjZ2anX8oHsy00ljGmpjltg0at7zMM=;
        b=Q3l/08XB3Xt92ctJqz7QE7ErrYD4//9dK2S40qL9cz8S9NDqomj79ucH1QW5USNI+r
         u7MF0xBtrGIjhHw0SJ6u9OFGRh3ViUc3WY4y8NaUzw5lk6SX0GOSCEg8k7JtXQNQizav
         /CcLqA2sZ8k+hDprDFWAsG5mJ/9jSk/aEPAS6n/6fBV4N3vfckP+AWLKH6igJuEJFB1K
         vMxV/0pAWJNZciymfVVf4IFpHZGBdAMdaBcQ/OvRw35uPcl9C2HkdQ7Z0nr/4gMmpExm
         ni4FW28UuwsPIva4aI2TbXkj5QDn3+fGN6IXp+1FUuYVBKx1TrmUfVnXrDpbKGRjDEjO
         FuEg==
X-Gm-Message-State: AOAM533mskkPi/gB6HnelFAII8Pd5lmH+PdrORMNddCr087qMonuUCYS
        OQmOYZgWYM9Qupbmf0QPpY8qHLt4LIecwj7l2WsGW4LdY8An7CqXxgkTHLrVpRMZS9y9QNUF61d
        4/ZbN1v1xbfqo
X-Received: by 2002:a7b:c401:: with SMTP id k1mr3743597wmi.120.1601375790321;
        Tue, 29 Sep 2020 03:36:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1hBlibSkko/LAft8fxp3KWccCLsb2lvaX6Rp2ClMvNy4t8LCP+r9kdfFAUVwpGSAiYf7VwQ==
X-Received: by 2002:a7b:c401:: with SMTP id k1mr3743568wmi.120.1601375790047;
        Tue, 29 Sep 2020 03:36:30 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m12sm4738035wml.38.2020.09.29.03.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 03:36:29 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] KVM: x86: hyper-v: always advertise HV_STIMER_DIRECT_MODE_AVAILABLE
In-Reply-To: <ded79131-bef1-cb56-68ca-d2bc596a4425@redhat.com>
References: <20200924145757.1035782-1-vkuznets@redhat.com> <20200924145757.1035782-5-vkuznets@redhat.com> <ded79131-bef1-cb56-68ca-d2bc596a4425@redhat.com>
Date:   Tue, 29 Sep 2020 12:36:28 +0200
Message-ID: <875z7wdg43.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 24/09/20 16:57, Vitaly Kuznetsov wrote:
>> HV_STIMER_DIRECT_MODE_AVAILABLE is the last conditionally set feature bit
>> in KVM_GET_SUPPORTED_HV_CPUID but it doesn't have to be conditional: first,
>> this bit is only an indication to userspace VMM that direct mode stimers
>> are supported, it still requires manual enablement (enabling SynIC) to
>> work so no VMM should just blindly copy it to guest CPUIDs. Second,
>> lapic_in_kernel() is a must for SynIC. Expose the bit unconditionally.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/hyperv.c | 8 +-------
>>  1 file changed, 1 insertion(+), 7 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>> index 6da20f91cd59..503829f71270 100644
>> --- a/arch/x86/kvm/hyperv.c
>> +++ b/arch/x86/kvm/hyperv.c
>> @@ -2028,13 +2028,7 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>>  			ent->ebx |= HV_DEBUGGING;
>>  			ent->edx |= HV_X64_GUEST_DEBUGGING_AVAILABLE;
>>  			ent->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
>> -
>> -			/*
>> -			 * Direct Synthetic timers only make sense with in-kernel
>> -			 * LAPIC
>> -			 */
>> -			if (lapic_in_kernel(vcpu))
>> -				ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
>> +			ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
>>  
>>  			break;
>>  
>> 
>
> Sorry for the late reply.  I think this is making things worse.  It's
> obviously okay to add a system KVM_GET_SUPPORTED_HV_CPUID, and I guess
> it makes sense to have bits in there that require to enable a
> capability.  For example, KVM_GET_SUPPORTED_CPUID has a couple bits such
> as X2APIC, that we return even if they require in-kernel irqchip.
>
> For the vCPU version however we should be able to copy the returned
> leaves to KVM_SET_CPUID2, meaning that unsupported features should be
> masked.

What I don't quite like about exposing HV_STIMER_DIRECT_MODE_AVAILABLE
conditionally is that we're requiring userspace to have a certain
control flow: first, it needs to create irqchip and only then call
KVM_GET_SUPPORTED_HV_CPUID or it won't know that
HV_STIMER_DIRECT_MODE_AVAILABLE is supported. 

Also, are you only concerned about HV_STIMER_DIRECT_MODE_AVAILABLE? E.g.
PATCH3 of this series is somewhat similar, it exposes eVMCS even when
the corresponding CAP wasn't enabled.

While I slightly prefer to get rid of this conditional feature exposure
once and for all, I don't really feel very strong about it. We can have
the system ioctl which always exposes all supported features and vCPU
version which only exposes what is currently enabled. We would, however,
need to preserve some inconsistency as a legacy: e.g. SynIC bits are now
exposed unconditionally, even before KVM_CAP_HYPERV_SYNIC[2] is enabled
(and if we change that we will break at least QEMU).

-- 
Vitaly

