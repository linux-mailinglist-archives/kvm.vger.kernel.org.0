Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14AE629702
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiKOLQf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiKOLQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:04 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CDD24BC6
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:00 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 4-20020a250104000000b006de5a38d75bso10022502ybb.20
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0iVDbAl/wOH2U+H6EW34muc3XZD9nJedZ9yIRaXatks=;
        b=KsWYZAk7wbm6OIEFqkj1jQ8VFtQJXPuE8kGSMKTColNLrqgjM+2cZ86FZdBJVYW/k5
         Bhdc+6DPA+USOmI/QoxuN45xRS/2EIPdrLDWIBcTGhcPYSUQ6mSmNRuJjuOH1pVkezHx
         DeJGzgD3+xMPFT9Q+69Xu3+8qUEho3jhtUDtCNtKvfBmTz0BFaedG+kuScc1T2cDyjw3
         HwW+IBIEPZjoEzks/nqD92Tq6JSfsUlfJGJBsFzakteDm+8yHLq+HRTtlyDe3D949j5S
         Cao2pLKGbFFa/KpKfmkME3JbesaksalKFeSgm3vbN2Eh4l3yhrXfn3TgYbFodJogA39H
         4LlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0iVDbAl/wOH2U+H6EW34muc3XZD9nJedZ9yIRaXatks=;
        b=GHIrbPireHFdwON5S2/Nvcb9VxqZTtgOaSpz7XaHlv9EdOt94R5bGD4EB2rw8dEYG2
         8LAJRykqEdEHUF+jRouFTFK3wUVI1zXfAuyRe/pN4JXlh9bNincrAQRikKwRbwV2/Zy/
         G0M0+wTRKnASeYrb0KjZ2xmGdkoTWk4DziOl581+OgnjItsKWwagzMAxJ9ePx2U8ao1Z
         m/WlRr/pR8Wu6z3h8JUOBWkmCKWyrlbzWXLkK9hJoZCSg/yTmOdjth2SACZwn6Da9Raq
         ks5pA+UH+K84CRPkh7EiitXCh/b0XPSNdhkzoTC5o71hAK3FiWL1bkhw5gkp4mOhofOT
         IFxg==
X-Gm-Message-State: ACrzQf0hVUlXQu92G5sh27Yn8LASrwWdSPP63EsnhcbvodSckZi84Kcj
        tKYGjBRL2ud2d1ONzNX892m++fc9MAR3WDNTr8XTf7Qypg+27Po04rR3zzHRcCTByXC3UaZKNU4
        DVUuz3un9QGvIB6hh1BAHLpALqvkJZo3boNrBcSguARyc46ZXCnUGJzU=
X-Google-Smtp-Source: AMsMyM7aK8p1bPly6GJPrwpEJiAQoQ3WMIhAJxzW15S6NlHzkFnuyytXtXShOjXRFBMCeN1cflWumACFPg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:484a:0:b0:36b:7d6c:d85 with SMTP id
 v71-20020a81484a000000b0036b7d6c0d85mr61409906ywa.8.1668510959497; Tue, 15
 Nov 2022 03:15:59 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:36 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-5-tabba@google.com>
Subject: [PATCH kvmtool v1 04/17] Add hostmem va to debug print
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, will@kernel.org, tabba@google.com
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

Useful when debugging.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arm/kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index d51cc15..c84983e 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -66,8 +66,8 @@ void kvm__init_ram(struct kvm *kvm)
 
 	kvm->arch.memory_guest_start = phys_start;
 
-	pr_debug("RAM created at 0x%llx - 0x%llx",
-		 phys_start, phys_start + phys_size - 1);
+	pr_debug("RAM created at 0x%llx - 0x%llx (host_mem 0x%llx)",
+		 phys_start, phys_start + phys_size - 1, (u64)host_mem);
 }
 
 void kvm__arch_delete_ram(struct kvm *kvm)
-- 
2.38.1.431.g37b22c650d-goog

