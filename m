Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B29F44619B
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 10:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbhKEJyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 05:54:09 -0400
Received: from mail.xenproject.org ([104.130.215.37]:56582 "EHLO
        mail.xenproject.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbhKEJyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 05:54:08 -0400
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1mivsP-00048Y-2s; Fri, 05 Nov 2021 09:51:13 +0000
Received: from host86-165-42-146.range86-165.btcentralplus.com ([86.165.42.146] helo=debian.home)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1mivsO-00088M-Q9; Fri, 05 Nov 2021 09:51:13 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     kvm@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 0/2] KVM: x86: Correct adjustment of KVM_CPUID_FEATURES
Date:   Fri,  5 Nov 2021 09:50:59 +0000
Message-Id: <20211105095101.5384-1-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2: Pre-requisite patch from Sean.

Paul Durrant (1):
  KVM: x86: Make sure KVM_CPUID_FEATURES really are KVM_CPUID_FEATURES

Sean Christopherson (1):
  KVM: x86: Add helper to consolidate core logic of SET_CPUID{2} flows

 arch/x86/include/asm/kvm_host.h      |  1 +
 arch/x86/include/asm/processor.h     |  5 +-
 arch/x86/include/uapi/asm/kvm_para.h |  1 +
 arch/x86/kernel/kvm.c                |  2 +-
 arch/x86/kvm/cpuid.c                 | 93 +++++++++++++++++++---------
 5 files changed, 71 insertions(+), 31 deletions(-)
---
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
