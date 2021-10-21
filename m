Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917CB4360E1
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 13:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhJUL7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 07:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbhJUL7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 07:59:48 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AA3C06161C;
        Thu, 21 Oct 2021 04:57:32 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id h193so89919pgc.1;
        Thu, 21 Oct 2021 04:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=idIj9x5Y1snEOdYM83+I6n7R4t6XnyFXPq7fZJooAt0=;
        b=QvnqmUW3vkYQDIvz4c0DkDquBfz0UXqjZUC0PwY4U8mXRpvcJ+SrK+3ui+5qMXR5nS
         T88lojXXUAUuEtM2XKgqmwuKaPsSjqDf/OxyM+NZgN9M2pa9d8LlQ4qe6KlA1PB2oWTU
         gEMfvIdPYfSzcBLsrxntIAPlht7kvi1XxsXuy6ks/zvRjrdk+BHTtE9uC7zhq6PCRgia
         Y77EkhCkAPPCN1ptuF6l+zorCgwqHKs5KV6FLRDTvufFCWTt0EaGxf21EzB+fuAB70Jx
         t+hHzP5Qd1TjFeRtbQBEPMHBikZemHsfLoL787dBzW4sWlwEhBJowuzcLmXcPu9qeaWo
         +uXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=idIj9x5Y1snEOdYM83+I6n7R4t6XnyFXPq7fZJooAt0=;
        b=ut/NSaQ0bhz2vzVRbhX3ZVs1C4qgX5dilPfNPmuWkrO3jpCpdOQ7CU/6tel9PzgyBj
         Syd2Z9aBxB5hW6FNd3RI57echUHKgh1v5TULjl0PSvq9vThSKM/YV3xyIrd0P5sd3rwr
         8eepTJVSkRpuSG6DYLQ/LDiIOR+XgH0ZZf7d5CSlEUrHybTl5UGS1+y+/Q2K7tCfpMHI
         65+N3GcUgDHmIHYuHuvOL11L4gzHNR/BHmVIffNBxUE3MXg/vWeLodw62PuQiEnlP/JV
         39pBisxiavaOYSvZ0iqY7RIztOl/8guwO5Y/6OpfTWtOmmy7BP+Z+TXv/70ErufjuQBm
         MkpA==
X-Gm-Message-State: AOAM533+wjrPb48xOB6dttp1R//0PExVFS8a8PcShYmdK5xvInSChQ5C
        2MmyzVceNeT9YPMQL/gvoDY=
X-Google-Smtp-Source: ABdhPJwu17uilS+pRVvSk89iNu6lAdgJwU8YwJMCdjTqkpEZIwNjHy9NHuJ4Lw3z8EjgYKkXVJnT1A==
X-Received: by 2002:a63:7406:: with SMTP id p6mr4044865pgc.246.1634817451815;
        Thu, 21 Oct 2021 04:57:31 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id t3sm5082314pgo.51.2021.10.21.04.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 04:57:31 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: ran.jianping@zte.com.cn
To:     anup@brainfault.org
Cc:     anup.patel@wdc.com, aou@eecs.berkeley.edu, atish.patra@wdc.com,
        cgel.zte@gmail.com, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        paul.walmsley@sifive.com, ran.jianping@zte.com.cn,
        zealci@zte.com.cn
Subject: [PATCH] RISC-V:KVM: remove unneeded semicolon
Date:   Thu, 21 Oct 2021 11:57:06 +0000
Message-Id: <20211021115706.1060778-1-ran.jianping@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAAhSdy3DWOux6HiDU6fPazZUq=FOor8_ZEoqh6FBZru07NyxLQ@mail.gmail.com>
References: <CAAhSdy3DWOux6HiDU6fPazZUq=FOor8_ZEoqh6FBZru07NyxLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: ran jianping <ran.jianping@zte.com.cn>

 Elimate the following coccinelle check warning:
 ./arch/riscv/kvm/vcpu_sbi.c:169:2-3: Unneeded semicolon
 ./arch/riscv/kvm/vcpu_exit.c:397:2-3: Unneeded semicolon
 ./arch/riscv/kvm/vcpu_exit.c:687:2-3: Unneeded semicolon
 ./arch/riscv/kvm/vcpu_exit.c:645:2-3: Unneeded semicolon
 ./arch/riscv/kvm/vcpu.c:247:2-3: Unneeded semicolon
 ./arch/riscv/kvm/vcpu.c:284:2-3: Unneeded semicolon
 ./arch/riscv/kvm/vcpu_timer.c:123:2-3: Unneeded semicolon
 ./arch/riscv/kvm/vcpu_timer.c:170:2-3: Unneeded semicolon

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ran jianping <ran.jianping@zte.com.cn>
---
 arch/riscv/kvm/vcpu.c       | 4 ++--
 arch/riscv/kvm/vcpu_exit.c  | 6 +++---
 arch/riscv/kvm/vcpu_sbi.c   | 2 +-
 arch/riscv/kvm/vcpu_timer.c | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index c44cabce7dd8..912928586df9 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -244,7 +244,7 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
@@ -281,7 +281,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	return 0;
 }
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 13bbc3f73713..7f2d742ae4c6 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -394,7 +394,7 @@ static int emulate_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		break;
 	default:
 		return -EOPNOTSUPP;
-	};
+	}
 
 	/* Update MMIO details in kvm_run struct */
 	run->mmio.is_write = true;
@@ -642,7 +642,7 @@ int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		break;
 	default:
 		return -EOPNOTSUPP;
-	};
+	}
 
 done:
 	/* Move to next instruction */
@@ -684,7 +684,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		break;
 	default:
 		break;
-	};
+	}
 
 	/* Print details in-case of error */
 	if (ret < 0) {
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index ebdcdbade9c6..eb3c045edf11 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -166,7 +166,7 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		/* Return error for unsupported SBI calls */
 		cp->a0 = SBI_ERR_NOT_SUPPORTED;
 		break;
-	};
+	}
 
 	if (next_sepc)
 		cp->sepc += 4;
diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
index ddd0ce727b83..5c4c37ff2d48 100644
--- a/arch/riscv/kvm/vcpu_timer.c
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -120,7 +120,7 @@ int kvm_riscv_vcpu_get_reg_timer(struct kvm_vcpu *vcpu,
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
@@ -167,7 +167,7 @@ int kvm_riscv_vcpu_set_reg_timer(struct kvm_vcpu *vcpu,
 	default:
 		ret = -EINVAL;
 		break;
-	};
+	}
 
 	return ret;
 }
-- 
2.25.1

