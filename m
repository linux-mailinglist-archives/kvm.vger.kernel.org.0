Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AA6307D3F
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 19:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhA1R75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 12:59:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26674 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231127AbhA1R6i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 12:58:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611856629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oUrhpiGGbTD0gAMn83fBLzGBVoI9/BE/KMSqjcuvSN0=;
        b=Hh5ZsBwCRyHSXcMxOy1oR5E82FYuWYChIi4yBuwh4yKSh5jroWbKCI4rFU5G8yruozy2YF
        8quKcXdVvekjbBxLysaVZj7z/LitXO5Wn8K+MtU9YjAc7ObdBusd0Optx78vny3pxKsFGJ
        JoPe2I3ECcGvE47WqR8ftDju5iRrG80=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-9KaJ-0zhPa6apyGuNAsRgA-1; Thu, 28 Jan 2021 12:57:05 -0500
X-MC-Unique: 9KaJ-0zhPa6apyGuNAsRgA-1
Received: by mail-ej1-f72.google.com with SMTP id yc16so853551ejb.11
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 09:57:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oUrhpiGGbTD0gAMn83fBLzGBVoI9/BE/KMSqjcuvSN0=;
        b=d48InupznWKJXIqFCXIh40EG+p23iovgxu/ITnCa+2yErk2NwDI+KvhbY0EViIYQMO
         eRgaNYltUT52lAiF4wiAbzlTg+okKGKfGB9JWBun6tJF+6DzUwvywuMKG/D9g1c0cqXd
         3+ycYsmY82x+lJfjqfylNeKzm1KlD8tj1Rsex+byX0HofuCMkkC5OeZ+MFuXnU+8Ts/a
         iDBpp0e8HDvSM/153yOIkvcg7FyvzL5NvFyuAE1qmaudisIjWRTRi/Br3b8rw/FSsu5K
         V4KXGViNicqIyOoboC3/4MLJ1Ka9CdCpfz6Vu/Y4FEmFETvkER67olZDi9xyK23n2nj3
         isWA==
X-Gm-Message-State: AOAM531m5++s1MQVv1+iM7KRIQjvQYfJI+fhMWb6prLYyaTobCVWG31i
        OqcuAE4m/JJnO7OD/sRWmpv2l5TJlHJZ5spP1SPTcKzBQ1bXxN/iyCuFwXq6VepUE/sgsXhzeJh
        Emx+NXH24ziW9
X-Received: by 2002:a05:6402:254b:: with SMTP id l11mr830455edb.202.1611856624121;
        Thu, 28 Jan 2021 09:57:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzhv5xdUV2+d83mJyPr/00SecV4xuLtdToo7JnM2GR2etJ9J2KmSq5DkCGTyEAmpBCetgZsEA==
X-Received: by 2002:a05:6402:254b:: with SMTP id l11mr830432edb.202.1611856623910;
        Thu, 28 Jan 2021 09:57:03 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h12sm3219173edb.16.2021.01.28.09.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:57:02 -0800 (PST)
Subject: Re: [PATCH v14 00/13] Introduce support for guest CET feature
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        Sean Christopherson <seanjc@google.com>
Cc:     yu.c.zhang@linux.intel.com
References: <20201106011637.14289-1-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c6e87502-6443-62f7-5df8-d7fcee0bca58@redhat.com>
Date:   Thu, 28 Jan 2021 18:57:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201106011637.14289-1-weijiang.yang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/20 02:16, Yang Weijiang wrote:
> Control-flow Enforcement Technology (CET) provides protection against
> Return/Jump-Oriented Programming (ROP/JOP) attack. There're two CET
> sub-features: Shadow Stack (SHSTK) and Indirect Branch Tracking (IBT).
> SHSTK is to prevent ROP programming and IBT is to prevent JOP programming.
> 
> Several parts in KVM have been updated to provide VM CET support, including:
> CPUID/XSAVES config, MSR pass-through, user space MSR access interface,
> vmentry/vmexit config, nested VM etc. These patches have dependency on CET
> kernel patches for xsaves support and CET definitions, e.g., MSR and related
> feature flags.
> 
> CET kernel patches are here:
> SHSTK: https://lkml.kernel.org/r/20201012153850.26996-1-yu-cheng.yu@intel.com/
> IBT: https://lkml.kernel.org/r/20201012154530.28382-1-yu-cheng.yu@intel.com/
> 
> CET QEMU patch:
> https://patchwork.ozlabs.org/project/qemu-devel/patch/20201013051935.6052-2-weijiang.yang@intel.com/
> KVM Unit test:
> https://patchwork.kernel.org/project/kvm/patch/20200506082110.25441-12-weijiang.yang@intel.com/
> 
> v14:
> - Sean refactored v13 patchset then came out v14-rc1, this version is
>    rebased on top of 5.10-rc1 and tested on TGL.
> - Fixed a few minor issues found during test, such as nested CET broken,
>    call-trace and guest reboot failure etc.
> - Original v14-rc1 is here: https://github.com/sean-jc/linux/tree/vmx/cet.
> 
> v13:
> - Added CET definitions as a separate patch to facilitate KVM test.
> - Disabled CET support in KVM if unrestricted_guest is turned off since
>    in this case CET related instructions/infrastructure cannot be emulated
>    well.
> 
> v12:
> - Fixed a few issues per Sean and Paolo's review feeback.
> - Refactored patches to make them properly arranged.
> - Removed unnecessary hard-coded CET states for host/guest.
> - Added compile-time assertions for vmcs_field_to_offset_table to detect
>    mismatch of the field type and field encoding number.
> - Added a custom MSR MSR_KVM_GUEST_SSP for guest active SSP save/restore.
> - Rebased patches to 5.7-rc3.
> 
> v11:
> - Fixed a guest vmentry failure issue when guest reboots.
> - Used vm_xxx_control_{set, clear}bit() to avoid side effect, it'll
>    clear cached data instead of pure VMCS field bits.
> - Added vcpu->arch.guest_supported_xss dedidated for guest runtime mask,
>    this avoids supported_xss overwritten issue caused by an old qemu.
> - Separated vmentry/vmexit state setting with CR0/CR4 dependency check
>    to make the patch more clear.
> - Added CET VMCS states in dump_vmcs() for debugging purpose.
> - Other refactor based on testing.
> - This patch serial is built on top of below branch and CET kernel patches
>    for seeking xsaves support.
> 
> v10:
> - Refactored code per Sean's review feedback.
> - Added CET support for nested VM.
> - Removed fix-patch for CPUID(0xd,N) enumeration as this part is done
>    by Paolo and Sean.
> - This new patchset is based on Paolo's queued cpu_caps branch.
> - Modified patch per XSAVES related change.
> - Consolidated KVM unit-test patch with KVM patches.
> 
> v9:
> - Refactored msr-check functions per Sean's feedback.
> - Fixed a few issues per Sean's suggestion.
> - Rebased patch to kernel-v5.4.
> - Moved CET CPUID feature bits and CR4.CET to last patch.
> 
> v8:
> - Addressed Jim and Sean's feedback on: 1) CPUID(0xD,i) enumeration. 2)
>    sanity check when configure guest CET. 3) function improvement.
> - Added more sanity check functions.
> - Set host vmexit default status so that guest won't leak CET status to
>    host when vmexit.
> - Added CR0.WP vs. CR4.CET mutual constrains.
> 
> v7:
> - Rebased patch to kernel v5.3
> - Sean suggested to change CPUID(0xd, n) enumeration code as alined with
>    existing one, and I think it's better to make the fix as an independent patch
>    since XSS MSR are being used widely on X86 platforms.
> - Check more host and guest status before configure guest CET
>    per Sean's feedback.
> - Add error-check before guest accesses CET MSRs per Sean's feedback.
> - Other minor fixes suggested by Sean.
> 
> v6:
> - Rebase patch to kernel v5.2.
> - Move CPUID(0xD, n>=1) helper to a seperate patch.
> - Merge xsave size fix with other patch.
> - Other minor fixes per community feedback.
> 
> v5:
> - Rebase patch to kernel v5.1.
> - Wrap CPUID(0xD, n>=1) code to a helper function.
> - Pass through MSR_IA32_PL1_SSP and MSR_IA32_PL2_SSP to Guest.
> - Add Co-developed-by expression in patch description.
> - Refine patch description.
> 
> v4:
> - Add Sean's patch for loading Guest fpu state before access XSAVES
>    managed CET MSRs.
> - Melt down CET bits setting into CPUID configuration patch.
> - Add VMX interface to query Host XSS.
> - Check Host and Guest XSS support bits before set Guest XSS.
> - Make Guest SHSTK and IBT feature enabling independent.
> - Do not report CET support to Guest when Host CET feature is Disabled.
> 
> v3:
> - Modified patches to make Guest CET independent to Host enabling.
> - Added patch 8 to add user space access for Guest CET MSR access.
> - Modified code comments and patch description to reflect changes.
> 
> v2:
> - Re-ordered patch sequence, combined one patch.
> - Added more description for CET related VMCS fields.
> - Added Host CET capability check while enabling Guest CET loading bit.
> - Added Host CET capability check while reporting Guest CPUID(EAX=7, EXC=0).
> - Modified code in reporting Guest CPUID(EAX=D,ECX>=1), make it clearer.
> - Added Host and Guest XSS mask check while setting bits for Guest XSS.
> 
> 
> Sean Christopherson (2):
>    KVM: x86: Report XSS as an MSR to be saved if there are supported features
>    KVM: x86: Load guest fpu state when accessing MSRs managed by XSAVES
> 
> Yang Weijiang (11):
>    KVM: x86: Refresh CPUID on writes to MSR_IA32_XSS
>    KVM: x86: Add #CP support in guest exception dispatch
>    KVM: VMX: Introduce CET VMCS fields and flags
>    KVM: x86: Add fault checks for CR4.CET
>    KVM: VMX: Emulate reads and writes to CET MSRs
>    KVM: VMX: Add a synthetic MSR to allow userspace VMM to access GUEST_SSP
>    KVM: x86: Report CET MSRs as to-be-saved if CET is supported
>    KVM: x86: Enable CET virtualization for VMX and advertise CET to userspace
>    KVM: VMX: Pass through CET MSRs to the guest when supported
>    KVM: nVMX: Add helper to check the vmcs01 MSR bitmap for MSR pass-through
>    KVM: nVMX: Enable CET support for nested VMX
> 
>   arch/x86/include/asm/kvm_host.h      |   4 +-
>   arch/x86/include/asm/vmx.h           |   8 ++
>   arch/x86/include/uapi/asm/kvm.h      |   1 +
>   arch/x86/include/uapi/asm/kvm_para.h |   1 +
>   arch/x86/kvm/cpuid.c                 |  26 +++-
>   arch/x86/kvm/vmx/capabilities.h      |   5 +
>   arch/x86/kvm/vmx/nested.c            |  57 ++++++--
>   arch/x86/kvm/vmx/vmcs12.c            |   6 +
>   arch/x86/kvm/vmx/vmcs12.h            |  14 +-
>   arch/x86/kvm/vmx/vmx.c               | 207 ++++++++++++++++++++++++++-
>   arch/x86/kvm/x86.c                   |  56 +++++++-
>   arch/x86/kvm/x86.h                   |  10 +-
>   12 files changed, 370 insertions(+), 25 deletions(-)
> 

I reviewed the patch and it is mostly okay.  However, if I understand it 
correctly, it will not do anything until host support materializes, 
because otherwise XSS will be 0.

If this is the case, I plan to apply locally v15 and hold on it until 
the host code is committed.

Paolo

