Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E1A277657
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 18:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgIXQNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 12:13:54 -0400
Received: from mail-m971.mail.163.com ([123.126.97.1]:49992 "EHLO
        mail-m971.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgIXQNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 12:13:54 -0400
X-Greylist: delayed 938 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2020 12:13:53 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=81LJb
        ZgEhFZ0fbUetUrd79c6ZgQwRmAgDqQCza3AI+0=; b=E/ILQ6Z1s5sh072UMuacB
        2A5qcVTTIiQRq+WwOZd2GueAqz18sRYlHBPeqCIx7pMpLwb9lVLfPP2wHMxSLuJm
        7JnGa5NQI8TINwsTJ+xEVsq4J8wlra8lVAroc6jQJU56UE447RzFBzYzzEsVnR7C
        k9zp4QJ8oOV0zIn76BwV5A=
Received: from ubuntu.localdomain (unknown [115.216.108.105])
        by smtp1 (Coremail) with SMTP id GdxpCgAH7h4Kwmxf_6nsCw--.274S4;
        Thu, 24 Sep 2020 23:58:03 +0800 (CST)
From:   Li Qiang <liq3ea@163.com>
To:     pbonzini@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        mtosatti@redhat.com
Cc:     liq3ea@gmail.com, linux-kernel@vger.kernel.org,
        Li Qiang <liq3ea@163.com>
Subject: [PATCH] cpuidle-haltpoll: fix error comments in arch_haltpoll_disable
Date:   Thu, 24 Sep 2020 08:58:00 -0700
Message-Id: <20200924155800.4939-1-liq3ea@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgAH7h4Kwmxf_6nsCw--.274S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xr18ZryDAr4fuw1xCryrXrb_yoWfGFX_XF
        13C398Cry3WrnrAay7Cw4rWF1agwnYqF4Fkas3tFWFy3srtr15Kan2yw1YyrnxZr4vyFZr
        Zw15Cw45Kw4UAjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUqg4DUUUUU==
X-Originating-IP: [115.216.108.105]
X-CM-SenderInfo: 5oltjvrd6rljoofrz/xtbBawupbVet2BDvSgAAsz
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'arch_haltpoll_disable' is used to disable guest halt poll.
Correct the comments.

Fixes: a1c4423b02b21 ("cpuidle-haltpoll: disable host side polling when kvm virtualized")
Signed-off-by: Li Qiang <liq3ea@163.com>
---
 arch/x86/kernel/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 08320b0b2b27..94ebb31cb4ce 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -954,7 +954,7 @@ void arch_haltpoll_disable(unsigned int cpu)
 	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL))
 		return;
 
-	/* Enable guest halt poll disables host halt poll */
+	/* Disable guest halt poll enables host halt poll */
 	smp_call_function_single(cpu, kvm_enable_host_haltpoll, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(arch_haltpoll_disable);
-- 
2.25.1

