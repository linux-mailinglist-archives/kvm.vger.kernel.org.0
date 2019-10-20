Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD7ADDD80
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2019 11:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfJTJ0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Oct 2019 05:26:05 -0400
Received: from mga12.intel.com ([192.55.52.136]:39083 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfJTJ0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Oct 2019 05:26:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Oct 2019 02:26:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,319,1566889200"; 
   d="scan'208";a="348494023"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.57])
  by orsmga004.jf.intel.com with ESMTP; 20 Oct 2019 02:26:02 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] Minor cleanup and refactor about vmcs
Date:   Sun, 20 Oct 2019 17:10:57 +0800
Message-Id: <20191020091101.125516-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no functional changs, just some cleanup and renaming to increase
readability.

Patch 1 is newly added from v2.
Patcd 2 and 3 is seperated from Patch 4.

Xiaoyao Li (4):
  KVM: VMX: Write VPID to vmcs when creating vcpu
  KVM: VMX: Remove vmx->hv_deadline_tsc initialization from
    vmx_vcpu_setup()
  KVM: VMX: Initialize vmx->guest_msrs[] right after allocation
  KVM: VMX: Rename {vmx,nested_vmx}_vcpu_setup()

 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/nested.h |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 50 +++++++++++++++++++--------------------
 3 files changed, 26 insertions(+), 28 deletions(-)

-- 
2.19.1

