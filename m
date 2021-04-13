Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9259B35DEAB
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 14:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345512AbhDMM1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 08:27:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345505AbhDMM1B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 08:27:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618316801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PPZjB79IEIwq/PRCsOh+j7hnsKwi62omE4Ya7aReZls=;
        b=LlrlQ4q1S5ZBgKDn1KF38Frzc4HTW8XiBQg1bbyaCoVSFAxmj3qbmieZFukN7GglYQxRvL
        WW7ttJwzP+UElc1bvNi1QNNLmMOX7/S2z7YlZfifPY7uasBiOQfobINMQsB4+AMnNa5bIZ
        EQQKt8Pf3WC7JsgE5M5O7CjJRg88wPw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-WXqNNjheOdWLlC4Ft6wxxQ-1; Tue, 13 Apr 2021 08:26:38 -0400
X-MC-Unique: WXqNNjheOdWLlC4Ft6wxxQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC61D1008062;
        Tue, 13 Apr 2021 12:26:36 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 926D760C04;
        Tue, 13 Apr 2021 12:26:34 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH RFC 01/22] asm-generic/hyperv: add HV_STATUS_ACCESS_DENIED definition
Date:   Tue, 13 Apr 2021 14:26:09 +0200
Message-Id: <20210413122630.975617-2-vkuznets@redhat.com>
In-Reply-To: <20210413122630.975617-1-vkuznets@redhat.com>
References: <20210413122630.975617-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From TLFSv6.0b, this status means: "The caller did not possess sufficient
access rights to perform the requested operation."

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 include/asm-generic/hyperv-tlfs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index 83448e837ded..e01a3bade13a 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -187,6 +187,7 @@ enum HV_GENERIC_SET_FORMAT {
 #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
 #define HV_STATUS_INVALID_ALIGNMENT		4
 #define HV_STATUS_INVALID_PARAMETER		5
+#define HV_STATUS_ACCESS_DENIED			6
 #define HV_STATUS_OPERATION_DENIED		8
 #define HV_STATUS_INSUFFICIENT_MEMORY		11
 #define HV_STATUS_INVALID_PORT_ID		17
-- 
2.30.2

