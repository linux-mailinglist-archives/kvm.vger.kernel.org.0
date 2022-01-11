Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364A548A4B0
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 02:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346066AbiAKBE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 20:04:59 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:59584 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243225AbiAKBE7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 20:04:59 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V1WtPEy_1641863096;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V1WtPEy_1641863096)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 11 Jan 2022 09:04:57 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     anup@brainfault.org
Cc:     atishp@atishpatra.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] RISC-V: KVM: remove unneeded semicolon
Date:   Tue, 11 Jan 2022 09:04:54 +0800
Message-Id: <20220111010454.126241-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eliminate the following coccicheck warning:
./arch/riscv/kvm/vcpu_sbi_v01.c:117:2-3: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 arch/riscv/kvm/vcpu_sbi_v01.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_v01.c b/arch/riscv/kvm/vcpu_sbi_v01.c
index 4c7e13ec9ccc..9acc8fa21d1f 100644
--- a/arch/riscv/kvm/vcpu_sbi_v01.c
+++ b/arch/riscv/kvm/vcpu_sbi_v01.c
@@ -114,7 +114,7 @@ static int kvm_sbi_ext_v01_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	default:
 		ret = -EINVAL;
 		break;
-	};
+	}
 
 	return ret;
 }
-- 
2.20.1.7.g153144c

