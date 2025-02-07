Return-Path: <kvm+bounces-37553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E2B4A2B9B2
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 04:27:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F61D1889A05
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 03:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC11188907;
	Fri,  7 Feb 2025 03:26:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D9A4EB51;
	Fri,  7 Feb 2025 03:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738898806; cv=none; b=EznnvR6PfQOeke4QCA1o2XrgkVIBwfp6VEob7JJzKw/KcFZUOoPP0lJdwhGdHOgB+PjCYjUDYgdK0MrQCr7KpWL/257fidsNE0KKJx0JEMtYnm9QqKrGbljYhzooa7lOLMRCHSZvb3T+m2ZgMfvWZU6XPIOAmspuz61llq3LeM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738898806; c=relaxed/simple;
	bh=4tl9W+KlvAbFa8js48u/8tzIfnw31Y/t/v4xcLcyKiI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BysIWczByoDK0elP6xBr6ErXgqZJi9DbwvUFxIiyznWZZlZDPZe819KktF1IvXjcDeQfyoOjlXuMwNieZz3QSL9qDR8N27C+b0pnNnyjSZZ9p37WH54fNnFQihJ6m63IMWKXsVeU7LYQ+weheFlbKMQ87np2ftWfAcUaseZKPeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxGeBqfaVnNjFuAA--.17251S3;
	Fri, 07 Feb 2025 11:26:34 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDx_MRqfaVn0JsDAA--.12326S2;
	Fri, 07 Feb 2025 11:26:34 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] LoongArch: KVM: Some tiny code cleanup
Date: Fri,  7 Feb 2025 11:26:31 +0800
Message-Id: <20250207032634.2333300-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDx_MRqfaVn0JsDAA--.12326S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

There is some tiny code cleanup with VM context switch or vCPU context
switch path. And add comments for feature macro so that it is easy to
understand.

Bibo Mao (3):
  LoongArch: KVM: Fix typo issue about GCFG feature detection
  LoongArch: KVM: Remove duplicated cache attribute setting
  LoongArch: KVM: Set host with kernel mode when switch to VM mode

 arch/loongarch/include/asm/loongarch.h | 26 ++++++++++++++++++++++++++
 arch/loongarch/kvm/main.c              |  4 ++--
 arch/loongarch/kvm/switch.S            |  2 +-
 arch/loongarch/kvm/vcpu.c              |  3 ---
 4 files changed, 29 insertions(+), 6 deletions(-)


base-commit: 5c8c229261f14159b54b9a32f12e5fa89d88b905
-- 
2.39.3


