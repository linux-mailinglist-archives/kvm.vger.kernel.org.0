Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4238A2041DB
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 22:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgFVUUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 16:20:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:62017 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728405AbgFVUUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 16:20:37 -0400
IronPort-SDR: rpPC6FH9qWpRYypU/6l+4vVDhStTbgIYVyScAsZrdFpD1A1LCVjQUOBC+1g+78SJCR6VHy3L1z
 QRSbqRz5Udiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="209057474"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="209057474"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 13:20:36 -0700
IronPort-SDR: IIknzzp2CyZi4jR/40NntXy9138dMaGyEd1yeTT7VXR8VLoz6c8hb1nfpUfRP1ZHEwfK0e6wZN
 9eKCRXf06pkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="478506313"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 22 Jun 2020 13:20:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] KVM: x86/mmu: Files and sp helper cleanups
Date:   Mon, 22 Jun 2020 13:20:28 -0700
Message-Id: <20200622202034.15093-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move more files to the mmu/ directory, and an mmu_internal.h to share
stuff amongst the mmu/ files, and clean up the helpers for retrieving a
shadow page from a sptep and/or hpa.

Sean Christopherson (6):
  KVM: x86/mmu: Move mmu_audit.c and mmutrace.h into the mmu/
    sub-directory
  KVM: x86/mmu: Move kvm_mmu_available_pages() into mmu.c
  KVM: x86/mmu: Add MMU-internal header
  KVM: x86/mmu: Make kvm_mmu_page definition and accessor internal-only
  KVM: x86/mmu: Add sptep_to_sp() helper to wrap shadow page lookup
  KVM: x86/mmu: Rename page_header() to to_shadow_page()

 arch/x86/include/asm/kvm_host.h    | 46 +---------------------
 arch/x86/kvm/mmu.h                 | 13 ------
 arch/x86/kvm/mmu/mmu.c             | 58 +++++++++++++++------------
 arch/x86/kvm/{ => mmu}/mmu_audit.c | 12 +++---
 arch/x86/kvm/mmu/mmu_internal.h    | 63 ++++++++++++++++++++++++++++++
 arch/x86/kvm/{ => mmu}/mmutrace.h  |  2 +-
 arch/x86/kvm/mmu/page_track.c      |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h     |  4 +-
 8 files changed, 108 insertions(+), 92 deletions(-)
 rename arch/x86/kvm/{ => mmu}/mmu_audit.c (96%)
 create mode 100644 arch/x86/kvm/mmu/mmu_internal.h
 rename arch/x86/kvm/{ => mmu}/mmutrace.h (99%)

-- 
2.26.0

