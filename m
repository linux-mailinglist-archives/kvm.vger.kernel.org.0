Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2554D341810
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 10:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhCSJR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 05:17:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36307 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229826AbhCSJRI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 05:17:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616145427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dTG0YNeiE2Tcbqwn6SJ65GVmG9r9Ym8B4ZrhCrxe4xk=;
        b=Xfv9UIX2cLY/g0NU6oXuBO8ORClG0buiap3aTMo64UHdwlLpIpVBvnwcucdBCeX4MNOLey
        Iy40NFrOvRi+nFuTq4nA6Rd7p+Hnd/Mk8LFlC2UP3gtXaMbw8UWdkN74T0PcgU/pFbwPPp
        gC6Po/WJIjIdMItWjqA1c8lmkGoRLPM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-sIzvRL-cMLiXnT6fmBNyZg-1; Fri, 19 Mar 2021 05:16:56 -0400
X-MC-Unique: sIzvRL-cMLiXnT6fmBNyZg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D996A189CD06;
        Fri, 19 Mar 2021 09:16:54 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-38.ams2.redhat.com [10.36.113.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10E5961D31;
        Fri, 19 Mar 2021 09:16:51 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     linux-doc@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] documentation/kvm: additional explanations on KVM_SET_BOOT_CPU_ID
Date:   Fri, 19 Mar 2021 10:16:50 +0100
Message-Id: <20210319091650.11967-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ioctl KVM_SET_BOOT_CPU_ID fails when called after vcpu creation.
Add this explanation in the documentation.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 Documentation/virt/kvm/api.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 38e327d4b479..bece398227f5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1495,7 +1495,8 @@ Fails if any VCPU has already been created.
 
 Define which vcpu is the Bootstrap Processor (BSP).  Values are the same
 as the vcpu id in KVM_CREATE_VCPU.  If this ioctl is not called, the default
-is vcpu 0.
+is vcpu 0. This ioctl has to be called before vcpu creation,
+otherwise it will return EBUSY error.
 
 
 4.42 KVM_GET_XSAVE
-- 
2.29.2

