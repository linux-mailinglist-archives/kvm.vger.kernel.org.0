Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18ED354432
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 18:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242019AbhDEQEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 12:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241868AbhDEQEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:07 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2F2C061756
        for <kvm@vger.kernel.org>; Mon,  5 Apr 2021 09:04:01 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso6077278pjb.3
        for <kvm@vger.kernel.org>; Mon, 05 Apr 2021 09:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zqoI+8LoWlE2zRvoOSwXuX0cF5o+iIT9RI18zTMvQ6k=;
        b=OV+qveMnL97IUGuHnAB07n6efv4noSQJ3bnAPfXzITx88F6FTH8xRz+cssWd/Hy1AQ
         Y6i9yZxx9zH9EhRO6FKFmu/BXMszaFcg0CuwqR9Kaw1jhxPYwaO5w6/QV0l8Cfuzt65J
         J9LU5XSIJVRklLIbXvza+qd8KPHQskBz7EopytLZU1zRyymtlJ61tqNneZ35vKYKRFYW
         avR/Ls29VsPNB6m2Fr6LptfTcbzP/npDOPXw77yf+1pMEQEfnrY4domMOi+jdVOmxL6l
         HL66XpBSXULIM+rd8aKpHdkoPZJ4ekUnYehQO5g6CykX5xzRCcJl6m/RFU2l8AXMCrRo
         Ox+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=zqoI+8LoWlE2zRvoOSwXuX0cF5o+iIT9RI18zTMvQ6k=;
        b=nGTCqhcf6bPacwojV91+FBpxoZqQ0qI8Bd3HafQZmsnm2yBjF4EiIFFyurUcqFS4ls
         cDJNoEAly3LkVP0aUhU/Pvrp0fOC+Gp1iWsEgZS/T9w0OzsxU2KSjJAOUjARmdc+8I+n
         BBQwtzmDccP+HP9SaVSVLgevRbX2VR/wrcSwLopd22yVhHZono18u3ORzTPfN6kFppqk
         QGfHxkMAP82YQtiLj7Sv13I8YrPlxAmfWn/av1Mb4IW7uzu3A25Pe5+Us7g4gdocF2wH
         HUOC5wIs+3ojQI4tZGKIL6uxW9LrlALF+IAVqbrOa0yykir8E2QOpBid+EWpx3SK7Vv1
         l9tQ==
X-Gm-Message-State: AOAM533FZZMYsggYrY+Kqsb7I0MOICsCH2J8Khuk647ZerAkLfjMtStf
        VMZGFxR4InF90tLzZaU7lOhSVg==
X-Google-Smtp-Source: ABdhPJyGH/yBMXo/ia/KsmYuVRjMMN/VRcpoxokkjlf9hUUIAsPMs9k4WoE2/VAkYIpHS1v7nvxVuA==
X-Received: by 2002:a17:90a:f40c:: with SMTP id ch12mr27310374pjb.176.1617638640928;
        Mon, 05 Apr 2021 09:04:00 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id v123sm15857662pfb.80.2021.04.05.09.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 09:04:00 -0700 (PDT)
Date:   Mon, 5 Apr 2021 16:03:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chang.seok.bae@intel.com,
        kvm@vger.kernel.org, robert.hu@intel.com
Subject: Re: [RFC PATCH 00/12] KVM: Support Intel KeyLocker
Message-ID: <YGs07I/mKhDy3pxD@google.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021, Robert Hoo wrote:
> IWKey, is the core of this framework. It is loaded into CPU by LOADIWKEY
> instruction, then inaccessible from (CPU) outside anymore.

Unless the VMM intercepts and saves the key in normal memory, which is what this
series proposes to do.  That needs to be called out very, very clearly.

> LOADIWKEY is the
> only Key Locker instruction that will cause VM-exit (if we set so in VM
> Execution Control). When load IWKey into CPU, we can ask CPU further
> randomize it, if HW supports this.
> The IWKey can also be distributed among CPUs, rather than LOADIWKEY on each
> CPU, by: first backup IWKey to platform specific storage, then copy it on
> target CPU. The backup process is triggered by writing to MSR
> IA32_COPY_LOCAL_TO_PLATFORM. The restore process is triggered by writing to
> MSR IA32_COPY_PLATFORM_LOCAL.
>  
> Virtualization Design
> Key Locker Spec [2] indicates virtualization limitations by current HW
> implementation.
> 1) IWKey cannot be read from CPU after it's loaded (this is the nature of
> this feature) and only 1 copy of IWKey inside 1 CPU.
> 2) Initial implementations may take a significant amount of time to perform
> a copy of IWKeyBackup to IWKey (via a write to MSR
> IA32_COPY_PLATFORM_LOCAL) so it may cause a significant performance impact
> to reload IWKey after each VM exit.
>  
> Due to above reasons, virtualization design makes below decisions
> 1) don't expose HW randomize IWKey capability (CPUID.0x19.ECX[1]) to guest. 
>    As such, guest IWKey cannot be preserved by VMM across VM-{Exit, Entry}.
>    (VMM cannot know what exact IWKey were set by CPU)
> 2) guests and host can only use Key Locker feature exclusively. [4] 
> 
> The virtualization implementation is generally straight forward
> 1) On VM-Exit of guest 'LOADIWKEY', VMM stores the IWKey in vCPU scope
>         area (kvm_vcpu_arch)
> 2) Right before VM-Entry, VMM load that vCPU's IWKey in to pCPU, by
> LOADIWKEY instruction.
> 3) On guest backup local to platform operation, VMM traps the write
>    to MSR, and simulate the IWKey store process by store it in a KVM
>    scope area (kvm_arch), mark the success status in the shadow
>    msr_ia32_iwkey_backup_status and msr_ia32_copy_status.
> 4) On guest copy from platform to local operation, VMM traps the write
>    to MSR and simulate the process by load kvm_arch.iwkey_backup to
>    vCPU.iwkey; and simulate the success status in the
>    shadow msr_ia32_copy_status.
> 5) Guest read the 2 status MSRs will also be trapped and return the shadow
>    value.
> 6) Other Key Locker instructions can run without VM-Exit in non-root mode.
> 
> At the end, we don't suggest this feature to be migratable, as if so, IWKey
> would have to be exposed to user space, which would weaken this feature's

/s/weaken/further weaken.  Saving the key in host kernel memory already subverts
IWKey to some extent.

Is there a concrete use case for virtualizing IWKey?  The caveats that come with
it quite nasty, e.g. reduced security (relative to native IWKey), not migratable,
increased vCPU switching latency, etc...

> security significance.
