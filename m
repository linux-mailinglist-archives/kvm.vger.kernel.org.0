Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D71ABDCF
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 18:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390581AbfIFQex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 12:34:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:9378 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390383AbfIFQew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 12:34:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 09:34:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,473,1559545200"; 
   d="scan'208";a="174327233"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 06 Sep 2019 09:34:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Evgeny Yakovlev <wrfsh@yandex-team.ru>
Subject: [kvm-unit-tests PATCH 3/3] x86: Bump max number of test CPUs to 255
Date:   Fri,  6 Sep 2019 09:34:50 -0700
Message-Id: <20190906163450.30797-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190906163450.30797-1-sean.j.christopherson@intel.com>
References: <20190906163450.30797-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The max number of CPUs is not actually enforced anywhere, e.g. manually
setting '-smp 240' when running a unit test will cause random corruption
and hangs during smp initialization.  Increase the max number of test
CPUs to 255, which is the true max kvm-unit-tests can support without
significant changes, e.g. it would need to boot with x2APIC enabled,
support interrupt remapping, etc...

There is no known use case for running with more than 64 CPUs, but the
cost of supporting 255 is minimal, e.g. increases the size of each test
binary by a few kbs and burns a few extra cycles in init_apic_map().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 lib/x86/apic-defs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/x86/apic-defs.h b/lib/x86/apic-defs.h
index 7107f0f..b2014de 100644
--- a/lib/x86/apic-defs.h
+++ b/lib/x86/apic-defs.h
@@ -6,7 +6,7 @@
  * both in C and ASM
  */
 
-#define MAX_TEST_CPUS (64)
+#define MAX_TEST_CPUS (255)
 
 /*
  * Constants for various Intel APICs. (local APIC, IOAPIC, etc.)
-- 
2.22.0

