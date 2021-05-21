Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D4438C40E
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237753AbhEUJ4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:56:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41144 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237306AbhEUJzD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:55:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1tOx64eovD26EcSajBJx6hL/brTncKob15OQmZUVSB4=;
        b=dyGUHp2UDh/Ei7YpqWaCAeAq75D/GYPnAGeCJFC2lrCFQylJVolGwGdAKQaHRTN4yK9jvI
        lTjZob6KvAv+g8XFDumtoMGBf7YgbHTKu+HyD1c7cRSqWmHd2we2tcL4WDzinaqcj6snJi
        MnITboHu7c9OE+VHHTlEgub1/gEqtWo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-bC1-IHZuMqWNiNuqM6nEXA-1; Fri, 21 May 2021 05:53:38 -0400
X-MC-Unique: bC1-IHZuMqWNiNuqM6nEXA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58F03801106;
        Fri, 21 May 2021 09:53:37 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C6EC6A047;
        Fri, 21 May 2021 09:53:35 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 29/30] KVM: selftests: Move evmcs.h to x86_64/
Date:   Fri, 21 May 2021 11:52:03 +0200
Message-Id: <20210521095204.2161214-30-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

evmcs.h is x86_64 only thing, move it to x86_64/ subdirectory.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/{ => x86_64}/evmcs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 rename tools/testing/selftests/kvm/include/{ => x86_64}/evmcs.h (99%)

diff --git a/tools/testing/selftests/kvm/include/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
similarity index 99%
rename from tools/testing/selftests/kvm/include/evmcs.h
rename to tools/testing/selftests/kvm/include/x86_64/evmcs.h
index a034438b6266..c9af97abd622 100644
--- a/tools/testing/selftests/kvm/include/evmcs.h
+++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * tools/testing/selftests/kvm/include/vmx.h
+ * tools/testing/selftests/kvm/include/x86_64/evmcs.h
  *
  * Copyright (C) 2018, Red Hat, Inc.
  *
-- 
2.31.1

