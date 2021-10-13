Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E5942C033
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 14:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbhJMMjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 08:39:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26336 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232366AbhJMMjU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 08:39:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634128637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MhSsu6sxXChH5UWR/mp2mBVqoRx87/emujX8miD2Vik=;
        b=jES8PANGEo/ptqeduPWELZBkR/rIPCFukE4xNhH8/rFNOmYYZqB3w+aGOyez/NoQpCELkg
        gyrh0Ha5LdiZ4Vz1EXCj+AL/8skqTVXdeT1ZhBvuudbkTesBecHesLg6qeHM/2qRmibzRo
        B+RAtvawo5BDApYDpBlEYed1gU59CHs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-uA6Gl4s7MKag8MN0OrVYbg-1; Wed, 13 Oct 2021 08:37:16 -0400
X-MC-Unique: uA6Gl4s7MKag8MN0OrVYbg-1
Received: by mail-wr1-f69.google.com with SMTP id d13-20020adfa34d000000b00160aa1cc5f1so1848128wrb.14
        for <kvm@vger.kernel.org>; Wed, 13 Oct 2021 05:37:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MhSsu6sxXChH5UWR/mp2mBVqoRx87/emujX8miD2Vik=;
        b=vPIXBJ+ofgOulc5/HSrl8dVQWqLQK4KeofXOe+699JJQLqqvI6LhWf+wlIS4Gc/X4V
         DsUGEmYct3i/ij/a24q4Jqw+SGjyeu6wtURUfXEVR4MeZZtrt1CeBGR/TYv6U7TO1/oV
         Ure3NREoFM2NZFa50JETsGE6dhyEI1IMOKKG+Uj12zhs2UmYgpYjT/4vEwygPHHhxOZh
         nZjLHc+BhFR4GmgCRe4CBRvKu/A0cuB7RQ72rcsUBH8DV1zmUVtK8hMEv77IG7qAKuSy
         iYB79GcoDA0bx9G93z61bmqCUE6yLD9cLz+1ecw7Shwx4OeJOi4HCcPS7EiCN9a7N69G
         cpjg==
X-Gm-Message-State: AOAM532UnBIAcIzXR69vh9GnRvD0nTPT+YtNUsSmAd6ejvL7LRs2PgpW
        Q3nDWbFyje6/HRw07gfq6dpNV3froY60vOH4lyydWSMl6C9Ng5pu5mzLFtJ6l1uNhPlBYGZacEz
        XJN9bP6Jfp6kN
X-Received: by 2002:adf:a411:: with SMTP id d17mr40068381wra.393.1634128634796;
        Wed, 13 Oct 2021 05:37:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1tGXtY6nBKqyTOqt9GARLofN8xAcRt+gUfOWGXC+tf5sZaJFXTRdEtHmrvr16r+ppH32lLw==
X-Received: by 2002:adf:a411:: with SMTP id d17mr40068344wra.393.1634128634501;
        Wed, 13 Oct 2021 05:37:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a2sm13258721wrq.9.2021.10.13.05.37.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 05:37:13 -0700 (PDT)
Message-ID: <826be724-c92b-4310-7ee9-b0af7cf28844@redhat.com>
Date:   Wed, 13 Oct 2021 14:37:12 +0200
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
 <da47ba42-b61e-d236-2c1c-9c5504e48091@redhat.com>
 <BYAPR11MB325670EF536F5C4766C18D19A9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BYAPR11MB325670EF536F5C4766C18D19A9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/21 12:25, Liu, Jing2 wrote:
> [...]
>> - the internal KVM value attached to guest_fpu.  When #NM happens, this
>> one becomes zero.
> 
>> The CPU value is:
>>
>> - the guest_fpu value between kvm_load_guest_fpu and kvm_put_guest_fpu.
>>    This ensures that no state is lost in the case you are describing.
>>
> 
> OK, you mean using guest_fpu as a KVM value. Let me describe the
> flow to see if anything missing.
> 
> When #NM trap which makes passthrough, guest_fpu XFD set to 0 and keeps
> forever. (don't change HW XFD which is still 1)
> In the #NM trap, KVM alloc buffer and regenerate a #NM exception to guest
> to make guest kernel alloc its thread buffer.
> Then in next vmexit, KVM sync vcpu->arch.xfd, load guest_fpu value (=0) and
> update current->thread.fpu XFD to 0 for kernel reference.

In the #NM handler, KVM allocates the buffer and the guest_fpu XFD 
becomes zero.  Also because the guest_fpu XFD is zero:

- #NM vmexits are disabled.  More precisely, trapping #NM is only 
necessary if guest_fpu->xfd & ~vcpu->arch.xfd & vcpu->arch.xcr0 is 
nonzero (i.e. only if there is a state that is guest_fpu-disabled, but 
enabled according to both XFD and XCR0).

- On the next vmentry XFD is set to just vcpu->arch.xfd and the 
instruction is retried.  If the instruction causes an #NM in the guest, 
it is not trapped and delivered normally to the guest.

>> I think it's simpler to always wait for #NM, it will only happen once
>> per vCPU.  In other words, even if the guest clears XFD before it
>> generates #NM, the guest_fpu's XFD remains nonzero
> 
> You mean a wrmsr trap doesn't do anything and return back?

The guest might run with the same XFD value as before (which is 
guest_fpu->xfd | vcpu->arch.xfd), but vcpu->arch.xfd is changed.  The 
value in vcpu->arch.xfd will be read back by an RDMSR, because 
passthrough is not enabled and the RDMSR will cause a vmexit.

Once an #NM is received and guest_fpu->xfd becomes zero, passthrough can 
be enabled.

Paolo

> In this case, when next vmenter, the OR of the guest value
> (vcpu->arch.xfd) and the guest_fpu value is still 1, so this
> doesn't obey guest's HW assumption? (guest finds the wrmsr
> didn't work)

