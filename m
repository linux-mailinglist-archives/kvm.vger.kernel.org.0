Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA2A27ACD
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 12:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbfEWKf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 06:35:26 -0400
Received: from foss.arm.com ([217.140.101.70]:43018 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730381AbfEWKf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 06:35:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D9B9341;
        Thu, 23 May 2019 03:35:25 -0700 (PDT)
Received: from usa.arm.com (e107155-lin.cambridge.arm.com [10.1.196.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7F6473F718;
        Thu, 23 May 2019 03:35:23 -0700 (PDT)
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v2 02/15] dt-bindings: ARM SPE: highlight the need for PPI partitions on heterogeneous systems
Date:   Thu, 23 May 2019 11:34:49 +0100
Message-Id: <20190523103502.25925-3-sudeep.holla@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523103502.25925-1-sudeep.holla@arm.com>
References: <20190523103502.25925-1-sudeep.holla@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's not entirely clear for the binding document that the only way to
express ARM SPE affined to a subset of CPUs on a heterogeneous systems
is through the use of PPI partitions available in the interrupt
controller bindings.

Let's make it clear.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 Documentation/devicetree/bindings/arm/spe-pmu.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/spe-pmu.txt b/Documentation/devicetree/bindings/arm/spe-pmu.txt
index 93372f2a7df9..4f4815800f6e 100644
--- a/Documentation/devicetree/bindings/arm/spe-pmu.txt
+++ b/Documentation/devicetree/bindings/arm/spe-pmu.txt
@@ -9,8 +9,9 @@ performance sample data using an in-memory trace buffer.
 	       "arm,statistical-profiling-extension-v1"
 
 - interrupts : Exactly 1 PPI must be listed. For heterogeneous systems where
-               SPE is only supported on a subset of the CPUs, please consult
-	       the arm,gic-v3 binding for details on describing a PPI partition.
+               SPE is only supported on a subset of the CPUs, a PPI partition
+	       described in the arm,gic-v3 binding must be used to describe
+	       the set of CPUs this interrupt is affine to.
 
 ** Example:
 
-- 
2.17.1

