Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1E4517EEDD
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 03:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgCJCwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 22:52:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:63496 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgCJCwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 22:52:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Mar 2020 19:52:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,535,1574150400"; 
   d="scan'208";a="235913626"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 09 Mar 2020 19:52:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] x86: Run unit tests with --no-reboot so shutdowns show up as failures
Date:   Mon,  9 Mar 2020 19:52:49 -0700
Message-Id: <20200310025249.30961-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Run tests with --no-reboot so that triple fault shutdowns get reported
as failures.  By default, Qemu automatically reboots on shutdown, i.e.
automatically restarts the test, eventually leading to a timeout.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

I don't think there are any tests would run afoul of --no-reboot?

 x86/run | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/run b/x86/run
index 1ac91f1..8b2425f 100755
--- a/x86/run
+++ b/x86/run
@@ -37,7 +37,7 @@ else
 	pc_testdev="-device testdev,chardev=testlog -chardev file,id=testlog,path=msr.out"
 fi
 
-command="${qemu} -nodefaults $pc_testdev -vnc none -serial stdio $pci_testdev"
+command="${qemu} --no-reboot -nodefaults $pc_testdev -vnc none -serial stdio $pci_testdev"
 command+=" -machine accel=$ACCEL -kernel"
 command="$(timeout_cmd) $command"
 
-- 
2.24.1

