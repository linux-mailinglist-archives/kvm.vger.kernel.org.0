Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84879367E52
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 12:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbhDVKGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 06:06:07 -0400
Received: from mga04.intel.com ([192.55.52.120]:61845 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230365AbhDVKGH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 06:06:07 -0400
IronPort-SDR: Ia94LpGtsiDT0kOxB8/UcjG4zHMPsIqwisy7b7lP0ujPVOmoLNZHgs4d61xfE4LCLDDK9bOEwj
 EEr9XbdjaRKA==
X-IronPort-AV: E=McAfee;i="6200,9189,9961"; a="193741589"
X-IronPort-AV: E=Sophos;i="5.82,242,1613462400"; 
   d="scan'208";a="193741589"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 03:05:32 -0700
IronPort-SDR: vU0Siz1iLObUsc/WZqlp80/j2Jo2IwJwF6jN2WgiPdpgjworQrGkWDAWaJws5ZAM9Q9wjUI0Pr
 vPFRONUyKh8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,242,1613462400"; 
   d="scan'208";a="421317100"
Received: from icx-2s.bj.intel.com ([10.240.192.119])
  by fmsmga008.fm.intel.com with ESMTP; 22 Apr 2021 03:05:31 -0700
From:   Yang Zhong <yang.zhong@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, yang.zhong@intel.com
Subject: [PATCH 0/2] Cleanup the registers read/write access
Date:   Thu, 22 Apr 2021 17:34:34 +0800
Message-Id: <20210422093436.78683-1-yang.zhong@intel.com>
X-Mailer: git-send-email 2.29.2.334.gfaefdd61ec
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM has defined the GP registers and pointer register access
methods in the ./arch/x86/kvm/kvm_cache_regs.h file, but there are
still some GP and pointer registers access using older style. We
should keep those registers access consistent in vmx and svm.

Yang Zhong (2):
  KVM: VMX: Keep registers read/write consistent with definition
  KVM: SVM: Keep registers read/write consistent with definition

 arch/x86/kvm/svm/nested.c |  2 +-
 arch/x86/kvm/svm/sev.c    | 65 ++++++++++++++++++++-------------------
 arch/x86/kvm/svm/svm.c    | 20 ++++++------
 arch/x86/kvm/vmx/vmx.c    | 11 ++++---
 4 files changed, 50 insertions(+), 48 deletions(-)

-- 
2.29.2.334.gfaefdd61ec

