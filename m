Return-Path: <kvm+bounces-20091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5965910843
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:30:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F18A282CA4
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 14:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 441471AE84D;
	Thu, 20 Jun 2024 14:29:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C569B1AD9EC;
	Thu, 20 Jun 2024 14:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718893793; cv=none; b=qMQPJgVAfq6Ifk1mXg2w5yGGKlic2VGWHCZUWQlJbncZ64TTMeyzXnVWRag9qq9VvYYCXC21PHty5BDedEwIVJsqJT88yfbXT5lQiN6sc6yngVsG0/raT32ZqeCkBPuRN2q7jS3a6mX/DodCaMoImeSOd9QL8uOOyWDQ3T51C6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718893793; c=relaxed/simple;
	bh=pBCyZkc4tuebg1GUCHdWBTrOlQDaM2RFzwp3I0Ya9Ug=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=O2j342MzVJm5mWMWqR8dih7GPNvViWEl0xuRDXn+Ncl4rl55AIQhqvZVkdw5gd1toKFiuE825g1EOB9oYvFCUGC4f/iMOcyENA/DtH2z6VjttTYlXbFRCZVToGfVCVDO0OR56OQrbPpnZ/cDZvkJnE0rMTTiEWYLejkjOdnnSug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4W4jYn5TNbz4wyg;
	Fri, 21 Jun 2024 00:29:49 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: pbonzini@redhat.com, naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu, corbet@lwn.net, mpe@ellerman.id.au, namhyung@kernel.org, npiggin@gmail.com, pbonzini@redhat.com, jniethe5@gmail.com, atrajeev@linux.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <171759276071.1480.9356137231993600304.stgit@linux.ibm.com>
References: <171759276071.1480.9356137231993600304.stgit@linux.ibm.com>
Subject: Re: [PATCH v2 0/8] KVM: PPC: Book3S HV: Nested guest migration fixes
Message-Id: <171889374990.827284.7391262828595235764.b4-ty@ellerman.id.au>
Date: Fri, 21 Jun 2024 00:29:09 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Wed, 05 Jun 2024 13:06:00 +0000, Shivaprasad G Bhat wrote:
> The series fixes the issues exposed by the kvm-unit-tests[1]
> sprs-migration test.
> 
> The SDAR, MMCR3 were seen to have some typo/refactoring bugs.
> The first two patches fix them.
> 
> The remaining patches take care of save-restoring the guest
> state elements for DEXCR, HASHKEYR and HASHPKEYR SPRs with PHYP
> during entry-exit. The KVM_PPC_REG too for them are missing which
> are added for use by the QEMU.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/8] KVM: PPC: Book3S HV: Fix the set_one_reg for MMCR3
      https://git.kernel.org/powerpc/c/f9ca6a10be20479d526f27316cc32cfd1785ed39
[2/8] KVM: PPC: Book3S HV: Fix the get_one_reg of SDAR
      https://git.kernel.org/powerpc/c/009f6f42c67e9de737d6d3d199f92b21a8cb9622
[3/8] KVM: PPC: Book3S HV: Add one-reg interface for DEXCR register
      https://git.kernel.org/powerpc/c/1a1e6865f516696adcf6e94f286c7a0f84d78df3
[4/8] KVM: PPC: Book3S HV nestedv2: Keep nested guest DEXCR in sync
      https://git.kernel.org/powerpc/c/2d6be3ca3276ab30fb14f285d400461a718d45e7
[5/8] KVM: PPC: Book3S HV: Add one-reg interface for HASHKEYR register
      https://git.kernel.org/powerpc/c/e9eb790b25577a15d3f450ed585c59048e4e6c44
[6/8] KVM: PPC: Book3S HV nestedv2: Keep nested guest HASHKEYR in sync
      https://git.kernel.org/powerpc/c/1e97c1eb785fe2dc863c2bd570030d6fcf4b5e5b
[7/8] KVM: PPC: Book3S HV: Add one-reg interface for HASHPKEYR register
      https://git.kernel.org/powerpc/c/9a0d2f4995ddde3022c54e43f9ece4f71f76f6e8
[8/8] KVM: PPC: Book3S HV nestedv2: Keep nested guest HASHPKEYR in sync
      https://git.kernel.org/powerpc/c/0b65365f3fa95c2c5e2094739151a05cabb3c48a

cheers

