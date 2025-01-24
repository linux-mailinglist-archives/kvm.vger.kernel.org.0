Return-Path: <kvm+bounces-36516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6373EA1B70E
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 14:39:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4131162FFB
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2025B83CD2;
	Fri, 24 Jan 2025 13:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DjZOhWXS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED7438FB9
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 13:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737725937; cv=none; b=alEp4eQVt5JWTuVTVae5OV4T94qyqsWDABGcdKgCjQAqCrwin6or8SG1ktVP04H51zspTTLNO3ctyjF7n5J7fswnzAv3rw+ZQlWoHUNdDAeZiPBXtpGCzA8cVk1GQvvmJsbgsO0PrBrvkb2c2L7e7DKNIjaSnWXwXPNzRoS/hhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737725937; c=relaxed/simple;
	bh=Ivxfpdrpb34ZCT0lQieIiov7gVqJ7+V2EXqhX8vm6BM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WWcmUVhjWMYMvu4fcm1KRdeBpTxp8lv7DWeK2yfLfnC0ZR0Wr6TOVMjtwq5B2F5zvVKR6Yr2IolnRIFiDkj3eksaLYSweDekHrKf2vNw9YzyVBg7M8fc1BnJEisDTop7WT33IeTzLG8EAqI+hQtkGoaibl/ogI0j6TDRHf0WIdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DjZOhWXS; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737725936; x=1769261936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ivxfpdrpb34ZCT0lQieIiov7gVqJ7+V2EXqhX8vm6BM=;
  b=DjZOhWXSEzLygND7BUTnCQw+G4OpD/AILshVSLjgak+7HcuqgIT+Rrcq
   0lV7EFRj/WxWk6n06+k29Dk/4Yk0FG+rLiwAXQPl6QYvBbvHunspkDd9h
   R6lSKYCP2CWeRaUI+BO5Bvuxjnt9dkQEPjRJ2l9JnJXvf/hjmmtLPwZ1l
   Kw7LdWCDDVz/64g6I3qRZ/aX4KOZKep+V6dUprFDLaYJAVBYKyAfcy2s5
   +HOJUPRhkUqcR1gpypBPCAbcDLiK/DtxU2PL6C7Z2r6J72fts5Vze0G5C
   Hnl1lsL+H86hwpPj4lnuh1NFNxQy++jWow90jkWQDJ72cVumgsmAcCpBZ
   g==;
X-CSE-ConnectionGUID: F1HaYXosSX68w6hlR+YbEQ==
X-CSE-MsgGUID: oaOY8StNTl2t4aySM3ZQUw==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="49246474"
X-IronPort-AV: E=Sophos;i="6.13,231,1732608000"; 
   d="scan'208";a="49246474"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 05:38:56 -0800
X-CSE-ConnectionGUID: dweXhYj8R0SZbpR+o8CQMQ==
X-CSE-MsgGUID: Ie6BhehtRWOPDjgmEywIIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111804384"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2025 05:38:52 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	xiaoyao.li@intel.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 30/52] i386/tdx: implement tdx_cpu_instance_init()
Date: Fri, 24 Jan 2025 08:20:26 -0500
Message-Id: <20250124132048.3229049-31-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124132048.3229049-1-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, pmu is not supported for TDX by KVM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
chanegs in v6:
 - new patch;
---
 target/i386/kvm/tdx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 591de30eedf4..12c1c2503845 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -396,6 +396,11 @@ static int tdx_kvm_type(X86ConfidentialGuest *cg)
     return KVM_X86_TDX_VM;
 }
 
+static void tdx_cpu_instance_init(X86ConfidentialGuest *cg, CPUState *cpu)
+{
+    object_property_set_bool(OBJECT(cpu), "pmu", false, &error_abort);
+}
+
 static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
 {
     if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
@@ -754,4 +759,5 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
 
     klass->kvm_init = tdx_kvm_init;
     x86_klass->kvm_type = tdx_kvm_type;
+    x86_klass->cpu_instance_init = tdx_cpu_instance_init;
 }
-- 
2.34.1


