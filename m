Return-Path: <kvm+bounces-24676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB23995919C
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 02:10:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FFC5B218DA
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 00:10:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2940C1C01;
	Wed, 21 Aug 2024 00:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mpFFMxkq"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24484A1D
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 00:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724199034; cv=none; b=KecXdTp8A/1NTXDLKbPGZf8OrHOwbAxbLkjo/ZzoOZXo/EFFRrmCGurCEnYGQ0tyrAGHUoFlQkPMGpqWIbt/XIgGG4666E0zOwP0IXm4U+yM5Enlnn9tNI4l0NFgt3LzSts3HL0Vd2+zYNXPqEmq+n3PmJoFaZCqVwr+AQgfm7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724199034; c=relaxed/simple;
	bh=cFp6zVnnyev+q9Q/XuLRa0Y8qA580u8V4E2+HDmzHuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q493RLT5XEOredoY3JWqK+8uvK+pKOo23A7NlMUPiqiMblr+QEqOcRhRUlciVIvY0T7gEGQAcxwHqGwtGh/TbZrhw29I57Y8Ky52btf/ZbbDaP/IcpTwQpJ8UtBcVb/+uLNDPlGuqOq3WyWeTCz65PR5X9u/xNH2e2mk4XYQvwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mpFFMxkq; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 20 Aug 2024 17:10:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724199029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pfBZF71vB+efgUAfC9rXR0u22NZxOfbgAngHkzBGvhM=;
	b=mpFFMxkqYDmDeD1BF7jbbvcU9SZfqNoMmapPytT9ZGD9pJdcZcuf+1X3EYJokym7+2eXdD
	4Cdp3RPIYLq7uw+EYRKOsnQkjovBCVLDkIKW7EFMzJLqPL1Nb3v1DwuvCOSKnE5daltqzv
	xeiHiSsyQVSnSzEDs8R4b+VJGn0osc8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH 12/12] KVM: arm64: Add selftest checking how the absence
 of GICv3 is handled
Message-ID: <ZsUwb2pEUNQt2arR@linux.dev>
References: <20240820100349.3544850-1-maz@kernel.org>
 <20240820100349.3544850-13-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820100349.3544850-13-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 20, 2024 at 11:03:49AM +0100, Marc Zyngier wrote:
> Given how tortuous and fragile the whole lack-of-GICv3 story is,
> add a selftest checking that we don't regress it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/aarch64/no-vgic-v3.c        | 170 ++++++++++++++++++
>  2 files changed, 171 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/aarch64/no-vgic-v3.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 48d32c5aa3eb..f66b37acc0b0 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -163,6 +163,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
>  TEST_GEN_PROGS_aarch64 += aarch64/vgic_lpi_stress
>  TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
> +TEST_GEN_PROGS_aarch64 += aarch64/no-vgic-v3
>  TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
>  TEST_GEN_PROGS_aarch64 += arch_timer
>  TEST_GEN_PROGS_aarch64 += demand_paging_test
> diff --git a/tools/testing/selftests/kvm/aarch64/no-vgic-v3.c b/tools/testing/selftests/kvm/aarch64/no-vgic-v3.c
> new file mode 100644
> index 000000000000..27169afc94c6
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/aarch64/no-vgic-v3.c
> @@ -0,0 +1,170 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +// Check that, on a GICv3 system, not configuring GICv3 correctly
> +// results in all of the sysregs generating an UNDEF exception.
> +
> +#include <test_util.h>
> +#include <kvm_util.h>
> +#include <processor.h>
> +
> +static volatile bool handled;
> +
> +#define __check_sr_read(r)					\
> +	do {							\
> +		uint64_t val;					\
> +								\
> +		handled = false;				\
> +		dsb(sy);					\
> +		val = read_sysreg_s(SYS_ ## r);			\
> +		(void)val;					\
> +	} while(0)
> +
> +#define __check_sr_write(r)					\
> +	do {							\
> +		handled = false;				\
> +		dsb(sy);					\
> +		write_sysreg_s(0, SYS_ ## r);			\
> +		isb();						\
> +	} while(0)
> +
> +/* Fatal checks */
> +#define check_sr_read(r)					\
> +	do {							\
> +		__check_sr_read(r);				\
> +		__GUEST_ASSERT(handled, #r " no read trap");	\
> +	} while(0)
> +
> +#define check_sr_write(r)					\
> +	do {							\
> +		__check_sr_write(r);				\
> +		__GUEST_ASSERT(handled, #r " no write trap");	\
> +	} while(0)
> +
> +#define check_sr_rw(r)				\
> +	do {					\
> +		check_sr_read(r);		\
> +		check_sr_write(r);		\
> +	} while(0)
> +
> +/* Non-fatal checks */
> +#define check_sr_read_maybe(r)						\
> +	do {								\
> +		__check_sr_read(r);					\
> +		if (!handled)						\
> +			GUEST_PRINTF(#r " read not trapping (OK)\n");	\
> +	} while(0)
> +
> +#define check_sr_write_maybe(r)						\
> +	do {								\
> +		__check_sr_write(r);					\
> +		if (!handled)						\
> +			GUEST_PRINTF(#r " write not trapping (OK)\n");	\
> +	} while(0)
> +
> +static void guest_code(void)
> +{
> +	/*
> +	 * Check that we advertise that ID_AA64PFR0_EL1.GIC == 0, having
> +	 * hidden the feature at runtime without any other userspace action.
> +	 */
> +	__GUEST_ASSERT(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_GIC),
> +				 read_sysreg(id_aa64pfr0_el1)) == 0,
> +		       "GICv3 wrongly advertised");
> +
> +	/*
> +	 * Access all GICv3 registers, and fail if we don't get an UNDEF.
> +	 * Note that we happily access all the APxRn registers without
> +	 * checking their existance, as all we want to see is a failure.
> +	 */
> +	check_sr_rw(ICC_PMR_EL1);
> +	check_sr_read(ICC_IAR0_EL1);
> +	check_sr_write(ICC_EOIR0_EL1);
> +	check_sr_rw(ICC_HPPIR0_EL1);
> +	check_sr_rw(ICC_BPR0_EL1);
> +	check_sr_rw(ICC_AP0R0_EL1);
> +	check_sr_rw(ICC_AP0R1_EL1);
> +	check_sr_rw(ICC_AP0R2_EL1);
> +	check_sr_rw(ICC_AP0R3_EL1);
> +	check_sr_rw(ICC_AP1R0_EL1);
> +	check_sr_rw(ICC_AP1R1_EL1);
> +	check_sr_rw(ICC_AP1R2_EL1);
> +	check_sr_rw(ICC_AP1R3_EL1);
> +	check_sr_write(ICC_DIR_EL1);
> +	check_sr_read(ICC_RPR_EL1);
> +	check_sr_write(ICC_SGI1R_EL1);
> +	check_sr_write(ICC_ASGI1R_EL1);
> +	check_sr_write(ICC_SGI0R_EL1);
> +	check_sr_read(ICC_IAR1_EL1);
> +	check_sr_write(ICC_EOIR1_EL1);
> +	check_sr_rw(ICC_HPPIR1_EL1);
> +	check_sr_rw(ICC_BPR1_EL1);
> +	check_sr_rw(ICC_CTLR_EL1);
> +	check_sr_rw(ICC_IGRPEN0_EL1);
> +	check_sr_rw(ICC_IGRPEN1_EL1);
> +
> +	/*
> +	 * ICC_SRE_EL1 may not be trappable, as ICC_SRE_EL2.Enable can
> +	 * be RAO/WI
> +	 */
> +	check_sr_read_maybe(ICC_SRE_EL1);
> +	check_sr_write_maybe(ICC_SRE_EL1);

In the case that a write does not UNDEF, should we check that
ICC_SRE_EL1.SRE is also RAO/WI?

-- 
Thanks,
Oliver

