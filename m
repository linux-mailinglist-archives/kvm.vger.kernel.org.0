Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6681EFEAF
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 19:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgFERWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 13:22:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37498 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726614AbgFERWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 13:22:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591377726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RuGOZnvDJQpKp0vYUjuXJhQewOvwWhd7fsqAjWE3CVg=;
        b=g1626IfHyB6QfQ0W+j8pIHCLXHFlhzLZguhdJHSt5s80+RzFrJD/SuVA2VUvOfYr8x6poO
        zBtCJX+xjFxM4SBh1LSuM+lgSDUZPnArnLYSpAD8/j+GMpyMcvCPhi/MWQupbVh7am4ESp
        iLh/RXtGURKES8zQ/Y4CZH4w4XJVudc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-MEKINgyPOSGI8FUET2jFHQ-1; Fri, 05 Jun 2020 13:22:05 -0400
X-MC-Unique: MEKINgyPOSGI8FUET2jFHQ-1
Received: by mail-wr1-f71.google.com with SMTP id j16so4001531wre.22
        for <kvm@vger.kernel.org>; Fri, 05 Jun 2020 10:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RuGOZnvDJQpKp0vYUjuXJhQewOvwWhd7fsqAjWE3CVg=;
        b=Xd8AB3Qb1lbMBA57ri0Zrw7xXXWi+7xF1ULqBs/4kp3vCnbQy3Gb0cRz42WYxSJLdr
         S2kJgo+OCqndXiWOjnA5gVwbdut/jAlz4cQac8NI0HdPN2W9My+HE72cVRTDsrZKZVft
         kEjArX8o31Q8+NKlhdag2TIle84bcBFn/7iLq1eMIA3cUebEwGFT4Yf71V54zppxJyUo
         J0ndHiCfw4ygop5aMvXCqXzlbzS+x6G/waY1Hb6Ht5g9hhzJCg/iZ83dwCUSLC8ERvw0
         ZiKc1ugWELc4p1hBLMRn/4rl4I/Ccc6qUyzrYntbBd9A4RkNwXosfWHxUV6yV1+PM60b
         3Mxw==
X-Gm-Message-State: AOAM530duvsvCY6pPz9ZYMZeu6y2bnSjJlp++E/F9TxdN/KRjwBL8igX
        fW53eKP+8W8+mOF8dCT9WIAgpJUWfOlRingmsy/cOnKesPkOVL0/EGaLwrms7U6INTrHbB8wBE8
        mWxMkGJYAtrzs
X-Received: by 2002:a1c:a3c5:: with SMTP id m188mr3603526wme.152.1591377724073;
        Fri, 05 Jun 2020 10:22:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5wq8gAEGIe/TueSuRhHHG/GUN8VXb01KrQUne6C0jKYAGiBSE6KmKG/6ub93AAeD3fqYx8g==
X-Received: by 2002:a1c:a3c5:: with SMTP id m188mr3603512wme.152.1591377723877;
        Fri, 05 Jun 2020 10:22:03 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.243.176])
        by smtp.gmail.com with ESMTPSA id j11sm12720518wru.69.2020.06.05.10.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 10:22:03 -0700 (PDT)
Subject: Re: [PATCH][v6] KVM: X86: support APERF/MPERF registers
To:     Jim Mattson <jmattson@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Li RongQing <lirongqing@baidu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        wei.huang2@amd.com
References: <1591321466-2046-1-git-send-email-lirongqing@baidu.com>
 <b70d03dd-947f-dee5-5499-3b381372497d@intel.com>
 <72a75924-c3cb-6b23-62bd-67b739dec166@redhat.com>
 <CALMp9eSrDehftA5o6tU2sE_098F2ucztYtzhvgguYDnWqwHJaw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a1aa9cc5-96c7-11fe-17e1-22fe46b940f3@redhat.com>
Date:   Fri, 5 Jun 2020 19:22:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSrDehftA5o6tU2sE_098F2ucztYtzhvgguYDnWqwHJaw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/06/20 19:16, Jim Mattson wrote:
>>>> @@ -4930,6 +4939,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>>>           kvm->arch.exception_payload_enabled = cap->args[0];
>>>>           r = 0;
>>>>           break;
>>>> +    case KVM_CAP_APERFMPERF:
>>>> +        kvm->arch.aperfmperf_mode =
>>>> +            boot_cpu_has(X86_FEATURE_APERFMPERF) ? cap->args[0] : 0;
>>> Shouldn't check whether cap->args[0] is a valid value?
>> Yes, only valid values should be allowed.
>>
>> Also, it should fail with -EINVAL if the host does not have
>> X86_FEATURE_APERFMPERF.
> Should enabling/disabling this capability be disallowed once vCPUs
> have been created?
> 

That's a good idea, yes.

Paolo

