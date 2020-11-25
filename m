Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709192C3C79
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgKYJl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:41:56 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57142 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727403AbgKYJlz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:41:55 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 5F8FC30462CD;
        Wed, 25 Nov 2020 11:35:43 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 43FF93072785;
        Wed, 25 Nov 2020 11:35:43 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 01/81] KVM: UAPI: add error codes used by the VM introspection code
Date:   Wed, 25 Nov 2020 11:34:40 +0200
Message-Id: <20201125093600.2766-2-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These new error codes help the introspection tool to identify the cause
of the introspection command failure and to recover from some error
cases or to give more information to the user.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 include/uapi/linux/kvm_para.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 8b86609849b9..3ce388249682 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -17,6 +17,10 @@
 #define KVM_E2BIG		E2BIG
 #define KVM_EPERM		EPERM
 #define KVM_EOPNOTSUPP		95
+#define KVM_EAGAIN		11
+#define KVM_ENOENT		ENOENT
+#define KVM_ENOMEM		ENOMEM
+#define KVM_EBUSY		EBUSY
 
 #define KVM_HC_VAPIC_POLL_IRQ		1
 #define KVM_HC_MMU_OP			2
