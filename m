Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855683D65A0
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 19:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237343AbhGZQod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 12:44:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24517 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240531AbhGZQo2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 12:44:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627320296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2djdVISIe1NLgmBdf251IqcGLIfy8aFTeD+AL2Ofvls=;
        b=C6U3/k0Kcf898CohbJM5O4zLFCU3PUdFiZIfQGwQUmQlNuYIjTehH/NT+7T5xq8qln8+Wx
        AuiAa/Oc4qo3RHp3vBzFd+YJuCK+/mqxN2aZGwKsOnp3pxb5avyJDMggUXihHnnruC/YB4
        BA2vc7IbWZez0Tviq7xVXYlAGabL1Zo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-Jq6r0uM1NjmCv70pANx_jw-1; Mon, 26 Jul 2021 13:24:55 -0400
X-MC-Unique: Jq6r0uM1NjmCv70pANx_jw-1
Received: by mail-ed1-f69.google.com with SMTP id l10-20020aa7caca0000b02903b874f26036so5038138edt.20
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 10:24:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2djdVISIe1NLgmBdf251IqcGLIfy8aFTeD+AL2Ofvls=;
        b=EbD4W7mlwd6aWk9gqtUD+U/yoaTj8Vu1CbDF06T4GorEOhQ+dMNefudvquRkrQR4Pu
         et9k5ZDRo5wH93tRzqJmeXv6ck1Bavy0DoE0SaHkvllW/mTfCA4duLxCgHRq9XVAl4EQ
         ayJmrDlEg3kqP6Fg4Tnw13PBVE5ZZmjHUEebuquDq2PtKertfrrmE6GVgWhX9zh+xzBx
         4eE7i5GB6zsJ+UhpJkECr6ckwqkoUQpCKUqHKTmVU8yZ3HC3C0kMBHyaGXcjb7AmFRJv
         Tl6B14+YOkrq/obxg4pZLy5xBc8V5xX8Cgq+HCkU5VxAfLS73XaFiyVN8tXSMR1gpA8a
         oEpA==
X-Gm-Message-State: AOAM533QshmLyE5Oh2yvHKshAw3m9CAHf2iepfukNYfvN0WHgpLMx31E
        //7FzsoxmgS/Sh0KYd29+IsbcAlbwLTQ8pmvtRae+xOY6Rc4xsvtWqF9DCoXOzNw0XDfNH+s02h
        laHvZDMbMY2O6
X-Received: by 2002:a05:6402:3549:: with SMTP id f9mr22856634edd.387.1627320294103;
        Mon, 26 Jul 2021 10:24:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJqnu4J9v9LvtB85/ss5s7uZ0nL7+7zWpcuIdk5J/PvblxuWRpzldFrXeuNX+PXqJ4vgt4GA==
X-Received: by 2002:a05:6402:3549:: with SMTP id f9mr22856617edd.387.1627320293924;
        Mon, 26 Jul 2021 10:24:53 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id d22sm94798ejj.47.2021.07.26.10.24.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 10:24:53 -0700 (PDT)
Subject: Re: [PATCH v2 0/8] My AVIC patch queue
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e57ac09d-e697-f917-c19d-26fa74b2af7e@redhat.com>
Date:   Mon, 26 Jul 2021 19:24:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713142023.106183-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/07/21 16:20, Maxim Levitsky wrote:
> Hi!
> 
> This is a series of bugfixes to the AVIC dynamic inhibition, which was
> made while trying to fix bugs as much as possible, in this area and trying
> to make the AVIC+SYNIC conditional enablement work.
> 
> * Patches 1-4 address an issue of possible
>    mismatch between the AVIC inhibit state and AVIC enable state on all vCPUs.
> 
>    Since AVICs state is changed via a request there is a window during which
>    the states differ which can lead to various warnings and errors.
> 
>    There was an earlier attempt to fix this by changing the AVIC enable state
>    on the current vCPU immediately when the AVIC inhibit request is created,
>    however while this fixes the common case, it actually hides the issue deeper,
>    because on all other vCPUs but current one, the two states can still
>    mismatch till the KVM_REQ_APICV_UPDATE is processed on each of them.
> 
>    My take on this is to fix the places where the mismatch causes the
>    issues instead and then drop the special case of toggling the AVIC right
>    away in kvm_request_apicv_update.
> 
>    V2: I rewrote the commit description for the patch that touches
>      avic inhibition in nested case.
> 
> * Patches 5-6 in this series fix a race condition which can cause
>    a lost write from a guest to APIC when the APIC write races
>    the AVIC un-inhibition, and add a warning to catch this problem
>    if it re-emerges again.
> 
>    V2: I re-implemented this with a mutex in V2.
> 
> * Patch 7 is an  fix yet another issue I found in AVIC inhibit code:
>    Currently avic_vcpu_load/avic_vcpu_put are called on userspace entry/exit
>    from KVM (aka kvm_vcpu_get/kvm_vcpu_put), and these functions update the
>    "is running" bit in the AVIC physical ID remap table and update the
>    target vCPU in iommu code.
> 
>    However both of these functions don't do anything when AVIC is inhibited
>    thus the "is running" bit will be kept enabled during exit to userspace.
>    This shouldn't be a big issue as the caller
>    doesn't use the AVIC when inhibited but still inconsistent and can trigger
>    a warning about this in avic_vcpu_load.
> 
>    To be on the safe side I think it makes sense to call
>    avic_vcpu_put/avic_vcpu_load when inhibiting/uninhibiting the AVIC.
>    This will ensure that the work these functions do is matched.
> 
> * Patch 8 is the patch from Vitaly about allowing AVIC with SYNC
>    as long as the guest doesn’t use the AutoEOI feature. I only slightly
>    changed it to drop the SRCU lock around call to kvm_request_apicv_update
>    and also expose the AutoEOI cpuid bit regardless of AVIC enablement.
> 
>    Despite the fact that this is the last patch in this series, this patch
>    doesn't depend on the other fixes.
> 
> Best regards,
> 	Maxim Levitsky
> 
> Maxim Levitsky (7):
>    KVM: SVM: svm_set_vintr don't warn if AVIC is active but is about to
>      be deactivated
>    KVM: SVM: tweak warning about enabled AVIC on nested entry
>    KVM: SVM: use vmcb01 in svm_refresh_apicv_exec_ctrl
>    KVM: x86: APICv: drop immediate APICv disablement on current vCPU
>    KVM: x86: APICv: fix race in kvm_request_apicv_update on SVM
>    KVM: SVM: add warning for mistmatch between AVIC state and AVIC access
>      page state
>    KVM: SVM: call avic_vcpu_load/avic_vcpu_put when enabling/disabling
>      AVIC
> 
> Vitaly Kuznetsov (1):
>    KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in
>      use
> 
>   arch/x86/include/asm/kvm_host.h |  3 ++
>   arch/x86/kvm/hyperv.c           | 34 ++++++++++++++++----
>   arch/x86/kvm/svm/avic.c         | 45 ++++++++++++++------------
>   arch/x86/kvm/svm/nested.c       |  2 +-
>   arch/x86/kvm/svm/svm.c          | 18 ++++++++---
>   arch/x86/kvm/x86.c              | 57 ++++++++++++++++++---------------
>   include/linux/kvm_host.h        |  1 +
>   virt/kvm/kvm_main.c             |  1 +
>   8 files changed, 103 insertions(+), 58 deletions(-)
> 

Queued patches 1-4, thanks.

Paolo

