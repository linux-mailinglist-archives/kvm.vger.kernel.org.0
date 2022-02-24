Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510E84C29F6
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 11:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbiBXK4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 05:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbiBXK4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 05:56:36 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A34527AA0E
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 02:56:07 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EFA92212B9;
        Thu, 24 Feb 2022 10:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645700165; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fDBt/0BVRd0xYLigzT6sQFBr1cg7foYCl8QKe2Zryw0=;
        b=iZk+ediF3E6yCJ+2r6MGwncZ56XtqytVFgEP9+6ng+DmOEbDhOLy7LOOL1WBvKwF3NCe0M
        UI+JuU0c4myGx815vMlf4J3lGPfEVZ0SaP5e80OvVLDNPaIaGGJCNGPvUJSWlXyrglM5o3
        +TxRPjMAU1rLmiZkpCI6VMU4txJQSoM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6326D13A79;
        Thu, 24 Feb 2022 10:56:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WP39FUVkF2KYSgAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Thu, 24 Feb 2022 10:56:05 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de,
        varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v3 02/11] x86: Move svm.h to lib/x86/
Date:   Thu, 24 Feb 2022 11:54:42 +0100
Message-Id: <20220224105451.5035-3-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220224105451.5035-1-varad.gautam@suse.com>
References: <20220224105451.5035-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

to share common definitions across testcases and lib/.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Reviewed-by: Marc Orr <marcorr@google.com>
---
 {x86 => lib/x86}/svm.h | 0
 x86/svm.c              | 2 +-
 x86/svm_tests.c        | 2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename {x86 => lib/x86}/svm.h (100%)

diff --git a/x86/svm.h b/lib/x86/svm.h
similarity index 100%
rename from x86/svm.h
rename to lib/x86/svm.h
diff --git a/x86/svm.c b/x86/svm.c
index 3f94b2a..7cfef9e 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -2,7 +2,7 @@
  * Framework for testing nested virtualization
  */
 
-#include "svm.h"
+#include "x86/svm.h"
 #include "libcflat.h"
 #include "processor.h"
 #include "desc.h"
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 0707786..7756296 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1,4 +1,4 @@
-#include "svm.h"
+#include "x86/svm.h"
 #include "libcflat.h"
 #include "processor.h"
 #include "desc.h"
-- 
2.32.0

