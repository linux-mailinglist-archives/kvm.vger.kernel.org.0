Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E17877D615F
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 07:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjJYF7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 01:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjJYF7b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 01:59:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B16130;
        Tue, 24 Oct 2023 22:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698213568; x=1729749568;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jQJiiFvpOMKFbrXXC4RAupxJWvxclI+9fI31oaetUbg=;
  b=Y8ud/hFcpiKS7W12OPz8RMn7+QCHv/VFToNTe3miWiIibEW2xQANxJZL
   cmI4Y8CGgUa8qk0Cq6mnsTq41D09BIDiwF9i9VqjjJnpwx+j2rBbWSEub
   HG0KKph8R3gk8xb1kwQOa1naIJRp5x5htweqtSV+LwtMLQe512oPOj9oI
   4b8BHnNlXA8N3S9sCiD/pKdtFKXwShRphymCXEvTOUYSdjeyI5K9b21R/
   ALdFsX3NKaktpFlflbJMEbemGdQUkvFGUQdiHNnOrVMZWJZYKvzwJlJj6
   4800+FoeHB0wuIzLZHlGsLsN3OCny9YBQnpvl9wOkqHgAgCzWSwF82mS7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="473479250"
X-IronPort-AV: E=Sophos;i="6.03,249,1694761200"; 
   d="scan'208";a="473479250"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 22:59:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="788021763"
X-IronPort-AV: E=Sophos;i="6.03,249,1694761200"; 
   d="scan'208";a="788021763"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga008.jf.intel.com with ESMTP; 24 Oct 2023 22:59:25 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 2/2] KVM: x86: Improve documentation of MSR_KVM_ASYNC_PF_EN
Date:   Wed, 25 Oct 2023 01:59:14 -0400
Message-Id: <20231025055914.1201792-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231025055914.1201792-1-xiaoyao.li@intel.com>
References: <20231025055914.1201792-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix some incorrect statement of MSR_KVM_ASYNC_PF_EN documentation and
state clearly the token in 'struct kvm_vcpu_pv_apf_data' of 'page ready'
event is matchted with the token in CR2 in 'page not present' event.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 Documentation/virt/kvm/x86/msr.rst | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/x86/msr.rst b/Documentation/virt/kvm/x86/msr.rst
index f6d70f99a1a7..3aecf2a70e7b 100644
--- a/Documentation/virt/kvm/x86/msr.rst
+++ b/Documentation/virt/kvm/x86/msr.rst
@@ -193,8 +193,8 @@ data:
 	Asynchronous page fault (APF) control MSR.
 
 	Bits 63-6 hold 64-byte aligned physical address of a 64 byte memory area
-	which must be in guest RAM and must be zeroed. This memory is expected
-	to hold a copy of the following structure::
+	which must be in guest RAM. This memory is expected to hold the
+	following structure::
 
 	  struct kvm_vcpu_pv_apf_data {
 		/* Used for 'page not present' events delivered via #PF */
@@ -231,14 +231,14 @@ data:
 	as regular page fault, guest must reset 'flags' to '0' before it does
 	something that can generate normal page fault.
 
-	Bytes 5-7 of 64 byte memory location ('token') will be written to by the
+	Bytes 4-7 of 64 byte memory location ('token') will be written to by the
 	hypervisor at the time of APF 'page ready' event injection. The content
-	of these bytes is a token which was previously delivered as 'page not
-	present' event. The event indicates the page in now available. Guest is
-	supposed to write '0' to 'token' when it is done handling 'page ready'
-	event and to write 1' to MSR_KVM_ASYNC_PF_ACK after clearing the location;
-	writing to the MSR forces KVM to re-scan its queue and deliver the next
-	pending notification.
+	of these bytes is a token which was previously delivered in CR2 as
+	'page not present' event. The event indicates the page is now available.
+	Guest is supposed to write '0' to 'token' when it is done handling
+	'page ready' event and to write '1' to MSR_KVM_ASYNC_PF_ACK after
+	clearing the location; writing to the MSR forces KVM to re-scan its
+	queue and deliver the next pending notification.
 
 	Note, MSR_KVM_ASYNC_PF_INT MSR specifying the interrupt vector for 'page
 	ready' APF delivery needs to be written to before enabling APF mechanism
-- 
2.34.1

