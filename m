Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929093C6D92
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 11:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbhGMJin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 05:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234819AbhGMJin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 05:38:43 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36CFC0613DD;
        Tue, 13 Jul 2021 02:35:53 -0700 (PDT)
Received: from cap.home.8bytes.org (p4ff2b1ea.dip0.t-ipconnect.de [79.242.177.234])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id A07E73C2;
        Tue, 13 Jul 2021 11:35:47 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 0/3] kvm: svm: Add initial GHCB protocol version 2 support
Date:   Tue, 13 Jul 2021 11:35:43 +0200
Message-Id: <20210713093546.7467-1-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Hi,

here is a small set of patches which I took from the pending SEV-SNP
patch-sets to enable basic support for GHCB protocol version 2.

When SEV-SNP is not supported, only two new MSR protocol VMGEXIT calls
need to be supported:

	- MSR-based AP-reset-hold
	- MSR-based HV-feature-request

These calls are implemented by here and then the protocol is lifted to
version 2.

This is submitted separately because the MSR-based AP-reset-hold call
is required to support kexec/kdump in SEV-ES guests.

Regards,

	Joerg

Brijesh Singh (2):
  KVM: SVM: Add support for Hypervisor Feature support MSR protocol
  KVM: SVM: Increase supported GHCB protocol version

Tom Lendacky (1):
  KVM: SVM: Add support to handle AP reset MSR protocol

 arch/x86/include/asm/sev-common.h |  5 +++
 arch/x86/include/uapi/asm/svm.h   |  1 +
 arch/x86/kvm/svm/sev.c            | 63 +++++++++++++++++++++++++++----
 arch/x86/kvm/svm/svm.h            |  4 +-
 4 files changed, 64 insertions(+), 9 deletions(-)


base-commit: e73f0f0ee7541171d89f2e2491130c7771ba58d3
-- 
2.31.1

