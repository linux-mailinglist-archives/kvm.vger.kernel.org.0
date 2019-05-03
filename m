Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3FD12E1B
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfECMqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:46:15 -0400
Received: from foss.arm.com ([217.140.101.70]:60556 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727726AbfECMqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:46:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2801D169E;
        Fri,  3 May 2019 05:46:14 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E53323F220;
        Fri,  3 May 2019 05:46:10 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 26/56] KVM: Document errors for KVM_GET_ONE_REG and KVM_SET_ONE_REG
Date:   Fri,  3 May 2019 13:43:57 +0100
Message-Id: <20190503124427.190206-27-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dave Martin <Dave.Martin@arm.com>

KVM_GET_ONE_REG and KVM_SET_ONE_REG return some error codes that
are not documented (but hopefully not surprising either).  To give
an indication of what these may mean, this patch adds brief
documentation.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/api.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 2d4f7ce5e967..cd920dd1195c 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1871,6 +1871,9 @@ Architectures: all
 Type: vcpu ioctl
 Parameters: struct kvm_one_reg (in)
 Returns: 0 on success, negative value on failure
+Errors:
+  ENOENT:   no such register
+  EINVAL:   other errors, such as bad size encoding for a known register
 
 struct kvm_one_reg {
        __u64 id;
@@ -2192,6 +2195,9 @@ Architectures: all
 Type: vcpu ioctl
 Parameters: struct kvm_one_reg (in and out)
 Returns: 0 on success, negative value on failure
+Errors:
+  ENOENT:   no such register
+  EINVAL:   other errors, such as bad size encoding for a known register
 
 This ioctl allows to receive the value of a single register implemented
 in a vcpu. The register to read is indicated by the "id" field of the
-- 
2.20.1

