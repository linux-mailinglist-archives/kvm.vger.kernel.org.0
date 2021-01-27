Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCB73062A2
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 18:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344193AbhA0Rvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 12:51:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343752AbhA0R1t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 12:27:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611768378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WsGoAY8pVGqoZZBbJ/C6seN6vjaWljQXnMBoXIykYjQ=;
        b=jRnASFcZDbSC2tvnV/yi2HWrqgdUZ38R5Kl5cBNuUd9dRRQvJfTcC0pocz4vvdeQH4zd5h
        0YgF8ayMDk1Ot5CjbPwI2CQL6E5dWCSeq2eVIYem2ch7OleYjUfUrz8CEdaBk6Vu7YX1eg
        DgYlb82SRf0gNVaNVFbhct1TP2QSFUI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-jd5rBVD4NxaSXfFtM8O2HQ-1; Wed, 27 Jan 2021 12:26:16 -0500
X-MC-Unique: jd5rBVD4NxaSXfFtM8O2HQ-1
Received: by mail-ej1-f69.google.com with SMTP id h4so978631eja.12
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 09:26:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WsGoAY8pVGqoZZBbJ/C6seN6vjaWljQXnMBoXIykYjQ=;
        b=MmM7ZjQ3MMun9bNBGQwYYbFuU9TkQSMU4/DIZmRy6V9c1qGHN8UAOblqQGgeeVoMRJ
         tfvMtpauQ7+4LVD5tkQMn0wwdL3i0QWNKJBBZHI5WKIegwbXbNazWbXOvHWuJhKjr9fs
         2xv1viVkgbs8Iek7GyooGB7blPiQ03eTTs1keceCMCFYvcKWU5SgDpQqErHUDShANTry
         2gh3NWTDBgYHm9anSknL8h2QTzgRgHx5LJwS4Vq9WFyJ4eCaGTAefyQBEODo+Sr+cFZ1
         hB9/bko6R15beSCP1f5zG4/KVr0QgmK859/d48zlfMbLJQT8ZlX4o8AU5PYUWs6qzK3y
         PSSg==
X-Gm-Message-State: AOAM532Xrb5DUrIDnSeFfgE6eQWEzsc7cZoN7aYN+FkFufU13GYS86mZ
        dVn+tTDK0BwuIbu/rDUyBlExbXR+6k/g4jMeWN83Osq3TH+0IQGmbkg0uz6+qzMbiCGAAJ44p+I
        DX9kRWQ9Tc/48
X-Received: by 2002:a17:906:380c:: with SMTP id v12mr2017716ejc.65.1611768374862;
        Wed, 27 Jan 2021 09:26:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz2T/f/5/DAjBZR2Gan/w1d/Od/Ic6hzZanyHpw1hGWI56YFXumEXsPba1fF57WAmEHBXM1VA==
X-Received: by 2002:a17:906:380c:: with SMTP id v12mr2017694ejc.65.1611768374611;
        Wed, 27 Jan 2021 09:26:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k9sm1140356ejp.83.2021.01.27.09.26.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 09:26:13 -0800 (PST)
Subject: Re: [PATCH 0/9] x86/virt: KVM: x86: Exception handling fixes/cleanups
To:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David P . Reed" <dpreed@deepplum.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Uros Bizjak <ubizjak@gmail.com>
References: <20201231002702.2223707-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8880fedc-14aa-1f14-b87b-118ebe0932a2@redhat.com>
Date:   Wed, 27 Jan 2021 18:26:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201231002702.2223707-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/12/20 01:26, Sean Christopherson wrote:
> This series is a conglomeration of three previous series/patches and a bit
> of new code.  None of the previous series are directly related, but they
> are all needed to achieve the overarching goal of nuking
> __kvm_handle_fault_on_reboot(), which is a rather ugly inline asm macro
> that has the unfortunate side effect of inserting in-line JMP+CALL
> sequences.
> 
> Patches 1-3 are resurrected from a series by David Reed[1] to fix VMXOFF
> bugs in the reboot flows.
> 
> Patch 4 is a patch from Uros Bizjak to get rid of custom inline asm in
> nested VMX.  This already received Paolo's "Queued, thanks." blessing,
> but has not been pushed to kvm.git.  It's included here as there is an
> indirect dependency in patch 8.
> 
> Patches 5-6 are minor tweaks to KVM's VMX{ON/OFF} paths to use the
> kernel's now-fault-tolerant VMXOFF instead of KVM's custom asm.
> 
> Patch 7 replaces SVM's __ex()/__kvm_handle_fault_on_reboot() with more
> tailored asm goto macros, similar to the existing VMX asm_vmx*() macros.
> This is largely an excuse to get rid of __kvm_handle_fault_on_reboot();
> the actual benefits of removing JMP+CALL are likely negligible as SVM only
> has a few uses of the macro (versus VMX's bajillion VMREADs/VMWRITEs).
> 
> Patch 8 removes __ex()/__kvm_handle_fault_on_reboot().
> 
> Patch 9 is a very trimmed down version of a different patch from Uros[3],
> which cleaned up the __ex()/__kvm_handle_fault_on_reboot() code, as
> opposed to zapping them entirely.
> 
> [1] https://lkml.kernel.org/r/20200704203809.76391-1-dpreed@deepplum.com
> [2] https://lkml.kernel.org/r/20201029134145.107560-1-ubizjak@gmail.com
> [3] https://lkml.kernel.org/r/20201221194800.46962-1-ubizjak@gmail.com
> 
> David P. Reed (1):
>    x86/virt: Mark flags and memory as clobbered by VMXOFF
> 
> Sean Christopherson (6):
>    x86/virt: Eat faults on VMXOFF in reboot flows
>    x86/reboot: Force all cpus to exit VMX root if VMX is supported
>    KVM: VMX: Move Intel PT shenanigans out of VMXON/VMXOFF flows
>    KVM: VMX: Use the kernel's version of VMXOFF
>    KVM: SVM: Use asm goto to handle unexpected #UD on SVM instructions
>    KVM: x86: Kill off __ex() and __kvm_handle_fault_on_reboot()
> 
> Uros Bizjak (2):
>    KVM/nVMX: Use __vmx_vcpu_run in nested_vmx_check_vmentry_hw
>    KVM: x86: Move declaration of kvm_spurious_fault() to x86.h
> 
>   arch/x86/include/asm/kvm_host.h | 25 --------------
>   arch/x86/include/asm/virtext.h  | 25 ++++++++++----
>   arch/x86/kernel/reboot.c        | 30 ++++++-----------
>   arch/x86/kvm/svm/sev.c          |  5 ++-
>   arch/x86/kvm/svm/svm.c          | 18 +---------
>   arch/x86/kvm/svm/svm_ops.h      | 59 +++++++++++++++++++++++++++++++++
>   arch/x86/kvm/vmx/nested.c       | 32 ++----------------
>   arch/x86/kvm/vmx/vmenter.S      |  2 +-
>   arch/x86/kvm/vmx/vmx.c          | 28 ++++++----------
>   arch/x86/kvm/vmx/vmx.h          |  1 +
>   arch/x86/kvm/vmx/vmx_ops.h      |  4 +--
>   arch/x86/kvm/x86.c              |  9 ++++-
>   arch/x86/kvm/x86.h              |  2 ++
>   13 files changed, 117 insertions(+), 123 deletions(-)
>   create mode 100644 arch/x86/kvm/svm/svm_ops.h
> 

Queued, thanks.

Paolo

