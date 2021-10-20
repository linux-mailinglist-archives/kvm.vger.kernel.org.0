Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA6B435595
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 23:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhJTVza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 17:55:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26141 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229695AbhJTVz3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 17:55:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634766794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U6rXNz3Z+PfqtejcB5UFQ+ZtQ0/yQs952Acpxd92MN0=;
        b=IJnffwH6b39WktcDBVyg0dBSUAcESH8qRDSt8qdUAWHds5elGFqH0l+fIJiOcIQr4vNDFZ
        h3D6//+riRIki6SiKPsIMlfQQ/o1M5Eg8LEBKFXmxFs7qgxVVP1nfPd5aK1W5rj4YuledT
        BRaQfBwpwyqOj5Z5VxZrjwWUHlt3pR0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-9r4usN5EPKeKm96x1a0tbA-1; Wed, 20 Oct 2021 17:53:13 -0400
X-MC-Unique: 9r4usN5EPKeKm96x1a0tbA-1
Received: by mail-ed1-f70.google.com with SMTP id t28-20020a508d5c000000b003dad7fc5caeso5138117edt.11
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 14:53:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U6rXNz3Z+PfqtejcB5UFQ+ZtQ0/yQs952Acpxd92MN0=;
        b=oXYSb1Kj8XusVRXVgPbYAJE4bshHHAB8VttZuMtUX+ZDo95YktIY0RRNSea078WBBN
         WXphVUP/uRv3nozJWM+P8UTxln9ND1lMZ9dP79QU0GveDEO3oYjgBWLHxdeamBLmm3SG
         9JGknU6xRgbq75hgM5BOUKZd1Xz8Lj33G6obgjZhcCN5TXMjl9xtVf4P5tNYjHC5V9il
         iJCQTtfrUp8TjibKzlWpGjP/A8NPYeWMvzPG+eMAbo4uYzxZy5XYhIrKt9+Yk6neOWB5
         XAifu+SL6Htz0FB8FIBPTCLvnPfHAQQHuZXTHC8FM05jC2CytR2YWf3/x+ymCsuXvBD6
         vReA==
X-Gm-Message-State: AOAM533+jSoWH4NY7sF5QKnnvgjJ8UWCsXizC7wVk/tWEYsQAwcel25J
        EJBlGGc0EYHDrUcpQPE2uC5C1ofVKqSn1PcloBqyAzisy2BSszYZw3gdkoOvU6Scu6Vju8wrVuZ
        WOAcMW9lU3Edz
X-Received: by 2002:a17:906:3947:: with SMTP id g7mr2363077eje.407.1634766792052;
        Wed, 20 Oct 2021 14:53:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzv6J9Xym4EJh9Zs4yIfGXv7o5aqhc8Tu4ag+uUYOnXHogw0Sb2KCWiFg9yiSL18vtR6i3TvQ==
X-Received: by 2002:a17:906:3947:: with SMTP id g7mr2363044eje.407.1634766791836;
        Wed, 20 Oct 2021 14:53:11 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id m23sm1603818eja.6.2021.10.20.14.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 14:53:11 -0700 (PDT)
Message-ID: <32fd9317-9d11-22b7-ff25-25220dd9029e@redhat.com>
Date:   Wed, 20 Oct 2021 23:53:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 1/5 V10] KVM: SEV: Refactor out sev_es_state struct
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20211012204858.3614961-1-pgonda@google.com>
 <20211012204858.3614961-2-pgonda@google.com>
 <ee9cb472-75ba-2a1e-a88c-ecdb1f3de4d4@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <ee9cb472-75ba-2a1e-a88c-ecdb1f3de4d4@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/10/21 23:12, Tom Lendacky wrote:
> On 10/12/21 3:48 PM, Peter Gonda wrote:
>> Move SEV-ES vCPU metadata into new sev_es_state struct from vcpu_svm.
>>
>> Signed-off-by: Peter Gonda <pgonda@google.com>
>> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: Marc Orr <marcorr@google.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
>> Cc: Brijesh Singh <brijesh.singh@amd.com>
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Cc: Wanpeng Li <wanpengli@tencent.com>
>> Cc: Jim Mattson <jmattson@google.com>
>> Cc: Joerg Roedel <joro@8bytes.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Borislav Petkov <bp@alien8.de>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: kvm@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
> 
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

FWIW this series won't apply due to the string I/O fixes in 5.15, so 
I've delayed it---but it's not lost.

Paolo

