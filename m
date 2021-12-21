Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD88847BC24
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 09:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235815AbhLUIso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 03:48:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33695 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233569AbhLUIsm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Dec 2021 03:48:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640076521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LHQemFwUsyba3tEe/uU9t9ytypWsDi32CVKu/T0ntzE=;
        b=KTIAzMcxvUsyJ/5POP6cqTqb33QL2DWZZYQ1Txfnb7Db7fo8ndl7/Yt/rM/viHgB2U/hA5
        /L5TJMU1NAVRnv2qLs88slQTZMIWaKfmryxhs+lsLF4Cswgjd1EIkaPNF8Zi3ez8MxcEdX
        6vx5aFmI3aXBZrHfuCqnxjzQ6WS62d8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-ICO1KUjZNSeAX9zJI2c2eg-1; Tue, 21 Dec 2021 03:48:40 -0500
X-MC-Unique: ICO1KUjZNSeAX9zJI2c2eg-1
Received: by mail-wr1-f72.google.com with SMTP id r7-20020adfbb07000000b001a254645f13so4394143wrg.7
        for <kvm@vger.kernel.org>; Tue, 21 Dec 2021 00:48:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LHQemFwUsyba3tEe/uU9t9ytypWsDi32CVKu/T0ntzE=;
        b=gmLRF/QdUKYUwYhsHa+X+GWX5n4qFQR8zqFbrPcc2UfZ6ZQiP34g7wgDQ6ecr9BgIi
         7AuLCzORrjHKOruggyCLYhdDpIgadH5+xDsLFrUx+Cr0jkWunHCB7jIyUATFZ1xZs6yk
         qcVKwSaub14QXt7x1Wwe/SWQgVE6ny56PwZve1HVCYiievKBOZAhal3fH/Ol/0lurBzh
         cBIrqQNj6FIHpUmee00bUzdfavBy1+2DS4vTIU0ubehiQyGOUmyiFhDfkIOfKofW6OO/
         UMkjoYytK5mtsa9my1N8UjXgHpg+IZ3zGpcFPLSoBWgftJ+hAsLv/TtbaglHn/JKfNS0
         AGDQ==
X-Gm-Message-State: AOAM53316NZe8zPr7mb9Wie1A/ShnC/AkWKzAz/IKQdh88KYpNsm1W13
        uQ+qZGkAVDOwW2e//BsolCHmjiYdysGb6wiA5b1genQ3DzrUoAgqsrV/J8WcqwTS+/Dih0EGLTN
        hK+RJyJp44K8f
X-Received: by 2002:a05:600c:24e:: with SMTP id 14mr1680073wmj.67.1640076518894;
        Tue, 21 Dec 2021 00:48:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzwoFpkxSW2a19mn7IJx5TJLZ8ottBYNreEq0GyobJqU6TMBQiB92uGZAeSMuNqN7vG0KHRvw==
X-Received: by 2002:a05:600c:24e:: with SMTP id 14mr1680050wmj.67.1640076518685;
        Tue, 21 Dec 2021 00:48:38 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id p13sm1796863wmq.19.2021.12.21.00.48.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 00:48:38 -0800 (PST)
Message-ID: <f465ec18-4a0d-2e1c-239e-cc93aa43226f@redhat.com>
Date:   Tue, 21 Dec 2021 09:48:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 23/23] kvm: x86: Disable RDMSR interception of
 IA32_XFD_ERR
Content-Language: en-US
To:     "Liu, Jing2" <jing2.liu@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc:     "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
 <20211217153003.1719189-24-jing2.liu@intel.com>
 <e6fd3fc5-ea06-30a5-29ce-1ffd6b815b47@redhat.com>
 <MWHPR11MB12451924FE9189E4B69E78A4A97C9@MWHPR11MB1245.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <MWHPR11MB12451924FE9189E4B69E78A4A97C9@MWHPR11MB1245.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/21/21 07:29, Liu, Jing2 wrote:
>>
> Thanks for reviewing the patches.
> 
> If disable unconditionally in vmx_create_vcpu, it means even guest has
> no cpuid, the msr read is passthrough to guest and it can read a value, which
> seems strange, though spec doesn't mention the read behaviour w/o cpuid.
> 
> How about disabling read interception at vmx_vcpu_after_set_cpuid?
> 
> if (boot_cpu_has(X86_FEATURE_XFD) && guest_cpuid_has(vcpu, X86_FEATURE_XFD))
>          vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R, false);

Even better:

	if (boot_cpu_has(X86_FEATURE_XFD))
		vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R,
					  !guest_cpuid_has(vcpu, X86_FEATURE_XFD));

Thanks,

Paolo

