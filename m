Return-Path: <kvm+bounces-18654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7FDD8D8485
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 15:59:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 257ED1C22535
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 13:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E9712E1C5;
	Mon,  3 Jun 2024 13:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SyY7UJvj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F171E892;
	Mon,  3 Jun 2024 13:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717423183; cv=none; b=B38l67+18ahKisjijlw1u8wRwViGKR7iixmdOXQvekDcS4RXw1jBDiRCANbCOJi8MEMqDpKM25d86Bwu5/+n+O/s1qevvRAguVN4Gsoc3/gVGyUlAIzuIriG9Wd/o/ofu9MObmUNUgrpHunrrVURhIQ7c/GEtsRw17ZZ7co1FkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717423183; c=relaxed/simple;
	bh=m9F1tMy1cVucXFVAnvCLLWurQRs1OcWmoLkqsGYMg68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=htebE8JLFKOIbrjYl0HKAGVMzB8bApMjTN46DALu0gj/yPQDt64OIrPrjQFeHRbw81lSwDciUNMItIoILxT5mO3KUK5g/5XcV3g5M2uLm7FcMU+qRIZmWxZx32eoe9mrL/eZIuPmHT71ikuVhyo9/GP0MGUNEV4OT9uTCJLOM8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SyY7UJvj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6500AC2BD10;
	Mon,  3 Jun 2024 13:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717423183;
	bh=m9F1tMy1cVucXFVAnvCLLWurQRs1OcWmoLkqsGYMg68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SyY7UJvjwkD40r9wAwYheEgHYuw8dBL6c8id9edb5mho0OQnm7roz5NxNJI7l3I+8
	 7HJkYla0IuGQNHxLf2nY3NaIV3eHvu4CLiDhnmB/7+tK9/9n81RPqdthJEEhcgrs5Q
	 4C+jNeIT6Wk7ZHMgvqeRTBGOqMkP61TSgJxQHumtEFwyV+SJ83Ihsc4in40QOwf802
	 xIE1ivTOaLKT2ZpOR5ce202f9gqTonT+zAnwJp1x/79KogNq3lUZRpcolKwCA9TaxV
	 flWP24QmNGvupf9yfmoodYk7DzjyYzdo613VH9C9XgBj1tzqkzFIONPkFgukjxe0nU
	 VL1p2aDzHYk2Q==
Date: Mon, 3 Jun 2024 14:59:38 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 00/13] KVM: arm64: Add support for hypervisor kCFI
Message-ID: <20240603135937.GA19151@willie-the-truck>
References: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 29, 2024 at 01:12:06PM +0100, Pierre-Clément Tosi wrote:
> CONFIG_CFI_CLANG ("kernel Control Flow Integrity") makes the compiler inject
> runtime type checks before any indirect function call. On AArch64, it generates
> a BRK instruction to be executed on type mismatch and encodes the indices of the
> registers holding the branch target and expected type in the immediate of the
> instruction. As a result, a synchronous exception gets triggered on kCFI failure
> and the fault handler can retrieve the immediate (and indices) from ESR_ELx.
> 
> This feature has been supported at EL1 ("host") since it was introduced by
> b26e484b8bb3 ("arm64: Add CFI error handling"), where cfi_handler() decodes
> ESR_EL1, giving informative panic messages such as
> 
>   [   21.885179] CFI failure at lkdtm_indirect_call+0x2c/0x44 [lkdtm]
>   (target: lkdtm_increment_int+0x0/0x1c [lkdtm]; expected type: 0x7e0c52a)
>   [   21.886593] Internal error: Oops - CFI: 0 [#1] PREEMPT SMP
> 
> However, it is not or only partially supported at EL2: in nVHE (or pKVM),
> CONFIG_CFI_CLANG gets filtered out at build time, preventing the compiler from
> injecting the checks. In VHE, EL2 code gets compiled with the checks but the
> handlers in VBAR_EL2 are not aware of kCFI and will produce a generic and
> not-so-helpful panic message such as
> 
>   [   36.456088][  T200] Kernel panic - not syncing: HYP panic:
>   [   36.456088][  T200] PS:204003c9 PC:ffffffc080092310 ESR:f2008228
>   [   36.456088][  T200] FAR:0000000081a50000 HPFAR:000000000081a500 PAR:1de7ec7edbadc0de
>   [   36.456088][  T200] VCPU:00000000e189c7cf
> 
> To address this,
> 
> - [01/13] fixes an existing bug where the ELR_EL2 was getting clobbered on
>   synchronous exceptions, causing the wrong "PC" to be reported by
>   nvhe_hyp_panic_handler() or __hyp_call_panic(). This is particularly limiting
>   for kCFI, as it would mask the location of the failed type check.
> - [02/13] fixes a minor C/asm ABI mismatch which would trigger a kCFI failure
> - [03/13] to [09/13] prepare nVHE for CONFIG_CFI_CLANG and [10/13] enables it
> - [11/13] improves kCFI error messages by saving then parsing the CPU context
> - [12/13] adds a kCFI test module for VHE and [13/13] extends it to nVHE & pKVM
> 
> As a result, an informative kCFI panic message is printed by or on behalf of EL2
> giving the expected type and target address (possibly resolved to a symbol) for
> VHE, nVHE, and pKVM (iff CONFIG_NVHE_EL2_DEBUG=y).
> 
> Note that kCFI errors remain fatal at EL2, even when CONFIG_CFI_PERMISSIVE=y.
> 
> Changes in v4:
>   - Addressed Will's comments on v3:

nit: but please keep reviewers on CC when you post a new version. I
missed this initially.

Will

