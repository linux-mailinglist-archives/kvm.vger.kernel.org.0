Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B0632F92C
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 10:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhCFJuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Mar 2021 04:50:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229662AbhCFJuJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 6 Mar 2021 04:50:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615024208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wtTBL6IGeyh8BSRigo0CKkYcexJFfp/4IWRWxSSwnCI=;
        b=b9MaAX0rVm388DL/Vm0qC9YOo6vurAI/31Rm9xRKN97RMV6RxCtbMWOxYxI9wl8fry8G3T
        uUMYCIVKkX39AQw+suyJrxcAcwWuyj5ohXJ4fjGdtfK7f0nWmYqitOPMpYvoQz5qoYSRie
        4iQARwXtdkgyO+txqXNMohIDS8s8tqg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-bBjo3HXfOiukrJTH3pW2rg-1; Sat, 06 Mar 2021 04:50:07 -0500
X-MC-Unique: bBjo3HXfOiukrJTH3pW2rg-1
Received: by mail-wr1-f69.google.com with SMTP id n16so1209501wro.1
        for <kvm@vger.kernel.org>; Sat, 06 Mar 2021 01:50:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wtTBL6IGeyh8BSRigo0CKkYcexJFfp/4IWRWxSSwnCI=;
        b=liZhfIb7bFU3iu0hmGKX/JQClYgmdVIhrTCMvrp7bS4dL+J86vj9tt2PVxv5rWcdT2
         pJ2o2zT6QnjbwFD44n+RSTKLU5wVi2KH1//Qq+QU7LrYWaaYPtcWVof5Unl5U/98n5SZ
         U07A9XK4sL9IaPzdWUTngoAHokcr0LiUVg3CsviworXFEjQ2hjrK32b6uwdc6iNTTcVd
         a+VVVkIIlY/qtOR+1VwLs90xe1O9haKqjG7jEmN+lJs3XxWoRjynexZ7k7XajS+V/ckJ
         SK+29JDFydnMp7j6A9qnRShSxRLsshaHZbg6kKk7YKkTE8kTbu/Yeoom7q13w550WRa2
         5fHg==
X-Gm-Message-State: AOAM532ulcAQ9R4rlPuKaZktMcq0d+Xk5v0MDGSJEyyfWVFxmmYuFiru
        uNo9VvAxlYgUNAinMV058a3vxInSkpdjqCH0RCnhLS4AO0cvlFpc3xjcTkjxxxXChbirWhnaiNY
        Uu9LqM5pVdzBdAOtEH3s5B4MMS3Z+baUzAbECoAa3iYLQVJuBSzyFZRf8P9rH4M3A
X-Received: by 2002:a05:600c:2312:: with SMTP id 18mr12896202wmo.8.1615024205667;
        Sat, 06 Mar 2021 01:50:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz8afe+cwtYmFye2D6e0melYZ9I5pdVrhkTg5wC3o1VvGnf0tHz47eDy06nGS/FpuI4hTDltw==
X-Received: by 2002:a05:600c:2312:: with SMTP id 18mr12896177wmo.8.1615024205516;
        Sat, 06 Mar 2021 01:50:05 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id m132sm9079567wmf.45.2021.03.06.01.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Mar 2021 01:50:04 -0800 (PST)
Subject: Re: [PATCH 0/8] KVM/arm64 fixes for 5.12, take #1
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Howard Zhang <Howard.Zhang@arm.com>,
        Jia He <justin.he@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
References: <87eegtzbch.wl-maz@kernel.org>
 <20210305185254.3730990-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7a42527e-df78-35ea-4b93-8587effb46cd@redhat.com>
Date:   Sat, 6 Mar 2021 10:50:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210305185254.3730990-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/21 19:52, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the first batch of fixes for 5.12. We have a handful of low
> level world-switch regressions, a page table walker fix, more PMU
> tidying up, and a workaround for systems with creative firmware.
> 
> This will need to go on top of the current state of mainline.

Applied to kvm/next (because kvm/master is also on the problematic 
5.12-rc1 tags), thanks.

Paolo

> Please apply,
> 
> 	M.
> 
> Andrew Scull (1):
>        KVM: arm64: Fix nVHE hyp panic host context restore
> 
> Jia He (1):
>        KVM: arm64: Fix range alignment when walking page tables
> 
> Marc Zyngier (4):
>        KVM: arm64: Turn kvm_arm_support_pmu_v3() into a static key
>        KVM: arm64: Don't access PMSELR_EL0/PMUSERENR_EL0 when no PMU is available
>        KVM: arm64: Rename __vgic_v3_get_ich_vtr_el2() to __vgic_v3_get_gic_config()
>        KVM: arm64: Workaround firmware wrongly advertising GICv2-on-v3 compatibility
> 
> Suzuki K Poulose (1):
>        KVM: arm64: nvhe: Save the SPE context early
> 
> Will Deacon (1):
>        KVM: arm64: Avoid corrupting vCPU context register in guest exit
> 
>   arch/arm64/include/asm/kvm_asm.h        |  4 ++--
>   arch/arm64/include/asm/kvm_hyp.h        |  8 ++++++-
>   arch/arm64/kernel/image-vars.h          |  3 +++
>   arch/arm64/kvm/hyp/entry.S              |  2 +-
>   arch/arm64/kvm/hyp/include/hyp/switch.h |  9 +++++---
>   arch/arm64/kvm/hyp/nvhe/debug-sr.c      | 12 ++++++++--
>   arch/arm64/kvm/hyp/nvhe/host.S          | 15 +++++++------
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  6 ++---
>   arch/arm64/kvm/hyp/nvhe/switch.c        | 14 +++++++++---
>   arch/arm64/kvm/hyp/pgtable.c            |  1 +
>   arch/arm64/kvm/hyp/vgic-v3-sr.c         | 40 +++++++++++++++++++++++++++++++--
>   arch/arm64/kvm/perf.c                   | 10 +++++++++
>   arch/arm64/kvm/pmu-emul.c               | 10 ---------
>   arch/arm64/kvm/vgic/vgic-v3.c           | 12 +++++++---
>   include/kvm/arm_pmu.h                   |  9 ++++++--
>   15 files changed, 116 insertions(+), 39 deletions(-)
> 

