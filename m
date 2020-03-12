Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B026183D4A
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 00:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgCLX1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 19:27:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:14954 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbgCLX1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 19:27:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 16:27:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261705926"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 16:27:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/8] nVMX: Clean up __enter_guest() and co.
Date:   Thu, 12 Mar 2020 16:27:37 -0700
Message-Id: <20200312232745.884-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Start chipping away at the crustiness in the nVMX tests by refactoring
"struct vmentry_failure" into "struct vmentry_result", with the full
VM-Exit stored in vmentry_result.  Capturing the exit reason allows for a
variety of cleanups and consolidations.

This series really only dives into the v1 tests.  I'd like to also clean
up the v2 tests, e.g. take the expected exit reason in enter_guest() so
that the expected behavior is more obvious, but that's a more invasive
cleanup for another day.

Sean Christopherson (8):
  nVMX: Eliminate superfluous entry_failure_handler() wrapper
  nVMX: Refactor VM-Entry "failure" struct into "result"
  nVMX: Consolidate non-canonical code in test_canonical()
  nVMX: Drop redundant check for guest termination
  nVMX: Expose __enter_guest() and consolidate guest state test code
  nVMX: Pass exit reason union to v1 exit handlers
  nVMX: Pass exit reason union to is_hypercall()
  nVMX: Pass exit reason enum to print_vmexit_info()

 x86/vmx.c       | 191 +++++++++++--------------
 x86/vmx.h       |  50 +++++--
 x86/vmx_tests.c | 366 +++++++++++++++++++-----------------------------
 3 files changed, 263 insertions(+), 344 deletions(-)

-- 
2.24.1

