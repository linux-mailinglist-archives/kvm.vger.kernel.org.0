Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E383043B9
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 17:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404934AbhAZQXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 11:23:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21308 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404510AbhAZQXR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 11:23:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611678110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sjkEg/wo/oYcd5wME62mrexAYIXyreMX6wM/DmqObFE=;
        b=Mr6PXif1jz4GTnntnZMrBtXAf1Xx/caGTUBNtIjMAdt6Up9ZnbTZH5x6HyTUjf2Ou1Zjj3
        89TKvU+wHieQtzhcFoqB60UP6RgdUxFDXsSSktbR4pQMUxJvFJzGKv3yMUmHt1gUvJkYY2
        GtQjPSfXPokEY94pEQqUA3qenSaF83s=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-ZXUbGvROMF2hQWxpEKZE-A-1; Tue, 26 Jan 2021 11:21:39 -0500
X-MC-Unique: ZXUbGvROMF2hQWxpEKZE-A-1
Received: by mail-ej1-f70.google.com with SMTP id p1so5130851ejo.4
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 08:21:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sjkEg/wo/oYcd5wME62mrexAYIXyreMX6wM/DmqObFE=;
        b=uFBuRGTbQ9lWXxKfaJXThhSgmBUemuzWATdSaeBwOe6Rc5cC0Lyr1qI8qtVldUKcfS
         Sm13zsn2Tl8nqq/aeCITnk/1fftpLns61m9PnCu5LGBRJrGFXXik2HdnYZOaMQVsFQiB
         2fzADvZ2SYpsarXSrhNgahvtOcKkTyoNIw5hRAKms3IxuaOSLiiGICq53BFfS51hd8+M
         vlp7MTofRnfy2qTfMSRdMrNW/djX8LVz0Jf1Wx7Aai9KzdsbmN3jCXhJtkPyt7KiPHV8
         b2HO+cH6XqFO/zUC+Ncv5H90pDYNJpqJBt2POStEEo9kdj5tfOZt0uAQDH32Dp7rdH05
         x+0A==
X-Gm-Message-State: AOAM533W4Dv5u88hKBd2HMix/DiY4WwUbSP1Sphu1ee6J4D3gyjVCgur
        4cCBHgI/2Z0KwbZ3MlGpbCYR954tNe4U7RzmquNlKu7OxL1wFdOSFHa6C3+Vq04arHoxV8ytV2X
        GB6+jn4Z5LHlw
X-Received: by 2002:a05:6402:b68:: with SMTP id cb8mr5148578edb.346.1611678097913;
        Tue, 26 Jan 2021 08:21:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyPyeaEvKovTY03nnv+TdQ6ynwZAjjJXWuwEFaRjVfzMwLlbQbps08spgaC8lGxM51D4Puh1Q==
X-Received: by 2002:a05:6402:b68:: with SMTP id cb8mr5148562edb.346.1611678097754;
        Tue, 26 Jan 2021 08:21:37 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r26sm13411455edc.95.2021.01.26.08.21.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 08:21:36 -0800 (PST)
Subject: Re: [PATCH v4 0/6] Qemu SEV-ES guest support
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
        "Michael S. Tsirkin" <mst@redhat.com>
References: <cover.1601060620.git.thomas.lendacky@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <30164d98-3d8c-64bf-500b-f98a7f12d3c3@redhat.com>
Date:   Tue, 26 Jan 2021 17:21:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <cover.1601060620.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 21:03, Tom Lendacky wrote:
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
> ---
> 
> These patches are based on commit:
> d0ed6a69d3 ("Update version for v5.1.0 release")
> 
> (I tried basing on the latest Qemu commit, but I was having build issues
> that level)
> 
> A version of the tree can be found at:
> https://github.com/AMDESE/qemu/tree/sev-es-v12
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
>   accel/kvm/kvm-all.c       |  69 ++++++++++++++++++++++++
>   accel/stubs/kvm-stub.c    |   5 ++
>   hw/i386/pc_sysfw.c        |  10 +++-
>   include/sysemu/cpus.h     |   2 +
>   include/sysemu/hw_accel.h |   5 ++
>   include/sysemu/kvm.h      |  26 +++++++++
>   include/sysemu/sev.h      |   3 ++
>   softmmu/cpus.c            |   5 ++
>   softmmu/vl.c              |   5 +-
>   target/arm/kvm.c          |   5 ++
>   target/i386/cpu.c         |   1 +
>   target/i386/kvm.c         |  10 +++-
>   target/i386/sev-stub.c    |   5 ++
>   target/i386/sev.c         | 109 +++++++++++++++++++++++++++++++++++++-
>   target/i386/sev_i386.h    |   1 +
>   target/mips/kvm.c         |   5 ++
>   target/ppc/kvm.c          |   5 ++
>   target/s390x/kvm.c        |   5 ++
>   18 files changed, 271 insertions(+), 5 deletions(-)
> 

Looks good!  Please fix the nit in patch 4 and rebase, I'll then apply it.

Thanks,

Paolo

