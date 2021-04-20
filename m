Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5766D365F30
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 20:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhDTS2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 14:28:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233092AbhDTS2a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 14:28:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618943278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rt/t+I/KtcZ1bXATJ8JrmYabWuJFiLedZQY+lkzmzzc=;
        b=SOAUtf/TzKHqnFh4Ma5XPZbWj64GchnvAodN0oSpJhoLbKeQhqBwGUMujJKFg7Od6hUAMh
        Bd0iqBNFw8+lv+OaP7w9cL0Hrjcu7Wgp7m2dyB+faQ6prQAgd7Q5C8y/A5kzRpNiDbZfG0
        metNFv+gTinuILQcxiiayWV9KFjIxVU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-V3uc2CwUOJ2brjXdQnGxkg-1; Tue, 20 Apr 2021 14:27:54 -0400
X-MC-Unique: V3uc2CwUOJ2brjXdQnGxkg-1
Received: by mail-ed1-f70.google.com with SMTP id c15-20020a056402100fb029038518e5afc5so6045010edu.18
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 11:27:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rt/t+I/KtcZ1bXATJ8JrmYabWuJFiLedZQY+lkzmzzc=;
        b=rexDoSB0Wc0h6WxWRYIub+9kyDMqYqjab89Txw9zywaaprnE7qnlD3S8eD2amCx7MN
         YwX2QikG/zmpEtyYo+qe+a/3Bu69O8LEv5HktJQugojtnDM42GB1vXT/1Mzi1JxsOVwQ
         DbB7zSNRSCxlVpSaWJ26IjIqldhupupYoq2pLIpmOEWhy0pV4qGJt9IXrCb7Kux/uU2I
         YHLVI+NOKS7L7a3NEuzaRFXDtuHsmLMcJGw66Ry03uaRFY+8Ldh4vWH+5eUEQ6n+pokq
         rzqHz34XfwEGpNk429vhyd4LtBxNYiU8Gtt8NsdShwSMyV7dOJEb6W7mhncpc0ai4Wuz
         vcYw==
X-Gm-Message-State: AOAM533j3Km05eWKVgCtqQprTDSBaEcPaNF3lRJWYkyKoj5oas5ptYDr
        EO8SCqsCoH2hgTSl7Z7xDrukNQc1/qqih8R3mnl3h+C37YER53IpCmgxWVjTowACroVnEErh22O
        5C7PVNkYBs1T5
X-Received: by 2002:a17:907:3ac1:: with SMTP id fi1mr28976531ejc.139.1618943272712;
        Tue, 20 Apr 2021 11:27:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEdOZkYCgIf/rLx/m6BBXcl0kUNchsFF0jNoefPiJKHN2UivzWKjaJQk29HdPJtEGSlDj93A==
X-Received: by 2002:a17:907:3ac1:: with SMTP id fi1mr28976513ejc.139.1618943272489;
        Tue, 20 Apr 2021 11:27:52 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id li16sm13295075ejb.101.2021.04.20.11.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 11:27:51 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: x86: guest interface for SEV live migration
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        srutherford@google.com, joro@8bytes.org, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, venu.busireddy@oracle.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org, Ashish Kalra <ashish.kalra@amd.com>
References: <20210420112006.741541-1-pbonzini@redhat.com>
 <YH7wAh0t+eQ5n1M2@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2b1f1764-bcb0-096a-8d44-aee94f2c85f3@redhat.com>
Date:   Tue, 20 Apr 2021 20:27:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YH7wAh0t+eQ5n1M2@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/21 17:15, Sean Christopherson wrote:
> On Tue, Apr 20, 2021, Paolo Bonzini wrote:
>> Do not return the SEV-ES bit from KVM_GET_SUPPORTED_CPUID unless
>> the corresponding module parameter is 1, and clear the memory encryption
>> leaf completely if SEV is disabled.
> 
> Impeccable timing, I was planning on refreshing my SEV cleanup series[*] today.
> There's going to be an annoying conflict with the svm_set_cpu_caps() change
> (see below), any objecting to folding your unintentional feedback into my series?

That's fine of course.

>> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
>> index 888e88b42e8d..e873a60a4830 100644
>> --- a/arch/x86/kvm/cpuid.h
>> +++ b/arch/x86/kvm/cpuid.h
>> @@ -99,6 +99,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
>>   	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
>>   	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
>>   	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
>> +	[CPUID_8000_001F_EAX] = {0x8000001F, 0, CPUID_EAX},
>>   };
>>   
>>   /*
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index cd8c333ed2dc..acdb8457289e 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -923,6 +923,13 @@ static __init void svm_set_cpu_caps(void)
>>   	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
>>   	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
>>   		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
>> +
>> +	/* CPUID 0x8000001F */
>> +	if (sev) {
>> +		kvm_cpu_cap_set(X86_FEATURE_SEV);
>> +		if (sev_es)
>> +			kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
> 
> Gah, I completely spaced on the module params in my series, which is more
> problematic than normal because it also moves "sev" and "sev_es" to sev.c.  The
> easy solution is to add sev_set_cpu_caps().

Sounds good.

Paolo

