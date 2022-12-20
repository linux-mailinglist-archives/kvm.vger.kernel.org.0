Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1896F652247
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbiLTORL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbiLTOQj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:16:39 -0500
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CE2F023;
        Tue, 20 Dec 2022 06:16:26 -0800 (PST)
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1p7csI-00012Y-70; Tue, 20 Dec 2022 13:41:42 +0000
Received: from 54-240-197-227.amazon.com ([54.240.197.227] helo=debian.cbg12.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1p7csH-0002HU-RX; Tue, 20 Dec 2022 13:41:42 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v6 0/2] KVM: x86/xen: update Xen CPUID Leaf 4
Date:   Tue, 20 Dec 2022 13:40:51 +0000
Message-Id: <20221220134053.15591-1-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_ADSP_ALL,
        RCVD_IN_DNSWL_MED,SPF_FAIL,SPF_HELO_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch #2 was the original patch. It has been expended to a series in v6.

Paul Durrant (2):
  KVM: x86/cpuid: generalize kvm_update_kvm_cpuid_base() and also
    capture limit
  KVM: x86/xen: update Xen CPUID Leaf 4 (tsc info) sub-leaves, if
    present

 arch/x86/include/asm/kvm_host.h |  8 +++++++-
 arch/x86/kvm/cpuid.c            | 17 ++++++++++-------
 arch/x86/kvm/x86.c              |  1 +
 arch/x86/kvm/xen.c              | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/xen.h              |  7 +++++++
 5 files changed, 51 insertions(+), 8 deletions(-)
---
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
-- 
2.20.1

