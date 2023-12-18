Return-Path: <kvm+bounces-4751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BE21F817B6A
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 20:52:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E7A51F2202A
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 19:52:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD10471477;
	Mon, 18 Dec 2023 19:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mgBTfMCe"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC54471450
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 19:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 18 Dec 2023 19:51:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702929081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MNLDxkyQEIxDaRjSMEFk0lA/gC40y5Szs1CPQAo05zE=;
	b=mgBTfMCeO2gca9mHwRzBoEND0XJYbbI/9Pc93Ou/hXzyhlMqSSq5J77ufFS/BiVdCjNwn4
	q+ntjjCG2qC6SpafIkjQmSqRf/gVxeV2zQkz+EveivZBxoooNZTL+tYES5Wjb/qu1HgCwR
	Xy4ERO89rE9xibo8BeT0+Aour6fMO3A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v11 00/43] KVM: arm64: Nested Virtualization support
 (FEAT_NV2 only)
Message-ID: <ZYCis7lNTYouBQnU@linux.dev>
References: <20231120131027.854038-1-maz@kernel.org>
 <86sf3zadmp.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86sf3zadmp.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 18, 2023 at 12:39:26PM +0000, Marc Zyngier wrote:
> On Mon, 20 Nov 2023 13:09:44 +0000,
> Marc Zyngier <maz@kernel.org> wrote:
> > 
> > This is the 5th drop of NV support on arm64 for this year, and most
> > probably the last one for this side of Christmas.
> 
> Unless someone objects, I'm planning to take the first 10 patches of
> this series into 6.8 (with the dependency on ID_AA64MMFR4_EL1.NV_frac
> in patch #1 removed).

For the first 10 patches:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

