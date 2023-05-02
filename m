Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0F36F42B9
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 13:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbjEBL0B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 07:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbjEBLZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 07:25:58 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F558100;
        Tue,  2 May 2023 04:25:24 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-5286344e1d4so3331754a12.3;
        Tue, 02 May 2023 04:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683026708; x=1685618708;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5+7ReMNdnROs/Fh8JrLZGt15/0ISu5r890dI+IDPkSo=;
        b=nVSTUXTp708ovqdxJ7PlaLUG8coc1+sI98n7oe1tLEJq5P4aX3dqLgu/HG4kLSPv4P
         VyxPfyXzhzi9TiGruAkLlLy+TX71FTFbneCYb4s4u22XgP6qrgNMY3CAKFVw2X7EfeDP
         6uWq3jlYM5CfnK4KzQs+M6/I1VR6llOk5dImu8+tMLRBdn+bhPifG3M8QK9Gty6vcUG6
         ENykAGheoQurnGZwHLI3ZbQQo2Rg3QfL8/u9TGusciYsryT1r3ZLpMCyEglHY65fMwvb
         HoyizLO6fPonNtRmcahPEkSG9TSTceKC/FufmWsQH+X9kaiaXqNanm1GWlTMD6hCOjID
         7esg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683026708; x=1685618708;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5+7ReMNdnROs/Fh8JrLZGt15/0ISu5r890dI+IDPkSo=;
        b=POp2oCnqAQGjZOnKASahyVWLjsWQsiSqL4P9OrJ+q47QNBebnA8suu9BuFYhFq1t5D
         EM+eYmoT6E+EjEBJZhepsvJVWxuGulJAirCvTG7SSzjCUpu9h7637AG+mal1yIHTnRar
         Y4eK/mnrd20KAEXQa6aDhGUH6Baunk81kMZzIVndNPgciL3+DwTTh0L51/GMJYxSQV4s
         qrlRN4MZ0YgvMw6Ng5nbb7K+0/p5pVPkDRwdx7VBBZYE79hMhIEjAlY9ppCfq+jHPg7Q
         eMAondl/5fMC9estVl1vuOuUZ3cAW+/8lKuUD0joIEsU0cKKJTfXw6UxEdBzlXImONwH
         JgTQ==
X-Gm-Message-State: AC+VfDwFSroglc28Avk4/k2D0KqO1vvGiuADS6mgFOiBgU0UhdUx4ISd
        uh8SI+U5P1/6XY5N3PSuf/VQyrsTYDvqRg==
X-Google-Smtp-Source: ACHHUZ7mpkh5ODjxKBcwTlpkc1Xeiu3oirFBlWTpTtu9Stq/9nXPentJn5HrEpfVgRuEY3GIlvu06w==
X-Received: by 2002:a17:90b:4c8d:b0:246:61ae:2fbb with SMTP id my13-20020a17090b4c8d00b0024661ae2fbbmr18306648pjb.41.1683026708455;
        Tue, 02 May 2023 04:25:08 -0700 (PDT)
Received: from Dommie-Laptop.. (111-248-114-205.dynamic-ip.hinet.net. [111.248.114.205])
        by smtp.gmail.com with ESMTPSA id jh19-20020a170903329300b001a239325f1csm19590017plb.100.2023.05.02.04.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 04:25:08 -0700 (PDT)
From:   Yan-Jie Wang <yanjiewtw@gmail.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Avi Kivity <avi@redhat.com>,
        Yan-Jie Wang <yanjiewtw@gmail.com>,
        Ching-Chun Huang <jserv@ccns.ncku.edu.tw>, trivial@kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH] docs: clarify KVM related kernel parameters' descriptions
Date:   Tue,  2 May 2023 19:25:02 +0800
Message-Id: <20230502112502.14859-1-yanjiewtw@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The descriptions of certain KVM related kernel parameters can be
ambiguous and confusing. They state 'Disable ...,' which implies that
setting them to 1 would disable the associated features or options,
when in fact the opposite is true.

This commit addresses this issue by revising the descriptions of these
parameters to make their intended behavior clear.

Signed-off-by: Yan-Jie Wang <yanjiewtw@gmail.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 9e5bab29685f..cc5abb3d54b9 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2552,10 +2552,10 @@
 			on the ratio, such that a page is zapped after 1 hour on average.
 
 	kvm-amd.nested=	[KVM,AMD] Allow nested virtualization in KVM/SVM.
-			Default is 1 (enabled)
+			Default is 1 (allow)
 
-	kvm-amd.npt=	[KVM,AMD] Disable nested paging (virtualized MMU)
-			for all guests.
+	kvm-amd.npt=	[KVM,AMD] Enable nested paging (virtualized MMU)
+			for all guests on capable AMD chips.
 			Default is 1 (enabled) if in 64-bit or 32-bit PAE mode.
 
 	kvm-arm.mode=
@@ -2602,12 +2602,12 @@
 			Format: <integer>
 			Default: 5
 
-	kvm-intel.ept=	[KVM,Intel] Disable extended page tables
+	kvm-intel.ept=	[KVM,Intel] Enable extended page tables
 			(virtualized MMU) support on capable Intel chips.
 			Default is 1 (enabled)
 
 	kvm-intel.emulate_invalid_guest_state=
-			[KVM,Intel] Disable emulation of invalid guest state.
+			[KVM,Intel] Enable emulation of invalid guest state.
 			Ignored if kvm-intel.enable_unrestricted_guest=1, as
 			guest state is never invalid for unrestricted guests.
 			This param doesn't apply to nested guests (L2), as KVM
@@ -2615,7 +2615,7 @@
 			Default is 1 (enabled)
 
 	kvm-intel.flexpriority=
-			[KVM,Intel] Disable FlexPriority feature (TPR shadow).
+			[KVM,Intel] Enable FlexPriority feature (TPR shadow).
 			Default is 1 (enabled)
 
 	kvm-intel.nested=
@@ -2623,7 +2623,7 @@
 			Default is 0 (disabled)
 
 	kvm-intel.unrestricted_guest=
-			[KVM,Intel] Disable unrestricted guest feature
+			[KVM,Intel] Enable unrestricted guest feature
 			(virtualized real and unpaged mode) on capable
 			Intel chips. Default is 1 (enabled)
 
@@ -2639,7 +2639,7 @@
 
 			Default is cond (do L1 cache flush in specific instances)
 
-	kvm-intel.vpid=	[KVM,Intel] Disable Virtual Processor Identification
+	kvm-intel.vpid=	[KVM,Intel] Enable Virtual Processor Identification
 			feature (tagged TLBs) on capable Intel chips.
 			Default is 1 (enabled)
 

base-commit: 865fdb08197e657c59e74a35fa32362b12397f58
-- 
2.34.1

