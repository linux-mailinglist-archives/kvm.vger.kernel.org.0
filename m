Return-Path: <kvm+bounces-59777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F43ABCDCD1
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 17:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1DCA54E86C6
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 15:29:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A092F99B3;
	Fri, 10 Oct 2025 15:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uReHgcMI"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C152F8BFC
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 15:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760110181; cv=none; b=ZX9nykRT2aQ1aPGGWtgzjp95OF6pVPuORBMu0aL2sw3k7Og/puY/VgVEtO+tp+ebNjBiXfe+DMAWUJ7+D6T4ijBMF6HvfcHs3k6qRsXo+St1iOUZNvh2koSWudrODQ5+dRohBLL86o+XA0GJHET7vWcDsBdRS7UeM7FA65wgIwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760110181; c=relaxed/simple;
	bh=bQjmRzwvDlWBNOUknLBSMmasOFXzjkSWSgwrVNUwjTM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uU4vW6LesUBxXE8hufo/gID+pclMR5fKYC6vjwUSEvoINA85+UwpmVzKhRh+nwxy5EkO+07loM74xxnViFjarI0bnll1W0PQbsHlS0vD8LHn3wCkWgBUmDVa5KLNQnezdcUlK8qUF5a1Zs51tiz61mCQWts+tCkyTOwRFIhqRy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uReHgcMI; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <25cf9d85-0f42-46d9-a4b6-618b406256f1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760110177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CKUrS5jDQSXSheSIBCNgkQhgEHNgs+CbGyP1+oymFao=;
	b=uReHgcMIl9041kVUV2NYDBnZ17LLwXhi8mvrSAKSipFDx+9sk8nnrtoxVG+nhoQME8efbV
	VfpjoyvLoDgbLz2tKB9fE8dfI8ksz5xi4VLtD6mPs2LwpjGLG2Kjw7S4f0hFqCdzvhPKBf
	bEl3VZgTHMhk8gEeVvNpO5c5riztYKE=
Date: Fri, 10 Oct 2025 23:29:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Cover ID_AA64ISAR3_EL1 in
 set_id_regs
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250920-kvm-arm64-id-aa64isar3-el1-v1-0-1764c1c1c96d@kernel.org>
 <20250920-kvm-arm64-id-aa64isar3-el1-v1-2-1764c1c1c96d@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20250920-kvm-arm64-id-aa64isar3-el1-v1-2-1764c1c1c96d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2025/9/21 03:52, Mark Brown wrote:
> We have a couple of writable bitfields in ID_AA64ISAR3_EL1 but the
> set_id_regs selftest does not cover this register at all, add coverage.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> index bfb70926272d..c7c38b1a1f10 100644
> --- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
> @@ -125,6 +125,13 @@ static const struct reg_ftr_bits ftr_id_aa64isar2_el1[] = {
>  	REG_FTR_END,
>  };
>  
> +static const struct reg_ftr_bits ftr_id_aa64isar3_el1[] = {
> +	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR3_EL1, FPRCVT, 0),
> +	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR3_EL1, LSFE, 0),
> +	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR3_EL1, FAMINMAX, 0),
> +	REG_FTR_END,
> +};
> +
>  static const struct reg_ftr_bits ftr_id_aa64pfr0_el1[] = {
>  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, CSV3, 0),
>  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR0_EL1, CSV2, 0),
> @@ -221,6 +228,7 @@ static struct test_feature_reg test_regs[] = {
>  	TEST_REG(SYS_ID_AA64ISAR0_EL1, ftr_id_aa64isar0_el1),
>  	TEST_REG(SYS_ID_AA64ISAR1_EL1, ftr_id_aa64isar1_el1),
>  	TEST_REG(SYS_ID_AA64ISAR2_EL1, ftr_id_aa64isar2_el1),
> +	TEST_REG(SYS_ID_AA64ISAR3_EL1, ftr_id_aa64isar3_el1),
>  	TEST_REG(SYS_ID_AA64PFR0_EL1, ftr_id_aa64pfr0_el1),
>  	TEST_REG(SYS_ID_AA64PFR1_EL1, ftr_id_aa64pfr1_el1),
>  	TEST_REG(SYS_ID_AA64MMFR0_EL1, ftr_id_aa64mmfr0_el1),
> @@ -239,6 +247,7 @@ static void guest_code(void)
>  	GUEST_REG_SYNC(SYS_ID_AA64ISAR0_EL1);
>  	GUEST_REG_SYNC(SYS_ID_AA64ISAR1_EL1);
>  	GUEST_REG_SYNC(SYS_ID_AA64ISAR2_EL1);
> +	GUEST_REG_SYNC(SYS_ID_AA64ISAR3_EL1);
>  	GUEST_REG_SYNC(SYS_ID_AA64PFR0_EL1);
>  	GUEST_REG_SYNC(SYS_ID_AA64MMFR0_EL1);
>  	GUEST_REG_SYNC(SYS_ID_AA64MMFR1_EL1);

Not related to this patch but seems that we forgot to sync several
registers (ID_AA64PFR1, MPIDR, CLIDR) in guest to make sure the guest
had seen the written value.

Zenghui

