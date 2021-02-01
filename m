Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD5230A4F9
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 11:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhBAKHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 05:07:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57930 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232952AbhBAKGy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 05:06:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612173928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hnrqm+5Orx/lAieV+sFAve7SQJvuYv/3WsI5oCSpaDs=;
        b=i3PHw8NXNtY1k6bM13rQtbgYMY+ebeYbmo5AM8s9KJY4/Ur3Fnw4ybHiScYL9B3yezgovu
        xzuawSxT4Uzt0L5fPI3uN+7AO7o7Tb/casE47oB6C0swMVrXQXZDLeGnXBYUXdVlgEPgRM
        mCPadSFe/LEqVnKYdFSJKOcp1P1x1TU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-tXSEHeIpNlS8Vf16K_lrzA-1; Mon, 01 Feb 2021 05:05:27 -0500
X-MC-Unique: tXSEHeIpNlS8Vf16K_lrzA-1
Received: by mail-wr1-f70.google.com with SMTP id u3so10050929wri.19
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 02:05:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hnrqm+5Orx/lAieV+sFAve7SQJvuYv/3WsI5oCSpaDs=;
        b=gLl4lmGzfuRkZ74VD88H40bilnapUo/tp1Q//LAhOWKqRsqMjbdKnIuB4aUkJXVUpX
         Qk5O80WeIkgQaeectlkc5i4bLlmj+7ej0tYtv1iCHm4gjEhL2hLduwBF3XX8EfwX6ah9
         3e9JmtDVVhEMPg+Ep+rsihM48avl3Vb/b2rshq7+qflz//zQ4EG2T47TthgkFpstU8ao
         PaK+rrPQuii8JaexdX4oKIO4PrBE7bfyTFsV09idgQBfZocgRMRxGDIGme4Fm4FO4LtF
         jSZItYjkYxhVZHq+1vEeV0uZjnDjIRz5uk9uuBOmtGC1ppKGy0Q/pQxhESTkp9hfQbNz
         w1Cg==
X-Gm-Message-State: AOAM5316QNxjaPJ4OL5FTuQ1n6cHBQ1j2tFd6+8g736cXv68NhcRC8AG
        2Qk1EnJHfhHPCFEmbgtqi1xmEwJm+PWqACvHVdJksCf8PUW9t9HyHXHuAoMwHCFo4h3HyoRCa0T
        +nqPKpXirn49w
X-Received: by 2002:a5d:4b8e:: with SMTP id b14mr16835036wrt.130.1612173925764;
        Mon, 01 Feb 2021 02:05:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyHqEKDZMztc6oYFmsWJE7+DzZDMGYfZt6wGifS7Lt1RNnM9xp9h2TviiF5fV0KuUXfhhESXw==
X-Received: by 2002:a5d:4b8e:: with SMTP id b14mr16835008wrt.130.1612173925582;
        Mon, 01 Feb 2021 02:05:25 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d5sm26108824wrs.21.2021.02.01.02.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 02:05:24 -0800 (PST)
Subject: Re: [RFC 2/7] KVM: VMX: Expose IA32_PKRS MSR
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
 <20200807084841.7112-3-chenyi.qiang@intel.com>
 <62f5f5ba-cbe9-231d-365a-80a656208e37@redhat.com>
 <a311a49b-ea77-99bf-0d0b-b613aed621a4@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <192cfa2c-e54a-c7c1-30dd-7077e07e4af1@redhat.com>
Date:   Mon, 1 Feb 2021 11:05:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <a311a49b-ea77-99bf-0d0b-b613aed621a4@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/21 10:53, Chenyi Qiang wrote:
>>>
>>
>> Is the guest expected to do a lot of reads/writes to the MSR (e.g. at 
>> every context switch)?
>>
>> Even if this is the case, the MSR intercepts and the entry/exit 
>> controls should only be done if CR4.PKS=1.  If the guest does not use 
>> PKS, KVM should behave as if these patches did not exist.
>>
> 
> Hi Paolo,
> 
> Per the MSR intercepts and entry/exit controls, IA32_PKRS access is 
> independent of the CR4.PKS bit, it just depends on CPUID enumeration. If 
> the guest doesn't set CR4.PKS but still has the CPUID capability, 
> modifying on PKRS should be supported but has no effect. IIUC, we can 
> not ignore these controls if CR4.PKS=0.

Understood, I wanted to avoid paying the price (if any) of loading PKRS 
on vmentry and vmexit not just if CPUID.PKS=0, but also if CR4.PKS=0. 
If CR4.PKS=0 it would be nicer to enable the MSR intercept and disable 
the vmentry/vmexit controls; just run the guest with the host value of 
IA32_PKRS.

Paolo

