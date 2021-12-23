Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41E947DBF8
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 01:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbhLWA0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 19:26:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31974 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229620AbhLWA0J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Dec 2021 19:26:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640219168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XorjI3ceeGLlYGMx0ynYLzGVKsYU3eQeSIoTevWnlTo=;
        b=i51GKWB1ibissAd6yFu3VH043//LgvkDKgorcVNDxGv2T6qtobv5WtrkeZb/H5ASoCsvbd
        G/dSfG4pSX3goukiHiiYaYnXyCHQGhIgPFneaTaAhOn2r2c61YRFd8NQMQ8gQL1RU2GSoz
        QxRJSx4PijQe/k8iCyhnf+BB3oAKTzE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-kq2_U1GTPb-FJWYLprwF_w-1; Wed, 22 Dec 2021 19:26:07 -0500
X-MC-Unique: kq2_U1GTPb-FJWYLprwF_w-1
Received: by mail-ed1-f71.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso3069265edt.20
        for <kvm@vger.kernel.org>; Wed, 22 Dec 2021 16:26:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XorjI3ceeGLlYGMx0ynYLzGVKsYU3eQeSIoTevWnlTo=;
        b=jBKeoz37yYvJDztqQk1jxZhH2X+8LUOhKPAYIE4pq40I3FK+7seMNORcUjEE31yLnP
         AY4GLCgas7hEHXfOn7vC5W5SupJP7Sp95KEg89nMVcHWXtj/GJPxWks38FEEPblhGTjM
         kBcZgwROMvjECZbmYVPtFRY40RqctC+uGuzHu0SAFUs7hFEeiz+r+3KEUJ5ShKQ2nxes
         dvz2BDOV1OmPlmS5YjGDHPh016cnxzT4uH+7zCeUm1+XiQ642CI3UtfevGciKrU3K7Cq
         nerA+H397epQUoOjaF75r+FKjL5VeuWd/41SobE5+8gf9fsXWofVRA99jQ1HYxXWcCUr
         mQIQ==
X-Gm-Message-State: AOAM5318ofJNY+OvGDsLvR2C+utdKrMgZHW5ZoVuAKxO5xKiPPiwi8W0
        T8vrPuo1+qw+mbMLTRWATQCgLml6NlQnPQuXwIEI0clvRcU8fdTKt8aOkdBojFODH1nM2ZUTqmx
        mT1Y0SyFpSMHP
X-Received: by 2002:a05:6402:268a:: with SMTP id w10mr99709edd.257.1640219166374;
        Wed, 22 Dec 2021 16:26:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwceTnYlxVmTyRG8jXJZ6EVuEi4BmbqdtKjoH7qw6Pr+3vBC7RDqxELM7AWVqpmcKrQcF/iBg==
X-Received: by 2002:a05:6402:268a:: with SMTP id w10mr99696edd.257.1640219166220;
        Wed, 22 Dec 2021 16:26:06 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id z22sm1451213edd.68.2021.12.22.16.26.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Dec 2021 16:26:05 -0800 (PST)
Message-ID: <e2ed79e6-612a-44a3-d77b-297135849656@redhat.com>
Date:   Thu, 23 Dec 2021 01:26:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v6 0/6] x86/xen: Add in-kernel Xen event channel delivery
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
References: <20211210163625.2886-1-dwmw2@infradead.org>
 <33f3a978-ae3b-21de-b184-e3e4cd1dd4e3@redhat.com>
 <a727e8ae9f1e35330b3e2cad49782d0b352bee1c.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <a727e8ae9f1e35330b3e2cad49782d0b352bee1c.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/22/21 16:18, David Woodhouse wrote:
>>> n a mapped
>>> shared info page.
>>>
>>> This can be used for routing MSI of passthrough devices to PIRQ event
>>> channels in a Xen guest, and we can build on it for delivering IPIs and
>>> timers directly from the kernel too.
>> Queued patches 1-5, thanks.
>>
>> Paolo
> Any word on when these will make it out to kvm.git? Did you find
> something else I need to fix?

I got a WARN when testing the queue branch, now I'm bisecting.

Paolo

