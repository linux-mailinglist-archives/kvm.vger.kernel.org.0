Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7942B19C692
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 17:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389325AbgDBP4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 11:56:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:50591 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389618AbgDBP4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 11:56:51 -0400
IronPort-SDR: Bg/mpS8NduwrtGlxKS1TB2XNC7o3imN/846LvE3avKky3cYU75ab9SobGeBXHf3xeG1XVl4ZKp
 CpwGIfDbJzDQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2020 08:56:49 -0700
IronPort-SDR: jyOiuXukMJhwojIPNuzpfJ9nU3RopoRR/yNMidbUYgAtGsQVDkUlYbJPSk/0GofpqJEnUBPx+z
 dZ40IbSFVtFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,336,1580803200"; 
   d="scan'208";a="396413079"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 02 Apr 2020 08:56:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     x86@kernel.org, "Kenneth R . Crudup" <kenny@panix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Nadav Amit <namit@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] x86: KVM: VMX: Add basic split-lock #AC handling
Date:   Thu,  2 Apr 2020 08:55:51 -0700
Message-Id: <20200402155554.27705-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200402124205.334622628@linutronix.de>
References: <20200402124205.334622628@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

First three patches from Xiaoyao's series to add split-lock #AC support
in KVM.

Xiaoyao Li (3):
  KVM: x86: Emulate split-lock access as a write in emulator
  x86/split_lock: Refactor and export handle_user_split_lock() for KVM
  KVM: VMX: Extend VMX's #AC interceptor to handle split lock #AC in
    guest

 arch/x86/include/asm/cpu.h  |  4 ++--
 arch/x86/kernel/cpu/intel.c |  7 ++++---
 arch/x86/kernel/traps.c     |  2 +-
 arch/x86/kvm/vmx/vmx.c      | 30 +++++++++++++++++++++++++++---
 arch/x86/kvm/x86.c          | 12 +++++++++++-
 5 files changed, 45 insertions(+), 10 deletions(-)

-- 
2.24.1

