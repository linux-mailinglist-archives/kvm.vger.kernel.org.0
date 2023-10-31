Return-Path: <kvm+bounces-203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 032117DCEEB
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 15:21:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3161C281187
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 14:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 060A61DFC2;
	Tue, 31 Oct 2023 14:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S1mYexjh"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780BC13FE1
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 14:21:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4506EED
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698762087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tEGwtLaTyDLUbYAbJd8Pcxwvb/gHACp97/7gVsbA1Xc=;
	b=S1mYexjh7FAp25UHj7rKBwNOetcZfkzXyxJvtkMVH6I9t0k6/AxVLWLGaSCX3+C5L4olRZ
	qTIK7Q0Ii07CTKtk5lPMC/i8yakp0P+Xl3y+IlVGR+THUrZYp39mfGdmhbvoE1C8oQDOZE
	v2Kv/t7R4fB7QbXJTixqmwmyXlIzlKQ=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-VXX6irVQPueChhptrVkwcw-1; Tue, 31 Oct 2023 10:21:25 -0400
X-MC-Unique: VXX6irVQPueChhptrVkwcw-1
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-457bc85ac53so1847899137.3
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:21:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698762085; x=1699366885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tEGwtLaTyDLUbYAbJd8Pcxwvb/gHACp97/7gVsbA1Xc=;
        b=aDYS/pfbYIqRY7wo1Z+1olavJo09g88EKuy8TmoqKOT6J+VzJrHlZKBxdk6jEvxhzb
         zj4TcjTEJrOp7WGa22xnWiNyU0KZtqVzEe83B0TinTUUC2gMw2MrCi8RutYoje+UTJ02
         x5Nrsz/umdx4Oj0cjB8B3sJNIXmESdmp20zfxDqrKRGHmu3s/Zo6BzsZ7Xq6F3wlw2Yh
         NcLLbgjZx4GwtSJ0oKrbG+6anWhuM7s2PdL8vyRFkjqK3lYoKtHTAjlshon5wipKu46e
         3/GrppxI5mO3GEPSUEcEJBa762KHpSy/L0ePz8ZVxnWZ6SoM1UyZfrfQ+vci9U5BkaC0
         NJYw==
X-Gm-Message-State: AOJu0YwdjymavpxOMRfQcOcGoTAG8JOEPcwK2OV4UC3zScrOzIpNK0OM
	83258x/yOZXt+GE8qtjsg6/ipT1+8AONEetcs6OmABdmnmVYDJraEVuwuSlJbsRylLTbU5N1cdA
	k9I3O7+nJT74ndDoc7vmi7XCUEWss
X-Received: by 2002:a67:b044:0:b0:45a:98d9:38ea with SMTP id q4-20020a67b044000000b0045a98d938eamr7690802vsh.16.1698762085036;
        Tue, 31 Oct 2023 07:21:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2V2HRRlSao5fkLO60dc1man5T8XhRoSC+35EbDqRfws4Hgm+ZERXgteR1s842YAalJM05R9C6Jle+6nalghs=
X-Received: by 2002:a67:b044:0:b0:45a:98d9:38ea with SMTP id
 q4-20020a67b044000000b0045a98d938eamr7690782vsh.16.1698762084734; Tue, 31 Oct
 2023 07:21:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231027204933.3651381-1-seanjc@google.com> <20231027204933.3651381-4-seanjc@google.com>
In-Reply-To: <20231027204933.3651381-4-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 31 Oct 2023 15:21:12 +0100
Message-ID: <CABgObfaimAUNCaTqM85=qq0Re1ZwQyJO9vNQFZRJHs_D+Y9uKQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Misc changes for 6.7
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 27, 2023 at 10:49=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> A truly miscellaneous collection of patches this time around.  David M's =
PML
> fix obviously belongs in the MMU pull request, but I applied it to the wr=
ong
> branch and didn't want to rebase for such a silly thing.
>
> The following changes since commit 5804c19b80bf625c6a9925317f845e497434d6=
d3:
>
>   Merge tag 'kvm-riscv-fixes-6.6-1' of https://github.com/kvm-riscv/linux=
 into HEAD (2023-09-23 05:35:55 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.7
>
> for you to fetch changes up to 2770d4722036d6bd24bcb78e9cd7f6e572077d03:
>
>   KVM: x86: Ignore MSR_AMD64_TW_CFG access (2023-10-19 10:55:14 -0700)

Pulled, thanks.

Paolo

>
> ----------------------------------------------------------------
> KVM x86 misc changes for 6.7:
>
>  - Add CONFIG_KVM_MAX_NR_VCPUS to allow supporting up to 4096 vCPUs witho=
ut
>    forcing more common use cases to eat the extra memory overhead.
>
>  - Add IBPB and SBPB virtualization support.
>
>  - Fix a bug where restoring a vCPU snapshot that was taken within 1 seco=
nd of
>    creating the original vCPU would cause KVM to try to synchronize the v=
CPU's
>    TSC and thus clobber the correct TSC being set by userspace.
>
>  - Compute guest wall clock using a single TSC read to avoid generating a=
n
>    inaccurate time, e.g. if the vCPU is preempted between multiple TSC re=
ads.
>
>  - "Virtualize" HWCR.TscFreqSel to make Linux guests happy, which complai=
n
>     about a "Firmware Bug" if the bit isn't set for select F/M/S combos.
>
>  - Don't apply side effects to Hyper-V's synthetic timer on writes from
>    userspace to fix an issue where the auto-enable behavior can trigger
>    spurious interrupts, i.e. do auto-enabling only for guest writes.
>
>  - Remove an unnecessary kick of all vCPUs when synchronizing the dirty l=
og
>    without PML enabled.
>
>  - Advertise "support" for non-serializing FS/GS base MSR writes as appro=
priate.
>
>  - Use octal notation for file permissions through KVM x86.
>
>  - Fix a handful of typo fixes and warts.
>
> ----------------------------------------------------------------
> David Matlack (1):
>       KVM: x86/mmu: Stop kicking vCPUs to sync the dirty log when PML is =
disabled
>
> David Woodhouse (1):
>       KVM: x86: Refine calculation of guest wall clock to use a single TS=
C read
>
> Dongli Zhang (1):
>       KVM: x86: remove always-false condition in kvmclock_sync_fn
>
> Jim Mattson (4):
>       KVM: x86: Allow HWCR.McStatusWrEn to be cleared once set
>       KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
>       KVM: selftests: Test behavior of HWCR, a.k.a. MSR_K7_HWCR
>       x86: KVM: Add feature flag for CPUID.80000021H:EAX[bit 1]
>
> Josh Poimboeuf (2):
>       KVM: x86: Add IBPB_BRTYPE support
>       KVM: x86: Add SBPB support
>
> Kyle Meyer (1):
>       KVM: x86: Add CONFIG_KVM_MAX_NR_VCPUS to allow up to 4096 vCPUs
>
> Liang Chen (1):
>       KVM: x86: remove the unused assigned_dev_head from kvm_arch
>
> Like Xu (1):
>       KVM: x86: Don't sync user-written TSC against startup values
>
> Maciej S. Szmigiero (1):
>       KVM: x86: Ignore MSR_AMD64_TW_CFG access
>
> Michal Luczaj (2):
>       KVM: x86: Remove redundant vcpu->arch.cr0 assignments
>       KVM: x86: Force TLB flush on userspace changes to special registers
>
> Mingwei Zhang (1):
>       KVM: x86: Update the variable naming in kvm_x86_ops.sched_in()
>
> Nicolas Saenz Julienne (1):
>       KVM: x86: hyper-v: Don't auto-enable stimer on write from user-spac=
e
>
> Peng Hao (1):
>       KVM: x86: Use octal for file permission
>
>  arch/x86/include/asm/cpufeatures.h                 |   1 +
>  arch/x86/include/asm/kvm_host.h                    |  12 +-
>  arch/x86/include/asm/msr-index.h                   |   1 +
>  arch/x86/kvm/Kconfig                               |  11 ++
>  arch/x86/kvm/cpuid.c                               |   8 +-
>  arch/x86/kvm/cpuid.h                               |   3 +-
>  arch/x86/kvm/hyperv.c                              |  10 +-
>  arch/x86/kvm/smm.c                                 |   1 -
>  arch/x86/kvm/svm/svm.c                             |   2 +-
>  arch/x86/kvm/vmx/vmx.c                             |  20 +--
>  arch/x86/kvm/x86.c                                 | 195 +++++++++++++++=
+-----
>  arch/x86/kvm/x86.h                                 |   1 +
>  arch/x86/kvm/xen.c                                 |   4 +-
>  tools/testing/selftests/kvm/Makefile               |   1 +
>  tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c |  47 +++++
>  15 files changed, 251 insertions(+), 66 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c
>


