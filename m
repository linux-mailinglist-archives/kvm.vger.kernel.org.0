Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE1F490FFD
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242083AbiAQR7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:59:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242069AbiAQR7X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 12:59:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642442363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oULSkyyD1La6mVoprfG9AWys6tTDMxcLXLzJ7PWaQaA=;
        b=d+g+H8LsL4NPkSDQr3a0jLkx1YL+UJQsllzG6HYvvf0FS9bzNDvF/6nDJ4MoHGBgiioQwZ
        /gJU2YVba7G0OKOircrbQd1xH5Rkz/uGZdLkHd3iQFvnhTTsqja007LvQ5XUOi//PT52+5
        fEYCqPcnAJ4p8fe0luSfLdTaQ95THb8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-xsN336pZMqy6Z1Hfc4TJbw-1; Mon, 17 Jan 2022 12:59:21 -0500
X-MC-Unique: xsN336pZMqy6Z1Hfc4TJbw-1
Received: by mail-wm1-f72.google.com with SMTP id w5-20020a1cf605000000b0034b8cb1f55eso5435490wmc.0
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 09:59:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oULSkyyD1La6mVoprfG9AWys6tTDMxcLXLzJ7PWaQaA=;
        b=PcSwqj5gilUn1Vs/jqYmwmtJBdKJ8GOHMsPPN/D/xlgyrapxaW9uoZM+1tqNTT3paz
         nqhjgfARg3+CVf1tYmYmUSzOvsdrkIQOoicepl9Xx9yetGxsLsAJNJ/IAVF+qKQTLj3U
         eyrkgqwqRSXzZGOL+0RceLLJJme6DD4Ynbogc9lIMjkUJ+qhCY+/YdmyJQlBq8rGQoVw
         2odUGL8BspMR0TChsheaOjaCXB4o6R4/0tNmeX8+g1x7C5F8NiVpBxoATi2cFL5UgFg6
         V7UZod5bUh4BmSBJz2lfC8qJJwoqYehSb3ggnEQ75IRNA1ziLWoldZU+d8M4RCzVEFj6
         W5eg==
X-Gm-Message-State: AOAM533nClT+szBY263G0TkFLimijoaV8EVnXWKlVWp6NkbD9Xjl9A4r
        PjSDgKjVBPrEQ2Re8AWGnV7YYVZbuL+/kRecv18baRe6upKkgYrETU9lqvCOwEa9bSP2+ZYG/TM
        PX7FhEi83ixO5
X-Received: by 2002:a5d:638c:: with SMTP id p12mr20817948wru.80.1642442360326;
        Mon, 17 Jan 2022 09:59:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzz0gZovTdCgz14mm3BIkBgMBsqldifLDLOSB0zad9vZ1Idc6/Emu8ix3sew7ZWfNGOlNic8w==
X-Received: by 2002:a5d:638c:: with SMTP id p12mr20817939wru.80.1642442360104;
        Mon, 17 Jan 2022 09:59:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id o8sm7747195wry.112.2022.01.17.09.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 09:59:19 -0800 (PST)
Message-ID: <aadbee28-054b-ddac-6b99-f7ee63e19d7c@redhat.com>
Date:   Mon, 17 Jan 2022 18:59:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 0/4] KVM: x86/mmu: Fix write-protection bug in the TDP
 MMU
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
References: <20220113233020.3986005-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220113233020.3986005-1-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/14/22 00:30, David Matlack wrote:
> While attempting to understand the big comment in
> kvm_mmu_slot_remove_write_access() about TLB flushing, I discovered a
> bug in the way the TDP MMU write-protects GFNs. I have not managed to
> reproduce the bug as it requires a rather complex set up of live
> migrating a VM that is using nested virtualization while the TDP MMU is
> enabled.
> 
> Patch 1 fixes the bug and is CC'd to stable.
> Patch 2-3 fix, document, and enforce invariants around MMU-writable
> and Host-writable bits.
> Patch 4 fixes up the aformentioned comment to be more readable.
> 
> Tested using the kvm-unit-tests and KVM selftests.
> 
> v2:
>   - Skip setting the SPTE when MMU-writable is already clear [Sean]
>   - Add patches for {MMU,Host}-writable invariants [Sean]
>   - Fix inaccuracies in kvm_mmu_slot_remove_write_access() comment [Sean]
> 
> v1: https://lore.kernel.org/kvm/20220112215801.3502286-1-dmatlack@google.com/
> 
> David Matlack (4):
>    KVM: x86/mmu: Fix write-protection of PTs mapped by the TDP MMU
>    KVM: x86/mmu: Clear MMU-writable during changed_pte notifier
>    KVM: x86/mmu: Document and enforce MMU-writable and Host-writable
>      invariants
>    KVM: x86/mmu: Improve TLB flush comment in
>      kvm_mmu_slot_remove_write_access()
> 
>   arch/x86/kvm/mmu/mmu.c     | 31 ++++++++++++++++++++--------
>   arch/x86/kvm/mmu/spte.c    |  1 +
>   arch/x86/kvm/mmu/spte.h    | 42 ++++++++++++++++++++++++++++++++------
>   arch/x86/kvm/mmu/tdp_mmu.c |  6 +++---
>   4 files changed, 62 insertions(+), 18 deletions(-)
> 
> 
> base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4

Queued, thanks.

Paolo

