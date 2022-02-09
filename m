Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8614AF71B
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 17:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237143AbiBIQo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 11:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236958AbiBIQoZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 11:44:25 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6651EC05CB87
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 08:44:28 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 042F41F38E;
        Wed,  9 Feb 2022 16:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644425067; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fDBt/0BVRd0xYLigzT6sQFBr1cg7foYCl8QKe2Zryw0=;
        b=nDYdu6td/DExVva2Dt0YhTXGqJG+H111UzIrFMR+q18m4Iq9HrO5THULlWhUxXi2u+bUhg
        BNYdalVnQ/yvhMl26T/5iTSivBZIkZqZ8WTPxZ0xpunM8EaZKIUlIi3vJ0e8023ZBnCyvn
        MYVgBfiOsftxZVY00dmqIfzFtPrWZl4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6FBD013D4F;
        Wed,  9 Feb 2022 16:44:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sK87GWrvA2LfNgAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Wed, 09 Feb 2022 16:44:26 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de,
        varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH v2 02/10] x86: Move svm.h to lib/x86/
Date:   Wed,  9 Feb 2022 17:44:12 +0100
Message-Id: <20220209164420.8894-3-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220209164420.8894-1-varad.gautam@suse.com>
References: <20220209164420.8894-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
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

