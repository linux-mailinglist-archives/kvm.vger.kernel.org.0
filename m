Return-Path: <kvm+bounces-5496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D676B822770
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 04:12:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC3C0B218CA
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 03:12:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A5C18E21;
	Wed,  3 Jan 2024 03:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ID6m0ohx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7DD18E00;
	Wed,  3 Jan 2024 03:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704251391; x=1735787391;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lWYg4zV2NcJ4nxhSpA6Fg/s1u8gQGW0XjbSleu1w/Jo=;
  b=ID6m0ohxfEQNdo11ngGMnYKGDk++nSIzSxrOHOJm9WZSZNC1ZgI3+KjH
   0iEJnBRVRpapdvZ2AYnqQ/R3RuWK5kg6tyEDBIGMZDLotVGLkPjH551A6
   FacB5ciBdIEYCOpR5nIxeTi09vug/iat+ozGSPr+XYfa9b8RD7t112dfX
   VsLW4sWRrZ+cV1GJXJdPD09naavbJDVq4Nkea8SGyYcAZFsE6kFCAO3m8
   Z6VLft4ZEHSAAXP978vuIrYwnW5kDoiBobS0jlfZAb9uCBHw4N0kiZj7v
   JAarTI3Fn8KKRuYppgExAjwWkhnBseC/UhtZ8YpipO/6XzldT9ZsTaR0R
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="10343149"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="10343149"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 19:09:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="729665948"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="729665948"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by orsmga003.jf.intel.com with ESMTP; 02 Jan 2024 19:09:47 -0800
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Mingwei Zhang <mizhang@google.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch v3 06/11] x86: pmu: Remove blank line and redundant space
Date: Wed,  3 Jan 2024 11:14:04 +0800
Message-Id: <20240103031409.2504051-7-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

code style changes.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index a2c64a1ce95b..46bed66c5c9f 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -207,8 +207,7 @@ static noinline void __measure(pmu_counter_t *evt, uint64_t count)
 static bool verify_event(uint64_t count, struct pmu_event *e)
 {
 	// printf("%d <= %ld <= %d\n", e->min, count, e->max);
-	return count >= e->min  && count <= e->max;
-
+	return count >= e->min && count <= e->max;
 }
 
 static bool verify_counter(pmu_counter_t *cnt)
-- 
2.34.1


