Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1FDB73609D
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 02:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjFTAko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 20:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjFTAkn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 20:40:43 -0400
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC8EE78;
        Mon, 19 Jun 2023 17:40:41 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VlZOfiK_1687221637;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VlZOfiK_1687221637)
          by smtp.aliyun-inc.com;
          Tue, 20 Jun 2023 08:40:38 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     anup@brainfault.org
Cc:     atishp@atishpatra.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] RISC-V: KVM: Remove unneeded semicolon
Date:   Tue, 20 Jun 2023 08:40:36 +0800
Message-Id: <20230620004036.4868-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,URIBL_BLOCKED,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

./arch/riscv/kvm/aia_imsic.c:94:2-3: Unneeded semicolon
./arch/riscv/kvm/aia_imsic.c:134:2-3: Unneeded semicolon
./arch/riscv/kvm/aia_imsic.c:173:2-3: Unneeded semicolon
./arch/riscv/kvm/aia_imsic.c:210:2-3: Unneeded semicolon
./arch/riscv/kvm/aia_imsic.c:296:2-3: Unneeded semicolon
./arch/riscv/kvm/aia_imsic.c:354:2-3: Unneeded semicolon
./arch/riscv/kvm/aia_device.c:105:4-5: Unneeded semicolon
./arch/riscv/kvm/aia_device.c:166:2-3: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5569
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 arch/riscv/kvm/aia_device.c |  4 ++--
 arch/riscv/kvm/aia_imsic.c  | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
index 84dae351b6d7..0eb689351b7d 100644
--- a/arch/riscv/kvm/aia_device.c
+++ b/arch/riscv/kvm/aia_device.c
@@ -102,7 +102,7 @@ static int aia_config(struct kvm *kvm, unsigned long type,
 				break;
 			default:
 				return -EINVAL;
-			};
+			}
 			aia->mode = *nr;
 		} else
 			*nr = aia->mode;
@@ -163,7 +163,7 @@ static int aia_config(struct kvm *kvm, unsigned long type,
 		break;
 	default:
 		return -ENXIO;
-	};
+	}
 
 	return 0;
 }
diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 8f108cfa80e5..fd4965c6f591 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -91,7 +91,7 @@ static unsigned long imsic_eix_read(int ireg)
 	switch (ireg) {
 	imsic_read_switchcase_64(IMSIC_EIP0)
 	imsic_read_switchcase_64(IMSIC_EIE0)
-	};
+	}
 
 	return 0;
 }
@@ -131,7 +131,7 @@ static unsigned long imsic_eix_swap(int ireg, unsigned long val)
 	switch (ireg) {
 	imsic_swap_switchcase_64(IMSIC_EIP0, val)
 	imsic_swap_switchcase_64(IMSIC_EIE0, val)
-	};
+	}
 
 	return 0;
 }
@@ -170,7 +170,7 @@ static void imsic_eix_write(int ireg, unsigned long val)
 	switch (ireg) {
 	imsic_write_switchcase_64(IMSIC_EIP0, val)
 	imsic_write_switchcase_64(IMSIC_EIE0, val)
-	};
+	}
 }
 
 #define imsic_vs_csr_set(__c, __v)		\
@@ -207,7 +207,7 @@ static void imsic_eix_set(int ireg, unsigned long val)
 	switch (ireg) {
 	imsic_set_switchcase_64(IMSIC_EIP0, val)
 	imsic_set_switchcase_64(IMSIC_EIE0, val)
-	};
+	}
 }
 
 static unsigned long imsic_mrif_atomic_rmw(struct imsic_mrif *mrif,
@@ -293,7 +293,7 @@ static int imsic_mrif_isel_check(u32 nr_eix, unsigned long isel)
 		break;
 	default:
 		return -ENOENT;
-	};
+	}
 #ifndef CONFIG_32BIT
 	if (num & 0x1)
 		return -EINVAL;
@@ -351,7 +351,7 @@ static int imsic_mrif_rmw(struct imsic_mrif *mrif, u32 nr_eix,
 		break;
 	default:
 		return -ENOENT;
-	};
+	}
 
 	if (val)
 		*val = old_val;
-- 
2.20.1.7.g153144c

