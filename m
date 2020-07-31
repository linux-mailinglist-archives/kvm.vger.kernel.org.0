Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54F6234263
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 11:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732107AbgGaJWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 05:22:17 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36658 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732014AbgGaJWQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 05:22:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596187334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nbjq+Qd3z4uniercrgDzYmhwtwrHGx+NiF3QyYytaOI=;
        b=IjROntUAXx3B2xHJEqPeUMVOnuqNcMf4+Cy7c7tPTvBI7jrvv+mWZSlWZ90ljAJHuLA0LZ
        CRHLT3V5iEMd89hd5P2k1Umn5O4e4AFCjoxz2n5nrbIM4QHvk84hWq4g+EIpXEatZqOLQP
        u5xohD7yOh71wASvlQylUEKZI8Xeev8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-7VMemmsLOayDTStOglot3Q-1; Fri, 31 Jul 2020 05:22:12 -0400
X-MC-Unique: 7VMemmsLOayDTStOglot3Q-1
Received: by mail-ej1-f70.google.com with SMTP id q9so10904119ejr.21
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 02:22:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=nbjq+Qd3z4uniercrgDzYmhwtwrHGx+NiF3QyYytaOI=;
        b=taT1jcrGFYD/Bpu/HarBB3g+35XLFcFdtGaCpkMReBHANBdBpDxkJxezsRTtUw+6Lu
         nGHqwlXAgwmNvAWE7PjhXOPXkwdXhkyd8auNEzLONbyVBQya/5RuAyoTravQGyDdVWoB
         /ZoShxfnGjpXMdSREB9PCSFPAYHRuvFHiWhoqQKsNhBV0hbNTLGjyxMwS7fiuKq2csOC
         Uc6MhFzX7yYMl/0BBNXKc79+97iHdUj7egEcYeqtsNzTukI5ZjUzhHqbE/9jTbVRoTuz
         0ZjprIxkObpPRCmKlCevJOzA3YtE9mmBzNQqzSsLv0+NB9tl//zCNnaJ3z8tmk3l3VKr
         gwyw==
X-Gm-Message-State: AOAM5315dEFNnCaa8BNy89kScMdu5sCLP/ItVt/UQK/BaVXoeOeUBuVf
        E4fG21Lg/BwabV+WNAnsGFFuEObwZM1uL89PDiDZuDn98vMeU4CYCu1dPKR57/rB/y6X7aI9KqC
        vZVcyJN4WQjF+
X-Received: by 2002:a05:6402:1346:: with SMTP id y6mr2973725edw.192.1596187331453;
        Fri, 31 Jul 2020 02:22:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznu+HSM6FxQEoWZ1y19cDcknKkYopQloP3v72psiCbKCVdlMUaN5YWjCmK+xs7S81m8dFclA==
X-Received: by 2002:a05:6402:1346:: with SMTP id y6mr2973702edw.192.1596187331208;
        Fri, 31 Jul 2020 02:22:11 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j11sm8081698ejx.0.2020.07.31.02.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 02:22:10 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Julia Suvorova <jusual@redhat.com>
Cc:     "open list\:VFIO DRIVER" <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: x86: Use MMCONFIG for all PCI config space accesses
In-Reply-To: <CAHp75VcyRjAr3ugmAWYcKMrAeea6ioQOPfJnj-Srntdg_W8ScQ@mail.gmail.com>
References: <20200730193510.578309-1-jusual@redhat.com> <CAHp75VcyRjAr3ugmAWYcKMrAeea6ioQOPfJnj-Srntdg_W8ScQ@mail.gmail.com>
Date:   Fri, 31 Jul 2020 11:22:09 +0200
Message-ID: <873658kpj2.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andy Shevchenko <andy.shevchenko@gmail.com> writes:

> On Thu, Jul 30, 2020 at 10:37 PM Julia Suvorova <jusual@redhat.com> wrote:
>>
>> Using MMCONFIG instead of I/O ports cuts the number of config space
>> accesses in half, which is faster on KVM and opens the door for
>> additional optimizations such as Vitaly's "[PATCH 0/3] KVM: x86: KVM
>> MEM_PCI_HOLE memory":
>
>> https://lore.kernel.org/kvm/20200728143741.2718593-1-vkuznets@redhat.com
>
> You may use Link: tag for this.
>
>> However, this change will not bring significant performance improvement
>> unless it is running on x86 within a hypervisor. Moreover, allowing
>> MMCONFIG access for addresses < 256 can be dangerous for some devices:
>> see commit a0ca99096094 ("PCI x86: always use conf1 to access config
>> space below 256 bytes"). That is why a special feature flag is needed.
>>
>> Introduce KVM_FEATURE_PCI_GO_MMCONFIG, which can be enabled when the
>> configuration is known to be safe (e.g. in QEMU).
>
> ...
>
>> +static int __init kvm_pci_arch_init(void)
>> +{
>> +       if (raw_pci_ext_ops &&
>> +           kvm_para_has_feature(KVM_FEATURE_PCI_GO_MMCONFIG)) {
>
> Better to use traditional pattern, i.e.
>   if (not_supported)
>     return bail_out;
>
>   ...do useful things...
>   return 0;
>
>> +               pr_info("PCI: Using MMCONFIG for base access\n");
>> +               raw_pci_ops = raw_pci_ext_ops;
>> +               return 0;
>> +       }
>
>> +       return 1;
>
> Hmm... I don't remember what positive codes means there. Perhaps you
> need to return a rather error code?

If I'm reading the code correctly,

pci_arch_init() has the following:

        if (x86_init.pci.arch_init && !x86_init.pci.arch_init())
                return 0;


so returning '1' here means 'continue' and this seems to be
correct. (E.g. Hyper-V's hv_pci_init() does the same). What I'm not sure
about is 'return 0' above as this will result in skipping the rest of
pci_arch_init(). Was this desired or should we return '1' in both cases?

-- 
Vitaly

