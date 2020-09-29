Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A0C27D3C5
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 18:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgI2Qn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 12:43:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:65283 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728315AbgI2Qn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 12:43:29 -0400
IronPort-SDR: TgVse+CqN8WTUbYoX2oWQP0RAUkv3u4WPlyb/zIfkNYuaRoBhXeAbVBjOc5el0mkfM5PTyyH6o
 BfIbxj0vHEVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="180392441"
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="180392441"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 09:43:27 -0700
IronPort-SDR: fWyAFBIHyQ+wveHnIpO07eZ8pdmmeKuVx3G+F1bLuBLj8A6D8XnWUTidxZ3y4ZGuGWZggCk37K
 DkrtLv9mjK3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,319,1596524400"; 
   d="scan'208";a="293723386"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga007.fm.intel.com with ESMTP; 29 Sep 2020 09:43:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH] x86: Make Hyper-V tests x86_64 only
Date:   Tue, 29 Sep 2020 09:43:25 -0700
Message-Id: <20200929164325.30605-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Skip the Hyper-V tests on i386, they explicitly run with kvm64 and crash
immediately when run in i386, i.e. waste 90 seconds waiting for the
timeout to fire.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/unittests.cfg | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 3a79151..0651778 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -314,18 +314,21 @@ arch = x86_64
 file = hyperv_synic.flat
 smp = 2
 extra_params = -cpu kvm64,hv_vpindex,hv_synic -device hyperv-testdev
+arch = x86_64
 groups = hyperv
 
 [hyperv_connections]
 file = hyperv_connections.flat
 smp = 2
 extra_params = -cpu kvm64,hv_vpindex,hv_synic -device hyperv-testdev
+arch = x86_64
 groups = hyperv
 
 [hyperv_stimer]
 file = hyperv_stimer.flat
 smp = 2
 extra_params = -cpu kvm64,hv_vpindex,hv_time,hv_synic,hv_stimer -device hyperv-testdev
+arch = x86_64
 groups = hyperv
 
 [hyperv_clock]
-- 
2.28.0

