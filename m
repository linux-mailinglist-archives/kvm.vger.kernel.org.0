Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C377E155D7C
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBGSQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:42 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40614 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727065AbgBGSQl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:41 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id BE60B305D48E;
        Fri,  7 Feb 2020 20:16:38 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id A8BF53052069;
        Fri,  7 Feb 2020 20:16:38 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 06/78] KVM: doc: fix the hypercall numbering
Date:   Fri,  7 Feb 2020 20:15:24 +0200
Message-Id: <20200207181636.1065-7-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/hypercalls.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/hypercalls.txt b/Documentation/virt/kvm/hypercalls.txt
index 5f6d291bd004..aff272bede08 100644
--- a/Documentation/virt/kvm/hypercalls.txt
+++ b/Documentation/virt/kvm/hypercalls.txt
@@ -122,7 +122,7 @@ compute the CLOCK_REALTIME for its clock, at the same instant.
 Returns KVM_EOPNOTSUPP if the host does not use TSC clocksource,
 or if clock type is different than KVM_CLOCK_PAIRING_WALLCLOCK.
 
-6. KVM_HC_SEND_IPI
+7. KVM_HC_SEND_IPI
 ------------------------
 Architecture: x86
 Status: active
@@ -142,7 +142,7 @@ corresponds to the APIC ID a2+1, and so on.
 
 Returns the number of CPUs to which the IPIs were delivered successfully.
 
-7. KVM_HC_SCHED_YIELD
+8. KVM_HC_SCHED_YIELD
 ------------------------
 Architecture: x86
 Status: active
