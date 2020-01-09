Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB6C13639B
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 00:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgAIXGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 18:06:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:54670 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbgAIXGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 18:06:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 15:06:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="396242471"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 09 Jan 2020 15:06:40 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>,
        Arvind Sankar <nivedita@alum.mit.edu>
Subject: [PATCH v2 0/2] KVM: x86/mmu: Optimize rsvd pte checks
Date:   Thu,  9 Jan 2020 15:06:38 -0800
Message-Id: <20200109230640.29927-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two patches to optimize the reserved bit and illegal EPT memtype/XWR
checks, and more importantly, clean up an undocumented, subtle bitwise-OR
in the code.

v2: Rewrite everything.

v1: https://lkml.kernel.org/r/20200108001859.25254-1-sean.j.christopherson@intel.com

Sean Christopherson (2):
  KVM: x86/mmu: Reorder the reserved bit check in
    prefetch_invalid_gpte()
  KVM: x86/mmu: Micro-optimize nEPT's bad memptype/XWR checks

 arch/x86/kvm/mmu/mmu.c         | 26 ++++++++++++++------------
 arch/x86/kvm/mmu/paging_tmpl.h | 23 +++++++++++++++++++----
 2 files changed, 33 insertions(+), 16 deletions(-)

-- 
2.24.1

