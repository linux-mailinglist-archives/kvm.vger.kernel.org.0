Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B267455CCF
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 14:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhKRNjH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 08:39:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35769 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231387AbhKRNjH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 08:39:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637242566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lQ5oXvhqw9hdRHdCcKmp06nROVN+IC9bdmFBmULq+6M=;
        b=i9toZx6a4vWdVIoveLp1GJ+JRe41+g0sh9NyRhpb3WgwT20w2QRVPUxbU2LHsEkSsPtUj8
        CBGXvuTlQkg0SL0CNpWGD1ElhRMJuix5s41J2bFiTMc9xdMxJ3xh0lkhl5FXR9dunFbc4L
        U4vIJP9Licjs7xNjhKE3ZJPSF6zkDtA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-Ce2K8_grNnSEbbpNPmktPA-1; Thu, 18 Nov 2021 08:36:03 -0500
X-MC-Unique: Ce2K8_grNnSEbbpNPmktPA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11834100E32B;
        Thu, 18 Nov 2021 13:36:02 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.33.36.247])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3042462A44;
        Thu, 18 Nov 2021 13:36:00 +0000 (UTC)
From:   =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Dov Murik <dovmurik@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PULL 3/6] target/i386/sev: Rephrase error message when no hashes table in guest firmware
Date:   Thu, 18 Nov 2021 13:35:29 +0000
Message-Id: <20211118133532.2029166-4-berrange@redhat.com>
In-Reply-To: <20211118133532.2029166-1-berrange@redhat.com>
References: <20211118133532.2029166-1-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dov Murik <dovmurik@linux.ibm.com>

Signed-off-by: Dov Murik <dovmurik@linux.ibm.com>
Acked-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
---
 target/i386/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index e3abbeef68..6ff196f7ad 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1232,7 +1232,8 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
     }
 
     if (!pc_system_ovmf_table_find(SEV_HASH_TABLE_RV_GUID, &data, NULL)) {
-        error_setg(errp, "SEV: kernel specified but OVMF has no hash table guid");
+        error_setg(errp, "SEV: kernel specified but guest firmware "
+                         "has no hashes table GUID");
         return false;
     }
     area = (SevHashTableDescriptor *)data;
-- 
2.31.1

