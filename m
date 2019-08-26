Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8958C9C957
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbfHZGWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:22:10 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36321 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729772AbfHZGWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:22:09 -0400
Received: by mail-pl1-f196.google.com with SMTP id f19so9495511plr.3;
        Sun, 25 Aug 2019 23:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vf3DbEEeWbjvdoN8kao0C1T72opz9cyDNBLzkRA60l4=;
        b=IY5dgVqJYTuOlLzI8B8vwu2RBc3absTDkYix7yfDw0kUpj0ZxXpYy1JShkoUlogPGx
         B6p9+XBKM5ooy5sKw3AJgpv7RHzHFBRc3bdhSBx8enR6MQ/l4d6LCOhLGEYTotpJMeSg
         ylf/1HWy7NRrYT3hqGSVPBwC9hWD6OGKoN4ERzwuswSwV9gv9knAKuofqFpR5yYuawBj
         0iI0JKxZDik7c7Hoq5ADVJ6zac3RUsUwO+CsoDodCURFRjbjM1QgjJRewaqYHwxnn3UE
         /TgVYmecDvwpCYeWg8g2FtfxrPpsGhf8TaCgZTxcGMxkGLV0Ws+3sc9lLtzMSy33QFpQ
         LCfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vf3DbEEeWbjvdoN8kao0C1T72opz9cyDNBLzkRA60l4=;
        b=IEpQT1L69UqdmE5TJg17NAj+DDHMner37hZr5dWaTEeoqkT5btlfwhCfbw9e9d5tLq
         iywV9CgjosZd5MhqVPoNkyKU7Ir5woSbE+PfHHm9MJQ0kPiVk2AAg10T6TgGzVXqqLbJ
         eQ77ElOAz2Zocsb+6UpF5DPebo2yg07J8UFm+5xnfDdqTjmXXLb5Ori3geAZvcA1Rv3B
         pG6VALSgR2KQCbzMYMSFbfebyJkvBJ6nrggapd3xwH/FQe8aWjXiU5n4XPs4IliW5fS9
         o6ly7UMO+tUDuy17zCwPnSH5wv6AI0o29B08uPCvqg/BLVrBs/LRHlIl1+7i9ayuOFN0
         4QmQ==
X-Gm-Message-State: APjAAAVyGbHFpUISyXSnTItFlABDO85IpNF1Gc9R0tceO0jfZtLynirs
        Mk61Eyfx3sWlsayyLVseW9SBiJIkMmI=
X-Google-Smtp-Source: APXvYqz9Cn97EPgzYGrhW0r0itVEkv1xXSb77ANzSbZ1lezxqSPmUtt/4OXYXIJhUPKJ0+v0WDNM9g==
X-Received: by 2002:a17:902:ff05:: with SMTP id f5mr16826040plj.116.1566800529146;
        Sun, 25 Aug 2019 23:22:09 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.22.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:22:08 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 22/23] KVM: PPC: Book3S HV: Nested: Enable nested hpt guests
Date:   Mon, 26 Aug 2019 16:21:08 +1000
Message-Id: <20190826062109.7573-23-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow nested hpt (hash page table) guests to be run.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 90788a52b298..bc7b411793be 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -330,7 +330,6 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 					       (l2_hv.lpcr & LPCR_VPM1))
 			return H_PARAMETER;
 	} else {
-		return H_PARAMETER;
 		/* must be at least V2 to support hpt guest */
 		if (l2_hv.version < 2)
 			return H_PARAMETER;
-- 
2.13.6

