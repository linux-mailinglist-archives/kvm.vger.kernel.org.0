Return-Path: <kvm+bounces-41594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1018EA6AD00
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 19:18:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6E0E18971D4
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 18:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EF3C225A5B;
	Thu, 20 Mar 2025 18:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="floBr6rA"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2012AD20
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 18:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742494687; cv=none; b=N8C9aW8cR0wCStc2XT/OxLKUBfp1+5/TPCjSr/7K0o/5bAmduc8vuvVXyhsn2FoSYufBQSbU8fY3LavF86sXTeIZUK1fHY3UCJqCXHIid/lrYsxeXrHFEzKS0FeGu8kdAxqisx+6px3JE9ZBPBd3320gCOekjLE/1NBhFi/nhds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742494687; c=relaxed/simple;
	bh=kgFhOZDJMI9KaBTW80gZMe9l4SBqoP/TrIDZAvlNvqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j3a88yd5zZBkGh6EhW8LzZ9DVBbAQ0csxI4vHBKv7tKUWpVhNQd8/75qULkShWLwRYEeUOKYP7HfRbF3WwQKvbFGNjhX0Vf4iQ168DMS2p3iIaYu3jrgvfHLA4dwOZmAhv8Oa0ow5ft8mX/dHuSl4ihwUCQxrGkDU7WZbYokR6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=floBr6rA; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 20 Mar 2025 18:17:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742494672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/5YlZC3aik6HXiACmy6t8g/Xv3GypRFT+iIORLPcXhI=;
	b=floBr6rAIg13qL8F9bU99ViTJh2SLb2SrPwf6ZzNDuMLN1xQR++em9wwem45oGlsVChuGH
	+YWx4v4vCrgXuVv3KL3Qif/a8bejRgzb63psulsdaYvzTHF0a5Uyonjm0f+G4X0nS1zt9y
	QhA821oesnGLrc7U4D50wK2e5zO8uY4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Make ASIDs static for SVM
Message-ID: <Z9xby4dSWWvHSjgL@google.com>
References: <20250313215540.4171762-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250313215540.4171762-1-yosry.ahmed@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 13, 2025 at 09:55:33PM +0000, Yosry Ahmed wrote:
> This series changes SVM to use a single ASID per-VM, instead of using
> dynamic generation-based ASIDs per-vCPU. Dynamic ASIDs were added for
> CPUs without FLUSHBYASID to avoid full TLB flushes, but as Sean said,
> FLUSHBYASID was added in 2010, and the case for this is no longer as
> strong [1].
> 
> Furthermore, having different ASIDs for different vCPUs is not required.
> ASIDs are local to physical CPUs. The only requirement is to make sure
> the ASID is flushed before a differnet vCPU runs on the same physical
> CPU (see below). Furthermore, SEV VMs have been using with a single ASID
> per-VM anyway (required for different reasons).
> 
> A new ASID is currently allocated in 3 cases:
> (a) Once when the vCPU is initialized.
> (b) When the vCPU moves to a new physical CPU.
> (c) On TLB flushes when FLUSHBYASID is not available.
> 
> Case (a) is trivial, instead the ASID is allocated for VM creation.
> Case (b) is handled by flushing the ASID instead of assigning a new one.
> Case (c) is handled by doing a full TLB flush (i.e.
> TLB_CONTROL_FLUSH_ALL_ASID) instead of assinging a new ASID. This is
> a bit aggressive, but FLUSHBYASID is available in all modern CPUs.
> 
> The series is organized as follows:
> - Patch 1 generalizes the VPID allocation code in VMX to be
>   vendor-neutral, to reuse for SVM.
> - Patches 2-3 do some refactoring and cleanups.
> - Patches 4-5 address cases (b) and (c) above.
> - Patch 6 moves to single ASID per-VM.
> - Patch 7 performs some minimal unification between SVM and SEV code.
>   More unification can be done. In particular, SEV can use the
>   generalized kvm_tlb_tags to allocate ASIDs, and can stop tracking the
>   ASID separately in struct kvm_sev_info. However, I didn't have enough
>   SEV knowledge (or testability) to do this.
> 
> The performance impact does not seem to be that bad. To test this
> series, I ran 3 benchmarks in an SVM guest on a Milan machine:
> - netperf
> - cpuid_rate [2]
> - A simple program doing mmap() and munmap() of 100M for 100 iterations,
>   to trigger MMU syncs and TLB flushes when using the shadow MMU.
> 
> The benchmarks were ran with and without the patches for 5 iterations
> each, and also with and without NPT and FLUSBYASID to emulate old
> hardware. In all cases, there was either no difference or a 1-2%
> performance hit for the old hardware case. The performance hit could be
> larger for specific workloads, but niche performance-sensitive workloads
> should not be running on very old hardware.

This series has several bugs. It allows a VM to use ASID 0 if we run out
of space (which is not allowed by VMRUN), and it does not handle the
case where multiple vCPUs of the same VM with the same ASID run on the
same CPU (handled by SEV through svm_cpu_data.sev_vmcbs).

I also think it's useful to see how the nSVM TLB flushing looks like on
top of this. So please hold off on reviewing this series, I will send a
new combined series.

> 
> [1] https://lore.kernel.org/lkml/Z8JOvMx6iLexT3pK@google.com/
> [2] https://lore.kernel.org/kvm/20231109180646.2963718-1-khorenko@virtuozzo.com/
> 
> Yosry Ahmed (7):
>   KVM: VMX: Generalize VPID allocation to be vendor-neutral
>   KVM: SVM: Use cached local variable in init_vmcb()
>   KVM: SVM: Add helpers to set/clear ASID flush
>   KVM: SVM: Flush everything if FLUSHBYASID is not available
>   KVM: SVM: Flush the ASID when running on a new CPU
>   KVM: SVM: Use a single ASID per VM
>   KVM: SVM: Share more code between pre_sev_run() and pre_svm_run()
> 
>  arch/x86/include/asm/svm.h |  5 ---
>  arch/x86/kvm/svm/nested.c  |  4 +-
>  arch/x86/kvm/svm/sev.c     | 26 +++++-------
>  arch/x86/kvm/svm/svm.c     | 87 ++++++++++++++++++++------------------
>  arch/x86/kvm/svm/svm.h     | 28 ++++++++----
>  arch/x86/kvm/vmx/nested.c  |  4 +-
>  arch/x86/kvm/vmx/vmx.c     | 38 +++--------------
>  arch/x86/kvm/vmx/vmx.h     |  4 +-
>  arch/x86/kvm/x86.c         | 58 +++++++++++++++++++++++++
>  arch/x86/kvm/x86.h         | 13 ++++++
>  10 files changed, 161 insertions(+), 106 deletions(-)
> 
> -- 
> 2.49.0.rc1.451.g8f38331e32-goog
> 

