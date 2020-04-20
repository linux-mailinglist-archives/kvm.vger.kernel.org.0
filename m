Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89CB1B14C0
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 20:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgDTSgu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 14:36:50 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:37433 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728172AbgDTSgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 14:36:41 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 495b5348S3z9v1wG;
        Mon, 20 Apr 2020 20:36:39 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=L8rOOqcK; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id gxDbs_nGq2rw; Mon, 20 Apr 2020 20:36:39 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 495b5330mBz9v1wB;
        Mon, 20 Apr 2020 20:36:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1587407799; bh=Z+DTGzvTxqsqWxp7dVXacfp4jVlr8OqLRFto6Y4sZ9Y=;
        h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
        b=L8rOOqcKaI8PRNtGUjmExVCXN2aNm7M4ITgfNvfHi0vm9iF2SxG5McgWPHCMxgUbd
         w/JDEn0iV9AaIW7Vzc24QlW0oeJaxOLqj46CJOvh0FF6TnMgOHUKbZsqSl/TrIc7UF
         SHD9VypxTA063u8DemWf1+5fC8tvjnIJQpKRC/iU=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 55A558B78A;
        Mon, 20 Apr 2020 20:36:39 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id rAhfwyKCRVLE; Mon, 20 Apr 2020 20:36:39 +0200 (CEST)
Received: from pc16570vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 0A2B98B77E;
        Mon, 20 Apr 2020 20:36:39 +0200 (CEST)
Received: by pc16570vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id D48DB657AE; Mon, 20 Apr 2020 18:36:38 +0000 (UTC)
Message-Id: <bb0a6081f7b95ee64ca20f92483e5b9661cbacb2.1587407777.git.christophe.leroy@c-s.fr>
In-Reply-To: <a5945463f86c984151962a475a3ee56a2893e85d.1587407777.git.christophe.leroy@c-s.fr>
References: <a5945463f86c984151962a475a3ee56a2893e85d.1587407777.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 5/5] powerpc: Remove _ALIGN_UP(), _ALIGN_DOWN() and _ALIGN()
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org
Date:   Mon, 20 Apr 2020 18:36:38 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These three powerpc macros have been replaced by
equivalent generic macros and are not used anymore.

Remove them.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 arch/powerpc/include/asm/page.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index 3ee8df0f66e0..a63fe6f3a0ff 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -249,13 +249,6 @@ static inline bool pfn_valid(unsigned long pfn)
 #include <asm/page_32.h>
 #endif
 
-/* align addr on a size boundary - adjust address up/down if needed */
-#define _ALIGN_UP(addr, size)   __ALIGN_KERNEL(addr, size)
-#define _ALIGN_DOWN(addr, size)	((addr)&(~((typeof(addr))(size)-1)))
-
-/* align addr on a size boundary - adjust address up if needed */
-#define _ALIGN(addr,size)     _ALIGN_UP(addr,size)
-
 /*
  * Don't compare things with KERNELBASE or PAGE_OFFSET to test for
  * "kernelness", use is_kernel_addr() - it should do what you want.
-- 
2.25.0

