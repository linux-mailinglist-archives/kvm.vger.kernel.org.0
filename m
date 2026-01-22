Return-Path: <kvm+bounces-68901-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gHELHIdAcmnpfAAAu9opvQ
	(envelope-from <kvm+bounces-68901-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:21:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D0D068A42
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:21:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A9D783047059
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 15:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E24E36CE00;
	Thu, 22 Jan 2026 15:14:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 295AB369229;
	Thu, 22 Jan 2026 15:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769094841; cv=none; b=G0Vz+WxswuA21M/U8jp0crYrFbR2+lZbFqitC7cf+kEbFb9fMMDADGw23CDOTi8SLx3kJAQuRpA9EPap2BAbormp8MpUO1kx0CtMpXiFjhypkQMydUIUhLQPJ1b4w9KTmVG57/vKXXXKhaWRj2CxpzpKOaSk6EYpp1azYkXw3gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769094841; c=relaxed/simple;
	bh=7EhnDCa5DdDVVOaHZg9iRoMPUPP7DFCJeLFhd4Rbjo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=YZ6yjNBxpzb7TBz1QLJTUFkm4hNcOuV26ZHg83ZexR5IsuB84EuiI5gNLC2jAIT4rdGaFWNTzDSaASurQ7wicOxQ6oC8UHbhZ4LqKIxd5fwaubfAbcTLLKs2oD/VkSLFrB1R2K+dPuJUcBq1hF2B4vk379BrQ+zdpOpsURakDuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF2B91476;
	Thu, 22 Jan 2026 07:13:50 -0800 (PST)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 050223F632;
	Thu, 22 Jan 2026 07:13:54 -0800 (PST)
From: Leonardo Bras <leo.bras@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	oliver.upton@linux.dev,
	catalin.marinas@arm.com,
	corbet@lwn.net,
	pbonzini@redhat.com,
	will@kernel.org,
	linux-kernel@vger.kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yezhenyu2@huawei.com,
	xiexiangyou@huawei.com,
	zhengchuan@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v2 1/5] arm64/sysreg: Add HDBSS related register information
Date: Thu, 22 Jan 2026 15:12:28 +0000
Message-ID: <aXI-XHF2jz7arOwg@devkitleo>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <86wm3iqlz8.wl-maz@kernel.org>
References: <20251121092342.3393318-1-zhengtian10@huawei.com> <20251121092342.3393318-2-zhengtian10@huawei.com> <86wm3iqlz8.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.86 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	FORGED_SENDER_MAILLIST(0.00)[];
	R_DKIM_NA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leo.bras@arm.com,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68901-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1D0D068A42
X-Rspamd-Action: no action

On Sat, Nov 22, 2025 at 12:40:27PM +0000, Marc Zyngier wrote:
> On Fri, 21 Nov 2025 09:23:38 +0000,
> Tian Zheng <zhengtian10@huawei.com> wrote:
> > 
> > From: eillon <yezhenyu2@huawei.com>
> > 
> > The ARM architecture added the HDBSS feature and descriptions of
> > related registers (HDBSSBR/HDBSSPROD) in the DDI0601(ID121123) version,
> > add them to Linux.
> > 
> > Signed-off-by: eillon <yezhenyu2@huawei.com>
> > Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> > ---
> >  arch/arm64/include/asm/esr.h     |  2 ++
> >  arch/arm64/include/asm/kvm_arm.h |  1 +
> >  arch/arm64/tools/sysreg          | 28 ++++++++++++++++++++++++++++
> >  3 files changed, 31 insertions(+)
> > 
> > diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> > index e1deed824464..a6f3cf0b9b86 100644
> > --- a/arch/arm64/include/asm/esr.h
> > +++ b/arch/arm64/include/asm/esr.h
> > @@ -159,6 +159,8 @@
> >  #define ESR_ELx_CM 		(UL(1) << ESR_ELx_CM_SHIFT)
> > 
> >  /* ISS2 field definitions for Data Aborts */
> > +#define ESR_ELx_HDBSSF_SHIFT	(11)
> > +#define ESR_ELx_HDBSSF		(UL(1) << ESR_ELx_HDBSSF_SHIFT)
> >  #define ESR_ELx_TnD_SHIFT	(10)
> >  #define ESR_ELx_TnD 		(UL(1) << ESR_ELx_TnD_SHIFT)
> >  #define ESR_ELx_TagAccess_SHIFT	(9)
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> > index 1da290aeedce..b71122680a03 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -124,6 +124,7 @@
> >  			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK)
> > 
> >  /* VTCR_EL2 Registers bits */
> > +#define VTCR_EL2_HDBSS		(1UL << 45)
> 
> I think it is time to convert VTCR_EL2 to the sysreg infrastructure
> instead of adding extra bits here.


Hi Marc, Tian,

Marc, IIUC the above was implemented by 
https://lore.kernel.org/all/20251210173024.561160-1-maz@kernel.org

Which was recently applied to next, and it its way to mainstream.

Tian, I think it's worth rebasing this patchset on top of the above.

BTW, I am working on using the feature enabled by this patchset on a new 
optimization, so please include me on any new release.

Thanks!
Leo

