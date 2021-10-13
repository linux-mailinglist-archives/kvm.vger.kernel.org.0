Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A67742BFE4
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 14:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhJMM2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 08:28:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230196AbhJMM23 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 08:28:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634127985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Dqo/N7vzZrZZut/dmL8suAY/OFRSZSIXFt0zXfL1xY=;
        b=KV+txcrzdVb2ij6aUO59Texkdwv1RTnKXpo1vWEZcSV4nzie3inWsI2b+gqn/a+AHcTyBb
        weBKxLlsVwUGFE4ZjkoOmd/WpR8byb3gq7DdUuseNL5y8vOIGBHhD2CSFOL4nHmloW/bBv
        eH4o3R+HDcbZjeo2C5WTI370hGVk6a8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-WngXyu9NMO-o_KSwEdOVuA-1; Wed, 13 Oct 2021 08:26:24 -0400
X-MC-Unique: WngXyu9NMO-o_KSwEdOVuA-1
Received: by mail-ed1-f69.google.com with SMTP id r11-20020aa7cfcb000000b003d4fbd652b9so2044639edy.14
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 05:26:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2Dqo/N7vzZrZZut/dmL8suAY/OFRSZSIXFt0zXfL1xY=;
        b=Ee4a0jnViV6IUVIJusa808z/1bhqOaE5hMQmfZUNf5K11ehwC7HFNPCP8v/77MMGi2
         H96UNc2BJfbWVLvZPmj+DTaFYFnuMM3lRQJ1lhImj4UHf0xpYHI7MQH36kc2AoFT3STu
         iN64AVsnqu8M6ZWTOmyErReGMX9fAl8YpRhVwe8Kmlb8DDxx9Espuvd1KUMuHDTk07hO
         Wn2w27h6MhVrsD7y2mKy93suXI9HzQQ3HhdEwPeInOol+/ingj8u0jBhrZHAn34DI/hw
         /VYADGX4MGMmXHJqiU93VYfvKJcg34JPziw9kN+SbeTNZjS0efsaEZj462vLGtv2w1up
         rHgw==
X-Gm-Message-State: AOAM530BAhHs0jasl7WD5Gmq57nDU8RCYavdF3DVPRPBiw6h8DWVIMYE
        bQ2iioHeLCc2Vxp7fvfpdNDKlOedEugSdX1vt2ONBWwLa6n/irubLiJgqYoFu/w5SZa4hlzSGR/
        PeYeVWEMjwVn/
X-Received: by 2002:a17:906:c7c1:: with SMTP id dc1mr41624366ejb.6.1634127983445;
        Wed, 13 Oct 2021 05:26:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+P5oSU5cLTLhqxDdez4dZhwJUIZbRtZ6U7YF8t/g6Ybvq5lbXJGfItLqFi3yQHvG7UiWhdQ==
X-Received: by 2002:a17:906:c7c1:: with SMTP id dc1mr41624338ejb.6.1634127983236;
        Wed, 13 Oct 2021 05:26:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z8sm6683870ejd.94.2021.10.13.05.26.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 05:26:21 -0700 (PDT)
Message-ID: <df3af1c2-fe93-ea21-56e5-4d70d08e55f2@redhat.com>
Date:   Wed, 13 Oct 2021 14:26:20 +0200
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
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <d673e736-0a72-4549-816d-b755227ea797@www.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/21 12:14, Andy Lutomirski wrote:
>> I think it's simpler to always wait for #NM, it will only happen
>> once per vCPU.  In other words, even if the guest clears XFD before
>> it generates #NM, the guest_fpu's XFD remains nonzero and an #NM
>> vmexit is possible.  After #NM the guest_fpu's XFD is zero; then
>> passthrough can happen and the #NM vmexit trap can be disabled.
>
> This will stop being at all optimal when Intel inevitably adds
> another feature that uses XFD.  In the potentially infinite window in
> which the guest manages XFD and #NM on behalf of its userspace and
> when the guest allocates the other hypothetical feature, all the #NMs
> will have to be trapped by KVM.

The reason is that it's quite common to simply let the guest see all 
CPUID bits that KVM knows about.  But it's not unlikely that most guests 
will not ever use any XFD feature, and therefore will not ever see an 
#NM.  I wouldn't have any problem with allocating _all_ of the dynamic 
state space on the first #NM.

Thinking more about it, #NM only has to be trapped if XCR0 enables a 
dynamic feature.  In other words, the guest value of XFD can be limited 
to (host_XFD|guest_XFD) & guest_XCR0.  This avoids that KVM 
unnecessarily traps for old guests that use CR0.TS.

Paolo

> Is it really worthwhile for KVM to use XFD at all instead of
> preallocating the state and being done with it?  KVM would still have
> to avoid data loss if the guest sets XFD with non-init state, but #NM
> could always pass through.
> 

