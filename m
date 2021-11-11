Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DCF44D7B3
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 14:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbhKKOA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 09:00:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26959 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233758AbhKKOAS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 09:00:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636639049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hYhlga9l+dRLua8rcAl6VVj9z4qXBBQCDEmwfEZZHa0=;
        b=isWFInweTfOd/j9ffjrYuWMFig5/TnxmmhHjLk1fHh0Q85W/Fre416xjxExJg7KriZ0U6P
        iRnKHuSTicdyVy8Th8w/dwETNpk8tQmIDiSsvIesGkhvxA3u4+wMRb5+VZDh89ojJy0jFz
        tMHI/mYmEwzhM/XWoJxhFBhlcoR6FyA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-e_D9AIbRPtm75-9T8KD-Pg-1; Thu, 11 Nov 2021 08:57:28 -0500
X-MC-Unique: e_D9AIbRPtm75-9T8KD-Pg-1
Received: by mail-wm1-f70.google.com with SMTP id 145-20020a1c0197000000b0032efc3eb9bcso4855001wmb.0
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 05:57:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hYhlga9l+dRLua8rcAl6VVj9z4qXBBQCDEmwfEZZHa0=;
        b=0P4t81Ef+VOIKhNVIqtb1Kcka2gDYWC3Mbu0HvOki0UszjZPg1V2W4h6fl8h2iqJbO
         P8XOb5B4SDqRmAXwMRB+C/CUQJWaPL45aWUB2HqFPSO+2Bde69/+f+hdF4S/34ByNC/e
         vWgdDdDU09eQlHdj6Xu+6kBBzExCFiiOMtEf7YLSaChD79TJ59uyyvfMLsOuw/EJI/+P
         y+YlQRNm2Br39ltyvXrozU6NJ7eYzT3AVJZbpJgQfltKXmke4PqWFG6yFbcEFuY9n7e4
         0dmvOueEEXOwEKTVsEaOfFf8dW5EpcvH15rUARpUaBhS0xnKQPh/VUabLxF44mmJPJ5e
         x+Sw==
X-Gm-Message-State: AOAM533TvcWS9II24o7xn3j2/tpFFy/mZF9cWGb4CteLUhQgqThACr3I
        ZGkzmsGvsYqi0NQ+BlHA7hriQveTRXSnU019UDwwbtW0tSwTE55RXULzJNZdTFgvO6zpdZI0+3h
        lbcX6jRiQqfEt
X-Received: by 2002:a1c:9d13:: with SMTP id g19mr26251576wme.41.1636639046859;
        Thu, 11 Nov 2021 05:57:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwFp8r4C8AvNghU3AZtLv8qEk2YatQzB7EJEr3qecnYWGh/r+Eh4CLJ/5O/hUw5d/h2pGckeQ==
X-Received: by 2002:a1c:9d13:: with SMTP id g19mr26251550wme.41.1636639046663;
        Thu, 11 Nov 2021 05:57:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id a9sm2925185wrt.66.2021.11.11.05.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 05:57:26 -0800 (PST)
Message-ID: <a59d9ab2-ec91-d123-3019-2af478f56dce@redhat.com>
Date:   Thu, 11 Nov 2021 14:57:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 0/2] KVM: x86: Correct adjustment of KVM_CPUID_FEATURES
Content-Language: en-US
To:     Paul Durrant <pdurrant@amazon.com>, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20211105095101.5384-1-pdurrant@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211105095101.5384-1-pdurrant@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/5/21 10:50, Paul Durrant wrote:
> v2: Pre-requisite patch from Sean.
> 
> Paul Durrant (1):
>    KVM: x86: Make sure KVM_CPUID_FEATURES really are KVM_CPUID_FEATURES
> 
> Sean Christopherson (1):
>    KVM: x86: Add helper to consolidate core logic of SET_CPUID{2} flows
> 
>   arch/x86/include/asm/kvm_host.h      |  1 +
>   arch/x86/include/asm/processor.h     |  5 +-
>   arch/x86/include/uapi/asm/kvm_para.h |  1 +
>   arch/x86/kernel/kvm.c                |  2 +-
>   arch/x86/kvm/cpuid.c                 | 93 +++++++++++++++++++---------
>   5 files changed, 71 insertions(+), 31 deletions(-)
> ---
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> 

Queued, thanks.

Paolo

