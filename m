Return-Path: <kvm+bounces-51524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84EF8AF8119
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 21:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C6D11CA40A6
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 19:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 102A52F2735;
	Thu,  3 Jul 2025 19:02:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D7224EF76;
	Thu,  3 Jul 2025 19:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751569339; cv=none; b=s1C7+05/sh+fU8p58cir1ctNZnJRNInKw9gFMAuBAXap9yx/EuT/n86EbQeyV7Irqe0apy9yAPPewvt8+z35mnwiC3PW38QWN5Ote0twwOUizzHs2bqGre/AZaQc4AKI/JLEOEvztTmRbjnEs1y7jAARSq34r37bnqiHXLY5jkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751569339; c=relaxed/simple;
	bh=UP07chNqEZY7uRAHeSpj3JWXCpnuyx7UxAapYtG9CbM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fD8ky3Q89xRFW4cvs8uWMFq0Y06bSyOS337jgtKqBcrIBymxpOmdgCRm7XYE+LPhLlZzGuN8X/d/Gqp6guhiWurTZ4cSfMRl/Jnh25lDZKWsLvh1jpXdueA7KI3YneZRI0IE4us++cjjQtKgxt/pSMRlSCi6nQXAYnPgR0ut3Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54ACC4CEEB;
	Thu,  3 Jul 2025 19:02:13 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH V5 0/2] arm64/debug: Drop redundant DBG_MDSCR_* macros
Date: Thu,  3 Jul 2025 20:02:11 +0100
Message-Id: <175156930986.3510289.10858196646035984142.b4-ty@arm.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250613023646.1215700-1-anshuman.khandual@arm.com>
References: <20250613023646.1215700-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 13 Jun 2025 08:06:44 +0530, Anshuman Khandual wrote:
> MDSCR_EL1 has already been defined in tools sysreg format and hence can be
> used in all debug monitor related call paths. Subsequently all DBG_MDSCR_*
> macros become redundant and hence can be dropped off completely. While here
> convert all variables handling MDSCR_EL1 register as u64 which reflects its
> true width as well.
> 
> This series applies on v6.16-rc1
> 
> [...]

Applied to arm64 (for-next/mdscr-cleanup), thanks!

[1/2] arm64/debug: Drop redundant DBG_MDSCR_* macros
      https://git.kernel.org/arm64/c/d3a80c5109a3
[2/2] KVM: selftests: Change MDSCR_EL1 register holding variables as uint64_t
      https://git.kernel.org/arm64/c/30ff3c981e48

-- 
Catalin


