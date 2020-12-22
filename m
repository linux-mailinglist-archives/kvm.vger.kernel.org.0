Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6AB2E0C3A
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 15:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgLVOzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 09:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbgLVOzA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 09:55:00 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D02C0611C5
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 06:54:35 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id z12so1422826pjn.1
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 06:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RADXly6HG+PYDpCqLXRZWwmhkpi+THQigpZFKjj79E0=;
        b=owxkRQAn8mi1u29AGfOZBHVkYG9INTpWMi5SOSOPS1fT0xL7YABZ+pMsbu77MelNiV
         cz0vixAFJ99sCW6JKgiaxHZA2cNY/HTaM57igo63TGRJKdt+BHU+/2asqycutk8mm8b0
         lIhdZCvqQFuRRM2rNq8a2/6rb75wbQ/3i5/RGb3awDl8Tc0KVl6PKUk3kdUcLlOe5e8M
         QtxtTkBREHqhY23FIjRWJ7V+R4+DdxA2wyrgmjildb72k1ujFqvDMQCtGl9ERlqQ0zG7
         HRKB3Qa1MxltAVTZvwH6Vj1aygNmWJw2lrFJAEnE3fFc8uUeRxwtlIhZYfX68XxNQFWk
         pzDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RADXly6HG+PYDpCqLXRZWwmhkpi+THQigpZFKjj79E0=;
        b=GNywxykp6hIHDHnkqNdurkLisfYUTUmxhml32uNH5llWdYRNlLQQH6+HfKGnKufzIj
         GrPgQCzS+KmLObEoNh6Mat2Je66pVjnBnRH1V5cpNOyQLPUkprk/jk1JHV10oqIMKVUo
         YTpW7JmDmpq8Gbf+EAOcCtepSd8kmpDv7AJJM5JiMxkTY+VHkTDhYZWcxiG8fdrTvVql
         j2/jBXuYoJb5YW4iB7kTvmBKrQxBE2sfhKCTBvA3JkE9JAXYSfJV8e1n8qNaqTjKyew7
         7Ri8Gt7Tv+nXKGBm1xJ8qbGIYALVT9yE8MGGGiQfw4rchZNvTK+h6TL8EMK1Wp1UFqbJ
         OmGg==
X-Gm-Message-State: AOAM532mhmbtqGDbQ2p9ejb/xd1arAWdwfelEK4Wf8VojDau6u4+Ha4c
        pXezSpYtCMiOA6aa0SkybWic
X-Google-Smtp-Source: ABdhPJxkRSBlcvxchIiS81ezO9xwR9ohQaUb5Kh8NPRBIkVLcDIYT224UEl4mr18HZP/oEI6uKUnAw==
X-Received: by 2002:a17:902:8343:b029:dc:231e:110a with SMTP id z3-20020a1709028343b02900dc231e110amr21401236pln.67.1608648875434;
        Tue, 22 Dec 2020 06:54:35 -0800 (PST)
Received: from localhost ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id t9sm14483845pgh.41.2020.12.22.06.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 06:54:34 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, akpm@linux-foundation.org,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC v2 13/13] vduse: Introduce a workqueue for irq injection
Date:   Tue, 22 Dec 2020 22:52:21 +0800
Message-Id: <20201222145221.711-14-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222145221.711-1-xieyongji@bytedance.com>
References: <20201222145221.711-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch introduces a dedicated workqueue for irq injection
so that we are able to do some performance tuning for it.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vdpa/vdpa_user/eventfd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_user/eventfd.c b/drivers/vdpa/vdpa_user/eventfd.c
index dbffddb08908..caf7d8d68ac0 100644
--- a/drivers/vdpa/vdpa_user/eventfd.c
+++ b/drivers/vdpa/vdpa_user/eventfd.c
@@ -18,6 +18,7 @@
 #include "eventfd.h"
 
 static struct workqueue_struct *vduse_irqfd_cleanup_wq;
+static struct workqueue_struct *vduse_irq_wq;
 
 static void vduse_virqfd_shutdown(struct work_struct *work)
 {
@@ -57,7 +58,7 @@ static int vduse_virqfd_wakeup(wait_queue_entry_t *wait, unsigned int mode,
 	__poll_t flags = key_to_poll(key);
 
 	if (flags & EPOLLIN)
-		schedule_work(&virqfd->inject);
+		queue_work(vduse_irq_wq, &virqfd->inject);
 
 	if (flags & EPOLLHUP) {
 		spin_lock(&vq->irq_lock);
@@ -165,11 +166,18 @@ int vduse_virqfd_init(void)
 	if (!vduse_irqfd_cleanup_wq)
 		return -ENOMEM;
 
+	vduse_irq_wq = alloc_workqueue("vduse-irq", WQ_SYSFS | WQ_UNBOUND, 0);
+	if (!vduse_irq_wq) {
+		destroy_workqueue(vduse_irqfd_cleanup_wq);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
 void vduse_virqfd_exit(void)
 {
+	destroy_workqueue(vduse_irq_wq);
 	destroy_workqueue(vduse_irqfd_cleanup_wq);
 }
 
-- 
2.11.0

