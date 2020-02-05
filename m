Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9054C153375
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgBEOzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:55:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24714 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726460AbgBEOzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 09:55:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580914543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Apr6jPFMPadZ6VcFfTXO/neiYKpBhQFen1bycOWrv0=;
        b=GE+uDbr6BRqqgychmOQ9qKaVUgI65rHxtoM4PxoytNWv5gBdbN5yri0JSgVWSRSyym+dYJ
        3J7GGf4/HcXQiEe+AL1Y0+PuDxCAVbnSitEbyuoF1bsUkkPVC0V14txg75zGFytAAgC6m5
        5bXm2bVU+/Jmgcmr8gjXdtVoI/nfbLw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-w6My6Ox7M86Cpah_ziUupQ-1; Wed, 05 Feb 2020 09:55:37 -0500
X-MC-Unique: w6My6Ox7M86Cpah_ziUupQ-1
Received: by mail-wr1-f70.google.com with SMTP id d15so1315190wru.1
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 06:55:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Apr6jPFMPadZ6VcFfTXO/neiYKpBhQFen1bycOWrv0=;
        b=rqIHZuVrFIYe7qSIC4NQ0nr/nlrWJhtoBa/5EStobs/aB26lCvjT27rOlCHh3lalaq
         L63BLPtEwV0TUd7xMIrzUgvNUs44aBvtfRJI8pC0Bg/q1J95a1aENhzjrstBZh57O/Hg
         eUSvzFdsn9JNG6XkouuEGnBS6INJ3ys05GKwSzAmjVGZ6LEKSbtG+cNDZ6lLZXMrIEwD
         NPiAnkqdBgRze93YEVvcTSX4KBkWwVg/4jvlJ9fP9MmHsHST9HmkHmIclcUoMolPNMVD
         35OpoZe1fZsmlQtBVp8x7zmu/1uo7Nsr2mK2T07lD2fnoHCBXVEilqxGA5EebmH6669E
         kflA==
X-Gm-Message-State: APjAAAVFfFp0u1kwknMubC+goqOl9IaWBPDRhyN00bC0uXTF9b6n3g9s
        vjDKn0YZjjzXZrN0nCyAnffUovB0YBXmkPSLXlt/ItO0fzD/s0ue2QzM8uq3f0+ysBjBYzMmxuH
        IHLWLJ1TWBRNU
X-Received: by 2002:a1c:5f06:: with SMTP id t6mr6232294wmb.32.1580914536326;
        Wed, 05 Feb 2020 06:55:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqxMDOPjQO1WGEO27EZ111Mu4rckUktMk9kud1PhMkGSCCGuov+QjkW9lVN5tJszG3vDKZQ1tg==
X-Received: by 2002:a1c:5f06:: with SMTP id t6mr6232275wmb.32.1580914536051;
        Wed, 05 Feb 2020 06:55:36 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a9f0:cbc3:a8a6:fc56? ([2001:b07:6468:f312:a9f0:cbc3:a8a6:fc56])
        by smtp.gmail.com with ESMTPSA id s65sm8834946wmf.48.2020.02.05.06.55.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 06:55:35 -0800 (PST)
Subject: Re: [PATCH 0/3] x86/kvm/hyper-v: fix enlightened VMCS & QEMU4.2
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
References: <20200205123034.630229-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <adbf1ea0-9c59-f683-ce03-a8fd92bfe488@redhat.com>
Date:   Wed, 5 Feb 2020 15:55:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200205123034.630229-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/02/20 13:30, Vitaly Kuznetsov wrote:
> With fine grained VMX feature enablement QEMU>=4.2 tries to do KVM_SET_MSRS
> with default (matching CPU model) values and in case eVMCS is also enabled,
> fails. While the regression is in QEMU, it may still be preferable to
> fix this in KVM.
> 
> It would be great if we could just omit the VMX feature filtering in KVM
> and make this guest's responsibility: if it switches to using enlightened
> vmcs it should be aware that not all hardware features are going to be
> supported. Genuine Hyper-V, however, fails the test. It, for example,
> enables SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES and without
> 'apic_access_addr' field in eVMCS there's not much we can do in KVM.
> Microsoft confirms the bug but it is unclear if it will ever get fixed
> in the existing Hyper-V versions as genuine Hyper-V never exposes
> these unsupported controls to L1.
> 
> Changes since 'RFC':
> - Go with the bare minimum [Paolo]
> 
> KVM RFC:
> https://lore.kernel.org/kvm/20200115171014.56405-1-vkuznets@redhat.com/
> 
> QEMU RFC@:
> https://lists.nongnu.org/archive/html/qemu-devel/2020-01/msg00123.html
> 
> Vitaly Kuznetsov (3):
>   x86/kvm/hyper-v: remove stale evmcs_already_enabled check from
>     nested_enable_evmcs()
>   x86/kvm/hyper-v: move VMX controls sanitization out of
>     nested_enable_evmcs()
>   x86/kvm/hyper-v: don't allow to turn on unsupported VMX controls for
>     nested guests
> 
>  arch/x86/kvm/vmx/evmcs.c  | 90 ++++++++++++++++++++++++++++++++++-----
>  arch/x86/kvm/vmx/evmcs.h  |  3 ++
>  arch/x86/kvm/vmx/nested.c |  3 ++
>  arch/x86/kvm/vmx/vmx.c    | 16 ++++++-
>  4 files changed, 99 insertions(+), 13 deletions(-)
> 

Queued, thanks.

Paolo

