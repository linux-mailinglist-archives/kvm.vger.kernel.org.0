Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFC2659412
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 02:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbiL3BhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 20:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbiL3Bg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 20:36:57 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D6716490
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 17:36:56 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id l15-20020a170903244f00b001927c3a0055so8120634pls.6
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 17:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K693M+RJONwJVc6/926ikzKQZnNuLaPR/xF052DwOT4=;
        b=kc2DyXWGf/HZakft0TEaOOUlqL94MGjmuvu3SSuVOspxKUU3yBcvHDgGd9u1cmg9VG
         dYIqdiMFNMtn45evyHzRwSdCpm7Q4RlaADc43y8yDn+NDvrPhDiTaEeJRtrI0/iH6kZA
         06ojrjKfTENtPcetE+771PXgDxKVNdT+2n6RqNjvSYB+rb8K0UWMidugV/j0NOk2T9QT
         +cM+qUhBXnY6J46vvjAs7JNLwsdFfiPgq1D3kwRQXttxxPS7nos+AETNKE1qtX3SsAle
         SMhxt3gCX918hbtNlqyTOlyJnR+R204GtCFwq8gadS/RP1YspYX6NU0DHFkuhlKhrgHr
         SqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K693M+RJONwJVc6/926ikzKQZnNuLaPR/xF052DwOT4=;
        b=MF1O3X2p2nSBdA4YqBa4WHH8TUQzPhvrunwM/LfgEJbFheFudtFuR9LGmGKaaEvdgk
         /IXBrxCMsA+WA5nuNTvJA64gSMSAZXSAf5HxSIimdw8aeMmnnRoTT78OsZMxkSh7iI6U
         sNxL4APOXX+eQC8mtTVFRZGEJi3Yv32FhIOF0pClb9wi+gJe0uAPMVkTDoFMGkgCPLRP
         S40sYXQ++sJHydb3r0i5lY2YOxzij2D8bBYXYqC1vCV4jyaPfwHUrn0Vh+bCLsUlo7RC
         9JfcnaNNxi2XrcboCbrXHwa9cTflf8q+M1nJ9TAOxbH3Ga/DfrYiG2T78okJg4nY0jtT
         J/jA==
X-Gm-Message-State: AFqh2krmWOK5Fyj+2Pvx378x0QxacSlgrvHCII3/ejQQxu32qS4Z0+5/
        1mw6uIg2+npOnIWq/Y6bs4djWOi+pbkgvflJrQXbkT/oihhkX0NfeNNxqyi0t7a89NkGXzsA2Vx
        B1rFwVvP0x74OcoXDglKuoJ9dfYsIeRvc7ZoQRkzFCFsj1NHuLh1J7aZYyo4V17BInMTp
X-Google-Smtp-Source: AMrXdXshoWXP+Nr8T94ckUdDn9Pueqkb1qKwShrQjIknX5+l9GKzZl8QCwzKoAkX/y0IctirxkAsBUwW16UX2zQr
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:4d83:b0:220:1f03:129b with SMTP
 id oj3-20020a17090b4d8300b002201f03129bmr176602pjb.0.1672364215620; Thu, 29
 Dec 2022 17:36:55 -0800 (PST)
Date:   Fri, 30 Dec 2022 01:36:48 +0000
In-Reply-To: <20221230013648.2850519-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221230013648.2850519-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230013648.2850519-3-aaronlewis@google.com>
Subject: [PATCH v2 2/2] KVM: selftests: Assert that XSAVE supports both XTILE{CFG,DATA}
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The check in amx_test that ensures that XSAVE supports XTILE makes sure
at least one of the XTILE bits are set, XTILECFG or XTILEDATA, when it
really should be checking that both are set.

Assert that both XTILECFG and XTILEDATA a set.

Fixes: bf70636d9443 ("selftest: kvm: Add amx selftest")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 2f555f5c93e99..db1b38ca7c840 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -121,7 +121,7 @@ static inline void check_cpuid_xsave(void)
 
 static inline void check_xsave_supports_xtile(void)
 {
-	GUEST_ASSERT(__xgetbv(0) & XFEATURE_MASK_XTILE);
+	GUEST_ASSERT((__xgetbv(0) & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE);
 }
 
 static void check_xtile_info(void)
-- 
2.39.0.314.g84b9a713c41-goog

