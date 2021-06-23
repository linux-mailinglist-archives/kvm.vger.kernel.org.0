Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF2B3B1AFB
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 15:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhFWNYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 09:24:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230263AbhFWNYJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 09:24:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624454511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rp1O/CPJY4l8FkaCBOTzb4x+CQmYngEXaAEL0v+9OoY=;
        b=J5eFVMDN0aGa5+iTV1JLsHv9FDurQt0Ky3XcRe9F3q60ZOPnUVURWPC5XCs4w093Irxt8z
        iHBpp3yzgJgYlFGIxeH8m335yKdUVct95m9gTHR8uJqL+wSR+qMtt2n1lfIhCLLuBbmksH
        e4SfUM3Y0X0fzgcHV/fhRBq6OV9//iM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-EXG66mM2NPGY60g2UQfOsQ-1; Wed, 23 Jun 2021 09:21:50 -0400
X-MC-Unique: EXG66mM2NPGY60g2UQfOsQ-1
Received: by mail-ej1-f71.google.com with SMTP id ci22-20020a170906c356b0290492ca430d87so966921ejb.14
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 06:21:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Rp1O/CPJY4l8FkaCBOTzb4x+CQmYngEXaAEL0v+9OoY=;
        b=Xf6eBvPuQ2N86B0PvvMs5oftD+BKIqk5V1Y/ogGHQZxXdWqoK6Laix4OYHuGrskop9
         /xF+zF2JYiLFUXs7cDe8dZHjYTfiQny5eOvrYqPwDIJu5ukYJMev/hTx784U3K+igtqm
         zRouCYC+X7fvl9xAPhtS1U9hbONoE7+JTvKo5HiQaeqgVyULXS/aDzuiZxl1ngoLAHWv
         rmDVoxBOqhSuEWt7//9rAKgoUZkJ5dGmnVUBZ1Qf/JfG3C2aLeh+57A4ML61BYORP0A4
         s9aVw3fB1j6SeEW4u99JBd1m7YcxRCKv8d0AMFmqb065F3ex5dvKyvme4oe2eC0yuMWR
         sFnA==
X-Gm-Message-State: AOAM531+coJ02eAVrsaU5RVdJGBQeSmMPMJfbaNDN1WQoYUrugvbzqp1
        3ACAP0RQUWk5qtetqOke7tE7a4D57+lDbFm6VYJG+v8Mly1ad6PHpJb06B3OUJjXTomUmlMEp7v
        HiW9gCZk7lAmE
X-Received: by 2002:aa7:d799:: with SMTP id s25mr12305636edq.161.1624454509049;
        Wed, 23 Jun 2021 06:21:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNlMRKDyVnNR+FKglMhJfZuFx+DjO1x2/9lay/i/uFnPMprFz11Nu8jKDmqkQkNrVWKQahmg==
X-Received: by 2002:aa7:d799:: with SMTP id s25mr12305593edq.161.1624454508854;
        Wed, 23 Jun 2021 06:21:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ml22sm5967065ejb.93.2021.06.23.06.21.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 06:21:48 -0700 (PDT)
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20210623074427.152266-1-vkuznets@redhat.com>
 <a3918bfa-7b4f-c31a-448a-aa22a44d4dfd@redhat.com>
 <53a9f893cb895f4b52e16c374cbe988607925cdf.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC] KVM: nSVM: Fix L1 state corruption upon return from
 SMM
Message-ID: <01564b34-2476-2098-7ec8-47336922afda@redhat.com>
Date:   Wed, 23 Jun 2021 15:21:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <53a9f893cb895f4b52e16c374cbe988607925cdf.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 15:01, Maxim Levitsky wrote:
> I did some homework on this now and I would like to share few my thoughts on this:
> 
> First of all my attention caught the way we intercept the #SMI
> (this isn't 100% related to the bug but still worth talking about IMHO)
> 
> A. Bare metal: Looks like SVM allows to intercept SMI, with SVM_EXIT_SMI,
>   with an intention of then entering the BIOS SMM handler manually using the SMM_CTL msr.

... or just using STGI, which is what happens for KVM.  This is in the 
manual: "The hypervisor may respond to the #VMEXIT(SMI) by executing the 
STGI instruction, which causes the pending SMI to be taken immediately".

It *should* work for KVM to just not intercept SMI, but it adds more 
complexity for no particular gain.

>   On bare metal we do set the INTERCEPT_SMI but we emulate the exit as a nop.
>   I guess on bare metal there are some undocumented bits that BIOS set which
>   make the CPU to ignore that SMI intercept and still take the #SMI handler,
>   normally but I wonder if we could still break some motherboard
>   code due to that.
> 
> B. Nested: If #SMI is intercepted, then it causes nested VMEXIT.
>   Since KVM does enable SMI intercept, when it runs nested it means that all SMIs
>   that nested KVM gets are emulated as NOP, and L1's SMI handler is not run.

No, this is incorrect.  Note that svm_check_nested_events does not clear 
smi_pending the way vmx_check_nested_events does it for nmi_pending.  So 
the interrupt is still there and will be injected on the next STGI.

Paolo

> 
> About the issue that was fixed in this patch. Let me try to understand how
> it would work on bare metal:
> 
> 1. A guest is entered. Host state is saved to VM_HSAVE_PA area (or stashed somewhere
>    in the CPU)
> 
> 2. #SMI (without intercept) happens
> 
> 3. CPU has to exit SVM, and start running the host SMI handler, it loads the SMM
>      state without touching the VM_HSAVE_PA runs the SMI handler, then once it RSMs,
>      it restores the guest state from SMM area and continues the guest
> 
> 4. Once a normal VMexit happens, the host state is restored from VM_HSAVE_PA
> 
> So host state indeed can't be saved to VMC01.
> 
> I to be honest think would prefer not to use the L1's hsave area but rather add back our
> 'hsave' in KVM and store there the L1 host state on the nested entry always.
> 
> This way we will avoid touching the vmcb01 at all and both solve the issue and
> reduce code complexity.
> (copying of L1 host state to what basically is L1 guest state area and back
> even has a comment to explain why it (was) possible to do so.
> (before you discovered that this doesn't work with SMM).
> 
> Thanks again for fixing this bug!
> 
> Best regards,
> 	Maxim Levitsky
> 

