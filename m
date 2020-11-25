Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985D52C3CA7
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbgKYJm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:27 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57142 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728552AbgKYJmG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:06 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id BFD94305D4F5;
        Wed, 25 Nov 2020 11:35:43 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id A52413072784;
        Wed, 25 Nov 2020 11:35:43 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 04/81] KVM: doc: fix the hypercalls numbering
Date:   Wed, 25 Nov 2020 11:34:43 +0200
Message-Id: <20201125093600.2766-5-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The next hypercalls will be correctly numbered.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/hypercalls.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
index ed4fddd364ea..70e77c66b64c 100644
--- a/Documentation/virt/kvm/hypercalls.rst
+++ b/Documentation/virt/kvm/hypercalls.rst
@@ -137,7 +137,7 @@ compute the CLOCK_REALTIME for its clock, at the same instant.
 Returns KVM_EOPNOTSUPP if the host does not use TSC clocksource,
 or if clock type is different than KVM_CLOCK_PAIRING_WALLCLOCK.
 
-6. KVM_HC_SEND_IPI
+7. KVM_HC_SEND_IPI
 ------------------
 
 :Architecture: x86
@@ -158,7 +158,7 @@ corresponds to the APIC ID a2+1, and so on.
 
 Returns the number of CPUs to which the IPIs were delivered successfully.
 
-7. KVM_HC_SCHED_YIELD
+8. KVM_HC_SCHED_YIELD
 ---------------------
 
 :Architecture: x86
