Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D892FAB87
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 21:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388959AbhARUcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 15:32:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388828AbhARUcH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 15:32:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611001840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yqbvFErNC41ofhFoCIqH0jJ0VT1UHbY55ftD8sHsSmY=;
        b=KYdkPPD4Z5eriKQfkHOrXu88nramTi5iFqK0gg4Qe5UQAD4h90N59NjpfW16I5Gy/jMmLO
        zbtEOvc/5PCzEbYaZ2kH+j0bXV93Ya3mGaCDtgDYrMJsmX0mAs89zJ1yrnepYUNX38db2W
        MdiQgB+3DLCSlMkkl0bQyte/jRXM81M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-hu61zzItM0uMQ0IJcP_mjg-1; Mon, 18 Jan 2021 15:30:39 -0500
X-MC-Unique: hu61zzItM0uMQ0IJcP_mjg-1
Received: by mail-ed1-f70.google.com with SMTP id m16so8274737edd.21
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 12:30:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yqbvFErNC41ofhFoCIqH0jJ0VT1UHbY55ftD8sHsSmY=;
        b=irSPR91gEG2oUZIbGXEZVHfJj4olzYxGMISbRMPFGbpLoY5YF3n/ZwzLwyLCIZ96CY
         bbDBtFx/LSOer0T0PFGJSz7Fr+pH94DHl+TF7nFbphbPrdIKUcFLqss6JFIhEcYRVAOo
         2Wx7+wIffil0GVROvOx3um0joPx63lKLmxw3mtOSmGgl1RacnTmxOAM/H50za3Ze5oT1
         5Z8KHZKjAIk3S2FGp1vxDzoUtjVmib6z4CvaoyxnX1qRq6YUyrw1qPunC/m6nJ4pbANI
         1E5FLbKZtHNjm1fX8qQYw+5dYtVMzDYdsyx2bMCVHO594xIHnqVyWt0H/9Mo9lCvz6Px
         cPAw==
X-Gm-Message-State: AOAM531cDcEWAh4RyDvnx9JwWHY2KNTlqft308OUlZzZ4HU/JeIKkl26
        RWJIFLrxXYPsV5bjkJY6NSXdlrOrICanzuX90vCXrsdwHZtMnpHByaMO6ro/ggboLMu6NiedOei
        Kj5xPTE4v8yOF
X-Received: by 2002:a17:906:f988:: with SMTP id li8mr953182ejb.84.1611001837770;
        Mon, 18 Jan 2021 12:30:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxg5krC67ubd8S/V4gd8xzdojPqRghoeT2iGz9bOd2FzH0hKKFUekA32nKlrNmtiIL8GX9RnQ==
X-Received: by 2002:a17:906:f988:: with SMTP id li8mr953172ejb.84.1611001837533;
        Mon, 18 Jan 2021 12:30:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a22sm8077675edv.67.2021.01.18.12.30.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 12:30:36 -0800 (PST)
Subject: Re: [PATCH] x86/sev: Add AMD_SEV_ES_GUEST Kconfig for including
 SEV-ES support
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210116002517.548769-1-seanjc@google.com>
 <d4deb3ba-5c72-f61c-5040-0571822297c6@redhat.com>
 <20210118202611.GH30090@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2262feb0-830e-1e05-d81b-031d54cf6853@redhat.com>
Date:   Mon, 18 Jan 2021 21:30:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210118202611.GH30090@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/01/21 21:26, Borislav Petkov wrote:
> On Mon, Jan 18, 2021 at 06:59:38PM +0100, Paolo Bonzini wrote:
>> On 16/01/21 01:25, Sean Christopherson wrote:
>>>
>>> @@ -1527,12 +1527,14 @@ config AMD_MEM_ENCRYPT
>>>   	select DYNAMIC_PHYSICAL_MASK
>>>   	select ARCH_USE_MEMREMAP_PROT
>>>   	select ARCH_HAS_FORCE_DMA_UNENCRYPTED
>>> -	select INSTRUCTION_DECODER
>>>   	help
>>>   	  Say yes to enable support for the encryption of system memory.
>>>   	  This requires an AMD processor that supports Secure Memory
>>>   	  Encryption (SME).
>>> +	  This also enables support for running as a Secure Encrypted
>>> +	  Virtualization (SEV) guest.
>>> +
>>>   config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
>>>   	bool "Activate AMD Secure Memory Encryption (SME) by default"
>>>   	default y
>>> @@ -1547,6 +1549,15 @@ config AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT
>>>   	  If set to N, then the encryption of system memory can be
>>>   	  activated with the mem_encrypt=on command line option.
>>> +config AMD_SEV_ES_GUEST
>>> +	bool "AMD Secure Encrypted Virtualization - Encrypted State (SEV-ES) Guest support"
>>> +	depends on AMD_MEM_ENCRYPT
>>> +	select INSTRUCTION_DECODER
>>> +	help
>>> +	  Enable support for running as a Secure Encrypted Virtualization -
>>> +	  Encrypted State (SEV-ES) Guest.  This enables SEV-ES boot protocol
>>> +	  changes, #VC handling, SEV-ES specific hypercalls, etc...
>>> +
>>
>> Queued, thanks.
> 
> Say, Paolo, why are you queuing a patch which goes through tip, if at all?

Right you are, unqueued.  I would have caught the mistake before 
actually crystallizing the hashes, but thanks for noticing!

Sean, please send a v2 that removes the help change for AMD_MEM_ENCRYPT, 
too.

Thanks,

Paolo

