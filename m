Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760E7ABDCD
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 18:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390380AbfIFQev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 12:34:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:9378 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388260AbfIFQev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 12:34:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 09:34:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,473,1559545200"; 
   d="scan'208";a="174327224"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 06 Sep 2019 09:34:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Evgeny Yakovlev <wrfsh@yandex-team.ru>
Subject: [kvm-unit-tests PATCH 0/3] x86: Cleanup max test CPUs
Date:   Fri,  6 Sep 2019 09:34:47 -0700
Message-Id: <20190906163450.30797-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a bug Evgeny reported where init_apic_map() can cause random
corruption due accessing random bytes far beyond the bounds of
online_cpus.  Take the opportunity to bump the max number of test CPUs
to a realistic maximum, i.e. what kvm-unit-tests can support without a
major rework.

Sean Christopherson (3):
  x86: Fix out of bounds access when processing online_cpus
  x86: Declare online_cpus based on MAX_TEST_CPUS
  x86: Bump max number of test CPUs to 255

 lib/x86/apic-defs.h | 2 +-
 lib/x86/apic.c      | 4 ++--
 lib/x86/smp.c       | 2 --
 x86/cstart.S        | 2 +-
 x86/cstart64.S      | 2 +-
 5 files changed, 5 insertions(+), 7 deletions(-)

-- 
2.22.0

