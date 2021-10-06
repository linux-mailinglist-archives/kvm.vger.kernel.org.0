Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175284244BA
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239561AbhJFRmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:42:53 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53652 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239111AbhJFRmg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:36 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 39D063074304;
        Wed,  6 Oct 2021 20:30:53 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 1F01D3064495;
        Wed,  6 Oct 2021 20:30:53 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 01/77] KVM: UAPI: add error codes used by the VM introspection code
Date:   Wed,  6 Oct 2021 20:29:57 +0300
Message-Id: <20211006173113.26445-2-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
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
index 960c7e93d1a9..16a867910459 100644
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
