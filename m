Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29BA2011C1
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403859AbgFSPob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:44:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50258 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404483AbgFSPo3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 11:44:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592581469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=93XXw+kywMi3asZNRy4k77qXN8roBGUKVd6cXXWLw6Q=;
        b=HYMv0gqkuyN6VK0bM1N9GnXRkqzjBPzWrMhMMCdhNWesnjc7MTmcN4+2O9uTPE3OqACmTb
        Rafzy8CNxihBCt8i1uNzqNKq3SOAewGi0NdD5h9vdj9GZjRPReQJ+jBztD9taw7G4vtk+D
        pA16OxILta/ATbQGASlJ2PUD3gA3h+8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-cvAKS8NhNjWYnHf0IBqyHw-1; Fri, 19 Jun 2020 11:44:27 -0400
X-MC-Unique: cvAKS8NhNjWYnHf0IBqyHw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 949C218A51E5;
        Fri, 19 Jun 2020 15:43:14 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9470660E1C;
        Fri, 19 Jun 2020 15:43:11 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     vkuznets@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        Mohammed Gamal <mgamal@redhat.com>
Subject: [kvm-unit-test PATCH 2/2] unittests.cfg: Increase timeout for access test
Date:   Fri, 19 Jun 2020 17:42:56 +0200
Message-Id: <20200619154256.79216-3-mgamal@redhat.com>
In-Reply-To: <20200619154256.79216-1-mgamal@redhat.com>
References: <20200619154256.79216-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In case of npt=0 on kvm_amd, tests run slower and timeout,
so increase the timeout. The tests then do succeed.

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
---
 x86/unittests.cfg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index bf0d02e..bc7184d 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -117,6 +117,7 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
 file = access.flat
 arch = x86_64
 extra_params = -cpu host,phys-bits=36
+timeout = 180
 
 [smap]
 file = smap.flat
-- 
2.26.2

