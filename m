Return-Path: <kvm+bounces-4745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E4EAA81793B
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 18:54:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C2461F256E9
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 17:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6AB5D759;
	Mon, 18 Dec 2023 17:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mpWBB7Cl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4E75D74C
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 17:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1d3d7d21535so1589045ad.2
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 09:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702922053; x=1703526853; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fMINNfJWvuE04cFMv8rPBVGtN6CWNaVi7PaUm7htEuY=;
        b=mpWBB7ClfC7vGHbXkVYDycQyAYtY/Qh1r5QX2wUaR3PSNECkco40mLb81PVdvQarn+
         gjYnahElBHASp6CqAVKpz8HyTjQJ/X/eMVOBqFWms//IcI9pNqM3xAwc1fy873k/xEON
         fXuP8ExI3kSESzkTO3KaKSOZNcDsK1a19UkNOrCP1/sSaljuNX4diQp4t7Uhlcl7dWZu
         WQauPySymdS4T5ww1cwvIih8KIShkWGhlmw52K+a5MZHwD63GM0NvyqJPWFPUJN+icM0
         tkMh9YgxAFmc4kSVsZLcgUdI81SG0h4eZe81ciAa9pIn7/ZVgNpyHxWXTFlxSDEOEwr8
         DMRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702922053; x=1703526853;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fMINNfJWvuE04cFMv8rPBVGtN6CWNaVi7PaUm7htEuY=;
        b=Km7B5Szc/Gpetsc5gGPcwYDFQgRLA8crI1WXWg7koLyV8eFJaTFhOz/6DQLCGtYcnB
         /LKvhSAi41VBSbvhIlpwwDGTOMDeXjcLC+VyvncJYI5p9mvOzTQtmprV68T+ZsqxDEOp
         yW8CcmtMFTMX6L4wiQ/9AdWXvKVZg2KvvFAPCllFbjJF9nmXEjVOTYL1kYngHJUS4RG8
         Lir3ox3RVFZNTzKw4WnPBvtZDhTtuzmyzBErUozLzYqUgqYFrMAwr5IMbBoKGhI5L6N6
         ojV7NIHR6OiIlWtgCOR3zle7OeiWA+lc4kRq7YpYN5OwISgONFQ08SZyN3S6BXmfCR5B
         MJKA==
X-Gm-Message-State: AOJu0YyGAhmyos2PE654UDQadrd1UBmEwKK7ZTKhYQ76fjd1tosdHwQ8
	INsLtiJzx2ZpgqQ/oULg3e4xtQzjZVM=
X-Google-Smtp-Source: AGHT+IHzSHvEwiqU8rtO9dbjBujIsHj9eLqnkFbvaBi2EXL1IjShmUdETJlo/EVjjDzEDkcgluuJNK3DWvw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:230e:b0:1d3:d81c:7984 with SMTP id
 d14-20020a170903230e00b001d3d81c7984mr18440plh.7.1702922053108; Mon, 18 Dec
 2023 09:54:13 -0800 (PST)
Date: Mon, 18 Dec 2023 09:54:11 -0800
In-Reply-To: <bug-218267-28872@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-218267-28872@https.bugzilla.kernel.org/>
Message-ID: <ZYCHQzwRpCSgw3Pk@google.com>
Subject: Re: [Bug 218267] New: [Sapphire Rapids][Upstream]Boot up multiple
 Windows VMs hang
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 15, 2023, bugzilla-daemon@kernel.org wrote:
> Platform: Sapphire Rapids Platform
> 
> Host OS: CentOS Stream 9
> 
> Kernel:6.7.0-rc1 (commit:8ed26ab8d59111c2f7b86d200d1eb97d2a458fd1)

...

> Qemu: QEMU emulator version 8.1.94 (v8.2.0-rc4)
> (commit:039afc5ef7367fbc8fb475580c291c2655e856cb)
> 
> Host Kernel cmdline:BOOT_IMAGE=/kvm-vmlinuz root=/dev/mapper/cs_spr--2s2-root
> ro crashkernel=auto console=tty0 console=ttyS0,115200,8n1 3 intel_iommu=on
> disable_mtrr_cleanup
> 
> Bug detailed description
> =======
> We boot up 8 Windows VMs (total vCPUs > pCPUs) in host, random run application
> on each VM such as WPS editing etc, and wait for a moment, then Some of the
> Windows Guest hang and console reports "KVM internal error. Suberror: 3".

...

> Code=25 88 61 00 00 b9 70 00 00 40 0f ba 32 00 72 06 33 c0 8b d0 <0f> 30 5a 58
> 59 c3 cc cc cc cc cc cc 0f 1f 84 00 00 00 00 00 48 81 ec 38 01 00 00 48 8d 84
> 
> KVM internal error. Suberror: 3
> extra data[0]: 0x000000008000002f  <= Vectoring IRQ 47 (decimal)
> extra data[1]: 0x0000000000000020  <= WRMSR VM-Exit
> extra data[2]: 0x0000000000000f82
> extra data[3]: 0x000000000000004b

KVM exits with an internal error because the CPU indicates that IRQ 47 was being
delivered/vectored when the VM-Exit occurred, but the VM-Exit is due to WRMSR.
A WRMSR VM-Exit is supposed to only occur on an instruction boundary, i.e. can't
occur while delivering an IRQ (or any exception/event), and so KVM kicks out to
userspace because something has gone off the rails.

   b9 70 00 00 40          mov    0x40000070, ecx
   0f ba 32 00             btr    0x0, DWORD PTR [rdx]
   72 06                   jb     0x16
   33 c0                   xor    eax,eax
   8b d0                   mov    eax, edx
   0f 30                   wrmsr

FWIW, the MSR in question is Hyper-V's synthetic EOI, a.k.a. HV_X64_MSR_EOI, though
I doubt the exact MSR matters.

Have you tried an older host kernel?  If not can you try something like v6.1?
Note, if you do, use base v6.1, *not* the stable tree in case a bug was backported.

There was a recent change to relevant code, commit 50011c2a2457 ("KVM: VMX: Refresh
available regs and IDT vectoring info before NMI handling"), though I don't see
any obvious bugs.  But I'm pretty sure the only alternative explanation is a
CPU/ucode bug, so it's definitely worth checking older versions of KVM.

