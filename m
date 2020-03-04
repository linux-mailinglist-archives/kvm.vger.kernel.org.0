Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9CD6178EB5
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 11:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387860AbgCDKms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 05:42:48 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:37919 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387396AbgCDKms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 05:42:48 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 320b1e17;
        Wed, 4 Mar 2020 10:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=woDMe5KTrxlQuzyXF8mQxtdX4Mo=; b=0xbXKYD5rqE3JWWxTtse
        Bv4B/YLWwA7hDha5wuHTUmcnS3M9aBoyrna1pQQvJtebgO0bOaVldaJal1KYvxgD
        WrpwNR5+MB/tBJQeY6tW1xwvrAH3nF4IiPg+pEoRBz/LG170DRwfB3+lrIPHieH9
        aCJd7Ng9p+504S8yoHC1Fv7SFPbE7EslRkRB4KFI1wi2CYsO+njwCvXSiobO1/Vh
        OxARR7tFSa/GHUPWkFKYcjiXiezSxjEZmC4jFlbkbG1UK5rfyD5t7UDEmTHuv7Yt
        Ep1IawimLNuGwem1LjHk7xDKwAxOZEMQdgAjo1qY55zR3rFWOnw7E2wo7c5m/bJt
        zw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0033f560 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Wed, 4 Mar 2020 10:38:13 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] KVM: fix Kconfig menu text for -Werror
Date:   Wed,  4 Mar 2020 18:42:21 +0800
Message-Id: <20200304104221.2977-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This was evidently copy and pasted from the i915 driver, but the text
wasn't updated.

Fixes: 4f337faf1c55 ("KVM: allow disabling -Werror")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/x86/kvm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 1bb4927030af..29bd4dc3363e 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -68,7 +68,7 @@ config KVM_WERROR
 	depends on (X86_64 && !KASAN) || !COMPILE_TEST
 	depends on EXPERT
 	help
-	  Add -Werror to the build flags for (and only for) i915.ko.
+	  Add -Werror to the build flags for kvm.ko.
 
 	  If in doubt, say "N".
 
-- 
2.25.1

