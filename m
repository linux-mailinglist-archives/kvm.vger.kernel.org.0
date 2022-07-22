Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9C457EA1B
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 01:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiGVXCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 19:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGVXCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 19:02:03 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1407248C82
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:02:03 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e11-20020a17090301cb00b0016c3375abd3so3301605plh.3
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=QcbuP/zxcogacMUrRB+WPN1LLTGM9pzC81o0jrcvja8=;
        b=SX3ud7yQzu2OSxHI+nd3/fylZ/k4Dzth0Cj+Lfjr76wSSbJu8D6kSlySCaSvGcjlfH
         gROYkquPtfSizAfn5ua61L+TM4XRvwngltTXQ7BFMKWUL6cBvkLrUXxyq5cO4t0zN4tS
         HDcSbFWuwVGOWKBYTZzXaAY5uTrMiOm+o3lGR3vgXgpRyxAVB3IAVgh9aQfyl59JbH9P
         ViA9Ftu1wMgBLaJ7qaBkALaU6noAjAFK/9ro5Iwzj9l/vWXCMp9s4PyhTLGqkTMsjN7C
         ggyA9+e2yq+E+2nlOIBHFR1GnuERvUjUo/YWTWfjOQN58vpRCoX0brIj66qJbcVjZmcf
         3DcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=QcbuP/zxcogacMUrRB+WPN1LLTGM9pzC81o0jrcvja8=;
        b=vho4xZFgXuU1eRSfzMDVMjhTch3J1ywkRlmKerfW9AOiBHeeJJ796Fb5FiCVzp4S/q
         zvm/HeTaE/KKwsYxvzhAPAHvz04Yok6t8fG5LnQ4nuyMI0dFvmg47xM5iOWquVCj4YSy
         jHq3X2NaW9QzMNAFxEQPxcHUgsr5SS20QF3xES+kKOV9/6iFoa6TpmV34Op0uadX06yj
         lriUliXzyoOo8OC/yhaXWu9OWRkNQyENXYIsVuoJOKIAbqL3zo4y66k+0KUBSyL4Cooe
         V0o8Yy6YMiJbd4jE009mcIgApfdi7f6CXYNJ7x0ix1qmqk36OAgu5HNTiTBi+Ern9SCW
         StKg==
X-Gm-Message-State: AJIora9KPRCVs02uITh5fYpGPafssDv7PZpQPHDAm2JCJbNJCLRtyqxe
        ibWuMzIf9PYW2/c/wULgu1Fg8AgJOu7xgWel8QLmRylmj24F4vbNmmku4XC1yUs99DBx5mhLPEA
        DBqjJXnm1svpdZZR/wlPfmYj7lh0/xzEJp2rPA6Nwq4DS2J4CKkK0KWW0+r7I1C8=
X-Google-Smtp-Source: AGRyM1vN9a3iSyZgrhJEDupPZj+y40XaynuHLrdJc4tOKfjiZkLhGPy7QJmFPuwostPIv4SaxUhlriN0IMAMhg==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:1c5c:b0:505:7469:134a with SMTP
 id s28-20020a056a001c5c00b005057469134amr2174133pfw.16.1658530922508; Fri, 22
 Jul 2022 16:02:02 -0700 (PDT)
Date:   Fri, 22 Jul 2022 16:01:57 -0700
Message-Id: <20220722230157.2429624-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [kvm-unit-tests PATCH] x86: kvmclock: Fix a non-prototype function declaration
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
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

Avoid a -Wstrict-prototypes clang warning.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 x86/kvmclock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/kvmclock.c b/x86/kvmclock.c
index f190048c9bde..f9f21032fea9 100644
--- a/x86/kvmclock.c
+++ b/x86/kvmclock.c
@@ -222,7 +222,7 @@ static cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 	return ret;
 }
 
-cycle_t kvm_clock_read()
+cycle_t kvm_clock_read(void)
 {
         struct pvclock_vcpu_time_info *src;
         cycle_t ret;
-- 
2.37.1.359.gd136c6c3e2-goog

