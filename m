Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8913062E5
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 19:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235772AbhA0SBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 13:01:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344122AbhA0R7h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 12:59:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611770291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GCxviBQBbv8OTsE75UZ23UOIHww55oQgzi/r5zVwztY=;
        b=CbQ3gNQIOil7I4chP2KRr4kWZZGeLhufzv0G2lRRH8S66GAwMh4QrrWzBAEK2xdxJyIc4L
        Ks6Vw6iENw5fA5Dk2x5Q7/aZtS1+bnJdVFKr2lIDimZTVvEGrw85jH8vedQ40077FiFX+K
        AB4V0fo7/nelIVI4WEIICjQshBnzCF8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-rXfN4KvtPgyN6qSBLvfmJQ-1; Wed, 27 Jan 2021 12:58:08 -0500
X-MC-Unique: rXfN4KvtPgyN6qSBLvfmJQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE0F2107ACE8;
        Wed, 27 Jan 2021 17:58:06 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FC4D5C675;
        Wed, 27 Jan 2021 17:58:04 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [PATCH 5/5] selftests: kvm: Raise the default timeout to 120 seconds
Date:   Wed, 27 Jan 2021 18:57:31 +0100
Message-Id: <20210127175731.2020089-6-vkuznets@redhat.com>
In-Reply-To: <20210127175731.2020089-1-vkuznets@redhat.com>
References: <20210127175731.2020089-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the updated maximum number of user memslots (32)
set_memory_region_test sometimes takes longer than the default 45 seconds
to finish. Raise the value to an arbitrary 120 seconds.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/settings | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/kvm/settings

diff --git a/tools/testing/selftests/kvm/settings b/tools/testing/selftests/kvm/settings
new file mode 100644
index 000000000000..6091b45d226b
--- /dev/null
+++ b/tools/testing/selftests/kvm/settings
@@ -0,0 +1 @@
+timeout=120
-- 
2.29.2

