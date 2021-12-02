Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8F946638C
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 13:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358120AbhLBMY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 07:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357907AbhLBMYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 07:24:14 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEF6C0613E1;
        Thu,  2 Dec 2021 04:20:52 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id t5so115400271edd.0;
        Thu, 02 Dec 2021 04:20:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P5tGu+doPfQ5xU8fjrdaQlDbiw4RiPi68N0ro/UhxSU=;
        b=b5w4yWRLdbNImCjLGmQLk1mdmbecSb3Oeo92A3qHbQV4iYEkD+JBJ/tzL90h4xmEJL
         71GOcHEOuvX+0EWUVhkV4CtVrua5unoqnGkT369VokSduJnVvJpJn3Lz2CIugzob4APR
         d1U8GKYde1dLphtLyclVLcELITjPxyua7Sm8rS1PjRVF4btR/itNCCN4sqiF5D2m03KM
         f7FcXURZoODpiaTAECIXMaBVX2W6eCo1yPTvMtxb5Ug9DNz7dedimyPb3YQ/swSNQ4tY
         UjZomI9GqaRm1nKF+YxK5LLZT9EE+32rJcFWV+rIyLvRfNivisKm3UgsJyMuYpqROERz
         yOJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P5tGu+doPfQ5xU8fjrdaQlDbiw4RiPi68N0ro/UhxSU=;
        b=DO1oq2kqt0smre1KdPE+lU8uyzWs4YV7SRognaDTnjlqkn3eLi4JaWK2KWg/m76vPE
         75JwWiW9gkM0d9SF0HcpvEHRWpxqQ53eTF8zsa1IuQqZPYaOYM79FI5TYuRo74h/yKPU
         ciY1kCe3HJvhgrf+otGKMEX7gzMe0YSysBKJ9fSubL50luDCQLZhEVXryJqHPp5WuDt1
         28txPz2DoXJIJuJFMnUu9g15BsYbdlZe3GeFu0JASNy29t9kvCIXR5PLDRfokJjq2nFh
         96mhCX8nFAGAR7UMw4As3OONXO8hR9TtFdPZ+JHn/MT4oGbi4uui/r8DX9iUuyE7VXSA
         fM7A==
X-Gm-Message-State: AOAM533O9+NJTGFCS8OBdab2b/9H51SUQ4XlfEZFJbBVWpfpZiBUej4A
        HDNXmesEuq60efmMCLm/uwk=
X-Google-Smtp-Source: ABdhPJylrmUFTOaeXzjFXhf99NYu1fPstNZ4ud28T0KhTJl0cc//6w1+3j2GitUO7rjErWHZPIMvag==
X-Received: by 2002:a05:6402:4311:: with SMTP id m17mr17339376edc.103.1638447649241;
        Thu, 02 Dec 2021 04:20:49 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id f22sm2268274edf.93.2021.12.02.04.20.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 04:20:48 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3e988837-436f-93ea-1679-915aec2733be@redhat.com>
Date:   Thu, 2 Dec 2021 13:20:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 0/4] KVM: nVMX: Enlightened MSR Bitmap feature for
 Hyper-V on KVM
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20211129094704.326635-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211129094704.326635-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/29/21 10:47, Vitaly Kuznetsov wrote:
> Changes since "[PATCH v4 0/8] KVM: nVMX: Enlightened MSR Bitmap feature for
> Hyper-V on KVM (+ KVM: x86: MSR filtering and related fixes)":
> - Drop Sean's "KVM: x86: MSR filtering and related fixes" as they're
>   already queued, rebase to the latest kvm/queue.
> 
> Original description of the feature:
> 
> Updating MSR bitmap for L2 is not cheap and rearly needed. TLFS for Hyper-V
> offers 'Enlightened MSR Bitmap' feature which allows L1 hypervisor to
> inform L0 when it changes MSR bitmap, this eliminates the need to examine
> L1's MSR bitmap for L2 every time when 'real' MSR bitmap for L2 gets
> constructed.
> 
> When the feature is enabled for Win10+WSL2, it shaves off around 700 CPU
> cycles from a nested vmexit cost (tight cpuid loop test).
> 
> First patch of the series is unrelated to the newly implemented feature,
> it fixes a bug in Enlightened MSR Bitmap usage when KVM runs as a nested
> hypervisor on top of Hyper-V.
> 
> Vitaly Kuznetsov (4):
>    KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
>    KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
>    KVM: nVMX: Track whether changes in L0 require MSR bitmap for L2 to be
>      rebuilt
>    KVM: nVMX: Implement Enlightened MSR Bitmap feature
> 
>   arch/x86/kvm/hyperv.c     |  2 ++
>   arch/x86/kvm/vmx/nested.c | 23 +++++++++++++++++++++-
>   arch/x86/kvm/vmx/vmx.c    | 41 ++++++++++++++++++++++++++-------------
>   arch/x86/kvm/vmx/vmx.h    |  9 +++++++++
>   4 files changed, 61 insertions(+), 14 deletions(-)
> 

Queued, thanks.

Paolo
