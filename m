Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6405439BF7
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 18:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbhJYQr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 12:47:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21072 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233999AbhJYQrY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 12:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635180302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WNT3hqzp5JAiOj7EMmMtN5eINp8qeUVSTFxs1YCteUs=;
        b=TnvKjYzbMABLpt+O8ruzcYRIXfO2gNSscay+j2EeGDbzmE4KHJ8374z8yYXuv3GQktfjI+
        7xNH23y1+De9mppDB4a7I6xoDdoHjg8gAo3FMKgnzCQdvq4eGniOPTM/PVWx064TXGNQ/J
        3VRR26l/Es7/0CIeN2JmTK1bXVuTK6A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-Z4Fz5fi0OKOtv_0NTiWMLw-1; Mon, 25 Oct 2021 12:44:59 -0400
X-MC-Unique: Z4Fz5fi0OKOtv_0NTiWMLw-1
Received: by mail-ed1-f70.google.com with SMTP id k28-20020a508adc000000b003dd5e21da4bso2855732edk.11
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 09:44:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WNT3hqzp5JAiOj7EMmMtN5eINp8qeUVSTFxs1YCteUs=;
        b=cj8q/PJkI2Ey9Jsd3cTugQoU8rjLUkJ3mTaUeAVRFt9yXN42AtIgUuR1Ii6GGdXaa0
         LhSdi1GAvcMuTmhbQlCV+QlGTujsF7lVfGDQXkxP9baOeKlPJd/GR6cu8bXDauMYyIDL
         kUzCY7RLjSRz4nZqWKQ+GwbpzMaqJmhwabPBkf2p6RzcPQPSeGaa5v72oi6ZD+8TWXpy
         7w8Uh337aocRje39/AUtVtnHz5d0cADNVD8P2rj1vCaWtxHAcNPcnuy5qrm0vlk2WndR
         29rb84c3bXMzfArFOf7PCvHSQlp3KbJ6b8fzmi3m/gY9Ms2KSTuI+TsR7Jp45+OhZ5oP
         YrBw==
X-Gm-Message-State: AOAM531YSnOPwzKUgTsx5Bq3tsOxizwkVsnQtJr8TyxkVhqzg+WRcNKK
        fyDWHj7N+m/9GL2Q9DhK1Mx5L9y+Ui1c6VTTmNEA9GdxOycRiMfqyWNmU47DJU3PZ9GoyzWK5d2
        5j7lDMj/CFgeV
X-Received: by 2002:aa7:c6c1:: with SMTP id b1mr28232444eds.11.1635180298515;
        Mon, 25 Oct 2021 09:44:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7JYRq/uuVj1jP70lO/MEVNlpAjXxBqnB+rGkuCz/InSJ3GTqq0f97A6YdgndqkltHiDRXuw==
X-Received: by 2002:aa7:c6c1:: with SMTP id b1mr28232408eds.11.1635180298290;
        Mon, 25 Oct 2021 09:44:58 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v22sm5792394edb.47.2021.10.25.09.44.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 09:44:57 -0700 (PDT)
Message-ID: <84444ec9-cebf-1ec2-ec3e-8b28e587682d@redhat.com>
Date:   Mon, 25 Oct 2021 18:44:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: vPMU: Don't program counter for interrupt-based
 event sampling w/o lapic_in_kernel
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1634894233-84041-1-git-send-email-wanpengli@tencent.com>
 <YXbb5ePpVWKxBsbh@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YXbb5ePpVWKxBsbh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/21 18:31, Sean Christopherson wrote:
>> vPMU depends on in-kernel lapic to deliver pmi interrupt, there is a
>> lot of overhead when creating/maintaining perf_event object,
>> locking/unlocking perf_event_ctx etc for vPMU. It silently fails to
>> deliver pmi interrupt if w/o in-kernel lapic currently. Let's not
>> program counter for interrupt-based event sampling w/o in-kernel
>> lapic support to avoid the whole bothering.
>
> This feels all kinds of wrong.  AFAIK, there's no way for KVM to enumerate to
> the guest that the vPMU isn't capable of generating interrupts.  I.e. any setup
> that exposes a vPMU to the guest without an in-kernel local APIC is either
> inherently broken or requires a paravirtualized guest.  I don't think KVM's bugs
> should be optimized.

Yeah, if it simplified the code it would be a different story, but here 
there's even not one but two new checks.

Paolo

