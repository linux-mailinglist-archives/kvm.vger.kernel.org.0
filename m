Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DE93BF72F
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 11:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhGHJDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 05:03:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38811 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231190AbhGHJDJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 05:03:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625734827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gIPcM/AEt6CFgVLe5U5Gt1G0R6Bu5ZtRDH8h8xxqSLM=;
        b=idSATHVWF2dXF236y2ClsZKJZJlKbFgv1ZHb9UggPvVCmL++exZVQOJBzOcAUX6MtZ2viu
        WqFjBIgDAqYNwpu5JI0QhUh5FSauoaLTf1Ygd4LkEGYTOvcgTB6UefVimBmcOXsAXCTFVz
        cWRM5gJnN2gaRvyTpKLehBfWALwVBM4=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-VRpBPMo0NASR6jWmfZh2_Q-1; Thu, 08 Jul 2021 05:00:26 -0400
X-MC-Unique: VRpBPMo0NASR6jWmfZh2_Q-1
Received: by mail-lf1-f72.google.com with SMTP id c20-20020a0565122394b0290328f0b3dcdcso2885933lfv.7
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 02:00:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gIPcM/AEt6CFgVLe5U5Gt1G0R6Bu5ZtRDH8h8xxqSLM=;
        b=XBlus3FQ1l/vW6VA3f34BO5pc0hTN695lI25pu7eRTeAdleRgCQR7yTbraivrPVZiD
         1z0qkMZqlqdQtsavYeUPpv8Bc/aV4TpUFX3wAI3ERI6utbBDKd42lJ1J4drfSNNF/ufa
         s+ZtDVbnBr/p5c8xdyziGL60AJLTgX1kw05N+dczeIOZHaCIGCXj3mU/wljjD81wq7uh
         dgI+opTTTD3lDq4+aHRO9bD6eC0VaP3j5Z1ikk1Zu2MwQZFItfSIQJOZ/P4F8t0ddk/N
         zY4ukPTQ9mvOr6nOxrO06GX0fRYcyLj+YMIquevvDBLdoOHO8h7Yy5Hd4mkcCsKHYhwn
         8hzA==
X-Gm-Message-State: AOAM533IoaLjuA3eWDN2iN9ve+5WbsMYjxu9ZVNkidCBhOps/pp6T2G0
        9j5VWVbxmJwwUEr7nKXkC8Ssd8ej17aMiLZbujL5mAo5sEpsktx9WyiBINT2f0FhImUhXUb4P8R
        ZKEmP594ZB4tj
X-Received: by 2002:a05:6402:1014:: with SMTP id c20mr36763721edu.380.1625734413609;
        Thu, 08 Jul 2021 01:53:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxx/+0c8nIU7pwYBojXCHzTNcV8ZCk6Cqibqq/t9wTBQKxs+CGQcGK3UP/Yf8+cmhDD/LkdhQ==
X-Received: by 2002:a05:6402:1014:: with SMTP id c20mr36763691edu.380.1625734413381;
        Thu, 08 Jul 2021 01:53:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u17sm853904edt.67.2021.07.08.01.53.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 01:53:32 -0700 (PDT)
Subject: Re: [PATCH Part1 RFC v4 04/36] x86/mm: Add sev_feature_enabled()
 helper
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>, tony.luck@intel.com,
        npmccallum@redhat.com, brijesh.ksingh@gmail.com
References: <20210707181506.30489-1-brijesh.singh@amd.com>
 <20210707181506.30489-5-brijesh.singh@amd.com> <YOa8TlaZM42+sz+E@work-vm>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e6c68c70-ac6e-07f2-c24e-f1c892080eab@redhat.com>
Date:   Thu, 8 Jul 2021 10:53:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YOa8TlaZM42+sz+E@work-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/21 10:50, Dr. David Alan Gilbert wrote:
>> +enum sev_feature_type {
>> +	SEV,
>> +	SEV_ES,
>> +	SEV_SNP
>> +};
> Is this ....
> 
>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>> index a7c413432b33..37589da0282e 100644
>> --- a/arch/x86/include/asm/msr-index.h
>> +++ b/arch/x86/include/asm/msr-index.h
>> @@ -481,8 +481,10 @@
>>   #define MSR_AMD64_SEV			0xc0010131
>>   #define MSR_AMD64_SEV_ENABLED_BIT	0
>>   #define MSR_AMD64_SEV_ES_ENABLED_BIT	1
>> +#define MSR_AMD64_SEV_SNP_ENABLED_BIT	2
> Just the same as this ?
> 

No, it's just a coincidence.

Paolo

