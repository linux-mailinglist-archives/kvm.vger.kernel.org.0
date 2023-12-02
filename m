Return-Path: <kvm+bounces-3263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BD23801E9F
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 22:19:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D4B91C2082D
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 21:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2499D219F3;
	Sat,  2 Dec 2023 21:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Xof8o13W"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b0])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFDD102
	for <kvm@vger.kernel.org>; Sat,  2 Dec 2023 13:19:06 -0800 (PST)
Date: Sat, 2 Dec 2023 13:18:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701551945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=bt3lo3ErvssH39DRGX6dCA6xEOnxf5ofeDp/CVk4sm4=;
	b=Xof8o13WrokB8K1TA+XUB7WVsjt8bLetDjwisEV+V/UdaBfChHJ4FPy7W5WsN63rSQQBOt
	xmwOkNlfXcY/XbXKEYBWkI0zmdOdm4pxfmRl0Sp/RDxUXUzi1gPZgqe0X8/X8tcgtWEdyo
	bnYaaj9LEf623Ocf56x6C8cME2GQhyE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Kunkun Jiang <jiangkunkun@huawei.com>
Subject: [GIT PULL] KVM/arm64 fixes for 6.7, take #1
Message-ID: <ZWufQneeJiBJLnPb@thinky-boi>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Paolo,

Here's the first set of fixes for 6.7. There hasn't been very many
interesting issues that have come up this cycle, so it is only a single
patch this time around.

Please pull :)

--
Thanks,
Oliver

The following changes since commit b85ea95d086471afb4ad062012a4d73cd328fa86:

  Linux 6.7-rc1 (2023-11-12 16:19:07 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.7-1

for you to fetch changes up to 8e4ece6889a5b1836b6a135827ac831a5350602a:

  KVM: arm64: GICv4: Do not perform a map to a mapped vLPI (2023-11-20 19:13:32 +0000)

----------------------------------------------------------------
KVM/arm64 fixes for 6.7, take #1

 - Avoid mapping vLPIs that have already been mapped

----------------------------------------------------------------
Kunkun Jiang (1):
      KVM: arm64: GICv4: Do not perform a map to a mapped vLPI

 arch/arm64/kvm/vgic/vgic-v4.c | 4 ++++
 1 file changed, 4 insertions(+)

