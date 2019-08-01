Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D72C7E457
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 22:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbfHAUfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 16:35:25 -0400
Received: from mga05.intel.com ([192.55.52.43]:47474 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbfHAUfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 16:35:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 13:35:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="191701850"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 01 Aug 2019 13:35:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: x86/mmu: minor MMIO SPTE cleanup
Date:   Thu,  1 Aug 2019 13:35:20 -0700
Message-Id: <20190801203523.5536-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A few loosely related MMIO SPTE patches to get rid of a bit of cruft that
has been a source of annoyance when mucking around in the MMIO code.

No functional changes intended.

Sean Christopherson (3):
  KVM: x86: Rename access permissions cache member in struct
    kvm_vcpu_arch
  KVM: x86/mmu: Add explicit access mask for MMIO SPTEs
  KVM: x86/mmu: Consolidate "is MMIO SPTE" code

 Documentation/virtual/kvm/mmu.txt |  4 ++--
 arch/x86/include/asm/kvm_host.h   |  2 +-
 arch/x86/kvm/mmu.c                | 31 +++++++++++++++++--------------
 arch/x86/kvm/mmu.h                |  2 +-
 arch/x86/kvm/vmx/vmx.c            |  2 +-
 arch/x86/kvm/x86.c                |  2 +-
 arch/x86/kvm/x86.h                |  2 +-
 7 files changed, 24 insertions(+), 21 deletions(-)

-- 
2.22.0

