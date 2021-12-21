Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D69747C159
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 15:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238397AbhLUOUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 09:20:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:4778 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238398AbhLUOUJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 09:20:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640096409; x=1671632409;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=X7GNZlTkvIGQw0fuJkvlzEC/Nbnciq94vmISIgk9dJw=;
  b=INSV27ukpK6xBmSwndhf1QWfdtxAT5ST3q9r6XQ6SC0CdO0mq4YP2k9R
   dl20vKgjv4HDuv0LKF7IbbNNtVXRFCB3IPF0cKpLbnE0jB1duboOGviiW
   JBwX36s2GphCfyYBRdmQ+2XACe5RNmm19x3+E/zDWioHxKHt6TYxueIIq
   dYMwlNXWLHtg6tHaRvOFB9Y/JttoB9neXBs404gLvME/qrxM5szpv5EnF
   rHDChDqTEorRiWu9C6D95QKzYqeZM6H+pjhKFfx15x1Pjyhlcd1t5WhC4
   GD2c5B+35OrTkI0lebq8VVaZvgniRBAkYXmxQo1SLksn8HlZ6DfiKSbwL
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="227693646"
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="227693646"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 06:20:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="466312322"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 21 Dec 2021 06:20:06 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH 0/3] AMX KVM selftest
Date:   Tue, 21 Dec 2021 18:15:04 -0500
Message-Id: <20211221231507.2910889-1-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Please help review this patchset, which is based on Jing's AMX v2.
https://lore.kernel.org/all/20211217153003.1719189-1-jing2.liu@intel.com/

Hope this patchset will be merged into Jing's v3 for further review. 

About this selftest requirement, please check below link:
https://lore.kernel.org/all/85401305-2c71-e57f-a01e-4850060d300a@redhat.com/

By the way, this amx_test.c file referenced Chang's older test code:
https://lore.kernel.org/lkml/20210221185637.19281-21-chang.seok.bae@intel.com/


Thanks!

Yang



Paolo Bonzini (1):
  selftest: kvm: Reorder vcpu_load_state steps for AMX

Yang Zhong (2):
  selftest: Move struct kvm_x86_state to header
  selftest: Support amx selftest

 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |  16 +-
 .../selftests/kvm/lib/x86_64/processor.c      |  44 +--
 tools/testing/selftests/kvm/x86_64/amx_test.c | 370 ++++++++++++++++++
 4 files changed, 401 insertions(+), 30 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/amx_test.c

