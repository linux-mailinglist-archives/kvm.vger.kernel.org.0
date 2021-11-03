Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CF7443D62
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 07:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhKCGrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 02:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhKCGrk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 02:47:40 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EE1C061714;
        Tue,  2 Nov 2021 23:45:04 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id om14so613784pjb.5;
        Tue, 02 Nov 2021 23:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mi8r83pUTBrcQ3MNCYSGeibYSRXnJ8qCuYpYc7RJ1PM=;
        b=ZsNvY/1QZJqQwmSQD0ybdPyn4eJsxCZ886ZuEMim6DMxXNegPsZxY6Mmq4/5K/j0sa
         7LnF4lcNyDBe3XmSDd+30N3idJn7j7+z/lGNM116lkLxv6RQbn6PyFnxYdLT0uF9K2j/
         m554MJiuBAjQB5HoPtuBw7Q8XFTyt37bFkMoNa6ujxQxo4uLbtYfDTRGZmdsILGmOLXT
         mxSbbkzDiSPtM80rdR/2krFfIFTQ0NSCBJ5qgUyNQyeacGz259zne9E767hBwXK1RySr
         7Q2q9NGYSCDAQwkVL6yNC1LGn0nv0HmENdu69QlCdBm7fC9sFsWFIHvp8tbEcyfxrzlx
         xRwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mi8r83pUTBrcQ3MNCYSGeibYSRXnJ8qCuYpYc7RJ1PM=;
        b=Qifd1BiaGGEeQM2OvSR4GcRJet3lWv8sMzQqr6XVMbaSdtJRPdsLMBrG3OF3lRLAE4
         DvJ5eQpLxGkmdwEIvFkPXgmtE8K/2sXWVxS0MPRkapQQLr8YdrzlkbymxCS8ah8F9IFD
         4IS5WVwQFfh8e21n1s+WgrOrescHKUEH7IJfYzHlrTzr1Nyk90tEF2piEGowjn4tdCtH
         RxrEfGRcpN21T07TjVpBsapGtEg6ER0A1VhVtWW2obc6FpSodoBASWaYKjkqhC7s5RPN
         jd2OImZo60IPqsYOXgKkBM6f6ZjiC71j1n6bwRRGC2wLzKSWcY1wcF9t+2nVfPBSSA/Z
         rinQ==
X-Gm-Message-State: AOAM5320e7DEopHoig+gDeRUo+W2YnuDux9CBH6/1b2SGQ5QJHSyWMEj
        5ddxOThuDRPYEiEIkvnL8e0=
X-Google-Smtp-Source: ABdhPJwyrnGs7LULTukmToIpcaU8jGvQcHTFD9U/AKD/YWHxNv+Au45UjpJy+CtAzY6Bamn4smnLBg==
X-Received: by 2002:a17:902:c206:b0:142:631:5ffc with SMTP id 6-20020a170902c20600b0014206315ffcmr10004182pll.38.1635921903857;
        Tue, 02 Nov 2021 23:45:03 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id q32sm898389pja.4.2021.11.02.23.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 23:45:03 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: zhang.mingyu@zte.com.cn
To:     anup.patel@wdc.com
Cc:     atish.patra@wdc.com, paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Zhang Mingyu <zhang.mingyu@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] RISC-V: KVM:Remove unneeded semicolon
Date:   Wed,  3 Nov 2021 06:44:58 +0000
Message-Id: <20211103064458.26916-1-zhang.mingyu@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhang Mingyu <zhang.mingyu@zte.com.cn>

Eliminate the following coccinelle check warning:
arch/riscv/kvm/vcpu.c:167:2-3
arch/riscv/kvm/vcpu.c:204:2-3

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Zhang Mingyu <zhang.mingyu@zte.com.cn>
---
 arch/riscv/kvm/vcpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index e92ba3e5db8c..e3d3aed46184 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -164,7 +164,7 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
 		return -EFAULT;
@@ -201,7 +201,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 		break;
 	default:
 		return -EINVAL;
-	};
+	}
 
 	return 0;
 }
-- 
2.25.1

