Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48CF1D54CE
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 17:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgEOPeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 11:34:00 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21189 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726239AbgEOPd7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 11:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589556838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=0q1Y8ePvKhM4R3+rVYPWm7Pu+FP0VGkrqM/os2Y0oAI=;
        b=b9EMjRgTzPUFgG1eoXpAe/aO+zKGyB3oPvR18cCaFgx9QNB4lCBCQf57zudQIn0tddzsXp
        dbO5892QRkwEqe2XIuc2wYbWlaApmNRyzyhFvHRY/LrVoiQetUB4tQXlVZHls86fKNkfl7
        6uF4hofZfqeYDS1euZ9jMymztp0kaOA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-6dK4yNHzNU2i7PFZi5h6Ew-1; Fri, 15 May 2020 11:33:56 -0400
X-MC-Unique: 6dK4yNHzNU2i7PFZi5h6Ew-1
Received: by mail-wm1-f69.google.com with SMTP id v23so1164276wmj.0
        for <kvm@vger.kernel.org>; Fri, 15 May 2020 08:33:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=0q1Y8ePvKhM4R3+rVYPWm7Pu+FP0VGkrqM/os2Y0oAI=;
        b=bq/MfASSzMKj3oFf67+WBc5vnHJJVvuSkfDHhJYvD5/MJcDWtLk/X6aJ21zDQGZhex
         zUxaqh96EHKYZJE29aqQUybXOCCkO0Bq0E8V6BB/WZHQdReb8Oy6Ua/nGBgu5yv1kVwr
         LycJWs/5jWeCRri5MP5xDAMrty2KuvmruU/ksiDT1Nq7P7QtYvupR1QYyM+kHALmCKLe
         SMGJd7ODVnvp9P1rrG7UKmrlaoSaL4u5sYDTSZdxlZ4idEfEOc/gvddM/sTWosS8sc3P
         5XzznBPRjLUOvEVLjXaXRZ6xWKnhzAZtHl+bw+7X44vUDmeaa9H7RmxXPtk1CI0saIIC
         y2xA==
X-Gm-Message-State: AOAM530uNVA/7wQhXyMH0LiMVWhEOj76j+VEUBNTRXhywd1/kjRG9MfE
        fBLxL4ITSxRrzLiNkFN4px8duHSisiBFSKFmNWqsf9lj0nrC3LdzkzWkg6ut2RG8LvXk4ItjXb+
        W1iJhcVaJuS3T
X-Received: by 2002:a1c:2087:: with SMTP id g129mr4503995wmg.126.1589556832765;
        Fri, 15 May 2020 08:33:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwz/KlciQFx1rHU1J+UL9igbunQtTe0UZESWhBj7gKnvBR65GITM/RzOMxXTQwccrKqsnawtA==
X-Received: by 2002:a1c:2087:: with SMTP id g129mr4503978wmg.126.1589556832581;
        Fri, 15 May 2020 08:33:52 -0700 (PDT)
Received: from redhat.com (bzq-79-179-68-225.red.bezeqint.net. [79.179.68.225])
        by smtp.gmail.com with ESMTPSA id c16sm4048373wrv.62.2020.05.15.08.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 08:33:51 -0700 (PDT)
Date:   Fri, 15 May 2020 11:33:50 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kbuild test robot <lkp@intel.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH] vhost: missing __user tags
Message-ID: <20200515153347.1092235-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

sparse warns about converting void * to void __user *. This is not new
but only got noticed now that vhost is built on more systems.
This is just a question of __user tags missing in a couple of places,
so fix it up.

Fixes: f88949138058 ("vhost: introduce O(1) vq metadata cache")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index d450e16c5c25..21a59b598ed8 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -730,7 +730,7 @@ static inline void __user *vhost_vq_meta_fetch(struct vhost_virtqueue *vq,
 	if (!map)
 		return NULL;
 
-	return (void *)(uintptr_t)(map->addr + addr - map->start);
+	return (void __user *)(uintptr_t)(map->addr + addr - map->start);
 }
 
 /* Can we switch to this memory table? */
@@ -869,7 +869,7 @@ static void __user *__vhost_get_user_slow(struct vhost_virtqueue *vq,
  * not happen in this case.
  */
 static inline void __user *__vhost_get_user(struct vhost_virtqueue *vq,
-					    void *addr, unsigned int size,
+					    void __user *addr, unsigned int size,
 					    int type)
 {
 	void __user *uaddr = vhost_vq_meta_fetch(vq,
-- 
MST

