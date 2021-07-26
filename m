Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB7A3D6875
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 23:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhGZUbt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 16:31:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42380 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233162AbhGZUbs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 16:31:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627333936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GSObEM4AEGGdRTXQ6Y6EvNaI/wD9NZAhPCl3zKiUAv0=;
        b=UBJk/qqBisVzjNVEkEMs/SXN7Y0TfHobv3vf+pdXIXwTdY5l6hg1VhmImEkbAeJK31ip74
        NNU2Ta2HbG7D65n0JwOOIUe++wCpzxLpz0X0uVOqoi4soSaOG9rOgl3HknTGEM4FKuMS9V
        71Jr69Bkbe3tMW3VVBhvkVsreTrsNs4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-CSyE9ySEOgWzCp8wweZUOg-1; Mon, 26 Jul 2021 17:12:14 -0400
X-MC-Unique: CSyE9ySEOgWzCp8wweZUOg-1
Received: by mail-ed1-f70.google.com with SMTP id f24-20020a0564021618b02903954c05c938so5381184edv.3
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 14:12:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GSObEM4AEGGdRTXQ6Y6EvNaI/wD9NZAhPCl3zKiUAv0=;
        b=pRX6pajO3Rsvlh+6/UeGCKtSlusK3SxdtahnK3EojLJMfNazGnbFwRok2+iNCKgcap
         c7+Fk0rh3oTW/S6tPIDDulHeGyRXq2TJ1zUZ/vJbnVepPNEiqHfJTaY7Nh/2TZZ/8Z2y
         F20DpP3oq8w0byP7VffxqMsru/QTZ1mHaztApmkkeZmdV/Jf4/e3FsYc1sdeRAEyq2+E
         2TvROstDNQmnYAIeP8LMqC8FtK7a9lljt2x4cvKu+cK9zP8q5H4u50NYXy/jja/XI158
         wuQPzpq0PlT+3MPmOgpqoNI1Jt2r9Ux6INpFUIRVrzYos8LSG0MAuO5FKBbDHevhekX/
         FYyw==
X-Gm-Message-State: AOAM533CPBAzGHybl9irzcGRDAks/LyfykL2WryI7Voo4hb4ewYf2q0T
        Biztpe/ptrFIn0llowOlOpTq1RG4O8+LA8APhBjsCCTmIFIYR4L9holSTITQoFMlWMKEHgLh7GH
        n90eVylasmNh4
X-Received: by 2002:aa7:ccc1:: with SMTP id y1mr23542095edt.321.1627333933725;
        Mon, 26 Jul 2021 14:12:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyT64Mwq0V+1NZBNjc/2ncdGQChN2iFhzEKjOGwYIyaHPCUy425QTZPpFeBHXXyiHEURvlSw==
X-Received: by 2002:aa7:ccc1:: with SMTP id y1mr23542074edt.321.1627333933578;
        Mon, 26 Jul 2021 14:12:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id f15sm236675ejt.75.2021.07.26.14.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 14:12:13 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
References: <20210713163324.627647-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 00/46] KVM: x86: vCPU RESET/INIT fixes and
 consolidation
Message-ID: <c3563870-62c3-897d-3148-e48bb755310c@redhat.com>
Date:   Mon, 26 Jul 2021 23:12:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/07/21 18:32, Sean Christopherson wrote:
> The end goal of this series is to consolidate the RESET/INIT code, both to
> deduplicate code and to try to avoid divergent behavior/bugs, e.g. SVM only
> recently started updating vcpu->arch.cr4 on INIT.
> 
> The TL;DR of why it takes 40+ patches to get there is that the RESET/INIT
> flows have multiple latent bugs and hidden dependencies, but "work"
> because they're rarely touched, are mostly fixed flows in both KVM and the
> guest, and because guests don't sanity check state after INIT.
> 
> While several of the patches have Fixes tags, I am absolutely terrified of
> backporting most of them due to the likelihood of breaking a different
> version of KVM.  And, for the most part the bugs are benign in the sense
> no guest has actually encountered any of these bugs.  For that reason, I
> intentionally omitted stable@ entirely.  The only patches I would consider
> even remotely safe for backporting are the first four patches in the series.
> 
> v2:
>    - Collect Reviews. [Reiji]
>    - Fix an apic->base_address initialization goof. [Reiji]
>    - Add patch to flush TLB on INIT. [Reiji]
>    - Add patch to preserved CR0.CD/NW on INIT. [Reiji]
>    - Add patch to emulate #INIT after shutdown on SVM. [Reiji]
>    - Add patch to consolidate arch.hflags code. [Reiji]
>    - Drop patch to omit VMWRITE zeroing. [Paolo, Jim]
>    - Drop several MMU patches (moved to other series).
> 
> v1: https://lkml.kernel.org/r/20210424004645.3950558-1-seanjc@google.com
> 
> Sean Christopherson (46):
>    KVM: x86: Flush the guest's TLB on INIT
>    KVM: nVMX: Set LDTR to its architecturally defined value on nested
>      VM-Exit
>    KVM: SVM: Zero out GDTR.base and IDTR.base on INIT
>    KVM: VMX: Set EDX at INIT with CPUID.0x1, Family-Model-Stepping
>    KVM: SVM: Require exact CPUID.0x1 match when stuffing EDX at INIT
>    KVM: SVM: Fall back to KVM's hardcoded value for EDX at RESET/INIT
>    KVM: VMX: Remove explicit MMU reset in enter_rmode()
>    KVM: SVM: Drop explicit MMU reset at RESET/INIT
>    KVM: SVM: Drop a redundant init_vmcb() from svm_create_vcpu()
>    KVM: VMX: Move init_vmcs() invocation to vmx_vcpu_reset()
>    KVM: x86: WARN if the APIC map is dirty without an in-kernel local
>      APIC
>    KVM: x86: Remove defunct BSP "update" in local APIC reset
>    KVM: x86: Migrate the PIT only if vcpu0 is migrated, not any BSP
>    KVM: x86: Don't force set BSP bit when local APIC is managed by
>      userspace
>    KVM: x86: Set BSP bit in reset BSP vCPU's APIC base by default
>    KVM: VMX: Stuff vcpu->arch.apic_base directly at vCPU RESET
>    KVM: x86: Open code necessary bits of kvm_lapic_set_base() at vCPU
>      RESET
>    KVM: x86: Consolidate APIC base RESET initialization code
>    KVM: x86: Move EDX initialization at vCPU RESET to common code
>    KVM: SVM: Don't bother writing vmcb->save.rip at vCPU RESET/INIT
>    KVM: VMX: Invert handling of CR0.WP for EPT without unrestricted guest
>    KVM: VMX: Remove direct write to vcpu->arch.cr0 during vCPU RESET/INIT
>    KVM: VMX: Fold ept_update_paging_mode_cr0() back into vmx_set_cr0()
>    KVM: nVMX: Do not clear CR3 load/store exiting bits if L1 wants 'em
>    KVM: VMX: Pull GUEST_CR3 from the VMCS iff CR3 load exiting is
>      disabled
>    KVM: x86/mmu: Skip the permission_fault() check on MMIO if CR0.PG=0
>    KVM: VMX: Process CR0.PG side effects after setting CR0 assets
>    KVM: VMX: Skip emulation required checks during pmode/rmode
>      transitions
>    KVM: nVMX: Don't evaluate "emulation required" on nested VM-Exit
>    KVM: SVM: Tweak order of cr0/cr4/efer writes at RESET/INIT
>    KVM: SVM: Drop redundant writes to vmcb->save.cr4 at RESET/INIT
>    KVM: SVM: Stuff save->dr6 at during VMSA sync, not at RESET/INIT
>    KVM: VMX: Skip pointless MSR bitmap update when setting EFER
>    KVM: VMX: Refresh list of user return MSRs after setting guest CPUID
>    KVM: VMX: Don't _explicitly_ reconfigure user return MSRs on vCPU INIT
>    KVM: x86: Move setting of sregs during vCPU RESET/INIT to common x86
>    KVM: VMX: Remove obsolete MSR bitmap refresh at vCPU RESET/INIT
>    KVM: nVMX: Remove obsolete MSR bitmap refresh at nested transitions
>    KVM: VMX: Don't redo x2APIC MSR bitmaps when userspace filter is
>      changed
>    KVM: VMX: Remove unnecessary initialization of msr_bitmap_mode
>    KVM: VMX: Smush x2APIC MSR bitmap adjustments into single function
>    KVM: VMX: Remove redundant write to set vCPU as active at RESET/INIT
>    KVM: VMX: Move RESET-only VMWRITE sequences to init_vmcs()
>    KVM: SVM: Emulate #INIT in response to triple fault shutdown
>    KVM: SVM: Drop redundant clearing of vcpu->arch.hflags at INIT/RESET
>    KVM: x86: Preserve guest's CR0.CD/NW on INIT
> 
>   arch/x86/include/asm/kvm_host.h |   5 -
>   arch/x86/kvm/i8254.c            |   3 +-
>   arch/x86/kvm/lapic.c            |  26 +--
>   arch/x86/kvm/svm/sev.c          |   1 +
>   arch/x86/kvm/svm/svm.c          |  48 ++----
>   arch/x86/kvm/vmx/nested.c       |  24 ++-
>   arch/x86/kvm/vmx/vmx.c          | 270 +++++++++++++++-----------------
>   arch/x86/kvm/vmx/vmx.h          |   5 +-
>   arch/x86/kvm/x86.c              |  52 +++++-
>   9 files changed, 211 insertions(+), 223 deletions(-)
> 

Queued, except for patches 9-10.

I'd rather have init_vmcb/svm_vcpu_reset look more like the VMX code, 
with the INIT code moved to svm_vcpu_reset and the rest remaining in 
init_vmcb.

Paolo

