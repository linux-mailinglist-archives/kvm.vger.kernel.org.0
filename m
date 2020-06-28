Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E54120C722
	for <lists+kvm@lfdr.de>; Sun, 28 Jun 2020 10:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgF1Iv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Jun 2020 04:51:59 -0400
Received: from mga05.intel.com ([192.55.52.43]:43712 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbgF1Iv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Jun 2020 04:51:59 -0400
IronPort-SDR: 9nvc4uHs/HSIoyq7vyfj1wpEhWEcU/RTG16/n2KIsFnEdSD0bIUOU0eqlFmiLL2eg9ZrgZNxFi
 sD3LCgDsZmLA==
X-IronPort-AV: E=McAfee;i="6000,8403,9665"; a="230601060"
X-IronPort-AV: E=Sophos;i="5.75,291,1589266800"; 
   d="scan'208";a="230601060"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2020 01:51:59 -0700
IronPort-SDR: nQCCV7I8aGn72OajMvPuSjKq+toOWQBvs1aHn94Y4JekY0wc6B3vQDItKtKMDkeK5I6L5R01Uu
 EA8RaPFsdquw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,291,1589266800"; 
   d="scan'208";a="480457278"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jun 2020 01:51:57 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 0/2] Add support for bus lock VM exit
Date:   Sun, 28 Jun 2020 16:53:39 +0800
Message-Id: <20200628085341.5107-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This serial adds the support for bus lock VM exit, which is a
sub-feature of bus lock detection in KVM. The left part concerning bus
lock debug exception support will be sent out once the kernel part is
ready.

The first patch applies Sean's refactor to vcpu_vmx.exit_reason at
https://patchwork.kernel.org/patch/11500659
It is necessary as bus lock VM exit adds a new modifier bit(bit 26) in
exit_reason field in VMCS.

The second patch is the enabling work for bus lock VM exit.

Document for Bus Lock VM exit is now available at the latest "Intel
Architecture Instruction Set Extensions Programming Reference".

Document Link:
https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html

Chenyi Qiang (1):
  KVM: VMX: Enable bus lock VM exit

Sean Christopherson (1):
  KVM: VMX: Convert vcpu_vmx.exit_reason to a union

 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/include/asm/vmx.h         |  1 +
 arch/x86/include/asm/vmxfeatures.h |  1 +
 arch/x86/include/uapi/asm/vmx.h    |  4 +-
 arch/x86/kvm/vmx/nested.c          | 42 ++++++++++------
 arch/x86/kvm/vmx/vmx.c             | 81 ++++++++++++++++++------------
 arch/x86/kvm/vmx/vmx.h             | 25 ++++++++-
 arch/x86/kvm/x86.c                 |  1 +
 8 files changed, 107 insertions(+), 49 deletions(-)

-- 
2.17.1

