Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BC5648968
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 21:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiLIUOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 15:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiLIUN7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 15:13:59 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82D06720B
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 12:13:58 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 203-20020a2502d4000000b006f94ab02400so6116486ybc.2
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 12:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fue5zdvQ0csJssU66zvXs+3fiFxVfKrEWArEoP7DVyM=;
        b=Y6RK1888y3Ff3zHGr9vHqu+Zxm+K2qWrGjVNt3wlTQoql4f9QjYzkAEO2Me/rO18rJ
         zydB/2g/sRgDwLQdZY9hXL9rmkn3x3jWb4S+OWGZ1brW3GxRbHa6JP0lW0Ei65ADEUTP
         IegXtFDkkvUDiQa1EbTyCgQT2H7xtW8TJcyC6L74l+9l11McxLNcFZy5EQj4IXpY+Osb
         PBHHEpel6WZXC0CgwSUOnSMiszCNBcTyXDUOyZ+tbHSasgfqDeuZTI01qMvVWkgtR6QG
         k3g18HKA3PhU6i0Lyr5UcGZJKVOvUWmNiDUfbcwa7SB7h4ahI5s+ykDwez0Rpyiactix
         urIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fue5zdvQ0csJssU66zvXs+3fiFxVfKrEWArEoP7DVyM=;
        b=h71wk1lNf+Zv6vhQQVTwmXCWcCGZpscdx++3T8bNC9E2EUxEyrQjVhictWCn57ps+2
         lIwChrnYnFcEEWJA//8fIAw7kCC4ZnBhOind40VoZDVGlsAtPUUYBst52GHiw5fLIjxw
         D7HPAb2bpoduydnGO3LqPlLtpWo7irEyxsWREf0ctf6s6KMFzBAJejLQKXsY6YIZDgYL
         M9hPz7zFLCmnpt6tFXvAjGoPAjWSLOKyfeXShgXYr6vAfoyOP3JxuX2igYS9uGEBhSZO
         lDYsdFlj7aBgtK8TfhFHIX78MkpNDODFXxz0lYKpYVWev5im+/1WEtAFKpqCoHUHz5m7
         TKjA==
X-Gm-Message-State: ANoB5pkGX0rurMSByb+41XTc8qs+oXpnvDm4TJ3mRE/k5vPwkX80889w
        jJ/GRqHQ+NmcKkd6xBPHi2xCdB0SbpTSXpq5V8hDH6Qf5Z68DFl3vQutV4BYQd234HPNhRqrS7a
        n+hU7UZ6PWW4HMgV4hUGdWhtp92Cm4YaR4n87DoxXSngAYuRWN7F1gMCW1FU5JLdFK0JZ
X-Google-Smtp-Source: AA0mqf77XUPPHw14u7lRnqiZOjUhx8QCLAQFIPoapozyk51d9rgPfhJEYkeXeJZ4cby/DFwzwVuvp2ypsms/PvwZ
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a25:ba8f:0:b0:6d0:828:9852 with SMTP id
 s15-20020a25ba8f000000b006d008289852mr66748827ybg.364.1670616838004; Fri, 09
 Dec 2022 12:13:58 -0800 (PST)
Date:   Fri,  9 Dec 2022 20:13:27 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221209201326.2781950-1-aaronlewis@google.com>
Subject: [PATCH] KVM: selftests: Fix a typo in the vcpu_msrs_set assert
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

The assert incorrectly identifies the ioctl being called.  Switch it
from KVM_GET_MSRS to KVM_SET_MSRS.

Fixes: 6ebfef83f03f ("KVM: selftest: Add proper helpers for x86-specific save/restore ioctls")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index b1a31de7108a..92c5c9eba1bb 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -716,7 +716,7 @@ static inline void vcpu_msrs_set(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs)
 	int r = __vcpu_ioctl(vcpu, KVM_SET_MSRS, msrs);
 
 	TEST_ASSERT(r == msrs->nmsrs,
-		    "KVM_GET_MSRS failed, r: %i (failed on MSR %x)",
+		    "KVM_SET_MSRS failed, r: %i (failed on MSR %x)",
 		    r, r < 0 || r >= msrs->nmsrs ? -1 : msrs->entries[r].index);
 }
 static inline void vcpu_debugregs_get(struct kvm_vcpu *vcpu,
-- 
2.39.0.rc1.256.g54fd8350bd-goog

