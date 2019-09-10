Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3375AAE889
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 12:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbfIJKmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 06:42:23 -0400
Received: from mga04.intel.com ([192.55.52.120]:64085 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbfIJKmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 06:42:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 03:42:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="196512133"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.44])
  by orsmga002.jf.intel.com with ESMTP; 10 Sep 2019 03:42:20 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Subject: [PATCH v2 0/2] KVM: CPUID: emulation flow adjustment and one minor refinement when updating maxphyaddr 
Date:   Tue, 10 Sep 2019 18:27:40 +0800
Message-Id: <20190910102742.47729-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 1 adjusts the execution flow of CPUID instruction emulation, which
checks the leaf number first per CPUID specification.

Patch 2 moves physical address width updating to where we check the virtual
address width in function kvm_update_cpuid() since they two use the same
cpuid leaf, which makes it more reasonable and no functional change.  

Xiaoyao Li (2):
  KVM: CPUID: Check limit first when emulating CPUID instruction
  KVM: CPUID: Put maxphyaddr updating together with virtual address
    width checking

 arch/x86/kvm/cpuid.c | 57 ++++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 23 deletions(-)

-- 
2.19.1

