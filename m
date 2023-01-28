Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B425867F33B
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 01:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbjA1Aip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 19:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjA1Aio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 19:38:44 -0500
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE8C10A;
        Fri, 27 Jan 2023 16:38:43 -0800 (PST)
Received: from [64.186.27.43] (helo=srivatsa-dev.eng.vmware.com)
        by outgoing2021.csail.mit.edu with esmtpa (Exim 4.95)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1pLZER-000elb-VP;
        Fri, 27 Jan 2023 19:38:12 -0500
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        peterz@infradead.org, hpa@zytor.com
Cc:     bp@alien8.de, dave.hansen@linux.intel.com,
        rafael.j.wysocki@intel.com, paulmck@kernel.org, jgross@suse.com,
        seanjc@google.com, thomas.lendacky@amd.com,
        linux-kernel@vger.kernel.org, imammedo@redhat.com,
        amakhalov@vmware.com, ganb@vmware.com, ankitja@vmware.com,
        bordoloih@vmware.com, keerthanak@vmware.com, blamoreaux@vmware.com,
        namit@vmware.com, wyes.karny@amd.com, lewis.carroll@amd.com,
        pv-drivers@vmware.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        srivatsa@csail.mit.edu
Subject: [PATCH] x86/hotplug: Remove incorrect comment about mwait_play_dead()
Date:   Fri, 27 Jan 2023 16:37:51 -0800
Message-Id: <20230128003751.141317-1-srivatsa@csail.mit.edu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>

The comment that says mwait_play_dead() returns only on failure is a
bit misleading because mwait_play_dead() could actually return for
valid reasons (such as mwait not being supported by the platform) that
do not indicate a failure of the CPU offline operation. So, remove the
comment.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
---
 arch/x86/kernel/smpboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 55cad72715d9..9013bb28255a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1833,7 +1833,7 @@ void native_play_dead(void)
 	play_dead_common();
 	tboot_shutdown(TB_SHUTDOWN_WFS);
 
-	mwait_play_dead();	/* Only returns on failure */
+	mwait_play_dead();
 	if (cpuidle_play_dead())
 		hlt_play_dead();
 }
-- 
2.25.1

