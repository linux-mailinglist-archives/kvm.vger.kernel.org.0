Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8510B17A709
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 15:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgCEOBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 09:01:44 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50692 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgCEOBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 09:01:44 -0500
Received: by mail-wm1-f67.google.com with SMTP id a5so6448165wmb.0;
        Thu, 05 Mar 2020 06:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g1gCW4wuMkAhJVczZU/0rxkNbCY/76UCAy/6zzDIpdQ=;
        b=oceuHmUMgk/rn3OAkyGgGVHh9NLeWrzgCnudqNZYR/kuLZ69dBuMtFkjeoPvlUC+S5
         oKrHbcvWqi5RgvJwhk5KAAbCcNgxQMHXowfPYVSxBwgGPIXbxylgZz1AytLXlCLw2ULa
         a8vPb6zGKQkH+exw8Yrs5rgGfdQuMSaJ7yE/HqELIH68qmP81uXv1yNmFECTpB12WuEY
         QIi7XSHhGfqfxPm2cyVs+NYANSf+z8ZoXPLffD0GpEFvCTxQJOgS6xvY7oLrzB/YPVC4
         K/YaI1qNREm8TxSMmrd9Tg1EtPCBbAPQuI9Ynoc0bf+PSlXjfHi6Gw2PoAnsLYxKIwZ+
         umIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g1gCW4wuMkAhJVczZU/0rxkNbCY/76UCAy/6zzDIpdQ=;
        b=sKRIO8WLjOPp/+N8VXVZ4x2XJ76nenNZOarQTB1+LF1Wzf/3P/Mgd6TEJEBkwjHeEs
         ygcKLJx8FKs/aDm0CFUmA7iDsOkzgXlb90OWUjyxf5JiWFHF9Ad1Vn+xoCex4UgWBgWS
         P/O6YK4vGnP6ow9Uy+aRXRcz0E+st+BH3Ag5J0Gl1NXb4XQHDzRxuQJI0Yw0p0r7+8lJ
         oZudgLVoEYwOXZ6T74xWgXq0gPzqOMvBgOnMTYw0syNn635UR93LYjfCciBUz2UrXjlG
         wP+e1vpU/29atf5xk7glqFhJhMWZofUWfIhZrGzGHMMAMV4anVMImmTjU/SkyNa6WnWD
         4ilw==
X-Gm-Message-State: ANhLgQ28usegjv75rHwR1ElDD631JQaX5Uj7gVSNzgN4YN33CtRQ6Ept
        NISDEerpyyjEniOJF7oJYp8rZcpU
X-Google-Smtp-Source: ADFU+vueCuoNuCRsOedGO1DKRNivBHPo2mT33aerbdX/BUEyPycLeTyHsse+Ct7KKHcDxcrvVDNSDQ==
X-Received: by 2002:a1c:25c5:: with SMTP id l188mr10314844wml.105.1583416899650;
        Thu, 05 Mar 2020 06:01:39 -0800 (PST)
Received: from linux.local ([31.154.166.148])
        by smtp.gmail.com with ESMTPSA id c72sm3379824wme.35.2020.03.05.06.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 06:01:39 -0800 (PST)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v2 1/4] x86/kvm/hyper-v: Align the hcall param for kvm_hyperv_exit
Date:   Thu,  5 Mar 2020 16:01:39 +0200
Message-Id: <20200305140142.413220-2-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305140142.413220-1-arilou@gmail.com>
References: <20200305140142.413220-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Jon Doron <arilou@gmail.com>
---
 include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b95f9a31a2f..9b4d449f4d20 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -200,6 +200,7 @@ struct kvm_hyperv_exit {
 			__u64 input;
 			__u64 result;
 			__u64 params[2];
+			__u32 pad;
 		} hcall;
 	} u;
 };
-- 
2.24.1

