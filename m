Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E786918D9CC
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 21:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgCTUzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 16:55:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:32133 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgCTUzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 16:55:48 -0400
IronPort-SDR: 4+skPi2oEOS3ei/z9OvBHO2nCq7ok/DwO2lk5cDCSP4vzEqqABa1jhbVQdK5Smkmq4TtH3ZLr5
 y0jMvC3UHaOQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 13:55:48 -0700
IronPort-SDR: k63Yw4bPtgT+YBuHh+MJxAjvWHjVdNNfwZVQ81qJKqRh6votGSJ3hhUNlQ/nzHWY5z8d1z6lLO
 ALRcKWK64f6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="280543320"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 20 Mar 2020 13:55:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH 2/7] KVM: selftests: Fix cosmetic copy-paste error in vm_mem_region_move()
Date:   Fri, 20 Mar 2020 13:55:41 -0700
Message-Id: <20200320205546.2396-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320205546.2396-1-sean.j.christopherson@intel.com>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a copy-paste typo in a comment and error message.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 0cf98ad59e32..8a3523d4434f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -764,7 +764,7 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags)
  * Input Args:
  *   vm - Virtual Machine
  *   slot - Slot of the memory region to move
- *   flags - Starting guest physical address
+ *   new_gpa - Starting guest physical address
  *
  * Output Args: None
  *
@@ -784,7 +784,7 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
 	ret = ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION, &region->region);
 
 	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION failed\n"
-		    "ret: %i errno: %i slot: %u flags: 0x%lx",
+		    "ret: %i errno: %i slot: %u new_gpa: 0x%lx",
 		    ret, errno, slot, new_gpa);
 }
 
-- 
2.24.1

