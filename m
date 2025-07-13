Return-Path: <kvm+bounces-52256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE95BB03349
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 00:21:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B12C51894F5C
	for <lists+kvm@lfdr.de>; Sun, 13 Jul 2025 22:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 371D420C478;
	Sun, 13 Jul 2025 22:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M5NecNqW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D1E2046A9;
	Sun, 13 Jul 2025 22:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752445243; cv=none; b=iY33G1KNQX7iCyLI7rU2AEWw7RnakgrzfJkRWaUh8ugUtoefrNWl0AJKTtTNUOZmRdnB8sJ314dZBnAfrgpUVsFSKfDSNI5xxNTXty7h9rUmRaMVj6rBKd35ZCeLqCd5sRcn1SU6QfTesRR/2jdDKZa2NRCU/PEFE9ZgKwBz/2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752445243; c=relaxed/simple;
	bh=Evzy0z8dVOISDH5lXgms8Aq3Kfyn1mwy+RJB/+zm9Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBPP9j/oxr9JqBAspcquIw8/E2DPP0VHCZK9Y2KWJbNNJ5UjN8JtZzmcOQNUSqp9XSk+m0Hue8Cyf2DDw4leE/l8uLK4Zd1dhObbdSXRe5XkKPgQbMobffvM/nnWwwSWutJitDuite/I84xRjJmiV63MTVooACn6hObMvy3Tnh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M5NecNqW; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752445242; x=1783981242;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Evzy0z8dVOISDH5lXgms8Aq3Kfyn1mwy+RJB/+zm9Ow=;
  b=M5NecNqWoFRIsHOnB79Zmyd6ZC/qOB2U9fPCY9dTr5TYDeNPSfPl2o2t
   bwCu7dDhybZlwdPa/r6l1MYWqJePXf7tc781h3m8wvUn8gNibj7jYeaQo
   Nc2z4LdWy8FP62b0iaSUD4j5Yj/A3QNpFsr6kwZfuK7yVtLEIBI6nSY1p
   c6cSuavl4PBOEQhP4V7SRNSX4kqs7XMm5s7bkQeNt4c0vaR7NEesCXsZ5
   kKWfSv3joqHTNDAcqvY8c1yOUj0J86nMnMPzaORMYiz3UrhIaNxZktV/V
   rX33SLuz1q8sXRVAetd7qoO/LXhkmnKZHh67r4W+UWpd5L3MvrVyW40V4
   Q==;
X-CSE-ConnectionGUID: p9fIXb7RShu2fTc8bOKqqA==
X-CSE-MsgGUID: 5bF3lHYOSxSeSNW3xMrKhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="80077254"
X-IronPort-AV: E=Sophos;i="6.16,309,1744095600"; 
   d="scan'208";a="80077254"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 15:20:42 -0700
X-CSE-ConnectionGUID: 37v/o9/oR3iteh3zY9Io2g==
X-CSE-MsgGUID: ZPozDmYRSW2VIlKne1TC+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,309,1744095600"; 
   d="scan'208";a="156891933"
Received: from gpacheco-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.7])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 15:20:38 -0700
From: Kai Huang <kai.huang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	thomas.lendacky@amd.com,
	nikunj@amd.com,
	bp@alien8.de,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	rick.p.edgecombe@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: x86: Reject KVM_SET_TSC_KHZ vCPU ioctl for TSC protected guest
Date: Mon, 14 Jul 2025 10:20:20 +1200
Message-ID: <71bbdf87fdd423e3ba3a45b57642c119ee2dd98c.1752444335.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <cover.1752444335.git.kai.huang@intel.com>
References: <cover.1752444335.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reject KVM_SET_TSC_KHZ vCPU ioctl if guest's TSC is protected and not
changeable by KVM, and update the documentation to reflect it.

For such TSC protected guests, e.g. TDX guests, typically the TSC is
configured once at VM level before any vCPU are created and remains
unchanged during VM's lifetime.  KVM provides the KVM_SET_TSC_KHZ VM
scope ioctl to allow the userspace VMM to configure the TSC of such VM.
After that the userspace VMM is not supposed to call the KVM_SET_TSC_KHZ
vCPU scope ioctl anymore when creating the vCPU.

The de facto userspace VMM Qemu does this for TDX guests.  The upcoming
SEV-SNP guests with Secure TSC should follow.

Note this could be a break of ABI.  But for now only TDX guests are TSC
protected and only Qemu supports TDX, thus in practice this should not
break any existing userspace.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
---
 Documentation/virt/kvm/api.rst | 7 +++++++
 arch/x86/kvm/x86.c             | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e343430ccb01..563878465a6a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2008,6 +2008,13 @@ If the KVM_CAP_VM_TSC_CONTROL capability is advertised, this can also
 be used as a vm ioctl to set the initial tsc frequency of subsequently
 created vCPUs. The vm ioctl must be called before any vCPU is created.
 
+For TSC protected Confidential Computing (CoCo) VMs where TSC frequency
+is configured once at VM scope and remains unchanged during VM's
+lifetime, the vm ioctl should be used to configure the TSC frequency
+and the vcpu ioctl is not supported.
+
+Example of such CoCo VMs: TDX guests.
+
 4.56 KVM_GET_TSC_KHZ
 --------------------
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4051c0cacb92..26737bc4decb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6186,6 +6186,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		u32 user_tsc_khz;
 
 		r = -EINVAL;
+
+		if (vcpu->arch.guest_tsc_protected)
+			goto out;
+
 		user_tsc_khz = (u32)arg;
 
 		if (kvm_caps.has_tsc_control &&
-- 
2.50.0


