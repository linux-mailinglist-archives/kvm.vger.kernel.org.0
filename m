Return-Path: <kvm+bounces-30832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A91A9BDD2E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:50:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E27E1F21BC3
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 02:50:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37AFA18FDDA;
	Wed,  6 Nov 2024 02:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hJjb/yyI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B2C18FC84
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 02:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730861395; cv=none; b=B1myF2p+oHRP8vD6unCFPPxyow+8c9yN9S9sypswZxPvGpNf+U2D1on23jfKa8o02BozDPkOLV0mpTbgjujLFnLEhOXZpS5FddgVRb1erhTjkH2CI0erbfBEiX9vYkXfQ42Gbf2ejYFT6dI7LskgBaN/W/fUTFe0C9qfh5k+IE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730861395; c=relaxed/simple;
	bh=H7lerJmEuC7yP69gP6zV6WKJa2+lLUCqxp5WR8/LiAI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dmp/tAIlHA0L9D+Oi15o9RxyTq0eVYtyxFIiEZOmYVDmjWB0vDEA7TwzwOhwEAikEM1CSgO0J6cEXNQe8zwPw51KUpX8JosHEAVOKz1YxtVae3yooS/vIL9/6Ta5TPEMaoJfc4rGZkfpJkd2dw1pHTFtFBd+qQivKY8UDhi95wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hJjb/yyI; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730861394; x=1762397394;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H7lerJmEuC7yP69gP6zV6WKJa2+lLUCqxp5WR8/LiAI=;
  b=hJjb/yyIMldPDo1Uk9NH6lf/PRKgN2pt71zQIu90I0m1Iv+7r6Rg4nKR
   RrZyN8/uqoPBzRidBj0oRIHrHKdWK0YcDUhDipGRQsSe0r7NOsOfxbetK
   /QBkfblM3QEfD9UPLvVf8EL9FMRtBEhxMRlXpqyzMv/5l/v6uwp0L7Raq
   gPBolSo48vJmbRjKp5nilQ0MzlKqSIg3/dc4FJFB3cT+J3lUaRpLh8sp+
   27gBcwYqWAVHZqrHb4jKPOqzTsXQIB9rYw3EfmxwAhNlGQrrFFk9ZiE2b
   TO9vNgL5Uz9EWT8pi/MF7OBsNtbROxSnoxY94OshO/ibc7TAYwE+FCe44
   A==;
X-CSE-ConnectionGUID: Ap0A7msvSuyN1H8RWUi0vw==
X-CSE-MsgGUID: qOaggdNlRjyH3zd4SAuNZg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30492200"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30492200"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 18:49:52 -0800
X-CSE-ConnectionGUID: rnzAlqV1T02GOnI+LsiAtQ==
X-CSE-MsgGUID: PiFYv1UARaawoXhgwXvjtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="115077975"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa001.fm.intel.com with ESMTP; 05 Nov 2024 18:49:49 -0800
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
	Zhao Liu <zhao1.liu@intel.com>,
	qemu-stable@nongnu.org
Subject: [PATCH v5 01/11 for v9.2?] i386/cpu: Mark avx10_version filtered when prefix is NULL
Date: Wed,  6 Nov 2024 11:07:18 +0800
Message-Id: <20241106030728.553238-2-zhao1.liu@intel.com>
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

In x86_cpu_filter_features(), if host doesn't support AVX10, the
configured avx10_version should be marked as filtered regardless of
whether prefix is NULL or not.

Check prefix before warn_report() instead of checking for
have_filtered_features.

Cc: qemu-stable@nongnu.org
Fixes: commit bccfb846fd52 ("target/i386: add AVX10 feature and AVX10 version property")
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
v5: new commit.
---
 target/i386/cpu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3baa95481fbc..77c1233daa13 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7711,8 +7711,10 @@ static bool x86_cpu_filter_features(X86CPU *cpu, bool verbose)
             env->avx10_version = version;
             have_filtered_features = true;
         }
-    } else if (env->avx10_version && prefix) {
-        warn_report("%s: avx10.%d.", prefix, env->avx10_version);
+    } else if (env->avx10_version) {
+        if (prefix) {
+            warn_report("%s: avx10.%d.", prefix, env->avx10_version);
+        }
         have_filtered_features = true;
     }
 
-- 
2.34.1


