Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB69142D842
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 13:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhJNLgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 07:36:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54109 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230241AbhJNLgC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 07:36:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634211237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aFiK62jXYmyXCc8jy67gMQtsRtTTUcSWEFlScum3zsE=;
        b=is6NXUJVLRghs27ktTkpkmx6Z77/ToZzp2Ts3E5ZbFDJH2rjl8FbSPLkCZ0PZaeXbI+qss
        ABZKBlFf+MOznkhI8xcs5yPrpsg8qdqIr/I2FOvaZ5MeF7rgoujiGP/B6l2HsEcYeGiUj8
        avO8Aurnb1YkIftdGoeRtDWSdRxF0WU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-Ntqh2R2yM_uNSExDJZqUyQ-1; Thu, 14 Oct 2021 07:33:56 -0400
X-MC-Unique: Ntqh2R2yM_uNSExDJZqUyQ-1
Received: by mail-wr1-f72.google.com with SMTP id c4-20020a5d6cc4000000b00160edc8bb28so4318924wrc.9
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 04:33:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aFiK62jXYmyXCc8jy67gMQtsRtTTUcSWEFlScum3zsE=;
        b=Bt/qrSthSK8ySUXEySzmXY9KYxA1QYw72gqdfQbfUQp2EcY+FF7xANAhON55hsLSp+
         OPQddRHquGsRoHmbv6O0s/FGrgVDu9CoqZ0md3vEPAd8escY3sjRZ4x4vnGMTwjZ4ff/
         /PwVU1CHXtKXb333YFnU8btjBb1LFfscdPXtXIFAkyrMv/zmpJQCUxmxEG7ENQtMVJq6
         dTLGHIgJvZaAin68Mu91r6u8pKDQkyqgZ79DLG5Q5zzUHaS9+8cS9bqbkgTue8i91CbD
         2KvylD1JTxS816L/R7RvmNpk53roRVIUx6slWu/Ef92vW3Gqm+qLt0PLqF/Zvh2OxpzJ
         e1ag==
X-Gm-Message-State: AOAM530rYf3lyDMijHtWJetnvxIhU5N/IWyyAsnJSgMmJxT0TsYtehbG
        /qIWC+nSjD4nlWNvJKMhB/MqBdQkw/riyd9q1Q+TIeRJjv4KXNBMd0Gb+eCfpq+b9eVXKiABJeN
        WWXXjDJJ+l9UM
X-Received: by 2002:adf:a505:: with SMTP id i5mr6046596wrb.38.1634211234551;
        Thu, 14 Oct 2021 04:33:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiKghIMWGUl/9bSIjpatJRN7IH0fZsaBz1H6o+dEhEpiL2daSqp+PW4wsJUfjL4Iyq+dH77A==
X-Received: by 2002:adf:a505:: with SMTP id i5mr6046567wrb.38.1634211234282;
        Thu, 14 Oct 2021 04:33:54 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n1sm7768996wmi.30.2021.10.14.04.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 04:33:53 -0700 (PDT)
Message-ID: <31430671-292b-f55d-a971-748d4bc775f1@redhat.com>
Date:   Thu, 14 Oct 2021 13:33:52 +0200
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
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
 <BL0PR11MB3252511FC48E43484DE79A3CA9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
 <6bbc5184-a675-1937-eb98-639906a9cf15@redhat.com>
 <BYAPR11MB3256A20F6BB9218BDB5B7988A9B89@BYAPR11MB3256.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BYAPR11MB3256A20F6BB9218BDB5B7988A9B89@BYAPR11MB3256.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/10/21 13:21, Liu, Jing2 wrote:
> Got it, the principle is once XCR0[n]=1 and XFD[n]=0, then guest is allowed
> to use the dynamic XSAVE state, thus KVM must prepare all things well
> before. This probably happens shortly after guest #NM.
> 
> Only one thing: it seems we assume that vcpu->arch.xfd is guest runtime
> value. And before guest initializes XFD, KVM provides
> vcpu->arch.xfd[18]=1, right? But the spec asks XFD reset value as zero.
> If so, between guest init XCR0 to 1 and init XFD to 1, it's XCR0[n]=1 and
> XFD[n]=0. If a guest never init XFD and directly use dynamic state...
> 
> Or do we want to provide guest a XFD[18]=1 value at the very beginning?

On reset the guest value has to be zero.  For Linux, which we control, 
we probably want to write the bit in XFD before XSETBV.  For other OSes 
there's nothing we can do, but hopefully they make similar considerations.

Paolo

