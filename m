Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4142552A2C3
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 15:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347214AbiEQNKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 09:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbiEQNK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 09:10:28 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DB03526C;
        Tue, 17 May 2022 06:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652793027; x=1684329027;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1nPBQlk1v0spoAKW3hSYWBBd7Hx4xf2A2nxLzd0Qt44=;
  b=L/J/iUliUtVzMk0MZT1OvXnLD/k6FBVA240ycFVKdRT97IIKNrBEEEml
   VGCPK+SwZx0jTCkrQ3c/Z9z8l9wb0Y58bIXD2veuvHSVZKk+0lZWJPBmm
   myUTRUvZP+qichDbQF3bTpYKwdCfljK20Hqhpgpie2Be4GZk9bi1bLZDf
   Od1LLz5FksL0lYaZSnzYBxoJ6nfpRPy8ZZNthDUZMndoJ4LlIbi1TRB57
   ScGjnRZx2ooHKGzUmEGLPv+ThynycWvnnbPGlovE11slNlCT1V4947ti6
   C7vaaWCg0lX7PX4pTo9qbunSBsIYdE48/zI3/1gzqBdwPmvyD3NFuRTYJ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="271300094"
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="271300094"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 06:10:27 -0700
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="713844207"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.52.217])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 06:10:24 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Leo Yan <leo.yan@linaro.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH V2 0/6] perf intel-pt: Add support for tracing KVM test programs
Date:   Tue, 17 May 2022 16:10:05 +0300
Message-Id: <20220517131011.6117-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi

A common case for KVM test programs is that the guest object code can be
found in the hypervisor process (i.e. the test program running on the
host).  Add support for that.

For some more details refer the 3rd patch "perf tools: Add guest_code
support"

For an example, see the last patch "perf intel-pt: Add guest_code support"

For more information about Perf tools support for Intel® Processor Trace
refer:

  https://perf.wiki.kernel.org/index.php/Perf_tools_support_for_Intel%C2%AE_Processor_Trace


Changes in V2:
	Add more explanation to commits, comments and documentation.


Adrian Hunter (6):
      perf tools: Add machine to machines back pointer
      perf tools: Factor out thread__set_guest_comm()
      perf tools: Add guest_code support
      perf script: Add guest_code support
      perf kvm report: Add guest_code support
      perf intel-pt: Add guest_code support

 tools/perf/Documentation/perf-intel-pt.txt |  70 ++++++++++++++++++++
 tools/perf/Documentation/perf-kvm.txt      |   3 +
 tools/perf/Documentation/perf-script.txt   |   4 ++
 tools/perf/builtin-kvm.c                   |   2 +
 tools/perf/builtin-script.c                |   5 +-
 tools/perf/util/event.c                    |   7 +-
 tools/perf/util/intel-pt.c                 |  20 +++++-
 tools/perf/util/machine.c                  | 101 ++++++++++++++++++++++++++++-
 tools/perf/util/machine.h                  |   4 ++
 tools/perf/util/session.c                  |   7 ++
 tools/perf/util/symbol_conf.h              |   3 +-
 11 files changed, 217 insertions(+), 9 deletions(-)


Regards
Adrian
