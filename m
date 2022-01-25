Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CC049AE05
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 09:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352891AbiAYIaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 03:30:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1450454AbiAYI15 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 03:27:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643099276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xGAGC8ZSjobiyDfU0CWYjPdtebj6fAowX1E7dpabtwo=;
        b=h7srgkEhudQxcGQNpJ+7hgupuIc4FXN8lolhOR6S/6j5/QlNnL7ihaznqtUynbwGFSX0q4
        93hvRpP+EH+9pWQkGyfHcvsx6fdsE0jsPE3gKxB+u5+lC3RB0J5O7qRyLDh3RSIKv0frr7
        TCru7mzCYC0PsUp6XDbD/3Mcv5os7j4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-428-7H6R4jghPkWS4Np3DFYDtw-1; Tue, 25 Jan 2022 03:27:55 -0500
X-MC-Unique: 7H6R4jghPkWS4Np3DFYDtw-1
Received: by mail-ed1-f70.google.com with SMTP id bc24-20020a056402205800b00407cf07b2e0so4022540edb.8
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 00:27:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xGAGC8ZSjobiyDfU0CWYjPdtebj6fAowX1E7dpabtwo=;
        b=3Ycc4RF6xwDxVXDqKSPXh3e51s7RIjODFN6unVnwKK4zRz/jsEJIa0fGRLW6vUZtHJ
         iZcTQ/17y1Vms5RpYH9mdzLLeV2qGXqbE972aLCc6hOpiCWWitOhYSLKWsFXZ+Is9XOH
         WVenzHo0j6A5Xv4WvE74FVJKAuoCGTH+iRdvr3UtdPsN13xp2OXNNb6D5rPy8DUglIZu
         dGbexyrsM9Bdfuw0BjnA/auBR+Kbts+FPoPDz/Hc5daLv6tXqLmlLM4dnWLAXbrhYXEj
         FTMonfjG4+woLrAQWnXEsqdohMH0W0fRBvtujnb9UbTXWrMXDNo1YQzAl0GLNAntwARf
         qXUg==
X-Gm-Message-State: AOAM530DOg8S74z9qnGjqSoAkfei4OEdLKbEW4GRISzf1MNXVgCsWRM7
        3eN1yeyzgiqxmY92Dqdmm7h6jyvkkh5OXkGmX1z/yAFJFgFKsEqcrBpXFgmv+fqlEeQLqO6AfVn
        OBgBqxcV5yVvn
X-Received: by 2002:a05:6402:11ca:: with SMTP id j10mr19666876edw.169.1643099274040;
        Tue, 25 Jan 2022 00:27:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzCXChr6Nh3ynRGb84TO3tGZbNPGj7Pfqsa1dBNHIpYahatyjTZ5IoE6kYc3KjFcQ9PBgrAMg==
X-Received: by 2002:a05:6402:11ca:: with SMTP id j10mr19666860edw.169.1643099273816;
        Tue, 25 Jan 2022 00:27:53 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id a11sm7867537edv.76.2022.01.25.00.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 00:27:53 -0800 (PST)
Message-ID: <f00d0e56-e5d3-4ac6-1519-fa843fb4d734@redhat.com>
Date:   Tue, 25 Jan 2022 09:27:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] KVM: x86/cpuid: Exclude unpermitted xfeatures for
 vcpu->arch.guest_supported_xcr0
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     "Liu, Jing2" <jing2.liu@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhong, Yang" <yang.zhong@intel.com>
References: <20220123055025.81342-1-likexu@tencent.com>
 <BN9PR11MB52762E2DEF810DF9AFAE1DDC8C5E9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <38c1fbc3-d770-48f3-5432-8fa1fde033f5@gmail.com>
 <Ye7SbfPL/QAjOI6s@google.com>
 <e5744e0b-00fc-8563-edb7-b6bf52c63b0e@redhat.com>
 <BN9PR11MB5276170712A9EF842B36ACE48C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BN9PR11MB5276170712A9EF842B36ACE48C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 02:54, Tian, Kevin wrote:
>> The extra complication is that arch_prctl(ARCH_REQ_XCOMP_GUEST_PERM)
>> changes what host userspace can/can't do.  It would be easier if we
>> could just say that KVM_GET_SUPPORTED_CPUID returns "the most" that
>> userspace can do, but we already have the contract that userspace can
>> take KVM_GET_SUPPORTED_CPUID and pass it straight to KVM_SET_CPUID2.
>>
>> Therefore,  KVM_GET_SUPPORTED_CPUID must limit its returned values to
>> what has already been enabled.
>>
>> While reviewing the QEMU part of AMX support (this morning), I also
>> noticed that there is no equivalent for guest permissions of
>> ARCH_GET_XCOMP_SUPP.  This needs to know KVM's supported_xcr0, so it's
>> probably best realized as a new KVM_CHECK_EXTENSION rather than as an
>> arch_prctl.
>>
> Would that lead to a weird situation where although KVM says no support
> of guest permissions while the user can still request them via prctl()?

This is already the case for the current implementation of 
KVM_GET_SUPPORTED_CPUID.

Paolo

> I wonder whether it's cleaner to do it still via prctl() if we really want to
> enhance this part. But as you said then it needs a mechanism to know
> KVM's supported_xcr0 (and if KVM is not loaded then no guest permission
> support at all)...

