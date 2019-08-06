Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E14283923
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 20:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfHFS50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 14:57:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:40914 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbfHFS5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 14:57:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 11:57:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,353,1559545200"; 
   d="scan'208";a="176715097"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 06 Aug 2019 11:56:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Eduardo Habkost <ehabkost@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC PATCH 11/20] linux-headers: Add temporary placeholder for KVM_CAP_SGX_ATTRIBUTE
Date:   Tue,  6 Aug 2019 11:56:40 -0700
Message-Id: <20190806185649.2476-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806185649.2476-1-sean.j.christopherson@intel.com>
References: <20190806185649.2476-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_CAP_SGX_ATTRIBUTE is a proposed capability for Intel SGX that can be
used by userspace to enable privileged attributes, e.g. access to the
PROVISIONKEY.  The capability number is a placeholder defined well above
existing capabilities so that it's stable during development.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 linux-headers/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index c8423e760c..a88fba824c 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -993,6 +993,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_SVE 170
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
+#define KVM_CAP_SGX_ATTRIBUTE 200
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.22.0

