Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E0F352E8C
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 19:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbhDBRis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 13:38:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235020AbhDBRir (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Apr 2021 13:38:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617385125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TKDRlulogoRtKYWAUF1pyaqEOli9TuwMVFnHg7gDyqg=;
        b=Q4xswCaxfgkySKmuL/5CGktC1WNv0NU55mYrCOwTG4ipR6QZTCdooCOc9A0C/G2FFYj7BR
        z/4K34jbh3ywbkeRwZuLQFwEeEEUQJWkz3Yo+iOCfO75IRarWz7QvB7JCJkHZXxnR0gXDv
        UOn9uoKF3IT/dXSo/rgNAmF4BeXW/2A=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-7ltd5MC2MbKSpcMjxtAeEQ-1; Fri, 02 Apr 2021 13:38:44 -0400
X-MC-Unique: 7ltd5MC2MbKSpcMjxtAeEQ-1
Received: by mail-ed1-f69.google.com with SMTP id i19so4880165edy.18
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 10:38:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TKDRlulogoRtKYWAUF1pyaqEOli9TuwMVFnHg7gDyqg=;
        b=RaIAazyxIuyR1Y0S8FbZve/ecyG0AzSuT0LJJDlHUgQqGsMogZsstZEhj0j7/OhEq1
         HUgEZN0M5Lh/nKr/e/7YIuAyncPnc58YgOFwcqjxzVeRZu+JmwTpoUygnOlHAwPEC3IU
         2amMTVa7OidEKD8cKYJYh1e3guNLzH2TH+A9mBgi//YMElQKm/cKix4zFzadqPEsEgQg
         fg0Zr00/MnlV84GMq0dgwb0jjijlqZ7JJO5/IOgX0uH4/vaop2+HuWxHrMk57twc60tB
         myFw52WtYxvkC82D9ox1Yv/peXxffu50vCuVNFVxhbC+MCllRrU2u31MAN1yvg2lmg5B
         S2nQ==
X-Gm-Message-State: AOAM5322OC6UJBpt102zS8QGtgZNdchiRVHqsd0TIQdSzt7V9x/N7Eh8
        G6+VWTXFhxPU+I0zU5yyf52DerSgZUizLy8mflOCF1AyRxly++Hd+y1B7e+Jp+3cttDy29GP8Nd
        DQZJXgh/dttqx
X-Received: by 2002:a17:907:3f10:: with SMTP id hq16mr2635470ejc.181.1617385123129;
        Fri, 02 Apr 2021 10:38:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzAS7ZbtJVwnzUWnA/6X0McPrVes3ar3lqem09HSmYxMrqLZW+HviZElaAarzltynI2Jr8wwA==
X-Received: by 2002:a17:907:3f10:: with SMTP id hq16mr2635443ejc.181.1617385122924;
        Fri, 02 Apr 2021 10:38:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y17sm4462135ejf.116.2021.04.02.10.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 10:38:42 -0700 (PDT)
Subject: Re: [PATCH v2 0/9] KVM: my debug patch queue
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Will Deacon <will@kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Jim Mattson <jmattson@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Kieran Bingham <kbingham@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>
References: <20210401135451.1004564-1-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cb7f918c-932f-d558-76ec-801ed8ed1f62@redhat.com>
Date:   Fri, 2 Apr 2021 19:38:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210401135451.1004564-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/04/21 15:54, Maxim Levitsky wrote:
> Hi!
> 
> I would like to publish two debug features which were needed for other stuff
> I work on.
> 
> One is the reworked lx-symbols script which now actually works on at least
> gdb 9.1 (gdb 9.2 was reported to fail to load the debug symbols from the kernel
> for some reason, not related to this patch) and upstream qemu.

Queued patches 2-5 for now.  6 is okay but it needs a selftest. (e.g. 
using KVM_VCPU_SET_EVENTS) and the correct name for the constant.

Paolo

> The other feature is the ability to trap all guest exceptions (on SVM for now)
> and see them in kvmtrace prior to potential merge to double/triple fault.
> 
> This can be very useful and I already had to manually patch KVM a few
> times for this.
> I will, once time permits, implement this feature on Intel as well.
> 
> V2:
> 
>   * Some more refactoring and workarounds for lx-symbols script
> 
>   * added KVM_GUESTDBG_BLOCKEVENTS flag to enable 'block interrupts on
>     single step' together with KVM_CAP_SET_GUEST_DEBUG2 capability
>     to indicate which guest debug flags are supported.
> 
>     This is a replacement for unconditional block of interrupts on single
>     step that was done in previous version of this patch set.
>     Patches to qemu to use that feature will be sent soon.
> 
>   * Reworked the the 'intercept all exceptions for debug' feature according
>     to the review feedback:
> 
>     - renamed the parameter that enables the feature and
>       moved it to common kvm module.
>       (only SVM part is currently implemented though)
> 
>     - disable the feature for SEV guests as was suggested during the review
>     - made the vmexit table const again, as was suggested in the review as well.
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (9):
>    scripts/gdb: rework lx-symbols gdb script
>    KVM: introduce KVM_CAP_SET_GUEST_DEBUG2
>    KVM: x86: implement KVM_CAP_SET_GUEST_DEBUG2
>    KVM: aarch64: implement KVM_CAP_SET_GUEST_DEBUG2
>    KVM: s390x: implement KVM_CAP_SET_GUEST_DEBUG2
>    KVM: x86: implement KVM_GUESTDBG_BLOCKEVENTS
>    KVM: SVM: split svm_handle_invalid_exit
>    KVM: x86: add force_intercept_exceptions_mask
>    KVM: SVM: implement force_intercept_exceptions_mask
> 
>   Documentation/virt/kvm/api.rst    |   4 +
>   arch/arm64/include/asm/kvm_host.h |   4 +
>   arch/arm64/kvm/arm.c              |   2 +
>   arch/arm64/kvm/guest.c            |   5 -
>   arch/s390/include/asm/kvm_host.h  |   4 +
>   arch/s390/kvm/kvm-s390.c          |   3 +
>   arch/x86/include/asm/kvm_host.h   |  12 ++
>   arch/x86/include/uapi/asm/kvm.h   |   1 +
>   arch/x86/kvm/svm/svm.c            |  87 +++++++++++--
>   arch/x86/kvm/svm/svm.h            |   6 +-
>   arch/x86/kvm/x86.c                |  14 ++-
>   arch/x86/kvm/x86.h                |   2 +
>   include/uapi/linux/kvm.h          |   1 +
>   kernel/module.c                   |   8 +-
>   scripts/gdb/linux/symbols.py      | 203 ++++++++++++++++++++----------
>   15 files changed, 272 insertions(+), 84 deletions(-)
> 

