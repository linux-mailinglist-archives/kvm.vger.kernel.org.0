Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA6C370681
	for <lists+kvm@lfdr.de>; Sat,  1 May 2021 11:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhEAJB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 May 2021 05:01:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230117AbhEAJB5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 1 May 2021 05:01:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619859666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TDG+TDZoewmymKPtgSjz1RxtoXK5cpceEnvgfqjHUWI=;
        b=GHk3wSIugvLLA78by5h/0xx29IBcp2l6hT8fAk9kgNtnuxs1N4APLL+LRGsf1gSatr0W6r
        jHQLNsOjOa6OUpPoCv5sHBKdum2rNd2FHe+EF0oVTG1HIeLP2BSv2K+ZWEPMFKbYuht9BG
        /OVjXvtZosnqfZ2rRTc1AIvazhxh12s=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-CHvxoGiYM_eTsxbbcw7sgQ-1; Sat, 01 May 2021 05:01:05 -0400
X-MC-Unique: CHvxoGiYM_eTsxbbcw7sgQ-1
Received: by mail-ej1-f69.google.com with SMTP id k9-20020a17090646c9b029039d323bd239so72005ejs.16
        for <kvm@vger.kernel.org>; Sat, 01 May 2021 02:01:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TDG+TDZoewmymKPtgSjz1RxtoXK5cpceEnvgfqjHUWI=;
        b=M0twNbh+L9NFYBBWOtCmFpM67EEXAuPowyvHqLZUSo3kSAu8R3d6Eka4hJgxmbhHbt
         X0vg5oB/FPhPxxtt29uDuZyWwe54KFq98JHBn/hxJgHLnpuouQQue4v3xx1kMOCnrcWQ
         Uku1tkzCzRyPSoRbydfnSCuCPFdX8nFzYUavfMEMvRu1Bk5UWa39nQlLFaiZGCj0Ho5r
         U5z1jpejC3HI3HN39Ua7IsMn9QFuD/1GpSnJFqYZIhBTJfw8LJKz5ZPnIVYLXluBgUfW
         X6End9BNUs2yJsHq9cs7RHdc0ARFAWL9zXFUM97Mtfsv3bCgb5XZ8aFqxfN+ABJfG/xK
         ONag==
X-Gm-Message-State: AOAM5320vr9N60owzeO6KGO9p9UhOq5EOc1xjpSMlUjEfbzByPn1AINo
        w613my5FbNjvpCflD8vSoVhRRbGgBPPty3mVbBRPppFcWenwj4ptYm0l2tsEvZEQ+awySe391Md
        rWiLgfg3+pz1K
X-Received: by 2002:a05:6402:4242:: with SMTP id g2mr10269018edb.329.1619859663762;
        Sat, 01 May 2021 02:01:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytu+AWS652si3LL4P4HnFVQgjMk+Zb3p7DXAj3txdYvQo50PY7VVni+IJKb5XffL2eD5WGaA==
X-Received: by 2002:a05:6402:4242:: with SMTP id g2mr10269003edb.329.1619859663500;
        Sat, 01 May 2021 02:01:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id dj17sm1391672edb.7.2021.05.01.02.01.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 May 2021 02:01:02 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        srutherford@google.com, joro@8bytes.org, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, ashish.kalra@amd.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org
References: <20210429104707.203055-1-pbonzini@redhat.com>
 <20210429104707.203055-3-pbonzini@redhat.com> <YIxkTZsblAzUzsf7@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c4bf8a05-ec0d-9723-bb64-444fe1f088b5@redhat.com>
Date:   Sat, 1 May 2021 11:01:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YIxkTZsblAzUzsf7@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/21 22:10, Sean Christopherson wrote:
> On Thu, Apr 29, 2021, Paolo Bonzini wrote:
>> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
>> index 57fc4090031a..cf1b0b2099b0 100644
>> --- a/Documentation/virt/kvm/msr.rst
>> +++ b/Documentation/virt/kvm/msr.rst
>> @@ -383,5 +383,10 @@ MSR_KVM_MIGRATION_CONTROL:
>>   data:
>>           This MSR is available if KVM_FEATURE_MIGRATION_CONTROL is present in
>>           CPUID.  Bit 0 represents whether live migration of the guest is allowed.
>> +
>>           When a guest is started, bit 0 will be 1 if the guest has encrypted
>> -        memory and 0 if the guest does not have encrypted memory.
>> +        memory and 0 if the guest does not have encrypted memory.  If the
>> +        guest is communicating page encryption status to the host using the
>> +        ``KVM_HC_PAGE_ENC_STATUS`` hypercall, it can set bit 0 in this MSR to
>> +        allow live migration of the guest.  The MSR is read-only if
>> +        ``KVM_FEATURE_HC_PAGE_STATUS`` is not advertised to the guest.
> 
> I still don't get the desire to tie MSR_KVM_MIGRATION_CONTROL to PAGE_ENC_STATUS
> in any way shape or form.  I can understand making it read-only or dropping
> writes if it's not intercepted by userspace, but making it read-only for
> non-encrypted guests makes it useful only for encrypted guests, which defeats
> the purpose of genericizing the MSR.

Yeah, I see your point.  On the other hand by making it unconditionally 
writable we must implement the writability in KVM, because a read-only 
implementation would not comply with the spec.

>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index e9c40be9235c..0c2524bbaa84 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3279,6 +3279,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   		if (!guest_pv_has(vcpu, KVM_FEATURE_MIGRATION_CONTROL))
>>   			return 1;
>>   
>> +		/*
>> +		 * This implementation is only good if userspace has *not*
>> +		 * enabled KVM_FEATURE_HC_PAGE_ENC_STATUS.  If userspace
>> +		 * enables KVM_FEATURE_HC_PAGE_ENC_STATUS it must set up an
>> +		 * MSR filter in order to accept writes that change bit 0.
>> +		 */
>>   		if (data != !static_call(kvm_x86_has_encrypted_memory)(vcpu->kvm))
>>   			return 1;
> 
> This behavior doesn't match the documentation.
> 
>    a. The MSR is not read-only for legacy guests since they can write '0'.
>    b. The MSR is not read-only if KVM_FEATURE_HC_PAGE_STATUS isn't advertised,
>       a guest with encrypted memory can write '1' regardless of whether userspace
>       has enabled KVM_FEATURE_HC_PAGE_STATUS.

Right, I should have said "not changeable" rather than "read-only".

>    c. The MSR is never fully writable, e.g. a guest with encrypted memory can set
>       bit 0, but not clear it.  This doesn't seem intentional?

It is intentional, clearing it would mean preserving the value in the 
kernel so that userspace can read it.

So... I don't know, all in all having both the separate CPUID and the 
userspace implementation reeks of overengineering.  It should be either 
of these:

- separate CPUID bit, MSR unconditionally writable and implemented in 
KVM.  Userspace is expected to ignore the MSR value for encrypted guests 
unless KVM_FEATURE_HC_PAGE_STATUS is exposed.  Userspace should respect 
it even for unencrypted guests (not a migration-DoS vector, because 
userspace can just not expose the feature).

- make it completely independent from migration, i.e. it's just a facet 
of MSR_KVM_PAGE_ENC_STATUS saying whether the bitmap is up-to-date.  It 
would use CPUID bit as the encryption status bitmap and have no code at 
all in KVM (userspace needs to set up the filter and implement everything).

At this point I very much prefer the latter, which is basically Ashish's 
earlier patch.

Paolo

> Why not simply drop writes?  E.g.
> 
> 		if (data & ~KVM_MIGRATION_READY)
> 			return 1;
> 		break;
> 
> And then do "msr->data = 0;" in the read path.  That's just as effective as
> making the MSR read-only to force userspace to intercept the MSR if it wants to
> do anything useful with the information, and it's easy to document.

