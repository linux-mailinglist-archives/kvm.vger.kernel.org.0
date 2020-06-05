Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D611EF163
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 08:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgFEGfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 02:35:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34226 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726026AbgFEGfj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 02:35:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591338938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zOWlMMC6MaTqH8FdPka6VFHXT+XA0yiK+Y+lYw5AEhg=;
        b=Z5c9DQ8q/DSBJz3KQgeUNSsZWRLN6VVMCzACQv3JzyMPmnvPwgmDAozZm9PNV+DArGeJDW
        gCACiXqgakExCMm/P+MkkHyeRHLR0oA7Gd5MFjB+j9Cf3y/112hWnwfKgKC19Olgnp9flY
        nk7+u1WkNm370jK8u0v7Mmg8SDYam1A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-Tg9oVb1jPLy1_v7J-k9uQg-1; Fri, 05 Jun 2020 02:35:36 -0400
X-MC-Unique: Tg9oVb1jPLy1_v7J-k9uQg-1
Received: by mail-wr1-f70.google.com with SMTP id a4so3353589wrp.5
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 23:35:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zOWlMMC6MaTqH8FdPka6VFHXT+XA0yiK+Y+lYw5AEhg=;
        b=eyPW8dGzhZ3cdjeQDjYKnbZk3czUyNEuVKcIaCPvOYErKzNsbIxw3EfRDqjGrsMh30
         rhcoFOy0n8Odq2Zw1pw3yZ4M25R7USgQpNoXItn16AQa+Y63ofCnKPCJiMY8qGQyYEz0
         ODW6/soKSFz/rPw3KhfolNOr1Tl3X5KE4XCd0LWqHIGySiIPzeRQbHOnQbAv/xOcQpTd
         fyXnr1T/V5866YzCC9LBmi20V/XL7MGUs/ceqm+V1ZzTlG+u4AeN2GA9F1QLSNl+VzUI
         RuXDm4cMljHg3Fd0E8JI4ZG969NAZ1S3benUYuH/XbFdVjwZVCj4V36Mi9ZZdQiuVPaE
         kjEQ==
X-Gm-Message-State: AOAM531EIsHA3AgRki2jN5OFOTFWskhqEELinAitn3GUDZ0L8DGeSPux
        pfeKVdIxiAk87CJJ6AOUef1Uuhre2R+cuescV5PlW+uuKcHXlTjmU0pdaj0sVrw7jKtEAxCAXhQ
        KilOr0zwgRGjI
X-Received: by 2002:a7b:cbd9:: with SMTP id n25mr1109928wmi.30.1591338935465;
        Thu, 04 Jun 2020 23:35:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbaDfuoRzF8P8RlKKO6/4Xp0aXgpd0OWZjUf60bwyQlbamy2U8/MpobFZD+Uih4G9J/CLtGg==
X-Received: by 2002:a7b:cbd9:: with SMTP id n25mr1109908wmi.30.1591338935173;
        Thu, 04 Jun 2020 23:35:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id k64sm10430479wmf.34.2020.06.04.23.35.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 23:35:34 -0700 (PDT)
Subject: Re: [PATCH][v6] KVM: X86: support APERF/MPERF registers
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Li RongQing <lirongqing@baidu.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        hpa@zytor.com, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
        jmattson@google.com, wanpengli@tencent.com, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wei.huang2@amd.com
References: <1591321466-2046-1-git-send-email-lirongqing@baidu.com>
 <b70d03dd-947f-dee5-5499-3b381372497d@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <72a75924-c3cb-6b23-62bd-67b739dec166@redhat.com>
Date:   Fri, 5 Jun 2020 08:35:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <b70d03dd-947f-dee5-5499-3b381372497d@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/06/20 07:00, Xiaoyao Li wrote:
> you could do
> 
>     bool guest_cpuid_aperfmperf = false;
>     if (best)
>         guest_cpuid_aperfmperf = !!(best->ecx & BIT(0));
> 
>     if (guest_cpuid_aperfmerf != guest_has_aperfmperf(vcpu->kvm))
>         return -EINVAL;
> 
> 
> In fact, I think we can do nothing here. Leave it as what usersapce
> wants just like how KVM treats other CPUID bits.

The reason to do it like Rongqing did is that it's suggested to take the
output of KVM_GET_SUPPORTED_CPUID and pass it down to KVM_SET_CPUID2.
Unfortunately we have KVM_GET_SUPPORTED_CPUID as a /dev/kvm (not VM)
ioctl, otherwise you could have used guest_has_aperfmperf to affect the
output of KVM_GET_SUPPORTED_CPUID.

I think it's okay however to keep it simple as you suggest.  In this
case however __do_cpuid_func must not return the X86_FEATURE_APERFMPERF bit.

The guest can instead check for the availability of KVM_CAP_APERFMPERF,
which is already done in Rongqing's patch.

>> @@ -4930,6 +4939,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>           kvm->arch.exception_payload_enabled = cap->args[0];
>>           r = 0;
>>           break;
>> +    case KVM_CAP_APERFMPERF:
>> +        kvm->arch.aperfmperf_mode =
>> +            boot_cpu_has(X86_FEATURE_APERFMPERF) ? cap->args[0] : 0;
> 
> Shouldn't check whether cap->args[0] is a valid value?

Yes, only valid values should be allowed.

Also, it should fail with -EINVAL if the host does not have
X86_FEATURE_APERFMPERF.

Thanks,

Paolo

