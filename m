Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E39248A1AC
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 22:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343724AbiAJVSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 16:18:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240441AbiAJVSY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 16:18:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641849504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J7MFVrWactFRO7z0/cZSEHpYBpO1gPnzHzw94L6Uy2o=;
        b=ZGhQo9T1q4wvK/Yb/NcKpF5KBWkU5nWGtTCV6PDHvmnQiB7zVOBO3jIgZOADsak2Lev8Os
        BBmp46rs9EMSIzb61X3idoIb2BO0TEDVk9ZeD9FCyNPoRnmBokP7bZKH1KfsW4iD5tXEST
        VbHltvmn3V8VRZzBRs+05s0GtXprcd4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-ivBflAN2MX-s3OS3ggEzqQ-1; Mon, 10 Jan 2022 16:18:22 -0500
X-MC-Unique: ivBflAN2MX-s3OS3ggEzqQ-1
Received: by mail-wm1-f69.google.com with SMTP id c5-20020a1c3505000000b00345c92c27c6so223778wma.2
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 13:18:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J7MFVrWactFRO7z0/cZSEHpYBpO1gPnzHzw94L6Uy2o=;
        b=vZg6xgxO23bmWoyN5OWPnIXzN2hWX20qEwQbXdws2pqs/LPPWpfAzT2RzW4q0cq4f3
         WfI4Czx3Y9JbMLbnsJyDk2F4Aa/Tfnriu3410IpmnLclvk2hO+Kz4XifAuCCPfUzbzqC
         tROUJYB4SPA3NITU2hzCigZ6e0CsjeGJnCMF4G4Jmoj3fEP1zDfr9uQm0i1E1nrw6gEY
         o8x6jHL3fzo3ZcubEUy5aWn+A6XchVetb9abONCxY6EvFLlVyilIBVhjBxE8u8k+7jSO
         /ZE9P7TDKVq09vSLMRwAbY05U9BXqmZOfZcpq2moICIiSLCsQdkl7vfxMphIU6eihwuY
         WqRA==
X-Gm-Message-State: AOAM533+/RgRCiD10d1kW/+8nOzG3xD+vLt4m0IVhP58iTJLaNYb0+Bq
        vIu6lJhSGO0uqvZfwj2cQlP/2uc2TaF5oB8tnEqyWlnbXNjTKBarZsN1MGGDi6R1+541TyCTlvP
        YHONHx8neScpT
X-Received: by 2002:a7b:c317:: with SMTP id k23mr1142917wmj.20.1641849501735;
        Mon, 10 Jan 2022 13:18:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx4+5EBjQikMR8M8iojk8l1dbfm807K8FOeByHDC7B5RVRGcumm5hzWJ1VCl1kaJhrRPxTf+g==
X-Received: by 2002:a7b:c317:: with SMTP id k23mr1142908wmj.20.1641849501546;
        Mon, 10 Jan 2022 13:18:21 -0800 (PST)
Received: from redhat.com ([2.55.19.241])
        by smtp.gmail.com with ESMTPSA id g84sm12999wme.7.2022.01.10.13.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 13:18:21 -0800 (PST)
Date:   Mon, 10 Jan 2022 16:18:17 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Kechen Lu <kechenl@nvidia.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        wanpengli@tencent.com, vkuznets@redhat.com, somduttar@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] KVM: x86: add per-vCPU exits disable
 capability
Message-ID: <20220110161344-mutt-send-email-mst@kernel.org>
References: <20211221090449.15337-1-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221090449.15337-1-kechenl@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 21, 2021 at 01:04:46AM -0800, Kechen Lu wrote:
> Summary
> ===========
> Introduce support of vCPU-scoped ioctl with KVM_CAP_X86_DISABLE_EXITS
> cap for disabling exits to enable finer-grained VM exits disabling
> on per vCPU scales instead of whole guest. This patch series enabled
> the vCPU-scoped exits control on HLT VM-exits.
> 
> Motivation
> ============
> In use cases like Windows guest running heavy CPU-bound
> workloads, disabling HLT VM-exits could mitigate host sched ctx switch
> overhead. Simply HLT disabling on all vCPUs could bring
> performance benefits, but if no pCPUs reserved for host threads, could
> happened to the forced preemption as host does not know the time to do
> the schedule for other host threads want to run. With this patch, we
> could only disable part of vCPUs HLT exits for one guest, this still
> keeps performance benefits, and also shows resiliency to host stressing
> workload running at the same time.
> 
> Performance and Testing
> =========================
> In the host stressing workload experiment with Windows guest heavy
> CPU-bound workloads, it shows good resiliency and having the ~3%
> performance improvement. E.g. Passmark running in a Windows guest
> with this patch disabling HLT exits on only half of vCPUs still
> showing 2.4% higher main score v/s baseline.
> 
> Tested everything on AMD machines.
> 
> 
> v1->v2 (Sean Christopherson) :
> - Add explicit restriction for VM-scoped exits disabling to be called
>   before vCPUs creation (patch 1)
> - Use vCPU ioctl instead of 64bit vCPU bitmask (patch 3), and make exits
>   disable flags check purely for vCPU instead of VM (patch 2)

This is still quite blunt and assumes a ton of configuration on the host
exactly matching the workload within guest. Which seems a waste since
guests actually have the smarts to know what's happening within them.

If you are going to allow guest to halt a vCPU, how about
working on exposing mwait to guest cleanly instead?
The idea is to expose this in ACPI - linux guests
ignore ACPI and go by CPUID but windows guests follow
ACPI. Linux can be patched ;)

What we would have is a mirror of host ACPI states,
such that lower states invoke HLT and exit, higher
power states invoke mwait and wait within guest.

The nice thing with this approach is that it's already supported
by the host kernel, so it's just a question of coding up ACPI.



> 
> Best Regards,
> Kechen
> 
> Kechen Lu (3):
>   KVM: x86: only allow exits disable before vCPUs created
>   KVM: x86: move ()_in_guest checking to vCPU scope
>   KVM: x86: add vCPU ioctl for HLT exits disable capability
> 
>  Documentation/virt/kvm/api.rst     |  4 +++-
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  7 +++++++
>  arch/x86/kvm/cpuid.c               |  2 +-
>  arch/x86/kvm/lapic.c               |  2 +-
>  arch/x86/kvm/svm/svm.c             | 20 +++++++++++++++-----
>  arch/x86/kvm/vmx/vmx.c             | 26 ++++++++++++++++++--------
>  arch/x86/kvm/x86.c                 | 24 +++++++++++++++++++++++-
>  arch/x86/kvm/x86.h                 | 16 ++++++++--------
>  9 files changed, 77 insertions(+), 25 deletions(-)
> 
> -- 
> 2.30.2

