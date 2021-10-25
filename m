Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259704395B9
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 14:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhJYMOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 08:14:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46457 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230167AbhJYMO3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 08:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635163927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MKcVElowmMx/QXUmDQd66FA5VTHck8N2LJbnTe8Bnro=;
        b=RYuJkeBtc/9DXinoEubAZvuplSkaE88c0XgW3eXKHrVEqtZmxA23n2NzZA7dAfK9w/kP9v
        35x3VaWmk9Y8Qu+3nXV097obUlsGSMJ/UJxtrLkZsm1xVuYFxXHUtAvPOQfi5ZrKTB9FsL
        DAAG9t+W5VNKok+h/APasJJOt3toQqs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-5ig8nKHqMXKR0i0_sbNS0g-1; Mon, 25 Oct 2021 08:12:06 -0400
X-MC-Unique: 5ig8nKHqMXKR0i0_sbNS0g-1
Received: by mail-wm1-f72.google.com with SMTP id b81-20020a1c8054000000b0032c9d428b7fso3432489wmd.3
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 05:12:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MKcVElowmMx/QXUmDQd66FA5VTHck8N2LJbnTe8Bnro=;
        b=oQmB9SqJuHFwnvm74Tg/Opbh7KCcaz5nw0CVvaPnMm+6POxVEG2mUyQ7bu6Qyinin/
         pRa6NvtwVBv6U90GIs9rBrswnjIiJ6sNiIad8Ayxu2p4HYWsGmRibhKCiTW55jTjpA57
         ft3CxlCqdlo3Ubjlu9vrMsrU/3oTMLFjzq3IwdDoim48RUW66oYBvqoRFJnismTFSQxk
         XwEOh9g/V4g9CEYjTt69uGrEw2bANd9HjNf4vBZPsSDhrbT81g/om7yK3JOFgvZwjKj3
         AJRvt/FfGM+GkkZzOo4vZDGSMVPl6WK9nI9N/kJGt8ehZ4bLDUE2BL2/UtHdWYSDCWv9
         pNug==
X-Gm-Message-State: AOAM53086hYB162tVsCNOrRJ0Jag1UdpqZB6c955tl7mN8DrcGclRXk5
        hj/Gw4CLoXgT6azJ+k1bUjTCYwkAzkjlr2Pjj8+hmUAe9RoHpxJlZDSlGUUshYGAhPIbnilEwdV
        6hO/yLXxWPb6M
X-Received: by 2002:a1c:3bd5:: with SMTP id i204mr19564211wma.46.1635163925122;
        Mon, 25 Oct 2021 05:12:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxW7aUo3Aefw44KflaDnt34AHkfsE4TxiVrjtiYBrYM8lIDvm9QEMR0ZfP9tDePC6Nuhf7FYA==
X-Received: by 2002:a1c:3bd5:: with SMTP id i204mr19564183wma.46.1635163924848;
        Mon, 25 Oct 2021 05:12:04 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f6sm14900402wmj.28.2021.10.25.05.12.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 05:12:04 -0700 (PDT)
Message-ID: <0badb3f0-3a25-ea55-af3c-775ef168dd8e@redhat.com>
Date:   Mon, 25 Oct 2021 14:12:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [EXTERNAL] [PATCH] KVM: x86/xen: Fix runstate updates to be
 atomic when preempting vCPU
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raslan, KarimAllah" <karahmed@amazon.com>
Cc:     "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
References: <3d2a13164cbc61142b16edba85960db9a381bebe.camel@amazon.co.uk>
 <09f4468b-0916-cf2c-1cef-46970a238ce4@redhat.com>
 <a0906628f31e359deb9e9a6cdf15eb72920c5960.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <a0906628f31e359deb9e9a6cdf15eb72920c5960.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/21 12:39, David Woodhouse wrote:
>> Not every single time, only if the cache is absent, stale or not
>> initialized.
> Hm, my reading of it suggests that it will fail even when the cache is
> valid, on IOMEM PFNs for which pfn_valid() is not set:
> 
>          if (pfn_valid(pfn)) {
>                  page = pfn_to_page(pfn);
>                  if (atomic)
>                          hva = kmap_atomic(page);
>                  else
>                          hva = kmap(page);
> #ifdef CONFIG_HAS_IOMEM
>          } else if (!atomic) {
>                  hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE,
> MEMREMAP_WB);
>          } else {
>                  return -EINVAL;
> #endif
>          }
> 

Yeah, you're right.  That's the "if" above.

> For this use case I'm not even sure why I'd *want* to cache the PFN and
> explicitly kmap/memremap it, when surely by *definition* there's a
> perfectly serviceable HVA which already points to it? 

The point of the gfn_to_pfn cache would be to know in advance that there 
won't be a page fault in atomic context.  You certainly don't want to 
memremap/memunmap it here, it would be awfully slow, but pulling the 
kmap/memremap to the MMU notifier would make sense.

Paolo

