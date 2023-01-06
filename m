Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832AD65FF02
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 11:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbjAFKgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 05:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjAFKga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 05:36:30 -0500
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDA26B5FF;
        Fri,  6 Jan 2023 02:36:29 -0800 (PST)
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1pDk5E-0003mV-2t; Fri, 06 Jan 2023 10:36:20 +0000
Received: from 54-240-197-227.amazon.com ([54.240.197.227] helo=debian.cbg12.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1pDk5D-0001wX-Ni; Fri, 06 Jan 2023 10:36:19 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     x86@kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>, Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v7 0/2] KVM: x86/xen: update Xen CPUID Leaf 4
Date:   Fri,  6 Jan 2023 10:35:58 +0000
Message-Id: <20230106103600.528-1-pdurrant@amazon.com>
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

 arch/x86/include/asm/kvm_host.h       |  8 +++++++-
 arch/x86/include/asm/xen/hypervisor.h |  4 +++-
 arch/x86/kvm/cpuid.c                  | 26 +++++++++++++++-----------
 arch/x86/kvm/x86.c                    |  1 +
 arch/x86/kvm/xen.c                    | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/xen.h                    |  7 +++++++
 6 files changed, 59 insertions(+), 13 deletions(-)
---
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
-- 
2.20.1

