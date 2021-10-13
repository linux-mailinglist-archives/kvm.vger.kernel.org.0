Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E2242B70C
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 08:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237918AbhJMG2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 02:28:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230001AbhJMG2q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Oct 2021 02:28:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634106403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M1r4UVSywHFrxKSzRmoAA2AVvVNlTRcwY3Az5uiDbcY=;
        b=LhGUiMm5EvVInZ4nW1mpWH7Yz3cP8nWdciDPmvJQE9SuYt5Sl5sH+SwVA3YtJd0AWd3Jeo
        sdApowZ/QCuoSBybGk875V3n0UqDs7V9VrxnpfrCK/hmv7SI48pQgd83qRMYHaABgXkZyr
        DM/m95cBu6FdbJKUXE3602KfFTZN1/U=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-WbWGXxEoN5-zPF6PNg8OJw-1; Wed, 13 Oct 2021 02:26:41 -0400
X-MC-Unique: WbWGXxEoN5-zPF6PNg8OJw-1
Received: by mail-ed1-f72.google.com with SMTP id e14-20020a056402088e00b003db6ebb9526so1242517edy.22
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 23:26:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=M1r4UVSywHFrxKSzRmoAA2AVvVNlTRcwY3Az5uiDbcY=;
        b=rIWYOjkZ04EnbSXjVqctk1SHGOE19VuoJ6LsecqbEKjZ1DqQTkM4T4V1FvXm+mdUfz
         F9G0y5E/nsxv4/GUXbn+SQfoNwM7Q/85BOuykFTwo7fSiHb6f5fxK5ZJGETQSatuezD5
         O861SgtroHKFPO4pL6xMiTQtT9aDVjg0OiFLHvY/7TCIcdh03K1ETPOzABuWBncBl5gk
         wEWL6wsqo5TIOMCyfeLhOF+hL9CnoGxQ6hZvMRKEy7VeAl5+2UgA1XvWbb4o4Iu6kebe
         5UJSiUNjvQUhdotmVNOCHem2LnYz5J9Fp2M8VllpFFG7fUclTvm7u3+CPNNVbxyTEhOk
         EPBQ==
X-Gm-Message-State: AOAM531Cp5lWpKsJci3ylLvXKTkS31cZaHCLZqHkUQLWEhUkex6IXn+t
        KnYeZZH/J2mo9PG4EBfiaMWVvChIPcR4mn14BXVOyw01eYZgdutD6TiobU1GE0ClUo57WNvo0d6
        7/ESEMPRH/ofX
X-Received: by 2002:a17:906:3715:: with SMTP id d21mr39321986ejc.74.1634106400732;
        Tue, 12 Oct 2021 23:26:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXXcXln6n4WTKAKDJCP/hvAKxCAGfx3dk26i18CyUdzkB601fhOGjD+CKgtZgBhVGNamrRdQ==
X-Received: by 2002:a17:906:3715:: with SMTP id d21mr39321958ejc.74.1634106400457;
        Tue, 12 Oct 2021 23:26:40 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k19sm5933406ejg.13.2021.10.12.23.26.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 23:26:39 -0700 (PDT)
Message-ID: <0962c143-2ff9-f157-d258-d16659818e80@redhat.com>
Date:   Wed, 13 Oct 2021 08:26:36 +0200
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
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BYAPR11MB3256B39E2A34A09FF64ECC5BA9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/21 08:15, Liu, Jing2 wrote:
> After KVM passthrough XFD to guest, when vmexit opening
> irq window and KVM is interrupted, kernel softirq path can call
> kernel_fpu_begin() to touch xsave state. This function does
> XSAVES. If guest XFD[18] is 1, and with guest AMX state in register,
> then guest AMX state is lost by XSAVES.

Yes, the host value of XFD (which is zero) has to be restored after 
vmexit.  See how KVM already handles SPEC_CTRL.

Passthrough of XFD is only enabled after the guest has caused an #NM 
vmexit and the full XSAVE state has been dynamically allocated, 
therefore it is always possible to do an XSAVES even from atomic context.

Paolo

