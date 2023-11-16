Return-Path: <kvm+bounces-1886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17BF97EE1A1
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 14:39:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B69E91F24523
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 13:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB5230F8C;
	Thu, 16 Nov 2023 13:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hq7bqN7q";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UC4DUtwU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2C2A0;
	Thu, 16 Nov 2023 05:38:51 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3566F204FF;
	Thu, 16 Nov 2023 13:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1700141930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qGlqJ91XgT6zatL0ncRqFs5WPTRXZ76PpGZv2Os9czw=;
	b=hq7bqN7qAkMVa/iDOqLUpaM+RodtpQsEIXkhW46MJ1L/vJzABEr7fQm/j2SI1xgZ1fN3kS
	QYWfF+IP1dp22stCfFdVlilyvx/wErZ+MckLhYy1mU1xnMhFROj6+vKb0AknLv2SJxoxH0
	ZKVr4eJnAuQ076eo78Anb2VZy1+e9Vk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1700141930;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qGlqJ91XgT6zatL0ncRqFs5WPTRXZ76PpGZv2Os9czw=;
	b=UC4DUtwUxpwUmPDeoE2Kwkgm0sjho0yy1TK7RzO5EZHy58JO53cexW7Cd5YdOX4X3ax2Iu
	fVx2z4AlhQWg4+CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BE626139C4;
	Thu, 16 Nov 2023 13:38:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id Dx7VKmkbVmXgFgAAMHmgww
	(envelope-from <clopez@suse.de>); Thu, 16 Nov 2023 13:38:49 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2] KVM: X86: improve documentation for KVM_CAP_X86_BUS_LOCK_EXIT
Date: Thu, 16 Nov 2023 14:36:29 +0100
Message-Id: <20231116133628.5976-1-clopez@suse.de>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -3.30
X-Spamd-Result: default: False [-3.30 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 RCPT_COUNT_FIVE(0.00)[6];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 MID_CONTAINS_FROM(1.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]

Improve the description for the KVM_CAP_X86_BUS_LOCK_EXIT capability,
fixing a few typos and improving grammar for overall clarity.

Signed-off-by: Carlos López <clopez@suse.de>
---
v2: Corrected the name of the KVM_RUN_X86_BUS_LOCK flag

 Documentation/virt/kvm/api.rst | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7025b3751027..4701370bf46f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6256,9 +6256,9 @@ More architecture-specific flags detailing state of the VCPU that may
 affect the device's behavior. Current defined flags::
 
   /* x86, set if the VCPU is in system management mode */
-  #define KVM_RUN_X86_SMM     (1 << 0)
+  #define KVM_RUN_X86_SMM          (1 << 0)
   /* x86, set if bus lock detected in VM */
-  #define KVM_RUN_BUS_LOCK    (1 << 1)
+  #define KVM_RUN_X86_BUS_LOCK     (1 << 1)
   /* arm64, set for KVM_EXIT_DEBUG */
   #define KVM_DEBUG_ARCH_HSR_HIGH_VALID  (1 << 0)
 
@@ -7582,20 +7582,20 @@ KVM_BUS_LOCK_DETECTION_OFF and KVM_BUS_LOCK_DETECTION_EXIT are supported
 currently and mutually exclusive with each other. More bits can be added in
 the future.
 
-With KVM_BUS_LOCK_DETECTION_OFF set, bus locks in guest will not cause vm exits
+With KVM_BUS_LOCK_DETECTION_OFF set, bus locks in guest will not cause VM exits
 so that no additional actions are needed. This is the default mode.
 
-With KVM_BUS_LOCK_DETECTION_EXIT set, vm exits happen when bus lock detected
-in VM. KVM just exits to userspace when handling them. Userspace can enforce
-its own throttling or other policy based mitigations.
-
-This capability is aimed to address the thread that VM can exploit bus locks to
-degree the performance of the whole system. Once the userspace enable this
-capability and select the KVM_BUS_LOCK_DETECTION_EXIT mode, KVM will set the
-KVM_RUN_BUS_LOCK flag in vcpu-run->flags field and exit to userspace. Concerning
-the bus lock vm exit can be preempted by a higher priority VM exit, the exit
-notifications to userspace can be KVM_EXIT_BUS_LOCK or other reasons.
-KVM_RUN_BUS_LOCK flag is used to distinguish between them.
+With KVM_BUS_LOCK_DETECTION_EXIT set, VM exits happen when a bus lock is
+detected in VM. KVM just exits to userspace when handling them. Userspace can
+enforce its own throttling or other policy based mitigations.
+
+This capability is aimed to address the fact that a VM can exploit bus locks to
+impact the performance of the whole system. Once userspace enables this
+capability and selects the KVM_BUS_LOCK_DETECTION_EXIT mode, KVM will set the
+KVM_RUN_X86_BUS_LOCK flag in the vcpu->run->flags field and exit to userspace.
+Concerning the bus lock, a VM exit can be preempted by a higher priority VM
+exit, so the exit notification to userspace can be KVM_EXIT_BUS_LOCK or another
+reason. KVM_RUN_X86_BUS_LOCK flag is used to distinguish between them.
 
 7.23 KVM_CAP_PPC_DAWR1
 ----------------------
-- 
2.35.3


