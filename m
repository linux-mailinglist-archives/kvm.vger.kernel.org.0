Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E651970F
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 05:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfEJD0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 23:26:12 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46456 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfEJD0M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 23:26:12 -0400
Received: by mail-pf1-f196.google.com with SMTP id y11so2393637pfm.13
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 20:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tl7VjzHdgtJTQ15zG/VNPKyp4z4cERyhkkjo6X/eOYs=;
        b=sCzF6jmJ8Vi+ecAUksZR948sBlZlHTmqTK2syYl4+wPW+Q0RyRNSnMGpWZkqL2RtZS
         k5RFOeapXVURDI2KVPzOnX8V8xUg2tEuv8xgV0m1yhYvWnnQfUVSdAJUYenbfG0zlq8d
         hF8C9sv6ZdAsFPgX0aPrH469mbsPVXp0SFuhoYrMqNhvlbPRhpQDcEYljdL81c/t/a9E
         rXkFvrEahrrA3aVt84EVdxbLmyyKRJQT5u20W14KQHvKBmJff+p8HC47sV0hMmhBqq6u
         Mpgn5xH1dcSpq6GB4uU3M4+yNYl7vjN5f/VFSAOSg2dFI3mvXQTYQaeVME5hTnTBeJVc
         6DqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tl7VjzHdgtJTQ15zG/VNPKyp4z4cERyhkkjo6X/eOYs=;
        b=b34YMMHzWIfqpoPhjCK964SF3pOgr1kIXnL+BRZ2nQ/ue/F44j07plLYb27axPOUjM
         ZD6m9u5hC+2+Xc8mMZRjxOZSbv7eENKVLOE5moCVNS71D6U3sWLNjhQC/7UPvubbD5iJ
         aZqGGUiVWxulfBwpAu9mTdT8RW/rD9VI7cbAaDanMp7WPQbtDY9oA3xECwLTU/6B2kNb
         1UoE7+wMWr9ZouazFsLpS1V4V55YSN83x5+LnLKM9GuPKX4cdU06gjjAdUA8dwzKR1IA
         TTs+h9jEFJn41OLBv0m5/qdRlQ1Rq3MNG9ihM8xa/7ji0Xvm0iLzqYp3jjSpGiO4VkMO
         vDLw==
X-Gm-Message-State: APjAAAXilZS/hwzUVv3iR7Orh0tz+2M7nEAPV3KgoV6+t64CtSCm7Go9
        cqdbOq/DNwhbWsWYA1DRwt4=
X-Google-Smtp-Source: APXvYqzx6NoI1ZVWKBueAT9NzcVcWFE1CuKa1zz62WOp+tiwzPDeeRiW3nxP8rKWvchcLlNasTZUqQ==
X-Received: by 2002:a62:7793:: with SMTP id s141mr10742057pfc.21.1557458771341;
        Thu, 09 May 2019 20:26:11 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id z66sm5225592pfz.83.2019.05.09.20.26.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 20:26:09 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH v3 3/4] lib: Remove redundant page zeroing
Date:   Thu,  9 May 2019 13:05:57 -0700
Message-Id: <20190509200558.12347-4-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190509200558.12347-1-nadav.amit@gmail.com>
References: <20190509200558.12347-1-nadav.amit@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that alloc_page() zeros the page, remove the redundant page zeroing.

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/virtio-mmio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/virtio-mmio.c b/lib/virtio-mmio.c
index 57fe78e..e5e8f66 100644
--- a/lib/virtio-mmio.c
+++ b/lib/virtio-mmio.c
@@ -56,7 +56,6 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev,
 	vq = calloc(1, sizeof(*vq));
 	assert(VIRTIO_MMIO_QUEUE_SIZE_MIN <= 2*PAGE_SIZE);
 	queue = alloc_pages(1);
-	memset(queue, 0, 2*PAGE_SIZE);
 	assert(vq && queue);
 
 	writel(index, vm_dev->base + VIRTIO_MMIO_QUEUE_SEL);
-- 
2.17.1

