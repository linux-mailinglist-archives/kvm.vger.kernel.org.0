Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 562AB1909C5
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 10:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgCXJmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 05:42:22 -0400
Received: from 8bytes.org ([81.169.241.247]:55346 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727230AbgCXJmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 05:42:00 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 279EF2E2; Tue, 24 Mar 2020 10:41:59 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] KVM: SVM: Move and split up svm.c
Date:   Tue, 24 Mar 2020 10:41:50 +0100
Message-Id: <20200324094154.32352-1-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

here is a patch-set agains kvm/queue which moves svm.c into its own
subdirectory arch/x86/kvm/svm/ and splits moves parts of it into
separate source files:

	- The parts related to nested SVM to nested.c

	- AVIC implementation to avic.c

	- The SEV parts to sev.c

I have tested the changes in a guest with and without SEV.

Please review.

Thanks,

	Joerg

Joerg Roedel (4):
  kVM SVM: Move SVM related files to own sub-directory
  KVM: SVM: Move Nested SVM Implementation to nested.c
  KVM: SVM: Move AVIC code to separate file
  KVM: SVM: Move SEV code to separate file

 arch/x86/kvm/Makefile                 |    2 +-
 arch/x86/kvm/svm/avic.c               | 1025 ++++
 arch/x86/kvm/svm/nested.c             |  823 ++++
 arch/x86/kvm/{pmu_amd.c => svm/pmu.c} |    0
 arch/x86/kvm/svm/sev.c                | 1178 +++++
 arch/x86/kvm/{ => svm}/svm.c          | 6546 ++++++-------------------
 arch/x86/kvm/svm/svm.h                |  491 ++
 7 files changed, 5106 insertions(+), 4959 deletions(-)
 create mode 100644 arch/x86/kvm/svm/avic.c
 create mode 100644 arch/x86/kvm/svm/nested.c
 rename arch/x86/kvm/{pmu_amd.c => svm/pmu.c} (100%)
 create mode 100644 arch/x86/kvm/svm/sev.c
 rename arch/x86/kvm/{ => svm}/svm.c (56%)
 create mode 100644 arch/x86/kvm/svm/svm.h

-- 
2.17.1

