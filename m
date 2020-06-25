Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B30209B15
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 10:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390496AbgFYIDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 04:03:32 -0400
Received: from 8bytes.org ([81.169.241.247]:48804 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726930AbgFYIDc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 04:03:32 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 8E7BF36D; Thu, 25 Jun 2020 10:03:30 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 0/4] KVM: SVM: Code move follow-up
Date:   Thu, 25 Jun 2020 10:03:21 +0200
Message-Id: <20200625080325.28439-1-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

here is small series to follow-up on the review comments for moving
the kvm-amd module code to its own sub-directory. The comments were
only about renaming structs and symbols, so there are no functional
changes in these patches.

The comments addressed here are all from [1].

Regards,

	Joerg

[1] https://lore.kernel.org/lkml/87d0917ezq.fsf@vitty.brq.redhat.com/

Joerg Roedel (4):
  KVM: SVM: Rename struct nested_state to svm_nested_state
  KVM: SVM: Add vmcb_ prefix to mark_*() functions
  KVM: SVM: Add svm_ prefix to set/clr/is_intercept()
  KVM: SVM: Rename svm_nested_virtualize_tpr() to
    nested_svm_virtualize_tpr()

 arch/x86/kvm/svm/avic.c   |   2 +-
 arch/x86/kvm/svm/nested.c |   8 +--
 arch/x86/kvm/svm/sev.c    |   2 +-
 arch/x86/kvm/svm/svm.c    | 138 +++++++++++++++++++-------------------
 arch/x86/kvm/svm/svm.h    |  20 +++---
 5 files changed, 85 insertions(+), 85 deletions(-)

-- 
2.27.0

