Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF35164D45
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 19:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgBSSDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 13:03:51 -0500
Received: from mga18.intel.com ([134.134.136.126]:17830 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbgBSSDv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 13:03:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 10:03:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,461,1574150400"; 
   d="scan'208";a="436312510"
Received: from gza.jf.intel.com ([10.54.75.28])
  by fmsmga006.fm.intel.com with ESMTP; 19 Feb 2020 10:03:50 -0800
From:   John Andersen <john.s.andersen@intel.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     John Andersen <john.s.andersen@intel.com>
Subject: [PATCH 0/1] Paravirtualized control register pinning test
Date:   Wed, 19 Feb 2020 10:04:35 -0800
Message-Id: <20200219180436.6580-1-john.s.andersen@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the corresponding test for
https://lore.kernel.org/kvm/20200218215902.5655-1-john.s.andersen@intel.com/T/#t

Thank you!

John Andersen (1):
  x86: Add control register pinning test

 x86/Makefile.common |   3 +-
 lib/x86/desc.h      |   1 +
 lib/x86/processor.h |   1 +
 lib/x86/desc.c      |   8 +++
 x86/cr_pin.c        | 163 ++++++++++++++++++++++++++++++++++++++++++++
 x86/pcid.c          |   8 ---
 x86/unittests.cfg   |   4 ++
 7 files changed, 179 insertions(+), 9 deletions(-)
 create mode 100644 x86/cr_pin.c

-- 
2.21.0

