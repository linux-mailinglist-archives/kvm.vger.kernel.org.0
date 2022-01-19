Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECCC493F25
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 18:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345930AbiASRg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 12:36:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41865 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240001AbiASRg2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 12:36:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642613787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6uWnFvqUizJUICRIRU+tmGcoOpYWkgt/pTJq2lLM14Y=;
        b=hzW0s4rvFLd5rkGleE/ZanoeKbDGMp9tCmXwaor0AoKO8uumipKUWNonWE3DyuXu41rt5d
        zzkv780ZxmfpCm1SsBJJA4B1PUB6LBk8N9JCdWLPDfpI8B56UpFDLEjnUTjM+16TDX6Tad
        AaQqVMsqOQVmMo/NN/pTcLNcihV6Z3g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-sCMA3n8vOb2eq8cxwTI0YA-1; Wed, 19 Jan 2022 12:36:25 -0500
X-MC-Unique: sCMA3n8vOb2eq8cxwTI0YA-1
Received: by mail-wm1-f70.google.com with SMTP id p7-20020a05600c1d8700b0034a0c77dad6so2196459wms.7
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 09:36:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6uWnFvqUizJUICRIRU+tmGcoOpYWkgt/pTJq2lLM14Y=;
        b=sh9JznErakLAcWME1AWqCtlTWRM6UF0FCl17/OREwwB8LJJ5IHHWeIfi4+H+zSykHV
         d8MTtwSN/CthrRKquzPnXFfHwK2clAUf39rqTZuLOPxWABJVQ9KbHHhRiwi1iUXJ7I1R
         YxWU0LGtSB7ZkCDDcm8KMBMcfjXNFvd0M2D6IqLnW823pHvriWWQWr5h4anSLRaiDAMT
         6R16KpLcMerCRHptHpjuUekY88ZJ377RFDDvjQiC2ZxdJUSMBxHm9HPkDqSku+OMKlKA
         7O4tLA6krNShZimgcJdQTJS+l/AI4r5+RjpAboIwJfxwAFQYKCxAZ8w4UyiOVFB1YjiG
         3H8w==
X-Gm-Message-State: AOAM531gssXf6jUrV9q0+kjuAkUz3zaVkq5PgdZ/dBPzuCfvRP7fK0hz
        2m7nQbXxyqJPmKSMoGzRZ6/FJnYnerU2s1B9NIE1G/TlKrqvhYkhfOHuSftEgGkbhA5nExLQ5uC
        rZP7WS5Fk5DiG
X-Received: by 2002:a05:600c:5125:: with SMTP id o37mr4675008wms.161.1642613784344;
        Wed, 19 Jan 2022 09:36:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyq7Kz6DYYlwfUQBRXTpTX6vJ+hPHGqduFXU1LNCD/ZgZwgEDvfo4+OqbpRietsHQMl9tpFWw==
X-Received: by 2002:a05:600c:5125:: with SMTP id o37mr4674987wms.161.1642613784145;
        Wed, 19 Jan 2022 09:36:24 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id o33sm11302070wms.3.2022.01.19.09.36.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 09:36:23 -0800 (PST)
Message-ID: <cf2d56a2-2644-31f2-c2a5-07077c66243a@redhat.com>
Date:   Wed, 19 Jan 2022 18:36:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v6 0/6] x86/xen: Add in-kernel Xen event channel delivery
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
References: <20211210163625.2886-1-dwmw2@infradead.org>
 <33f3a978-ae3b-21de-b184-e3e4cd1dd4e3@redhat.com>
 <a727e8ae9f1e35330b3e2cad49782d0b352bee1c.camel@infradead.org>
 <e2ed79e6-612a-44a3-d77b-297135849656@redhat.com>
 <YcTpJ369cRBN4W93@google.com>
 <daeba2e20c50bbede7fbe32c4f3c0aed7091382e.camel@infradead.org>
 <YdjaOIymuiRhXUeT@google.com> <Yd5GlAKgh0L0ZQir@xz-m1.local>
 <791794474839b5bcad08b1282998d8a5cb47f0e5.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <791794474839b5bcad08b1282998d8a5cb47f0e5.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/22 09:14, David Woodhouse wrote:
>> Or do we have explicit other requirement that needs to dirty guest pages
>> without vcpu context at all?
>
> Delivering interrupts may want to do so. That's the one we hit for
> S390, and I only avoided it for Xen event channel delivery on x86 by
> declaring that the Xen shared info page is exempt from dirty tracking
> and should*always*  be considered dirty.

We also have one that I just found out about in 
kvm_hv_invalidate_tsc_page, called from KVM_SET_CLOCK. :/

So either we have another special case to document for the dirty ring 
buffer (and retroactively so, even), or we're in bad need for a solution.

Paolo

