Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575163E5830
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 12:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239819AbhHJKV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 06:21:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238602AbhHJKV6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 06:21:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628590896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UoOPav9mt5YOVdwvQ7MavZDm5DJmX9UQzZ8YeI9L690=;
        b=Z5gqo5ItEiokNOg17GSlgOnUvF3yamW6t964ZiLyoU3xrKqp8ONLTA7YSP3X3PAg6Rheq2
        QtIrqmS3xYbk2YRS3BdZkHC6GuWn6hsxR64HDnS/vMZykDJ+zawDZQcDMGlrZSECGh/jxB
        1+Zk/fYNLgMigDEn8fqCSoFDpeQBVRY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-iqfl7gTKMauT6qazEkfrjw-1; Tue, 10 Aug 2021 06:21:35 -0400
X-MC-Unique: iqfl7gTKMauT6qazEkfrjw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 790868799E0;
        Tue, 10 Aug 2021 10:21:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3875C60BF1;
        Tue, 10 Aug 2021 10:21:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: stats: remove dead stores
Date:   Tue, 10 Aug 2021 06:21:33 -0400
Message-Id: <20210810102133.3316768-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These stores are copied and pasted from the "if" statements above.
They are dead and while they are not really a bug, they can be
confusing to anyone reading the code as well.  Remove them.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/binary_stats.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/binary_stats.c b/virt/kvm/binary_stats.c
index e609d428811a..eefca6c69f51 100644
--- a/virt/kvm/binary_stats.c
+++ b/virt/kvm/binary_stats.c
@@ -136,9 +136,7 @@ ssize_t kvm_stats_read(char *id, const struct kvm_stats_header *header,
 		src = stats + pos - header->data_offset;
 		if (copy_to_user(dest, src, copylen))
 			return -EFAULT;
-		remain -= copylen;
 		pos += copylen;
-		dest += copylen;
 	}
 
 	*offset = pos;
-- 
2.27.0

