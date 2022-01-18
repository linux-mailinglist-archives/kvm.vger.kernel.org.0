Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2124927EA
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 15:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244523AbiAROBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 09:01:46 -0500
Received: from mga05.intel.com ([192.55.52.43]:21745 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243931AbiAROBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 09:01:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642514505; x=1674050505;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AhDLteH7a+mtrXjsjZwZgK9xaQ+7sAHzctj6XyQwxAQ=;
  b=kpzZUUzlrTMOYZ6/Z0Vf5WlXj9U0hZ0FDElIc2ITM+xnHpjDtKHlMCjB
   g3ztQenJqAaaiM/+U/ejXnXAYOu95BUdi0bX7hgwYD0iYfnANLcyWCF5T
   wsQQiqYFvk3SlXYRKlDGh1uCJAbnTgwUG8743v2iRXUX5Y/TY8WJkk1AF
   +YLInGziGr9EM74J6t+49LfdLBW2OLUEpIDJU42vlaUUQNu6pXglSY3JP
   1xfds9drExUtdfE7J0EZbAOotApQg7cXaHlv8YQ8DfMP6WsKcrwkwDEDV
   /kw+k3Et+SrGpckOy2T34/sEb/s1NT9pU2eyDbQxwJ2Nv3NxXDmKx+apE
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="331169015"
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="331169015"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 06:01:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="530299051"
Received: from 984fee00bf64.jf.intel.com ([10.165.54.77])
  by fmsmga007.fm.intel.com with ESMTP; 18 Jan 2022 06:01:45 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yang.zhong@intel.com
Subject: [PATCH 0/2] kvm selftest cleanup
Date:   Tue, 18 Jan 2022 06:01:42 -0800
Message-Id: <20220118140144.58855-1-yang.zhong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 1 to sync KVM_CAP_XSAVE2 to 208, and patch 2 only cleanup
processor.c file with tabs as Sean requested before. Those two
patches were based on latest Linux release(commit id: e3a8b6a1e70c).

Yang Zhong (2):
  kvm: selftests: Sync KVM_CAP_XSAVE2 from linux header
  kvm: selftests: Use tabs to replace spaces

 tools/include/uapi/linux/kvm.h                |  2 +-
 .../selftests/kvm/lib/x86_64/processor.c      | 70 +++++++++----------
 2 files changed, 36 insertions(+), 36 deletions(-)

