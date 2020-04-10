Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EACCD1A4C8F
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 01:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbgDJXRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 19:17:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:20816 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726789AbgDJXRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 19:17:12 -0400
IronPort-SDR: AG88i3JDq6VKZClTOYHC+FRr6LzTja/YgtVpTvQ9Dts8QHIxrIpnz50JRdrq53VchLnsUl0roi
 HxCmNAaT2vjA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 16:17:12 -0700
IronPort-SDR: yi/ATni0nkUPVWHDKuOdVmgO/RcaHa+XF3OXnqXR5HKUHcqjTG3UDMmrse05jdpox6liMxnaUC
 Zyg+rRHTUegw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,368,1580803200"; 
   d="scan'208";a="452542244"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 10 Apr 2020 16:17:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: [PATCH 07/10] selftests: kvm: Add vm_get_fd() in kvm_util
Date:   Fri, 10 Apr 2020 16:17:04 -0700
Message-Id: <20200410231707.7128-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200410231707.7128-1-sean.j.christopherson@intel.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wainer dos Santos Moschetta <wainersm@redhat.com>

Introduces the vm_get_fd() function in kvm_util which returns
the VM file descriptor.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 1 +
 tools/testing/selftests/kvm/lib/kvm_util.c     | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index e38d91bd8ec1..53b11d725d81 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -256,6 +256,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm);
 unsigned int vm_get_page_size(struct kvm_vm *vm);
 unsigned int vm_get_page_shift(struct kvm_vm *vm);
 unsigned int vm_get_max_gfn(struct kvm_vm *vm);
+int vm_get_fd(struct kvm_vm *vm);
 
 unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
 unsigned int vm_num_host_pages(enum vm_guest_mode mode, unsigned int num_guest_pages);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ab5b7ea60f4b..33ab0a36d230 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1739,6 +1739,11 @@ unsigned int vm_get_max_gfn(struct kvm_vm *vm)
 	return vm->max_gfn;
 }
 
+int vm_get_fd(struct kvm_vm *vm)
+{
+	return vm->fd;
+}
+
 static unsigned int vm_calc_num_pages(unsigned int num_pages,
 				      unsigned int page_shift,
 				      unsigned int new_page_shift,
-- 
2.26.0

