Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B901CF279
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 12:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbgELKc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 06:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728371AbgELKc2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 06:32:28 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF65C061A0C;
        Tue, 12 May 2020 03:32:28 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id e6so9165534pjt.4;
        Tue, 12 May 2020 03:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p7gcKiXZHRnvuvHPL32ueIkTT7PTkn2ALsQ2li3G5xk=;
        b=Sgi/sA+FHpEkidsgAV9yhiGk3DAU9N/d3hNeii4hSdI5wrsZCoKs6/nDhiTBi1LPVf
         kHKIM96TkFG+6XXdg/W8yTMwy1uRVyaIov31YDfLlEJLamVZCHVoxRvkx/6Qph70YDma
         SW7SHMdsf5GgIlCLvc3eNcBzUdgCac65r7u+oRUCR5LotMINFyZuYteff1UVrjGT8Hqb
         dh7VTXTsYNp79UoamO2jmTFxNl/GUDoBoeHnJ79v+yPiljYHZO6KLSUd/ySLlP2Q4AFq
         7Xd3uu9AuimryTHFxq7+hIqOtqSKpAV4m3UkPWMFlsLDl40WX+s4WNSEJ5/mj+Dt6N3z
         Djgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=p7gcKiXZHRnvuvHPL32ueIkTT7PTkn2ALsQ2li3G5xk=;
        b=ZJLu7xh/mcBILdmwhRng4MrDFDEx78Gmh9k1qP0Y4w8jsxl3g8fcIT5L7/llt2BNFv
         aRMZPDfPLHHVtoNLNXKqKkCVyk+GmpzbGcdT+jF3y/wk3MOPP7WzcC2vGnHheM2LX3Jo
         svS5DugBC4sI0Qx1mtlpvKFcyyUilOu4ZVtw72WsytweZ1y6ndpBfFB8pVYIqVWcvvxI
         BhbMgouOCx8hnsz/WaXjQA9w9y8Ko3izotFmyIIkeFKwxGlkm3v7RBM6m2rEJoMuBvYN
         3eRiN0vZHNwOAZ9KQtvpErakgUrGbAcMK1BaU80jurHGCpJTmnY2jn7mlfMeXRvuVIgh
         BFtQ==
X-Gm-Message-State: AGi0PubXxebKbkC7eIAOv2A1mIv7vdIYwFWWHvEmLEbvqp551SIilwM9
        5htin61xDeknHepMA6NIQdw=
X-Google-Smtp-Source: APiQypKXzEwQaOBW2m4XhF+efQG2Xk7kvpRSGkq1A/HFxmDKLW1x6xPDx9Ax1NIeBFpUQg2P7TFfpw==
X-Received: by 2002:a17:902:8a81:: with SMTP id p1mr19456967plo.104.1589279547669;
        Tue, 12 May 2020 03:32:27 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id q11sm11617094pfl.97.2020.05.12.03.32.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 May 2020 03:32:27 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V4 03/14] KVM: MIPS: Increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16
Date:   Tue, 12 May 2020 18:31:09 +0800
Message-Id: <1589279480-27722-4-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
References: <1589279480-27722-1-git-send-email-chenhc@lemote.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson-3 based machines can have as many as 16 CPUs, and so does
memory slots, so increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16.

Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/kvm_host.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index caa2b936..a7758c0 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -78,8 +78,8 @@
 #define KVM_REG_MIPS_CP0_KSCRATCH6	MIPS_CP0_64(31, 7)
 
 
-#define KVM_MAX_VCPUS		8
-#define KVM_USER_MEM_SLOTS	8
+#define KVM_MAX_VCPUS		16
+#define KVM_USER_MEM_SLOTS	16
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS	0
 
-- 
2.7.0

