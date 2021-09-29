Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7E541C25C
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 12:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245335AbhI2KN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 06:13:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:28996 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245274AbhI2KN5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 06:13:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="247430447"
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="247430447"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 03:12:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,332,1624345200"; 
   d="scan'208";a="707211675"
Received: from zhangyu-optiplex-7040.bj.intel.com ([10.238.154.154])
  by fmsmga006.fm.intel.com with ESMTP; 29 Sep 2021 03:12:12 -0700
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: [PATCH v2 0/2] Cleanups for pointer usages in nVMX.
Date:   Thu, 30 Sep 2021 01:51:52 +0800
Message-Id: <20210929175154.11396-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace usages of "-1ull" with INVALID_GPA. And reset the vmxon_ptr
when emulating vmxoff.

v2:
  Added patch to replace usages of "-1ull" with INVALID_GPA.

Vitaly Kuznetsov (1):
  KVM: nVMX: Reset vmxon_ptr upon VMXOFF emulation.

Yu Zhang (1):
  KVM: nVMX: Use INVALID_GPA for pointers used in nVMX.

 arch/x86/kvm/vmx/nested.c | 61 ++++++++++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.c    |  5 ++--
 2 files changed, 34 insertions(+), 32 deletions(-)

-- 
2.25.1

