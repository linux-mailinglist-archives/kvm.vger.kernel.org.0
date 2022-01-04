Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBDD484967
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 21:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiADUpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 15:45:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233112AbiADUpq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Jan 2022 15:45:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641329146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PYrqbdtdF3TH5qv2dr8q46HQl1ZSosdbS+NCJ8IVZW0=;
        b=Ivy6TqZ47rTjGWnte//yzL1FAzabVlyvWV9Y3A8DPI2GahU6KdTLGvSFWbW92q35xXymnI
        EkX42PJehq2Iq0mNnuW3xasuYJOi9ZbnIpxM4E6dCxJWbJQ4MDLjI6kiwTLXggif3cCkro
        ZYeH0BKd4U7oxb9WgsXk+Hb703halUg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-1EuAt6cXPZ-T2vMSbx_WFA-1; Tue, 04 Jan 2022 15:45:45 -0500
X-MC-Unique: 1EuAt6cXPZ-T2vMSbx_WFA-1
Received: by mail-ed1-f69.google.com with SMTP id b8-20020a056402350800b003f8f42a883dso18993954edd.16
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 12:45:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PYrqbdtdF3TH5qv2dr8q46HQl1ZSosdbS+NCJ8IVZW0=;
        b=DUHd5yR/lOX2VDZRsmwUX4F4AWFOVRhg41t94pvrUdBjvgnW6i8LU2vVyWccAFRwe0
         hCu14uJYWQsl7ruHouMaW9u2C/tM8sq69PB90D3wWpWLQuSN9RidUK+Iu/FHB1uRptg+
         Sq+iJpf/jowGzKmFNKGaVWmHMiBwRTCDvX9Zd932Uh1H1oSCHGHwXaUFntP90I/Xhopa
         8OcVmcmljxreW01AVGrFpxZFTz/ir7qSyXK4QyzsIJGmJXiMKtCaGh3qVB4v9ZjQnQa+
         Njn3IOFFGq1JpPZDVA6sIWNx7gzkMAURC3n7ffdwe0DM0hde9K0VjRJ1eOZ/PlqNKJYj
         xK7A==
X-Gm-Message-State: AOAM530WAlHZudSfdIOFHy/3C5pb39vOzXfg7vXAmY4P/keTqeSR8+f3
        +I1BdJvohq4JbFkvzvXRBsiCktVrsI1GP8EUHcaz/jbdW6palHmEuuNBNEoQ5g/rm089DBYdPpM
        pXZh/f8tRZ4j9
X-Received: by 2002:a17:906:9746:: with SMTP id o6mr3103300ejy.112.1641329143963;
        Tue, 04 Jan 2022 12:45:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwMBe92plviw0jlSVwnEa2kU3pf6epuXjoKR1YY7Y5SakD1MSKrYxN09nCveIinmPB1gzQR0w==
X-Received: by 2002:a17:906:9746:: with SMTP id o6mr3103286ejy.112.1641329143795;
        Tue, 04 Jan 2022 12:45:43 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id f5sm15075159edu.38.2022.01.04.12.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 12:45:43 -0800 (PST)
Message-ID: <c41a0458-1bfa-9dc6-71ce-f0433cd400e7@redhat.com>
Date:   Tue, 4 Jan 2022 21:45:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v4 18/21] kvm: x86: Add support for getting/setting
 expanded xstate buffer
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Yang Zhong <yang.zhong@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, corbet@lwn.net, shuah@kernel.org,
        jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com
References: <20211229131328.12283-1-yang.zhong@intel.com>
 <20211229131328.12283-19-yang.zhong@intel.com> <YdSkDAruycpXhNUT@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YdSkDAruycpXhNUT@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/4/22 20:46, Sean Christopherson wrote:
> On Wed, Dec 29, 2021, Yang Zhong wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index bdf89c28d2ce..76e1941db223 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4296,6 +4296,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>   		else
>>   			r = 0;
>>   		break;
>> +	case KVM_CAP_XSAVE2:
>> +		r = kvm->vcpus[0]->arch.guest_fpu.uabi_size;
> 
> a) This does not compile against kvm/queue.
> 
>     arch/x86/kvm/x86.c: In function ‘kvm_vm_ioctl_check_extension’:
>     arch/x86/kvm/x86.c:4317:24: error: ‘struct kvm’ has no member named ‘vcpus’
>      4317 |                 r = kvm->vcpus[0]->arch.guest_fpu.uabi_size;
> 
> b) vcpu0 is not guaranteed to be non-NULL at this point.

Yang, you can post an incremental patch for this.  You can use the 
highest bit of the guest-permitted xcr0 (i.e. the OR of KVM's supported 
XCR0 an the guest-permitted dynamic features) and pass it to cpuid(0xD).

Paolo

