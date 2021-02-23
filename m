Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3810322F55
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 18:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhBWRIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 12:08:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49327 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232545AbhBWRIB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 12:08:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614099994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=avKMupa6a85FWOiwIB+lEculG0t/Djdrh0a5DcIz4dA=;
        b=K6IcIrALJIOGgt1dTnP9wnWjjeTkD7uQ7s/Q1JggvtAn19zuCGEPFpapwyaxUGtA0AuUMq
        deRqvNh8bE8eMJIBa8VLXCXYLryO2B/AEEJ7U2bT1KDVNUefrGO3Dd7qVo4jP058RQalks
        qEO00bNUpXyU82lrSwSAtCWkZ8xzUXM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-LBrF3-l3Mz2tVEj7ybb7DQ-1; Tue, 23 Feb 2021 12:06:14 -0500
X-MC-Unique: LBrF3-l3Mz2tVEj7ybb7DQ-1
Received: by mail-ej1-f72.google.com with SMTP id er8so5618482ejc.13
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 09:06:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=avKMupa6a85FWOiwIB+lEculG0t/Djdrh0a5DcIz4dA=;
        b=arno8IU08A9QbQY/bKoQEDGQQFSme5DD1LGJbWXIRMS1Dlz4lw7+X5F55etOsnCnRM
         tHvrgAZPOxUJ2xycpl6sqZGZhnZIUaj4CWYfpFsebPFRuIlYM/vIBYOqkEpqIs6Siac6
         9ybMQjNlXjkF/UlSg7bZybQ1RMmqlQ4yi+ZrW+kIdL//D1Xg6zGdoo3YWeP0w987X4V2
         0P4QDimr5AVloH+x++xAZf6K2lCV5xpiOYZMxeo77vlxuQIiEJUa9exu5ME0DMwferOf
         QfyKXvt6lzuCQ8xaEvafZFcHRxjnQDvzTrLkDqQjgi39hmSxLyv+s/zea1Jp4yAesN1+
         iYbA==
X-Gm-Message-State: AOAM532ec6ngHAMYRTG2ZqlFcM/jCtA6Ki+Gg+q8oFIqiqaXi8w6gGu+
        ukQujxpaJ7GkOhEoD2EmX9rr73zM5F8jbDmytKMHRYNSyQGmLytiNdKn5jDrbGZM4zxzTRCwHX3
        SgCytHP/65V0q
X-Received: by 2002:a05:6402:1a51:: with SMTP id bf17mr27561446edb.25.1614099972859;
        Tue, 23 Feb 2021 09:06:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwskiemK4n02TtPFLp+bUTlHzvJG47UwUsUB4/FINbtoDi3yuIqcs6WTM09YmpnQvvel254QA==
X-Received: by 2002:a05:6402:1a51:: with SMTP id bf17mr27561418edb.25.1614099972592;
        Tue, 23 Feb 2021 09:06:12 -0800 (PST)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id l13sm585802ejr.63.2021.02.23.09.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 09:06:11 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: vmx/pmu: Clear DEBUGCTLMSR_LBR bit on the debug
 breakpoint event
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu@linux.intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20210223013958.1280444-1-like.xu@linux.intel.com>
 <20210223013958.1280444-2-like.xu@linux.intel.com>
 <YDUvhTyFVwwZHnEj@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f1f9f159-d9c4-c03e-2297-84b5aab28447@redhat.com>
Date:   Tue, 23 Feb 2021 18:06:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YDUvhTyFVwwZHnEj@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/02/21 17:38, Sean Christopherson wrote:
> On Tue, Feb 23, 2021, Like Xu wrote:
>> When the processor that support model-specific LBR generates a debug
>> breakpoint event, it automatically clears the LBR flag. This action
>> does not clear previously stored LBR stack MSRs. (Intel SDM 17.4.2)
>>
>> Signed-off-by: Like Xu <like.xu@linux.intel.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index e0a3a9be654b..4951b535eb7f 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -4795,6 +4795,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>>   	u32 intr_info, ex_no, error_code;
>>   	unsigned long cr2, rip, dr6;
>>   	u32 vect_info;
>> +	u64 lbr_ctl;
>>   
>>   	vect_info = vmx->idt_vectoring_info;
>>   	intr_info = vmx_get_intr_info(vcpu);
>> @@ -4886,6 +4887,10 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>>   		rip = kvm_rip_read(vcpu);
>>   		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
>>   		kvm_run->debug.arch.exception = ex_no;
>> +		/* On the debug breakpoint event, the LBREn bit is cleared. */
> 
> Except this code is in BP_VECTOR, not DB_VECTOR as it should be.
> 
>    When the processor generates a debug exception (#DB), it automatically clears
>    the LBR flag before executing the exception handler. This action does not
>    clear previously stored LBR stack MSRs.

Also, this should come with a testcase.

Paolo

