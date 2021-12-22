Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB4C47D27B
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 13:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244924AbhLVMwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 07:52:20 -0500
Received: from mga14.intel.com ([192.55.52.115]:12132 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241182AbhLVMwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 07:52:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640177538; x=1671713538;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Qgvf8YfdsiKA1xXvNM3v6ydz1CebkL0punWobt6VX7E=;
  b=DzWZyeIgppHigURwBD9BUAWgmcQ9PXGbFRcD7vd+gEQ41t4C8DtvLqtI
   RKhHRXixvxgk2CwC9x5Tcg0H5EQ7lNZCcDAaJzKFxqz7l+Qs+2C8tgPYV
   4NzaFtNrtEo009Rq5LXWpOb09KDaf/I9an1rOMPhwNm9KhJhsK/2O1O4R
   WO0+7kw9KEFyJWHShjWLCpzw0DHYhEZf84IPWCnAsVleauwpqyx8BV+vR
   AJzQ1GUV8OKZiJLjhwUfiew5CEqg1MOoeLI9vnm0719QbofyBjZKEr/vT
   +OuVvMZG8zldoAPX778RZ/OlX0smmRTLA3OUSAQXMbFprtT4wsIeDW69/
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240834724"
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="240834724"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 04:52:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="549315007"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga001.jf.intel.com with ESMTP; 22 Dec 2021 04:52:16 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH v2 0/3] AMX KVM selftest
Date:   Wed, 22 Dec 2021 16:47:28 -0500
Message-Id: <20211222214731.2912361-1-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Please help review this patchset, which is still based on Jing's AMX v2.
https://lore.kernel.org/all/20211217153003.1719189-1-jing2.liu@intel.com/

Since Jing's v3 was justly sent out, I will rebase this patchest on it and send my
separate v3.

About this selftest requirement, please check below link:
https://lore.kernel.org/all/85401305-2c71-e57f-a01e-4850060d300a@redhat.com/

By the way, this amx_test.c file referenced some Chang's older test code:
https://lore.kernel.org/lkml/20210221185637.19281-21-chang.seok.bae@intel.com/

Thanks!

Yang


Change history
==============
v1-->v2
   - Added more GUEST_SYNC() from guest code(Paolo).
   - Added back save/restore code after GUEST_SYNC()
     handles in the main()(Paolo).

Paolo Bonzini (1):
  selftest: kvm: Reorder vcpu_load_state steps for AMX

Yang Zhong (2):
  selftest: kvm: Move struct kvm_x86_state to header
  selftest: kvm: Support amx selftest

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |  16 +-
 .../selftests/kvm/lib/x86_64/processor.c      |  44 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c | 451 ++++++++++++++++++
 4 files changed, 482 insertions(+), 30 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/amx_test.c

