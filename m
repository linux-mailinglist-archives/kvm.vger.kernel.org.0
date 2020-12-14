Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158482D9EAF
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440260AbgLNSPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:15:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51671 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439948AbgLNSPF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 13:15:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607969615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AwwzZdDyF1r6qcS1a83NpXAsbn9SW/LPeb1RFJju/b4=;
        b=ORK/hdJv2KLSE7P0fTClKEl14It18qK3jwu3CpI6x59RZ0qAc3zm6brJ8u3YScTHoYb7F3
        6cV0UgjAFTJhli6uaOSjzyfByUwzSXMde6MNOZzvQEfjDeEC418erR1o/k4PB7uH4vNauU
        8t5KaEdUWuGC/GmxndB7uhEWK7TdEkQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-8gfcU3uqMO2oljTryUybXw-1; Mon, 14 Dec 2020 13:13:24 -0500
X-MC-Unique: 8gfcU3uqMO2oljTryUybXw-1
Received: by mail-wm1-f72.google.com with SMTP id k67so3247265wmk.5
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:13:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AwwzZdDyF1r6qcS1a83NpXAsbn9SW/LPeb1RFJju/b4=;
        b=l5dEkRoTMSvPD7JZPsbeXdIpzuvr3w0/syT+oPZZGyhVmc3EkKySA0eS4X2w0Apo5K
         Sdvel+DYpinQvCICiTXdKTbNRgWmShQ+1AP/TMrw8ukfbFbfuD1y+Vw9PHRQGTp9nTSo
         oteWiBDP/LP8L98RgoU0pfBBG1uZDYTppYVGajcmEoKz1I7/TuyMp1cY1CYUCR2RF5P+
         wrOCWj6EA02XCg3UmiIIjIoMITyRKNNOjr5btsaEpLWvJj3r8EQXPHAHykbcfW00GsiG
         +U82tp5XcIZcnfutDJe3qrtbcn3V1U//Pe9Bvfjnbk212cYfv5Uo31OU4kELg+DvTcUr
         XL1A==
X-Gm-Message-State: AOAM530+9X5K3HM7o+oFsvee/UHOqp2gdM19Kw+kh5XSW7t+VFtHm1QQ
        Ugu/oTX3BkrOfLCZRl1QDe2YuWU2a0mQbG7JQxxrIewKxYnBwQ/DZT/g77mUydqjjlMcTVDKTG6
        JhekeG22nwvTC
X-Received: by 2002:a1c:6008:: with SMTP id u8mr28240645wmb.173.1607969603263;
        Mon, 14 Dec 2020 10:13:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyuUM/UOHcT7yv0tgDWk8gjs5bzu4UDZt8mSBTZrr1Gppa0JPSQqRDV8wZEKahD+QUrFaqO9g==
X-Received: by 2002:a1c:6008:: with SMTP id u8mr28240616wmb.173.1607969602964;
        Mon, 14 Dec 2020 10:13:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j59sm4170676wrj.13.2020.12.14.10.13.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 10:13:22 -0800 (PST)
Subject: Re: [PATCH v5 00/34] SEV-ES hypervisor support
To:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e348086e-1ca1-9020-7c0f-421768a96944@redhat.com>
Date:   Mon, 14 Dec 2020 19:13:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/20 18:09, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> This patch series provides support for running SEV-ES guests under KVM.
> 
> Secure Encrypted Virtualization - Encrypted State (SEV-ES) expands on the
> SEV support to protect the guest register state from the hypervisor. See
> "AMD64 Architecture Programmer's Manual Volume 2: System Programming",
> section "15.35 Encrypted State (SEV-ES)" [1].
> 
> In order to allow a hypervisor to perform functions on behalf of a guest,
> there is architectural support for notifying a guest's operating system
> when certain types of VMEXITs are about to occur. This allows the guest to
> selectively share information with the hypervisor to satisfy the requested
> function. The notification is performed using a new exception, the VMM
> Communication exception (#VC). The information is shared through the
> Guest-Hypervisor Communication Block (GHCB) using the VMGEXIT instruction.
> The GHCB format and the protocol for using it is documented in "SEV-ES
> Guest-Hypervisor Communication Block Standardization" [2].
> 
> Under SEV-ES, a vCPU save area (VMSA) must be encrypted. SVM is updated to
> build the initial VMSA and then encrypt it before running the guest. Once
> encrypted, it must not be modified by the hypervisor. Modification of the
> VMSA will result in the VMRUN instruction failing with a SHUTDOWN exit
> code. KVM must support the VMGEXIT exit code in order to perform the
> necessary functions required of the guest. The GHCB is used to exchange
> the information needed by both the hypervisor and the guest.
> 
> Register data from the GHCB is copied into the KVM register variables and
> accessed as usual during handling of the exit. Upon return to the guest,
> updated registers are copied back to the GHCB for the guest to act upon.
> 
> There are changes to some of the intercepts that are needed under SEV-ES.
> For example, CR0 writes cannot be intercepted, so the code needs to ensure
> that the intercept is not enabled during execution or that the hypervisor
> does not try to read the register as part of exit processing. Another
> example is shutdown processing, where the vCPU cannot be directly reset.
> 
> Support is added to handle VMGEXIT events and implement the GHCB protocol.
> This includes supporting standard exit events, like a CPUID instruction
> intercept, to new support, for things like AP processor booting. Much of
> the existing SVM intercept support can be re-used by setting the exit
> code information from the VMGEXIT and calling the appropriate intercept
> handlers.
> 
> Finally, to launch and run an SEV-ES guest requires changes to the vCPU
> initialization, loading and execution.
> 
> [1] https://www.amd.com/system/files/TechDocs/24593.pdf
> [2] https://developer.amd.com/wp-content/resources/56421.pdf
> 
> ---
> 
> These patches are based on the KVM queue branch:
> https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> 
> dc924b062488 ("KVM: SVM: check CR4 changes against vcpu->arch")
> 
> A version of the tree can also be found at:
> https://github.com/AMDESE/linux/tree/sev-es-v5
>   This tree has one addition patch that is not yet part of the queue
>   tree that is required to run any SEV guest:
>   [PATCH] KVM: x86: adjust SEV for commit 7e8e6eed75e
>   https://lore.kernel.org/kvm/20201130143959.3636394-1-pbonzini@redhat.com/
> 
> Changes from v4:
> - Updated the tracking support for CR0/CR4
> 
> Changes from v3:
> - Some krobot fixes.
> - Some checkpatch cleanups.
> 
> Changes from v2:
> - Update the freeing of the VMSA page to account for the encrypted memory
>    cache coherency feature as well as the VM page flush feature.
> - Update the GHCB dump function with a bit more detail.
> - Don't check for RAX being present as part of a string IO operation.
> - Include RSI when syncing from GHCB to support KVM hypercall arguments.
> - Add GHCB usage field validation check.
> 
> Changes from v1:
> - Removed the VMSA indirection support:
>    - On LAUNCH_UPDATE_VMSA, sync traditional VMSA over to the new SEV-ES
>      VMSA area to be encrypted.
>    - On VMGEXIT VMEXIT, directly copy valid registers into vCPU arch
>      register array from GHCB. On VMRUN (following a VMGEXIT), directly
>      copy dirty vCPU arch registers to GHCB.
>    - Removed reg_read_override()/reg_write_override() KVM ops.
> - Added VMGEXIT exit-reason validation.
> - Changed kvm_vcpu_arch variable vmsa_encrypted to guest_state_protected
> - Updated the tracking support for EFER/CR0/CR4/CR8 to minimize changes
>    to the x86.c code
> - Updated __set_sregs to not set any register values (previously supported
>    setting the tracked values of EFER/CR0/CR4/CR8)
> - Added support for reporting SMM capability at the VM-level. This allows
>    an SEV-ES guest to indicate SMM is not supported
> - Updated FPU support to check for a guest FPU save area before using it.
>    Updated SVM to free guest FPU for an SEV-ES guest during KVM create_vcpu
>    op.
> - Removed changes to the kvm_skip_emulated_instruction()
> - Added VMSA validity checks before invoking LAUNCH_UPDATE_VMSA
> - Minor code restructuring in areas for better readability
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Brijesh Singh <brijesh.singh@amd.com>

I'm queuing everything except patch 27, there's time to include it later 
in 5.11.

Regarding MSRs, take a look at the series I'm sending shortly (or 
perhaps in a couple hours).  For now I'll keep it in kvm/queue, but the 
plan is to get acks quickly and/or just include it in 5.11.  Please try 
the kvm/queue branch to see if I screwed up anything.

Paolo

