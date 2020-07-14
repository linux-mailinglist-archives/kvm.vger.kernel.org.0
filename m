Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A5121E474
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 02:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgGNAX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 20:23:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:36936 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbgGNAX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 20:23:57 -0400
IronPort-SDR: oaOpJek9+Xia9ukedJ0paIbkoDgs3X7zv55BcmrTYj9SNJjErysOcS2j5cxISwf5XI3La3zxvB
 HNhuVfau1inQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="136910632"
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="136910632"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 17:23:56 -0700
IronPort-SDR: VlxafKPUXAubB0RJv5cEr74nJWQzIhtv3shcyhfJhPRunX7PwGH3GDzrPahdf0xbLkgav8te1y
 sCIJQz8YBBAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="268505771"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jul 2020 17:23:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Karl Heubaum <karl.heubaum@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [kvm-unit-tests PATCH 0/2] nVMX: Two PCIDE related fixes
Date:   Mon, 13 Jul 2020 17:23:53 -0700
Message-Id: <20200714002355.538-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PCIDE fixes for two completely unrelated tests that managed to combine
powers and create a super confusing error where the MTF test loads CR3
with 0 and sends things into the weeds.

Sean Christopherson (2):
  nVMX: Restore active host RIP/CR4 after test_host_addr_size()
  nVMX: Use the standard non-canonical value in test_mtf3

 x86/vmx_tests.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

-- 
2.26.0

