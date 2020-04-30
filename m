Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986E71BEE88
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 05:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgD3DIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 23:08:48 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3389 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726180AbgD3DIs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Apr 2020 23:08:48 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A444332F201F2EBA6E37;
        Thu, 30 Apr 2020 11:08:45 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 30 Apr 2020 11:08:36 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <tsbogend@alpha.franken.de>
CC:     <linux-mips@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] KVM: MIPS/VZ: Remove unneeded semicolon
Date:   Thu, 30 Apr 2020 11:14:50 +0800
Message-ID: <1588216490-60282-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixes coccicheck warnings:

arch/mips/kvm/vz.c:1186:4-5: Unneeded semicolon
arch/mips/kvm/vz.c:1195:3-4: Unneeded semicolon
arch/mips/kvm/vz.c:1949:3-4: Unneeded semicolon
arch/mips/kvm/vz.c:1121:2-3: Unneeded semicolon
arch/mips/kvm/vz.c:2188:3-4: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 arch/mips/kvm/vz.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index dde2088..389dd0f 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -1118,7 +1118,7 @@ static enum emulation_result kvm_vz_gpsi_cache(union mips_instruction inst,
 		break;
 	default:
 		break;
-	};
+	}
 
 	kvm_err("@ %#lx/%#lx CACHE (cache: %#x, op: %#x, base[%d]: %#lx, offset: %#x\n",
 		curr_pc, vcpu->arch.gprs[31], cache, op, base, arch->gprs[base],
@@ -1183,7 +1183,7 @@ static enum emulation_result kvm_trap_vz_handle_gpsi(u32 cause, u32 *opc,
 				trace_kvm_hwr(vcpu, KVM_TRACE_RDHWR,
 					      KVM_TRACE_HWR(rd, sel), 0);
 				goto unknown;
-			};
+			}
 
 			trace_kvm_hwr(vcpu, KVM_TRACE_RDHWR,
 				      KVM_TRACE_HWR(rd, sel), arch->gprs[rt]);
@@ -1192,7 +1192,7 @@ static enum emulation_result kvm_trap_vz_handle_gpsi(u32 cause, u32 *opc,
 			break;
 		default:
 			goto unknown;
-		};
+		}
 		break;
 unknown:
 
@@ -1946,7 +1946,7 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu *vcpu,
 		default:
 			*v = (long)kvm_read_c0_guest_prid(cop0);
 			break;
-		};
+		}
 		break;
 	case KVM_REG_MIPS_CP0_EBASE:
 		*v = kvm_vz_read_gc0_ebase();
@@ -2185,7 +2185,7 @@ static int kvm_vz_set_one_reg(struct kvm_vcpu *vcpu,
 		default:
 			kvm_write_c0_guest_prid(cop0, v);
 			break;
-		};
+		}
 		break;
 	case KVM_REG_MIPS_CP0_EBASE:
 		kvm_vz_write_gc0_ebase(v);
-- 
2.6.2

