Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10345492AFB
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 17:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244403AbiARQRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 11:17:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28292 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346930AbiARQRK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 11:17:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642522626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z08MHDNhy6Tp5Zxakk6GNjZnK5qCuR7d3aDgDq9KhjY=;
        b=IeR/1ZmxWVwgLyBpl19KJBTOjs9Iy7RBNBtT9SVzURaNcuvbXvnISMrU0DcsOwJtJoLr/C
        XK1wbJ5YqUg8rG7/ndk0E8qa2SkvZz/0iv4HxOJAUJRoaJO9CxN/JI7hwXnV53r7a4KcKJ
        ZP67cSC7KWB8G1DlhK9kD4oOpDlw9HI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-CmGWuEFWOSarYepnpeKflQ-1; Tue, 18 Jan 2022 11:17:05 -0500
X-MC-Unique: CmGWuEFWOSarYepnpeKflQ-1
Received: by mail-ed1-f70.google.com with SMTP id k10-20020a50cb8a000000b00403c8326f2aso1297363edi.6
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 08:17:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=z08MHDNhy6Tp5Zxakk6GNjZnK5qCuR7d3aDgDq9KhjY=;
        b=zWDi6mBK29fMsSx0vxdXl8PuiSW+JhVZwTLEDEnCYCxhw0Iw8imdYWnN6enO4VPkY6
         1BE0l8xs9LGNrtQX1r1KeRT/TL/9HuZIBM0F6vo0y2lbVS9RyW00ipTiQ2BDdsAANBbU
         RMXzntPHcjUBQ2qqqnWZc+xw31AuQOSMYHmc62XkZ+E49WPDgFI9yXxO8/VkQCXMDdxK
         4yYHSE8NGHkn6Y08r7OLYGdBVf5zCvG6+TFWpfWOY2uAAdV4AnWoCMRQJevR/0CAWRzn
         MNpFPU/Apf4gI3OrZKWaC2u0eUe6F1gfKIq6GWqTVa/w2Auc0Sx3z/9DPbB0vLvSNVgp
         H30g==
X-Gm-Message-State: AOAM530lo6mDRJ4Xlsc/+nstqXsx+Cen7iTF6vHMnGkKGb4znmm7uUBP
        uxjGiqK0BsCJj6Y5+pmaslf3hxR9HTi4+c8ry7500Q6/AXocYSqNyfhO/+JhExrzTvOb0yRv37b
        73/GOz/phyJhj
X-Received: by 2002:a05:6402:3584:: with SMTP id y4mr25606861edc.232.1642522623068;
        Tue, 18 Jan 2022 08:17:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzo/6+gmCA8OwF6BChxrtL1iLImWhAnnptNx8y2bxdPukt0yBeGnkJKHszWzBV91g04OqJYbw==
X-Received: by 2002:a05:6402:3584:: with SMTP id y4mr25606849edc.232.1642522622859;
        Tue, 18 Jan 2022 08:17:02 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id p25sm67611edw.75.2022.01.18.08.17.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 08:17:02 -0800 (PST)
Message-ID: <498eb39c-c50a-afef-4d46-5c6753489d7e@redhat.com>
Date:   Tue, 18 Jan 2022 17:17:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 0/4] KVM: x86: Partially allow KVM_SET_CPUID{,2} after
 KVM_RUN for CPU hotplug
Content-Language: en-US
To:     Igor Mammedov <imammedo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20220117150542.2176196-1-vkuznets@redhat.com>
 <20220118153531.11e73048@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220118153531.11e73048@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/22 15:35, Igor Mammedov wrote:
> Can you check following scenario:
>   * on host that has IA32_TSX_CTRL and TSX enabled (RTM/HLE cpuid bits present)
>   * boot 2 vcpus VM with TSX enabled on VMM side but with tsx=off on kernel CLI
> 
>       that should cause kernel to set MSR_IA32_TSX_CTRL to 3H from initial 0H
>       and clear RTM+HLE bits in CPUID, check that RTM/HLE cpuid it cleared
> 
>   * hotunplug a VCPU and then replug it again
>      if IA32_TSX_CTRL is reset to initial state, that should re-enable
>      RTM/HLE cpuid bits and KVM_SET_CPUID2 might fail due to difference
> 
> and as Sean pointed out there might be other non constant leafs,
> where exact match check could leave userspace broken.


MSR_IA32_TSX_CTRL is handled differently straight during the CPUID call:

                 if (function == 7 && index == 0) {
                         u64 data;
                         if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
                             (data & TSX_CTRL_CPUID_CLEAR))
                                 *ebx &= ~(F(RTM) | F(HLE));
                 }


and I think we should redo all or most of kvm_update_cpuid_runtime
the same way.

Paolo

