Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3AE4A5DA9
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 14:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbiBANtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 08:49:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44512 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230213AbiBANtM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Feb 2022 08:49:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643723352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gb3u5DHLCGetxN0uWnH4iM2RSertj3cWh5p/ybXC50g=;
        b=h0v6slBwZbTbrAJ1fxdB0OS4+zD0wph5NUgIIxAOQzVgS1zyOPvvqmVau4PlKBeybpvr0Y
        OT9jZKo0k1deozIfsNNjnUY0rT+GfcNX8dEny2XNyjIboWcWxO7xiso3u5t2k4xw4m3Spf
        40OnjtFrgUF5M1to7NC1qg5waiyvIa4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-d5uNdu7fPZyj0kLRqO81RQ-1; Tue, 01 Feb 2022 08:49:11 -0500
X-MC-Unique: d5uNdu7fPZyj0kLRqO81RQ-1
Received: by mail-ej1-f69.google.com with SMTP id lb14-20020a170907784e00b006aa178894fcso6573739ejc.6
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 05:49:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gb3u5DHLCGetxN0uWnH4iM2RSertj3cWh5p/ybXC50g=;
        b=X3NivyIijv5TVw05OW7VwoRlVvZbRqZ/Nf3y1RkvknkTe2kjTSTVnzudzqCR0CEF/g
         +pgDYpqtD/AdO+Dv69LwMcZwGUkP5gndjX6JaGksDM6t1KlCmBksUtihqQRMZhHx9/i0
         1dAAO3Fpiu9ZYchLaixYxAzv5r7gxTLRXEAnZP1m0r32DuIVuNVaKl7BHLOMjppzZrHd
         vHQ7J5JxgA+/aEaJ0DdTvz11r+Ox2l9tluA6xZefhBZIkrh/kGtr6aWliQrtQLNe007l
         V43v3vWbQAkkCjAecLIXME3/QDrZ0Ut55dTePQGsN5ZMSZgataJ19J+Z+IYL0u7LC1jQ
         jQtw==
X-Gm-Message-State: AOAM531nt/76BLv5AIc4sOngNTuVBmJUkLvmZ12AvM3gwhZocaiHvsNu
        y9nXIkcly8YhdIV06ircPzipYSse3FKhAS8eR2+QsDblHpcs68x5Q49+NJqEtYgfINEPPZT4F79
        FqbErDjHSoyeP
X-Received: by 2002:a17:907:1612:: with SMTP id hb18mr5997434ejc.724.1643723350166;
        Tue, 01 Feb 2022 05:49:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw2PA8mupdsxfkcEkT+V1LoyDQO3cZpptFXHIgLFlEEXevhP31yy+uI4yF7M5Qe3/mJ3pKzyA==
X-Received: by 2002:a17:907:1612:: with SMTP id hb18mr5997407ejc.724.1643723349951;
        Tue, 01 Feb 2022 05:49:09 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id og19sm9419431ejc.147.2022.02.01.05.49.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 05:49:09 -0800 (PST)
Message-ID: <35f06589-d300-c356-dc17-2c021ac97281@redhat.com>
Date:   Tue, 1 Feb 2022 14:49:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 0/5] KVM: SVM: nSVM: Implement Enlightened MSR-Bitmap for
 Hyper-V-on-KVM and fix it for KVM-on-Hyper-V
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        linux-kernel@vger.kernel.org
References: <20211220152139.418372-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211220152139.418372-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/20/21 16:21, Vitaly Kuznetsov wrote:
> Enlightened MSR-Bitmap feature implements a PV protocol for L0 and L1
> hypervisors to collaborate and skip unneeded updates to MSR-Bitmap.
> KVM implements the feature for KVM-on-Hyper-V but it seems there was
> a flaw in the implementation and the feature may not be fully functional.
> PATCHes 1-2 fix the problem. The rest of the series implements the same
> feature for Hyper-V-on-KVM.
> 
> Vitaly Kuznetsov (5):
>    KVM: SVM: Drop stale comment from
>      svm_hv_vmcb_dirty_nested_enlightenments()
>    KVM: SVM: hyper-v: Enable Enlightened MSR-Bitmap support for real
>    KVM: nSVM: Track whether changes in L0 require MSR bitmap for L2 to be
>      rebuilt
>    KVM: x86: Make kvm_hv_hypercall_enabled() static inline
>    KVM: nSVM: Implement Enlightened MSR-Bitmap feature
> 
>   arch/x86/kvm/hyperv.c           | 12 +--------
>   arch/x86/kvm/hyperv.h           |  6 ++++-
>   arch/x86/kvm/svm/nested.c       | 47 ++++++++++++++++++++++++++++-----
>   arch/x86/kvm/svm/svm.c          |  3 ++-
>   arch/x86/kvm/svm/svm.h          | 16 +++++++----
>   arch/x86/kvm/svm/svm_onhyperv.h | 12 +++------
>   6 files changed, 63 insertions(+), 33 deletions(-)
> 

Queued 3-5 now, but it would be nice to have some testcases.

Paolo

