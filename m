Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86066305DB7
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 15:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbhA0OAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 09:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbhA0N7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 08:59:08 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348BDC061574;
        Wed, 27 Jan 2021 05:58:28 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id rv9so2736805ejb.13;
        Wed, 27 Jan 2021 05:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HWOLqctN03iPgf1OHxnbyaiPwcazrOMON+VZMndD6U4=;
        b=eifbrOa7j6ER30jIUYtDpdiqHn9CZr7e+gR807aYg3fAn2g1AhDKNzvyP3M5qYhtfh
         Bg2JtfxFNfRKwHGDKkttqp5TvgosRvJkNrwKVYX4xhsJzZ9+EEpkOahCG9cpk0ZwBHjZ
         TpVWfvSDDbGitue4m3p5qXk+j0F6AcGadhLq8AEsVNbE8qJYTlXk2rnt8rMYXO0wxTVL
         xnB3LuxDDxcNIY9Ls8TC6zeHFDIhHIc+dV11NdpTlwEpHu6UKP1r+QRn3DyrIbnffgBS
         UZ0cLHT0L6pTikDgIMRPpYajN7FINL/Km9zXNqYD0fK2jl+43LZdsIJvm/oLJnrQ17NO
         XAoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HWOLqctN03iPgf1OHxnbyaiPwcazrOMON+VZMndD6U4=;
        b=Q3jEC1F7M4L+At0KCv7GcNUtenUBTVsNckiPkC4bDeDZS7gdyXa6vk0B2ot93uWVH8
         Rq7MLycEJbS32feXgF+IPK/EbgyYKHuItfAZDkPKzl344v5DSZ5fJc4HRRgsA23kcoJU
         q3XFNaCUdVh03yr8hr+0mNHtOXc8Gy8Bgles+8Jzvg+ovulnHjy7pLw4WsB4TiYAfNJs
         uVK4hDZ8QASB1pyI8ZR7MZvnntvGR+WrX7VC8AzZa2VArXTqHos3UIFe8K3WoA+metsf
         UHda1fkzz/xLS4S4LAjDObSD/rWjmhqDKy8UTP01raF4uFN63PreX2bBT/6qo20sKHBs
         /ecg==
X-Gm-Message-State: AOAM532iWKG7INsHWG8eAcZ9Fdm7kwNEAr/csgJ6R624kbngzyJe2KAm
        80g1bisB1H2oLTRxIynUmftXhJDARQJR8g==
X-Google-Smtp-Source: ABdhPJysSXhgaQ8FxkGoW4fuZXGpMNUkS45F4rmzs7fFCGXEfuO8n/ayd6F3eZ4H2dCrWBrB3IbiMA==
X-Received: by 2002:a17:906:c793:: with SMTP id cw19mr6721127ejb.246.1611755906888;
        Wed, 27 Jan 2021 05:58:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id gt12sm866450ejb.38.2021.01.27.05.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 05:58:25 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Subject: Re: [GIT PULL] KVM fixes for Linux 5.11-rc6
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210127102246.1599444-1-pbonzini@redhat.com>
Message-ID: <ab1f5612-dd23-3a5a-0bf0-13ab6bdcbfe4@redhat.com>
Date:   Wed, 27 Jan 2021 14:58:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210127102246.1599444-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/01/21 11:22, Paolo Bonzini wrote:
> Linus,
> 
> I sent this yesterday but I cannot find it in the archives (weird),
> so I am resending it.

Nevermind, I now see that you've pulled it already, though I've gotten 
no pr-tracker-bot reply either.  Sorry about the noise.

Paolo

> The following changes since commit 7c53f6b671f4aba70ff15e1b05148b10d58c2837:
> 
>    Linux 5.11-rc3 (2021-01-10 14:34:50 -0800)
> 
> are available in the Git repository at:
> 
>    https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
> 
> for you to fetch changes up to 9a78e15802a87de2b08dfd1bd88e855201d2c8fa:
> 
>    KVM: x86: allow KVM_REQ_GET_NESTED_STATE_PAGES outside guest mode for VMX (2021-01-25 18:54:09 -0500)
> 
> ----------------------------------------------------------------
> * x86 bugfixes
> * Documentation fixes
> * Avoid performance regression due to SEV-ES patches
> 
> ARM:
> - Don't allow tagged pointers to point to memslots
> - Filter out ARMv8.1+ PMU events on v8.0 hardware
> - Hide PMU registers from userspace when no PMU is configured
> - More PMU cleanups
> - Don't try to handle broken PSCI firmware
> - More sys_reg() to reg_to_encoding() conversions
> 
> ----------------------------------------------------------------
> Alexandru Elisei (1):
>        KVM: arm64: Use the reg_to_encoding() macro instead of sys_reg()
> 
> David Brazdil (1):
>        KVM: arm64: Allow PSCI SYSTEM_OFF/RESET to return
> 
> Jay Zhou (1):
>        KVM: x86: get smi pending status correctly
> 
> Like Xu (2):
>        KVM: x86/pmu: Fix UBSAN shift-out-of-bounds warning in intel_pmu_refresh()
>        KVM: x86/pmu: Fix HW_REF_CPU_CYCLES event pseudo-encoding in intel_arch_events[]
> 
> Lorenzo Brescia (1):
>        kvm: tracing: Fix unmatched kvm_entry and kvm_exit events
> 
> Marc Zyngier (4):
>        KVM: arm64: Hide PMU registers from userspace when not available
>        KVM: arm64: Simplify handling of absent PMU system registers
>        KVM: arm64: Filter out v8.1+ events on v8.0 HW
>        KVM: Forbid the use of tagged userspace addresses for memslots
> 
> Maxim Levitsky (1):
>        KVM: nVMX: Sync unsync'd vmcs02 state to vmcs12 on migration
> 
> Paolo Bonzini (2):
>        Merge tag 'kvmarm-fixes-5.11-2' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
>        KVM: x86: allow KVM_REQ_GET_NESTED_STATE_PAGES outside guest mode for VMX
> 
> Quentin Perret (1):
>        KVM: Documentation: Fix spec for KVM_CAP_ENABLE_CAP_VM
> 
> Sean Christopherson (3):
>        KVM: x86: Add more protection against undefined behavior in rsvd_bits()
>        KVM: SVM: Unconditionally sync GPRs to GHCB on VMRUN of SEV-ES guest
>        KVM: x86: Revert "KVM: x86: Mark GPRs dirty when written"
> 
> Steven Price (1):
>        KVM: arm64: Compute TPIDR_EL2 ignoring MTE tag
> 
> Zenghui Yu (1):
>        KVM: Documentation: Update description of KVM_{GET,CLEAR}_DIRTY_LOG
> 
>   Documentation/virt/kvm/api.rst       | 21 ++++----
>   arch/arm64/kvm/arm.c                 |  3 +-
>   arch/arm64/kvm/hyp/nvhe/psci-relay.c | 13 ++---
>   arch/arm64/kvm/pmu-emul.c            | 10 ++--
>   arch/arm64/kvm/sys_regs.c            | 93 ++++++++++++++++++++++--------------
>   arch/x86/kvm/kvm_cache_regs.h        | 51 ++++++++++----------
>   arch/x86/kvm/mmu.h                   |  9 +++-
>   arch/x86/kvm/svm/nested.c            |  3 ++
>   arch/x86/kvm/svm/sev.c               | 15 +++---
>   arch/x86/kvm/svm/svm.c               |  2 +
>   arch/x86/kvm/vmx/nested.c            | 44 ++++++++++++-----
>   arch/x86/kvm/vmx/pmu_intel.c         |  6 ++-
>   arch/x86/kvm/vmx/vmx.c               |  2 +
>   arch/x86/kvm/x86.c                   | 11 +++--
>   virt/kvm/kvm_main.c                  |  1 +
>   15 files changed, 172 insertions(+), 112 deletions(-)
> 

