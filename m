Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9286D127CEA
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 15:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfLTObI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 09:31:08 -0500
Received: from foss.arm.com ([217.140.110.172]:51340 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728039AbfLTObH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 09:31:07 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FC1811B3;
        Fri, 20 Dec 2019 06:31:07 -0800 (PST)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87C853F86C;
        Fri, 20 Dec 2019 06:31:05 -0800 (PST)
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc:     Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 16/18] KVM: arm64: enable SPE support
Date:   Fri, 20 Dec 2019 14:30:23 +0000
Message-Id: <20191220143025.33853-17-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191220143025.33853-1-andrew.murray@arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

We have all the bits and pieces to enable SPE for guest in place, so
lets enable it.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 virt/kvm/arm/arm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index a66085c8e785..fb3ad0835255 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -611,6 +611,10 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 		return ret;
 
 	ret = kvm_arm_pmu_v3_enable(vcpu);
+	if (ret)
+		return ret;
+
+	ret = kvm_arm_spe_v1_enable(vcpu);
 
 	return ret;
 }
-- 
2.21.0

