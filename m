Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626EC27600A
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgIWSgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:36:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:62893 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgIWSgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:36:31 -0400
IronPort-SDR: pu1WlUPkEAIVm+sm7cktybZu5wOcnW59pPgT2MgJYtRAPptH1zevNzdRo5UrJDyHYWRNp98228
 r8oz/iwA83Zg==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="179071084"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="179071084"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:31:13 -0700
IronPort-SDR: XCE25CZx9o4roeAASR1hBUV0R6VuwmCg7XyrXto6zd0cgXxwq7xYvcXnJIe5iTekicSGWKLzN+
 NqFRKAB0dYQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="413082157"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga001.fm.intel.com with ESMTP; 23 Sep 2020 11:31:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 0/2] KVM: VMX: Super early file refactor for TDX
Date:   Wed, 23 Sep 2020 11:31:10 -0700
Message-Id: <20200923183112.3030-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename vmx/ops.h to vmx/vmx_ops.h, and move VMX's posted interrupt support
to dedicated files in preparation for future Trust Domain Extensions (TDX)
enabling.

These changes are somewhat premature, as full TDX enabling is months away,
but the posted interrupts change is (IMO) valuable irrespective of TDX.

The value of the vmx_ops.h rename without TDX is debatable.  I have no
problem deferring the change to the actual TDX series if there are
objections.  I'm submitting the patch now as getting the rename upstream
will save us minor merge conflict pain if there are changes to vmx/ops.h
between now and whenever the TDX enabling series comes along.

https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html

Sean Christopherson (1):
  KVM: VMX: Rename ops.h to vmx_ops.h

Xiaoyao Li (1):
  KVM: VMX: Extract posted interrupt support to separate files

 arch/x86/kvm/Makefile                 |   3 +-
 arch/x86/kvm/vmx/posted_intr.c        | 332 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/posted_intr.h        |  99 ++++++++
 arch/x86/kvm/vmx/vmx.c                | 321 +------------------------
 arch/x86/kvm/vmx/vmx.h                |  92 +------
 arch/x86/kvm/vmx/{ops.h => vmx_ops.h} |   0
 6 files changed, 440 insertions(+), 407 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/posted_intr.c
 create mode 100644 arch/x86/kvm/vmx/posted_intr.h
 rename arch/x86/kvm/vmx/{ops.h => vmx_ops.h} (100%)

-- 
2.28.0

