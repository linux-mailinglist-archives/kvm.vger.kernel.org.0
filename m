Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E1D155D11
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 18:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgBGRms (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 12:42:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:13003 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbgBGRmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 12:42:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 09:42:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,414,1574150400"; 
   d="scan'208";a="312095672"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 07 Feb 2020 09:42:46 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/4] nVMX: 5-level nested EPT support
Date:   Fri,  7 Feb 2020 09:42:40 -0800
Message-Id: <20200207174244.6590-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for 5-level nested EPT and clean up the test for
MSR_IA32_VMX_EPT_VPID_CAP in the process.

Sean Christopherson (4):
  nVMX: Extend EPTP test to allow 5-level EPT
  nVMX: Refactor the EPT/VPID MSR cap check to make it readable
  nVMX: Mark bit 39 of MSR_IA32_VMX_EPT_VPID_CAP as reserved
  nVMX: Extend EPT cap MSR test to allow 5-level EPT

 x86/vmx.c       | 21 ++++++++++++++++++++-
 x86/vmx.h       |  4 +++-
 x86/vmx_tests.c | 12 ++++++++----
 3 files changed, 31 insertions(+), 6 deletions(-)

-- 
2.24.1

