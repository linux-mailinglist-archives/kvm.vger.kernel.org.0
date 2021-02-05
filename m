Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9B23109C3
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 12:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhBELDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 06:03:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24105 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231913AbhBELBT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 06:01:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612522788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FWEbYiIl2mPic9AVqqzSqXwMZeGmN0DaILU6NQPe7NM=;
        b=IUZt2n4nUmaObBhuJVMcAkzelanPi7c8ZJ9kHr+A/5Iqhb525Zs2+SwFJynWgbOA7MHSUu
        2gla/pLoIQhkONBLW4SEAMKC06OlLlwJss5tqAKqcOOoiGxbp9Hgy6vTzpSlDUWu9zMx2e
        7IXssRsu39yWEOsHv5y2V794c3F6SV4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-EkC8ewh_MXWc5qE6x75D6g-1; Fri, 05 Feb 2021 05:59:45 -0500
X-MC-Unique: EkC8ewh_MXWc5qE6x75D6g-1
Received: by mail-ed1-f71.google.com with SMTP id i4so6827486edt.11
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 02:59:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FWEbYiIl2mPic9AVqqzSqXwMZeGmN0DaILU6NQPe7NM=;
        b=bbY/q5Ane9W+xnsudRB8vAPnlV/Ip8P0V4Osm3fs0/UpZUGt5txZCEPYQwixTJ/3yW
         2TYoNtVqMB5WdGaWqM860E9Ale1K0RXUgIi+x92bWawZj6kGZDOfU86omPFtADgWkH6G
         d651yx5vrZAoAk5s1Cfm2UuMuGHXJmlevM8fro19YgciDQ8LM2VXzhLxPRJR0a0VjAUQ
         jTUNArtxpOv6GwrdSJelSC7ZyzI2mHMUa/zj+TjLWo1vpEnkejX9y4tQCakTV70Ce7fZ
         Ikb91a3C8aekI1zdlbT55pIaiZAjbCLOWfVEJ5j0LelkIktFyNfZpUoIehGmW4sW33RC
         F19g==
X-Gm-Message-State: AOAM532qKFgcLrzHiHAWL63a9/F7fadMQLy9TLje/02jui5uafFdt885
        YIa9C7qci0luSDRgk6zd0G/z4AUGwWexcpViPHoFaMUKsasOSpVKs2FiSHMdKPMwpLIedzLkxpc
        rJcmREB3R4cZF
X-Received: by 2002:a17:906:cf89:: with SMTP id um9mr3529388ejb.189.1612522784266;
        Fri, 05 Feb 2021 02:59:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyicYZ7U5+td54yQvw/EmYQEep7zZoL7Z/iHsgVsTvXCI+OmMZnm8j+EI9h1mLD7ZwFN6rfqQ==
X-Received: by 2002:a17:906:cf89:: with SMTP id um9mr3529357ejb.189.1612522784023;
        Fri, 05 Feb 2021 02:59:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r9sm3707707eju.74.2021.02.05.02.59.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 02:59:42 -0800 (PST)
Subject: Re: [PATCH v6 0/6] Qemu SEV-ES guest support
To:     Tom Lendacky <thomas.lendacky@amd.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9cfe8d87-c440-6ce8-7b1c-beb46e17c173@redhat.com>
Date:   Fri, 5 Feb 2021 11:59:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <cover.1611682609.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/01/21 18:36, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> This patch series provides support for launching an SEV-ES guest.
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
> The main areas of the Qemu code that are updated to support SEV-ES are
> around the SEV guest launch process and AP booting in order to support
> booting multiple vCPUs.
> 
> There are no new command line switches required. Instead, the desire for
> SEV-ES is presented using the SEV policy object. Bit 2 of the SEV policy
> object indicates that SEV-ES is required.
> 
> The SEV launch process is updated in two ways. The first is that a the
> KVM_SEV_ES_INIT ioctl is used to initialize the guest instead of the
> standard KVM_SEV_INIT ioctl. The second is that before the SEV launch
> measurement is calculated, the LAUNCH_UPDATE_VMSA SEV API is invoked for
> each vCPU that Qemu has created. Once the LAUNCH_UPDATE_VMSA API has been
> invoked, no direct changes to the guest register state can be made.
> 
> AP booting poses some interesting challenges. The INIT-SIPI-SIPI sequence
> is typically used to boot the APs. However, the hypervisor is not allowed
> to update the guest registers. For the APs, the reset vector must be known
> in advance. An OVMF method to provide a known reset vector address exists
> by providing an SEV information block, identified by UUID, near the end of
> the firmware [3]. OVMF will program the jump to the actual reset vector in
> this area of memory. Since the memory location is known in advance, an AP
> can be created with the known reset vector address as its starting CS:IP.
> The GHCB document [2] talks about how SMP booting under SEV-ES is
> performed. SEV-ES also requires the use of the in-kernel irqchip support
> in order to minimize the changes required to Qemu to support AP booting.
> 
> [1] https://www.amd.com/system/files/TechDocs/24593.pdf
> [2] https://developer.amd.com/wp-content/resources/56421.pdf
> [3] 30937f2f98c4 ("OvmfPkg: Use the SEV-ES work area for the SEV-ES AP reset vector")
>      https://github.com/tianocore/edk2/commit/30937f2f98c42496f2f143fe8374ae7f7e684847
> 
> Cc: Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>
> Cc: Aurelien Jarno <aurelien@aurel32.net>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> 
> ---
> 
> These patches are based on commit:
> 9cd69f1a27 ("Merge remote-tracking branch 'remotes/stefanberger/tags/pull-tpm-2021-01-25-1' into staging")
> 
> Additionally, these patches pre-req the following patch series that has
> not yet been accepted into the Qemu tree:
> 
> [PATCH v2 0/2] sev: enable secret injection to a self described area in OVMF
>    https://lore.kernel.org/qemu-devel/20201214154429.11023-1-jejb@linux.ibm.com/
> 
> A version of the tree can be found at:
> https://github.com/AMDESE/qemu/tree/sev-es-v14
> 
> Changes since v5:
> - Rework the reset prevention patch to not issue the error message if the
>    --no-reboot option has been specified for SEV-ES guests.
> 
> Changes since v4:
> - Add support for an updated Firmware GUID table implementation, that
>    is now present in OVMF SEV-ES firmware, when searching for the reset
>    vector information. The code will check for the new implementation
>    first, followed by the original implementation to maintain backward
>    compatibility.
> 
> Changes since v3:
> - Use the QemuUUID structure for GUID definitions
> - Use SEV-ES policy bit definition from target/i386/sev_i386.h
> - Update SMM support to a per-VM check in order to check SMM capability
>    at the VM level since SEV-ES guests don't currently support SMM
> - Make the CPU resettable check an arch-specific check
> 
> Changes since v2:
> - Add in-kernel irqchip requirement for SEV-ES guests
> 
> Changes since v1:
> - Fixed checkpatch.pl errors/warnings
> 
> Tom Lendacky (6):
>    sev/i386: Add initial support for SEV-ES
>    sev/i386: Require in-kernel irqchip support for SEV-ES guests
>    sev/i386: Allow AP booting under SEV-ES
>    sev/i386: Don't allow a system reset under an SEV-ES guest
>    kvm/i386: Use a per-VM check for SMM capability
>    sev/i386: Enable an SEV-ES guest based on SEV policy
> 
>   accel/kvm/kvm-all.c       |  69 +++++++++++++++++++++
>   accel/stubs/kvm-stub.c    |   5 ++
>   hw/i386/pc_sysfw.c        |  10 ++-
>   include/sysemu/cpus.h     |   2 +
>   include/sysemu/hw_accel.h |   5 ++
>   include/sysemu/kvm.h      |  26 ++++++++
>   include/sysemu/sev.h      |   3 +
>   softmmu/cpus.c            |   5 ++
>   softmmu/runstate.c        |   3 +
>   target/arm/kvm.c          |   5 ++
>   target/i386/cpu.c         |   1 +
>   target/i386/kvm/kvm.c     |  10 ++-
>   target/i386/sev-stub.c    |   6 ++
>   target/i386/sev.c         | 124 +++++++++++++++++++++++++++++++++++++-
>   target/i386/sev_i386.h    |   1 +
>   target/mips/kvm.c         |   5 ++
>   target/ppc/kvm.c          |   5 ++
>   target/s390x/kvm.c        |   5 ++
>   18 files changed, 286 insertions(+), 4 deletions(-)
> 

Queued, thanks.

Paolo

