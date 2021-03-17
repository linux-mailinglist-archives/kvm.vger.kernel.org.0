Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0130B33EF61
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 12:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhCQLTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 07:19:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231179AbhCQLTl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Mar 2021 07:19:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615979980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DWegNjY6jdpOK3nQ6dsMm+ViORSOfIsbAq2kyIiD81M=;
        b=SAtbvVJ70LmOsp/wUkpBWu67s/IQmcpDoBEMvAVSlh6Dane9mzuksyRQvyQMQy1lHenzoV
        DXwqQMhUJ2FpmAWk34SlVWJBCZFPmX0ENanmcmnZkhWCwRU0bBgoaAA0b3qUTYpGkCcHhY
        DidFzaeZWsl0HCjyxsOoPFaeH8c43rk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-q2CLEAEaPaKDnMXyHCZBOw-1; Wed, 17 Mar 2021 07:19:38 -0400
X-MC-Unique: q2CLEAEaPaKDnMXyHCZBOw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F0C4107B274;
        Wed, 17 Mar 2021 11:19:37 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49C6A19C66;
        Wed, 17 Mar 2021 11:19:35 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v2 5/4] KVM: x86: hyper-v: Briefly document enum hv_tsc_page_status
Date:   Wed, 17 Mar 2021 12:19:34 +0100
Message-Id: <20210317111934.993523-1-vkuznets@redhat.com>
In-Reply-To: <71484ff3-491a-e8a2-3ef4-e21adb4259ee@redhat.com>
References: <71484ff3-491a-e8a2-3ef4-e21adb4259ee@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add comments to enum hv_tsc_page_status documenting what each state means.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 71b14e51fdc0..e1b6e2edc828 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -884,12 +884,19 @@ struct kvm_hv_syndbg {
 	u64 options;
 };
 
+/* Current state of Hyper-V TSC page clocksource */
 enum hv_tsc_page_status {
+	/* TSC page was not set up or disabled */
 	HV_TSC_PAGE_UNSET = 0,
+	/* TSC page MSR was written by the guest, update pending */
 	HV_TSC_PAGE_GUEST_CHANGED,
+	/* TSC page MSR was written by KVM userspace, update pending */
 	HV_TSC_PAGE_HOST_CHANGED,
+	/* TSC page was properly set up and is currently active  */
 	HV_TSC_PAGE_SET,
+	/* TSC page is currently being updated and therefore is inactive */
 	HV_TSC_PAGE_UPDATING,
+	/* TSC page was set up with an inaccessible GPA */
 	HV_TSC_PAGE_BROKEN,
 };
 
-- 
2.30.2

