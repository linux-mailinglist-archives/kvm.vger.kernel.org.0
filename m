Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D50782C82
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 16:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236127AbjHUOsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 10:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236055AbjHUOsE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 10:48:04 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD34AE2
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 07:48:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 714CE22BA3;
        Mon, 21 Aug 2023 14:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1692629281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SKaj40AGDMmtE1L+i7cRpd8FF0LwsG6wcYk7oN7PN9U=;
        b=AA1IiQLq/0Mot3/jCOTV2j9Im7DfK4s+K9mO6WJaVkVlBU/KtkR+3umpR2My/fT1EhH4RB
        ZyRP55gDN/csorMLekaWd8OlA6S+mjT2hgJurwvPcWScE3wvQ4X1vFyju38HLW1dr4hSJy
        QRMyGVG/sFZwgvTTIL9143XZtUxi/xc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1692629281;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SKaj40AGDMmtE1L+i7cRpd8FF0LwsG6wcYk7oN7PN9U=;
        b=lI9ogezRmtXjCo0nhqCOMqXfFGvSGj6AAToxpQIdN04bA8P92ulInXEw2yDNRdKgTv+H9V
        EFXyN3YX35gg+iDw==
Received: from vasant-suse.fritz.box (vkarasulli.udp.ovpn1.nue.suse.de [10.163.24.134])
        by relay2.suse.de (Postfix) with ESMTP id DDB902C145;
        Mon, 21 Aug 2023 14:48:00 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, jroedel@suse.de,
        drjones@redhat.com, erdemaktas@google.com, marcorr@google.com,
        papaluri@amd.com, rientjes@google.com, zxwang42@gmail.com,
        Vasant Karasulli <vkarasulli@suse.de>,
        Varad Gautam <varad.gautam@suse.com>
Subject: [kvm-unit-tests PATCH v5 02/11] x86: Move svm.h to lib/x86/
Date:   Mon, 21 Aug 2023 16:47:42 +0200
Message-Id: <20230821144751.22557-3-vkarasulli@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230821144751.22557-1-vkarasulli@suse.de>
References: <20230821144751.22557-1-vkarasulli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This enables sharing common definitions across testcases and lib/.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
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
index ba435b4..fc7359c 100644
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
index 27ce47b..2b4137c 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1,4 +1,4 @@
-#include "svm.h"
+#include "x86/svm.h"
 #include "libcflat.h"
 #include "processor.h"
 #include "desc.h"
--
2.34.1

