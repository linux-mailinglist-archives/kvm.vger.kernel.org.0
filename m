Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4830242C470
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 17:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhJMPH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 11:07:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28109 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229653AbhJMPHz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 11:07:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634137552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZUvBAsWmgQbw3yBugnmSYIWYxF7ZgSd0vwpJHIAZn0U=;
        b=dJQe2y5r5yc4Fk37tbT5yHKW1uVCITy3KIXrZIAz9wEKrSdf+4APe07nOCOUFXznsy5dQC
        JumST4XW0+9+BtOX10x47MJcDqsGys6ivJ8PZVe5jBbDO8OQLmgCW4ubxlOKAdiOc+MyXv
        +g6lJBm9eIvyWG9e6dVHRWETn8bYKoc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-HQ2XHgwhP3G9d9D_Zzltwg-1; Wed, 13 Oct 2021 11:05:50 -0400
X-MC-Unique: HQ2XHgwhP3G9d9D_Zzltwg-1
Received: by mail-ed1-f70.google.com with SMTP id e14-20020a056402088e00b003db6ebb9526so2458769edy.22
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 08:05:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZUvBAsWmgQbw3yBugnmSYIWYxF7ZgSd0vwpJHIAZn0U=;
        b=w77bWgABI2qTpc/lHzqFywc5NlQuro1MYxfqWIo9v0eLmCC1jMGEH/78dAiZn3HuSF
         Hq9vfwYnao5Rl3J8k6bNffYFdPAuH+n8wEVCSfpTQSlnc1H/8PagJIgbzvwRs33y95oL
         vsztP3DmeTYF4nDXati3vSpLlT/UUrB3nezYUU+0PT66AoBHczSmZJI0OwTKRr6b9Ft9
         4mkG/qhBLxmpvTvPMBcpyLpA5XT/+IcWb61DsHSFNQTQ2OEbtr+0ubWADBJxmV7VmQ+7
         FfHQv87i325VnmfKpW3HHmnyqBHKjYNsfidBfAS3WymV2A3ayCD277AHf6GZQjdp9l0W
         Sp3w==
X-Gm-Message-State: AOAM532hq3BV49B8iUfaS7PtFUc1B7i1fj2fCdzbwJ+b3UbFtEuE83O8
        LwQlDnVYyQMWbzYl4JMKPusqpqlcPWkIgEckkPKSj6B1nlwLwTiPh1IjBj5++KnnQoAswCQjccJ
        M/fgaSNABpZ33
X-Received: by 2002:a17:906:39d8:: with SMTP id i24mr23051eje.49.1634137549542;
        Wed, 13 Oct 2021 08:05:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/xDpJNxyPHo5beDcIqc5nv7j7IdDRzLCPacTEVEqeKPisHZnDBc+2PPNDdWlNmtFXLDR97w==
X-Received: by 2002:a17:906:39d8:: with SMTP id i24mr23026eje.49.1634137549301;
        Wed, 13 Oct 2021 08:05:49 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id se12sm6949370ejb.88.2021.10.13.08.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 08:05:48 -0700 (PDT)
Message-ID: <59c1dbc5-95f6-c592-d85c-c13a64bbee55@redhat.com>
Date:   Wed, 13 Oct 2021 17:05:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Content-Language: en-US
To:     Andy Lutomirski <luto@kernel.org>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     the arch/x86 maintainers <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.069324121@linutronix.de>
 <8a5762ab-18d5-56f8-78a6-c722a2f387c5@redhat.com>
 <BYAPR11MB3256B39E2A34A09FF64ECC5BA9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
 <0962c143-2ff9-f157-d258-d16659818e80@redhat.com>
 <BYAPR11MB325676AAA8A0785AF992A2B9A9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
 <da47ba42-b61e-d236-2c1c-9c5504e48091@redhat.com>
 <d673e736-0a72-4549-816d-b755227ea797@www.fastmail.com>
 <df3af1c2-fe93-ea21-56e5-4d70d08e55f2@redhat.com>
 <10a8868e-eb85-4043-a5ad-96c03d9b0abb@www.fastmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <10a8868e-eb85-4043-a5ad-96c03d9b0abb@www.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/21 16:59, Andy Lutomirski wrote:
>> 
>> Thinking more about it, #NM only has to be trapped if XCR0 enables
>> a dynamic feature.  In other words, the guest value of XFD can be
>> limited to (host_XFD|guest_XFD) & guest_XCR0.  This avoids that
>> KVM unnecessarily traps for old guests that use CR0.TS.
>> 
> You could simplify this by allocating the state the first time XCR0
> enables the feature in question.
> 
> (This is how regular non-virt userspace*should*  work too, but it
> looks like I’ve probably been outvoted on that front…)

Good point, you could do that too and do the work on the XCR0 vmexit 
instead of #NM.

Paolo

