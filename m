Return-Path: <kvm+bounces-30842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E449BDD42
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:51:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBA3B281530
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25BED1917EE;
	Wed,  6 Nov 2024 02:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WC1x4pRt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB35619046E
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 02:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730861425; cv=none; b=EI4reBCXMWQoLhC6brTGyJYlk1xQLy2eN3pyi/eeDHvDx9D5qKev/TcLx0XfBDWZgFNT9/L5/VcHMbI1bodC7SlJC415QI0leMhkavBInSOG2TuE5/zvBZYTPAYZ+gZOp2kbQT3znY/Bqivf7UKVAq7/lSNuVeFZ6dEV5+4iQfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730861425; c=relaxed/simple;
	bh=9AuyQrZYSzpVA3FJlyTq2ttbB88VVZZG/V9oVSStOkA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gBUvjU4BCAec4SsmWdQ3t3KI6DsH3cN7o9dzrFpTxt7W1JlMkKgMIISs6KB40ddtSnVi/ry1WygIz9x03OkPTIl2kt5FbXPs5gb9PTt/HsPOxD2fdlAW4LrlFpMlCgDlLzZ62V5zijDtKDc4R2smhhIquEYON0+NqRvbuZ7Oyx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WC1x4pRt; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730861424; x=1762397424;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9AuyQrZYSzpVA3FJlyTq2ttbB88VVZZG/V9oVSStOkA=;
  b=WC1x4pRtT2wYixV7DepMT15h3fVb9vrsZ8+LF7mBQ++TrdZ8xENXTBj2
   wmABVCi/Cik4T7y9GE1BsoLo73tefg1u6oyuVbo6u0BZWVcfOBGmUd7u5
   XacwHqbn25vEkclUMaNhK6NLOkk3A/cRC+F16DT1Bs7BA8ciA8G19SQ4l
   DNMZ1jmij+e/PgxeilHRcRfq2D8bdjhevE357lnG5e8LSmQDUs2acJ83E
   j9dBWSeufq9jvinVKAFiMQt2CUEs0mS2HORXzxTAUTn93NX32GxfObrXR
   FO55sWGl35E+iSbZPAhOwUy7XACA+g2ItWRufAs3a4KYPutGsV1Brezxt
   A==;
X-CSE-ConnectionGUID: FxQOSwM0SgC8CtLvBDICmQ==
X-CSE-MsgGUID: FDNMdexlTn6DSgtI3567WA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30492328"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30492328"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:50:24 -0800
X-CSE-ConnectionGUID: Xc1MDl7tSfCEEqJ32ZjcVg==
X-CSE-MsgGUID: k7B4qdF5SEW5pn0ojYmSlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="115078037"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 05 Nov 2024 18:50:20 -0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Tao Su <tao1.su@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 11/11] target/i386/kvm: Replace ARRAY_SIZE(msr_handlers) with KVM_MSR_FILTER_MAX_RANGES
Date: Wed,  6 Nov 2024 11:07:28 +0800
Message-Id: <20241106030728.553238-12-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241106030728.553238-1-zhao1.liu@intel.com>
References: <20241106030728.553238-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_install_msr_filters() uses KVM_MSR_FILTER_MAX_RANGES as the bound
when traversing msr_handlers[], while other places still compute the
size by ARRAY_SIZE(msr_handlers).

In fact, msr_handlers[] is an array with the fixed size
KVM_MSR_FILTER_MAX_RANGES, so there is no difference between the two
ways.

For the code consistency and to avoid additional computational overhead,
use KVM_MSR_FILTER_MAX_RANGES instead of ARRAY_SIZE(msr_handlers).

Suggested-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
---
v4: new commit.
---
 target/i386/kvm/kvm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 013c0359acbe..501873475255 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5885,7 +5885,7 @@ static int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
 {
     int i, ret;
 
-    for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
+    for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
         if (!msr_handlers[i].msr) {
             msr_handlers[i] = (KVMMSRHandlers) {
                 .msr = msr,
@@ -5911,7 +5911,7 @@ static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
     int i;
     bool r;
 
-    for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
+    for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
         KVMMSRHandlers *handler = &msr_handlers[i];
         if (run->msr.index == handler->msr) {
             if (handler->rdmsr) {
@@ -5931,7 +5931,7 @@ static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
     int i;
     bool r;
 
-    for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
+    for (i = 0; i < KVM_MSR_FILTER_MAX_RANGES; i++) {
         KVMMSRHandlers *handler = &msr_handlers[i];
         if (run->msr.index == handler->msr) {
             if (handler->wrmsr) {
-- 
2.34.1


