Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72FF3648E2
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 19:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbhDSROx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 13:14:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24960 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233867AbhDSROw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 13:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618852462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eylKqSPDKz9S5T2Q/ChqqD4u0vbwKNM9iAmrwjM6+PU=;
        b=SOhcYzv4cHGXbddA4ZppMYm0ObHi9FiBC4lkjQpBt63BiaaaVtU3HjJ3mXIhlzg1ba5Tgk
        VfgSOTKqasDqGHQmAzwJ4kUdUenuCDioXeYM1ONnbGZNe0+EAu/hQL4LTE+uqk5cGkRn3Q
        jqHc0wLRZHQkmxGtR6NfRQgM2Kozryk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-BLI75tolMTW0MovBWvvy1w-1; Mon, 19 Apr 2021 13:14:17 -0400
X-MC-Unique: BLI75tolMTW0MovBWvvy1w-1
Received: by mail-ed1-f72.google.com with SMTP id f1-20020a0564021941b02903850806bb32so5618518edz.9
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 10:14:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eylKqSPDKz9S5T2Q/ChqqD4u0vbwKNM9iAmrwjM6+PU=;
        b=g0lPHCoIrAjyBIP/c6/Qa97WLfgn4Tepid4UAGSUWl20zP1hDtkIcMtQKNRWIhOwAJ
         4oahi4ajvKvbPUOWTcKPsnw2ZXgSD6gGedfSNS426J7Xx5I8LQKNOeVCtB+Gs9+vYZN0
         +SRbkOGbNSeXneQvQXzKHBiY+Zza2pRjHRzTwZzzukIVY6GxcZQ4NUcHoaLtJcOUnSrh
         BBWYsrFRA3716Mokqc/E+Nd0iHmZdUEFI4x+74GWxe+nzOhZrJPV5XtrWfscqNep8i1Z
         cXpp7Zdr4QmdGXZx9nhFNw3ZXN/m2MPrLK26COj32v2m9vAiZtn/5eYid1bUKSBhUmVE
         M4cg==
X-Gm-Message-State: AOAM531QZ2797H95TtT1ex0Rp/Z6BemrePC94uvkPKnYIjQQSSCwJqU8
        tTHi6WidrpEzwB54Fs3cV/90Q9JGmCabU7RcUDSjfvnRSFYufyYUCAFfS9GAJWdZWTPEcBB+2Ro
        FSrpe7TO6tBsu
X-Received: by 2002:a17:906:70c4:: with SMTP id g4mr10585011ejk.443.1618852456748;
        Mon, 19 Apr 2021 10:14:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyz7HtCdHIFmzmfa3Pq5QOAbWngw9gcL3kk+4xm7U7h633rYwfO6lJbpER/0gieLXM52ttO2g==
X-Received: by 2002:a17:906:70c4:: with SMTP id g4mr10584990ejk.443.1618852456585;
        Mon, 19 Apr 2021 10:14:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q2sm10801191eje.24.2021.04.19.10.14.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 10:14:15 -0700 (PDT)
Subject: Re: [PATCH v5 10/11] KVM: VMX: Enable SGX virtualization for SGX1,
 SGX2 and LC
To:     Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org, bp@alien8.de,
        jarkko@kernel.org, dave.hansen@intel.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com
References: <cover.1618196135.git.kai.huang@intel.com>
 <a99e9c23310c79f2f4175c1af4c4cbcef913c3e5.1618196135.git.kai.huang@intel.com>
 <9f568584-8b09-afe6-30a1-cbe280749f5d@redhat.com>
 <3d376fef419077376eecb017ab494ba7ffc393a7.camel@intel.com>
 <YH2e1lIckOBY2OGa@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <acff71e3-4a38-b858-551c-8b34cbf344af@redhat.com>
Date:   Mon, 19 Apr 2021 19:14:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YH2e1lIckOBY2OGa@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/04/21 17:16, Sean Christopherson wrote:
> On Mon, Apr 19, 2021, Kai Huang wrote:
>> On Sat, 2021-04-17 at 16:11 +0200, Paolo Bonzini wrote:
>>> On 12/04/21 06:21, Kai Huang wrote:
>>>> @@ -4377,6 +4380,15 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>>>>    	if (!vcpu->kvm->arch.bus_lock_detection_enabled)
>>>>    		exec_control &= ~SECONDARY_EXEC_BUS_LOCK_DETECTION;
>>>>    
>>>>
>>>> +	if (cpu_has_vmx_encls_vmexit() && nested) {
>>>> +		if (guest_cpuid_has(vcpu, X86_FEATURE_SGX))
>>>> +			vmx->nested.msrs.secondary_ctls_high |=
>>>> +				SECONDARY_EXEC_ENCLS_EXITING;
>>>> +		else
>>>> +			vmx->nested.msrs.secondary_ctls_high &=
>>>> +				~SECONDARY_EXEC_ENCLS_EXITING;
>>>> +	}
>>>> +
>>>
>>> This is incorrect, I've removed it.  The MSRs can only be written by
>>> userspace.
> 
> vmx_compute_secondary_exec_control() violates that left, right, and center, it's
> just buried down in vmx_adjust_secondary_exec_control().  This is an open coded
> version of that helper, sans the actual update to exec_control since ENCLS needs
> to be conditionally intercepted even when it's exposed to the guest.

Hmm, that's true.  I'll place back the version that you had.

Paolo

>>> If SGX is disabled in the guest CPUID, nested_vmx_exit_handled_encls can
>>> just do:
>>>
>>> 	if (!guest_cpuid_has(vcpu, X86_FEATURE_SGX) ||
>>> 	    !nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING))
>>> 		return false;
>>>
>>> and the useless ENCLS exiting bitmap in vmcs12 will be ignored.
>>>
>>> Paolo
>>>
>>
>> Thanks for queuing this series!
>>
>> Looks good to me. However if I read code correctly, in this way a side effect would be
>> vmx->nested.msrs.secondary_ctls_high will always have SECONDARY_EXEC_ENCLS_EXITING bit
>> set, even SGX is not exposed to guest, which means a guest can set this even SGX is not
>> present, but I think it is OK since ENCLS exiting bitmap in vmcs12 will be ignored anyway
>> in nested_vmx_exit_handled_encls() as you mentioned above.
>>
>> Anyway, I have tested this code and it works at my side (by creating L2 with SGX support
>> and running SGX workloads inside it).
>>
>> Sean, please also comment if you have any.
>>
>>
> 

