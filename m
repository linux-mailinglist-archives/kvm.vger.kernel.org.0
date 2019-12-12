Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C53B611D3D9
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 18:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbfLLR2r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 12:28:47 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:47938 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730027AbfLLR2r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 12:28:47 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1ifSGV-00069s-HK; Thu, 12 Dec 2019 18:28:39 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>, Jia He <justin.he@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 1/8] KVM: arm/arm64: Get rid of unused arg in cpu_init_hyp_mode()
Date:   Thu, 12 Dec 2019 17:28:17 +0000
Message-Id: <20191212172824.11523-2-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212172824.11523-1-maz@kernel.org>
References: <20191212172824.11523-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, alexandru.elisei@arm.com, ard.biesheuvel@linaro.org, christoffer.dall@arm.com, eric.auger@redhat.com, james.morse@arm.com, justin.he@arm.com, mark.rutland@arm.com, linmiaohe@huawei.com, steven.price@arm.com, will@kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

As arg dummy is not really needed, there's no need to pass
NULL when calling cpu_init_hyp_mode(). So clean it up.

Fixes: 67f691976662 ("arm64: kvm: allows kvm cpu hotplug")
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/1574320559-5662-1-git-send-email-linmiaohe@huawei.com
---
 virt/kvm/arm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 12e0280291ce..8de4daf25097 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1352,7 +1352,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	}
 }
 
-static void cpu_init_hyp_mode(void *dummy)
+static void cpu_init_hyp_mode(void)
 {
 	phys_addr_t pgd_ptr;
 	unsigned long hyp_stack_ptr;
@@ -1386,7 +1386,7 @@ static void cpu_hyp_reinit(void)
 	if (is_kernel_in_hyp_mode())
 		kvm_timer_init_vhe();
 	else
-		cpu_init_hyp_mode(NULL);
+		cpu_init_hyp_mode();
 
 	kvm_arm_init_debug();
 
-- 
2.20.1

