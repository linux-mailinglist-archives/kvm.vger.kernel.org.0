Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EE936557A
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 11:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhDTJet (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 05:34:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230491AbhDTJer (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 05:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618911255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HR9PGFeuseuv+4p0efVgdR4ZvWDR0WWeCLxvhuktGw8=;
        b=RDx/XDB48pjHJzSqYv+bdY95dViPBnmwOM4bVD3C6NFbCJnZaeCbrq6TbUrjSney5DaPpw
        uvfokhh/er6zIUkJmsykLmk1kyyQVtj3dCUe794YZcYrelIHOBgNQYdJFbZer3yfuIRElC
        cUVmTXPR3iNqTJDN5hbgOBYH0VWqQ0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-SJp_Z5AbNziPaAD3TyvAdw-1; Tue, 20 Apr 2021 05:34:13 -0400
X-MC-Unique: SJp_Z5AbNziPaAD3TyvAdw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5736107ACCA;
        Tue, 20 Apr 2021 09:34:12 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6152710016FE;
        Tue, 20 Apr 2021 09:34:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH] KVM: x86: document behavior of measurement ioctls with len==0
Date:   Tue, 20 Apr 2021 05:34:11 -0400
Message-Id: <20210420093411.1498840-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/amd-memory-encryption.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 469a6308765b..34ce2d1fcb89 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -148,6 +148,9 @@ measurement. Since the guest owner knows the initial contents of the guest at
 boot, the measurement can be verified by comparing it to what the guest owner
 expects.
 
+If len is zero on entry, the measurement blob length is written to len and
+uaddr is unused.
+
 Parameters (in): struct  kvm_sev_launch_measure
 
 Returns: 0 on success, -negative on error
@@ -271,6 +274,9 @@ report containing the SHA-256 digest of the guest memory and VMSA passed through
 commands and signed with the PEK. The digest returned by the command should match the digest
 used by the guest owner with the KVM_SEV_LAUNCH_MEASURE.
 
+If len is zero on entry, the measurement blob length is written to len and
+uaddr is unused.
+
 Parameters (in): struct kvm_sev_attestation
 
 Returns: 0 on success, -negative on error
-- 
2.26.2

