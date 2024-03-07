Return-Path: <kvm+bounces-11309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E138B875246
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 15:50:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F02E1C22B2A
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 14:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35CE912BF06;
	Thu,  7 Mar 2024 14:50:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC951E865;
	Thu,  7 Mar 2024 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709823014; cv=none; b=AIbctfHstqM6s6SlejE/ivSxq004q0kWoDQQg7rDy50NgoWqpo11GV44mQ24x8xrTrRorl5EQfhvg0Zqw/XdikqFj+uh88ikuXFzXTLCU7h15BS1gY0v0NfZZzN9mLEzbzs+k/dVKEEDs5b0a4lZAmsKHe/CNCGPqtmYtb25mP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709823014; c=relaxed/simple;
	bh=C/qCrjhoIs3jvOYBesJnb1uSBPlCckrGFa/pt10VT+w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UxrW17U1pJYfE9LqtM5uFa8bhVU1u11nyoy+Pd4ptm0AQEGujl13bC5/9MOYgVSqh+PnftUV8wKIof/vWQtODJpgNzZaCBKm06DzafKhxutktFOqvFEGKnsuvOlObAV/ffpY5pCXWGad0EqbRn+HQSjnZhiOWx6TGnsR/6524Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB558C433C7;
	Thu,  7 Mar 2024 14:50:11 +0000 (UTC)
From: Huacai Chen <chenhuacai@loongson.cn>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Xuerui Wang <kernel@xen0n.name>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [GIT PULL] LoongArch KVM changes for v6.9
Date: Thu,  7 Mar 2024 22:49:30 +0800
Message-ID: <20240307144930.3919566-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following changes since commit 90d35da658da8cff0d4ecbb5113f5fac9d00eb72:

  Linux 6.8-rc7 (2024-03-03 13:02:52 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git tags/loongarch-kvm-6.9

for you to fetch changes up to b99f783106ea5b2f8c9d74f4d3b1e2f77af9ec6e:

  LoongArch: KVM: Remove unnecessary CSR register saving during enter guest (2024-03-06 09:12:13 +0800)

----------------------------------------------------------------
LoongArch KVM changes for v6.9

1. Set reserved bits as zero in CPUCFG.
2. Start SW timer only when vcpu is blocking.
3. Do not restart SW timer when it is expired.
4. Remove unnecessary CSR register saving during enter guest.

KVM PV features are unfortunately missing in v6.9 for some
implementation controversies, sigh.
----------------------------------------------------------------
Bibo Mao (4):
      LoongArch: KVM: Set reserved bits as zero in CPUCFG
      LoongArch: KVM: Start SW timer only when vcpu is blocking
      LoongArch: KVM: Do not restart SW timer when it is expired
      LoongArch: KVM: Remove unnecessary CSR register saving during enter guest

 arch/loongarch/kvm/switch.S |  6 ------
 arch/loongarch/kvm/timer.c  | 43 ++++++++++---------------------------------
 arch/loongarch/kvm/vcpu.c   | 33 ++++++++++++++++++++++++++-------
 3 files changed, 36 insertions(+), 46 deletions(-)

