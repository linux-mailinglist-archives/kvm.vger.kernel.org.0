Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E23540409C
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 23:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbhIHVnh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 17:43:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32159 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234808AbhIHVng (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 17:43:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631137347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rAVZAu3hpXwiNvy/AA87U7fY8TlEUUMh0/TY5+LCdNo=;
        b=TZ9pPsRxzhEPFv9LCkB007HFaHrlpMiA+QNlqUsgcoBb4PMGOt9mperb1rf4wccvo+r6uE
        cfBoWsxgahX8vOkxdjQPO7he/Msik3mom+4cfFeJnmw1TquI3UkpT9kStoRJ8qpi4rrP1f
        oBcpZMFsxhBIhMneAQbUWpjaxBrdYOE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-35Qalk8nP7iUZpSm9wT7rg-1; Wed, 08 Sep 2021 17:42:26 -0400
X-MC-Unique: 35Qalk8nP7iUZpSm9wT7rg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FBCD835DE1
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 21:42:25 +0000 (UTC)
Received: from wainer-laptop.localdomain.com (ovpn-116-108.gru2.redhat.com [10.97.116.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB82619C79;
        Wed,  8 Sep 2021 21:42:22 +0000 (UTC)
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: [PATCH] KVM: Documentation: Fix missing backtick
Date:   Wed,  8 Sep 2021 18:42:17 -0300
Message-Id: <20210908214217.1423119-1-wainersm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Added the missing backtick around ENOTTY in amd-memory-encryption.rst.

Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
---
 Documentation/virt/kvm/amd-memory-encryption.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
index 5c081c8c7164..1d1810731f95 100644
--- a/Documentation/virt/kvm/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/amd-memory-encryption.rst
@@ -55,7 +55,7 @@ information, see the SEV Key Management spec [api-spec]_
 
 The main ioctl to access SEV is KVM_MEMORY_ENCRYPT_OP.  If the argument
 to KVM_MEMORY_ENCRYPT_OP is NULL, the ioctl returns 0 if SEV is enabled
-and ``ENOTTY` if it is disabled (on some older versions of Linux,
+and ``ENOTTY`` if it is disabled (on some older versions of Linux,
 the ioctl runs normally even with a NULL argument, and therefore will
 likely return ``EFAULT``).  If non-NULL, the argument to KVM_MEMORY_ENCRYPT_OP
 must be a struct kvm_sev_cmd::
-- 
2.31.1

