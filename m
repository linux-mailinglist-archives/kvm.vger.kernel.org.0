Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F352435F95
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 12:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhJUKsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 06:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbhJUKsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 06:48:03 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C68C061749;
        Thu, 21 Oct 2021 03:45:47 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t11so92663plq.11;
        Thu, 21 Oct 2021 03:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AD2dgM0zOn+M+g2RGuvovb9BPcvRHY33KeWc/UhpNGw=;
        b=Snj3fnFkDCt/kE5qCbarCVOnGdbw8px3rbLWF5GhXJ+Cjza+RNMQKVP5qdVC9BkfKM
         BzgD3ew1SREru87oLgmeH7xzYSfg0CaPSDX1820dqKMSGJaz38ZDHJVoYT0Awwnckn23
         EbfNdYChCd1lp1TELLyMLfkPl+T+gOKGpwfo+al9SFE9hmNdawJZPkf+/jCEpitKQtut
         R9V9xPkzxkkdP4fDfZpA6yUlbtDeJ75wV4gf1rqMIrssVI0lnsBM/oPtVyHwG1nh0AsB
         gP/u+hNuf+FzmxS4KSfOeR6nbBdHq7zNlu91Xx34+Qbe2w1qssUw+xG85ZAcYiNwLFEB
         1BsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AD2dgM0zOn+M+g2RGuvovb9BPcvRHY33KeWc/UhpNGw=;
        b=Q3UvCvpqbLm1GwEJe2BQydBU3qw9tvXSpl5SV4ulZxO4stVKfiowGCMCQvtHvk8hMd
         CK2z5LPCOnOE2lzp0RurjyAa9oN/wisraPhDhXQaQ8pES9+fRAjBk1xj4s4XC9LwfnrZ
         3fyOxEnkLdk9ia9ZztoxTBdnk4CCZuiR8iyTo2LpVbd4n5J1FseNkOiU1MB8zy7ZwP4T
         uVevXdpWa/nxB3WiWjc/CpdMCci7V5p3unvja45/q3pMyIwX366Qa50PawP2ndCXpGnG
         FTncT87U9zaoz7afhF+mffWmCuOC4Z6u+4nKY24XMTV3QX5cBdcU1A/N0+fWejwlhTq/
         YU2g==
X-Gm-Message-State: AOAM530XiUmN1c2GTTFExetdYTEKWEizWNNa0NY/E//DMiWNwVDHQJbT
        4wO+447K8BVzusEHP57ZODc=
X-Google-Smtp-Source: ABdhPJzdNFVZFI9FIDisl3iWCkpstFXbPSPKvMlVXZy6TSnE0XsAMgeyH85X1nHC6O2Q51WGZFqDbw==
X-Received: by 2002:a17:90a:ac14:: with SMTP id o20mr5702524pjq.219.1634813147081;
        Thu, 21 Oct 2021 03:45:47 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id x20sm5355438pjp.48.2021.10.21.03.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 03:45:46 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: ran.jianping@zte.com.cn
To:     anup.patel@wdc.com
Cc:     atish.patra@wdc.com, paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        ran jianping <ran.jianping@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] RISC-V:KVM: remove unneeded semicolon Elimate the following coccinelle check warning: ./arch/riscv/kvm/vcpu_sbi.c:169:2-3: Unneeded semicolon ./arch/riscv/kvm/vcpu_exit.c:397:2-3: Unneeded semicolon ./arch/riscv/kvm/vcpu_exit.c:687:2-3: Unneeded semicolon ./arch/riscv/kvm/vcpu_exit.c:645:2-3: Unneeded semicolon ./arch/riscv/kvm/vcpu.c:247:2-3: Unneeded semicolon ./arch/riscv/kvm/vcpu.c:284:2-3: Unneeded semicolon ./arch/riscv/kvm/vcpu_timer.c:123:2-3: Unneeded semicolon ./arch/riscv/kvm/vcpu_timer.c:170:2-3: Unneeded semicolon
Date:   Thu, 21 Oct 2021 10:45:36 +0000
Message-Id: <20211021104536.1060107-1-ran.jianping@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: ran jianping <ran.jianping@zte.com.cn>

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

