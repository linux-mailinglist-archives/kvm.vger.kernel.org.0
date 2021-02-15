Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E355F31BFB2
	for <lists+kvm@lfdr.de>; Mon, 15 Feb 2021 17:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhBOQsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 11:48:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49469 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230255AbhBOQrN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Feb 2021 11:47:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613407529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v2lFUCX+4kgOW9WJ4+n8lk62Y3uHoeoTMYbOZCSXAAQ=;
        b=b2GLpVcZTyBf4bt8r/ElESAfdq/W3HI6pAYmFl+Fot8n9sADLnmpL6cPb+PYWEVk9YeLqy
        VRjJv7pSkeJ69xdTVYMk4dkyjPmoUoaplv82NXMxcRC98X4sxyxQVOmGilIQ9Z+UOjQFE7
        qVYcuxsu5TSlIsQgsFIDWIVeZ1OcWGE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-hE4EwAINMyq8Wto1-GPr2Q-1; Mon, 15 Feb 2021 11:45:27 -0500
X-MC-Unique: hE4EwAINMyq8Wto1-GPr2Q-1
Received: by mail-ed1-f69.google.com with SMTP id g6so5511045edy.9
        for <kvm@vger.kernel.org>; Mon, 15 Feb 2021 08:45:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v2lFUCX+4kgOW9WJ4+n8lk62Y3uHoeoTMYbOZCSXAAQ=;
        b=Uq5q+eHzg3xS+AxvG+heOriURwh0tqCcVC94CzuMT6nU7jUpPImZOBQVWmC0l/hy3L
         IOm2oK9rUg6SnkYctEopT8cnQiDFYnb94trweL98DBs1GVA/UV656OfUTRAZGXoXmrl1
         w9TVFkzFx74OhUhfOKIsMcJb8tWauAP4XPNoX3jqIF9lYRuL7j3W3j7X5vPW9TIXaLm7
         j2UjvL4CFb26EgbnmlQE8h7EQvDIbMrENUXVUpBImSWDNjAzOgL8Civtw3UiXa4/rJMe
         htjdZtvjAoy/7rAwkNHcF4bklBKlVPFKYI3xqPU/O+NGv1G0pTqgy6o7tMa7lfOkgsem
         UUYA==
X-Gm-Message-State: AOAM532pBgU4R8A92Q2opdmOzC5nIu6bNTeajn6W2OMcfvUU2GAcUyTN
        wtcD/Xfq8fbAsDZkV8r8eBn27fSdxXPwrny7kp2fqawCpFLfC93CroGZSYFucdo35bcs5HVaFEk
        Jo6X9VRNGMfRf
X-Received: by 2002:a17:907:11c7:: with SMTP id va7mr16473919ejb.351.1613407526359;
        Mon, 15 Feb 2021 08:45:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBfHqnRxLbv+dwOEC17d5YwjhX3h5Z8eCWeAyeZ1sOKlSQFTMM6XcrEZIe5j+tRH/AafsC8A==
X-Received: by 2002:a17:907:11c7:: with SMTP id va7mr16473899ejb.351.1613407526163;
        Mon, 15 Feb 2021 08:45:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id hc40sm10301803ejc.50.2021.02.15.08.45.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Feb 2021 08:45:25 -0800 (PST)
Subject: Re: [PATCH 0/3] KVM: x86: SVM INVPCID fix, and cleanups
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>
References: <20210212003411.1102677-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <65fa42a3-4f7b-4708-ffce-e77fe32aaed7@redhat.com>
Date:   Mon, 15 Feb 2021 17:45:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210212003411.1102677-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/02/21 01:34, Sean Christopherson wrote:
> Fix an INVPCID bug on SVM where it fails to injected a #UD when INVPCID is
> supported but not exposed to the guest.  Do a bit of cleanup in patch 02
> now that both VMX and SVM support PCID/INVPCID.
> 
> Patch 03 address KVM behavior that has long confused the heck out of me.
> KVM currently allows enabling INVPCID if and only if PCID is also enabled
> for the guest, the justification being that the guest will see incorrect
> fault behavior (#UD instead of #GP) due to the way the VMCS control works.
> 
> But that makes no sense, because nothing is forcing KVM to disable INVCPID
> in the VMCS when PCID is disabled.  AFACIT, the myth was the result of a
> bug in the original _submission_, not even the original _commit_ was buggy.
> 
> Digging back, the very original submission had this code, where
> vmx_pcid_supported() was further conditioned on EPT being enabled.  This
> would lead to the buggy scenario of unexpected #UD, as a host with PCID
> and INVCPID would fail to enable INVPCID if EPT was disabled.
> 
>>> +	if (vmx_pcid_supported()) {
>>> +		exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
>>> +		if (exec_control & SECONDARY_EXEC_ENABLE_INVPCID) {
>>> +			best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
>>> +			if (best && (best->ecx & bit(X86_FEATURE_PCID)))
>>> +				vmx->invpcid_enabled = true;
>>> +			else {
>>> +				exec_control &= ~SECONDARY_EXEC_ENABLE_INVPCID;
>>> +				vmcs_write32(SECONDARY_VM_EXEC_CONTROL,
>>> +						exec_control);
>>> +				best = kvm_find_cpuid_entry(vcpu, 0x7, 0);
>>> +				best->ecx &= ~bit(X86_FEATURE_INVPCID);
>>> +			}
>>> +		}
>>> +	}
> 
> The incorrect behavior is especially problematic now that SVM also
> supports INVCPID, as KVM allows !PCID && INVPCID on SVM but not on VMX.
> 
> Patches to fix kvm-unit-tests are also incoming...
> 
> Sean Christopherson (3):
>    KVM: SVM: Intercept INVPCID when it's disabled to inject #UD
>    KVM: x86: Advertise INVPCID by default
>    KVM: VMX: Allow INVPCID in guest without PCID
> 
>   arch/x86/kvm/cpuid.c   |  2 +-
>   arch/x86/kvm/svm/svm.c | 11 ++++-------
>   arch/x86/kvm/vmx/vmx.c | 14 ++------------
>   3 files changed, 7 insertions(+), 20 deletions(-)
> 

Queued, thanks.

Paolo

