Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671514121AE
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 20:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358582AbhITSHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 14:07:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343989AbhITSFt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 14:05:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632161062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gopq2BZfkhjQI2xV/FKOoo6DL77eDjWiZmjGPcNNBzk=;
        b=jSNczaBSLEd9s1LTCX+NcQbFF8hVi3EcI3gNevnslWsJQ2eQQOOQKbB15goy0slDOBbppd
        PVK08yRdwJa6slFkR+5RohV7Q/pmE13YMLpOuueOpUgHxNz3qe9ZQn2GIP/pXPSlc8qdD3
        J6FecUh9kBXQhIypdSoZvlXFKqa+DuM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-DXwG4gHkPW2fCzcC6jE_xQ-1; Mon, 20 Sep 2021 14:04:21 -0400
X-MC-Unique: DXwG4gHkPW2fCzcC6jE_xQ-1
Received: by mail-wr1-f70.google.com with SMTP id q14-20020a5d574e000000b00157b0978ddeso6752801wrw.5
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 11:04:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gopq2BZfkhjQI2xV/FKOoo6DL77eDjWiZmjGPcNNBzk=;
        b=ZWC8mUvVHQawuX/OWP7IDQm67Wao4g13AVU7Y4x5JDl6Eb809U6jgZgvuFqIlP41IE
         p8R0sbIZy0X1sT/fzJa5jU3texzvZ1VxaZlPiqvIbnUTEbPz06kkXGTUosezsTTBEL5C
         05sYIWvUtoR9TY4mRyBv44rVjQmCjmDnOrrT54ALCGNz/iADMbR0cBqAjvQq5k/gvbid
         TPHB44VicDBZ4/5//T9bgDOt6r87Yde08aHiqHYstaczkR10aBXRFQ1BJpqzhbgY8pIa
         NDI8D/GtpqpJXAZs/hHCG4mvviapa99V6DAcj05/H79irGiVnqGgpKo5rBnjTsEefjL9
         yTZA==
X-Gm-Message-State: AOAM533cbDNnKF03CzTA0CVgw7kwbP/246jdVif7MkNZm5D29A450Exu
        Az1VqIIAVy/FvL/fOXSE56mNp5+Lj+TAO44/CEqz7BkoXed5ZhO2tJxKSNT9wRg5VkDTmp+0M+o
        yrSUUoKZ8+znAPGocn+/XrS6a7V9933ddjtKBgEpqqUwZy/0mUJgz9sgb0Z1sVAd6
X-Received: by 2002:a05:600c:4b87:: with SMTP id e7mr368901wmp.108.1632161059304;
        Mon, 20 Sep 2021 11:04:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8yCyXTPQoZtRcZQsJIQbJE0GIxqbCuoyPq+LQY2WknfXjhfcSPzpz1/IggdbHc197w7rocw==
X-Received: by 2002:a05:600c:4b87:: with SMTP id e7mr368722wmp.108.1632161057696;
        Mon, 20 Sep 2021 11:04:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f5sm199154wmb.47.2021.09.20.11.04.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 11:04:17 -0700 (PDT)
Subject: Re: [PATCH v5 0/8] KVM: Various fixes and improvements around kicking
 vCPUs
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210903075141.403071-1-vkuznets@redhat.com>
 <87h7ef9ubo.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <21214d34-68b6-ba8e-c12e-2fa44a430540@redhat.com>
Date:   Mon, 20 Sep 2021 20:04:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87h7ef9ubo.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/21 16:48, Vitaly Kuznetsov wrote:
> 
>> Patch6 fixes a real problem with ioapic_write_indirect() KVM does
>> out-of-bounds access to stack memory.
> Paolo,
> 
> while the rest of the series is certainly not urgent, PATCH6 seems to be
> fixing a real problem introduced in 5.10. Would it be possible to send
> it for one of the upcoming 5.15 rcs (and probably to stable@)?

Yep, I'm back to KVM now.

Paolo

