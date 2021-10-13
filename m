Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DD942BABA
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 10:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbhJMIpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 04:45:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59145 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229902AbhJMIpA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 04:45:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634114577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZNEBzMh01UbIpCvcvAMyeRlQt2efPWKePBsn29MszCA=;
        b=iiZveaspKHJlEDezl0qM/1/M5ndMa530RpJDXWFQ5O/kjaIV1+AyeY2EZIHaylnv4fMW88
        KLnx1hHEnW2zlor7ME/Hn3U89YnClVbkL87dWhpvCx8+RiCBfuHPMf0fpr4Z9sMgzHeknA
        rAw6+5gUUr1QyiO7Y66HG3MESTc8GFc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-VICgThOGNgyHdJZmZL5zLA-1; Wed, 13 Oct 2021 04:42:56 -0400
X-MC-Unique: VICgThOGNgyHdJZmZL5zLA-1
Received: by mail-ed1-f71.google.com with SMTP id p13-20020a056402044d00b003db3256e4f2so1624214edw.3
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 01:42:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZNEBzMh01UbIpCvcvAMyeRlQt2efPWKePBsn29MszCA=;
        b=ETEZIUS0T1Hmr7Mt6EDbU+AEKWdgTtbtDKxCv3qPvjS332bcMaXi+DD2+y21x0ad/f
         BkJ+X23QbQVi4hzzceWsGT5h2IjFiwWN7Oj3m66YceiM1uLxpG4iANy4u2oK/jIfXK7p
         ZfNIsx8xdU4ATHTntIwshxNAcFPxwUm8letig7bOjnOyOw3AdZZmLi66FeEJIYzHKjZ1
         FKgAwfKd+Cd5+LX9jB9wqZGAbmn68SCU/nn3ExPUfU/stwSZX2GMo3HQCfeiOErIcd8a
         82Ji4mDqEanXnNQknNssKHBNDofo59Iua7oeTDQTQvsRHLlsR7A1SxRaaOp++8MLyv8K
         pTGw==
X-Gm-Message-State: AOAM533nISmy3G+3MKx4p/ye1CgVtojKqXxaeV+XITSuk/s2CZtgyT+U
        k+RoMme0qHE6NhardJt9fYieQA2uBnipIXgi3m/sequCVUTVC+lWPvm72FgHl8nLLDZKd9IOlOf
        4gqDqEQtiiIsA
X-Received: by 2002:a50:d88b:: with SMTP id p11mr7818890edj.287.1634114575403;
        Wed, 13 Oct 2021 01:42:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAWsODufwXfMW8KNKakO9uRsUWFkAKm1xso7Dyxl0T3P74KqLy/MBGkXk476xbNpTYJx3Ywg==
X-Received: by 2002:a50:d88b:: with SMTP id p11mr7818859edj.287.1634114575212;
        Wed, 13 Oct 2021 01:42:55 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 10sm6252772eju.12.2021.10.13.01.42.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 01:42:54 -0700 (PDT)
Message-ID: <da47ba42-b61e-d236-2c1c-9c5504e48091@redhat.com>
Date:   Wed, 13 Oct 2021 10:42:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Content-Language: en-US
To:     "Liu, Jing2" <jing2.liu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.069324121@linutronix.de>
 <8a5762ab-18d5-56f8-78a6-c722a2f387c5@redhat.com>
 <BYAPR11MB3256B39E2A34A09FF64ECC5BA9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
 <0962c143-2ff9-f157-d258-d16659818e80@redhat.com>
 <BYAPR11MB325676AAA8A0785AF992A2B9A9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BYAPR11MB325676AAA8A0785AF992A2B9A9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/21 09:46, Liu, Jing2 wrote:
> 
>> On 13/10/21 08:15, Liu, Jing2 wrote:
>>> After KVM passthrough XFD to guest, when vmexit opening irq window and
>>> KVM is interrupted, kernel softirq path can call
>>> kernel_fpu_begin() to touch xsave state. This function does XSAVES. If
>>> guest XFD[18] is 1, and with guest AMX state in register, then guest
>>> AMX state is lost by XSAVES.
>>
>> Yes, the host value of XFD (which is zero) has to be restored after vmexit.
>> See how KVM already handles SPEC_CTRL.
> 
> I'm trying to understand why qemu's XFD is zero after kernel supports AMX.

There are three copies of XFD:

- the guest value stored in vcpu->arch.

- the "QEMU" value attached to host_fpu.  This one only becomes zero if 
QEMU requires AMX (which shouldn't happen).

- the internal KVM value attached to guest_fpu.  When #NM happens, this 
one becomes zero.


The CPU value is:

- the host_fpu value before kvm_load_guest_fpu and after 
kvm_put_guest_fpu.  This ensures that QEMU context switch is as cheap as 
possible.

- the guest_fpu value between kvm_load_guest_fpu and kvm_put_guest_fpu. 
  This ensures that no state is lost in the case you are describing.

- the OR of the guest value and the guest_fpu value while the guest runs 
(using either MSR load/save lists, or manual wrmsr like 
pt_guest_enter/pt_guest_exit).  This ensures that the host has the 
opportunity to get a #NM exception, and allocate AMX state in the 
guest_fpu and in current->thread.fpu.

> Yes, passthrough is done by two cases: one is guest #NM trapped;
> another is guest clearing XFD before it generates #NM (this is possible for
> guest), then passthrough.
> For the two cases, we passthrough and allocate buffer for guest_fpu, and
> current->thread.fpu.

I think it's simpler to always wait for #NM, it will only happen once 
per vCPU.  In other words, even if the guest clears XFD before it 
generates #NM, the guest_fpu's XFD remains nonzero and an #NM vmexit is 
possible.  After #NM the guest_fpu's XFD is zero; then passthrough can 
happen and the #NM vmexit trap can be disabled.

Paolo

