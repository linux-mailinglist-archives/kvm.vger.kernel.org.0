Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF763028C7
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 18:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731016AbhAYRZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 12:25:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30187 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730668AbhAYRYB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 12:24:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611595352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LMaj7CkNnEbxNARZFdcDZTjqCgJ7QYeYI1k3Xem58ag=;
        b=M24ahvlWZi8zyRHXdFK73ezERrUuk3owFCS/ssCAEOFJaqwBGZl0iUnXAVhAIDH3RiCfwy
        gVCNzPDpKmbSDKOKIFJrBrTyeA7cTnBuXDmAuAHf1WdiE7JMDCeIXTAQUAI3r9LnhH4fxE
        mPSRjM1dhY38O9KoH7i26pATlG5HG8I=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-uN6Hv2_gO_ilfdmzRY0ZXQ-1; Mon, 25 Jan 2021 12:22:31 -0500
X-MC-Unique: uN6Hv2_gO_ilfdmzRY0ZXQ-1
Received: by mail-ej1-f72.google.com with SMTP id z2so4091038ejf.3
        for <kvm@vger.kernel.org>; Mon, 25 Jan 2021 09:22:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LMaj7CkNnEbxNARZFdcDZTjqCgJ7QYeYI1k3Xem58ag=;
        b=J5QLeDcXe/MnU7MP4jcXskzqhZd3H7Y4krcWcvla13PKDFrHZcBLHiTpmzm7KQ6v99
         8nXr2ACTXq4GXLlO8EelEKQnPrY2Vdnb0A2VFmYoCSXtiIB4RADNnp91om85NG3xgQ1q
         4YGPCyALnlAYof+Fk1V/s/OY48+ZxVzwlmZySNQH39LpfOuMFXA5lkOo6G2lde5zvixY
         bzD+nciVp1Rml68//1G4b+6fAzalLelLn/vyldHmWYuUIgvatAk+Nu98s6hoHc/UOFxu
         FUPDLWsnjK9fsVnrz77Dpa0mIVOunVQkCgpzFMebfosufZQbWipE++f2Fg7T7yrjAEQH
         525g==
X-Gm-Message-State: AOAM531ZtWqXYn8fl7fwDArdYPVuJ699+kWi9SSQ1fGYb+Wm4iP0NyDi
        +JLL+DuvIRD/b+plywHMjesqZzMnvKucQFM2z69YnoUxIl3MoERd2V8K9XUWp4LOFWelgxdaFKX
        KBQljZN+o6Vo5
X-Received: by 2002:a17:906:5958:: with SMTP id g24mr990737ejr.377.1611595349953;
        Mon, 25 Jan 2021 09:22:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwv5l+Mrc2U9qE+MMYwbCngwX6psPudgBFrDAPGxTNqASvvq3z5peNzORmDfO5fmo9ni1FAEg==
X-Received: by 2002:a17:906:5958:: with SMTP id g24mr990721ejr.377.1611595349417;
        Mon, 25 Jan 2021 09:22:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id zg7sm8669806ejb.31.2021.01.25.09.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 09:22:28 -0800 (PST)
Subject: Re: [PATCH 0/3] KVM: x86: Revert dirty tracking for GPRs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20210122235049.3107620-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a4fb32c1-808e-8f50-fcef-b95cfe41aad6@redhat.com>
Date:   Mon, 25 Jan 2021 18:22:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210122235049.3107620-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/01/21 00:50, Sean Christopherson wrote:
> This is effectively belated feedback on the SEV-ES series.  My primary
> interest is to revert the GPR dirty/available tracking, as it's pure
> overhead for non-SEV-ES VMs, and even for SEV-ES I suspect the dirty
> tracking is at best lost in the noise, and possibly even a net negative.
> 
> My original plan was to submit patches 1+3 as patch 1, taking a few
> creative liberties with the GHCB spec to justify writing the GHCB GPRs
> after every VMGEXIT.  But, since KVM is effectively writing the GHCB GPRs
> on every VMRUN, I feel confident in saying that my interpretation of the
> spec has already been proven correct.
> 
> The SEV-ES changes are effectively compile tested only, but unless I've
> overlooked a code path, patch 1 is a nop.  Patch 3 definitely needs
> testing.
> 
> Paolo, I'd really like to get patches 1 and 2 into 5.11, the code cost of
> the dirty/available tracking is not trivial.
> 
> Sean Christopherson (3):
>    KVM: SVM: Unconditionally sync GPRs to GHCB on VMRUN of SEV-ES guest
>    KVM: x86: Revert "KVM: x86: Mark GPRs dirty when written"
>    KVM: SVM: Sync GPRs to the GHCB only after VMGEXIT
> 
>   arch/x86/kvm/kvm_cache_regs.h | 51 +++++++++++++++++------------------
>   arch/x86/kvm/svm/sev.c        | 14 +++++-----
>   arch/x86/kvm/svm/svm.h        |  1 +
>   3 files changed, 34 insertions(+), 32 deletions(-)
> 

Queued 1-2, thanks!  Yes, these should be in 5.11.

Paolo

