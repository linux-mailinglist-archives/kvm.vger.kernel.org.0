Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0ACC783904
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 07:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjHVFG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 01:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbjHVFGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 01:06:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D992FCC3;
        Mon, 21 Aug 2023 22:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692680749; x=1724216749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BI0wCz5Y1/hfopD6qA0qFJQF81Z7fbGbcwe5ACKj33k=;
  b=UPxsxOltBRuamvcFkUYpPKNWlqsoo9itgsBmsK5N3rU1011ajyE3okon
   SmLxGWeFeDNrFJHhAuCVSH1z9AMmz8xrqcOkwkpmGEhMuTolX+jEvfCpR
   Kz1zSDLJ5H+7kbaPoPNJhy9pN1J6lJOPnW4+B0zaQQTnSJTaAvqi8yFYx
   HV6axaCDe06TM/lRqZfZrCd8A43aM9eJq90Y4OH6j/kCICjFSv1b3siiA
   K7uJbrTudPWUnGTgQeFhGrjRbAP7YqqY/3so+kynILcEgCCWVKqizf77R
   EL8qFvrAgT1FqQ5VfaJ6vua3imlu4y6ABKsn7/vXnQp7w6FSvf1zUfado
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="440146569"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="440146569"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 22:04:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="982736777"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="982736777"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga006.fm.intel.com with ESMTP; 21 Aug 2023 22:04:21 -0700
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH RFC v3 06/13] perf/x86: Fix typos and inconsistent indents in perf_event header
Date:   Tue, 22 Aug 2023 13:11:33 +0800
Message-Id: <20230822051140.512879-7-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230822051140.512879-1-dapeng1.mi@linux.intel.com>
References: <20230822051140.512879-1-dapeng1.mi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is one typo and some inconsistent indents in perf_event.h header
file. Fix them.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/perf_event.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 85a9fd5a3ec3..63e1ce1f4b27 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -386,15 +386,15 @@ static inline bool is_topdown_idx(int idx)
  *
  * With this fake counter assigned, the guest LBR event user (such as KVM),
  * can program the LBR registers on its own, and we don't actually do anything
- * with then in the host context.
+ * with them in the host context.
  */
-#define INTEL_PMC_IDX_FIXED_VLBR	(GLOBAL_STATUS_LBRS_FROZEN_BIT)
+#define INTEL_PMC_IDX_FIXED_VLBR		(GLOBAL_STATUS_LBRS_FROZEN_BIT)
 
 /*
  * Pseudo-encoding the guest LBR event as event=0x00,umask=0x1b,
  * since it would claim bit 58 which is effectively Fixed26.
  */
-#define INTEL_FIXED_VLBR_EVENT	0x1b00
+#define INTEL_FIXED_VLBR_EVENT			0x1b00
 
 /*
  * Adaptive PEBS v4
-- 
2.34.1

