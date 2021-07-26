Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76103D592C
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 14:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbhGZL3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 07:29:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233763AbhGZL33 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 07:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627301397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dR3iMn5XpVkez/+wHkSECFYP9sgFxn9jkjpt8nIR5Uc=;
        b=bDZHSofPgtZaqb51+KbSQkDtLS5KMarZZFI65RhXPkP8M91OXFz8j+dmvxC+43nnEu2lJf
        89tX/FLOv90NrcGyr2xMq6VCpH6ZyhXdNV1RwYCD+m1GwlFDEcmR8xXhF4JcedZXH2E6og
        eyWWR/KhutzFpzRhKafiObPt6KKVEJQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-1ctmpAOSNz-AR7BSf5kTiw-1; Mon, 26 Jul 2021 08:09:56 -0400
X-MC-Unique: 1ctmpAOSNz-AR7BSf5kTiw-1
Received: by mail-ej1-f72.google.com with SMTP id lu19-20020a170906fad3b029058768348f55so75680ejb.12
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 05:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dR3iMn5XpVkez/+wHkSECFYP9sgFxn9jkjpt8nIR5Uc=;
        b=IRQA4wbasaUfob/um44+AyOKXMYpxDhdlPmiyzW8BWIYVVYICnWPkaC8KufmXXiKH/
         fYsDyXD2AoZZdjkA5+gcDrBHLCPUX4mrQ+3zkwisXm90aiiLrzOxB/Z9iHiaFZqp7llD
         ypN3XRWcgnV0WCSUb0ZrLMdioWhSQfXTT6mNSW6L2M8tMud8EefsUoyXhqn4v8Tnifm6
         fZQakCc4zAoaqMvVvJm97Vova7ubARBMsxhOln32x0D6DmSKH6emJpWGu93fvKrWVRWz
         2qlrpMho1DfTqFJMnj3begcV0sV5ttGbwNcBRQ761Cenx3twovyvdTfkaStqvk8UQP/Q
         HKqw==
X-Gm-Message-State: AOAM531xwZI+ixqJdfHtnRShSqPMQlVOEHXFI/0kYOFKNGBHzEzOkFbe
        XbPnrKdpvehOR+7vJvhstF5qK+sRnilvOwnbNBRHnGJmMsTeS7k1DdVZoYl/8b6aoLEknDpDSI/
        TfE0yrL7tpiXz
X-Received: by 2002:a05:6402:278e:: with SMTP id b14mr20836482ede.277.1627301394782;
        Mon, 26 Jul 2021 05:09:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxG/K6orRo8FdAJeANVHYVJ7oWfky5S48VStZ68j2xJl+uCgPs+Dvd7uIrzacxbfwHidHnLqw==
X-Received: by 2002:a05:6402:278e:: with SMTP id b14mr20836460ede.277.1627301394623;
        Mon, 26 Jul 2021 05:09:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id em9sm14213522ejc.88.2021.07.26.05.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 05:09:54 -0700 (PDT)
Subject: Re: [PATCH] KVM: nSVM: Rename nested_svm_vmloadsave() to
 svm_copy_vmloadsave_state()
To:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20210716144104.465269-1-vkuznets@redhat.com>
 <YPG7XVwkze/3YDaI@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a28699c3-d557-2c8f-f79e-c97a5cdb9035@redhat.com>
Date:   Mon, 26 Jul 2021 14:09:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YPG7XVwkze/3YDaI@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/07/21 19:01, Sean Christopherson wrote:
> On Fri, Jul 16, 2021, Vitaly Kuznetsov wrote:
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index 3bd09c50c98b..8493592b63b4 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -722,7 +722,7 @@ void svm_copy_vmrun_state(struct vmcb_save_area *from_save,
>>   	to_save->cpl = 0;
>>   }
>>   
>> -void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
>> +void svm_copy_vmloadsave_state(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
> 
> And swap the parameter order for both functions in a follow-up patch?  I.e. have
> the destination first to match memcpy().
> 

Queued, thanks.

Paolo

