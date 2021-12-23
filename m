Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2774447DED5
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 06:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346493AbhLWF7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 00:59:04 -0500
Received: from mga18.intel.com ([134.134.136.126]:19252 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346485AbhLWF7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 00:59:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640239142; x=1671775142;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YO/ErCxPCsln7lq66uXQgQMsjQYnX24IqwEvfZWJYFc=;
  b=fQPp+2rM/BAppMg1MD5uScSvjUXA/iLefarrUYpTTq4U2LioexM9H5b3
   X8T2+g4rsJZg3L+DSksAM7f5w04TP8VzS7Vk5bj8EHusuolXbaDxSGC0n
   3upP3FNGCGhBPTMPmZXjuhgKxeDf7p3CxG8x948pfk4CDJ9wxfFYdolJG
   3OOs73Nofk8D4JuQoQnaEno9M8dEVkCwdvX3x8gS8LKiopcDYHCeiNtHp
   QEMWPpa7TRWd91VV3asE/mhNM9TNF2s+hHs4xfpbhx6bwhNsw6bBboJwS
   ftzKgvc/zvp8CbjRCOTUYoWENiDq3F8eoupbuVaYgERpOGMW3Mgot/jUu
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="227608831"
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="227608831"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 21:59:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="468423732"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga006.jf.intel.com with ESMTP; 22 Dec 2021 21:59:00 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH v3 0/3] AMX KVM selftest
Date:   Thu, 23 Dec 2021 09:53:19 -0500
Message-Id: <20211223145322.2914028-1-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Please help review this patchset, which is rebased on Jing's AMX v3.
https://lore.kernel.org/all/20211222124052.644626-1-jing2.liu@intel.com/

About this selftest requirement, please check below link:
https://lore.kernel.org/all/85401305-2c71-e57f-a01e-4850060d300a@redhat.com/

By the way, this amx_test.c file referenced some Chang's older test code:
https://lore.kernel.org/lkml/20210221185637.19281-21-chang.seok.bae@intel.com/


Thanks!

Yang


Change history
==============
v2-->v3:
   - Removed the skip "regs->rip += 3", enable amx in #NM handler(Paolo).

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
 .../selftests/kvm/lib/x86_64/processor.c      |  32 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c | 448 ++++++++++++++++++
 4 files changed, 473 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/amx_test.c

