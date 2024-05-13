Return-Path: <kvm+bounces-17342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E31B8C45E7
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 19:21:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0826528421D
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 17:21:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B255C20DCB;
	Mon, 13 May 2024 17:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZX0cQ39z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09E120310;
	Mon, 13 May 2024 17:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715620886; cv=none; b=rMEZ7FX8XNHBCVmwch1dvPuN6IFD/Gq0d975cUGPk9kdoh0mAYFvEB+b7VO6gJIuTULvgJQVWUTy2EZLg/PM0NKO8VvDbGhZ+8Uo/AIOIL+uIoASLtpL11eKno6OdzFz2v/aq+jLwnTYqkoqxEikGvRoSEq9jChRn4slAjS4QSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715620886; c=relaxed/simple;
	bh=k++p0ZG9E1nTiNJDIztVZOSY2K/lTio1vsTURr954Oc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSCLW5ysaGsec01DAf931J5dmrNuzGxtp6qWPYWmIzynfmYYXqISMGFLrlX/0YLaZNugRykY2bL2uVssZwFXd3dqnnwQwQRtAe06aostan34miKWN4NBV9xQC6wMSHoWUm814yonMvb9TSF4HODLTonqG7slfxi55MOmUxgDF9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZX0cQ39z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77F7C113CC;
	Mon, 13 May 2024 17:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715620886;
	bh=k++p0ZG9E1nTiNJDIztVZOSY2K/lTio1vsTURr954Oc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZX0cQ39zWPuJUcRR0OHvx7IUl9CqRcakfXqWjz3zW2Bv+aKK/Sr+V5Li7aTqODExu
	 tB+6QTxPLdfjJWoAg2wkmNQW6RnTqTWapbP/8Rxhie8fK/Yo0WHuKI/FG7EiSIVu4T
	 NrpHzv3F3BUJe0zvcVeHaYIJUDQdkwzns5gT3Ii+muhLm26G4JmEdEJ4EdQXJwGbmb
	 44CnUrUnhxGOyku/afuKyLw6VvezfXpMiKELWfKFSU1G2CRJr02Lt+6GO1768spit0
	 BbHYqqbmss6JdfY3pjvNgL7wUhnaw9A5gSVzhGT6Bm5TQftgp5TmtDawj+Exm+wHJs
	 mpv5XjxMfe6GQ==
Date: Mon, 13 May 2024 18:21:21 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v3 09/12] KVM: arm64: VHE: Add test module for hyp kCFI
Message-ID: <20240513172120.GA29051@willie-the-truck>
References: <20240510112645.3625702-1-ptosi@google.com>
 <20240510112645.3625702-10-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240510112645.3625702-10-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 10, 2024 at 12:26:38PM +0100, Pierre-Clément Tosi wrote:
> In order to easily periodically (and potentially automatically) validate
> that the hypervisor kCFI feature doesn't bitrot, introduce a way to
> trigger hypervisor kCFI faults from userspace on test builds of KVM.
> 
> Add hooks in the hypervisor code to call registered callbacks (intended
> to trigger kCFI faults either for the callback call itself of from
> within the callback function) when running with guest or host VBAR_EL2.
> As the calls are issued from the KVM_RUN ioctl handling path, userspace
> gains control over when the actual triggering of the fault happens
> without needing to modify the KVM uAPI.
> 
> Export kernel functions to register these callbacks from modules and
> introduce a kernel module intended to contain any testing logic. By
> limiting the changes to the core kernel to a strict minimum, this
> architectural split allows tests to be updated (within the module)
> without the need to redeploy (or recompile) the kernel (hyp) under test.
> 
> Use the module parameters as the uAPI for configuring the fault
> condition being tested (i.e. either at insertion or post-insertion
> using /sys/module/.../parameters), which naturally makes it impossible
> for userspace to test kCFI without the module (and, inversely, makes
> the module only - not KVM - responsible for exposing said uAPI).
> 
> As kCFI is implemented with a caller-side check of a callee-side value,
> make the module support 4 tests based on the location of the caller and
> callee (built-in or in-module), for each of the 2 hypervisor contexts
> (host & guest), selected by userspace using the 'guest' or 'host' module
> parameter. For this purpose, export symbols which the module can use to
> configure the callbacks for in-kernel and module-to-built-in kCFI
> faulting calls.
> 
> Define the module-to-kernel API to allow the module to detect that it
> was loaded on a kernel built with support for it but which is running
> without a hypervisor (-ENXIO) or with one that doesn't use the VHE CPU
> feature (-EOPNOTSUPP), which is currently the only mode for which KVM
> supports hypervisor kCFI.
> 
> Allow kernel build configs to set CONFIG_HYP_CFI_TEST to only support
> the in-kernel hooks (=y) or also build the test module (=m). Use
> intermediate internal Kconfig flags (CONFIG_HYP_SUPPORTS_CFI_TEST and
> CONFIG_HYP_CFI_TEST_MODULE) to simplify the Makefiles and #ifdefs. As
> the symbols for callback registration are only exported to modules when
> CONFIG_HYP_CFI_TEST != n, it is impossible for the test module to be
> non-forcefully inserted on a kernel that doesn't support it.
> 
> Note that this feature must NOT result in any noticeable change
> (behavioral or binary size) when HYP_CFI_TEST_MODULE = n.
> 
> CONFIG_HYP_CFI_TEST is intentionally independent of CONFIG_CFI_CLANG, to
> avoid arbitrarily limiting the number of flag combinations that can be
> tested with the module.
> 
> Also note that, as VHE aliases VBAR_EL1 to VBAR_EL2 for the host,
> testing hypervisor kCFI in VHE and in host context is equivalent to
> testing kCFI support of the kernel itself i.e. EL1 in non-VHE and/or in
> non-virtualized environments. For this reason, CONFIG_CFI_PERMISSIVE
> **will** prevent the test module from triggering a hyp panic (although a
> warning still gets printed) in that context.
> 
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/include/asm/kvm_cfi.h     |  36 ++++++++
>  arch/arm64/kvm/Kconfig               |  22 +++++
>  arch/arm64/kvm/Makefile              |   3 +
>  arch/arm64/kvm/hyp/include/hyp/cfi.h |  47 ++++++++++
>  arch/arm64/kvm/hyp/vhe/Makefile      |   1 +
>  arch/arm64/kvm/hyp/vhe/cfi.c         |  37 ++++++++
>  arch/arm64/kvm/hyp/vhe/switch.c      |   7 ++
>  arch/arm64/kvm/hyp_cfi_test.c        |  43 +++++++++
>  arch/arm64/kvm/hyp_cfi_test_module.c | 133 +++++++++++++++++++++++++++
>  9 files changed, 329 insertions(+)
>  create mode 100644 arch/arm64/include/asm/kvm_cfi.h
>  create mode 100644 arch/arm64/kvm/hyp/include/hyp/cfi.h
>  create mode 100644 arch/arm64/kvm/hyp/vhe/cfi.c
>  create mode 100644 arch/arm64/kvm/hyp_cfi_test.c
>  create mode 100644 arch/arm64/kvm/hyp_cfi_test_module.c
> 
> diff --git a/arch/arm64/include/asm/kvm_cfi.h b/arch/arm64/include/asm/kvm_cfi.h
> new file mode 100644
> index 000000000000..13cc7b19d838
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_cfi.h
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2024 - Google Inc
> + * Author: Pierre-Clément Tosi <ptosi@google.com>
> + */
> +
> +#ifndef __ARM64_KVM_CFI_H__
> +#define __ARM64_KVM_CFI_H__
> +
> +#include <asm/kvm_asm.h>
> +#include <linux/errno.h>
> +
> +#ifdef CONFIG_HYP_SUPPORTS_CFI_TEST
> +
> +int kvm_cfi_test_register_host_ctxt_cb(void (*cb)(void));
> +int kvm_cfi_test_register_guest_ctxt_cb(void (*cb)(void));

Hmm, I tend to think this indirection is a little over the top for a test
module that only registers a small handful of handlers:

> +static int set_param_mode(const char *val, const struct kernel_param *kp,
> +			 int (*register_cb)(void (*)(void)))
> +{
> +	unsigned int *mode = kp->arg;
> +	int err;
> +
> +	err = param_set_uint(val, kp);
> +	if (err)
> +		return err;
> +
> +	switch (*mode) {
> +	case 0:
> +		return register_cb(NULL);
> +	case 1:
> +		return register_cb(hyp_trigger_builtin_cfi_fault);
> +	case 2:
> +		return register_cb((void *)hyp_cfi_builtin2module_test_target);
> +	case 3:
> +		return register_cb(trigger_module2builtin_cfi_fault);
> +	case 4:
> +		return register_cb(trigger_module2module_cfi_fault);
> +	default:
> +		return -EINVAL;
> +	}
> +}

Why not just have a hyp selftest that runs through all of this behind a
static key? I think it would simplify the code quite a bit, and you could
move the registration and indirection logic.

Will

