Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C9042C492
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 17:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhJMPOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 11:14:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45417 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231906AbhJMPO3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 11:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634137945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jevHWv3I+jeDgbOR89zqbg54Wz1Hnd03eixogAhyAP0=;
        b=RUNB3fxMmDUd8jwcvvzgGtgsdN2uHG+dM5vE4RmivGKe/wq1s+MCjqmGW1qLCTR39qSlCS
        PbA4QRFVMOEtcOvXqTUtibeJz9Q6NxJ/K1uYupoX8vDaPWvSTuSSqE1tMNJN87aUE8Dzgo
        yI1H0p9cROTD2+hE6cBz8Dd5JEEJuXk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-aoCU68b1P86ERbaoksHS_Q-1; Wed, 13 Oct 2021 11:12:24 -0400
X-MC-Unique: aoCU68b1P86ERbaoksHS_Q-1
Received: by mail-ed1-f70.google.com with SMTP id f4-20020a50e084000000b003db585bc274so2501778edl.17
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 08:12:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jevHWv3I+jeDgbOR89zqbg54Wz1Hnd03eixogAhyAP0=;
        b=QIsM9dzkTwro6DHkgjmbLKE5kIWVjZCzWZCaV8VJ/WEltaoh3KiXv9LTezRKE5fT2i
         02ldsD76uAbGDjiJ2cUR7xe56JQIv+Y8u4Ybr5QXxDDaw2b1OrVMLdepnMu5iA3qJ9YZ
         XH0pSvcl+Nf+pwKTSKBs13YQQxBvDGm2LJak+fdQPDb/Cxne0nNDBH/JWLerRZ7QkXnc
         R4onnted/qrkyu6oPrviOLbVqRvmlsulQOqw5BmayNPUj8YIzTFcIngBLLKBa/zQUhU/
         00MA7cyp42Cl2r5GX1eC/Wb/71XhpdszCIf/fmr4tPn05cKq3rx4XYbO8nI7F0lMMHH9
         coQw==
X-Gm-Message-State: AOAM532GZCgWxAaRAJc0We5fMfW5Hes3DLszoCR/T8HHl7gTs233lWbl
        k0xo3jyGxMDW2X0KJt2aEJSaAnK1kC6TpNQHDgyXqualX1KmC76B/aD37cE/BLetwatoNdMCjvK
        vqBy58qy2oRTq
X-Received: by 2002:a17:907:1dd2:: with SMTP id og18mr41271ejc.267.1634137943374;
        Wed, 13 Oct 2021 08:12:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwae9xhG7EGdZA2V4vnuNuXRMDzZv0Q1hHuqm+C+/4peepodprFKI0tHKPW8yWjmmtYrS29Qw==
X-Received: by 2002:a17:907:1dd2:: with SMTP id og18mr41244ejc.267.1634137943141;
        Wed, 13 Oct 2021 08:12:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y4sm6907507ejr.101.2021.10.13.08.12.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 08:12:22 -0700 (PDT)
Message-ID: <9adb43fb-182f-dffb-1fde-ae7e9610a344@redhat.com>
Date:   Wed, 13 Oct 2021 17:12:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [patch 14/31] x86/fpu: Replace KVMs homebrewn FPU copy from user
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.129308001@linutronix.de> <YWW/PEQyQAwS9/qv@zn.tnic>
 <YWbz0ayrpoxbBo5U@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YWbz0ayrpoxbBo5U@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/21 16:57, Sean Christopherson wrote:
>>> +int fpu_copy_kvm_uabi_to_vcpu(struct fpu *fpu, const void *buf, u64 xcr0,
>>> +			      u32 *vpkru)
>> Right, except that there's no @vcpu in the args of that function. I
>> guess you could call it
>>
>> fpu_copy_kvm_uabi_to_buf()
>>
>> and that @buf can be
>>
>> vcpu->arch.guest_fpu
> But the existing @buf is the userspace pointer, which semantically makes sense
> because the userspace pointer is the "buffer" and the destination @fpu (and @prku)
> is vCPU state, not a buffer.
> 
> That said, I also struggled with the lack of @vcpu.  What about prepending vcpu_
> to fpu and to pkru?  E.g.
> 
>    int fpu_copy_kvm_uabi_to_vcpu(struct fpu *vcpu_fpu, const void *buf, u64 xcr0,
>    				u32 *vcpu_pkru)
> 

It doesn't matter much that the source is somehow related to a vCPU, as 
long as the FPU is concerned.  If anything I would even drop the "v" 
from vpkru, but that's really nitpicking.

Paolo

