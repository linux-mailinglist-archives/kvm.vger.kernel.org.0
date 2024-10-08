Return-Path: <kvm+bounces-28128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 449A99945BD
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 12:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 042D92875DB
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 10:46:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8C51C3F27;
	Tue,  8 Oct 2024 10:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jhxig615"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A741D0496;
	Tue,  8 Oct 2024 10:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728384335; cv=none; b=Gebc35VuXm3JfCo2zueicki0DhYMxUIAVNYTwX6Eqt5u76p1WfHacUfRcilXTs4XpOXGiKzJACpQeJ2ZMusM5e5yQCHFcdS3GfeFN0PsbweJ8CTIRWFNLH1z1Q0FtXR9mnfKZO1RnzDgIn7gXuaP1N2Yz666ncsKPH95WWXzhqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728384335; c=relaxed/simple;
	bh=/Wy3bEmK+Z2Csvv6DBysE2rgjF97bye9ch+Y+NPQ9vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzD0U6XyT+aDrrs44BWn/4hQ5X6ZG01rS5VE+1qvSGneM33CuwDfmScKfDXCJmUSsvtwulKd35Mx+RCIgAMV7r48iv02yDtDpZVYtHCzEoXHn7W+h/gviKe/4Bntt+vPzD2AUp5B7wlv99gw0BxpHggCN0faPDdQM+Ik5ynn0co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jhxig615; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728384333; x=1759920333;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/Wy3bEmK+Z2Csvv6DBysE2rgjF97bye9ch+Y+NPQ9vw=;
  b=Jhxig6155VgLoVHiV3ffcYVcb/b0Hidf0r3dHRkeNA/WGQynCbG2Y/Et
   8GM+MA5CYdFCwhKBEiEnjbScY99VtGilO9+D2c3Jvi6d9JmVHmGRtSFs0
   fx7ZyrK2GZPlVsJgQHziXrxNd2yeLaDvLV493zLlOFWur2ewtcOf6No08
   v+bCDQc2is+lwy6b1zoARgUY/gYXCBl6Rej3OH2OAGXmhuu7lr8Z5FomH
   pOaVEjCCR1/FL0jyld4O6CIvB0mQH2V3dDgXqMrVgrclucNoCQCnmCwyu
   iJ8VCTIlyBMIqy+mRIo9WTRQHXc4Kkbq9qJ/RUCaezK5R/RA9l3apHyws
   Q==;
X-CSE-ConnectionGUID: //8ed1ffRfyYemUtHGDcXw==
X-CSE-MsgGUID: S7ooEgGTTuK/J5/CRAtZYg==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="45033839"
X-IronPort-AV: E=Sophos;i="6.11,186,1725346800"; 
   d="scan'208";a="45033839"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 03:45:31 -0700
X-CSE-ConnectionGUID: h4kYvybrTwmALhhG/u1m0A==
X-CSE-MsgGUID: jIdiX7nLSFCzVuXbVVVpjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,186,1725346800"; 
   d="scan'208";a="76166929"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.88])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 03:45:30 -0700
From: Kai Huang <kai.huang@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 2/2] KVM: x86: Fix a comment inside __kvm_set_or_clear_apicv_inhibit()
Date: Tue,  8 Oct 2024 23:45:14 +1300
Message-ID: <e462e7001b8668649347f879c66597d3327dbac2.1728383775.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1728383775.git.kai.huang@intel.com>
References: <cover.1728383775.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change svm_vcpu_run() to vcpu_enter_guest() in the comment of
__kvm_set_or_clear_apicv_inhibit() to make it reflect the fact.

When one thread updates VM's APICv state due to updating the APICv
inhibit reasons, it kicks off all vCPUs and makes them wait until the
new reason has been updated and can be seen by all vCPUs.

There was one WARN() to make sure VM's APICv state is consistent with
vCPU's APICv state in the svm_vcpu_run().  Commit ee49a8932971 ("KVM:
x86: Move SVM's APICv sanity check to common x86") moved that WARN() to
x86 common code vcpu_enter_guest() due to the logic is not unique to
SVM, and added comments to both __kvm_set_or_clear_apicv_inhibit() and
vcpu_enter_guest() to explain this.

However, although the comment in __kvm_set_or_clear_apicv_inhibit()
mentioned the WARN(), it seems forgot to reflect that the WARN() had
been moved to x86 common, i.e., it still mentioned the svm_vcpu_run()
but not vcpu_enter_guest().  Fix it.

Note after the change the first line that contains vcpu_enter_guest()
exceeds 80 characters, but leave it as is to make the diff clean.

Fixes: ee49a8932971 ("KVM: x86: Move SVM's APICv sanity check to common x86")
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index afd70c274692..7b347e564d10 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10606,11 +10606,11 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 	if (!!old != !!new) {
 		/*
 		 * Kick all vCPUs before setting apicv_inhibit_reasons to avoid
-		 * false positives in the sanity check WARN in svm_vcpu_run().
+		 * false positives in the sanity check WARN in vcpu_enter_guest().
 		 * This task will wait for all vCPUs to ack the kick IRQ before
 		 * updating apicv_inhibit_reasons, and all other vCPUs will
 		 * block on acquiring apicv_update_lock so that vCPUs can't
-		 * redo svm_vcpu_run() without seeing the new inhibit state.
+		 * redo vcpu_enter_guest() without seeing the new inhibit state.
 		 *
 		 * Note, holding apicv_update_lock and taking it in the read
 		 * side (handling the request) also prevents other vCPUs from
-- 
2.46.0


