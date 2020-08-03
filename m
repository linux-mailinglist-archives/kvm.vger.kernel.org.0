Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510A623A479
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 14:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgHCM11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 08:27:27 -0400
Received: from 8bytes.org ([81.169.241.247]:34650 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728530AbgHCM1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 08:27:24 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id E244D423; Mon,  3 Aug 2020 14:27:21 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] KVM: SVM: SEV-ES groundwork
Date:   Mon,  3 Aug 2020 14:27:04 +0200
Message-Id: <20200803122708.5942-1-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

here is v3 of the  groundwork patches for the upcoming SEV-ES support in
the Linux kernel. They are part of both the client patch-set and the
KVM hypervisor patches (under development).

Patch 1 necesary to fix a compile warning about a stack-frame getting
too large. The other 3 patches define the Guest Hypervisor
Communication Block (GHCB) and accessor functions.

This version addresses the review comments from Sean.

It would be great if you could consider them for v5.9, so that the
client and the hypervisor patch-sets can be developed more independently
of each other.

Please let me know what you think.

Regards,

	Joerg

Borislav Petkov (1):
  KVM: SVM: Use __packed shorthand

Joerg Roedel (2):
  KVM: SVM: nested: Don't allocate VMCB structures on stack
  KVM: SVM: Add GHCB Accessor functions

Tom Lendacky (1):
  KVM: SVM: Add GHCB definitions

 arch/x86/include/asm/svm.h | 100 ++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/svm/nested.c  |  47 +++++++++++------
 arch/x86/kvm/svm/svm.c     |   2 +
 3 files changed, 128 insertions(+), 21 deletions(-)

-- 
2.17.1

