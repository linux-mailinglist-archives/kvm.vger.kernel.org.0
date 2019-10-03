Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 739B5C9D54
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 13:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730124AbfJCLcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 07:32:35 -0400
Received: from foss.arm.com ([217.140.110.172]:42360 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729942AbfJCLce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 07:32:34 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73465337;
        Thu,  3 Oct 2019 04:32:34 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 65BED3F706;
        Thu,  3 Oct 2019 04:32:33 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        mark.rutland@arm.com, andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH v2 0/3] arm64: Add code generation test
Date:   Thu,  3 Oct 2019 12:32:14 +0100
Message-Id: <20191003113217.25464-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a test to check if KVM honors the CTR_EL0.{IDC, DIC} bits that it
advertises to the guests. Full details are in patch #3.

Changes in v2:
* Gathered Reviewed-by tags.
* Fixed typo s/group/groups in #3.

Alexandru Elisei (3):
  lib: arm64: Add missing ISB in flush_tlb_page
  lib: arm/arm64: Add function to clear the PTE_USER bit
  arm64: Add cache code generation test

 arm/Makefile.arm64    |   1 +
 lib/arm/asm/mmu-api.h |   1 +
 lib/arm64/asm/mmu.h   |   1 +
 lib/arm/mmu.c         |  15 ++++++
 arm/cache.c           | 122 ++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg     |   6 +++
 6 files changed, 146 insertions(+)
 create mode 100644 arm/cache.c

-- 
2.20.1

