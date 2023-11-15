Return-Path: <kvm+bounces-1807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61D4B7EBF82
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 10:32:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 785821C2095A
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 09:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFAEA8F65;
	Wed, 15 Nov 2023 09:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28B863C4
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 09:32:23 +0000 (UTC)
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 958ECFC;
	Wed, 15 Nov 2023 01:32:21 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
	by gateway (Coremail) with SMTP id _____8CxbesjkFRlWjw6AA--.46619S3;
	Wed, 15 Nov 2023 17:32:19 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Bx7twhkFRlq99CAA--.16093S2;
	Wed, 15 Nov 2023 17:32:17 +0800 (CST)
From: Tianrui Zhao <zhaotianrui@loongson.cn>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	loongarch@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Mark Brown <broonie@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	maobibo@loongson.cn,
	Xi Ruoyao <xry111@xry111.site>,
	zhaotianrui@loongson.cn
Subject: [PATCH v1 0/2] LoongArch: KVM: Add LSX,LASX support
Date: Wed, 15 Nov 2023 17:19:19 +0800
Message-Id: <20231115091921.85516-1-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Bx7twhkFRlq99CAA--.16093S2
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

This patch series add LSX,LASX support for LoongArch KVM.
LSX: LoongArch 128-bits vector instruction
LASX:LoongArch 256-bits vector instruction

There will be LSX,LASX exception in KVM when guest use the
LSX,LASX instructions. KVM will enable LSX,LASX and restore
the vector registers for guest then return to guest to continue
running.

Changes for v1:
(1) Add LSX support for LoongArch KVM.
(2) Add LASX support for LoongArch KVM.

Tianrui Zhao (1):
  LoongArch: KVM: Add lsx support

zhaotianrui (1):
  LoongArch: KVM: Add lasx support

 arch/loongarch/include/asm/kvm_host.h | 12 ++++
 arch/loongarch/include/asm/kvm_vcpu.h | 22 +++++++
 arch/loongarch/kernel/fpu.S           |  1 +
 arch/loongarch/kvm/exit.c             | 36 +++++++++++
 arch/loongarch/kvm/switch.S           | 38 ++++++++++++
 arch/loongarch/kvm/trace.h            |  6 +-
 arch/loongarch/kvm/vcpu.c             | 88 ++++++++++++++++++++++++++-
 7 files changed, 199 insertions(+), 4 deletions(-)

-- 
2.39.1


