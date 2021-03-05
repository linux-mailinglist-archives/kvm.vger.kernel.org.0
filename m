Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BC832F12A
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 18:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCER1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 12:27:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28851 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229493AbhCER1m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Mar 2021 12:27:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614965261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bLxB2l1qRKkq52ZoCU3NDR4MPkAT8Rs45+g/2VRl+rw=;
        b=W469EHssZmQPFCfW6EfFs0RBBauroJrZMY5p9uHnu8RXlTEpLudPXCuH0PwfyDpHek55Zj
        bt6hp416szEnBfXNbMSNN0L6Uzvy6eHaMMmwZXg7L8RfbnQYltRK6WefdsUjqzA6tgXG2E
        8EjrtWUQZJZYYGvI8mEg30InqX8cBbg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-bg0x38exN5yjV2zd4Mk8ww-1; Fri, 05 Mar 2021 12:27:40 -0500
X-MC-Unique: bg0x38exN5yjV2zd4Mk8ww-1
Received: by mail-wr1-f72.google.com with SMTP id m9so1346765wrx.6
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 09:27:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bLxB2l1qRKkq52ZoCU3NDR4MPkAT8Rs45+g/2VRl+rw=;
        b=m6pGzefX8xmthVO2hOoxR5bQ6x0y7qmIOElbFw3a3HwseV6tijwK2pL4es4Ugm6EbR
         wKt9xpMvoiDzp28wCPtnlqf9H0/TqFL3TeZwFOIxMtRFmQJ+XwMFJspzoLFB5fKKolIU
         Fud76amrFiEvRfS03Vw8yi9f50zrgxuOR79bZWpNCwdHiL48VU7yEWAqoUKVJ+bL0uw4
         mx0IlmCi4jJQkeRnCdFm2ve9mV6nj+42+nSpROlYktjTBQXOHZB1K2DciKSwljbFC63Y
         tO3Z90kM59h/jUv3yQ/ptXQOFT7kSsWqDO62hsJRTBcqCMKrO9jVJAEYfPkkJE5XkrSS
         2HWA==
X-Gm-Message-State: AOAM533gzxiJujsicbME4L5F6azLO8QM0e5Dis5wdYTlOwC8Q7HFEO1V
        ZkwDTwklYingm2y3pH1R3i1dFNojnuw9WMbbAEZDnkQmyUX/cvtFUkU5TLziYtkennXkhrLmZND
        Wan1TPidCUeg1Rg7MRtaAR8OtOPml6hlS6aVulka0qAf/2xBbtJLIff+cEwOgzFog
X-Received: by 2002:a5d:63d2:: with SMTP id c18mr10413768wrw.277.1614965258880;
        Fri, 05 Mar 2021 09:27:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkbOTMiAdDixzDlmyw0o+BrvOtsI4Mh4wmSTXrH0tuUAuSZrSvkdc9LdEhdcKIKd6WWY0CAA==
X-Received: by 2002:a5d:63d2:: with SMTP id c18mr10413736wrw.277.1614965258679;
        Fri, 05 Mar 2021 09:27:38 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n5sm5001272wmq.7.2021.03.05.09.27.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 09:27:37 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.12, take #1
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
References: <20210305164944.3729910-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <847417af-fdab-9ca1-3edc-39f1d77cb6cb@redhat.com>
Date:   Fri, 5 Mar 2021 18:27:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210305164944.3729910-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/21 17:49, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the first batch of fixes for 5.12. We have a handful of low
> level world-switch regressions, a page table walker fix, more PMU
> tidying up, and a workaround for systems with creative firmware.
> 
> Note that this is based on -rc1 despite the breakage, as I didn't feel
> like holding these patches until -rc2.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit fe07bfda2fb9cdef8a4d4008a409bb02f35f1bd8:
> 
>    Linux 5.12-rc1 (2021-02-28 16:05:19 -0800)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.12-1
> 
> for you to fetch changes up to e85583b3f1fe62c9b371a3100c1c91af94005ca9:
> 
>    KVM: arm64: Fix range alignment when walking page tables (2021-03-04 09:54:12 +0000)

Hi Marc,

due to a severe data corruption bug in 5.12-rc1, Linus suggested not 
including 5.12-rc1 in trees to avoid it eating our filesystems 
unwittingly during future bisections.

Would it be a problem for you to rebase on top of your merge window pull 
request?  If there are conflicts, another possibility is for you to just 
send me the patch series.  I will handle all the topic branch juggling.

This will mean rewriting kvmarm.git's history, but it does seem to be 
the lesser (or the most future-proof) evil.

Thanks,

Paolo

> ----------------------------------------------------------------
> KVM/arm64 fixes for 5.12, take #1
> 
> - Fix SPE context save/restore on nVHE
> - Fix some subtle host context corruption on vcpu exit
> - Fix panic handling on nVHE
> - Prevent the hypervisor from accessing PMU registers when there is none
> - Workaround broken firmwares advertising bogus GICv2 compatibility
> - Fix Stage-2 unaligned range unmapping
> 
> ----------------------------------------------------------------
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

