Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74031CBB73
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 01:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgEHXxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 19:53:50 -0400
Received: from mga14.intel.com ([192.55.52.115]:30638 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728215AbgEHXxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 19:53:50 -0400
IronPort-SDR: CvwoTR473YLfXkwt8qVYuewsmoPvkSoJthdOlNFeYQqkcgY3OiYNbWtP+ozIbI2bJrWxsiGilH
 Kf8f5xNQWZBg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 16:53:50 -0700
IronPort-SDR: 0hlBtlpPBDYA9wedXf0KefbtWk3OA6bNE4/+M7ECX+/QyB2DxV7UobHHnCsLUf75RnJy1+uT3V
 lpG2rzCHheaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="264546902"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 08 May 2020 16:53:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: VMX: Fix and a cleanup for VM-Exit tracing
Date:   Fri,  8 May 2020 16:53:46 -0700
Message-Id: <20200508235348.19427-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix for a recently introduced bug where KVM no longer traces failed
VM-Enter, and a previously posted patch for printing symbolic names of
VM-Exit flags, e.g. the flag set on failed VM-Enter.

Sean Christopherson (2):
  KVM: VMX: Invoke kvm_exit tracepoint on VM-Exit due to failed VM-Enter
  KVM: x86: Print symbolic names of VMX VM-Exit flags in traces

 arch/x86/include/uapi/asm/vmx.h |  3 +++
 arch/x86/kvm/trace.h            | 32 +++++++++++++++++---------------
 arch/x86/kvm/vmx/vmx.c          |  4 ++--
 3 files changed, 22 insertions(+), 17 deletions(-)

-- 
2.26.0

