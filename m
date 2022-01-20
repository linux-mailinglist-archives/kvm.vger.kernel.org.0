Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EB7494E3E
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 13:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243595AbiATMwI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 07:52:08 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:49044 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243355AbiATMwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 07:52:07 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 46350218E9;
        Thu, 20 Jan 2022 12:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642683126; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D3uwwkswiwPe3vqsMYVtYKJXaP24WfpYThrssek70/k=;
        b=JEVS6UaltAbjEykk76V/UVIEzrEB2x0J16fTPD0Ai36E1aFzJkKASUUf+dHppi1SdwVb4Y
        AUYCf/W5jpsODVU7uo4eoiK9zjP2LqjPqKeUMVkf+ljPH6YZSBKpqKpNzr03Tkhx/nSqZi
        qZMfDCSk4ik61wUPTUnNUO2eXgkakGI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AEAAA13B51;
        Thu, 20 Jan 2022 12:52:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KPKjKPVa6WGIagAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Thu, 20 Jan 2022 12:52:05 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de,
        varad.gautam@suse.com
Subject: [kvm-unit-tests 03/13] x86: Move svm.h to lib/x86/
Date:   Thu, 20 Jan 2022 13:51:12 +0100
Message-Id: <20220120125122.4633-4-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220120125122.4633-1-varad.gautam@suse.com>
References: <20220120125122.4633-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 8ad6122..5cc4642 100644
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

