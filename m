Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A6038C3F9
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237395AbhEUJzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:55:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59362 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236788AbhEUJy0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:54:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pzJWGyL/xmrJPwQpBuslPuW40Xd6Owzo4Ei6ZEpATRY=;
        b=X+lJpHBKlKtJGAPIG/V4/1lyraF6Gt28XYkhz7sFdx7EhW4yitjA5nfiz9peg9ONL3u0Ih
        tusEepS3FNDQGx/rTjmi9VSmJ5nz4jK48RCfoeR9d6XGH/2MgoL4vpEAuumnGhiP22bina
        3VUS0e9FJdQ8wT+bal9dxoo3c5ngJIg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-_PTlrdW4NXmaGb-J2ifcMg-1; Fri, 21 May 2021 05:53:01 -0400
X-MC-Unique: _PTlrdW4NXmaGb-J2ifcMg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43368800C60;
        Fri, 21 May 2021 09:53:00 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 328EB687F7;
        Fri, 21 May 2021 09:52:57 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 18/30] KVM: x86: hyper-v: Inverse the default in hv_check_msr_access()
Date:   Fri, 21 May 2021 11:51:52 +0200
Message-Id: <20210521095204.2161214-19-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Access to all MSRs is now properly checked. To avoid 'forgetting' to
properly check access to new MSRs in the future change the default
to 'false' meaning 'no access'.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f54385ffcdc0..ec065177531b 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1265,7 +1265,7 @@ static bool hv_check_msr_access(struct kvm_vcpu_hv *hv_vcpu, u32 msr)
 		break;
 	}
 
-	return true;
+	return false;
 }
 
 static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
-- 
2.31.1

