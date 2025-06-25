Return-Path: <kvm+bounces-50634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 533C2AE7945
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 09:59:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9EA667AFB69
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 07:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F82E20B81D;
	Wed, 25 Jun 2025 07:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kZuJ4DhW"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00ADA207A26
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 07:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750838362; cv=none; b=l4zNgMIYIig26Nbkqvqj4I8ZNHED01DQRxxnEWApnVdxgP2xXmIrUTsDrPJ8aiUFZBG9bRqdYOq+g0ROydlaScBcxT5hzH05fuF8cMxOY40aWrC6m+/+BgTk7s2KhsGn5jqPztZwFCeAO2VrUR2jU5uRRLgWWzU4m6OGGWAl5OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750838362; c=relaxed/simple;
	bh=zUGZufnvMKaCOA4cdvldqWv45x8gEZBbT0XjJGKRVik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d+vYE92E8P35ON+5snPbRcYoWtCrciF8lVbQDnLzRlxrNlSwde0+cmNB/+6Okps9AeRHIAf/GfhmtQ6+obU16F5J8nLDJq+VleR5R4w/s0IwMcLFG+KanLZFq7mT+R+ppYTmg00X6qK2+1Ub3CUZNH2XuMi4K2oAUkYS4yu3cGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kZuJ4DhW; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <9d9316d7-7e00-4274-bd1c-9cb83fd82d32@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750838356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5/oz/zGgO2lN3zqV+etyJUP5tKHg/3V30huStLqNW9k=;
	b=kZuJ4DhW42AB1uTtKIOcJmDzEI3f1DUB1nDhB7RmZtJyIpYhTJbyYeKOS66gVENcr/UcM8
	oNSuSRj0UCwzfK2urGWKsxJICw5xZK0LbYSMC0yFWQcuzaw4E4OtO9mbxkhVNeiwY6LWVg
	75ADxYh8LfI1v6hi2eejSlcLC/nYAoY=
Date: Wed, 25 Jun 2025 00:59:10 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 00/12] MMU related improvements for KVM RISC-V
To: Anup Patel <apatel@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20250618113532.471448-1-apatel@ventanamicro.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Atish Patra <atish.patra@linux.dev>
In-Reply-To: <20250618113532.471448-1-apatel@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT


On 6/18/25 4:35 AM, Anup Patel wrote:
> This series primarily has various MMU improvements for KVM RISC-V
> and it also serves as a preparatory series for the upcoming nested
> virtualization support.
>
> PATCH1 to PATCH4: Few cosmetic improvements
> PATCH5 to PATCH7: TLB maintenance and SBI NACL related improvements
> PATCH8 to PATCH12: MMU related preparatory work for nested virtualization

For the entire series:

Tested-by: Atish Patra <atishp@rivosinc.com>

> These patches can also be found in the riscv_kvm_mmu_imp_v3 branch
> at: https://github.com/avpatel/linux.git
>
> Changes since v2:
>   - Rebased upon Linux-6.16-rc2 and latest riscv_kvm_queue branch
>   - Added Reviewed-by tags to appropriate patches
>
> Changes since v1:
>   - Rebased upon Linux-6.16-rc1
>   - Dropped PATCH1 and PATCH2 of v1 series since these are queued
>     as fixes for Linux-6.16
>   - Addressed Atish's comment on PATCH1 in this series
>   - Added new PATCH7 in this series
>
> Anup Patel (12):
>    RISC-V: KVM: Check kvm_riscv_vcpu_alloc_vector_context() return value
>    RISC-V: KVM: Drop the return value of kvm_riscv_vcpu_aia_init()
>    RISC-V: KVM: Rename and move kvm_riscv_local_tlb_sanitize()
>    RISC-V: KVM: Replace KVM_REQ_HFENCE_GVMA_VMID_ALL with
>      KVM_REQ_TLB_FLUSH
>    RISC-V: KVM: Don't flush TLB when PTE is unchanged
>    RISC-V: KVM: Implement kvm_arch_flush_remote_tlbs_range()
>    RISC-V: KVM: Use ncsr_xyz() in kvm_riscv_vcpu_trap_redirect()
>    RISC-V: KVM: Factor-out MMU related declarations into separate headers
>    RISC-V: KVM: Introduce struct kvm_gstage_mapping
>    RISC-V: KVM: Add vmid field to struct kvm_riscv_hfence
>    RISC-V: KVM: Factor-out g-stage page table management
>    RISC-V: KVM: Pass VMID as parameter to kvm_riscv_hfence_xyz() APIs
>
>   arch/riscv/include/asm/kvm_aia.h    |   2 +-
>   arch/riscv/include/asm/kvm_gstage.h |  72 ++++
>   arch/riscv/include/asm/kvm_host.h   | 103 +-----
>   arch/riscv/include/asm/kvm_mmu.h    |  21 ++
>   arch/riscv/include/asm/kvm_tlb.h    |  84 +++++
>   arch/riscv/include/asm/kvm_vmid.h   |  27 ++
>   arch/riscv/kvm/Makefile             |   1 +
>   arch/riscv/kvm/aia_device.c         |   6 +-
>   arch/riscv/kvm/aia_imsic.c          |  12 +-
>   arch/riscv/kvm/gstage.c             | 338 +++++++++++++++++++
>   arch/riscv/kvm/main.c               |   3 +-
>   arch/riscv/kvm/mmu.c                | 499 ++++++----------------------
>   arch/riscv/kvm/tlb.c                | 110 +++---
>   arch/riscv/kvm/vcpu.c               |  26 +-
>   arch/riscv/kvm/vcpu_exit.c          |  20 +-
>   arch/riscv/kvm/vcpu_sbi_replace.c   |  17 +-
>   arch/riscv/kvm/vcpu_sbi_v01.c       |  25 +-
>   arch/riscv/kvm/vm.c                 |   7 +-
>   arch/riscv/kvm/vmid.c               |  25 ++
>   19 files changed, 795 insertions(+), 603 deletions(-)
>   create mode 100644 arch/riscv/include/asm/kvm_gstage.h
>   create mode 100644 arch/riscv/include/asm/kvm_mmu.h
>   create mode 100644 arch/riscv/include/asm/kvm_tlb.h
>   create mode 100644 arch/riscv/include/asm/kvm_vmid.h
>   create mode 100644 arch/riscv/kvm/gstage.c
>

