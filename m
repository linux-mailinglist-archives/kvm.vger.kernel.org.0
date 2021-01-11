Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EED22F1C6C
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 18:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389576AbhAKRdb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 12:33:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389573AbhAKRda (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 12:33:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610386324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zsTOKgciTV89wIpixObU4B7sv76RXsMzj7Th3SejzMQ=;
        b=TG+yET7T8TXhtt4nVvh0VRd/WhUCMbhfooXcJAZKFHNHYPJJBDnaPJp3Bz2dWaDHBma/we
        DFAYors+/886estPDFZbAZgY70MMd28//yBGETH1j5cYmY1Xne0A3cV2+wdzdtdmF7s2Zi
        Bso+kxSA7Qu1pfubmPw9caUFEdHQ6dY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-Cd9UEke5OzWThzqMzk3NTg-1; Mon, 11 Jan 2021 12:32:02 -0500
X-MC-Unique: Cd9UEke5OzWThzqMzk3NTg-1
Received: by mail-ej1-f71.google.com with SMTP id d19so179627ejo.18
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 09:32:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zsTOKgciTV89wIpixObU4B7sv76RXsMzj7Th3SejzMQ=;
        b=aEAqJ1UvAen4QXiuiU5yew853e6ARweg5fEGqpvxTXffDgQfGLuNQEf02mYVRweq0D
         a4FG6igmX427o636xUzGWytpCxhiwDfjA1C1mI/3awHZmlubWNVRItDZOwi3wlU+gnz4
         iNoh3rX7JEsvUP/6GDHgByEaCGFLlO1afVBHiznLcNmKD9p5Hl3oNcl5QRBxX2E9STRi
         elvanyBEOb3vYSwGP41OdLTAReYZkWyps1LNzF7t1QT+Dx6lEkxS27aiHopBHIiUQZOY
         wG0U9g3P6U7dWFvg8mFlVJQHu8RSeE1A57qzgFDhTpYELuhW9DO4ShG849ky7JELcXOS
         toBQ==
X-Gm-Message-State: AOAM533butG71uNtPeIAl3XFycXMZ3Gfx6b8v1v8Ecm17GtMvqacuCmD
        cngmatVPRFiEdt0/mOumnW4Y93BY2rG8f1HnqwoIUxqgONfuALVOYvnREeL4qXLlUa+fOa73EzB
        QRXXIoVZqJfTy
X-Received: by 2002:a17:906:65a:: with SMTP id t26mr378403ejb.394.1610386321099;
        Mon, 11 Jan 2021 09:32:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwKXahcCk4gQhje80Bzfm9XS00VyakRL8IiG/KJMIUcgS2sE1kIv09C/lVjahr+RnI3fQ1uvw==
X-Received: by 2002:a17:906:65a:: with SMTP id t26mr378393ejb.394.1610386320959;
        Mon, 11 Jan 2021 09:32:00 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id dk16sm105625ejb.85.2021.01.11.09.31.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 09:32:00 -0800 (PST)
Subject: Re: [PATCH 0/2] Use static_call for kvm_x86_ops
To:     Jason Baron <jbaron@akamai.com>, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, aarcange@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1610379877.git.jbaron@akamai.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f56312ed-32d5-f1ca-8ca8-6de20daa955e@redhat.com>
Date:   Mon, 11 Jan 2021 18:31:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <cover.1610379877.git.jbaron@akamai.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/01/21 17:57, Jason Baron wrote:
> Hi,
> 
> Convert kvm_x86_ops to use static_call. Shows good performance
> gains for cpuid loop micro-benchmark (resulsts included in patch 2).
> 
> Thanks,
> 
> -Jason
> 
> Jason Baron (2):
>    KVM: x86: introduce definitions to support static calls for kvm_x86_ops
>    KVM: x86: use static calls to reduce kvm_x86_ops overhead
> 
>   arch/x86/include/asm/kvm_host.h |  71 +++++++++-
>   arch/x86/kvm/cpuid.c            |   2 +-
>   arch/x86/kvm/hyperv.c           |   4 +-
>   arch/x86/kvm/irq.c              |   2 +-
>   arch/x86/kvm/kvm_cache_regs.h   |  10 +-
>   arch/x86/kvm/lapic.c            |  28 ++--
>   arch/x86/kvm/mmu.h              |   6 +-
>   arch/x86/kvm/mmu/mmu.c          |  12 +-
>   arch/x86/kvm/mmu/spte.c         |   2 +-
>   arch/x86/kvm/pmu.c              |   2 +-
>   arch/x86/kvm/trace.h            |   4 +-
>   arch/x86/kvm/x86.c              | 299 ++++++++++++++++++++--------------------
>   arch/x86/kvm/x86.h              |   6 +-
>   13 files changed, 259 insertions(+), 189 deletions(-)
> 

Thank you thank you thank you! :)

(Except that now I have to find another task for a new KVM developer, 
but that's not a big deal).

Paolo

